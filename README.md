# SKY130A Physical Verification – VLSI Design

Implementation of a SKY130A-based CMOS inverter design and physical verification flow using open-source EDA tools, including Xschem, ngspice, Magic, Netgen, and Open_PDKs.

This project covers PDK setup, schematic design, SPICE simulation, physical layout implementation, Design Rule Checking (DRC), layout extraction, and Layout-versus-Schematic (LVS) verification.

---

## 1. Project Overview

This repository documents my hands-on experience in setting up and using an open-source VLSI design environment on **Ubuntu 24.04.5 LTS** running inside **Oracle VirtualBox**.

The project focuses on understanding the complete custom IC design workflow using the SkyWater SKY130A Process Design Kit (PDK).

### Objectives

- Set up an open-source VLSI design environment.
- Understand the SKY130A PDK architecture.
- Design a CMOS inverter using Xschem.
- Perform circuit simulation using ngspice.
- Implement the inverter layout using Magic.
- Perform DRC and layout extraction.
- Verify layout and schematic consistency using Netgen.

---

## 2. Open-Source PDK Architecture

The following diagram illustrates the open-source PDK ecosystem and the role of the `open_pdks` repository in supporting different open-source EDA tools.

![Open-Source PDK Toolchain](toolchains.png)

**Reference:** Architecture diagram provided by the instructor.

Repository: https://github.com/fossi-foundation/open-pdks

---

## 3. Environment and Tool Installation

### 3.1 Environment

| Component | Configuration |
|---|---|
| Operating System | Ubuntu 24.04.5 LTS |
| Virtualization | Oracle VirtualBox |
| Git | 2.43.0 |
| Magic | 8.3 |
| Xschem | 3.4.4 |
| ngspice | 42 |
| Netgen | Installed |
| PDK | SkyWater SKY130A |

### 3.2 Ubuntu Environment

![Ubuntu Environment](Tools/Ubuntu.png)

Ubuntu 24.04.5 LTS running inside Oracle VirtualBox.

### 3.3 Git Installation Verification

![Git Verification](Tools/Git%20Verification.png)

Verify Git installation:

```bash
git --version
```

### 3.4 Magic Installation and Launch

![Magic Installation](Tools/magic%20install.png)

Magic is used for IC layout design, physical verification, and layout extraction.

**Installation from source:**

```bash
git clone git://opencircuitdesign.com/magic
cd magic
./configure
make
sudo make install
```

**Verify Magic version:**

```bash
magic -version
```

**Launch Magic with SKY130A technology configuration:**

```bash
magic -rcfile /usr/local/share/pdk/sky130A/libs.tech/magic/sky130A.magicrc
```

![Magic Tool](Tools/magic%20tool.png)

### 3.5 Netgen Installation and Launch

![Netgen Tool](Tools/Netgen%20tool.png)

Netgen is used for Layout-versus-Schematic (LVS) verification.

**Installation from source:**

```bash
git clone git://opencircuitdesign.com/netgen
cd netgen
./configure
make
sudo make install
```

**Launch Netgen:**

```bash
netgen -batch
```

### 3.6 ngspice Installation and Launch

![ngspice Tool](Tools/Ngspice%20tool.png)

ngspice is used for analog circuit simulation and transient response analysis.

**Installation from source :**

```bash
tar -zxvf ngspice-37.tar.gz
cd ngspice-37
mkdir release
cd release
../configure 
make
sudo make install
```

Install xterm for waveform display:

```bash
sudo apt-get update
sudo apt-get install xterm
```

**Verify ngspice version:**

```bash
ngspice --version
```

**Launch:**

```bash
ngspice
```

**Installed version:** ngspice-42.

### 3.7 Xschem Installation and Launch

![Xschem Tool](Tools/Xschme%20tool.png)

Xschem is used for schematic capture and SPICE netlist generation.

**Installation from source:**

```bash
git clone https://github.com/StefanSchippers/xschem.git xschem_git
cd xschem_git
./configure
make
sudo make install
```

**Verify Xschem version:**

```bash
xschem --version
```

**Launch:**

```bash
xschem
```

### 3.8 Xschem Library Reference

![Xschem Library Reference](Tools/Checking%20xschme%20works.png)

Screenshot showing the Xschem library and symbol reference interface.

---

## 4. SKY130A PDK Configuration

The SKY130A PDK provides technology-specific device models, layout rules, and configuration files required by the EDA tools.

### 4.1 PDK Directory Verification

Installed PDK directory:

```bash
/usr/local/share/pdk/sky130A
```

Set environment variables:

```bash
export PDK_ROOT=/usr/local/share/pdk
export PDK=sky130A
```

Verify the PDK directory:

```bash
ls /usr/local/share/pdk/sky130A
```

Check technology files:

```bash
ls /usr/local/share/pdk/sky130A/libs.tech/
```

### 4.2 Magic Technology Configuration

Magic technology configuration file:

```bash
/usr/local/share/pdk/sky130A/libs.tech/magic/sky130A.magicrc
```

Launch Magic:

```bash
magic -rcfile /usr/local/share/pdk/sky130A/libs.tech/magic/sky130A.magicrc
```

### 4.3 ngspice Model Library Configuration

SKY130A SPICE model library:

```bash
/usr/local/share/pdk/sky130A/libs.tech/ngspice/sky130.lib.spice
```

Include the typical process corner in the SPICE testbench:

```spice
.lib /usr/local/share/pdk/sky130A/libs.tech/ngspice/sky130.lib.spice tt
```

Here, `tt` represents the typical process corner.

### 4.4 Xschem Library Configuration

Xschem uses SKY130A device symbols and model libraries for schematic design and netlist generation.

Library directory:

```bash
/usr/local/share/pdk/sky130A/libs.tech/xschem/
```

### 4.5 Project Configuration and Design Files

The `ubuntu_files` directory contains the configuration files and design files used during the SKY130A CMOS inverter implementation.

**Create project directories:**

```bash
mkdir -p ubuntu_files/mag
mkdir -p ubuntu_files/netgen
mkdir -p ubuntu_files/xschem
```

**Copy Xschem configuration:**

```bash
cp /usr/local/share/pdk/sky130A/libs.tech/xschem/xschemrc ubuntu_files/xschem/
```

**Copy ngspice initialization file:**

```bash
cp /usr/local/share/pdk/sky130A/libs.tech/ngspice/spinit ubuntu_files/xschem/.spiceinit
```

**Copy Magic configuration:**

```bash
cp /usr/local/share/pdk/sky130A/libs.tech/magic/sky130A.magicrc ubuntu_files/mag/.magicrc
```

**Copy Netgen LVS setup file:**

```bash
cp /usr/local/share/pdk/sky130A/libs.tech/netgen/sky130A_setup.tcl ubuntu_files/netgen/
```

**Verify configuration files:**

```bash
ls -la ubuntu_files/mag/
ls -la ubuntu_files/netgen/
ls -la ubuntu_files/xschem/
```

**Repository directory structure:**

```text
ubuntu_files/
│
├── mag/
│   └── .magicrc
│
├── netgen/
│   └── sky130A_setup.tcl
│
├── xschem/
│   ├── inverter.sch
│   ├── inverter.sym
│   ├── inverter_tb.sch
│   ├── xschemrc
│   └── .spiceinit
│
├── inverter.spice
└── test.txt
```

**File descriptions:**

| File | Purpose |
|---|---|
| sky130A_setup.tcl | Netgen LVS setup |
| inverter.sch | CMOS inverter schematic |
| inverter.sym | Reusable inverter symbol |
| inverter_tb.sch | Inverter testbench |
| xschemrc | Xschem configuration |
| .spiceinit | ngspice initialization |
| .magicrc | Magic technology configuration |
| inverter.spice | SPICE netlist |
| test.txt | Supporting test file |

---

## 5. CMOS Inverter Design and Simulation Using Xschem

This section documents the schematic design and simulation of a CMOS inverter using Xschem and the SKY130A PDK.

The inverter consists of a PMOS transistor and an NMOS transistor connected in a complementary configuration.

### 5.1 CMOS Inverter Schematic Design

![CMOS Inverter Schematic](Inverter%20using%20Xschem/inverter%20schematic%20using%20xschem.png)

Designed a CMOS inverter using SKY130A PMOS and NMOS transistors in Xschem.

Open the schematic from the repository:

```bash
xschem ubuntu_files/xschem/inverter.sch
```

### 5.2 Schematic Converted into Symbol

![Inverter Symbol](Inverter%20using%20Xschem/Converted%20the%20schematic%20to%20a%20symbol.png)

Converted the inverter schematic into a reusable hierarchical symbol for testbench integration.

The generated symbol is stored as:

```text
ubuntu_files/xschem/inverter.sym
```

### 5.3 Inverter Testbench Design

![Inverter Testbench](Inverter%20using%20Xschem/inverter_tb.png)

Created an inverter testbench using Xschem with:

- Input voltage source.
- 1.8 V power supply.
- SKY130A model library.
- CMOS inverter symbol.

Open the testbench:

```bash
xschem ubuntu_files/xschem/inverter_tb.sch
```

### 5.4 SPICE Netlist Generation

The schematic is converted into a SPICE netlist for circuit simulation.

The repository contains:

```text
ubuntu_files/inverter.spice
```

The netlist can be inspected using:

```bash
cat ubuntu_files/inverter.spice
```

### 5.5 Transient Simulation Using ngspice

Execute the SPICE netlist:

```bash
ngspice ubuntu_files/inverter.spice
```

The simulation is used to observe the inverter's transient response.

### 5.6 Transient Simulation Waveform

![Simulation Waveform](Inverter%20using%20Xschem/simulation%20waveform.png)

The waveform shows the input and output voltage responses.

- When the input voltage is LOW, the output is HIGH.
- When the input voltage is HIGH, the output is LOW.
- The output demonstrates the expected CMOS inverter operation.

### 5.7 ngspice Simulation Results

![ngspice Simulation](Inverter%20using%20Xschem/simulation.png)

Executed the transient simulation using ngspice and observed the inverter output response.

### Design and Simulation Flow

**Xschem Schematic Design → Symbol Generation → Testbench Creation → SPICE Netlist → ngspice Simulation → Waveform Analysis**

---

## 6. CMOS Inverter Physical Layout and Verification Using Magic

This section documents the physical implementation and verification of the CMOS inverter using Magic and the SKY130A PDK.

### 6.1 Magic Layout Tool Setup

![Magic Layout Tool](layout%20using%20mgspice/magic%20tool.png)

Launched Magic with SKY130A technology configuration for physical layout implementation.

```bash
magic -rcfile /usr/local/share/pdk/sky130A/libs.tech/magic/sky130A.magicrc
```

### 6.2 PMOS Transistor Parameters

![PMOS Parameters](layout%20using%20mgspice/pfet_parameter.png)

Configured SKY130A PMOS transistor parameters:

- Width: 1.0 µm
- Length: 0.18 µm
- Fingers: 3
- Multiplier: 1

### 6.3 NMOS Transistor Parameters

![NMOS Parameters](layout%20using%20mgspice/nfet_parameters.png)

Configured SKY130A NMOS transistor parameters:

- Width: 1.5 µm
- Length: 0.18 µm
- Fingers: 3
- Multiplier: 1

### 6.4 CMOS Inverter Physical Layout

![CMOS Inverter Layout](layout%20using%20mgspice/layout.png)

Implemented the CMOS inverter physical layout using SKY130A PMOS and NMOS devices.

The layout includes:

- PMOS and NMOS transistor regions.
- Input connection (vin).
- Output connection (vout).
- Power supply (VDD).
- Ground connection (VSS).

### 6.5 Design Rule Checking (DRC)

![DRC Check](layout%20using%20mgspice/drc%20check.png)

Performed Design Rule Checking using Magic to identify physical design-rule violations.

**Magic DRC commands:**

```tcl
drc check
drc count
drc why
```

**DRC Results:**

- Total DRC errors found: 0
- No errors found.

### 6.6 Layout Extraction and SPICE Netlist Generation

![Layout Extraction](layout%20using%20mgspice/exract.png)

Performed layout extraction using Magic.

**Magic extraction commands:**

```tcl
extract do local
extract all
ext2spice lvs
ext2spice
```

These commands perform:

- Local layout extraction.
- Complete layout extraction.
- LVS-oriented SPICE extraction.
- SPICE netlist generation.

The extracted layout information is converted into a SPICE netlist for further verification.

### 6.7 Layout-versus-Schematic (LVS) Verification

![LVS Result](layout%20using%20mgspice/LVS_result.png)

LVS verification was performed using Netgen by comparing the schematic and extracted layout netlists.

The repository contains the SKY130A Netgen setup file:

```text
ubuntu_files/netgen/sky130A_setup.tcl
```

**Netgen LVS command template:**

```bash
netgen -batch lvs \
"layout.spice inverter" \
"schematic.spice inverter" \
"$PWD/ubuntu_files/netgen/sky130A_setup.tcl" \
lvs_report.txt
```

Replace `layout.spice` and `schematic.spice` with the actual extracted layout and schematic netlist filenames.

**Verification Results:**

- Circuit 1 contains 2 device instances.
- Circuit 2 contains 2 device instances.
- Both circuits contain 4 nets.
- Final result: Circuits match uniquely.
- LVS Done.

### 6.8 Physical Verification Summary

| Verification Stage | Tool | Result |
|---|---|---|
| Physical Layout | Magic | Completed |
| PMOS/NMOS Configuration | Magic | Completed |
| DRC | Magic | 0 Errors |
| Layout Extraction | Magic | Completed |
| SPICE Netlist Generation | Magic | Completed |
| LVS | Netgen | Circuits Match Uniquely |

### Physical Design Flow

**Xschem Schematic → Magic Layout Generation → DRC Verification → Layout Extraction → SPICE Netlist Generation → Netgen LVS Verification**

---

## 7. SKY130A Metal Layer Stack and Cross-Section

The following diagram illustrates the SKY130A technology stack, including metal interconnect layers, vias, polysilicon, diffusion, and substrate layers.

![SKY130A Metal Stack](stack.jpg)

### 7.1 Diagram Overview

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

## 8. Overall Project Workflow

The complete custom IC design and verification workflow demonstrated in this project is:

**PDK Setup → Schematic Design → SPICE Netlist Generation → Circuit Simulation → Physical Layout → DRC → Layout Extraction → LVS Verification**

---

## 9. Project Conclusion

This project provided practical exposure to an open-source VLSI design environment using the SkyWater SKY130A PDK.

A CMOS inverter was designed using Xschem, simulated using ngspice, and physically implemented using Magic.

The physical layout was checked using Magic DRC, which reported zero errors. Layout extraction was performed, and Netgen LVS verification reported that the schematic and layout circuits matched uniquely.

The project helped develop an understanding of schematic capture, transistor-level design, SPICE simulation, physical layout implementation, and verification methodologies.

---

## 10. Future Work

- Explore more complex CMOS logic gates.
- Design NAND, NOR, and other standard logic circuits.
- Study parasitic extraction and post-layout simulation.
- Explore advanced physical design concepts.
- Understand the complete RTL-to-GDSII flow.

---

**Tools:** Xschem | ngspice | Magic | Netgen | Open_PDKs | Git

**Technology:** SkyWater SKY130A
