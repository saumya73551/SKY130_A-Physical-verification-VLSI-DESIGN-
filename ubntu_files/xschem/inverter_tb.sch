v {xschem version=3.4.4 file_version=1.2
}
G {}
K {}
V {}
S {}
E {}
N -80 -40 -20 -40 {
lab=in}
N -80 20 380 20 {
lab=GND}
N 380 10 380 20 {
lab=GND}
N 280 -40 320 -40 {
lab=#net1}
N 320 -60 320 -40 {
lab=#net1}
N 380 -60 380 -50 {
lab=#net1}
N 320 -60 380 -60 {
lab=#net1}
N 380 -60 380 -50 {
lab=#net1}
N 280 -0 280 20 {
lab=GND}
N 280 -20 310 -20 {
lab=out}
N -50 -80 -50 -40 {
lab=in}
C {vsource.sym} -80 -10 0 0 {name=V1 value="PWL (0 0 20n 0 900n 1.8)" savecurrent=false}
C {vsource.sym} 380 -20 0 0 {name=V2 value= 1.8 savecurrent=false}
C {gnd.sym} 50 20 0 0 {name=l1 lab=GND}
C {opin.sym} 310 -20 0 0 {name=p2 lab=out}
C {opin.sym} -50 -80 0 0 {name=p3 lab=in}
C {code_shown.sym} 190 -100 0 0 {name=s1 only_toplevel=false value=".lib /usr/local/share/pdk/sky130A/libs.tech/ngspice/sky130.lib.spice tt"}
C {code_shown.sym} 200 120 0 0 {name=s2 only_toplevel=false value=".control
tran 1n 1u
plot v(in) v(out)
.endc"}
C {/home/saumya/Desktop/Lab1_and/xschem/inverter.sym} 130 -20 0 0 {name=x1}
