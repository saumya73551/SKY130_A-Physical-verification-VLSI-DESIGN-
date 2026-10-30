# SKY130_A-Physical-verification-VLSI-DESIGN-
Implementation and documentation of a SKY130A-based VLSI physical design and verification flow using open-source EDA tools, including Magic, Netgen, and Open_PDKs. Covers PDK setup, layout design, DRC, LVS, and physical verification.
# Sky130 Open-Source VLSI Tool Setup

This repository documents my hands-on setup and initial launch checks for an open-source VLSI design environment on **Ubuntu 24.04.5 LTS** running in **Oracle VirtualBox**. The tools explored are **Magic**, **Netgen**, **ngspice**, and **Xschem**, along with Git.

The goal is to prepare an environment for learning schematic capture, circuit simulation, layout design, and physical-verification concepts using the SkyWater SKY130 process.

## Environment

- **Operating system:** Ubuntu 24.04.5 LTS (Noble)
- **Virtualization:** Oracle VirtualBox
- **Git:** 2.43.0
- **EDA tools checked:** Magic, Netgen, ngspice, Xschem
- **PDK focus:** SkyWater SKY130A

## Progress summary

- Confirmed the Ubuntu environment and checked the Git installation.
- Opened Magic, Netgen, ngspice, and Xschem.
- Captured screenshots of the tool launch checks.
- These screenshots show **initial application/command-line checks**. They do not, by themselves, prove that the SKY130A PDK is fully configured or that a complete schematic-to-layout flow has passed.

## Screenshots and notes

### 1. Ubuntu environment
![Ubuntu environment](screenshots/ubuntu-environment.png)

Ubuntu 24.04.5 LTS is running inside VirtualBox. The terminal output also records the guest kernel and available memory at the time of checking.

### 2. Git installation check
![Git version check](screenshots/git-version-check.png)

Ran `git --version`; the terminal returned **git version 2.43.0**. Git is available for cloning and managing project repositories.

### 3. Magic installation / terminal check
![Magic installation terminal](screenshots/magic-install-terminal.png)

Terminal screenshot from the Magic setup process. It records the installation/setup activity before opening the graphical tool.

### 4. Magic layout tool
![Magic application](screenshots/magic-application.png)

Magic launches with its layout window and Tcl console. The screenshot shows the default `minimum` technology, so SKY130A technology configuration still needs to be selected/verified before doing SKY130 layout work.

### 5. Netgen launch check
![Netgen application](screenshots/netgen-application.png)

Netgen opens its Tcl console and reports its version. This is an initial launch check; an actual Layout-versus-Schematic (LVS) comparison still needs to be run on matching example netlists.

### 6. ngspice launch check
![ngspice application](screenshots/ngspice-application.png)

ngspice starts successfully and displays its interactive prompt. A circuit netlist and simulation command are needed to verify circuit simulation and plotting.

### 7. Xschem library/reference screen
![Xschem library reference](screenshots/xschem-library-reference.png)

Xschem displays a symbol/library reference screen containing analog and digital device examples. This confirms the schematic editor is open; the correct SKY130A library paths should be checked before using process-specific symbols.

### 8. Xschem launch check
![Xschem launch check](screenshots/xschem-launch-check.png)

Xschem opens a new schematic window. The canvas is currently blank, ready for a schematic to be created or an existing `.sch` file to be opened.

### 9. Screenshot overview
![Screenshot overview](screenshots/screenshot-overview.png)

A compact overview of the screenshots collected during the setup and verification process.

## Tools and their roles

| Tool | Main purpose |
|---|---|
| **Xschem** | Draw and edit circuit schematics and generate netlists. |
| **ngspice** | Simulate analog and mixed-signal circuits from SPICE netlists. |
| **Magic** | Create and inspect IC layouts and run design-rule checks (DRC) when the technology files are configured. |
| **Netgen** | Compare schematic and extracted-layout netlists for LVS. |
| **Git** | Clone repositories and track project changes. |

## Next steps

1. Confirm that the SKY130A PDK is installed and that the environment variables and technology files point to the correct location.
2. Configure Xschem with the SKY130A `xschemrc` and ngspice initialization file.
3. Configure Magic with the SKY130A technology file.
4. Create a simple inverter schematic in Xschem and generate its SPICE netlist.
5. Simulate the inverter using ngspice.
6. Create or import the corresponding layout in Magic, run DRC, extract a netlist, and compare it with the schematic netlist using Netgen.

## Learning focus

This setup is an initial step toward understanding the open-source custom-IC workflow: **schematic capture → SPICE simulation → layout → DRC → extraction → LVS**.

---
*Documentation and screenshots reflect the setup progress captured on 28 October 2026.*
