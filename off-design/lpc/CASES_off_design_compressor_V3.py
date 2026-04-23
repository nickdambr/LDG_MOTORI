import numpy as np
import matplotlib.pyplot as plt
from tabulate import tabulate

# Import the main simulation function from your script
# Assuming the script is in a subdirectory named 'LPC'
from CHECK_off_design_compressor_V3 import multistageCompressorState

def run_and_plot_off_design_scenarios():
    """
    Runs several off-design cases for the multistage compressor and plots
    the stage-by-stage aerodynamic properties.
    """
    # --- 1. Define Base Parameters (from your script's main function) ---
    T01 = 312.951
    p01 = 58917.7
    phim = [1.2723] * 8
    gamma = 1.4
    Rair = 287.0
    alpha1m = [0.0] * 8
    beta2m = [0.0] * 8
    CompAreas = [
        1.03714, 0.828889, 0.676808, 0.562502, 0.474492, 0.405349, 0.350079, 0.305236
    ]
    CompMeanDiameter = [0.504818] * 8
    etaStage = 0.89

    # --- 2. Define Operating Cases ---
    design_massflow = 124.4431866
    design_Ncomp = 6723.98

    cases = [
        {"name": "Design", "massflow": design_massflow, "Ncomp": design_Ncomp},
        {"name": "High Mass Flow (+5%)", "massflow": design_massflow * 1.05, "Ncomp": design_Ncomp},
        {"name": "High Mass Flow (+15%)", "massflow": design_massflow * 1.10, "Ncomp": design_Ncomp},
        {"name": "High Shaft Speed (+10%)", "massflow": design_massflow, "Ncomp": design_Ncomp * 1.10},
        {"name": "Low Shaft Speed (-10%)", "massflow": design_massflow, "Ncomp": design_Ncomp * 0.90},
        {"name": "Low Shaft Speed (-20%)", "massflow": design_massflow, "Ncomp": design_Ncomp * 0.80}
    ]

    # --- 3. Run Simulations and Collect Data ---
    all_case_results = {}
    summary_data = []

    print("--- Running Compressor Off-Design Simulations ---")
    for case in cases:
        print(f"\nCalculating case: {case['name']}...")
        
        results = multistageCompressorState(
            T01, p01, case["massflow"], case["Ncomp"], phim, Rair, gamma,
            alpha1m, beta2m, CompAreas, CompMeanDiameter, etaStage
        )
        
        betaCmap, etaCmap, _, _, _, _, _, perfo, chokepoint = results
        
        # Store stage-by-stage data for plotting
        all_case_results[case['name']] = perfo
        
        # Store summary data
        total_pr = betaCmap[1]
        total_eta = etaCmap[1]
        last_stage = len(perfo)
        status = "Choked" if chokepoint != [0, 0] and last_stage < len(CompAreas) else "OK"
        
        summary_data.append([
            case['name'], f"{case['massflow']:.2f}", f"{case['Ncomp']:.2f}",
            f"{total_pr:.3f}", f"{total_eta:.3f}", last_stage, status
        ])

    # --- 4. Print Summary Table ---
    print("\n\n--- Overall Performance Summary ---")
    headers = ["Case", "Mass Flow [kg/s]", "Shaft Speed [RPM]", "Total PR", "Total η", "Stages Run", "Status"]
    print(tabulate(summary_data, headers=headers, tablefmt="grid"))

    # --- 5. Plot Stage-by-Stage Results ---
    fig, axes = plt.subplots(3, 1, figsize=(12, 16), sharex=True)
    fig.suptitle('Compressor Stage-by-Stage Performance Comparison', fontsize=16)
    ax1, ax2, ax3 = axes

    for case_name, perfo_data in all_case_results.items():
        if not perfo_data:
            print(f"Warning: No performance data for case '{case_name}', likely immediate choke.")
            continue

        # Extract data for plotting
        stages = np.arange(1, len(perfo_data) + 1)
        axial_vel = [p[4] for p in perfo_data]
        static_temp = [p[5] for p in perfo_data]
        mach_num = [p[6] for p in perfo_data]
        speed_of_sound = np.sqrt(gamma * Rair * np.array(static_temp))

        # Plot on each subplot
        ax1.plot(stages, axial_vel, 'o-', label=case_name)
        ax2.plot(stages, speed_of_sound, 'o-', label=case_name)
        ax3.plot(stages, mach_num, 'o-', label=case_name)

    # Configure plots
    ax1.set_ylabel('Axial Velocity (Ca) [m/s]', fontsize=12)
    #ax1.set_title('Axial Velocity Profile', fontsize=14)
    ax1.grid(True, linestyle='--')
    ax1.legend()

    ax2.set_ylabel('Speed of Sound (a) [m/s]', fontsize=12)
    #ax2.set_title('Speed of Sound Profile', fontsize=14)
    ax2.grid(True, linestyle='--')
    ax2.legend()

    ax3.set_ylabel('Mach Number (M)', fontsize=12)
    #ax3.set_title('Mach Number Profile', fontsize=14)
    ax3.set_xlabel('Stage Number', fontsize=12)
    ax3.grid(True, linestyle='--')
    ax3.legend()
    ax3.set_xticks(np.arange(1, len(CompAreas) + 1)) # Ensure integer ticks for stages

    plt.tight_layout(rect=(0, 0, 1, 0.96))
    plt.show()

if __name__ == "__main__":
    run_and_plot_off_design_scenarios()
