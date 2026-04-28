# Aircraft Engine Design — Low-Bypass Turbofan for an Eurofighter-class Fighter

A full preliminary design of a mixed-flow, two-shaft, afterburning turbofan for a supersonic air-superiority mission, from mission analysis to component off-design. University group project, Sapienza Università di Roma.

## Academic context

- **Course:** Aircraft Engines (*Motori Aeronautici*)
- **Professors:** Prof. Mauro Valorani, Prof. Riccardo Malpica
- **University:** Sapienza Università di Roma
- **Academic year:** 2024–2025
- **Group members:** Niccolò D'Ambrosio, Francesco Daniele, Matteo Grippo, Elisa Jacopucci

## Overview

The project designs a fighter-class turbofan engine starting from a 14-phase supersonic mission (takeoff → subsonic cruise climb → CAP loiter → supersonic penetration at M 1.6 → combat with 5g/4g turns → escape dash at M 1.4 → return). The reference aircraft/engine pair is an **Eurofighter Typhoon** fitted with an **EJ-200 Mk.200** class engine (MTOW 23 500 kg, Fₘₐₓ 88.96 kN with afterburner).

The pipeline is:
**Mission Analysis → Constraint Analysis (iterated 3×) → Thermodynamic Cycle → Cantera combustion tables → Multi-objective cycle optimization (pymoo/NSGA-II) → Component design (LPC, HPC, HPT, LPT) → Inlet + Nozzle design → Off-design maps.**

Tool stack: **Python** (pymoo, Cantera, NumPy/Matplotlib), **Wolfram Mathematica** (cycle modules, interpolating functions), JSON for design-point I/O.

## What the project covers

1. **Mission Analysis** — 14-phase flight profile with subsonic cruise, supercruise, combat and escape dash legs.
2. **Constraint Analysis** — thrust-loading vs. wing-loading diagrams, three design iterations, MTOW and weight-fraction estimation, throttle-ratio selection.
3. **Engine Cycle Analysis** — mixed-flow two-shaft turbofan with afterburner, three mixers (post-HPT, post-LPT, post-combustor), carpet plots across the mission envelope.
4. **Combustion via Cantera** — tabulated combustion results (temperature, pressure, fuel-to-air ratio) exported from Python to Mathematica as interpolating functions for `f` and `cₚ`.
5. **Multi-objective cycle optimization** — pymoo NSGA-II over Mach, altitude, BPR, βf, βc, OPR; objectives: maximise Iₐ, minimise TSFC, EINOₓ, EICO. Design-space plots, scatter matrices, parallel coordinates and bubble charts drive the design-point selection.
6. **Component design** — LPC, HPC, HPT, LPT sizing with velocity-triangle design in Python (the Python solver replaces Mathematica's `FindRoot`/`NSolve`/`Reduce` which failed to converge on the coupled system).
7. **Off-design maps** — LPC and HPC maps including first-stage choking massflow (139.14 kg/s for the LPC, 154.75 kg/s for the HPC).
8. **Inlet and nozzle** — design and off-design behaviour of both.

## How the optimization orchestrates Python + Mathematica + Cantera

> ⭐ The cross-language orchestration below was designed and implemented by **Niccolò D'Ambrosio** as part of the end-to-end pipeline integration.

The optimization is not a pure-Python loop: each NSGA-II fitness evaluation spans **three processes in two languages**, communicating through JSON files keyed by UUID. This lets each process stay in the language that best fits its job — pymoo in Python, cycle equations in Mathematica, chemical equilibrium in Cantera — without brittle FFI glue.

### Offline preparation (run once)

```
combustion-cantera/calc_tabella_multiprocessing.py
        │
        ▼
Cantera grid sweep over (T, p, φ)  ──►  tabella_combustione.json
        (multiprocessing-parallel)        (3-D lookup table for f and cp_B)
```

### Online evaluation (thousands of times per generation)

```
      ┌────────────────────────────────────────────────────────────┐
      │  optimization/Opt_v4.py   ── pymoo NSGA-II driver          │
      │  StarmapParallelization over N CPU cores                   │
      └──┬─────────────────────────────────────────────────────────┘
         │   candidate x = [M, h, BPR, β_c]   → write input_ID_<uuid>.json
         │                                      (in inputDesign/)
         ▼
      subprocess.run(wolframscript -file TF.wls …)
         │
         ▼
      ┌────────────────────────────────────────────────────────────┐
      │  optimization/TF.wls + ModulesForAircraftEngine.wl         │
      │  Turbofan cycle:                                           │
      │    f, cp_B  ← Interpolation[tabella_combustione.json]      │
      │               (no Cantera call here — O(1) lookup)         │
      │                                                            │
      │  For NOx/CO emissions only:                                │
      │     Run[python equilibrium_calculation_v2.py …]            │
      │         │                                                  │
      │         ▼                                                  │
      │     ┌────────────────────────────────────────────────┐     │
      │     │ combustion-cantera/equilibrium_calculation_v2  │     │
      │     │ Cantera.Solution('kerosene.yaml').equilibrate  │     │
      │     │ → write equilibrium_ID_<uuid>.json             │     │
      │     └────────────────────────────────────────────────┘     │
      │                                                            │
      │  Read equilibrium JSON → compute EINOX, EICO               │
      │  Write output_ID_<uuid>.json  (in outputDesign/)           │
      └──┬─────────────────────────────────────────────────────────┘
         │
         ▼
      Opt_v4.py reads output_ID_<uuid>.json → returns
         [−Ia, TSFC, EINOX, EICO] to pymoo → next generation
```

### Design choices that make it work

- **JSON as the wire format.** Simple, language-agnostic, easy to debug (you can `cat inputDesign/input_ID_<uuid>.json` mid-run).
- **UUID per evaluation.** Every candidate gets a unique ID, so concurrent workers never collide on file I/O — cheap and robust parallelism.
- **Two-speed combustion.** Thermodynamic properties (`f`, `cp_B`) come from the pre-computed Cantera table via Mathematica's `Interpolation` — O(1) lookup inside the hot loop. The slower full-equilibrium Cantera call happens only once per candidate, and only for emissions (which are the objectives, so you can't interpolate them).
- **Self-contained subprocesses.** `TF.wls` self-locates via `$InputFileName`; `equilibrium_calculation_v2.py` resolves `kerosene.yaml` relative to its own `__file__`. The whole pipeline runs regardless of the caller's cwd.
- **Fail-soft.** If any stage raises (bad cycle parameters, Cantera convergence failure, missing output), the Python side returns a heavy penalty `[1e6, 1e6, 1e6, 1e6]` so NSGA-II doesn't crash — the individual is simply dominated and pruned.
- **Configurable executable.** `WOLFRAMSCRIPT` environment variable overrides the default `wolframscript` on `$PATH`, needed on Windows where the exe lives under `C:\Program Files\Wolfram Research\…`.

## Key results — chosen design point

Closest Pareto-front point to the supercruise reference condition (M 1.5, 12 192 m):

| M | Altitude | BPR | βf | βc | OPR | Iₐ | TSFC | EINOₓ | EICO |
|---|---|---|---|---|---|---|---|---|---|
| 1.49 | 12 373 m | 0.10 | 6.33 | 3.48 | 22.03 | **936.35 N·s/kg** | **0.106 (kg·s)/N** | 34.97 g/kg | 0.386 g/kg |

## Repository layout

```
.
├── README.md                              ← this file
├── requirements.txt                       ← Python dependencies
├── report/                                ← final 49-page PDF report (Italian)
├── mission-analysis/                      ← §1 mission analysis (Excel profiles, images)
├── constraint-analysis/                   ← §2 constraint analysis iterations
├── combustion-cantera/                    ← §4 combustion tables (Python + YAML)
├── optimization/                          ← §3, §5, §6 cycle + NSGA-II + component sizing
│   ├── ModulesForAircraftEngine.wl        ← Mathematica cycle modules
│   ├── Opt_v4.py                          ← latest pymoo optimization driver
│   ├── TF.wls                             ← turbofan script
│   └── design-point-data/                 ← chosen design-point artifacts
└── off-design/                            ← §7, §8 component off-design + inlet/nozzle
    ├── lpc/  hpc/  inlet/  nozzle/
    └── matching/                          ← matching solver (Python + Mathematica)
```

> The `inputDesign/` and `outputDesign/` subfolders are generated artefacts from optimization runs and are git-ignored.

## How to run

### Python environment

```bash
python -m venv .venv
.venv\Scripts\activate                      # Windows
# source .venv/bin/activate                 # Linux/macOS
pip install -r requirements.txt
```

### Reproduce the optimization (§4–§5)

```bash
cd combustion-cantera
python calc_tabella_multiprocessing.py      # generate tabella_combustione.json
cd ../optimization
python Opt_v4.py                            # run NSGA-II over the cycle
```

### Reproduce the off-design maps (§7)

```bash
cd off-design/matching
wolframscript -file <matching_script>.wls   # Mathematica-driven
```

### Read the full report

Open [report/PROGETTO MOTORI AERONAUTICI_D'AMBROSIO_DANIELE_GRIPPO_JACOPUCCI.pdf](report/PROGETTO%20MOTORI%20AERONAUTICI_D'AMBROSIO_DANIELE_GRIPPO_JACOPUCCI.pdf) — 49 pages, Italian.

## Team contributions

| # | Section | Lead | Contributors |
|---|---------|------|--------------|
| 1 | Mission Analysis | **Niccolò D'Ambrosio** | all members |
| 2 | Constraint Analysis + design iterations | **Niccolò D'Ambrosio** | all members |
| 3 | Engine Cycle Analysis (turbofan + afterburner) | Francesco Daniele | **Niccolò D'Ambrosio** |
| 4 | Cantera combustion tables | Matteo Grippo | — |
| 5 | Multi-objective optimization (pymoo / NSGA-II) | Elisa Jacopucci | **Niccolò D'Ambrosio** |
| 6 | Component design (LPC, HPC, HPT, LPT) | Matteo Grippo *(initial)* / **Niccolò D'Ambrosio** *(revision)* | — |
| 7 | Off-design maps (LPC, HPC) | **Niccolò D'Ambrosio** | — |
| 8 | Inlet + Nozzle (design and off-design) | **Niccolò D'Ambrosio** | — |
| ★ | **Cross-language simulation pipeline** — end-to-end integration, Python ↔ Mathematica ↔ Cantera orchestration, JSON/UUID handshake, parallelization (see [§ *How the optimization orchestrates…*](#how-the-optimization-orchestrates-python--mathematica--cantera)) | **Niccolò D'Ambrosio** | — |

## References

- Mattingly, J. D., Heiser, W. H., Pratt, D. T. — *Aircraft Engine Design*, 2nd ed., AIAA Education Series.
- Kurzke, J., Halliwell, I. — *Propulsion and Power: An Exploration of Gas Turbine Performance Modeling*, Springer.
- [pymoo](https://pymoo.org/) — multi-objective optimization in Python (NSGA-II).
- [Cantera](https://cantera.org/) — chemical kinetics and combustion equilibrium.
- Eurofighter Typhoon / EJ-200 Mk.200 — reference aircraft and engine.

## License

Academic coursework. Third-party dependencies retain their respective upstream licenses.
