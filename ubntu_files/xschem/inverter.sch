v {xschem version=3.4.4 file_version=1.2
}
G {}
K {}
V {}
S {}
E {}
N 210 -10 240 -10 {
lab=vin}
N 210 -10 210 100 {
lab=vin}
N 210 100 240 100 {
lab=vin}
N 170 50 210 50 {
lab=vin}
N 280 20 280 70 {
lab=out}
N 280 40 410 40 {
lab=out}
N 280 130 280 170 {
lab=vss}
N 280 170 310 170 {
lab=vss}
N 280 100 300 100 {
lab=vss}
N 300 100 300 170 {
lab=vss}
N 280 -90 280 -40 {
lab=vdd}
N 280 -90 290 -90 {
lab=vdd}
C {sky130_fd_pr/nfet_01v8.sym} 260 100 0 0 {nname=M1
L=0.18
W=4.5
nf=3
mult=1
body=vss
ad=" 'int((nf+1)/2) * W/nf * 0.29' "
pd=" '2*int((nf+1)/2) * (W/nf + 0.29)' "
as=" 'int((nf+2)/2) * W/nf * 0.29' "
ps=" '2*int((nf+2)/2) * (W/nf + 0.29)' "
nrd=" '0.29 / W' " nrs= " '0.29 / W' "
sa=0 sb=0 sd=0
model=nfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/pfet3_01v8.sym} 260 -10 0 0 {name=M2
L=0.18
W=3
body=vdd
nf=3
mult=1
ad=" 'int((nf+1)/2) * W/nf * 0.29' "
pd=" '2*int((nf+1)/2) * (W/nf + 0.29)' "
as=" 'int((nf+2)/2) * W/nf * 0.29' "
ps=" '2*int((nf+2)/2) * (W/nf + 0.29)' "
nrd=" '0.29 / W' " nrs= " '0.29 / W' "
sa=0 sb=0 sd=0
model=pfet_01v8
spiceprefix=X
}
C {ipin.sym} 170 50 0 0 {name=p1 lab=vin}
C {iopin.sym} 290 -90 0 0 {name=p2 lab=vdd}
C {iopin.sym} 310 170 0 0 {name=p3 lab=vss}
C {opin.sym} 410 40 0 0 {name=p4 lab=vout}
