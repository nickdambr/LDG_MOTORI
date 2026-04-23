import numpy as np
from scipy.optimize import root_scalar
from tabulate import tabulate 
from scipy.interpolate import griddata
from scipy.interpolate import interp1d
import matplotlib.pyplot as plt
import json

def TF(T01, gamma, Mach):
    """Total-to-static temperature relation."""
    return T01 / (1 + (gamma - 1) / 2 * Mach**2)

def is_choked(M):
    return M >= 1.0

def StageReducedProperties(massflow, Ncomp, diameter, area, alpha1, p01, T01, Rgas, gamma):
    # Calculate reduced speed and mass flow
    nred = ((Ncomp / 60) * diameter) / np.sqrt(Rgas * T01)
    mred = (massflow * np.sqrt(Rgas * T01)) / (area * p01)
    print(f"nred : {nred}")
    print(f"mred : {mred}")
    print(f"massflow : {massflow}")
    print(f"diameter : {diameter}")
    print(f"Rgas : {Rgas}")
    print(f"T01 : {T01}")
    print(f"area : {area}")
    print(f"p01 : {p01}")

    # Solve for Mach number
    def mach_func(Machd):
        return mred - (
            np.sqrt(gamma) * Machd * np.cos(alpha1) *
            (1 + (gamma - 1) / 2 * Machd**2) ** (0.5 - gamma / (gamma - 1))
        )

    mach_solution = root_scalar(mach_func, method='newton', x0=0.5)
    if not mach_solution.converged:
        print("Mach root finding did not converge.")
        return True, [0, 0, 0, 0, 0, 0]

    Mach = mach_solution.root
    print(f"mach_solutionM : {Mach}")
    print(f"mach : {Mach}")

    choked = False
    if Mach > 0.99999:
        choked = True
        return choked, [0, 0, 0, 0, 0, 0]

    T = TF(T01, gamma, Mach)
    print("Debug phi ----------------------")
    print(f"T : {T}")
    Ca1 = Mach * np.cos(alpha1) * np.sqrt(gamma * Rgas * T)
    print(f"Ca1 : {Ca1}")

    U = np.pi * (Ncomp / 60) * diameter
    print(f"U : {U}")
    phi = Ca1 / U

    return choked, [Ca1, T, Mach, phi, nred, mred]

def Phi(mred, nred, Mach, gamma):
    delta = (gamma - 1.0) / 2.0
    phi = (1.0 / np.pi) * (mred / nred) * (1.0 + delta * Mach**2) ** (1.0 / (gamma - 1.0))
    return phi

def shockLosses(phi, phid, posIncidence, negIncidence):
    if phi < phid:
        return negIncidence * (phi - phid) ** 2
    else:
        return posIncidence * (phi - phid) ** 2

def PsiIdeal(phi, alpha1, beta2):
    k = np.tan(alpha1) + np.tan(beta2)
    psi = 1.0 - k * phi
    return psi

def Psi(phi, phid, alpha1, beta2, etaStage):
    k = np.tan(alpha1) + np.tan(beta2)
    if k == 0:
        k = 1e-16
    viscLossCoeff = (PsiIdeal(phid, alpha1, beta2) / phid**2) * (1.0 - etaStage)
    # Calculate negIncidence
    psi0 = 0.1
    phi0 = 0.0
    negIncidence = (1.0 - k * phi0 - psi0 - viscLossCoeff * (phi0**2)) / (phi0 - 1.0 * phid) ** 2
    # Calculate posIncidence
    psi0 = 0.0
    phi0 = 0.8 / k
    posIncidence = (1.0 - k * phi0 - psi0 - viscLossCoeff * (phi0**2)) / (phi0 - 1.0 * phid) ** 2
    psi = (1.0 - k * phi) - shockLosses(phi, phid, posIncidence, negIncidence) - viscLossCoeff * phi**2
    return psi

def EfficiencyComp(phi, phid, alpha1, beta2, etaStage):
    psi_val = Psi(phi, phid, alpha1, beta2, etaStage)
    psi_ideal = PsiIdeal(phi, alpha1, beta2)
    if psi_val > 0:
        return abs(psi_val / psi_ideal)
    else:
        return 0.0

def PRatioComp(mred, nred, Mach, phid, alpha1, beta2, gamma, etaStage):
    phi = Phi(mred, nred, Mach, gamma)
    print("phi :", phi)
    print("input psi -> {phi,phid,alpha1,beta2,etaStage}:", (phi, phid, alpha1, beta2, etaStage))
    psi = Psi(phi, phid, alpha1, beta2, etaStage)
    print("psi :", psi)
    PRatio = (1.0 + np.pi**2 * ((gamma - 1.0) / gamma) * nred**2 * psi) ** (gamma / (gamma - 1.0))
    return PRatio

def etaTotF(T01, T0nisen, T0n):
    if T0n - T01 != 0:
        return (T0nisen - T01) / (T0n - T01)
    else:
        return 0.0

def multistageCompressorState(
    T01, p01, mflow, Ncomp, phid, R, gamma_c, alpha1, beta2, Area, d, etaStage
):
    delta = (gamma_c - 1.0) / 2.0

    T0n = T01
    p0n = p01

    mredtot = mflow * np.sqrt(R * T01) / (p01 * Area[0])
    nredtot = (Ncomp / 60 * d[0]) / np.sqrt(R * T01)

    Z = len(d)
    chokepoint = [0, 0]
    perfo = []
    lastStage = 0

    for i in range(Z):
        lastStage = i + 1  # Python is 0-based

        choked, stage_props = StageReducedProperties(
            mflow, Ncomp, d[i], Area[i], alpha1[i], p0n, T0n, R, gamma_c
        )
        Can, Tn, Mn, phin, nredn, mredn = stage_props
        print(f"{[Can, Tn, Mn, phin, nredn, mredn]=}")

        if choked:
            chokepoint = [mredtot, p0n / p01]
            break

        print("debug input betacn :", [mredn, nredn, Mn, phid[i], alpha1[i], beta2[i], gamma_c, etaStage])
        betacn = PRatioComp(mredn, nredn, Mn, phid[i], alpha1[i], beta2[i], gamma_c, etaStage)
        print("betacn:", betacn)
        turbine = False

        if betacn < 1.0:
            turbine = True
            break

        phin = Phi(mredn, nredn, Mn, gamma_c)
        print("phin (recalculated):", phin)
        eff = EfficiencyComp(phin, phid[i], alpha1[i], beta2[i], etaStage)
        if eff == 0:
            delT0n = 0
        else:
            delT0n = (betacn ** ((gamma_c - 1) / gamma_c) - 1) / eff
        print("delT0n with Efficiency:", delT0n)
        print("delT0n without EfficiencyComp:", betacn ** ((gamma_c - 1) / gamma_c) - 1)
        T0n = T0n * (1.0 + delT0n)
        print("T0n:", T0n)
        p0n = p0n * betacn

        perfo.append([betacn, delT0n, T0n, p0n, Can, Tn, Mn, phin, nredn, mredn])

    betaCtot = p0n / p01
    delT0tot = (T0n - T01) / T01
    T0nisen = T01 * betaCtot ** ((gamma_c - 1) / gamma_c)
    etaTot = etaTotF(T01, T0nisen, T0n)

    betaCmap = [[mredtot, nredtot], betaCtot]
    etaCmap1 = [[mredtot, nredtot], etaTot]
    etaCmap = [mredtot, betaCtot, etaTot]
    nredCmap = [mredtot, betaCtot, nredtot]
    delT0map = [mredtot, betaCtot, delT0tot]
    Machmap = [mredtot, betaCtot, Mn]
    lastStagemap = [mredtot, betaCtot, lastStage]

    return [
        betaCmap, etaCmap, nredCmap, delT0map, Machmap, lastStagemap,
        etaCmap1, perfo, chokepoint
    ]

def find_max_massflow_first_stage_choke(
    massflowOnD, NcompOnD, meanDiameter, Area, alpha1m, p01, T01, Rgas, gamma
):
    """
    Determines the maximum massflow that causes first stage choking.
    Returns mflowmax.
    """
    mflowmax = None
    for i in np.arange(0, 100.1, 0.1):
        Ngiri = NcompOnD * 2
        mssflow = massflowOnD + i
        # Suppress output from StageReducedProperties if needed
        choked, _ = StageReducedProperties(
            mssflow, Ngiri, meanDiameter, Area, alpha1m, p01, T01, Rgas, gamma
        )
        if choked:
            mflowmax = mssflow - 0.5
            break
    if mflowmax is None:
        mflowmax = mssflow  # If no choking found in the range
    # ... inside your function after determining mflowmax ...
    result = {"First stage choking massflow": mflowmax}
    with open("first_stage_choke_massflow.json", "w") as f:
        json.dump(result, f, indent=4)
    return mflowmax

def off_design_compressor_map(
    T01,p01,massflow_grid, Nshaft_grid,
    alpha1, beta2, Area, Dmean, phid, etaStage,
    gamma, R, mred_des, Pi_des,
    plot_resolution 
    ):
    """
    Computes and plots the off-design compressor map.
    """
    results = []
    choked_points = []

    # Loop over all operating points
    for N in Nshaft_grid:
        for m in massflow_grid:
            # Call your multistageCompressorState for each point
            res = multistageCompressorState(
                T01=T01,  # Set inlet T01 for this point
                p01=p01,  # Set inlet p01 for this point
                mflow=m,
                Ncomp=N,
                phid=phid,
                R=R,
                gamma_c=gamma,
                alpha1=alpha1,
                beta2=beta2,
                Area=Area,
                d=Dmean,
                etaStage=etaStage
            )
            # Unpack results
            betaCmap, etaCmap, nredCmap, delT0map, Machmap, lastStagemap, etaCmap1, perfo, chokepoint = res

            # Store main map data
            mred = nredCmap[0]
            nred = nredCmap[2]
            pi_c = betaCmap[1]
            results.append([mred, nred, pi_c])

            # Store choked points if any
            if chokepoint != [0, 0]:
                choked_points.append([mred, nred, pi_c])

    # Convert to arrays for interpolation
    results = np.array(results)
    mred_vals, nred_vals, pi_c_vals = results[:,0], results[:,1], results[:,2]

    # Interpolate on a regular grid
    mred_grid = np.linspace(mred_vals.min(), mred_vals.max(), plot_resolution[0])
    nred_grid = np.linspace(nred_vals.min(), nred_vals.max(), plot_resolution[1])
    M, N = np.meshgrid(mred_grid, nred_grid)
    Pi_grid = griddata((mred_vals, nred_vals), pi_c_vals, (M, N), method='cubic')
    np.savez('compressor_map_grid.npz', Pi_grid=Pi_grid, mred_grid=mred_grid, nred_grid=nred_grid, choked_points=choked_points)

    # For each N_red (row), find the m_red (column) where Pi_c is maximum
    max_indices = np.nanargmax(Pi_grid, axis=1)
    mred_boundary = mred_grid[max_indices]
    pi_max_boundary = Pi_grid[np.arange(len(nred_grid)), max_indices]

    # Interpolate the stability boundary as a function of mred
    boundary_interp = interp1d(mred_boundary, pi_max_boundary, kind='linear', bounds_error=False, fill_value=np.nan)

    # Evaluate the boundary at all mred_grid points
    pi_max_interp = boundary_interp(mred_grid)  # shape: (len(mred_grid),)

    # Broadcast and mask: for each column (mred), mask Pi_grid values above the interpolated boundary
    mask = Pi_grid > pi_max_interp[None, :]  # shape: (len(nred_grid), len(mred_grid))
    Pi_grid_masked = Pi_grid.copy()
    Pi_grid_masked[mask] = np.nan


    print("Shape of pi_max_boundary:", pi_max_boundary.shape)
    print("Shape of Pi_grid:", Pi_grid.shape)
    print("Shape of Pi_grid_masked:", Pi_grid_masked.shape)

    


    # Plot the map
    plt.figure(figsize=(8,6))
    cp = plt.contourf(M, Pi_grid_masked, N, levels=256, cmap='coolwarm')
    # Add contour lines of N
    contour_N = plt.contour(M, Pi_grid_masked, N,levels=16, colors='black', linewidths=1.5, linestyles='dotted')
    plt.clabel(contour_N, fmt="N=%.2f", colors='black', fontsize=12)
    plt.colorbar(cp, label='$N_{red}$')
    plt.plot(mred_boundary, pi_max_boundary, 'r--', label='Stability Boundary', linewidth=1.5)
    plt.scatter(mred_des, Pi_des, color='black', marker='o', s=80, label='Design Point')
    # Plot choked points
    if choked_points:
        choked_points = np.array(choked_points)
        plt.scatter(
        choked_points[:,0],  # mred
        choked_points[:,2],  # pi_c
        c='orange', marker='x', label='Choked Points'
    )
    plt.xlabel('$\dot{m}_{red}$')
    plt.ylabel('$\Pi_c$')
    plt.title('HPC Map')
    plt.legend()
    plt.xlim(0.05, np.nanmax(mred_grid) * 1.1)  # Add some padding to the x-axis
    plt.ylim(0, np.nanmax(Pi_grid_masked) * 1.1)  # Add some padding to the y-axis
    plt.show()

    # Optionally: Save results to file
   #data = {'mred': mred_vals.tolist(), 'nred': nred_vals.tolist(), 'pi_c': pi_c_vals.tolist()}
   #with open('compressor_map_data.json', 'w') as f:
     #json.dump(data, f)

    return results, choked_points, Pi_grid, Pi_grid_masked



# Import all your functions here or define them in this file:
# from stage_flow import StageReducedProperties, Phi, PRatioComp, EfficiencyComp, etaTotF, multistageCompressorState

def main():
    massflow = 124.44318661191535
    Ncomp = 6723.98  # RPM
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
    etaStage = 0.89  # Replace with your actual value for ηpf

    # Call the principal function
    results = multistageCompressorState(
        T01, p01, massflow, Ncomp, phim, Rair, gamma, alpha1m, beta2m, CompAreas, CompMeanDiameter, etaStage
    )

    (
        betaCmap, etaCmap, nredCmap, delT0map, Machmap, lastStagemap,
        etaCmap1, perfo, chokepoint
    ) = results

    print("betaCmap:", betaCmap)
    print("etaCmap:", etaCmap)
    print("nredCmap:", nredCmap)
    print("delT0map:", delT0map)
    print("Machmap:", Machmap)
    print("lastStagemap:", lastStagemap)
    print("etaCmap1:", etaCmap1)
    print("perfo (stage-by-stage):")
    for stage_perf in perfo:
        print(stage_perf)
    print("chokepoint:", chokepoint)

    print("\nStage-by-stage performance table:")
    headers = ["betacn", "delT0n", "T0n", "p0n", "Can", "Tn", "Mn", "phin", "nredn", "mredn"]
    print(tabulate(perfo, headers=headers, floatfmt=".6g"))

    betacn_product = np.prod([stage[0] for stage in perfo])
    print(f"\nProduct of all betacn: {betacn_product}")


    
    

    
    



if __name__ == "__main__":
    main()