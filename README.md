
# SKY130A Physical Verification – VLSI Design

Implementation and documentation of a SKY130A-based VLSI physical design and verification flow using open-source EDA tools, including Magic, Netgen, ngspice, Xschem, and Open_PDKs.

The project covers PDK configuration, CMOS inverter schematic design, circuit simulation, physical layout generation, Design Rule Checking (DRC), layout extraction, and Layout-versus-Schematic (LVS) verification.

# Sky130 Open-Source VLSI Tool Setup

This repository documents my hands-on setup and implementation of an open-source VLSI design environment on **Ubuntu 24.04.5 LTS** running in **Oracle VirtualBox**.

The tools used are **Magic, Netgen, ngspice, Xschem**, and Git, with the SkyWater SKY130A Process Design Kit.

The objective is to understand the complete custom IC design workflow, from schematic capture and circuit simulation to physical layout and verification.

---

## Open-Source PDK Architecture

The following diagram illustrates the open-source PDK ecosystem and the role of the `open_pdks` repository in supporting different open-source EDA tools.

![Open-Source PDK Toolchain](toolchains.png)

**Reference:** Architecture diagram provided by the instructor.

---

## Environment

- **Operating System:** Ubuntu 24.04.5 LTS (Noble)
- **Virtualization:** Oracle VirtualBox
- **Git:** 2.43.0
- **Xschem:** V3.4.4
- **ngspice:** Version 42
- **Magic:** Version 8.3 Revision 411
- **EDA Tools:** Magic, Netgen, ngspice, Xschem
- **PDK:** SkyWater SKY130A
- **PDK Installation Path:** `/usr/local/share/pdk/sky130A`

## Progress Summary

- Installed and configured Ubuntu 24.04.5 LTS.
- Installed and checked open-source EDA tools.
- Configured the SKY130A PDK environment.
- Prepared Magic, Netgen, ngspice, and Xschem configuration files.
- Designed a CMOS inverter using Xschem.
- Generated a reusable inverter symbol.
- Created an inverter testbench.
- Simulated the inverter using ngspice.
- Implemented the CMOS inverter physical layout using Magic.
- Performed DRC and obtained zero reported errors.
- Extracted the layout and generated a SPICE netlist.
- Performed LVS verification using Netgen.

---

# 1. Open-Source EDA Tool Installation and Verification

## Screenshots and Documentation

### 1. Ubuntu Environment

![Ubuntu Environment](Tools/Ubuntu.png)

Ubuntu 24.04.5 LTS running inside Oracle VirtualBox.

### 2. Git Installation Verification

![Git Verification](Tools/Git%20Verification.png)

Verified Git installation using:

```bash
git --version
```

### 3. Magic Installation

![Magic Installation](Tools/magic%20install.png)

Terminal screenshot showing the Magic installation and setup process.

### 4. Magic Layout Tool

![Magic Tool](Tools/magic%20tool.png)

Magic VLSI layout editor launched with its graphical interface and Tcl console.

### 5. Netgen Tool

![Netgen Tool](Tools/Netgen%20tool.png)

Netgen launched successfully. It is used for Layout-versus-Schematic (LVS) verification.

### 6. ngspice Tool

![ngspice Tool](Tools/Ngspice%20tool.png)

ngspice launched successfully and displayed its interactive simulation prompt.

### 7. Xschem Tool

![Xschem Tool](Tools/Xschme%20tool.png)

Xschem schematic editor launched successfully.

### 8. Xschem Library Reference

![Xschem Library Reference](Tools/Checking%20xschme%20works.png)

Screenshot showing the Xschem library and symbol reference interface.

---

# 2. SKY130A PDK Configuration and Setup

This section documents the configuration files used to integrate the SkyWater SKY130A PDK with open-source EDA tools.

The configuration files provide technology support for schematic design, circuit simulation, layout generation, and physical verification.

**PDK Root Directory:**

```bash
/usr/local/share/pdk/sky130A
```

Set the PDK environment variable:

```bash
export PDK_ROOT=/usr/local/share/pdk
export PDK=sky130A
```

## 2.1 Magic Configuration – .magicrc

The `.magicrc` file configures Magic for the SKY130A technology.

Important functions from the uploaded configuration:

- Configures the layout grid.
- Enables Euclidean DRC checking.
- Loads the SKY130A technology file.
- Loads the SKY130A device generator.
- Configures power, ground, and substrate names.
- Adds paths to SKY130A reference-cell libraries.

### Important commands

```tcl
set PDK_ROOT /usr/local/share/pdk

tech load $PDK_ROOT/sky130A/libs.tech/magic/sky130A.tech

source $PDK_ROOT/sky130A/libs.tech/magic/sky130A.tcl

snap lambda

drc euclidean on

ext2spice scale off
```

### Launch Magic

```bash
export PDK_ROOT=/usr/local/share/pdk

magic -rcfile ~/.magicrc
```

The configuration also supports selecting `mag` or `maglef` library views through the `MAGTYPE` environment variable.

## 2.2 Netgen LVS Configuration – sky130A_setup.tcl

The `sky130A_setup.tcl` file contains technology-specific rules for comparing schematic and extracted-layout netlists.

The uploaded configuration includes:

- MOS transistor device recognition.
- PMOS and NMOS device classes.
- Source/drain pin permutation rules.
- Series and parallel device handling.
- Device property comparison.
- Width and length tolerances.
- Handling of extracted device parameters.

### Important commands from the configuration

```tcl
permute default

property default

property parallel none
```

MOS transistor device definitions include:

```tcl
lappend devices sky130_fd_pr__nfet_01v8

lappend devices sky130_fd_pr__pfet_01v8
```

For MOS devices, the setup also specifies:

```tcl
permute "-circuit1 $dev" 1 3

property "-circuit1 $dev" parallel enable

property "-circuit1 $dev" tolerance {w 0.01} {l 0.01}
```

Equivalent rules are applied to circuit 2.

The configuration allows Netgen to account for device parameters and pin ordering during LVS comparison.

## 2.3 ngspice Configuration – .spiceinit

The `.spiceinit` file configures ngspice for SkyWater PDK model compatibility and simulation.

### Actual settings from the uploaded file

```spice
* .spiceinit for use with Skywater PDK and ngspice KLU

set ngbehavior=hsa
set skywaterpdk
set ng_nomodcheck
set num_threads=8

option noinit
option klu
```

### Configuration purpose

| Setting | Purpose |
|---|---|
| `ngbehavior=hsa` | Selects HSA compatibility behavior |
| `skywaterpdk` | Enables SkyWater PDK compatibility |
| `ng_nomodcheck` | Disables model parameter checking |
| `num_threads=8` | Configures eight simulation threads |
| `option noinit` | Suppresses operating-point initialization output |
| `option klu` | Selects KLU as the matrix solver |

### Install the configuration

```bash
cp PDK_Configuration/.spiceinit ~/.spiceinit
```

### Launch ngspice

```bash
ngspice
```

## 2.4 Xschem Configuration – xschemrc

The `xschemrc` file configures the Xschem schematic editor and its SKY130A library paths.

Important configuration features:

- Defines Xschem library search paths.
- Includes standard device libraries.
- Configures SKY130A library identification colors.
- Detects the Open_PDKs installation directory.
- Sets the SKY130A PDK model directory.
- Configures the startup schematic.
- Provides SKY130-specific simulation support.

### Important settings from the uploaded configuration

```tcl
set XSCHEM_LIBRARY_PATH {}

append XSCHEM_LIBRARY_PATH :${XSCHEM_SHAREDIR}/xschem_library/devices

append XSCHEM_LIBRARY_PATH :${XSCHEM_SHAREDIR}/xschem_library
```

SKY130A library configuration:

```tcl
set dircolor(sky130_fd_pr$) blue

set dircolor(sky130_tests$) blue

set dircolor(xschem_sky130$) blue
```

PDK detection:

```tcl
set PDK sky130A

set SKYWATER_MODELS ${PDK_ROOT}/${PDK}/libs.tech/combined
```

The configuration also sets the startup window:

```tcl
set XSCHEM_START_WINDOW ${PDK_ROOT}/${PDK}/libs.tech/xschem/sky130_tests/top.sch
```

### Install the configuration

```bash
mkdir -p ~/.xschem

cp PDK_Configuration/xschemrc ~/.xschem/xschemrc
```

### Launch Xschem

```bash
xschem
```

---

# 3. CMOS Inverter Design and Simulation Using Xschem

This section documents the design and simulation of a CMOS inverter using Xschem and the SKY130A PDK.

The inverter is implemented using SKY130A PMOS and NMOS transistors. The schematic is converted into a reusable symbol and simulated using ngspice.

## 3.1 CMOS Inverter Schematic Design

![CMOS Inverter Schematic](Inverter%20using%20Xschem/inverter%20schematic%20using%20xschem.png)

Designed a CMOS inverter using SKY130A PMOS and NMOS transistors in Xschem.

The uploaded `inverter.sch` uses the following device parameters:

| Parameter | PMOS (M2) | NMOS (M1) |
|---|---:|---:|
| Width | 3 µm | 4.5 µm |
| Length | 0.18 µm | 0.18 µm |
| Fingers | 3 | 3 |
| Multiplier | 1 | 1 |

Device symbols:

```text
sky130_fd_pr/nfet_01v8.sym

sky130_fd_pr/pfet3_01v8.sym
```

Open the schematic:

```bash
xschem inverter.sch
```

## 3.2 Schematic Converted into Symbol

![Inverter Symbol](Inverter%20using%20Xschem/Converted%20the%20schematic%20to%20a%20symbol.png)

Converted the inverter schematic into a reusable hierarchical symbol for testbench integration.

The uploaded `inverter.sym` defines four interface pins:

- `vin` – Input
- `vout` – Output
- `vdd` – Supply
- `vss` – Ground

## 3.3 Inverter Testbench Design

![Inverter Testbench](Inverter%20using%20Xschem/inverter_tb.png)

Created an inverter testbench using Xschem with input voltage source, power supply, and SKY130A model library.

The testbench uses:

```spice
.lib /usr/local/share/pdk/sky130A/libs.tech/ngspice/sky130.lib.spice tt
```

Input voltage source:

```spice
PWL (0 0 20n 0 900n 1.8)
```

Supply voltage:

```spice
1.8
```

Transient simulation:

```spice
.control
tran 1n 1u
plot v(in) v(out)
.endc
```

## 3.4 Transient Simulation Waveform

![Simulation Waveform](Inverter%20using%20Xschem/simulation%20waveform.png)

Simulated the CMOS inverter using ngspice.

The waveform shows the input and output voltage responses, demonstrating the inverter's voltage inversion operation.

## 3.5 ngspice Simulation Results

![ngspice Simulation](Inverter%20using%20Xschem/simulation.png)

Executed the transient simulation using ngspice and observed the inverter output response.

### Simulation commands

```bash
xschem inverter_tb.sch

ngspice ~/.xschem/simulations/inverter_tb.spice
```

The second command assumes that Xschem generated the netlist at its default simulation directory.

## Design and Simulation Flow

**Xschem Schematic Design → Symbol Generation → Testbench Creation → SPICE Netlist Generation → ngspice Simulation → Waveform Analysis**

---

# 4. CMOS Inverter Physical Layout and Verification Using Magic

This section documents the physical layout implementation and verification of a CMOS inverter using Magic and the SKY130A PDK.

The layout uses SKY130A PMOS and NMOS devices. DRC, layout extraction, SPICE netlist generation, and LVS verification were performed.

## 4.1 Magic Layout Tool Setup

![Magic Layout Tool](layout%20using%20mgspice/magic%20tool.png)

Launched Magic with the SKY130A technology configuration for CMOS inverter physical layout implementation.

## 4.2 PMOS Transistor Parameters

![PMOS Parameters](layout%20using%20mgspice/pfet_parameter.png)

Configured SKY130A PMOS transistor parameters, including width, length, finger count, and device properties.

## 4.3 NMOS Transistor Parameters

![NMOS Parameters](layout%20using%20mgspice/nfet_parameters.png)

Configured SKY130A NMOS transistor parameters for the CMOS inverter layout.

## 4.4 CMOS Inverter Physical Layout

![CMOS Inverter Layout](layout%20using%20mgspice/layout.png)

Implemented the CMOS inverter physical layout using SKY130A PMOS and NMOS devices with input (vin), output (vout), VDD, and VSS connections.

## 4.5 Design Rule Checking (DRC)

![DRC Check](layout%20using%20mgspice/drc%20check.png)

Performed DRC verification using Magic.

Commands used in the Magic Tcl console:

```tcl
drc check

drc count

drc why
```

**Reported Result:**

- Total DRC errors found: 0
- No errors found.

## 4.6 Layout Extraction and SPICE Netlist Generation

![Layout Extraction](layout%20using%20mgspice/exract.png)

Performed layout extraction using Magic.

### Important extraction commands

```tcl
extract do local

extract all

ext2spice lvs

ext2spice
```

These commands perform local extraction, extract layout devices and connectivity, and generate a SPICE netlist.

The uploaded `inverter.spice` file was generated from `inverter.ext`.

It contains extracted PMOS and NMOS device subcircuits and the top-level inverter subcircuit.

Example top-level declaration:

```spice
.subckt inverter vin vdd vss vout
```

## 4.7 Layout-versus-Schematic (LVS) Verification

![LVS Result](layout%20using%20mgspice/LVS_result.png)

Performed LVS verification using Netgen by comparing the schematic and extracted-layout netlists.

### Netgen LVS command format

```bash
netgen -batch lvs \
"layout_netlist.spice inverter" \
"schematic_netlist.spice inverter" \
"PDK_Configuration/sky130A_setup.tcl"
```

Replace the example netlist filenames with the actual generated files.

### Reported verification result

```text
Final result:
Circuits match uniquely.

Logging to file "comp.out" disabled

LVS Done.
```

The terminal output reports:

- Circuit 1 contains 2 devices.
- Circuit 2 contains 2 devices.
- Both circuits contain 4 nets.
- Final result: Circuits match uniquely.

### Verification Summary

| Verification Stage | Tool | Result |
|---|---|---|
| Physical Layout | Magic | Completed |
| PMOS/NMOS Configuration | Magic | Completed |
| DRC | Magic | 0 Errors |
| Layout Extraction | Magic | Completed |
| SPICE Netlist Generation | Magic | Completed |
| LVS | Netgen | Circuits Match Uniquely |

## Physical Design and Verification Flow

**Xschem Schematic → Magic Layout Generation → DRC Verification → Layout Extraction → SPICE Netlist Generation → Netgen LVS Verification**

---

# 5. SKY130A Metal Layer Stack and Cross-Section

The following diagram illustrates the SKY130A technology stack, including metal interconnect layers, vias, polysilicon, diffusion, and substrate layers.

![SKY130A Metal Stack](stack.jpg)

## Diagram Overview

The cross-section represents the different fabrication layers used in the SKY130A process:

- **Metal Layers:** Metal1 to Metal5 for electrical interconnections.
- **Via Layers:** Via1 to Via4 for connections between metal layers.
- **Polysilicon:** Used for MOSFET gate formation.
- **Diffusion:** Source and drain regions.
- **N-Well and P-Substrate:** Semiconductor regions forming the device structure.
- **Dielectric Layers:** Insulating layers between conductive structures.

This diagram is included as a technology reference for understanding the SKY130A fabrication stack and physical layout design.

**Reference:** SKY130A process stack diagram.

---

# 6. Tools and Their Roles

| Tool | Main Purpose |
|---|---|
| Xschem | Schematic capture and SPICE netlist generation |
| ngspice | Analog and mixed-signal circuit simulation |
| Magic | IC layout design, extraction, and DRC |
| Netgen | Layout-versus-Schematic (LVS) comparison |
| Open_PDKs | PDK installation and configuration |
| Git | Version control and repository management |

---

# 7. Important Terminal Commands Reference

## Check EDA Tool Versions

```bash
git --version

magic --version

ngspice --version

xschem --version

netgen -batch
```

## Check SKY130A PDK Installation

```bash
ls /usr/local/share/pdk/

ls /usr/local/share/pdk/sky130A/libs.tech/

ls /usr/local/share/pdk/sky130A/libs.ref/
```

## Check Configuration Files

```bash
ls -la ~/.magicrc

ls -la ~/.spiceinit

ls -la ~/.xschem/xschemrc
```

## Check SKY130A Technology Files

```bash
ls /usr/local/share/pdk/sky130A/libs.tech/magic/

ls /usr/local/share/pdk/sky130A/libs.tech/xschem/

ls /usr/local/share/pdk/sky130A/libs.tech/ngspice/
```

---

# 8. Learning Focus

Understanding the complete open-source custom IC design workflow:

**PDK Installation → Tool Configuration → Schematic Design → SPICE Simulation → Physical Layout → DRC → Layout Extraction → LVS Verification**

---

# 9. Repository Status

**Current Status:** Open-source EDA tool installation, SKY130A configuration, CMOS inverter schematic design, transient simulation, physical layout generation, DRC, layout extraction, and LVS verification have been documented.

**Reported verification results:**
- Magic DRC: 0 errors.
- Netgen LVS: Circuits match uniquely.

Further work can include more complex CMOS circuits, layout optimization, parasitic extraction, and additional physical verification experiments.

