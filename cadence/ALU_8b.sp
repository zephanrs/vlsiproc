*
*
*
*                       LINUX           Sat May 16 05:13:39 2026
*
*
*
*  PROGRAM  advgen
*
*  Name           : advgen - Quantus - (64-bit)
*  Version        : 23.1.1-p051
*  Build Date     : Thu Feb 15 21:11:17 PST 2024
*
*  HSPICE LIBRARY
*
*  OPERATING_TEMPERATURE 25
*  QRC_TECH_DIR /opt/cadence-designkits/gpdk045_v_6_0/qrc/typical 
*
*
*

*
.SUBCKT ALU_8b eq gnd! in0<0> in0<1> in0<2> in0<3> in0<4> in0<5> in0<6> in0<7>
+ in1<0> in1<1> in1<2> in1<3> in1<4> in1<5> in1<6> in1<7> sum<0> sum<1> sum<2>
+ sum<3> sum<4> sum<5> sum<6> sum<7> vdd!
*
*
*  caps2d version: 10
*
*
*       TRANSISTOR CARDS
*
*
MXI88/MNM0	eq	net7	gnd!	gnd!	g45n1svt	L=4.5e-08
+ W=4.8e-07
+ AD=6.72e-14	AS=6.72e-14	PD=1.24e-06	PS=1.24e-06
+ fw=4.8e-07 sa=1.4e-07 sb=1.4e-07 sca=4.2604 scb=0.000545366 scc=7.2595e-07
MXI5/MNM4	XI5/net2	net43	gnd!	gnd!	g45n1svt
+ L=4.5e-08	W=2.4e-07
+ AD=3.84e-14	AS=3.36e-14	PD=8e-07	PS=7.6e-07
+ fw=2.4e-07 sa=1.4e-07 sb=3.45e-07 sca=4.03612 scb=0.00025167 scc=4.50294e-08
MXI5/MNM5	net33	net40	XI5/net2	gnd!	g45n1svt
+ L=4.5e-08	W=2.4e-07
+ AD=3.36e-14	AS=3.84e-14	PD=7.6e-07	PS=8e-07
+ fw=2.4e-07 sa=3.45e-07 sb=1.4e-07 sca=4.03612 scb=0.00025167 scc=4.50294e-08
MXI6/MNM4	XI6/net2	net49	gnd!	gnd!	g45n1svt
+ L=4.5e-08	W=2.4e-07
+ AD=3.84e-14	AS=3.36e-14	PD=8e-07	PS=7.6e-07
+ fw=2.4e-07 sa=1.4e-07 sb=3.45e-07 sca=4.03612 scb=0.00025167 scc=4.50294e-08
MXI6/MNM5	net19	net46	XI6/net2	gnd!	g45n1svt
+ L=4.5e-08	W=2.4e-07
+ AD=3.36e-14	AS=3.84e-14	PD=7.6e-07	PS=8e-07
+ fw=2.4e-07 sa=3.45e-07 sb=1.4e-07 sca=4.03612 scb=0.00025167 scc=4.50294e-08
MXI4/MNM0	net5	net33	gnd!	gnd!	g45n1svt	L=4.5e-08
+ W=1.2e-07
+ AD=1.92e-14	AS=1.68e-14	PD=5.6e-07	PS=5.2e-07
+ fw=1.2e-07 sa=1.4e-07 sb=3.45e-07 sca=3.9431 scb=0.000183837 scc=1.14832e-08
MXI4/MNM1	net5	net19	gnd!	gnd!	g45n1svt	L=4.5e-08
+ W=1.2e-07
+ AD=1.92e-14	AS=1.68e-14	PD=5.6e-07	PS=5.2e-07
+ fw=1.2e-07 sa=1.4e-07 sb=3.45e-07 sca=3.9431 scb=0.000183837 scc=1.14832e-08
MXI0/MNM0	net40	P<7>	gnd!	gnd!	g45n1svt	L=4.5e-08
+ W=1.2e-07
+ AD=1.92e-14	AS=1.68e-14	PD=5.6e-07	PS=5.2e-07
+ fw=1.2e-07 sa=1.4e-07 sb=3.45e-07 sca=3.9431 scb=0.000183837 scc=1.14832e-08
MXI0/MNM1	net40	P<6>	gnd!	gnd!	g45n1svt	L=4.5e-08
+ W=1.2e-07
+ AD=1.92e-14	AS=1.68e-14	PD=5.6e-07	PS=5.2e-07
+ fw=1.2e-07 sa=1.4e-07 sb=3.45e-07 sca=3.9431 scb=0.000183837 scc=1.14832e-08
MXI1/MNM0	net43	P<5>	gnd!	gnd!	g45n1svt	L=4.5e-08
+ W=1.2e-07
+ AD=1.92e-14	AS=1.68e-14	PD=5.6e-07	PS=5.2e-07
+ fw=1.2e-07 sa=1.4e-07 sb=3.45e-07 sca=3.9431 scb=0.000183837 scc=1.14832e-08
MXI1/MNM1	net43	P<4>	gnd!	gnd!	g45n1svt	L=4.5e-08
+ W=1.2e-07
+ AD=1.92e-14	AS=1.68e-14	PD=5.6e-07	PS=5.2e-07
+ fw=1.2e-07 sa=1.4e-07 sb=3.45e-07 sca=3.9431 scb=0.000183837 scc=1.14832e-08
MXI3/MNM0	net49	P<1>	gnd!	gnd!	g45n1svt	L=4.5e-08
+ W=1.2e-07
+ AD=1.92e-14	AS=1.68e-14	PD=5.6e-07	PS=5.2e-07
+ fw=1.2e-07 sa=1.4e-07 sb=3.45e-07 sca=3.9431 scb=0.000183837 scc=1.14832e-08
MXI3/MNM1	net49	sum<0>	gnd!	gnd!	g45n1svt	L=4.5e-08
+ W=1.2e-07
+ AD=1.92e-14	AS=1.68e-14	PD=5.6e-07	PS=5.2e-07
+ fw=1.2e-07 sa=1.4e-07 sb=3.45e-07 sca=3.9431 scb=0.000183837 scc=1.14832e-08
MXI2/MNM0	net46	P<3>	gnd!	gnd!	g45n1svt	L=4.5e-08
+ W=1.2e-07
+ AD=1.92e-14	AS=1.68e-14	PD=5.6e-07	PS=5.2e-07
+ fw=1.2e-07 sa=1.4e-07 sb=3.45e-07 sca=3.9431 scb=0.000183837 scc=1.14832e-08
MXI2/MNM1	net46	P<2>	gnd!	gnd!	g45n1svt	L=4.5e-08
+ W=1.2e-07
+ AD=1.92e-14	AS=1.68e-14	PD=5.6e-07	PS=5.2e-07
+ fw=1.2e-07 sa=1.4e-07 sb=3.45e-07 sca=3.9431 scb=0.000183837 scc=1.14832e-08
MXI97/MNM0	XI97/net2	G<4>	gnd!	gnd!	g45n1svt
+ L=4.5e-08	W=2.4e-07
+ AD=1.44e-14	AS=3.96e-14	PD=6e-07	PS=8.6e-07
+ fw=2.4e-07 sa=2.575e-07 sb=2.45e-07 sca=4.03612 scb=0.00025167 scc=4.50294e-08
MXI97/MPM8	net13	P<5>	XI97/net2	gnd!	g45n1svt
+ L=4.5e-08	W=2.4e-07
+ AD=3.36e-14	AS=1.44e-14	PD=7.6e-07	PS=6e-07
+ fw=2.4e-07 sa=3.625e-07 sb=1.4e-07 sca=4.03612 scb=0.00025167 scc=4.50294e-08
MXI97/MPM7	net13	G<5>	gnd!	gnd!	g45n1svt	L=4.5e-08
+ W=1.2e-07
+ AD=1.68e-14	AS=3.96e-14	PD=5.2e-07	PS=8.6e-07
+ fw=1.2e-07 sa=4.8e-07 sb=1.4e-07 sca=4.30195 scb=0.000337913 scc=7.93041e-08
MXI97/MNM5	XI97/net4	P<4>	gnd!	gnd!	g45n1svt
+ L=4.5e-08	W=2.4e-07
+ AD=3.84e-14	AS=3.36e-14	PD=8e-07	PS=7.6e-07
+ fw=2.4e-07 sa=1.4e-07 sb=3.45e-07 sca=4.03612 scb=0.00025167 scc=4.50294e-08
MXI97/MNM4	net17	P<5>	XI97/net4	gnd!	g45n1svt
+ L=4.5e-08	W=2.4e-07
+ AD=3.36e-14	AS=3.84e-14	PD=7.6e-07	PS=8e-07
+ fw=2.4e-07 sa=3.45e-07 sb=1.4e-07 sca=4.03612 scb=0.00025167 scc=4.50294e-08
MXI84/MNM0	XI84/net2	net11	gnd!	gnd!	g45n1svt
+ L=4.5e-08	W=2.4e-07
+ AD=1.44e-14	AS=3.96e-14	PD=6e-07	PS=8.6e-07
+ fw=2.4e-07 sa=2.575e-07 sb=2.45e-07 sca=4.03612 scb=0.00025167 scc=4.50294e-08
MXI84/MPM8	net21	net30	XI84/net2	gnd!	g45n1svt
+ L=4.5e-08	W=2.4e-07
+ AD=3.36e-14	AS=1.44e-14	PD=7.6e-07	PS=6e-07
+ fw=2.4e-07 sa=3.625e-07 sb=1.4e-07 sca=4.03612 scb=0.00025167 scc=4.50294e-08
MXI84/MPM7	net21	net24	gnd!	gnd!	g45n1svt	L=4.5e-08
+ W=1.2e-07
+ AD=1.68e-14	AS=3.96e-14	PD=5.2e-07	PS=8.6e-07
+ fw=1.2e-07 sa=4.8e-07 sb=1.4e-07 sca=4.30195 scb=0.000337913 scc=7.93041e-08
MXI84/MNM5	XI84/net4	net16	gnd!	gnd!	g45n1svt
+ L=4.5e-08	W=2.4e-07
+ AD=3.84e-14	AS=3.36e-14	PD=8e-07	PS=7.6e-07
+ fw=2.4e-07 sa=1.4e-07 sb=3.45e-07 sca=4.03612 scb=0.00025167 scc=4.50294e-08
MXI84/MNM4	net27	net30	XI84/net4	gnd!	g45n1svt
+ L=4.5e-08	W=2.4e-07
+ AD=3.36e-14	AS=3.84e-14	PD=7.6e-07	PS=8e-07
+ fw=2.4e-07 sa=3.45e-07 sb=1.4e-07 sca=4.03612 scb=0.00025167 scc=4.50294e-08
MXI91/MNM0	XI91/net2	net11	gnd!	gnd!	g45n1svt
+ L=4.5e-08	W=2.4e-07
+ AD=1.44e-14	AS=3.96e-14	PD=6e-07	PS=8.6e-07
+ fw=2.4e-07 sa=2.575e-07 sb=2.45e-07 sca=4.03612 scb=0.00025167 scc=4.50294e-08
MXI91/MPM8	net31	P<6>	XI91/net2	gnd!	g45n1svt
+ L=4.5e-08	W=2.4e-07
+ AD=3.36e-14	AS=1.44e-14	PD=7.6e-07	PS=6e-07
+ fw=2.4e-07 sa=3.625e-07 sb=1.4e-07 sca=4.03612 scb=0.00025167 scc=4.50294e-08
MXI91/MPM7	net31	G<6>	gnd!	gnd!	g45n1svt	L=4.5e-08
+ W=1.2e-07
+ AD=1.68e-14	AS=3.96e-14	PD=5.2e-07	PS=8.6e-07
+ fw=1.2e-07 sa=4.8e-07 sb=1.4e-07 sca=4.30195 scb=0.000337913 scc=7.93041e-08
MXI91/MNM5	XI91/net4	net16	gnd!	gnd!	g45n1svt
+ L=4.5e-08	W=2.4e-07
+ AD=3.84e-14	AS=3.36e-14	PD=8e-07	PS=7.6e-07
+ fw=2.4e-07 sa=1.4e-07 sb=3.45e-07 sca=4.03612 scb=0.00025167 scc=4.50294e-08
MXI91/MNM4	net35	P<6>	XI91/net4	gnd!	g45n1svt
+ L=4.5e-08	W=2.4e-07
+ AD=3.36e-14	AS=3.84e-14	PD=7.6e-07	PS=8e-07
+ fw=2.4e-07 sa=3.45e-07 sb=1.4e-07 sca=4.03612 scb=0.00025167 scc=4.50294e-08
MXI85/MNM0	XI85/net2	G<6>	gnd!	gnd!	g45n1svt
+ L=4.5e-08	W=2.4e-07
+ AD=1.44e-14	AS=3.96e-14	PD=6e-07	PS=8.6e-07
+ fw=2.4e-07 sa=2.575e-07 sb=2.45e-07 sca=4.03612 scb=0.00025167 scc=4.50294e-08
MXI85/MPM8	net23	P<7>	XI85/net2	gnd!	g45n1svt
+ L=4.5e-08	W=2.4e-07
+ AD=3.36e-14	AS=1.44e-14	PD=7.6e-07	PS=6e-07
+ fw=2.4e-07 sa=3.625e-07 sb=1.4e-07 sca=4.03612 scb=0.00025167 scc=4.50294e-08
MXI85/MPM7	net23	G<7>	gnd!	gnd!	g45n1svt	L=4.5e-08
+ W=1.2e-07
+ AD=1.68e-14	AS=3.96e-14	PD=5.2e-07	PS=8.6e-07
+ fw=1.2e-07 sa=4.8e-07 sb=1.4e-07 sca=4.30195 scb=0.000337913 scc=7.93041e-08
MXI85/MNM5	XI85/net4	P<6>	gnd!	gnd!	g45n1svt
+ L=4.5e-08	W=2.4e-07
+ AD=3.84e-14	AS=3.36e-14	PD=8e-07	PS=7.6e-07
+ fw=2.4e-07 sa=1.4e-07 sb=3.45e-07 sca=4.03612 scb=0.00025167 scc=4.50294e-08
MXI85/MNM4	net29	P<7>	XI85/net4	gnd!	g45n1svt
+ L=4.5e-08	W=2.4e-07
+ AD=3.36e-14	AS=3.84e-14	PD=7.6e-07	PS=8e-07
+ fw=2.4e-07 sa=3.45e-07 sb=1.4e-07 sca=4.03612 scb=0.00025167 scc=4.50294e-08
MXI106/MNM0	XI106/net2	G<2>	gnd!	gnd!	g45n1svt
+ L=4.5e-08	W=2.4e-07
+ AD=1.44e-14	AS=3.96e-14	PD=6e-07	PS=8.6e-07
+ fw=2.4e-07 sa=2.575e-07 sb=2.45e-07 sca=4.03612 scb=0.00025167 scc=4.50294e-08
MXI106/MPM8	net2	P<3>	XI106/net2	gnd!	g45n1svt
+ L=4.5e-08	W=2.4e-07
+ AD=3.36e-14	AS=1.44e-14	PD=7.6e-07	PS=6e-07
+ fw=2.4e-07 sa=3.625e-07 sb=1.4e-07 sca=4.03612 scb=0.00025167 scc=4.50294e-08
MXI106/MPM7	net2	G<3>	gnd!	gnd!	g45n1svt	L=4.5e-08
+ W=1.2e-07
+ AD=1.68e-14	AS=3.96e-14	PD=5.2e-07	PS=8.6e-07
+ fw=1.2e-07 sa=4.8e-07 sb=1.4e-07 sca=4.30195 scb=0.000337913 scc=7.93041e-08
MXI106/MNM5	XI106/net4	P<2>	gnd!	gnd!	g45n1svt
+ L=4.5e-08	W=2.4e-07
+ AD=3.84e-14	AS=3.36e-14	PD=8e-07	PS=7.6e-07
+ fw=2.4e-07 sa=1.4e-07 sb=3.45e-07 sca=4.03612 scb=0.00025167 scc=4.50294e-08
MXI106/MNM4	net6	P<3>	XI106/net4	gnd!	g45n1svt
+ L=4.5e-08	W=2.4e-07
+ AD=3.36e-14	AS=3.84e-14	PD=7.6e-07	PS=8e-07
+ fw=2.4e-07 sa=3.45e-07 sb=1.4e-07 sca=4.03612 scb=0.00025167 scc=4.50294e-08
MXI111/MPM6	XI111/net7	G10	gnd!	gnd!	g45n1svt
+ L=4.5e-08	W=2.4e-07
+ AD=1.44e-14	AS=3.96e-14	PD=6e-07	PS=8.6e-07
+ fw=2.4e-07 sa=2.575e-07 sb=2.45e-07 sca=4.03612 scb=0.00025167 scc=4.50294e-08
MXI111/MPM8	net9	P<2>	XI111/net7	gnd!	g45n1svt
+ L=4.5e-08	W=2.4e-07
+ AD=3.36e-14	AS=1.44e-14	PD=7.6e-07	PS=6e-07
+ fw=2.4e-07 sa=3.625e-07 sb=1.4e-07 sca=4.03612 scb=0.00025167 scc=4.50294e-08
MXI111/MPM7	net9	G<2>	gnd!	gnd!	g45n1svt	L=4.5e-08
+ W=1.2e-07
+ AD=1.68e-14	AS=3.96e-14	PD=5.2e-07	PS=8.6e-07
+ fw=1.2e-07 sa=4.8e-07 sb=1.4e-07 sca=4.30195 scb=0.000337913 scc=7.93041e-08
MXI83/MPM6	XI83/net7	G30	gnd!	gnd!	g45n1svt
+ L=4.5e-08	W=2.4e-07
+ AD=1.44e-14	AS=3.96e-14	PD=6e-07	PS=8.6e-07
+ fw=2.4e-07 sa=2.575e-07 sb=2.45e-07 sca=4.03612 scb=0.00025167 scc=4.50294e-08
MXI83/MPM8	net26	net28	XI83/net7	gnd!	g45n1svt
+ L=4.5e-08	W=2.4e-07
+ AD=3.36e-14	AS=1.44e-14	PD=7.6e-07	PS=6e-07
+ fw=2.4e-07 sa=3.625e-07 sb=1.4e-07 sca=4.03612 scb=0.00025167 scc=4.50294e-08
MXI83/MPM7	net26	net22	gnd!	gnd!	g45n1svt	L=4.5e-08
+ W=1.2e-07
+ AD=1.68e-14	AS=3.96e-14	PD=5.2e-07	PS=8.6e-07
+ fw=1.2e-07 sa=4.8e-07 sb=1.4e-07 sca=4.30195 scb=0.000337913 scc=7.93041e-08
MXI90/MPM6	XI90/net7	G30	gnd!	gnd!	g45n1svt
+ L=4.5e-08	W=2.4e-07
+ AD=1.44e-14	AS=3.96e-14	PD=6e-07	PS=8.6e-07
+ fw=2.4e-07 sa=2.575e-07 sb=2.45e-07 sca=4.03612 scb=0.00025167 scc=4.50294e-08
MXI90/MPM8	net34	net36	XI90/net7	gnd!	g45n1svt
+ L=4.5e-08	W=2.4e-07
+ AD=3.36e-14	AS=1.44e-14	PD=7.6e-07	PS=5.99999e-07
+ fw=2.4e-07 sa=3.625e-07 sb=1.4e-07 sca=4.03612 scb=0.00025167 scc=4.50294e-08
MXI90/MPM7	net34	net32	gnd!	gnd!	g45n1svt	L=4.5e-08
+ W=1.2e-07
+ AD=1.68e-14	AS=3.96e-14	PD=5.2e-07	PS=8.59999e-07
+ fw=1.2e-07 sa=4.8e-07 sb=1.4e-07 sca=4.30195 scb=0.000337913 scc=7.93041e-08
MXI102/MPM6	XI102/net7	G30	gnd!	gnd!	g45n1svt
+ L=4.5e-08	W=2.4e-07
+ AD=1.44e-14	AS=3.96e-14	PD=5.99999e-07	PS=8.59999e-07
+ fw=2.4e-07 sa=2.575e-07 sb=2.45e-07 sca=4.03612 scb=0.00025167 scc=4.50294e-08
MXI102/MPM8	net20	P<4>	XI102/net7	gnd!	g45n1svt
+ L=4.5e-08	W=2.4e-07
+ AD=3.36e-14	AS=1.44e-14	PD=7.59999e-07	PS=5.99999e-07
+ fw=2.4e-07 sa=3.625e-07 sb=1.4e-07 sca=4.03612 scb=0.00025167 scc=4.50294e-08
MXI102/MPM7	net20	G<4>	gnd!	gnd!	g45n1svt	L=4.5e-08
+ W=1.2e-07
+ AD=1.68e-14	AS=3.96e-14	PD=5.19999e-07	PS=8.59999e-07
+ fw=1.2e-07 sa=4.8e-07 sb=1.4e-07 sca=4.30195 scb=0.000337913 scc=7.93041e-08
MXI96/MPM6	XI96/net7	G30	gnd!	gnd!	g45n1svt
+ L=4.5e-08	W=2.4e-07
+ AD=1.44e-14	AS=3.96e-14	PD=5.99999e-07	PS=8.59999e-07
+ fw=2.4e-07 sa=2.575e-07 sb=2.45e-07 sca=4.03612 scb=0.00025167 scc=4.50294e-08
MXI96/MPM8	net15	net16	XI96/net7	gnd!	g45n1svt
+ L=4.5e-08	W=2.4e-07
+ AD=3.36e-14	AS=1.44e-14	PD=7.59999e-07	PS=5.99999e-07
+ fw=2.4e-07 sa=3.625e-07 sb=1.4e-07 sca=4.03612 scb=0.00025167 scc=4.50294e-08
MXI96/MPM7	net15	net11	gnd!	gnd!	g45n1svt	L=4.5e-08
+ W=1.2e-07
+ AD=1.68e-14	AS=3.96e-14	PD=5.19999e-07	PS=8.59999e-07
+ fw=1.2e-07 sa=4.8e-07 sb=1.4e-07 sca=4.30195 scb=0.000337913 scc=7.93041e-08
MXI105/MPM6	XI105/net7	G10	gnd!	gnd!	g45n1svt
+ L=4.5e-08	W=2.4e-07
+ AD=1.44e-14	AS=3.96e-14	PD=5.99999e-07	PS=8.59999e-07
+ fw=2.4e-07 sa=2.575e-07 sb=2.45e-07 sca=4.03612 scb=0.00025167 scc=4.50294e-08
MXI105/MPM8	net4	net3	XI105/net7	gnd!	g45n1svt
+ L=4.5e-08	W=2.4e-07
+ AD=3.36e-14	AS=1.44e-14	PD=7.59999e-07	PS=5.99999e-07
+ fw=2.4e-07 sa=3.625e-07 sb=1.4e-07 sca=4.03612 scb=0.00025167 scc=4.50294e-08
MXI105/MPM7	net4	net1	gnd!	gnd!	g45n1svt	L=4.5e-08
+ W=1.2e-07
+ AD=1.68e-14	AS=3.96e-14	PD=5.19999e-07	PS=8.59999e-07
+ fw=1.2e-07 sa=4.8e-07 sb=1.4e-07 sca=4.30195 scb=0.000337913 scc=7.93041e-08
MXI115/MPM6	XI115/net7	G<0>	gnd!	gnd!	g45n1svt
+ L=4.5e-08	W=2.4e-07
+ AD=1.44e-14	AS=3.96e-14	PD=5.99999e-07	PS=8.59999e-07
+ fw=2.4e-07 sa=2.575e-07 sb=2.45e-07 sca=4.03612 scb=0.00025167 scc=4.50294e-08
MXI115/MPM8	net10	P<1>	XI115/net7	gnd!	g45n1svt
+ L=4.5e-08	W=2.4e-07
+ AD=3.36e-14	AS=1.44e-14	PD=7.59999e-07	PS=5.99999e-07
+ fw=2.4e-07 sa=3.625e-07 sb=1.4e-07 sca=4.03612 scb=0.00025167 scc=4.50294e-08
MXI115/MPM7	net10	G<1>	gnd!	gnd!	g45n1svt	L=4.5e-08
+ W=1.2e-07
+ AD=1.68e-14	AS=3.96e-14	PD=5.19999e-07	PS=8.59999e-07
+ fw=1.2e-07 sa=4.8e-07 sb=1.4e-07 sca=4.30195 scb=0.000337913 scc=7.93041e-08
MXI58/MNM10	sum<6>	XI58/in1_b	XI58/net3	gnd!	g45n1svt
+ L=4.5e-08	W=2.4e-07
+ AD=3.84e-14	AS=1.44e-14	PD=7.99999e-07	PS=5.99999e-07
+ fw=2.4e-07 sa=2.45e-07 sb=4.5e-07 sca=6.79033 scb=0.00366733 scc=3.70846e-05
MXI58/MNM11	XI58/net17	G50	gnd!	gnd!	g45n1svt
+ L=4.5e-08	W=2.4e-07
+ AD=1.44e-14	AS=3.36e-14	PD=5.99999e-07	PS=7.59999e-07
+ fw=2.4e-07 sa=1.4e-07 sb=5.55e-07 sca=6.79033 scb=0.00366733 scc=3.70846e-05
MXI58/MNM9	XI58/net3	XI58/in0_b	gnd!	gnd!	g45n1svt
+ L=4.5e-08	W=2.4e-07
+ AD=1.44e-14	AS=3.36e-14	PD=5.99999e-07	PS=7.59999e-07
+ fw=2.4e-07 sa=1.4e-07 sb=5.55e-07 sca=6.79033 scb=0.00366733 scc=3.70846e-05
MXI58/MNM5	XI58/in1_b	G50	gnd!	gnd!	g45n1svt
+ L=4.5e-08	W=1.2e-07
+ AD=1.68e-14	AS=1.68e-14	PD=5.19999e-07	PS=5.19999e-07
+ fw=1.2e-07 sa=1.4e-07 sb=1.4e-07 sca=3.9431 scb=0.000183837 scc=1.14832e-08
MXI58/MNM6	XI58/in0_b	P<6>	gnd!	gnd!	g45n1svt
+ L=4.5e-08	W=1.2e-07
+ AD=1.68e-14	AS=1.68e-14	PD=5.19999e-07	PS=5.19999e-07
+ fw=1.2e-07 sa=1.4e-07 sb=1.4e-07 sca=3.9431 scb=0.000183837 scc=1.14832e-08
MXI58/MNM12	sum<6>	P<6>	XI58/net17	gnd!	g45n1svt
+ L=4.5e-08	W=2.4e-07
+ AD=3.84e-14	AS=1.44e-14	PD=7.99999e-07	PS=5.99999e-07
+ fw=2.4e-07 sa=4.5e-07 sb=2.45e-07 sca=6.79033 scb=0.00366733 scc=3.70846e-05
MXI61/MNM10	sum<3>	XI61/in1_b	XI61/net3	gnd!	g45n1svt
+ L=4.5e-08	W=2.4e-07
+ AD=3.84e-14	AS=1.44e-14	PD=7.99999e-07	PS=5.99999e-07
+ fw=2.4e-07 sa=2.45e-07 sb=4.5e-07 sca=6.79033 scb=0.00366733 scc=3.70846e-05
MXI61/MNM11	XI61/net17	G20	gnd!	gnd!	g45n1svt
+ L=4.5e-08	W=2.4e-07
+ AD=1.44e-14	AS=3.36e-14	PD=5.99999e-07	PS=7.59999e-07
+ fw=2.4e-07 sa=1.4e-07 sb=5.55e-07 sca=6.79033 scb=0.00366733 scc=3.70846e-05
MXI61/MNM9	XI61/net3	XI61/in0_b	gnd!	gnd!	g45n1svt
+ L=4.5e-08	W=2.4e-07
+ AD=1.44e-14	AS=3.36e-14	PD=5.99999e-07	PS=7.59999e-07
+ fw=2.4e-07 sa=1.4e-07 sb=5.55e-07 sca=6.79033 scb=0.00366733 scc=3.70846e-05
MXI61/MNM5	XI61/in1_b	G20	gnd!	gnd!	g45n1svt
+ L=4.5e-08	W=1.2e-07
+ AD=1.68e-14	AS=1.68e-14	PD=5.19999e-07	PS=5.19999e-07
+ fw=1.2e-07 sa=1.4e-07 sb=1.4e-07 sca=3.9431 scb=0.000183837 scc=1.14832e-08
MXI61/MNM6	XI61/in0_b	P<3>	gnd!	gnd!	g45n1svt
+ L=4.5e-08	W=1.2e-07
+ AD=1.68e-14	AS=1.68e-14	PD=5.19999e-07	PS=5.19999e-07
+ fw=1.2e-07 sa=1.4e-07 sb=1.4e-07 sca=3.9431 scb=0.000183837 scc=1.14832e-08
MXI61/MNM12	sum<3>	P<3>	XI61/net17	gnd!	g45n1svt
+ L=4.5e-08	W=2.4e-07
+ AD=3.84e-14	AS=1.44e-14	PD=7.99999e-07	PS=5.99999e-07
+ fw=2.4e-07 sa=4.5e-07 sb=2.45e-07 sca=6.79033 scb=0.00366733 scc=3.70846e-05
MXI57/MNM10	sum<7>	XI57/in1_b	XI57/net3	gnd!	g45n1svt
+ L=4.5e-08	W=2.4e-07
+ AD=3.84e-14	AS=1.44e-14	PD=7.99999e-07	PS=5.99999e-07
+ fw=2.4e-07 sa=2.45e-07 sb=4.5e-07 sca=6.79033 scb=0.00366733 scc=3.70846e-05
MXI57/MNM11	XI57/net17	G60	gnd!	gnd!	g45n1svt
+ L=4.5e-08	W=2.4e-07
+ AD=1.44e-14	AS=3.36e-14	PD=5.99999e-07	PS=7.59999e-07
+ fw=2.4e-07 sa=1.4e-07 sb=5.55e-07 sca=6.79033 scb=0.00366733 scc=3.70846e-05
MXI57/MNM9	XI57/net3	XI57/in0_b	gnd!	gnd!	g45n1svt
+ L=4.5e-08	W=2.4e-07
+ AD=1.44e-14	AS=3.36e-14	PD=5.99999e-07	PS=7.59999e-07
+ fw=2.4e-07 sa=1.4e-07 sb=5.55e-07 sca=6.79033 scb=0.00366733 scc=3.70846e-05
MXI57/MNM5	XI57/in1_b	G60	gnd!	gnd!	g45n1svt
+ L=4.5e-08	W=1.2e-07
+ AD=1.68e-14	AS=1.68e-14	PD=5.19999e-07	PS=5.19999e-07
+ fw=1.2e-07 sa=1.4e-07 sb=1.4e-07 sca=3.9431 scb=0.000183837 scc=1.14832e-08
MXI57/MNM6	XI57/in0_b	P<7>	gnd!	gnd!	g45n1svt
+ L=4.5e-08	W=1.2e-07
+ AD=1.68e-14	AS=1.68e-14	PD=5.19999e-07	PS=5.19999e-07
+ fw=1.2e-07 sa=1.4e-07 sb=1.4e-07 sca=3.9431 scb=0.000183837 scc=1.14832e-08
MXI57/MNM12	sum<7>	P<7>	XI57/net17	gnd!	g45n1svt
+ L=4.5e-08	W=2.4e-07
+ AD=3.84e-14	AS=1.44e-14	PD=7.99999e-07	PS=5.99999e-07
+ fw=2.4e-07 sa=4.5e-07 sb=2.45e-07 sca=6.79033 scb=0.00366733 scc=3.70846e-05
MXI59/MNM10	sum<5>	XI59/in1_b	XI59/net3	gnd!	g45n1svt
+ L=4.5e-08	W=2.4e-07
+ AD=3.84e-14	AS=1.44e-14	PD=7.99999e-07	PS=5.99999e-07
+ fw=2.4e-07 sa=2.45e-07 sb=4.5e-07 sca=6.79033 scb=0.00366733 scc=3.70846e-05
MXI59/MNM11	XI59/net17	G40	gnd!	gnd!	g45n1svt
+ L=4.5e-08	W=2.4e-07
+ AD=1.44e-14	AS=3.36e-14	PD=5.99999e-07	PS=7.59999e-07
+ fw=2.4e-07 sa=1.4e-07 sb=5.55e-07 sca=6.79033 scb=0.00366733 scc=3.70846e-05
MXI59/MNM9	XI59/net3	XI59/in0_b	gnd!	gnd!	g45n1svt
+ L=4.5e-08	W=2.4e-07
+ AD=1.44e-14	AS=3.36e-14	PD=5.99999e-07	PS=7.59999e-07
+ fw=2.4e-07 sa=1.4e-07 sb=5.55e-07 sca=6.79033 scb=0.00366733 scc=3.70846e-05
MXI59/MNM5	XI59/in1_b	G40	gnd!	gnd!	g45n1svt
+ L=4.5e-08	W=1.2e-07
+ AD=1.68e-14	AS=1.68e-14	PD=5.19999e-07	PS=5.19999e-07
+ fw=1.2e-07 sa=1.4e-07 sb=1.4e-07 sca=3.9431 scb=0.000183837 scc=1.14832e-08
MXI59/MNM6	XI59/in0_b	P<5>	gnd!	gnd!	g45n1svt
+ L=4.5e-08	W=1.2e-07
+ AD=1.68e-14	AS=1.68e-14	PD=5.19999e-07	PS=5.19999e-07
+ fw=1.2e-07 sa=1.4e-07 sb=1.4e-07 sca=3.9431 scb=0.000183837 scc=1.14832e-08
MXI59/MNM12	sum<5>	P<5>	XI59/net17	gnd!	g45n1svt
+ L=4.5e-08	W=2.4e-07
+ AD=3.84e-14	AS=1.44e-14	PD=7.99999e-07	PS=5.99999e-07
+ fw=2.4e-07 sa=4.5e-07 sb=2.45e-07 sca=6.79033 scb=0.00366733 scc=3.70846e-05
MXI60/MNM10	sum<4>	XI60/in1_b	XI60/net3	gnd!	g45n1svt
+ L=4.5e-08	W=2.4e-07
+ AD=3.84e-14	AS=1.44e-14	PD=7.99999e-07	PS=5.99999e-07
+ fw=2.4e-07 sa=2.45e-07 sb=4.5e-07 sca=6.79033 scb=0.00366733 scc=3.70846e-05
MXI60/MNM11	XI60/net17	G30	gnd!	gnd!	g45n1svt
+ L=4.5e-08	W=2.4e-07
+ AD=1.44e-14	AS=3.36e-14	PD=5.99999e-07	PS=7.59999e-07
+ fw=2.4e-07 sa=1.4e-07 sb=5.55e-07 sca=6.79033 scb=0.00366733 scc=3.70846e-05
MXI60/MNM9	XI60/net3	XI60/in0_b	gnd!	gnd!	g45n1svt
+ L=4.5e-08	W=2.4e-07
+ AD=1.44e-14	AS=3.36e-14	PD=5.99999e-07	PS=7.59999e-07
+ fw=2.4e-07 sa=1.4e-07 sb=5.55e-07 sca=6.79033 scb=0.00366733 scc=3.70846e-05
MXI60/MNM5	XI60/in1_b	G30	gnd!	gnd!	g45n1svt
+ L=4.5e-08	W=1.2e-07
+ AD=1.68e-14	AS=1.68e-14	PD=5.19999e-07	PS=5.19999e-07
+ fw=1.2e-07 sa=1.4e-07 sb=1.4e-07 sca=3.9431 scb=0.000183837 scc=1.14832e-08
MXI60/MNM6	XI60/in0_b	P<4>	gnd!	gnd!	g45n1svt
+ L=4.5e-08	W=1.2e-07
+ AD=1.68e-14	AS=1.68e-14	PD=5.19999e-07	PS=5.19999e-07
+ fw=1.2e-07 sa=1.4e-07 sb=1.4e-07 sca=3.9431 scb=0.000183837 scc=1.14832e-08
MXI60/MNM12	sum<4>	P<4>	XI60/net17	gnd!	g45n1svt
+ L=4.5e-08	W=2.4e-07
+ AD=3.84e-14	AS=1.44e-14	PD=7.99999e-07	PS=5.99999e-07
+ fw=2.4e-07 sa=4.5e-07 sb=2.45e-07 sca=6.79033 scb=0.00366733 scc=3.70846e-05
MXI62/MNM10	sum<2>	XI62/in1_b	XI62/net3	gnd!	g45n1svt
+ L=4.5e-08	W=2.4e-07
+ AD=3.84e-14	AS=1.44e-14	PD=7.99999e-07	PS=5.99999e-07
+ fw=2.4e-07 sa=2.45e-07 sb=4.5e-07 sca=6.79033 scb=0.00366733 scc=3.70846e-05
MXI62/MNM11	XI62/net17	G10	gnd!	gnd!	g45n1svt
+ L=4.5e-08	W=2.4e-07
+ AD=1.44e-14	AS=3.36e-14	PD=5.99999e-07	PS=7.59999e-07
+ fw=2.4e-07 sa=1.4e-07 sb=5.55e-07 sca=6.79033 scb=0.00366733 scc=3.70846e-05
MXI62/MNM9	XI62/net3	XI62/in0_b	gnd!	gnd!	g45n1svt
+ L=4.5e-08	W=2.4e-07
+ AD=1.44e-14	AS=3.36e-14	PD=5.99999e-07	PS=7.59999e-07
+ fw=2.4e-07 sa=1.4e-07 sb=5.55e-07 sca=6.79033 scb=0.00366733 scc=3.70846e-05
MXI62/MNM5	XI62/in1_b	G10	gnd!	gnd!	g45n1svt
+ L=4.5e-08	W=1.2e-07
+ AD=1.68e-14	AS=1.68e-14	PD=5.19999e-07	PS=5.19999e-07
+ fw=1.2e-07 sa=1.4e-07 sb=1.4e-07 sca=3.9431 scb=0.000183837 scc=1.14832e-08
MXI62/MNM6	XI62/in0_b	P<2>	gnd!	gnd!	g45n1svt
+ L=4.5e-08	W=1.2e-07
+ AD=1.68e-14	AS=1.68e-14	PD=5.19999e-07	PS=5.19999e-07
+ fw=1.2e-07 sa=1.4e-07 sb=1.4e-07 sca=3.9431 scb=0.000183837 scc=1.14832e-08
MXI62/MNM12	sum<2>	P<2>	XI62/net17	gnd!	g45n1svt
+ L=4.5e-08	W=2.4e-07
+ AD=3.84e-14	AS=1.44e-14	PD=7.99999e-07	PS=5.99999e-07
+ fw=2.4e-07 sa=4.5e-07 sb=2.45e-07 sca=6.79033 scb=0.00366733 scc=3.70846e-05
MXI63/MNM10	sum<1>	XI63/in1_b	XI63/net3	gnd!	g45n1svt
+ L=4.5e-08	W=2.4e-07
+ AD=3.84e-14	AS=1.44e-14	PD=7.99999e-07	PS=5.99999e-07
+ fw=2.4e-07 sa=2.45e-07 sb=4.5e-07 sca=6.79033 scb=0.00366733 scc=3.70846e-05
MXI63/MNM11	XI63/net17	G<0>	gnd!	gnd!	g45n1svt
+ L=4.5e-08	W=2.4e-07
+ AD=1.44e-14	AS=3.36e-14	PD=5.99999e-07	PS=7.59999e-07
+ fw=2.4e-07 sa=1.4e-07 sb=5.55e-07 sca=6.79033 scb=0.00366733 scc=3.70846e-05
MXI63/MNM9	XI63/net3	XI63/in0_b	gnd!	gnd!	g45n1svt
+ L=4.5e-08	W=2.4e-07
+ AD=1.44e-14	AS=3.36e-14	PD=5.99999e-07	PS=7.59999e-07
+ fw=2.4e-07 sa=1.4e-07 sb=5.55e-07 sca=6.79033 scb=0.00366733 scc=3.70846e-05
MXI63/MNM5	XI63/in1_b	G<0>	gnd!	gnd!	g45n1svt
+ L=4.5e-08	W=1.2e-07
+ AD=1.68e-14	AS=1.68e-14	PD=5.19999e-07	PS=5.19999e-07
+ fw=1.2e-07 sa=1.4e-07 sb=1.4e-07 sca=3.9431 scb=0.000183837 scc=1.14832e-08
MXI63/MNM6	XI63/in0_b	P<1>	gnd!	gnd!	g45n1svt
+ L=4.5e-08	W=1.2e-07
+ AD=1.68e-14	AS=1.68e-14	PD=5.19999e-07	PS=5.19999e-07
+ fw=1.2e-07 sa=1.4e-07 sb=1.4e-07 sca=3.9431 scb=0.000183837 scc=1.14832e-08
MXI63/MNM12	sum<1>	P<1>	XI63/net17	gnd!	g45n1svt
+ L=4.5e-08	W=2.4e-07
+ AD=3.84e-14	AS=1.44e-14	PD=7.99999e-07	PS=5.99999e-07
+ fw=2.4e-07 sa=4.5e-07 sb=2.45e-07 sca=6.79033 scb=0.00366733 scc=3.70846e-05
MXI146/MNM10	sum<0>	XI146/in1_b	XI146/net3	gnd!	g45n1svt
+ L=4.5e-08	W=2.4e-07
+ AD=3.84e-14	AS=1.44e-14	PD=7.99999e-07	PS=5.99999e-07
+ fw=2.4e-07 sa=2.45e-07 sb=4.5e-07 sca=6.79033 scb=0.00366733 scc=3.70846e-05
MXI146/MNM11	XI146/net17	in1<0>	gnd!	gnd!	g45n1svt
+ L=4.5e-08	W=2.4e-07
+ AD=1.44e-14	AS=3.36e-14	PD=5.99999e-07	PS=7.59999e-07
+ fw=2.4e-07 sa=1.4e-07 sb=5.55e-07 sca=6.79033 scb=0.00366733 scc=3.70846e-05
MXI146/MNM9	XI146/net3	XI146/in0_b	gnd!	gnd!	g45n1svt
+ L=4.5e-08	W=2.4e-07
+ AD=1.44e-14	AS=3.36e-14	PD=5.99999e-07	PS=7.59999e-07
+ fw=2.4e-07 sa=1.4e-07 sb=5.55e-07 sca=6.79033 scb=0.00366733 scc=3.70846e-05
MXI146/MNM5	XI146/in1_b	in1<0>	gnd!	gnd!	g45n1svt
+ L=4.5e-08	W=1.2e-07
+ AD=1.68e-14	AS=1.68e-14	PD=5.19999e-07	PS=5.19999e-07
+ fw=1.2e-07 sa=1.4e-07 sb=1.4e-07 sca=3.9431 scb=0.000183837 scc=1.14832e-08
MXI146/MNM6	XI146/in0_b	in0<0>	gnd!	gnd!	g45n1svt
+ L=4.5e-08	W=1.2e-07
+ AD=1.68e-14	AS=1.68e-14	PD=5.19999e-07	PS=5.19999e-07
+ fw=1.2e-07 sa=1.4e-07 sb=1.4e-07 sca=3.9431 scb=0.000183837 scc=1.14832e-08
MXI146/MNM12	sum<0>	in0<0>	XI146/net17	gnd!	g45n1svt
+ L=4.5e-08	W=2.4e-07
+ AD=3.84e-14	AS=1.44e-14	PD=7.99999e-07	PS=5.99999e-07
+ fw=2.4e-07 sa=4.5e-07 sb=2.45e-07 sca=6.79033 scb=0.00366733 scc=3.70846e-05
MXI142/MNM10	P<4>	XI142/in1_b	XI142/net3	gnd!	g45n1svt
+ L=4.5e-08	W=2.4e-07
+ AD=3.84e-14	AS=1.44e-14	PD=7.99999e-07	PS=5.99999e-07
+ fw=2.4e-07 sa=2.45e-07 sb=4.5e-07 sca=6.79033 scb=0.00366733 scc=3.70846e-05
MXI142/MNM11	XI142/net17	in1<4>	gnd!	gnd!	g45n1svt
+ L=4.5e-08	W=2.4e-07
+ AD=1.44e-14	AS=3.36e-14	PD=5.99999e-07	PS=7.59999e-07
+ fw=2.4e-07 sa=1.4e-07 sb=5.55e-07 sca=6.79033 scb=0.00366733 scc=3.70846e-05
MXI142/MNM9	XI142/net3	XI142/in0_b	gnd!	gnd!	g45n1svt
+ L=4.5e-08	W=2.4e-07
+ AD=1.44e-14	AS=3.36e-14	PD=5.99999e-07	PS=7.59999e-07
+ fw=2.4e-07 sa=1.4e-07 sb=5.55e-07 sca=6.79033 scb=0.00366733 scc=3.70846e-05
MXI142/MNM5	XI142/in1_b	in1<4>	gnd!	gnd!	g45n1svt
+ L=4.5e-08	W=1.2e-07
+ AD=1.68e-14	AS=1.68e-14	PD=5.19999e-07	PS=5.19999e-07
+ fw=1.2e-07 sa=1.4e-07 sb=1.4e-07 sca=3.9431 scb=0.000183837 scc=1.14832e-08
MXI142/MNM6	XI142/in0_b	in0<4>	gnd!	gnd!	g45n1svt
+ L=4.5e-08	W=1.2e-07
+ AD=1.68e-14	AS=1.68e-14	PD=5.19999e-07	PS=5.19999e-07
+ fw=1.2e-07 sa=1.4e-07 sb=1.4e-07 sca=3.9431 scb=0.000183837 scc=1.14832e-08
MXI142/MNM12	P<4>	in0<4>	XI142/net17	gnd!	g45n1svt
+ L=4.5e-08	W=2.4e-07
+ AD=3.84e-14	AS=1.44e-14	PD=7.99999e-07	PS=5.99999e-07
+ fw=2.4e-07 sa=4.5e-07 sb=2.45e-07 sca=6.79033 scb=0.00366733 scc=3.70846e-05
MXI140/MNM10	P<6>	XI140/in1_b	XI140/net3	gnd!	g45n1svt
+ L=4.5e-08	W=2.4e-07
+ AD=3.84e-14	AS=1.44e-14	PD=7.99999e-07	PS=5.99999e-07
+ fw=2.4e-07 sa=2.45e-07 sb=4.5e-07 sca=6.79033 scb=0.00366733 scc=3.70846e-05
MXI140/MNM11	XI140/net17	in1<6>	gnd!	gnd!	g45n1svt
+ L=4.5e-08	W=2.4e-07
+ AD=1.44e-14	AS=3.36e-14	PD=5.99999e-07	PS=7.59999e-07
+ fw=2.4e-07 sa=1.4e-07 sb=5.55e-07 sca=6.79033 scb=0.00366733 scc=3.70846e-05
MXI140/MNM9	XI140/net3	XI140/in0_b	gnd!	gnd!	g45n1svt
+ L=4.5e-08	W=2.4e-07
+ AD=1.44e-14	AS=3.36e-14	PD=5.99999e-07	PS=7.59999e-07
+ fw=2.4e-07 sa=1.4e-07 sb=5.55e-07 sca=6.79033 scb=0.00366733 scc=3.70846e-05
MXI140/MNM5	XI140/in1_b	in1<6>	gnd!	gnd!	g45n1svt
+ L=4.5e-08	W=1.2e-07
+ AD=1.68e-14	AS=1.68e-14	PD=5.19999e-07	PS=5.19999e-07
+ fw=1.2e-07 sa=1.4e-07 sb=1.4e-07 sca=3.9431 scb=0.000183837 scc=1.14832e-08
MXI140/MNM6	XI140/in0_b	in0<6>	gnd!	gnd!	g45n1svt
+ L=4.5e-08	W=1.2e-07
+ AD=1.68e-14	AS=1.68e-14	PD=5.19999e-07	PS=5.19999e-07
+ fw=1.2e-07 sa=1.4e-07 sb=1.4e-07 sca=3.9431 scb=0.000183837 scc=1.14832e-08
MXI140/MNM12	P<6>	in0<6>	XI140/net17	gnd!	g45n1svt
+ L=4.5e-08	W=2.4e-07
+ AD=3.84e-14	AS=1.44e-14	PD=7.99999e-07	PS=5.99999e-07
+ fw=2.4e-07 sa=4.5e-07 sb=2.45e-07 sca=6.79033 scb=0.00366733 scc=3.70846e-05
MXI143/MNM10	P<3>	XI143/in1_b	XI143/net3	gnd!	g45n1svt
+ L=4.5e-08	W=2.4e-07
+ AD=3.84e-14	AS=1.44e-14	PD=7.99999e-07	PS=5.99999e-07
+ fw=2.4e-07 sa=2.45e-07 sb=4.5e-07 sca=6.79033 scb=0.00366733 scc=3.70846e-05
MXI143/MNM11	XI143/net17	in1<3>	gnd!	gnd!	g45n1svt
+ L=4.5e-08	W=2.4e-07
+ AD=1.44e-14	AS=3.36e-14	PD=5.99999e-07	PS=7.59999e-07
+ fw=2.4e-07 sa=1.4e-07 sb=5.55e-07 sca=6.79033 scb=0.00366733 scc=3.70846e-05
MXI143/MNM9	XI143/net3	XI143/in0_b	gnd!	gnd!	g45n1svt
+ L=4.5e-08	W=2.4e-07
+ AD=1.44e-14	AS=3.36e-14	PD=5.99999e-07	PS=7.59999e-07
+ fw=2.4e-07 sa=1.4e-07 sb=5.55e-07 sca=6.79033 scb=0.00366733 scc=3.70846e-05
MXI143/MNM5	XI143/in1_b	in1<3>	gnd!	gnd!	g45n1svt
+ L=4.5e-08	W=1.2e-07
+ AD=1.68e-14	AS=1.68e-14	PD=5.19999e-07	PS=5.19999e-07
+ fw=1.2e-07 sa=1.4e-07 sb=1.4e-07 sca=3.9431 scb=0.000183837 scc=1.14832e-08
MXI143/MNM6	XI143/in0_b	in0<3>	gnd!	gnd!	g45n1svt
+ L=4.5e-08	W=1.2e-07
+ AD=1.68e-14	AS=1.68e-14	PD=5.19999e-07	PS=5.19999e-07
+ fw=1.2e-07 sa=1.4e-07 sb=1.4e-07 sca=3.9431 scb=0.000183837 scc=1.14832e-08
MXI143/MNM12	P<3>	in0<3>	XI143/net17	gnd!	g45n1svt
+ L=4.5e-08	W=2.4e-07
+ AD=3.84e-14	AS=1.44e-14	PD=7.99999e-07	PS=5.99999e-07
+ fw=2.4e-07 sa=4.5e-07 sb=2.45e-07 sca=6.79033 scb=0.00366733 scc=3.70846e-05
MXI145/MNM10	P<1>	XI145/in1_b	XI145/net3	gnd!	g45n1svt
+ L=4.5e-08	W=2.4e-07
+ AD=3.84e-14	AS=1.44e-14	PD=7.99999e-07	PS=5.99999e-07
+ fw=2.4e-07 sa=2.45e-07 sb=4.5e-07 sca=6.79033 scb=0.00366733 scc=3.70846e-05
MXI145/MNM11	XI145/net17	in1<1>	gnd!	gnd!	g45n1svt
+ L=4.5e-08	W=2.4e-07
+ AD=1.44e-14	AS=3.36e-14	PD=5.99999e-07	PS=7.59999e-07
+ fw=2.4e-07 sa=1.4e-07 sb=5.55e-07 sca=6.79033 scb=0.00366733 scc=3.70846e-05
MXI145/MNM9	XI145/net3	XI145/in0_b	gnd!	gnd!	g45n1svt
+ L=4.5e-08	W=2.4e-07
+ AD=1.44e-14	AS=3.36e-14	PD=5.99999e-07	PS=7.59999e-07
+ fw=2.4e-07 sa=1.4e-07 sb=5.55e-07 sca=6.79033 scb=0.00366733 scc=3.70846e-05
MXI145/MNM5	XI145/in1_b	in1<1>	gnd!	gnd!	g45n1svt
+ L=4.5e-08	W=1.2e-07
+ AD=1.68e-14	AS=1.68e-14	PD=5.19999e-07	PS=5.19999e-07
+ fw=1.2e-07 sa=1.4e-07 sb=1.4e-07 sca=3.9431 scb=0.000183837 scc=1.14832e-08
MXI145/MNM6	XI145/in0_b	in0<1>	gnd!	gnd!	g45n1svt
+ L=4.5e-08	W=1.2e-07
+ AD=1.68e-14	AS=1.68e-14	PD=5.19999e-07	PS=5.19999e-07
+ fw=1.2e-07 sa=1.4e-07 sb=1.4e-07 sca=3.9431 scb=0.000183837 scc=1.14832e-08
MXI145/MNM12	P<1>	in0<1>	XI145/net17	gnd!	g45n1svt
+ L=4.5e-08	W=2.4e-07
+ AD=3.84e-14	AS=1.44e-14	PD=7.99999e-07	PS=5.99999e-07
+ fw=2.4e-07 sa=4.5e-07 sb=2.45e-07 sca=6.79033 scb=0.00366733 scc=3.70846e-05
MXI139/MNM10	P<7>	XI139/in1_b	XI139/net3	gnd!	g45n1svt
+ L=4.5e-08	W=2.4e-07
+ AD=3.84e-14	AS=1.44e-14	PD=7.99999e-07	PS=5.99999e-07
+ fw=2.4e-07 sa=2.45e-07 sb=4.5e-07 sca=6.79033 scb=0.00366733 scc=3.70846e-05
MXI139/MNM11	XI139/net17	in1<7>	gnd!	gnd!	g45n1svt
+ L=4.5e-08	W=2.4e-07
+ AD=1.44e-14	AS=3.36e-14	PD=5.99999e-07	PS=7.59999e-07
+ fw=2.4e-07 sa=1.4e-07 sb=5.55e-07 sca=6.79033 scb=0.00366733 scc=3.70846e-05
MXI139/MNM9	XI139/net3	XI139/in0_b	gnd!	gnd!	g45n1svt
+ L=4.5e-08	W=2.4e-07
+ AD=1.44e-14	AS=3.36e-14	PD=5.99999e-07	PS=7.59999e-07
+ fw=2.4e-07 sa=1.4e-07 sb=5.55e-07 sca=6.79033 scb=0.00366733 scc=3.70846e-05
MXI139/MNM5	XI139/in1_b	in1<7>	gnd!	gnd!	g45n1svt
+ L=4.5e-08	W=1.2e-07
+ AD=1.68e-14	AS=1.68e-14	PD=5.19999e-07	PS=5.19999e-07
+ fw=1.2e-07 sa=1.4e-07 sb=1.4e-07 sca=3.9431 scb=0.000183837 scc=1.14832e-08
MXI139/MNM6	XI139/in0_b	in0<7>	gnd!	gnd!	g45n1svt
+ L=4.5e-08	W=1.2e-07
+ AD=1.68e-14	AS=1.68e-14	PD=5.19999e-07	PS=5.19999e-07
+ fw=1.2e-07 sa=1.4e-07 sb=1.4e-07 sca=3.9431 scb=0.000183837 scc=1.14832e-08
MXI139/MNM12	P<7>	in0<7>	XI139/net17	gnd!	g45n1svt
+ L=4.5e-08	W=2.4e-07
+ AD=3.84e-14	AS=1.44e-14	PD=7.99999e-07	PS=5.99999e-07
+ fw=2.4e-07 sa=4.5e-07 sb=2.45e-07 sca=6.79033 scb=0.00366733 scc=3.70846e-05
MXI141/MNM10	P<5>	XI141/in1_b	XI141/net3	gnd!	g45n1svt
+ L=4.5e-08	W=2.4e-07
+ AD=3.84e-14	AS=1.44e-14	PD=7.99999e-07	PS=5.99999e-07
+ fw=2.4e-07 sa=2.45e-07 sb=4.5e-07 sca=6.79033 scb=0.00366733 scc=3.70846e-05
MXI141/MNM11	XI141/net17	in1<5>	gnd!	gnd!	g45n1svt
+ L=4.5e-08	W=2.4e-07
+ AD=1.44e-14	AS=3.36e-14	PD=5.99999e-07	PS=7.59999e-07
+ fw=2.4e-07 sa=1.4e-07 sb=5.55e-07 sca=6.79033 scb=0.00366733 scc=3.70846e-05
MXI141/MNM9	XI141/net3	XI141/in0_b	gnd!	gnd!	g45n1svt
+ L=4.5e-08	W=2.4e-07
+ AD=1.44e-14	AS=3.36e-14	PD=5.99999e-07	PS=7.59999e-07
+ fw=2.4e-07 sa=1.4e-07 sb=5.55e-07 sca=6.79033 scb=0.00366733 scc=3.70846e-05
MXI141/MNM5	XI141/in1_b	in1<5>	gnd!	gnd!	g45n1svt
+ L=4.5e-08	W=1.2e-07
+ AD=1.68e-14	AS=1.68e-14	PD=5.19999e-07	PS=5.19999e-07
+ fw=1.2e-07 sa=1.4e-07 sb=1.4e-07 sca=3.9431 scb=0.000183837 scc=1.14832e-08
MXI141/MNM6	XI141/in0_b	in0<5>	gnd!	gnd!	g45n1svt
+ L=4.5e-08	W=1.2e-07
+ AD=1.68e-14	AS=1.68e-14	PD=5.19999e-07	PS=5.19999e-07
+ fw=1.2e-07 sa=1.4e-07 sb=1.4e-07 sca=3.9431 scb=0.000183837 scc=1.14832e-08
MXI141/MNM12	P<5>	in0<5>	XI141/net17	gnd!	g45n1svt
+ L=4.5e-08	W=2.4e-07
+ AD=3.84e-14	AS=1.44e-14	PD=7.99999e-07	PS=5.99999e-07
+ fw=2.4e-07 sa=4.5e-07 sb=2.45e-07 sca=6.79033 scb=0.00366733 scc=3.70846e-05
MXI144/MNM10	P<2>	XI144/in1_b	XI144/net3	gnd!	g45n1svt
+ L=4.5e-08	W=2.4e-07
+ AD=3.84e-14	AS=1.44e-14	PD=7.99999e-07	PS=5.99999e-07
+ fw=2.4e-07 sa=2.45e-07 sb=4.5e-07 sca=6.79033 scb=0.00366733 scc=3.70846e-05
MXI144/MNM11	XI144/net17	in1<2>	gnd!	gnd!	g45n1svt
+ L=4.5e-08	W=2.4e-07
+ AD=1.44e-14	AS=3.36e-14	PD=5.99999e-07	PS=7.59999e-07
+ fw=2.4e-07 sa=1.4e-07 sb=5.55e-07 sca=6.79033 scb=0.00366733 scc=3.70846e-05
MXI144/MNM9	XI144/net3	XI144/in0_b	gnd!	gnd!	g45n1svt
+ L=4.5e-08	W=2.4e-07
+ AD=1.44e-14	AS=3.36e-14	PD=5.99999e-07	PS=7.59999e-07
+ fw=2.4e-07 sa=1.4e-07 sb=5.55e-07 sca=6.79033 scb=0.00366733 scc=3.70846e-05
MXI144/MNM5	XI144/in1_b	in1<2>	gnd!	gnd!	g45n1svt
+ L=4.5e-08	W=1.2e-07
+ AD=1.68e-14	AS=1.68e-14	PD=5.19999e-07	PS=5.19999e-07
+ fw=1.2e-07 sa=1.4e-07 sb=1.4e-07 sca=3.9431 scb=0.000183837 scc=1.14832e-08
MXI144/MNM6	XI144/in0_b	in0<2>	gnd!	gnd!	g45n1svt
+ L=4.5e-08	W=1.2e-07
+ AD=1.68e-14	AS=1.68e-14	PD=5.19999e-07	PS=5.19999e-07
+ fw=1.2e-07 sa=1.4e-07 sb=1.4e-07 sca=3.9431 scb=0.000183837 scc=1.14832e-08
MXI144/MNM12	P<2>	in0<2>	XI144/net17	gnd!	g45n1svt
+ L=4.5e-08	W=2.4e-07
+ AD=3.84e-14	AS=1.44e-14	PD=7.99999e-07	PS=5.99999e-07
+ fw=2.4e-07 sa=4.5e-07 sb=2.45e-07 sca=6.79033 scb=0.00366733 scc=3.70846e-05
MXI134/MNM3	G<4>	XI134/out_b	gnd!	gnd!	g45n1svt
+ L=4.5e-08	W=1.2e-07
+ AD=1.68e-14	AS=1.68e-14	PD=5.19999e-07	PS=5.19999e-07
+ fw=1.2e-07 sa=1.4e-07 sb=1.4e-07 sca=3.9431 scb=0.000183837 scc=1.14832e-08
MXI134/MNM4	XI134/net1	in1<4>	gnd!	gnd!	g45n1svt
+ L=4.5e-08	W=2.4e-07
+ AD=3.84e-14	AS=3.36e-14	PD=7.99999e-07	PS=7.59999e-07
+ fw=2.4e-07 sa=1.4e-07 sb=3.45e-07 sca=4.95247 scb=0.000984263 scc=1.72105e-06
MXI134/MNM5	XI134/out_b	in0<4>	XI134/net1	gnd!	g45n1svt
+ L=4.5e-08	W=2.4e-07
+ AD=3.36e-14	AS=3.84e-14	PD=7.59999e-07	PS=7.99999e-07
+ fw=2.4e-07 sa=3.45e-07 sb=1.4e-07 sca=4.95247 scb=0.000984263 scc=1.72105e-06
MXI138/MNM3	G<0>	XI138/out_b	gnd!	gnd!	g45n1svt
+ L=4.5e-08	W=1.2e-07
+ AD=1.68e-14	AS=1.68e-14	PD=5.19999e-07	PS=5.19999e-07
+ fw=1.2e-07 sa=1.4e-07 sb=1.4e-07 sca=3.9431 scb=0.000183837 scc=1.14832e-08
MXI138/MNM4	XI138/net1	in1<0>	gnd!	gnd!	g45n1svt
+ L=4.5e-08	W=2.4e-07
+ AD=3.84e-14	AS=3.36e-14	PD=7.99999e-07	PS=7.59999e-07
+ fw=2.4e-07 sa=1.4e-07 sb=3.45e-07 sca=4.95247 scb=0.000984263 scc=1.72105e-06
MXI138/MNM5	XI138/out_b	in0<0>	XI138/net1	gnd!	g45n1svt
+ L=4.5e-08	W=2.4e-07
+ AD=3.36e-14	AS=3.84e-14	PD=7.59999e-07	PS=7.99999e-07
+ fw=2.4e-07 sa=3.45e-07 sb=1.4e-07 sca=4.95247 scb=0.000984263 scc=1.72105e-06
MXI133/MNM3	G<5>	XI133/out_b	gnd!	gnd!	g45n1svt
+ L=4.5e-08	W=1.2e-07
+ AD=1.68e-14	AS=1.68e-14	PD=5.19999e-07	PS=5.19999e-07
+ fw=1.2e-07 sa=1.4e-07 sb=1.4e-07 sca=3.9431 scb=0.000183837 scc=1.14832e-08
MXI133/MNM4	XI133/net1	in1<5>	gnd!	gnd!	g45n1svt
+ L=4.5e-08	W=2.4e-07
+ AD=3.84e-14	AS=3.36e-14	PD=7.99999e-07	PS=7.59999e-07
+ fw=2.4e-07 sa=1.4e-07 sb=3.45e-07 sca=4.95247 scb=0.000984263 scc=1.72105e-06
MXI133/MNM5	XI133/out_b	in0<5>	XI133/net1	gnd!	g45n1svt
+ L=4.5e-08	W=2.4e-07
+ AD=3.36e-14	AS=3.84e-14	PD=7.59999e-07	PS=7.99999e-07
+ fw=2.4e-07 sa=3.45e-07 sb=1.4e-07 sca=4.95247 scb=0.000984263 scc=1.72105e-06
MXI137/MNM3	G<1>	XI137/out_b	gnd!	gnd!	g45n1svt
+ L=4.5e-08	W=1.2e-07
+ AD=1.68e-14	AS=1.68e-14	PD=5.19999e-07	PS=5.19999e-07
+ fw=1.2e-07 sa=1.4e-07 sb=1.4e-07 sca=3.9431 scb=0.000183837 scc=1.14832e-08
MXI137/MNM4	XI137/net1	in1<1>	gnd!	gnd!	g45n1svt
+ L=4.5e-08	W=2.4e-07
+ AD=3.84e-14	AS=3.36e-14	PD=7.99999e-07	PS=7.59999e-07
+ fw=2.4e-07 sa=1.4e-07 sb=3.45e-07 sca=4.95247 scb=0.000984263 scc=1.72105e-06
MXI137/MNM5	XI137/out_b	in0<1>	XI137/net1	gnd!	g45n1svt
+ L=4.5e-08	W=2.4e-07
+ AD=3.36e-14	AS=3.84e-14	PD=7.59999e-07	PS=7.99999e-07
+ fw=2.4e-07 sa=3.45e-07 sb=1.4e-07 sca=4.95247 scb=0.000984263 scc=1.72105e-06
MXI131/MNM3	G<7>	XI131/out_b	gnd!	gnd!	g45n1svt
+ L=4.5e-08	W=1.2e-07
+ AD=1.68e-14	AS=1.68e-14	PD=5.19999e-07	PS=5.19999e-07
+ fw=1.2e-07 sa=1.4e-07 sb=1.4e-07 sca=3.9431 scb=0.000183837 scc=1.14832e-08
MXI131/MNM4	XI131/net1	in1<7>	gnd!	gnd!	g45n1svt
+ L=4.5e-08	W=2.4e-07
+ AD=3.84e-14	AS=3.36e-14	PD=7.99999e-07	PS=7.59999e-07
+ fw=2.4e-07 sa=1.4e-07 sb=3.45e-07 sca=4.95247 scb=0.000984263 scc=1.72105e-06
MXI131/MNM5	XI131/out_b	in0<7>	XI131/net1	gnd!	g45n1svt
+ L=4.5e-08	W=2.4e-07
+ AD=3.36e-14	AS=3.84e-14	PD=7.59999e-07	PS=7.99999e-07
+ fw=2.4e-07 sa=3.45e-07 sb=1.4e-07 sca=4.95247 scb=0.000984263 scc=1.72105e-06
MXI132/MNM3	G<6>	XI132/out_b	gnd!	gnd!	g45n1svt
+ L=4.5e-08	W=1.2e-07
+ AD=1.68e-14	AS=1.68e-14	PD=5.19999e-07	PS=5.19999e-07
+ fw=1.2e-07 sa=1.4e-07 sb=1.4e-07 sca=3.9431 scb=0.000183837 scc=1.14832e-08
MXI132/MNM4	XI132/net1	in1<6>	gnd!	gnd!	g45n1svt
+ L=4.5e-08	W=2.4e-07
+ AD=3.84e-14	AS=3.36e-14	PD=7.99999e-07	PS=7.59999e-07
+ fw=2.4e-07 sa=1.4e-07 sb=3.45e-07 sca=4.95247 scb=0.000984263 scc=1.72105e-06
MXI132/MNM5	XI132/out_b	in0<6>	XI132/net1	gnd!	g45n1svt
+ L=4.5e-08	W=2.4e-07
+ AD=3.36e-14	AS=3.84e-14	PD=7.59999e-07	PS=7.99999e-07
+ fw=2.4e-07 sa=3.45e-07 sb=1.4e-07 sca=4.95247 scb=0.000984263 scc=1.72105e-06
MXI135/MNM3	G<3>	XI135/out_b	gnd!	gnd!	g45n1svt
+ L=4.5e-08	W=1.2e-07
+ AD=1.68e-14	AS=1.68e-14	PD=5.19999e-07	PS=5.19999e-07
+ fw=1.2e-07 sa=1.4e-07 sb=1.4e-07 sca=3.9431 scb=0.000183837 scc=1.14832e-08
MXI135/MNM4	XI135/net1	in1<3>	gnd!	gnd!	g45n1svt
+ L=4.5e-08	W=2.4e-07
+ AD=3.84e-14	AS=3.36e-14	PD=7.99999e-07	PS=7.59999e-07
+ fw=2.4e-07 sa=1.4e-07 sb=3.45e-07 sca=4.95247 scb=0.000984263 scc=1.72105e-06
MXI135/MNM5	XI135/out_b	in0<3>	XI135/net1	gnd!	g45n1svt
+ L=4.5e-08	W=2.4e-07
+ AD=3.36e-14	AS=3.84e-14	PD=7.59999e-07	PS=7.99999e-07
+ fw=2.4e-07 sa=3.45e-07 sb=1.4e-07 sca=4.95247 scb=0.000984263 scc=1.72105e-06
MXI136/MNM3	G<2>	XI136/out_b	gnd!	gnd!	g45n1svt
+ L=4.5e-08	W=1.2e-07
+ AD=1.68e-14	AS=1.68e-14	PD=5.19999e-07	PS=5.19999e-07
+ fw=1.2e-07 sa=1.4e-07 sb=1.4e-07 sca=3.9431 scb=0.000183837 scc=1.14832e-08
MXI136/MNM4	XI136/net1	in1<2>	gnd!	gnd!	g45n1svt
+ L=4.5e-08	W=2.4e-07
+ AD=3.84e-14	AS=3.36e-14	PD=7.99999e-07	PS=7.59999e-07
+ fw=2.4e-07 sa=1.4e-07 sb=3.45e-07 sca=4.95247 scb=0.000984263 scc=1.72105e-06
MXI136/MNM5	XI136/out_b	in0<2>	XI136/net1	gnd!	g45n1svt
+ L=4.5e-08	W=2.4e-07
+ AD=3.36e-14	AS=3.84e-14	PD=7.59999e-07	PS=7.99999e-07
+ fw=2.4e-07 sa=3.45e-07 sb=1.4e-07 sca=4.95247 scb=0.000984263 scc=1.72105e-06
MXI77/MNM0	G20	net9	gnd!	gnd!	g45n1svt	L=4.5e-08
+ W=1.2e-07
+ AD=1.68e-14	AS=1.68e-14	PD=5.19999e-07	PS=5.19999e-07
+ fw=1.2e-07 sa=1.4e-07 sb=1.4e-07 sca=4.13423 scb=0.000254067 scc=3.31832e-08
MXI79/MNM0	G60	net34	gnd!	gnd!	g45n1svt	L=4.5e-08
+ W=1.2e-07
+ AD=1.68e-14	AS=1.68e-14	PD=5.19999e-07	PS=5.19999e-07
+ fw=1.2e-07 sa=1.4e-07 sb=1.4e-07 sca=4.13423 scb=0.000254067 scc=3.31832e-08
MXI81/MNM0	G40	net20	gnd!	gnd!	g45n1svt	L=4.5e-08
+ W=1.2e-07
+ AD=1.68e-14	AS=1.68e-14	PD=5.19999e-07	PS=5.19999e-07
+ fw=1.2e-07 sa=1.4e-07 sb=1.4e-07 sca=4.13423 scb=0.000254067 scc=3.31832e-08
MXI87/MNM0	net7	net5	gnd!	gnd!	g45n1svt	L=4.5e-08
+ W=1.2e-07
+ AD=1.68e-14	AS=1.68e-14	PD=5.19999e-07	PS=5.19999e-07
+ fw=1.2e-07 sa=1.4e-07 sb=1.4e-07 sca=4.13423 scb=0.000254067 scc=3.31832e-08
MXI80/MNM0	G50	net15	gnd!	gnd!	g45n1svt	L=4.5e-08
+ W=1.2e-07
+ AD=1.68e-14	AS=1.68e-14	PD=5.19999e-07	PS=5.19999e-07
+ fw=1.2e-07 sa=1.4e-07 sb=1.4e-07 sca=4.13423 scb=0.000254067 scc=3.31832e-08
MXI76__4/MNM0	G30	net4	gnd!	gnd!	g45n1svt	L=4.5e-08
+ W=1.2e-07
+ AD=1.68e-14	AS=1.68e-14	PD=5.19999e-07	PS=5.19999e-07
+ fw=1.2e-07 sa=1.4e-07 sb=1.4e-07 sca=4.13423 scb=0.000254067 scc=3.31832e-08
MXI76__3/MNM0	G30	net4	gnd!	gnd!	g45n1svt	L=4.5e-08
+ W=1.2e-07
+ AD=1.68e-14	AS=1.68e-14	PD=5.19999e-07	PS=5.19999e-07
+ fw=1.2e-07 sa=1.4e-07 sb=1.4e-07 sca=4.13423 scb=0.000254067 scc=3.31832e-08
MXI73/MNM0	net28	net27	gnd!	gnd!	g45n1svt	L=4.5e-08
+ W=1.2e-07
+ AD=1.68e-14	AS=1.68e-14	PD=5.19999e-07	PS=5.19999e-07
+ fw=1.2e-07 sa=1.4e-07 sb=1.4e-07 sca=4.13423 scb=0.000254067 scc=3.31832e-08
MXI74/MNM0	net36	net35	gnd!	gnd!	g45n1svt	L=4.5e-08
+ W=1.2e-07
+ AD=1.68e-14	AS=1.68e-14	PD=5.19999e-07	PS=5.19999e-07
+ fw=1.2e-07 sa=1.4e-07 sb=1.4e-07 sca=4.13423 scb=0.000254067 scc=3.31832e-08
MXI76__2/MNM0	G30	net4	gnd!	gnd!	g45n1svt	L=4.5e-08
+ W=1.2e-07
+ AD=1.68e-14	AS=1.68e-14	PD=5.19999e-07	PS=5.19999e-07
+ fw=1.2e-07 sa=1.4e-07 sb=1.4e-07 sca=4.13423 scb=0.000254067 scc=3.31832e-08
MXI72/MNM0	net22	net21	gnd!	gnd!	g45n1svt	L=4.5e-08
+ W=1.2e-07
+ AD=1.68e-14	AS=1.68e-14	PD=5.19999e-07	PS=5.19999e-07
+ fw=1.2e-07 sa=1.4e-07 sb=1.4e-07 sca=4.13423 scb=0.000254067 scc=3.31832e-08
MXI75/MNM0	net32	net31	gnd!	gnd!	g45n1svt	L=4.5e-08
+ W=1.2e-07
+ AD=1.68e-14	AS=1.68e-14	PD=5.19999e-07	PS=5.19999e-07
+ fw=1.2e-07 sa=1.4e-07 sb=1.4e-07 sca=4.13423 scb=0.000254067 scc=3.31832e-08
MXI67__2/MNM0	net16	net17	gnd!	gnd!	g45n1svt	L=4.5e-08
+ W=1.2e-07
+ AD=1.68e-14	AS=1.68e-14	PD=5.19999e-07	PS=5.19999e-07
+ fw=1.2e-07 sa=1.4e-07 sb=1.4e-07 sca=4.13423 scb=0.000254067 scc=3.31832e-08
MXI76/MNM0	G30	net4	gnd!	gnd!	g45n1svt	L=4.5e-08
+ W=1.2e-07
+ AD=1.68e-14	AS=1.68e-14	PD=5.19999e-07	PS=5.19999e-07
+ fw=1.2e-07 sa=1.4e-07 sb=1.4e-07 sca=4.13423 scb=0.000254067 scc=3.31832e-08
MXI70/MNM0	G10	net10	gnd!	gnd!	g45n1svt	L=4.5e-08
+ W=1.2e-07
+ AD=1.68e-14	AS=1.68e-14	PD=5.19999e-07	PS=5.19999e-07
+ fw=1.2e-07 sa=1.4e-07 sb=1.4e-07 sca=4.13423 scb=0.000254067 scc=3.31832e-08
MXI67/MNM0	net16	net17	gnd!	gnd!	g45n1svt	L=4.5e-08
+ W=1.2e-07
+ AD=1.68e-14	AS=1.68e-14	PD=5.19999e-07	PS=5.19999e-07
+ fw=1.2e-07 sa=1.4e-07 sb=1.4e-07 sca=4.13423 scb=0.000254067 scc=3.31832e-08
MXI70__2/MNM0	G10	net10	gnd!	gnd!	g45n1svt	L=4.5e-08
+ W=1.2e-07
+ AD=1.68e-14	AS=1.68e-14	PD=5.19999e-07	PS=5.19999e-07
+ fw=1.2e-07 sa=1.4e-07 sb=1.4e-07 sca=4.13423 scb=0.000254067 scc=3.31832e-08
MXI66__2/MNM0	net11	net13	gnd!	gnd!	g45n1svt	L=4.5e-08
+ W=1.2e-07
+ AD=1.68e-14	AS=1.68e-14	PD=5.19999e-07	PS=5.19999e-07
+ fw=1.2e-07 sa=1.4e-07 sb=1.4e-07 sca=4.13423 scb=0.000254067 scc=3.31832e-08
MXI69/MNM0	net1	net2	gnd!	gnd!	g45n1svt	L=4.5e-08
+ W=1.2e-07
+ AD=1.68e-14	AS=1.68e-14	PD=5.19999e-07	PS=5.19999e-07
+ fw=1.2e-07 sa=1.4e-07 sb=1.4e-07 sca=4.13423 scb=0.000254067 scc=3.31832e-08
MXI66/MNM0	net11	net13	gnd!	gnd!	g45n1svt	L=4.5e-08
+ W=1.2e-07
+ AD=1.68e-14	AS=1.68e-14	PD=5.19999e-07	PS=5.19999e-07
+ fw=1.2e-07 sa=1.4e-07 sb=1.4e-07 sca=4.13423 scb=0.000254067 scc=3.31832e-08
MXI68/MNM0	net3	net6	gnd!	gnd!	g45n1svt	L=4.5e-08
+ W=1.2e-07
+ AD=1.68e-14	AS=1.68e-14	PD=5.19999e-07	PS=5.19999e-07
+ fw=1.2e-07 sa=1.4e-07 sb=1.4e-07 sca=4.13423 scb=0.000254067 scc=3.31832e-08
MXI64/MNM0	net24	net23	gnd!	gnd!	g45n1svt	L=4.5e-08
+ W=1.2e-07
+ AD=1.68e-14	AS=1.68e-14	PD=5.19999e-07	PS=5.19999e-07
+ fw=1.2e-07 sa=1.4e-07 sb=1.4e-07 sca=4.13423 scb=0.000254067 scc=3.31832e-08
MXI71/MNM0	net30	net29	gnd!	gnd!	g45n1svt	L=4.5e-08
+ W=1.2e-07
+ AD=1.68e-14	AS=1.68e-14	PD=5.19999e-07	PS=5.19999e-07
+ fw=1.2e-07 sa=1.4e-07 sb=1.4e-07 sca=4.13423 scb=0.000254067 scc=3.31832e-08
MXI88/MPM0	eq	net7	vdd!	vdd!	g45p1svt	L=4.5e-08
+ W=6.7e-07
+ AD=9.38e-14	AS=9.38e-14	PD=1.62e-06	PS=1.62e-06
+ fw=6.7e-07 sa=1.4e-07 sb=1.4e-07 sca=14.2227 scb=0.015226 scc=0.000590329
MXI5/MPM5	net33	net40	vdd!	vdd!	g45p1svt	L=4.5e-08
+ W=1.6e-07
+ AD=2.56e-14	AS=2.24e-14	PD=6.4e-07	PS=6e-07
+ fw=1.6e-07 sa=1.4e-07 sb=3.45e-07 sca=3.91594 scb=0.000183079 scc=1.25917e-08
MXI5/MPM6	net33	net43	vdd!	vdd!	g45p1svt	L=4.5e-08
+ W=1.6e-07
+ AD=2.56e-14	AS=2.24e-14	PD=6.4e-07	PS=6e-07
+ fw=1.6e-07 sa=1.4e-07 sb=3.45e-07 sca=3.91594 scb=0.000183079 scc=1.25917e-08
MXI6/MPM5	net19	net46	vdd!	vdd!	g45p1svt	L=4.5e-08
+ W=1.6e-07
+ AD=2.56e-14	AS=2.24e-14	PD=6.4e-07	PS=6e-07
+ fw=1.6e-07 sa=1.4e-07 sb=3.45e-07 sca=3.91594 scb=0.000183079 scc=1.25917e-08
MXI6/MPM6	net19	net49	vdd!	vdd!	g45p1svt	L=4.5e-08
+ W=1.6e-07
+ AD=2.56e-14	AS=2.24e-14	PD=6.4e-07	PS=6e-07
+ fw=1.6e-07 sa=1.4e-07 sb=3.45e-07 sca=3.91594 scb=0.000183079 scc=1.25917e-08
MXI97/MNM7	net13	P<5>	XI97/net1	vdd!	g45p1svt
+ L=4.5e-08	W=3.2e-07
+ AD=5.12e-14	AS=4.48e-14	PD=9.6e-07	PS=9.2e-07
+ fw=3.2e-07 sa=1.4e-07 sb=5.5e-07 sca=4.58716 scb=0.000694216 scc=9.03134e-07
MXI97/MPM5	net17	P<4>	vdd!	vdd!	g45p1svt	L=4.5e-08
+ W=1.6e-07
+ AD=2.56e-14	AS=2.24e-14	PD=6.4e-07	PS=6e-07
+ fw=1.6e-07 sa=1.4e-07 sb=3.45e-07 sca=3.91594 scb=0.000183079 scc=1.25917e-08
MXI97/MNM6	net13	G<4>	XI97/net1	vdd!	g45p1svt
+ L=4.5e-08	W=3.2e-07
+ AD=5.12e-14	AS=5.12e-14	PD=9.6e-07	PS=9.6e-07
+ fw=3.2e-07 sa=3.45e-07 sb=3.45e-07 sca=4.58716 scb=0.000694216 scc=9.03134e-07
MXI97/MNM8	XI97/net1	G<5>	vdd!	vdd!	g45p1svt
+ L=4.5e-08	W=3.2e-07
+ AD=5.12e-14	AS=4.48e-14	PD=9.6e-07	PS=9.2e-07
+ fw=3.2e-07 sa=1.4e-07 sb=5.5e-07 sca=4.58716 scb=0.000694216 scc=9.03134e-07
MXI97/MPM6	net17	P<5>	vdd!	vdd!	g45p1svt	L=4.5e-08
+ W=1.6e-07
+ AD=2.56e-14	AS=2.24e-14	PD=6.4e-07	PS=6e-07
+ fw=1.6e-07 sa=3.45e-07 sb=1.4e-07 sca=3.91594 scb=0.000183079 scc=1.25917e-08
MXI84/MNM7	net21	net30	XI84/net1	vdd!	g45p1svt
+ L=4.5e-08	W=3.2e-07
+ AD=5.12e-14	AS=4.48e-14	PD=9.6e-07	PS=9.2e-07
+ fw=3.2e-07 sa=1.4e-07 sb=5.5e-07 sca=4.58716 scb=0.000694216 scc=9.03134e-07
MXI84/MPM5	net27	net16	vdd!	vdd!	g45p1svt	L=4.5e-08
+ W=1.6e-07
+ AD=2.56e-14	AS=2.24e-14	PD=6.4e-07	PS=6e-07
+ fw=1.6e-07 sa=1.4e-07 sb=3.45e-07 sca=3.91594 scb=0.000183079 scc=1.25917e-08
MXI84/MNM6	net21	net11	XI84/net1	vdd!	g45p1svt
+ L=4.5e-08	W=3.2e-07
+ AD=5.12e-14	AS=5.12e-14	PD=9.6e-07	PS=9.6e-07
+ fw=3.2e-07 sa=3.45e-07 sb=3.45e-07 sca=4.58716 scb=0.000694216 scc=9.03134e-07
MXI84/MNM8	XI84/net1	net24	vdd!	vdd!	g45p1svt
+ L=4.5e-08	W=3.2e-07
+ AD=5.12e-14	AS=4.48e-14	PD=9.6e-07	PS=9.2e-07
+ fw=3.2e-07 sa=1.4e-07 sb=5.5e-07 sca=4.58716 scb=0.000694216 scc=9.03134e-07
MXI84/MPM6	net27	net30	vdd!	vdd!	g45p1svt	L=4.5e-08
+ W=1.6e-07
+ AD=2.56e-14	AS=2.24e-14	PD=6.4e-07	PS=6e-07
+ fw=1.6e-07 sa=3.45e-07 sb=1.4e-07 sca=3.91594 scb=0.000183079 scc=1.25917e-08
MXI91/MNM7	net31	P<6>	XI91/net1	vdd!	g45p1svt
+ L=4.5e-08	W=3.2e-07
+ AD=5.12e-14	AS=4.48e-14	PD=9.6e-07	PS=9.2e-07
+ fw=3.2e-07 sa=1.4e-07 sb=5.5e-07 sca=4.58716 scb=0.000694216 scc=9.03134e-07
MXI91/MPM5	net35	net16	vdd!	vdd!	g45p1svt	L=4.5e-08
+ W=1.6e-07
+ AD=2.56e-14	AS=2.24e-14	PD=6.4e-07	PS=6e-07
+ fw=1.6e-07 sa=1.4e-07 sb=3.45e-07 sca=3.91594 scb=0.000183079 scc=1.25917e-08
MXI91/MNM6	net31	net11	XI91/net1	vdd!	g45p1svt
+ L=4.5e-08	W=3.2e-07
+ AD=5.12e-14	AS=5.12e-14	PD=9.6e-07	PS=9.6e-07
+ fw=3.2e-07 sa=3.45e-07 sb=3.45e-07 sca=4.58716 scb=0.000694216 scc=9.03134e-07
MXI91/MNM8	XI91/net1	G<6>	vdd!	vdd!	g45p1svt
+ L=4.5e-08	W=3.2e-07
+ AD=5.12e-14	AS=4.48e-14	PD=9.6e-07	PS=9.2e-07
+ fw=3.2e-07 sa=1.4e-07 sb=5.5e-07 sca=4.58716 scb=0.000694216 scc=9.03134e-07
MXI91/MPM6	net35	P<6>	vdd!	vdd!	g45p1svt	L=4.5e-08
+ W=1.6e-07
+ AD=2.56e-14	AS=2.24e-14	PD=6.4e-07	PS=6e-07
+ fw=1.6e-07 sa=3.45e-07 sb=1.4e-07 sca=3.91594 scb=0.000183079 scc=1.25917e-08
MXI85/MNM7	net23	P<7>	XI85/net1	vdd!	g45p1svt
+ L=4.5e-08	W=3.2e-07
+ AD=5.12e-14	AS=4.48e-14	PD=9.6e-07	PS=9.2e-07
+ fw=3.2e-07 sa=1.4e-07 sb=5.5e-07 sca=4.58716 scb=0.000694216 scc=9.03134e-07
MXI85/MPM5	net29	P<6>	vdd!	vdd!	g45p1svt	L=4.5e-08
+ W=1.6e-07
+ AD=2.56e-14	AS=2.24e-14	PD=6.4e-07	PS=6e-07
+ fw=1.6e-07 sa=1.4e-07 sb=3.45e-07 sca=3.91594 scb=0.000183079 scc=1.25917e-08
MXI85/MNM6	net23	G<6>	XI85/net1	vdd!	g45p1svt
+ L=4.5e-08	W=3.2e-07
+ AD=5.12e-14	AS=5.12e-14	PD=9.6e-07	PS=9.6e-07
+ fw=3.2e-07 sa=3.45e-07 sb=3.45e-07 sca=4.58716 scb=0.000694216 scc=9.03134e-07
MXI85/MNM8	XI85/net1	G<7>	vdd!	vdd!	g45p1svt
+ L=4.5e-08	W=3.2e-07
+ AD=5.12e-14	AS=4.48e-14	PD=9.6e-07	PS=9.2e-07
+ fw=3.2e-07 sa=1.4e-07 sb=5.5e-07 sca=4.58716 scb=0.000694216 scc=9.03134e-07
MXI85/MPM6	net29	P<7>	vdd!	vdd!	g45p1svt	L=4.5e-08
+ W=1.6e-07
+ AD=2.56e-14	AS=2.24e-14	PD=6.4e-07	PS=6e-07
+ fw=1.6e-07 sa=3.45e-07 sb=1.4e-07 sca=3.91594 scb=0.000183079 scc=1.25917e-08
MXI106/MNM7	net2	P<3>	XI106/net1	vdd!	g45p1svt
+ L=4.5e-08	W=3.2e-07
+ AD=5.12e-14	AS=4.48e-14	PD=9.6e-07	PS=9.2e-07
+ fw=3.2e-07 sa=1.4e-07 sb=5.5e-07 sca=4.58716 scb=0.000694216 scc=9.03134e-07
MXI106/MPM5	net6	P<2>	vdd!	vdd!	g45p1svt	L=4.5e-08
+ W=1.6e-07
+ AD=2.56e-14	AS=2.24e-14	PD=6.4e-07	PS=6e-07
+ fw=1.6e-07 sa=1.4e-07 sb=3.45e-07 sca=3.91594 scb=0.000183079 scc=1.25917e-08
MXI106/MNM6	net2	G<2>	XI106/net1	vdd!	g45p1svt
+ L=4.5e-08	W=3.2e-07
+ AD=5.12e-14	AS=5.12e-14	PD=9.6e-07	PS=9.6e-07
+ fw=3.2e-07 sa=3.45e-07 sb=3.45e-07 sca=4.58716 scb=0.000694216 scc=9.03134e-07
MXI106/MNM8	XI106/net1	G<3>	vdd!	vdd!	g45p1svt
+ L=4.5e-08	W=3.2e-07
+ AD=5.12e-14	AS=4.48e-14	PD=9.6e-07	PS=9.2e-07
+ fw=3.2e-07 sa=1.4e-07 sb=5.5e-07 sca=4.58716 scb=0.000694216 scc=9.03134e-07
MXI106/MPM6	net6	P<3>	vdd!	vdd!	g45p1svt	L=4.5e-08
+ W=1.6e-07
+ AD=2.56e-14	AS=2.24e-14	PD=6.4e-07	PS=6e-07
+ fw=1.6e-07 sa=3.45e-07 sb=1.4e-07 sca=3.91594 scb=0.000183079 scc=1.25917e-08
MXI111/MNM6	net9	G10	XI111/net5	vdd!	g45p1svt
+ L=4.5e-08	W=3.2e-07
+ AD=5.12e-14	AS=5.12e-14	PD=9.6e-07	PS=9.6e-07
+ fw=3.2e-07 sa=3.45e-07 sb=3.45e-07 sca=4.58716 scb=0.000694216 scc=9.03134e-07
MXI111/MNM7	net9	P<2>	XI111/net5	vdd!	g45p1svt
+ L=4.5e-08	W=3.2e-07
+ AD=5.12e-14	AS=4.48e-14	PD=9.6e-07	PS=9.2e-07
+ fw=3.2e-07 sa=5.5e-07 sb=1.4e-07 sca=4.58716 scb=0.000694216 scc=9.03134e-07
MXI111/MNM8	XI111/net5	G<2>	vdd!	vdd!	g45p1svt
+ L=4.5e-08	W=3.2e-07
+ AD=5.12e-14	AS=4.48e-14	PD=9.6e-07	PS=9.2e-07
+ fw=3.2e-07 sa=1.4e-07 sb=5.5e-07 sca=4.58716 scb=0.000694216 scc=9.03134e-07
MXI83/MNM6	net26	G30	XI83/net5	vdd!	g45p1svt
+ L=4.5e-08	W=3.2e-07
+ AD=5.12e-14	AS=5.12e-14	PD=9.6e-07	PS=9.6e-07
+ fw=3.2e-07 sa=3.45e-07 sb=3.45e-07 sca=4.58716 scb=0.000694216 scc=9.03134e-07
MXI83/MNM7	net26	net28	XI83/net5	vdd!	g45p1svt
+ L=4.5e-08	W=3.2e-07
+ AD=5.12e-14	AS=4.48e-14	PD=9.6e-07	PS=9.2e-07
+ fw=3.2e-07 sa=5.5e-07 sb=1.4e-07 sca=4.58716 scb=0.000694216 scc=9.03134e-07
MXI83/MNM8	XI83/net5	net22	vdd!	vdd!	g45p1svt
+ L=4.5e-08	W=3.2e-07
+ AD=5.12e-14	AS=4.48e-14	PD=9.6e-07	PS=9.2e-07
+ fw=3.2e-07 sa=1.4e-07 sb=5.5e-07 sca=4.58716 scb=0.000694216 scc=9.03134e-07
MXI90/MNM6	net34	G30	XI90/net5	vdd!	g45p1svt
+ L=4.5e-08	W=3.2e-07
+ AD=5.12e-14	AS=5.12e-14	PD=9.6e-07	PS=9.6e-07
+ fw=3.2e-07 sa=3.45e-07 sb=3.45e-07 sca=4.58716 scb=0.000694216 scc=9.03134e-07
MXI90/MNM7	net34	net36	XI90/net5	vdd!	g45p1svt
+ L=4.5e-08	W=3.2e-07
+ AD=5.12e-14	AS=4.48e-14	PD=9.6e-07	PS=9.2e-07
+ fw=3.2e-07 sa=5.5e-07 sb=1.4e-07 sca=4.58716 scb=0.000694216 scc=9.03134e-07
MXI90/MNM8	XI90/net5	net32	vdd!	vdd!	g45p1svt
+ L=4.5e-08	W=3.2e-07
+ AD=5.12e-14	AS=4.48e-14	PD=9.6e-07	PS=9.2e-07
+ fw=3.2e-07 sa=1.4e-07 sb=5.5e-07 sca=4.58716 scb=0.000694216 scc=9.03134e-07
MXI102/MNM6	net20	G30	XI102/net5	vdd!	g45p1svt
+ L=4.5e-08	W=3.2e-07
+ AD=5.12e-14	AS=5.12e-14	PD=9.6e-07	PS=9.6e-07
+ fw=3.2e-07 sa=3.45e-07 sb=3.45e-07 sca=4.58716 scb=0.000694216 scc=9.03134e-07
MXI102/MNM7	net20	P<4>	XI102/net5	vdd!	g45p1svt
+ L=4.5e-08	W=3.2e-07
+ AD=5.12e-14	AS=4.48e-14	PD=9.6e-07	PS=9.2e-07
+ fw=3.2e-07 sa=5.5e-07 sb=1.4e-07 sca=4.58716 scb=0.000694216 scc=9.03134e-07
MXI102/MNM8	XI102/net5	G<4>	vdd!	vdd!	g45p1svt
+ L=4.5e-08	W=3.2e-07
+ AD=5.12e-14	AS=4.48e-14	PD=9.6e-07	PS=9.2e-07
+ fw=3.2e-07 sa=1.4e-07 sb=5.5e-07 sca=4.58716 scb=0.000694216 scc=9.03134e-07
MXI96/MNM6	net15	G30	XI96/net5	vdd!	g45p1svt
+ L=4.5e-08	W=3.2e-07
+ AD=5.12e-14	AS=5.12e-14	PD=9.6e-07	PS=9.6e-07
+ fw=3.2e-07 sa=3.45e-07 sb=3.45e-07 sca=4.58716 scb=0.000694216 scc=9.03134e-07
MXI96/MNM7	net15	net16	XI96/net5	vdd!	g45p1svt
+ L=4.5e-08	W=3.2e-07
+ AD=5.12e-14	AS=4.48e-14	PD=9.6e-07	PS=9.2e-07
+ fw=3.2e-07 sa=5.5e-07 sb=1.4e-07 sca=4.58716 scb=0.000694216 scc=9.03134e-07
MXI96/MNM8	XI96/net5	net11	vdd!	vdd!	g45p1svt
+ L=4.5e-08	W=3.2e-07
+ AD=5.12e-14	AS=4.48e-14	PD=9.6e-07	PS=9.2e-07
+ fw=3.2e-07 sa=1.4e-07 sb=5.5e-07 sca=4.58716 scb=0.000694216 scc=9.03134e-07
MXI105/MNM6	net4	G10	XI105/net5	vdd!	g45p1svt
+ L=4.5e-08	W=3.2e-07
+ AD=5.12e-14	AS=5.12e-14	PD=9.6e-07	PS=9.6e-07
+ fw=3.2e-07 sa=3.45e-07 sb=3.45e-07 sca=4.58716 scb=0.000694216 scc=9.03134e-07
MXI105/MNM7	net4	net3	XI105/net5	vdd!	g45p1svt
+ L=4.5e-08	W=3.2e-07
+ AD=5.12e-14	AS=4.48e-14	PD=9.6e-07	PS=9.2e-07
+ fw=3.2e-07 sa=5.5e-07 sb=1.4e-07 sca=4.58716 scb=0.000694216 scc=9.03134e-07
MXI105/MNM8	XI105/net5	net1	vdd!	vdd!	g45p1svt
+ L=4.5e-08	W=3.2e-07
+ AD=5.12e-14	AS=4.48e-14	PD=9.6e-07	PS=9.2e-07
+ fw=3.2e-07 sa=1.4e-07 sb=5.5e-07 sca=4.58716 scb=0.000694216 scc=9.03134e-07
MXI115/MNM6	net10	G<0>	XI115/net5	vdd!	g45p1svt
+ L=4.5e-08	W=3.2e-07
+ AD=5.12e-14	AS=5.12e-14	PD=9.6e-07	PS=9.6e-07
+ fw=3.2e-07 sa=3.45e-07 sb=3.45e-07 sca=4.58716 scb=0.000694216 scc=9.03134e-07
MXI115/MNM7	net10	P<1>	XI115/net5	vdd!	g45p1svt
+ L=4.5e-08	W=3.2e-07
+ AD=5.12e-14	AS=4.48e-14	PD=9.6e-07	PS=9.2e-07
+ fw=3.2e-07 sa=5.5e-07 sb=1.4e-07 sca=4.58716 scb=0.000694216 scc=9.03134e-07
MXI115/MNM8	XI115/net5	G<1>	vdd!	vdd!	g45p1svt
+ L=4.5e-08	W=3.2e-07
+ AD=5.12e-14	AS=4.48e-14	PD=9.6e-07	PS=9.2e-07
+ fw=3.2e-07 sa=1.4e-07 sb=5.5e-07 sca=4.58716 scb=0.000694216 scc=9.03134e-07
MXI144/MPM6	XI144/in0_b	in0<2>	vdd!	vdd!	g45p1svt
+ L=4.5e-08	W=1.6e-07
+ AD=2.24e-14	AS=2.24e-14	PD=6e-07	PS=6e-07
+ fw=1.6e-07 sa=1.4e-07 sb=1.4e-07 sca=27.1671 scb=0.0287257 scc=0.00270007
MXI136/MPM6	XI136/out_b	in1<2>	vdd!	vdd!	g45p1svt
+ L=4.5e-08	W=1.6e-07
+ AD=2.56e-14	AS=2.24e-14	PD=6.4e-07	PS=6e-07
+ fw=1.6e-07 sa=1.4e-07 sb=5.8e-07 sca=23.3672 scb=0.0242109 scc=0.00264686
MXI135/MPM6	XI135/out_b	in1<3>	vdd!	vdd!	g45p1svt
+ L=4.5e-08	W=1.6e-07
+ AD=2.56e-14	AS=2.24e-14	PD=6.4e-07	PS=6e-07
+ fw=1.6e-07 sa=1.4e-07 sb=5.8e-07 sca=23.3672 scb=0.0242109 scc=0.00264686
MXI141/MPM6	XI141/in0_b	in0<5>	vdd!	vdd!	g45p1svt
+ L=4.5e-08	W=1.6e-07
+ AD=2.24e-14	AS=2.24e-14	PD=6e-07	PS=6e-07
+ fw=1.6e-07 sa=1.4e-07 sb=1.4e-07 sca=23.3672 scb=0.0242109 scc=0.00264686
MXI132/MPM6	XI132/out_b	in1<6>	vdd!	vdd!	g45p1svt
+ L=4.5e-08	W=1.6e-07
+ AD=2.56e-14	AS=2.24e-14	PD=6.4e-07	PS=6e-07
+ fw=1.6e-07 sa=1.4e-07 sb=5.8e-07 sca=23.3672 scb=0.0242109 scc=0.00264686
MXI131/MPM6	XI131/out_b	in1<7>	vdd!	vdd!	g45p1svt
+ L=4.5e-08	W=1.6e-07
+ AD=2.56e-14	AS=2.24e-14	PD=6.4e-07	PS=6e-07
+ fw=1.6e-07 sa=1.4e-07 sb=5.8e-07 sca=23.3672 scb=0.0242109 scc=0.00264686
MXI139/MPM6	XI139/in0_b	in0<7>	vdd!	vdd!	g45p1svt
+ L=4.5e-08	W=1.6e-07
+ AD=2.24e-14	AS=2.24e-14	PD=6e-07	PS=6e-07
+ fw=1.6e-07 sa=1.4e-07 sb=1.4e-07 sca=23.3672 scb=0.0242109 scc=0.00264686
MXI136/MPM5	XI136/out_b	in0<2>	vdd!	vdd!	g45p1svt
+ L=4.5e-08	W=1.6e-07
+ AD=2.56e-14	AS=3.04e-14	PD=6.4e-07	PS=7e-07
+ fw=1.6e-07 sa=3.45e-07 sb=3.75e-07 sca=8.44597 scb=0.00611987 scc=8.49061e-05
MXI135/MPM5	XI135/out_b	in0<3>	vdd!	vdd!	g45p1svt
+ L=4.5e-08	W=1.6e-07
+ AD=2.56e-14	AS=3.04e-14	PD=6.4e-07	PS=7e-07
+ fw=1.6e-07 sa=3.45e-07 sb=3.75e-07 sca=8.44597 scb=0.00611987 scc=8.49061e-05
MXI132/MPM5	XI132/out_b	in0<6>	vdd!	vdd!	g45p1svt
+ L=4.5e-08	W=1.6e-07
+ AD=2.56e-14	AS=3.04e-14	PD=6.4e-07	PS=7e-07
+ fw=1.6e-07 sa=3.45e-07 sb=3.75e-07 sca=8.44597 scb=0.00611987 scc=8.49061e-05
MXI131/MPM5	XI131/out_b	in0<7>	vdd!	vdd!	g45p1svt
+ L=4.5e-08	W=1.6e-07
+ AD=2.56e-14	AS=3.04e-14	PD=6.4e-07	PS=7e-07
+ fw=1.6e-07 sa=3.45e-07 sb=3.75e-07 sca=8.44597 scb=0.00611987 scc=8.49061e-05
MXI144/MPM2	XI144/net12	XI144/in0_b	vdd!	vdd!	g45p1svt
+ L=4.5e-08	W=3.2e-07
+ AD=1.92e-14	AS=4.48e-14	PD=7.6e-07	PS=9.2e-07
+ fw=3.2e-07 sa=1.4e-07 sb=5.55e-07 sca=9.02964 scb=0.00498211 scc=3.116e-05
MXI141/MPM2	XI141/net12	XI141/in0_b	vdd!	vdd!	g45p1svt
+ L=4.5e-08	W=3.2e-07
+ AD=1.92e-14	AS=4.48e-14	PD=7.6e-07	PS=9.2e-07
+ fw=3.2e-07 sa=1.4e-07 sb=5.55e-07 sca=8.35229 scb=0.00476235 scc=3.10431e-05
MXI139/MPM2	XI139/net12	XI139/in0_b	vdd!	vdd!	g45p1svt
+ L=4.5e-08	W=3.2e-07
+ AD=1.92e-14	AS=4.48e-14	PD=7.6e-07	PS=9.2e-07
+ fw=3.2e-07 sa=1.4e-07 sb=5.55e-07 sca=8.35229 scb=0.00476235 scc=3.10431e-05
MXI136/MPM3	G<2>	XI136/out_b	vdd!	vdd!	g45p1svt
+ L=4.5e-08	W=1.6e-07
+ AD=2.24e-14	AS=3.04e-14	PD=6e-07	PS=7e-07
+ fw=1.6e-07 sa=5.8e-07 sb=1.4e-07 sca=5.24002 scb=0.00102994 scc=1.21113e-06
MXI135/MPM3	G<3>	XI135/out_b	vdd!	vdd!	g45p1svt
+ L=4.5e-08	W=1.6e-07
+ AD=2.24e-14	AS=3.04e-14	PD=6e-07	PS=7e-07
+ fw=1.6e-07 sa=5.8e-07 sb=1.4e-07 sca=5.24002 scb=0.00102994 scc=1.21113e-06
MXI132/MPM3	G<6>	XI132/out_b	vdd!	vdd!	g45p1svt
+ L=4.5e-08	W=1.6e-07
+ AD=2.24e-14	AS=3.04e-14	PD=6e-07	PS=7e-07
+ fw=1.6e-07 sa=5.8e-07 sb=1.4e-07 sca=5.24002 scb=0.00102994 scc=1.21113e-06
MXI131/MPM3	G<7>	XI131/out_b	vdd!	vdd!	g45p1svt
+ L=4.5e-08	W=1.6e-07
+ AD=2.24e-14	AS=3.04e-14	PD=6e-07	PS=7e-07
+ fw=1.6e-07 sa=5.8e-07 sb=1.4e-07 sca=5.24002 scb=0.00102994 scc=1.21113e-06
MXI144/MPM3	P<2>	in1<2>	XI144/net12	vdd!	g45p1svt
+ L=4.5e-08	W=3.2e-07
+ AD=5.12e-14	AS=1.92e-14	PD=9.6e-07	PS=7.6e-07
+ fw=3.2e-07 sa=2.45e-07 sb=4.5e-07 sca=8.11102 scb=0.00378979 scc=2.47327e-05
MXI141/MPM3	P<5>	in1<5>	XI141/net12	vdd!	g45p1svt
+ L=4.5e-08	W=3.2e-07
+ AD=5.12e-14	AS=1.92e-14	PD=9.6e-07	PS=7.6e-07
+ fw=3.2e-07 sa=2.45e-07 sb=4.5e-07 sca=7.43367 scb=0.00357003 scc=2.46159e-05
MXI139/MPM3	P<7>	in1<7>	XI139/net12	vdd!	g45p1svt
+ L=4.5e-08	W=3.2e-07
+ AD=5.12e-14	AS=1.92e-14	PD=9.6e-07	PS=7.6e-07
+ fw=3.2e-07 sa=2.45e-07 sb=4.5e-07 sca=7.43367 scb=0.00357003 scc=2.46159e-05
MXI144/MPM8	P<2>	in0<2>	XI144/net4	vdd!	g45p1svt
+ L=4.5e-08	W=3.2e-07
+ AD=5.12e-14	AS=1.92e-14	PD=9.6e-07	PS=7.6e-07
+ fw=3.2e-07 sa=4.5e-07 sb=2.45e-07 sca=7.17858 scb=0.00308505 scc=2.36624e-05
MXI141/MPM8	P<5>	in0<5>	XI141/net4	vdd!	g45p1svt
+ L=4.5e-08	W=3.2e-07
+ AD=5.12e-14	AS=1.92e-14	PD=9.6e-07	PS=7.6e-07
+ fw=3.2e-07 sa=4.5e-07 sb=2.45e-07 sca=6.50123 scb=0.00286529 scc=2.35456e-05
MXI139/MPM8	P<7>	in0<7>	XI139/net4	vdd!	g45p1svt
+ L=4.5e-08	W=3.2e-07
+ AD=5.12e-14	AS=1.92e-14	PD=9.6e-07	PS=7.6e-07
+ fw=3.2e-07 sa=4.5e-07 sb=2.45e-07 sca=6.50123 scb=0.00286529 scc=2.35456e-05
MXI144/MPM7	XI144/net4	XI144/in1_b	vdd!	vdd!	g45p1svt
+ L=4.5e-08	W=3.2e-07
+ AD=1.92e-14	AS=4.48e-14	PD=7.6e-07	PS=9.2e-07
+ fw=3.2e-07 sa=5.55e-07 sb=1.4e-07 sca=6.91121 scb=0.00299832 scc=2.36419e-05
MXI141/MPM7	XI141/net4	XI141/in1_b	vdd!	vdd!	g45p1svt
+ L=4.5e-08	W=3.2e-07
+ AD=1.92e-14	AS=4.48e-14	PD=7.6e-07	PS=9.2e-07
+ fw=3.2e-07 sa=5.55e-07 sb=1.4e-07 sca=6.23386 scb=0.00277856 scc=2.35251e-05
MXI139/MPM7	XI139/net4	XI139/in1_b	vdd!	vdd!	g45p1svt
+ L=4.5e-08	W=3.2e-07
+ AD=1.92e-14	AS=4.48e-14	PD=7.6e-07	PS=9.2e-07
+ fw=3.2e-07 sa=5.55e-07 sb=1.4e-07 sca=6.23386 scb=0.00277856 scc=2.35251e-05
MXI145/MPM6	XI145/in0_b	in0<1>	vdd!	vdd!	g45p1svt
+ L=4.5e-08	W=1.6e-07
+ AD=2.24e-14	AS=2.24e-14	PD=6e-07	PS=6e-07
+ fw=1.6e-07 sa=1.4e-07 sb=1.4e-07 sca=23.3672 scb=0.0242109 scc=0.00264686
MXI143/MPM6	XI143/in0_b	in0<3>	vdd!	vdd!	g45p1svt
+ L=4.5e-08	W=1.6e-07
+ AD=2.24e-14	AS=2.24e-14	PD=6e-07	PS=6e-07
+ fw=1.6e-07 sa=1.4e-07 sb=1.4e-07 sca=3.91594 scb=0.000183079 scc=1.25917e-08
MXI140/MPM6	XI140/in0_b	in0<6>	vdd!	vdd!	g45p1svt
+ L=4.5e-08	W=1.6e-07
+ AD=2.24e-14	AS=2.24e-14	PD=6e-07	PS=6e-07
+ fw=1.6e-07 sa=1.4e-07 sb=1.4e-07 sca=3.91594 scb=0.000183079 scc=1.25917e-08
MXI144/MPM5	XI144/in1_b	in1<2>	vdd!	vdd!	g45p1svt
+ L=4.5e-08	W=1.6e-07
+ AD=2.24e-14	AS=2.24e-14	PD=6e-07	PS=6e-07
+ fw=1.6e-07 sa=1.4e-07 sb=1.4e-07 sca=3.91594 scb=0.000183079 scc=1.25917e-08
MXI141/MPM5	XI141/in1_b	in1<5>	vdd!	vdd!	g45p1svt
+ L=4.5e-08	W=1.6e-07
+ AD=2.24e-14	AS=2.24e-14	PD=6e-07	PS=6e-07
+ fw=1.6e-07 sa=1.4e-07 sb=1.4e-07 sca=3.91594 scb=0.000183079 scc=1.25917e-08
MXI139/MPM5	XI139/in1_b	in1<7>	vdd!	vdd!	g45p1svt
+ L=4.5e-08	W=1.6e-07
+ AD=2.24e-14	AS=2.24e-14	PD=6e-07	PS=6e-07
+ fw=1.6e-07 sa=1.4e-07 sb=1.4e-07 sca=3.91594 scb=0.000183079 scc=1.25917e-08
MXI145/MPM2	XI145/net12	XI145/in0_b	vdd!	vdd!	g45p1svt
+ L=4.5e-08	W=3.2e-07
+ AD=1.92e-14	AS=4.48e-14	PD=7.6e-07	PS=9.2e-07
+ fw=3.2e-07 sa=1.4e-07 sb=5.55e-07 sca=8.35229 scb=0.00476235 scc=3.10431e-05
MXI143/MPM2	XI143/net12	XI143/in0_b	vdd!	vdd!	g45p1svt
+ L=4.5e-08	W=3.2e-07
+ AD=1.92e-14	AS=4.48e-14	PD=7.6e-07	PS=9.2e-07
+ fw=3.2e-07 sa=1.4e-07 sb=5.55e-07 sca=6.14367 scb=0.00275993 scc=2.35233e-05
MXI140/MPM2	XI140/net12	XI140/in0_b	vdd!	vdd!	g45p1svt
+ L=4.5e-08	W=3.2e-07
+ AD=1.92e-14	AS=4.48e-14	PD=7.6e-07	PS=9.2e-07
+ fw=3.2e-07 sa=1.4e-07 sb=5.55e-07 sca=6.14367 scb=0.00275993 scc=2.35233e-05
MXI145/MPM3	P<1>	in1<1>	XI145/net12	vdd!	g45p1svt
+ L=4.5e-08	W=3.2e-07
+ AD=5.12e-14	AS=1.92e-14	PD=9.6e-07	PS=7.6e-07
+ fw=3.2e-07 sa=2.45e-07 sb=4.5e-07 sca=7.43367 scb=0.00357003 scc=2.46159e-05
MXI143/MPM3	P<3>	in1<3>	XI143/net12	vdd!	g45p1svt
+ L=4.5e-08	W=3.2e-07
+ AD=5.12e-14	AS=1.92e-14	PD=9.6e-07	PS=7.6e-07
+ fw=3.2e-07 sa=2.45e-07 sb=4.5e-07 sca=6.14367 scb=0.00275993 scc=2.35233e-05
MXI140/MPM3	P<6>	in1<6>	XI140/net12	vdd!	g45p1svt
+ L=4.5e-08	W=3.2e-07
+ AD=5.12e-14	AS=1.92e-14	PD=9.6e-07	PS=7.6e-07
+ fw=3.2e-07 sa=2.45e-07 sb=4.5e-07 sca=6.14367 scb=0.00275993 scc=2.35233e-05
MXI137/MPM6	XI137/out_b	in1<1>	vdd!	vdd!	g45p1svt
+ L=4.5e-08	W=1.6e-07
+ AD=2.56e-14	AS=2.24e-14	PD=6.4e-07	PS=6e-07
+ fw=1.6e-07 sa=1.4e-07 sb=5.8e-07 sca=3.91594 scb=0.000183079 scc=1.25917e-08
MXI133/MPM6	XI133/out_b	in1<5>	vdd!	vdd!	g45p1svt
+ L=4.5e-08	W=1.6e-07
+ AD=2.56e-14	AS=2.24e-14	PD=6.4e-07	PS=6e-07
+ fw=1.6e-07 sa=1.4e-07 sb=5.8e-07 sca=3.91594 scb=0.000183079 scc=1.25917e-08
MXI71/MPM0	net30	net29	vdd!	vdd!	g45p1svt	L=4.5e-08
+ W=1.6e-07
+ AD=2.24e-14	AS=2.24e-14	PD=6e-07	PS=6e-07
+ fw=1.6e-07 sa=1.4e-07 sb=1.4e-07 sca=4.52664 scb=0.000509491 scc=2.72339e-07
MXI145/MPM8	P<1>	in0<1>	XI145/net4	vdd!	g45p1svt
+ L=4.5e-08	W=3.2e-07
+ AD=5.12e-14	AS=1.92e-14	PD=9.6e-07	PS=7.6e-07
+ fw=3.2e-07 sa=4.5e-07 sb=2.45e-07 sca=6.50123 scb=0.00286529 scc=2.35456e-05
MXI143/MPM8	P<3>	in0<3>	XI143/net4	vdd!	g45p1svt
+ L=4.5e-08	W=3.2e-07
+ AD=5.12e-14	AS=1.92e-14	PD=9.6e-07	PS=7.6e-07
+ fw=3.2e-07 sa=4.5e-07 sb=2.45e-07 sca=6.14367 scb=0.00275993 scc=2.35233e-05
MXI140/MPM8	P<6>	in0<6>	XI140/net4	vdd!	g45p1svt
+ L=4.5e-08	W=3.2e-07
+ AD=5.12e-14	AS=1.92e-14	PD=9.6e-07	PS=7.6e-07
+ fw=3.2e-07 sa=4.5e-07 sb=2.45e-07 sca=6.14367 scb=0.00275993 scc=2.35233e-05
MXI137/MPM5	XI137/out_b	in0<1>	vdd!	vdd!	g45p1svt
+ L=4.5e-08	W=1.6e-07
+ AD=2.56e-14	AS=3.04e-14	PD=6.4e-07	PS=7e-07
+ fw=1.6e-07 sa=3.45e-07 sb=3.75e-07 sca=3.91594 scb=0.000183079 scc=1.25917e-08
MXI133/MPM5	XI133/out_b	in0<5>	vdd!	vdd!	g45p1svt
+ L=4.5e-08	W=1.6e-07
+ AD=2.56e-14	AS=3.04e-14	PD=6.4e-07	PS=7e-07
+ fw=1.6e-07 sa=3.45e-07 sb=3.75e-07 sca=3.91594 scb=0.000183079 scc=1.25917e-08
MXI145/MPM7	XI145/net4	XI145/in1_b	vdd!	vdd!	g45p1svt
+ L=4.5e-08	W=3.2e-07
+ AD=1.92e-14	AS=4.48e-14	PD=7.6e-07	PS=9.2e-07
+ fw=3.2e-07 sa=5.55e-07 sb=1.4e-07 sca=6.23386 scb=0.00277856 scc=2.35251e-05
MXI143/MPM7	XI143/net4	XI143/in1_b	vdd!	vdd!	g45p1svt
+ L=4.5e-08	W=3.2e-07
+ AD=1.92e-14	AS=4.48e-14	PD=7.6e-07	PS=9.2e-07
+ fw=3.2e-07 sa=5.55e-07 sb=1.4e-07 sca=6.14367 scb=0.00275993 scc=2.35233e-05
MXI140/MPM7	XI140/net4	XI140/in1_b	vdd!	vdd!	g45p1svt
+ L=4.5e-08	W=3.2e-07
+ AD=1.92e-14	AS=4.48e-14	PD=7.6e-07	PS=9.2e-07
+ fw=3.2e-07 sa=5.55e-07 sb=1.4e-07 sca=6.14367 scb=0.00275993 scc=2.35233e-05
MXI137/MPM3	G<1>	XI137/out_b	vdd!	vdd!	g45p1svt
+ L=4.5e-08	W=1.6e-07
+ AD=2.24e-14	AS=3.04e-14	PD=6e-07	PS=7e-07
+ fw=1.6e-07 sa=5.8e-07 sb=1.4e-07 sca=3.91594 scb=0.000183079 scc=1.25917e-08
MXI133/MPM3	G<5>	XI133/out_b	vdd!	vdd!	g45p1svt
+ L=4.5e-08	W=1.6e-07
+ AD=2.24e-14	AS=3.04e-14	PD=6e-07	PS=7e-07
+ fw=1.6e-07 sa=5.8e-07 sb=1.4e-07 sca=3.91594 scb=0.000183079 scc=1.25917e-08
MXI64/MPM0	net24	net23	vdd!	vdd!	g45p1svt	L=4.5e-08
+ W=1.6e-07
+ AD=2.24e-14	AS=2.24e-14	PD=6e-07	PS=6e-07
+ fw=1.6e-07 sa=1.4e-07 sb=1.4e-07 sca=4.52664 scb=0.000509491 scc=2.72339e-07
MXI145/MPM5	XI145/in1_b	in1<1>	vdd!	vdd!	g45p1svt
+ L=4.5e-08	W=1.6e-07
+ AD=2.24e-14	AS=2.24e-14	PD=6e-07	PS=6e-07
+ fw=1.6e-07 sa=1.4e-07 sb=1.4e-07 sca=3.91594 scb=0.000183079 scc=1.25917e-08
MXI143/MPM5	XI143/in1_b	in1<3>	vdd!	vdd!	g45p1svt
+ L=4.5e-08	W=1.6e-07
+ AD=2.24e-14	AS=2.24e-14	PD=6e-07	PS=6e-07
+ fw=1.6e-07 sa=1.4e-07 sb=1.4e-07 sca=3.91594 scb=0.000183079 scc=1.25917e-08
MXI140/MPM5	XI140/in1_b	in1<6>	vdd!	vdd!	g45p1svt
+ L=4.5e-08	W=1.6e-07
+ AD=2.24e-14	AS=2.24e-14	PD=6e-07	PS=6e-07
+ fw=1.6e-07 sa=1.4e-07 sb=1.4e-07 sca=3.91594 scb=0.000183079 scc=1.25917e-08
MXI138/MPM6	XI138/out_b	in1<0>	vdd!	vdd!	g45p1svt
+ L=4.5e-08	W=1.6e-07
+ AD=2.56e-14	AS=2.24e-14	PD=6.4e-07	PS=6e-07
+ fw=1.6e-07 sa=1.4e-07 sb=5.8e-07 sca=3.91594 scb=0.000183079 scc=1.25917e-08
MXI68/MPM0	net3	net6	vdd!	vdd!	g45p1svt	L=4.5e-08
+ W=1.6e-07
+ AD=2.24e-14	AS=2.24e-14	PD=6e-07	PS=6e-07
+ fw=1.6e-07 sa=1.4e-07 sb=1.4e-07 sca=4.52664 scb=0.000509491 scc=2.72339e-07
MXI142/MPM6	XI142/in0_b	in0<4>	vdd!	vdd!	g45p1svt
+ L=4.5e-08	W=1.6e-07
+ AD=2.24e-14	AS=2.24e-14	PD=6e-07	PS=6e-07
+ fw=1.6e-07 sa=1.4e-07 sb=1.4e-07 sca=3.91594 scb=0.000183079 scc=1.25917e-08
MXI134/MPM6	XI134/out_b	in1<4>	vdd!	vdd!	g45p1svt
+ L=4.5e-08	W=1.6e-07
+ AD=2.56e-14	AS=2.24e-14	PD=6.4e-07	PS=6e-07
+ fw=1.6e-07 sa=1.4e-07 sb=5.8e-07 sca=3.91594 scb=0.000183079 scc=1.25917e-08
MXI66/MPM0	net11	net13	vdd!	vdd!	g45p1svt	L=4.5e-08
+ W=1.6e-07
+ AD=2.24e-14	AS=2.24e-14	PD=6e-07	PS=6e-07
+ fw=1.6e-07 sa=1.4e-07 sb=1.4e-07 sca=4.52664 scb=0.000509491 scc=2.72339e-07
MXI138/MPM5	XI138/out_b	in0<0>	vdd!	vdd!	g45p1svt
+ L=4.5e-08	W=1.6e-07
+ AD=2.56e-14	AS=3.04e-14	PD=6.4e-07	PS=7e-07
+ fw=1.6e-07 sa=3.45e-07 sb=3.75e-07 sca=3.91594 scb=0.000183079 scc=1.25917e-08
MXI134/MPM5	XI134/out_b	in0<4>	vdd!	vdd!	g45p1svt
+ L=4.5e-08	W=1.6e-07
+ AD=2.56e-14	AS=3.04e-14	PD=6.4e-07	PS=7e-07
+ fw=1.6e-07 sa=3.45e-07 sb=3.75e-07 sca=3.91594 scb=0.000183079 scc=1.25917e-08
MXI142/MPM2	XI142/net12	XI142/in0_b	vdd!	vdd!	g45p1svt
+ L=4.5e-08	W=3.2e-07
+ AD=1.92e-14	AS=4.48e-14	PD=7.6e-07	PS=9.2e-07
+ fw=3.2e-07 sa=1.4e-07 sb=5.55e-07 sca=6.14367 scb=0.00275993 scc=2.35233e-05
MXI138/MPM3	G<0>	XI138/out_b	vdd!	vdd!	g45p1svt
+ L=4.5e-08	W=1.6e-07
+ AD=2.24e-14	AS=3.04e-14	PD=6e-07	PS=7e-07
+ fw=1.6e-07 sa=5.8e-07 sb=1.4e-07 sca=3.91594 scb=0.000183079 scc=1.25917e-08
MXI134/MPM3	G<4>	XI134/out_b	vdd!	vdd!	g45p1svt
+ L=4.5e-08	W=1.6e-07
+ AD=2.24e-14	AS=3.04e-14	PD=6e-07	PS=7e-07
+ fw=1.6e-07 sa=5.8e-07 sb=1.4e-07 sca=3.91594 scb=0.000183079 scc=1.25917e-08
MXI142/MPM3	P<4>	in1<4>	XI142/net12	vdd!	g45p1svt
+ L=4.5e-08	W=3.2e-07
+ AD=5.12e-14	AS=1.92e-14	PD=9.6e-07	PS=7.6e-07
+ fw=3.2e-07 sa=2.45e-07 sb=4.5e-07 sca=6.14367 scb=0.00275993 scc=2.35233e-05
MXI69/MPM0	net1	net2	vdd!	vdd!	g45p1svt	L=4.5e-08
+ W=1.6e-07
+ AD=2.24e-14	AS=2.24e-14	PD=6e-07	PS=6e-07
+ fw=1.6e-07 sa=1.4e-07 sb=1.4e-07 sca=4.52664 scb=0.000509491 scc=2.72339e-07
MXI66__2/MPM0	net11	net13	vdd!	vdd!	g45p1svt	L=4.5e-08
+ W=1.6e-07
+ AD=2.24e-14	AS=2.24e-14	PD=6e-07	PS=6e-07
+ fw=1.6e-07 sa=1.4e-07 sb=1.4e-07 sca=4.52664 scb=0.000509491 scc=2.72339e-07
MXI142/MPM8	P<4>	in0<4>	XI142/net4	vdd!	g45p1svt
+ L=4.5e-08	W=3.2e-07
+ AD=5.12e-14	AS=1.92e-14	PD=9.6e-07	PS=7.6e-07
+ fw=3.2e-07 sa=4.5e-07 sb=2.45e-07 sca=6.14367 scb=0.00275993 scc=2.35233e-05
MXI142/MPM7	XI142/net4	XI142/in1_b	vdd!	vdd!	g45p1svt
+ L=4.5e-08	W=3.2e-07
+ AD=1.92e-14	AS=4.48e-14	PD=7.6e-07	PS=9.2e-07
+ fw=3.2e-07 sa=5.55e-07 sb=1.4e-07 sca=6.14367 scb=0.00275993 scc=2.35233e-05
MXI146/MPM6	XI146/in0_b	in0<0>	vdd!	vdd!	g45p1svt
+ L=4.5e-08	W=1.6e-07
+ AD=2.24e-14	AS=2.24e-14	PD=6e-07	PS=6e-07
+ fw=1.6e-07 sa=1.4e-07 sb=1.4e-07 sca=3.91594 scb=0.000183079 scc=1.25917e-08
MXI70__2/MPM0	G10	net10	vdd!	vdd!	g45p1svt	L=4.5e-08
+ W=1.6e-07
+ AD=2.24e-14	AS=2.24e-14	PD=6e-07	PS=6e-07
+ fw=1.6e-07 sa=1.4e-07 sb=1.4e-07 sca=4.52664 scb=0.000509491 scc=2.72339e-07
MXI67__2/MPM0	net16	net17	vdd!	vdd!	g45p1svt	L=4.5e-08
+ W=1.6e-07
+ AD=2.24e-14	AS=2.24e-14	PD=6e-07	PS=6e-07
+ fw=1.6e-07 sa=1.4e-07 sb=1.4e-07 sca=4.52664 scb=0.000509491 scc=2.72339e-07
MXI142/MPM5	XI142/in1_b	in1<4>	vdd!	vdd!	g45p1svt
+ L=4.5e-08	W=1.6e-07
+ AD=2.24e-14	AS=2.24e-14	PD=6e-07	PS=6e-07
+ fw=1.6e-07 sa=1.4e-07 sb=1.4e-07 sca=3.91594 scb=0.000183079 scc=1.25917e-08
MXI146/MPM2	XI146/net12	XI146/in0_b	vdd!	vdd!	g45p1svt
+ L=4.5e-08	W=3.2e-07
+ AD=1.92e-14	AS=4.48e-14	PD=7.6e-07	PS=9.2e-07
+ fw=3.2e-07 sa=1.4e-07 sb=5.55e-07 sca=6.14367 scb=0.00275993 scc=2.35233e-05
MXI146/MPM3	sum<0>	in1<0>	XI146/net12	vdd!	g45p1svt
+ L=4.5e-08	W=3.2e-07
+ AD=5.12e-14	AS=1.92e-14	PD=9.6e-07	PS=7.6e-07
+ fw=3.2e-07 sa=2.45e-07 sb=4.5e-07 sca=6.14367 scb=0.00275993 scc=2.35233e-05
MXI70/MPM0	G10	net10	vdd!	vdd!	g45p1svt	L=4.5e-08
+ W=1.6e-07
+ AD=2.24e-14	AS=2.24e-14	PD=6e-07	PS=6e-07
+ fw=1.6e-07 sa=1.4e-07 sb=1.4e-07 sca=4.52664 scb=0.000509491 scc=2.72339e-07
MXI76__2/MPM0	G30	net4	vdd!	vdd!	g45p1svt	L=4.5e-08
+ W=1.6e-07
+ AD=2.24e-14	AS=2.24e-14	PD=6e-07	PS=6e-07
+ fw=1.6e-07 sa=1.4e-07 sb=1.4e-07 sca=4.52664 scb=0.000509491 scc=2.72339e-07
MXI67/MPM0	net16	net17	vdd!	vdd!	g45p1svt	L=4.5e-08
+ W=1.6e-07
+ AD=2.24e-14	AS=2.24e-14	PD=6e-07	PS=6e-07
+ fw=1.6e-07 sa=1.4e-07 sb=1.4e-07 sca=4.52664 scb=0.000509491 scc=2.72339e-07
MXI75/MPM0	net32	net31	vdd!	vdd!	g45p1svt	L=4.5e-08
+ W=1.6e-07
+ AD=2.24e-14	AS=2.24e-14	PD=6e-07	PS=6e-07
+ fw=1.6e-07 sa=1.4e-07 sb=1.4e-07 sca=4.52664 scb=0.000509491 scc=2.72339e-07
MXI72/MPM0	net22	net21	vdd!	vdd!	g45p1svt	L=4.5e-08
+ W=1.6e-07
+ AD=2.24e-14	AS=2.24e-14	PD=6e-07	PS=6e-07
+ fw=1.6e-07 sa=1.4e-07 sb=1.4e-07 sca=4.52664 scb=0.000509491 scc=2.72339e-07
MXI146/MPM8	sum<0>	in0<0>	XI146/net4	vdd!	g45p1svt
+ L=4.5e-08	W=3.2e-07
+ AD=5.12e-14	AS=1.92e-14	PD=9.6e-07	PS=7.6e-07
+ fw=3.2e-07 sa=4.5e-07 sb=2.45e-07 sca=6.14367 scb=0.00275993 scc=2.35233e-05
MXI146/MPM7	XI146/net4	XI146/in1_b	vdd!	vdd!	g45p1svt
+ L=4.5e-08	W=3.2e-07
+ AD=1.92e-14	AS=4.48e-14	PD=7.6e-07	PS=9.2e-07
+ fw=3.2e-07 sa=5.55e-07 sb=1.4e-07 sca=6.14367 scb=0.00275993 scc=2.35233e-05
MXI63/MPM6	XI63/in0_b	P<1>	vdd!	vdd!	g45p1svt
+ L=4.5e-08	W=1.6e-07
+ AD=2.24e-14	AS=2.24e-14	PD=6e-07	PS=6e-07
+ fw=1.6e-07 sa=1.4e-07 sb=1.4e-07 sca=3.91594 scb=0.000183079 scc=1.25917e-08
MXI2/MPM0	XI2/net5	P<3>	vdd!	vdd!	g45p1svt
+ L=4.5e-08	W=3.2e-07
+ AD=5.12e-14	AS=4.48e-14	PD=9.6e-07	PS=9.2e-07
+ fw=3.2e-07 sa=1.4e-07 sb=3.45e-07 sca=4.07201 scb=0.000304387 scc=1.00321e-07
MXI76/MPM0	G30	net4	vdd!	vdd!	g45p1svt	L=4.5e-08
+ W=1.6e-07
+ AD=2.24e-14	AS=2.24e-14	PD=6e-07	PS=6e-07
+ fw=1.6e-07 sa=1.4e-07 sb=1.4e-07 sca=4.52664 scb=0.000509491 scc=2.72339e-07
MXI74/MPM0	net36	net35	vdd!	vdd!	g45p1svt	L=4.5e-08
+ W=1.6e-07
+ AD=2.24e-14	AS=2.24e-14	PD=6e-07	PS=6e-07
+ fw=1.6e-07 sa=1.4e-07 sb=1.4e-07 sca=4.52664 scb=0.000509491 scc=2.72339e-07
MXI73/MPM0	net28	net27	vdd!	vdd!	g45p1svt	L=4.5e-08
+ W=1.6e-07
+ AD=2.24e-14	AS=2.24e-14	PD=6e-07	PS=6e-07
+ fw=1.6e-07 sa=1.4e-07 sb=1.4e-07 sca=4.52664 scb=0.000509491 scc=2.72339e-07
MXI146/MPM5	XI146/in1_b	in1<0>	vdd!	vdd!	g45p1svt
+ L=4.5e-08	W=1.6e-07
+ AD=2.24e-14	AS=2.24e-14	PD=6e-07	PS=6e-07
+ fw=1.6e-07 sa=1.4e-07 sb=1.4e-07 sca=4.01692 scb=0.000204276 scc=1.4787e-08
MXI2/MPM1	net46	P<2>	XI2/net5	vdd!	g45p1svt
+ L=4.5e-08	W=3.2e-07
+ AD=4.48e-14	AS=5.12e-14	PD=9.2e-07	PS=9.6e-07
+ fw=3.2e-07 sa=3.45e-07 sb=1.4e-07 sca=4.07201 scb=0.000304387 scc=1.00321e-07
MXI63/MPM2	XI63/net12	XI63/in0_b	vdd!	vdd!	g45p1svt
+ L=4.5e-08	W=3.2e-07
+ AD=1.92e-14	AS=4.48e-14	PD=7.6e-07	PS=9.2e-07
+ fw=3.2e-07 sa=1.4e-07 sb=5.55e-07 sca=6.14367 scb=0.00275993 scc=2.35233e-05
MXI63/MPM3	sum<1>	G<0>	XI63/net12	vdd!	g45p1svt
+ L=4.5e-08	W=3.2e-07
+ AD=5.12e-14	AS=1.92e-14	PD=9.6e-07	PS=7.6e-07
+ fw=3.2e-07 sa=2.45e-07 sb=4.5e-07 sca=6.14367 scb=0.00275993 scc=2.35233e-05
MXI3/MPM0	XI3/net5	P<1>	vdd!	vdd!	g45p1svt
+ L=4.5e-08	W=3.2e-07
+ AD=5.12e-14	AS=4.48e-14	PD=9.6e-07	PS=9.2e-07
+ fw=3.2e-07 sa=1.4e-07 sb=3.45e-07 sca=6.22501 scb=0.00222462 scc=6.96531e-06
MXI76__3/MPM0	G30	net4	vdd!	vdd!	g45p1svt	L=4.5e-08
+ W=1.6e-07
+ AD=2.24e-14	AS=2.24e-14	PD=6e-07	PS=6e-07
+ fw=1.6e-07 sa=1.4e-07 sb=1.4e-07 sca=4.52664 scb=0.000509491 scc=2.72339e-07
MXI63/MPM8	sum<1>	P<1>	XI63/net4	vdd!	g45p1svt
+ L=4.5e-08	W=3.2e-07
+ AD=5.12e-14	AS=1.92e-14	PD=9.6e-07	PS=7.6e-07
+ fw=3.2e-07 sa=4.5e-07 sb=2.45e-07 sca=6.14367 scb=0.00275993 scc=2.35233e-05
MXI3/MPM1	net49	sum<0>	XI3/net5	vdd!	g45p1svt
+ L=4.5e-08	W=3.2e-07
+ AD=4.48e-14	AS=5.12e-14	PD=9.2e-07	PS=9.6e-07
+ fw=3.2e-07 sa=3.45e-07 sb=1.4e-07 sca=10.7545 scb=0.00996388 scc=0.000263868
MXI63/MPM7	XI63/net4	XI63/in1_b	vdd!	vdd!	g45p1svt
+ L=4.5e-08	W=3.2e-07
+ AD=1.92e-14	AS=4.48e-14	PD=7.6e-07	PS=9.2e-07
+ fw=3.2e-07 sa=5.55e-07 sb=1.4e-07 sca=6.14367 scb=0.00275993 scc=2.35233e-05
MXI76__4/MPM0	G30	net4	vdd!	vdd!	g45p1svt	L=4.5e-08
+ W=1.6e-07
+ AD=2.24e-14	AS=2.24e-14	PD=6e-07	PS=6e-07
+ fw=1.6e-07 sa=1.4e-07 sb=1.4e-07 sca=4.52664 scb=0.000509491 scc=2.72339e-07
MXI80/MPM0	G50	net15	vdd!	vdd!	g45p1svt	L=4.5e-08
+ W=1.6e-07
+ AD=2.24e-14	AS=2.24e-14	PD=6e-07	PS=6e-07
+ fw=1.6e-07 sa=1.4e-07 sb=1.4e-07 sca=4.52664 scb=0.000509491 scc=2.72339e-07
MXI63/MPM5	XI63/in1_b	G<0>	vdd!	vdd!	g45p1svt
+ L=4.5e-08	W=1.6e-07
+ AD=2.24e-14	AS=2.24e-14	PD=6e-07	PS=6e-07
+ fw=1.6e-07 sa=1.4e-07 sb=1.4e-07 sca=7.71587 scb=0.00469792 scc=5.32189e-05
MXI62/MPM6	XI62/in0_b	P<2>	vdd!	vdd!	g45p1svt
+ L=4.5e-08	W=1.6e-07
+ AD=2.24e-14	AS=2.24e-14	PD=6e-07	PS=6e-07
+ fw=1.6e-07 sa=1.4e-07 sb=1.4e-07 sca=7.71587 scb=0.00469792 scc=5.32189e-05
MXI60/MPM6	XI60/in0_b	P<4>	vdd!	vdd!	g45p1svt
+ L=4.5e-08	W=1.6e-07
+ AD=2.24e-14	AS=2.24e-14	PD=6e-07	PS=6e-07
+ fw=1.6e-07 sa=1.4e-07 sb=1.4e-07 sca=3.91594 scb=0.000183079 scc=1.25917e-08
MXI1/MPM0	XI1/net5	P<5>	vdd!	vdd!	g45p1svt
+ L=4.5e-08	W=3.2e-07
+ AD=5.12e-14	AS=4.48e-14	PD=9.6e-07	PS=9.2e-07
+ fw=3.2e-07 sa=1.4e-07 sb=3.45e-07 sca=4.07201 scb=0.000304387 scc=1.00321e-07
MXI0/MPM0	XI0/net5	P<7>	vdd!	vdd!	g45p1svt
+ L=4.5e-08	W=3.2e-07
+ AD=5.12e-14	AS=4.48e-14	PD=9.6e-07	PS=9.2e-07
+ fw=3.2e-07 sa=1.4e-07 sb=3.45e-07 sca=4.07201 scb=0.000304387 scc=1.00321e-07
MXI87/MPM0	net7	net5	vdd!	vdd!	g45p1svt	L=4.5e-08
+ W=1.6e-07
+ AD=2.24e-14	AS=2.24e-14	PD=6e-07	PS=6e-07
+ fw=1.6e-07 sa=1.4e-07 sb=1.4e-07 sca=5.06716 scb=0.000703853 scc=3.37721e-07
MXI1/MPM1	net43	P<4>	XI1/net5	vdd!	g45p1svt
+ L=4.5e-08	W=3.2e-07
+ AD=4.48e-14	AS=5.12e-14	PD=9.2e-07	PS=9.6e-07
+ fw=3.2e-07 sa=3.45e-07 sb=1.4e-07 sca=4.07201 scb=0.000304387 scc=1.00321e-07
MXI0/MPM1	net40	P<6>	XI0/net5	vdd!	g45p1svt
+ L=4.5e-08	W=3.2e-07
+ AD=4.48e-14	AS=5.12e-14	PD=9.2e-07	PS=9.6e-07
+ fw=3.2e-07 sa=3.45e-07 sb=1.4e-07 sca=4.07201 scb=0.000304387 scc=1.00321e-07
MXI62/MPM2	XI62/net12	XI62/in0_b	vdd!	vdd!	g45p1svt
+ L=4.5e-08	W=3.2e-07
+ AD=1.92e-14	AS=4.48e-14	PD=7.6e-07	PS=9.2e-07
+ fw=3.2e-07 sa=1.4e-07 sb=5.55e-07 sca=6.91121 scb=0.00299832 scc=2.36419e-05
MXI60/MPM2	XI60/net12	XI60/in0_b	vdd!	vdd!	g45p1svt
+ L=4.5e-08	W=3.2e-07
+ AD=1.92e-14	AS=4.48e-14	PD=7.6e-07	PS=9.2e-07
+ fw=3.2e-07 sa=1.4e-07 sb=5.55e-07 sca=6.23386 scb=0.00277856 scc=2.35251e-05
MXI62/MPM3	sum<2>	G10	XI62/net12	vdd!	g45p1svt
+ L=4.5e-08	W=3.2e-07
+ AD=5.12e-14	AS=1.92e-14	PD=9.6e-07	PS=7.6e-07
+ fw=3.2e-07 sa=2.45e-07 sb=4.5e-07 sca=7.17858 scb=0.00308505 scc=2.36624e-05
MXI60/MPM3	sum<4>	G30	XI60/net12	vdd!	g45p1svt
+ L=4.5e-08	W=3.2e-07
+ AD=5.12e-14	AS=1.92e-14	PD=9.6e-07	PS=7.6e-07
+ fw=3.2e-07 sa=2.45e-07 sb=4.5e-07 sca=6.50123 scb=0.00286529 scc=2.35456e-05
MXI62/MPM8	sum<2>	P<2>	XI62/net4	vdd!	g45p1svt
+ L=4.5e-08	W=3.2e-07
+ AD=5.12e-14	AS=1.92e-14	PD=9.6e-07	PS=7.6e-07
+ fw=3.2e-07 sa=4.5e-07 sb=2.45e-07 sca=8.11102 scb=0.00378979 scc=2.47327e-05
MXI60/MPM8	sum<4>	P<4>	XI60/net4	vdd!	g45p1svt
+ L=4.5e-08	W=3.2e-07
+ AD=5.12e-14	AS=1.92e-14	PD=9.6e-07	PS=7.6e-07
+ fw=3.2e-07 sa=4.5e-07 sb=2.45e-07 sca=7.43367 scb=0.00357003 scc=2.46159e-05
MXI81/MPM0	G40	net20	vdd!	vdd!	g45p1svt	L=4.5e-08
+ W=1.6e-07
+ AD=2.24e-14	AS=2.24e-14	PD=6e-07	PS=6e-07
+ fw=1.6e-07 sa=1.4e-07 sb=1.4e-07 sca=4.52664 scb=0.000509491 scc=2.72339e-07
MXI4/MPM0	XI4/net5	net33	vdd!	vdd!	g45p1svt
+ L=4.5e-08	W=3.2e-07
+ AD=5.12e-14	AS=4.48e-14	PD=9.6e-07	PS=9.2e-07
+ fw=3.2e-07 sa=1.4e-07 sb=3.45e-07 sca=4.07201 scb=0.000304387 scc=1.00321e-07
MXI79/MPM0	G60	net34	vdd!	vdd!	g45p1svt	L=4.5e-08
+ W=1.6e-07
+ AD=2.24e-14	AS=2.24e-14	PD=6e-07	PS=6e-07
+ fw=1.6e-07 sa=1.4e-07 sb=1.4e-07 sca=4.52664 scb=0.000509491 scc=2.72339e-07
MXI62/MPM7	XI62/net4	XI62/in1_b	vdd!	vdd!	g45p1svt
+ L=4.5e-08	W=3.2e-07
+ AD=1.92e-14	AS=4.48e-14	PD=7.6e-07	PS=9.2e-07
+ fw=3.2e-07 sa=5.55e-07 sb=1.4e-07 sca=9.02964 scb=0.00498211 scc=3.116e-05
MXI60/MPM7	XI60/net4	XI60/in1_b	vdd!	vdd!	g45p1svt
+ L=4.5e-08	W=3.2e-07
+ AD=1.92e-14	AS=4.48e-14	PD=7.6e-07	PS=9.2e-07
+ fw=3.2e-07 sa=5.55e-07 sb=1.4e-07 sca=8.35229 scb=0.00476235 scc=3.10431e-05
MXI4/MPM1	net5	net19	XI4/net5	vdd!	g45p1svt
+ L=4.5e-08	W=3.2e-07
+ AD=4.48e-14	AS=5.12e-14	PD=9.2e-07	PS=9.6e-07
+ fw=3.2e-07 sa=3.45e-07 sb=1.4e-07 sca=4.07201 scb=0.000304387 scc=1.00321e-07
MXI77/MPM0	G20	net9	vdd!	vdd!	g45p1svt	L=4.5e-08
+ W=1.6e-07
+ AD=2.24e-14	AS=2.24e-14	PD=6e-07	PS=6e-07
+ fw=1.6e-07 sa=1.4e-07 sb=1.4e-07 sca=4.52664 scb=0.000509491 scc=2.72339e-07
MXI62/MPM5	XI62/in1_b	G10	vdd!	vdd!	g45p1svt
+ L=4.5e-08	W=1.6e-07
+ AD=2.24e-14	AS=2.24e-14	PD=6e-07	PS=6e-07
+ fw=1.6e-07 sa=1.4e-07 sb=1.4e-07 sca=27.1671 scb=0.0287257 scc=0.00270007
MXI60/MPM5	XI60/in1_b	G30	vdd!	vdd!	g45p1svt
+ L=4.5e-08	W=1.6e-07
+ AD=2.24e-14	AS=2.24e-14	PD=6e-07	PS=6e-07
+ fw=1.6e-07 sa=1.4e-07 sb=1.4e-07 sca=23.3672 scb=0.0242109 scc=0.00264686
MXI59/MPM6	XI59/in0_b	P<5>	vdd!	vdd!	g45p1svt
+ L=4.5e-08	W=1.6e-07
+ AD=2.24e-14	AS=2.24e-14	PD=6e-07	PS=6e-07
+ fw=1.6e-07 sa=1.4e-07 sb=1.4e-07 sca=3.91594 scb=0.000183079 scc=1.25917e-08
MXI57/MPM6	XI57/in0_b	P<7>	vdd!	vdd!	g45p1svt
+ L=4.5e-08	W=1.6e-07
+ AD=2.24e-14	AS=2.24e-14	PD=6e-07	PS=6e-07
+ fw=1.6e-07 sa=1.4e-07 sb=1.4e-07 sca=7.71587 scb=0.00469792 scc=5.32189e-05
MXI61/MPM6	XI61/in0_b	P<3>	vdd!	vdd!	g45p1svt
+ L=4.5e-08	W=1.6e-07
+ AD=2.24e-14	AS=2.24e-14	PD=6e-07	PS=6e-07
+ fw=1.6e-07 sa=1.4e-07 sb=1.4e-07 sca=7.71587 scb=0.00469792 scc=5.32189e-05
MXI58/MPM6	XI58/in0_b	P<6>	vdd!	vdd!	g45p1svt
+ L=4.5e-08	W=1.6e-07
+ AD=2.24e-14	AS=2.24e-14	PD=6e-07	PS=6e-07
+ fw=1.6e-07 sa=1.4e-07 sb=1.4e-07 sca=3.91594 scb=0.000183079 scc=1.25917e-08
MXI59/MPM2	XI59/net12	XI59/in0_b	vdd!	vdd!	g45p1svt
+ L=4.5e-08	W=3.2e-07
+ AD=1.92e-14	AS=4.48e-14	PD=7.6e-07	PS=9.2e-07
+ fw=3.2e-07 sa=1.4e-07 sb=5.55e-07 sca=6.23386 scb=0.00277856 scc=2.35251e-05
MXI57/MPM2	XI57/net12	XI57/in0_b	vdd!	vdd!	g45p1svt
+ L=4.5e-08	W=3.2e-07
+ AD=1.92e-14	AS=4.48e-14	PD=7.6e-07	PS=9.2e-07
+ fw=3.2e-07 sa=1.4e-07 sb=5.55e-07 sca=6.91121 scb=0.00299832 scc=2.36419e-05
MXI59/MPM3	sum<5>	G40	XI59/net12	vdd!	g45p1svt
+ L=4.5e-08	W=3.2e-07
+ AD=5.12e-14	AS=1.92e-14	PD=9.6e-07	PS=7.6e-07
+ fw=3.2e-07 sa=2.45e-07 sb=4.5e-07 sca=6.50123 scb=0.00286529 scc=2.35456e-05
MXI57/MPM3	sum<7>	G60	XI57/net12	vdd!	g45p1svt
+ L=4.5e-08	W=3.2e-07
+ AD=5.12e-14	AS=1.92e-14	PD=9.6e-07	PS=7.6e-07
+ fw=3.2e-07 sa=2.45e-07 sb=4.5e-07 sca=7.17858 scb=0.00308505 scc=2.36624e-05
MXI61/MPM2	XI61/net12	XI61/in0_b	vdd!	vdd!	g45p1svt
+ L=4.5e-08	W=3.2e-07
+ AD=1.92e-14	AS=4.48e-14	PD=7.6e-07	PS=9.2e-07
+ fw=3.2e-07 sa=1.4e-07 sb=5.55e-07 sca=6.91121 scb=0.00299832 scc=2.36419e-05
MXI58/MPM2	XI58/net12	XI58/in0_b	vdd!	vdd!	g45p1svt
+ L=4.5e-08	W=3.2e-07
+ AD=1.92e-14	AS=4.48e-14	PD=7.6e-07	PS=9.2e-07
+ fw=3.2e-07 sa=1.4e-07 sb=5.55e-07 sca=6.23386 scb=0.00277856 scc=2.35251e-05
MXI59/MPM8	sum<5>	P<5>	XI59/net4	vdd!	g45p1svt
+ L=4.5e-08	W=3.2e-07
+ AD=5.12e-14	AS=1.92e-14	PD=9.6e-07	PS=7.6e-07
+ fw=3.2e-07 sa=4.5e-07 sb=2.45e-07 sca=7.43367 scb=0.00357003 scc=2.46159e-05
MXI57/MPM8	sum<7>	P<7>	XI57/net4	vdd!	g45p1svt
+ L=4.5e-08	W=3.2e-07
+ AD=5.12e-14	AS=1.92e-14	PD=9.6e-07	PS=7.6e-07
+ fw=3.2e-07 sa=4.5e-07 sb=2.45e-07 sca=8.11102 scb=0.00378979 scc=2.47327e-05
MXI61/MPM3	sum<3>	G20	XI61/net12	vdd!	g45p1svt
+ L=4.5e-08	W=3.2e-07
+ AD=5.12e-14	AS=1.92e-14	PD=9.6e-07	PS=7.6e-07
+ fw=3.2e-07 sa=2.45e-07 sb=4.5e-07 sca=7.17858 scb=0.00308505 scc=2.36624e-05
MXI58/MPM3	sum<6>	G50	XI58/net12	vdd!	g45p1svt
+ L=4.5e-08	W=3.2e-07
+ AD=5.12e-14	AS=1.92e-14	PD=9.6e-07	PS=7.6e-07
+ fw=3.2e-07 sa=2.45e-07 sb=4.5e-07 sca=6.50123 scb=0.00286529 scc=2.35456e-05
MXI59/MPM7	XI59/net4	XI59/in1_b	vdd!	vdd!	g45p1svt
+ L=4.5e-08	W=3.2e-07
+ AD=1.92e-14	AS=4.48e-14	PD=7.6e-07	PS=9.2e-07
+ fw=3.2e-07 sa=5.55e-07 sb=1.4e-07 sca=8.35229 scb=0.00476235 scc=3.10431e-05
MXI57/MPM7	XI57/net4	XI57/in1_b	vdd!	vdd!	g45p1svt
+ L=4.5e-08	W=3.2e-07
+ AD=1.92e-14	AS=4.48e-14	PD=7.6e-07	PS=9.2e-07
+ fw=3.2e-07 sa=5.55e-07 sb=1.4e-07 sca=9.02964 scb=0.00498211 scc=3.116e-05
MXI61/MPM8	sum<3>	P<3>	XI61/net4	vdd!	g45p1svt
+ L=4.5e-08	W=3.2e-07
+ AD=5.12e-14	AS=1.92e-14	PD=9.6e-07	PS=7.6e-07
+ fw=3.2e-07 sa=4.5e-07 sb=2.45e-07 sca=8.11102 scb=0.00378979 scc=2.47327e-05
MXI58/MPM8	sum<6>	P<6>	XI58/net4	vdd!	g45p1svt
+ L=4.5e-08	W=3.2e-07
+ AD=5.12e-14	AS=1.92e-14	PD=9.6e-07	PS=7.6e-07
+ fw=3.2e-07 sa=4.5e-07 sb=2.45e-07 sca=7.43367 scb=0.00357003 scc=2.46159e-05
MXI61/MPM7	XI61/net4	XI61/in1_b	vdd!	vdd!	g45p1svt
+ L=4.5e-08	W=3.2e-07
+ AD=1.92e-14	AS=4.48e-14	PD=7.6e-07	PS=9.2e-07
+ fw=3.2e-07 sa=5.55e-07 sb=1.4e-07 sca=9.02964 scb=0.00498211 scc=3.116e-05
MXI58/MPM7	XI58/net4	XI58/in1_b	vdd!	vdd!	g45p1svt
+ L=4.5e-08	W=3.2e-07
+ AD=1.92e-14	AS=4.48e-14	PD=7.6e-07	PS=9.2e-07
+ fw=3.2e-07 sa=5.55e-07 sb=1.4e-07 sca=8.35229 scb=0.00476235 scc=3.10431e-05
MXI59/MPM5	XI59/in1_b	G40	vdd!	vdd!	g45p1svt
+ L=4.5e-08	W=1.6e-07
+ AD=2.24e-14	AS=2.24e-14	PD=6e-07	PS=6e-07
+ fw=1.6e-07 sa=1.4e-07 sb=1.4e-07 sca=23.3672 scb=0.0242109 scc=0.00264686
MXI57/MPM5	XI57/in1_b	G60	vdd!	vdd!	g45p1svt
+ L=4.5e-08	W=1.6e-07
+ AD=2.24e-14	AS=2.24e-14	PD=6e-07	PS=6e-07
+ fw=1.6e-07 sa=1.4e-07 sb=1.4e-07 sca=27.1671 scb=0.0287257 scc=0.00270007
MXI61/MPM5	XI61/in1_b	G20	vdd!	vdd!	g45p1svt
+ L=4.5e-08	W=1.6e-07
+ AD=2.24e-14	AS=2.24e-14	PD=6e-07	PS=6e-07
+ fw=1.6e-07 sa=1.4e-07 sb=1.4e-07 sca=27.1671 scb=0.0287257 scc=0.00270007
MXI58/MPM5	XI58/in1_b	G50	vdd!	vdd!	g45p1svt
+ L=4.5e-08	W=1.6e-07
+ AD=2.24e-14	AS=2.24e-14	PD=6e-07	PS=6e-07
+ fw=1.6e-07 sa=1.4e-07 sb=1.4e-07 sca=27.1671 scb=0.0287257 scc=0.00270007
*
*
*       CAPACITOR CARDS
*
*
C1	XI131/out_b	G<7>	1.4494e-16
C2	in0<0>	in0<1>	1.20046e-16
C3	net23	net24	9.30777e-17
C4	in0<1>	in0<2>	2.53029e-17
C5	P<1>	XI145/in0_b	9.86429e-17
C6	net27	net28	1.68555e-16
C7	sum<7>	eq	1.14055e-16
C8	eq	vdd!	1.03847e-16
C9	in0<3>	in0<2>	8.70124e-17
C10	in0<0>	in1<0>	5.38184e-16
C11	in0<4>	in0<2>	5.84026e-17
C12	in0<0>	in1<1>	4.37192e-17
C13	XI142/in0_b	vdd!	1.63549e-16
C14	in0<4>	in0<3>	6.73356e-17
C15	in0<5>	in0<3>	1.75778e-16
C16	in1<1>	in0<1>	5.02495e-16
C17	XI60/in0_b	sum<4>	8.68241e-17
C18	P<1>	XI145/in1_b	9.31428e-17
C19	in0<6>	in0<3>	7.12486e-17
C20	in0<5>	in0<4>	3.7147e-17
C21	sum<0>	in0<0>	5.58157e-17
C22	net19	XI60/in1_b	3.28049e-17
C23	in0<7>	in0<3>	4.25773e-17
C24	in0<6>	in0<4>	1.37561e-17
C25	in0<2>	in1<2>	4.09317e-16
C26	XI142/in1_b	vdd!	1.60739e-16
C27	in1<0>	in0<3>	1.01583e-17
C28	in0<6>	in0<5>	1.14534e-16
C29	in0<3>	in1<1>	3.89874e-17
C30	sum<4>	XI60/in1_b	8.77186e-17
C31	net5	eq	9.13644e-17
C32	in1<0>	in0<4>	2.26793e-16
C33	in0<3>	in1<2>	4.53616e-16
C34	P<4>	XI1/net5	3.0907e-17
C35	net13	XI97/net1	8.6453e-17
C36	in0<7>	in0<5>	3.60342e-17
C37	eq	net7	1.15835e-16
C38	in0<0>	vdd!	1.34712e-16
C39	in0<3>	in1<3>	5.00909e-16
C40	in1<1>	in0<4>	2.90133e-17
C41	in1<0>	in0<5>	4.49953e-17
C42	in0<7>	in0<6>	2.86464e-16
C43	in0<4>	in1<2>	7.38707e-17
C44	in0<0>	P<1>	2.18976e-17
C45	in1<1>	in0<5>	2.37076e-17
C46	in1<3>	in0<4>	3.96906e-16
C47	in1<0>	in0<6>	5.11882e-17
C48	in0<5>	in1<2>	2.63647e-16
C49	in0<4>	in1<4>	4.06067e-16
C50	net21	net22	1.66045e-16
C51	in1<1>	in0<6>	5.34653e-17
C52	in0<1>	vdd!	1.81046e-16
C53	in0<0>	G<0>	1.72698e-16
C54	in1<0>	in0<7>	5.1949e-17
C55	in1<3>	in0<5>	3.29154e-16
C56	XI63/in0_b	XI63/in1_b	5.09361e-17
C57	in1<2>	in0<6>	1.88193e-16
C58	P<3>	net9	5.29674e-17
C59	in1<1>	in0<7>	2.75039e-17
C60	in0<5>	in1<4>	1.15264e-17
C61	in0<1>	P<1>	1.67251e-16
C62	in0<6>	in1<3>	2.04178e-16
C63	in0<5>	in1<5>	4.77441e-16
C64	in1<2>	in0<7>	3.10862e-16
C65	in1<1>	in1<0>	3.83097e-16
C66	in0<2>	vdd!	2.92463e-16
C67	in0<5>	in1<6>	1.00938e-17
C68	in0<7>	in1<3>	4.96349e-17
C69	in1<0>	in1<2>	5.30298e-17
C70	in1<5>	in0<6>	1.13359e-16
C71	in0<1>	G<0>	1.4731e-17
C72	in1<4>	in0<7>	4.27817e-17
C73	P<2>	in0<2>	7.11271e-17
C74	in0<6>	in1<6>	5.43259e-16
C75	in1<0>	in1<3>	6.40253e-17
C76	in1<1>	in1<2>	2.67463e-16
C77	in1<5>	in0<7>	6.69791e-17
C78	in0<3>	vdd!	1.56801e-16
C79	G<6>	XI140/in1_b	1.44071e-17
C80	in1<0>	in1<4>	8.40752e-17
C81	net23	net16	8.42049e-17
C82	in1<1>	in1<3>	4.49801e-17
C83	in1<6>	in0<7>	2.7317e-16
C84	G10	net4	1.88806e-16
C85	in1<7>	in0<7>	4.80392e-16
C86	in0<3>	P<2>	9.5056e-17
C87	in1<1>	in1<4>	3.18492e-16
C88	in1<3>	in1<2>	6.31583e-17
C89	in0<4>	vdd!	1.49764e-16
C90	XI60/in0_b	XI60/in1_b	5.119e-17
C91	in1<1>	in1<5>	2.60847e-17
C92	in0<2>	G<2>	1.38379e-17
C93	XI146/in0_b	vdd!	1.64881e-16
C94	in1<1>	in1<6>	1.26372e-17
C95	in1<2>	in1<5>	1.78938e-17
C96	sum<0>	in1<0>	1.10778e-16
C97	P<2>	in0<4>	1.25217e-16
C98	in1<3>	in1<4>	1.47178e-16
C99	sum<4>	XI59/in1_b	3.91804e-17
C100	in0<5>	vdd!	2.77029e-16
C101	in1<3>	in1<5>	1.285e-16
C102	net2	in0<4>	7.84292e-17
C103	XI146/in1_b	vdd!	1.54556e-16
C104	P<4>	in0<4>	5.26863e-17
C105	in0<3>	G<2>	3.16582e-17
C106	in1<3>	in1<6>	2.30461e-16
C107	in1<4>	in1<5>	8.9347e-17
C108	in1<1>	sum<1>	1.12022e-17
C109	in0<6>	vdd!	2.01924e-16
C110	XI2/net5	net46	3.35988e-17
C111	in0<3>	G<3>	1.26732e-16
C112	in1<4>	in1<6>	9.6256e-17
C113	net20	G<4>	7.34318e-17
C114	in0<6>	G<6>	9.50464e-17
C115	XI131/out_b	P<6>	3.4695e-17
C116	XI132/net1	XI132/out_b	2.67499e-17
C117	in1<4>	in1<7>	1.08671e-16
C118	in0<7>	vdd!	1.83959e-16
C119	in0<3>	net6	1.18811e-17
C120	in1<5>	in1<6>	1.28229e-16
C121	in0<4>	G<2>	3.74986e-17
C122	P<3>	in0<3>	4.8186e-17
C123	net49	XI63/in1_b	3.76613e-17
C124	in0<7>	P<7>	1.692e-16
C125	P<5>	in0<4>	3.14817e-17
C126	XI138/out_b	in0<0>	3.05703e-16
C127	sum<3>	XI61/in0_b	9.02354e-17
C128	in1<5>	in1<7>	9.86473e-17
C129	in0<0>	XI138/net1	2.93987e-17
C130	net2	in0<6>	1.10758e-17
C131	in0<7>	G<6>	4.03983e-17
C132	in0<4>	G<3>	1.74148e-17
C133	in1<0>	vdd!	2.4337e-16
C134	in1<6>	in1<7>	8.07408e-17
C135	sum<3>	XI61/in1_b	9.46339e-17
C136	XI141/in1_b	XI141/in0_b	5.27985e-17
C137	P<6>	XI57/in0_b	4.24915e-17
C138	in0<4>	net6	1.94694e-17
C139	in0<5>	P<5>	1.45261e-16
C140	in0<4>	P<3>	4.38086e-17
C141	XI83/net5	net26	9.07024e-17
C142	in1<1>	vdd!	2.40606e-16
C143	XI142/in0_b	XI142/in1_b	5.0924e-17
C144	P<2>	in1<0>	3.66639e-17
C145	in0<5>	G<3>	3.55311e-17
C146	in1<0>	P<1>	3.17663e-16
C147	in1<2>	vdd!	3.58603e-16
C148	in1<0>	net2	5.6055e-17
C149	XI59/in0_b	sum<5>	8.72064e-17
C150	P<2>	in1<1>	8.03422e-17
C151	XI63/in0_b	vdd!	1.60052e-16
C152	in1<0>	P<4>	7.55819e-17
C153	in0<1>	XI137/out_b	2.99122e-16
C154	in0<4>	net3	1.67802e-17
C155	in0<5>	P<3>	3.99869e-17
C156	in0<1>	XI137/net1	2.86447e-17
C157	P<1>	in1<1>	3.45322e-16
C158	sum<5>	XI59/in1_b	9.0778e-17
C159	in1<3>	vdd!	3.66208e-16
C160	in0<6>	G<3>	1.29923e-17
C161	XI63/in1_b	vdd!	1.5217e-16
C162	XI115/net5	net10	9.4965e-17
C163	P<2>	in1<2>	1.12711e-16
C164	in0<4>	G<4>	1.22164e-17
C165	P<6>	in0<6>	7.57019e-17
C166	in1<0>	G<0>	1.24809e-16
C167	P<4>	in1<1>	4.76486e-17
C168	P<1>	in1<2>	3.15088e-17
C169	in1<4>	vdd!	2.41475e-16
C170	in1<3>	G<6>	1.22458e-16
C171	in1<1>	G30	8.3284e-17
C172	XI136/out_b	in0<2>	2.75536e-16
C173	in0<7>	G<7>	1.57001e-17
C174	in0<2>	XI136/net1	3.20651e-17
C175	XI91/net1	net11	5.05652e-17
C176	in1<2>	net2	6.91385e-17
C177	in1<4>	P<7>	6.61781e-17
C178	sum<1>	sum<2>	1.33341e-16
C179	net15	net16	2.3219e-16
C180	in0<0>	XI146/in0_b	2.61126e-16
C181	XI146/in1_b	in0<0>	1.91679e-16
C182	in1<0>	G<2>	3.02317e-17
C183	in1<5>	vdd!	3.47777e-16
C184	in1<1>	G<0>	4.60956e-17
C185	in1<4>	G<6>	5.22395e-17
C186	in1<0>	P<5>	2.17303e-17
C187	in0<7>	P<6>	1.9362e-17
C188	in1<5>	P<7>	1.85399e-16
C189	net3	net1	3.84871e-17
C190	in1<6>	vdd!	3.79528e-16
C191	sum<2>	sum<3>	8.60448e-17
C192	G<6>	in1<5>	1.064e-16
C193	in0<1>	XI145/in0_b	2.62865e-16
C194	in1<1>	G<2>	4.86182e-17
C195	XI145/in1_b	in0<1>	1.9755e-16
C196	in1<6>	P<7>	1.24901e-17
C197	in1<1>	P<5>	3.30696e-17
C198	G10	net46	6.1533e-17
C199	in1<7>	vdd!	3.41015e-16
C200	net32	net36	1.46969e-16
C201	in1<6>	G<6>	1.71679e-17
C202	in0<2>	XI144/in0_b	2.67385e-16
C203	P<4>	in1<4>	1.25963e-16
C204	XI144/in1_b	in0<2>	1.93262e-16
C205	XI135/out_b	in0<3>	3.08346e-16
C206	P<7>	in1<7>	1.49879e-16
C207	in1<0>	P<3>	3.46662e-17
C208	sum<3>	sum<4>	7.92464e-17
C209	in1<2>	G<2>	4.94542e-17
C210	in0<3>	XI135/net1	3.14117e-17
C211	in1<4>	G30	6.84509e-17
C212	sum<0>	vdd!	1.04258e-16
C213	XI91/net4	net35	2.76647e-17
C214	in1<2>	P<5>	2.87847e-17
C215	XI62/in0_b	vdd!	1.64104e-16
C216	sum<1>	vdd!	7.85614e-17
C217	G10	net19	2.04614e-16
C218	in1<2>	G<3>	4.24786e-17
C219	XI62/in1_b	vdd!	1.59981e-16
C220	in1<1>	P<3>	4.41005e-17
C221	sum<5>	sum<4>	1.39562e-16
C222	XI57/in1_b	XI57/in0_b	5.08836e-17
C223	in1<3>	P<5>	4.20367e-17
C224	sum<2>	vdd!	5.09148e-17
C225	in1<0>	net3	2.08131e-17
C226	sum<0>	XI3/net5	3.01158e-17
C227	XI84/net1	net11	5.04777e-17
C228	in1<1>	G<5>	4.00755e-17
C229	net15	net11	5.022e-17
C230	XI6/net2	net46	2.76546e-17
C231	in1<2>	net6	3.22659e-17
C232	in1<3>	G<3>	2.93107e-17
C233	sum<0>	P<1>	2.94594e-16
C234	XI141/in0_b	P<5>	8.50099e-17
C235	sum<3>	vdd!	6.59437e-17
C236	in1<2>	P<3>	1.2235e-17
C237	P<5>	in1<4>	5.50803e-17
C238	in1<1>	net13	2.35018e-17
C239	sum<1>	P<2>	2.656e-17
C240	sum<5>	sum<6>	5.92414e-17
C241	in1<1>	net16	1.28475e-17
C242	in1<4>	G<7>	2.20073e-17
C243	in1<3>	P<6>	1.21661e-17
C244	in1<0>	G<4>	2.59103e-17
C245	net22	net28	1.60842e-16
C246	XI131/net1	XI131/out_b	2.68629e-17
C247	sum<1>	P<1>	8.84332e-17
C248	sum<4>	vdd!	7.97506e-17
C249	in1<1>	net3	1.54878e-17
C250	XI102/net5	P<5>	1.09383e-17
C251	net35	XI91/net1	1.17529e-17
C252	sum<2>	P<2>	5.72595e-17
C253	P<5>	XI141/in1_b	8.80849e-17
C254	P<5>	in1<5>	6.60382e-17
C255	P<3>	in1<3>	4.06973e-17
C256	sum<5>	vdd!	9.30608e-17
C257	in1<0>	net10	2.10298e-17
C258	sum<7>	sum<6>	1.57345e-16
C259	in1<5>	G<7>	3.62022e-17
C260	in1<4>	P<6>	2.43837e-17
C261	in1<0>	G10	2.2604e-17
C262	in1<3>	G<5>	1.77562e-17
C263	in1<1>	G<4>	4.27729e-17
C264	sum<6>	vdd!	5.93084e-17
C265	XI134/out_b	in0<4>	2.84015e-16
C266	in1<0>	net4	1.45783e-17
C267	sum<0>	G<0>	2.36281e-17
C268	in0<4>	XI134/net1	3.65563e-17
C269	XI60/in0_b	vdd!	1.61643e-16
C270	in1<5>	net29	4.09923e-17
C271	sum<6>	XI57/in1_b	3.76601e-17
C272	net26	net5	5.88244e-17
C273	in1<6>	G<7>	1.22411e-17
C274	sum<7>	vdd!	7.82437e-17
C275	in1<5>	P<6>	1.131e-16
C276	in1<1>	net10	2.41201e-17
C277	XI60/in1_b	vdd!	1.53943e-16
C278	in1<4>	G<5>	1.21982e-16
C279	sum<1>	G<0>	9.25106e-17
C280	sum<7>	P<7>	3.36496e-17
C281	in1<1>	G10	7.03802e-17
C282	net19	XI4/net5	3.92093e-17
C283	in0<3>	XI143/in0_b	2.64976e-16
C284	XI143/in1_b	in0<3>	1.93229e-16
C285	XI133/out_b	in0<5>	2.72017e-16
C286	in1<1>	net4	7.01475e-17
C287	in1<6>	P<6>	4.21961e-17
C288	in1<4>	net13	8.25441e-17
C289	XI133/net1	in0<5>	3.01983e-17
C290	P<7>	vdd!	3.24545e-16
C291	sum<4>	P<4>	2.86983e-17
C292	in1<4>	net16	4.30211e-17
C293	XI132/out_b	in0<6>	3.07978e-16
C294	net29	in1<7>	1.98228e-16
C295	sum<1>	G<2>	1.08696e-17
C296	sum<4>	G30	7.38015e-17
C297	G<6>	vdd!	2.04649e-16
C298	in0<6>	XI132/net1	2.99846e-17
C299	sum<5>	XI58/in0_b	1.28756e-17
C300	in1<7>	P<6>	3.05889e-17
C301	in1<4>	net11	3.64349e-17
C302	P<1>	XI146/in1_b	2.12089e-17
C303	net34	net32	5.20861e-17
C304	XI6/net2	net19	2.60281e-17
C305	sum<4>	G50	2.25792e-17
C306	P<2>	vdd!	3.00506e-16
C307	in1<4>	net35	1.55055e-17
C308	G<6>	P<7>	1.69845e-16
C309	XI106/net1	G<2>	3.91378e-17
C310	XI143/in0_b	XI143/in1_b	5.05273e-17
C311	sum<3>	G40	1.70391e-17
C312	P<1>	vdd!	4.044e-16
C313	P<6>	XI58/in0_b	2.71272e-16
C314	sum<7>	XI57/in0_b	8.15141e-17
C315	in0<5>	XI141/in0_b	2.67185e-16
C316	in1<4>	G<4>	2.67303e-17
C317	G50	sum<5>	1.11222e-16
C318	in1<7>	net30	7.44265e-17
C319	G10	G20	1.11381e-16
C320	XI141/in1_b	in0<5>	1.987e-16
C321	XI59/in0_b	vdd!	1.64176e-16
C322	XI142/in0_b	P<4>	8.79915e-17
C323	in1<6>	net13	1.17029e-16
C324	XI133/out_b	G<5>	1.49564e-16
C325	net2	vdd!	6.25875e-17
C326	sum<7>	XI57/in1_b	8.5153e-17
C327	in1<6>	net16	4.09389e-17
C328	G40	sum<4>	1.31613e-16
C329	sum<6>	G50	2.2104e-17
C330	XI59/in1_b	vdd!	1.53573e-16
C331	in0<7>	XI131/out_b	2.77242e-16
C332	P<4>	XI142/in1_b	1.16963e-16
C333	in1<7>	net24	1.60395e-17
C334	XI58/in1_b	P<6>	1.96591e-16
C335	sum<5>	G60	2.72024e-17
C336	in0<7>	XI131/net1	2.86486e-17
C337	P<4>	vdd!	2.98499e-16
C338	G10	XI105/net5	3.32165e-17
C339	net27	XI84/net4	2.92665e-17
C340	XI96/net5	net15	9.51298e-17
C341	in1<6>	net11	5.06817e-17
C342	sum<5>	G40	2.9655e-17
C343	G30	vdd!	5.91389e-16
C344	G60	sum<6>	9.08989e-17
C345	P<3>	XI61/in0_b	2.86941e-16
C346	in1<4>	net4	1.06308e-16
C347	net34	net36	2.09991e-16
C348	in0<4>	XI142/in0_b	2.65808e-16
C349	G50	vdd!	2.40937e-16
C350	net19	net46	2.42572e-16
C351	P<1>	XI63/in0_b	2.75439e-16
C352	XI142/in1_b	in0<4>	2.00909e-16
C353	P<7>	G30	5.36181e-17
C354	sum<5>	P<5>	4.60561e-17
C355	P<2>	net2	1.00028e-16
C356	sum<7>	G60	2.68725e-17
C357	sum<2>	P<3>	1.75192e-17
C358	G10	net49	1.29194e-17
C359	XI58/in0_b	sum<6>	8.94879e-17
C360	G<0>	vdd!	2.79825e-16
C361	XI61/in1_b	P<3>	1.92784e-16
C362	XI137/out_b	G<1>	1.75801e-16
C363	XI63/in1_b	P<1>	1.9731e-16
C364	P<2>	XI62/in0_b	2.67605e-16
C365	sum<6>	XI58/in1_b	1.02788e-16
C366	G60	vdd!	2.19303e-16
C367	XI57/in0_b	vdd!	1.57859e-16
C368	sum<3>	P<3>	5.31387e-17
C369	XI62/in1_b	P<2>	1.94276e-16
C370	G40	vdd!	2.03866e-16
C371	P<7>	G60	2.40243e-16
C372	XI57/in1_b	vdd!	1.54935e-16
C373	net23	XI85/net1	9.35748e-17
C374	in1<0>	XI138/out_b	2.7071e-17
C375	G<2>	vdd!	1.43971e-16
C376	in1<2>	XI136/out_b	2.68417e-17
C377	P<5>	vdd!	3.05761e-16
C378	in1<1>	G<1>	1.20189e-17
C379	G<0>	P<2>	2.00878e-16
C380	net4	XI105/net5	1.0255e-16
C381	net19	net20	4.80473e-17
C382	in1<1>	XI137/out_b	2.96835e-17
C383	sum<6>	P<6>	8.60746e-17
C384	G<7>	vdd!	9.93529e-17
C385	in0<7>	XI139/in0_b	2.87492e-16
C386	P<1>	G<0>	5.98402e-16
C387	XI139/in1_b	in0<7>	1.96268e-16
C388	P<4>	G30	6.25649e-16
C389	G<3>	vdd!	1.9161e-16
C390	P<6>	sum<7>	1.0078e-16
C391	P<7>	G<7>	2.14824e-16
C392	G10	net1	2.49138e-16
C393	XI137/net1	XI137/out_b	2.70411e-17
C394	net29	vdd!	1.69041e-16
C395	in0<6>	XI140/in0_b	2.52436e-16
C396	P<2>	G<2>	3.62624e-16
C397	XI140/in1_b	in0<6>	1.9622e-16
C398	XI61/in0_b	vdd!	1.65261e-16
C399	in1<3>	XI135/out_b	2.54948e-17
C400	P<7>	XI57/in0_b	2.58327e-16
C401	in1<5>	net23	4.47033e-17
C402	P<6>	vdd!	4.24171e-16
C403	G<7>	G<6>	3.24534e-16
C404	G30	G50	3.31316e-17
C405	XI61/in1_b	vdd!	1.59893e-16
C406	net29	P<7>	4.47968e-16
C407	P<1>	G<2>	1.00953e-17
C408	net29	XI139/in1_b	2.16795e-17
C409	XI57/in1_b	P<7>	1.9094e-16
C410	XI58/in0_b	XI58/in1_b	5.13274e-17
C411	net6	vdd!	1.06067e-16
C412	net43	net19	1.01754e-16
C413	net4	net1	5.83958e-17
C414	P<6>	P<7>	5.67759e-16
C415	P<3>	vdd!	3.73864e-16
C416	net13	XI134/out_b	1.33823e-17
C417	G<2>	net2	2.27714e-16
C418	G<3>	P<2>	1.01033e-17
C419	net31	XI91/net1	8.37891e-17
C420	XI1/net5	net43	3.82168e-17
C421	net30	vdd!	1.52161e-16
C422	G<6>	P<6>	2.00668e-16
C423	sum<2>	G10	4.8744e-17
C424	XI144/in0_b	in1<2>	5.48302e-17
C425	net19	net33	3.00967e-16
C426	G40	G30	1.87044e-17
C427	net20	net43	6.73997e-17
C428	G<5>	vdd!	1.5535e-16
C429	XI144/in1_b	in1<2>	2.57858e-16
C430	P<5>	P<4>	5.13302e-16
C431	net24	vdd!	1.16466e-16
C432	G40	G50	1.40689e-17
C433	in1<7>	net23	1.59936e-17
C434	G10	net9	8.51853e-17
C435	XI58/in0_b	vdd!	1.63408e-16
C436	G10	sum<3>	2.19148e-17
C437	G<3>	net2	7.93827e-17
C438	P<2>	net6	2.06694e-16
C439	net13	vdd!	1.63672e-16
C440	P<5>	G30	1.04473e-16
C441	XI58/in1_b	vdd!	1.5849e-16
C442	G<6>	net30	2.27842e-17
C443	net16	vdd!	3.74206e-16
C444	P<2>	P<3>	4.90346e-16
C445	XI97/net1	G<4>	3.95708e-17
C446	XI133/out_b	in1<4>	3.02564e-17
C447	P<5>	G50	2.05176e-17
C448	G10	sum<4>	1.77102e-17
C449	net3	vdd!	8.07012e-17
C450	XI145/in0_b	in1<1>	5.4729e-17
C451	net28	net5	4.84206e-17
C452	XI145/in1_b	in1<1>	2.57881e-16
C453	net46	net49	3.82086e-16
C454	sum<0>	net49	2.1485e-16
C455	net4	sum<4>	2.45898e-17
C456	P<7>	net16	8.06299e-17
C457	net11	vdd!	2.92384e-16
C458	G<3>	XI106/net1	1.63274e-17
C459	net6	net2	7.80811e-17
C460	in1<4>	XI134/out_b	2.43889e-17
C461	net35	vdd!	1.14937e-16
C462	in1<6>	XI132/out_b	2.04308e-17
C463	P<3>	net2	2.1337e-16
C464	G<6>	net16	8.08321e-17
C465	P<7>	net11	5.42515e-17
C466	net27	vdd!	1.3066e-16
C467	in1<5>	XI133/out_b	2.42396e-17
C468	net26	net7	4.28077e-17
C469	net49	net19	2.54039e-17
C470	P<6>	G30	4.20025e-17
C471	net49	sum<1>	7.86492e-17
C472	net43	net33	5.44325e-17
C473	XI97/net1	P<5>	1.37422e-17
C474	P<7>	net35	1.47017e-16
C475	G<4>	vdd!	1.30413e-16
C476	G40	P<5>	2.46383e-16
C477	XI115/net5	vdd!	1.11218e-16
C478	XI133/net1	XI133/out_b	2.6866e-17
C479	sum<2>	G20	4.98117e-17
C480	G<6>	net11	3.27431e-16
C481	net31	vdd!	5.32887e-17
C482	G50	P<6>	1.27628e-16
C483	in1<0>	XI146/in0_b	5.98233e-17
C484	P<2>	net3	2.03916e-17
C485	net5	net19	1.89286e-16
C486	XI146/in1_b	in1<0>	2.58786e-16
C487	G10	XI111/net5	3.47917e-17
C488	net19	sum<4>	1.24848e-16
C489	net21	vdd!	5.80823e-17
C490	net49	sum<2>	1.66807e-17
C491	XI105/net5	vdd!	1.04312e-16
C492	in1<7>	XI131/out_b	2.7063e-17
C493	net10	vdd!	1.39968e-16
C494	G<6>	net27	1.18096e-17
C495	sum<3>	G20	3.61479e-17
C496	XI139/in0_b	XI139/in1_b	5.12834e-17
C497	net17	vdd!	2.29768e-16
C498	P<6>	G60	4.62229e-17
C499	XI96/net5	vdd!	1.11954e-16
C500	G<5>	G30	4.23645e-17
C501	net19	sum<5>	3.09172e-17
C502	G<3>	G<2>	2.57734e-16
C503	P<4>	XI60/in0_b	2.71612e-16
C504	G10	vdd!	4.61215e-16
C505	XI84/net1	net21	8.46396e-17
C506	net13	P<4>	1.29342e-17
C507	G<6>	net31	1.69978e-16
C508	net3	net2	7.15669e-17
C509	XI60/in1_b	P<4>	1.97633e-16
C510	net4	vdd!	3.03402e-16
C511	XI141/in0_b	in1<5>	5.92977e-17
C512	G<0>	XI63/in0_b	5.68356e-17
C513	XI102/net5	vdd!	1.09955e-16
C514	XI85/net4	net29	2.93677e-17
C515	XI141/in1_b	in1<5>	3.00537e-16
C516	net32	vdd!	1.36069e-16
C517	net10	G<1>	5.86808e-17
C518	net5	net34	1.58184e-17
C519	XI63/in1_b	G<0>	2.56559e-16
C520	in1<3>	XI143/in0_b	5.52471e-17
C521	net22	vdd!	1.407e-16
C522	net16	G30	3.37671e-16
C523	in1<3>	XI143/in1_b	2.67529e-16
C524	XI90/net5	vdd!	1.09563e-16
C525	G<2>	net6	1.10705e-16
C526	net36	vdd!	9.63101e-17
C527	G<7>	net29	1.82461e-17
C528	net26	vdd!	2.458e-17
C529	XI5/net2	net33	2.19368e-17
C530	net28	vdd!	1.0619e-16
C531	net34	net40	4.96743e-17
C532	G<2>	P<3>	1.9831e-16
C533	G30	XI60/in0_b	6.02404e-17
C534	G30	net11	2.76485e-16
C535	G<7>	P<6>	1.55391e-16
C536	net46	vdd!	7.71074e-17
C537	P<7>	net36	1.21956e-16
C538	XI83/net5	vdd!	1.09061e-16
C539	net5	sum<5>	3.32446e-17
C540	XI134/out_b	G<4>	1.49315e-16
C541	G<6>	net32	4.58735e-17
C542	net10	P<1>	2.90555e-16
C543	G10	P<2>	4.5004e-16
C544	G30	XI60/in1_b	2.5906e-16
C545	net19	vdd!	2.49998e-16
C546	G<4>	P<4>	2.18162e-16
C547	net43	net40	2.97438e-16
C548	net20	vdd!	7.41962e-17
C549	net33	net5	4.70847e-17
C550	XI111/net5	vdd!	1.05708e-16
C551	G<3>	net6	1.31444e-16
C552	net34	vdd!	7.49478e-17
C553	P<1>	G10	1.2761e-16
C554	net29	P<6>	2.30831e-16
C555	net5	sum<6>	3.77971e-17
C556	net19	net9	3.03953e-17
C557	G30	G<4>	3.01912e-16
C558	XI138/net1	XI138/out_b	2.6878e-17
C559	net26	net22	4.61786e-17
C560	net43	vdd!	1.51893e-16
C561	P<5>	G<5>	5.13163e-17
C562	XI62/in0_b	XI62/in1_b	5.38434e-17
C563	G<3>	P<3>	1.61873e-16
C564	net33	net40	2.66414e-16
C565	net33	vdd!	1.51958e-16
C566	XI106/net1	vdd!	1.01265e-16
C567	P<7>	net34	2.67709e-16
C568	XI106/net4	net6	3.03904e-17
C569	G20	vdd!	2.2251e-16
C570	net5	sum<7>	5.04474e-17
C571	P<4>	net17	1.83869e-16
C572	XI146/in1_b	XI146/in0_b	5.3605e-17
C573	in1<7>	XI139/in0_b	5.65871e-17
C574	net23	vdd!	1.03009e-16
C575	net13	P<5>	2.73296e-16
C576	net15	net43	4.13688e-17
C577	net46	P<2>	1.96789e-16
C578	XI111/net5	net9	9.61826e-17
C579	in1<7>	XI139/in1_b	2.50098e-16
C580	net30	net29	1.43744e-16
C581	net49	vdd!	1.91319e-16
C582	XI142/in0_b	in1<4>	5.4794e-17
C583	G<2>	net3	7.41466e-17
C584	XI85/net1	vdd!	9.04233e-17
C585	XI142/in1_b	in1<4>	2.61032e-16
C586	P<2>	net19	1.62986e-17
C587	net17	G30	2.08038e-17
C588	net4	P<4>	6.13217e-17
C589	P<3>	XI143/in0_b	8.73409e-17
C590	net5	vdd!	1.15073e-16
C591	net6	XI106/net1	1.01548e-17
C592	in1<5>	XI140/in0_b	1.58419e-17
C593	P<6>	XI140/in0_b	1.031e-16
C594	net6	P<3>	2.33077e-16
C595	P<7>	net23	1.8837e-16
C596	net49	XI3/net5	3.74403e-17
C597	net40	vdd!	8.59519e-17
C598	G<7>	net16	1.95736e-16
C599	P<3>	XI143/in1_b	9.15377e-17
C600	G20	XI61/in0_b	6.34432e-17
C601	net1	vdd!	1.23364e-16
C602	net4	G30	5.69713e-16
C603	P<6>	XI140/in1_b	9.142e-17
C604	P<6>	XI91/net1	3.28918e-17
C605	XI91/net1	vdd!	9.92716e-17
C606	XI62/in0_b	G10	5.5486e-17
C607	G<0>	net10	9.05956e-17
C608	net5	P<7>	5.01137e-17
C609	net15	vdd!	6.34472e-17
C610	XI97/net4	net17	2.89768e-17
C611	XI59/in1_b	XI59/in0_b	5.11231e-17
C612	G30	net32	2.74577e-16
C613	G<6>	net23	3.08876e-16
C614	P<7>	net40	8.74218e-17
C615	net7	vdd!	1.3668e-16
C616	G20	XI61/in1_b	2.6305e-16
C617	G30	net22	2.39558e-16
C618	XI62/in1_b	G10	2.65798e-16
C619	G<3>	net3	3.44655e-17
C620	net9	vdd!	6.07712e-17
C621	XI140/in0_b	in1<6>	5.53474e-17
C622	G<0>	G10	1.21615e-17
C623	XI84/net1	vdd!	9.94312e-17
C624	XI140/in1_b	in1<6>	2.58574e-16
C625	net36	G30	3.49041e-16
C626	XI136/out_b	vdd!	1.11633e-16
C627	P<5>	G<4>	2.27454e-16
C628	P<6>	net16	1.26219e-16
C629	net28	G30	3.14836e-16
C630	net19	P<4>	5.19422e-17
C631	XI85/net1	P<7>	2.37644e-17
C632	net5	net40	2.02752e-17
C633	P<2>	net49	7.78475e-17
C634	net17	XI97/net1	2.23197e-17
C635	P<3>	XI106/net1	3.54163e-17
C636	XI135/out_b	vdd!	1.13567e-16
C637	net20	P<4>	2.66732e-16
C638	XI97/net1	vdd!	1.03983e-16
C639	XI134/net1	XI134/out_b	2.31103e-17
C640	net30	net24	5.08917e-17
C641	G20	net9	1.26736e-16
C642	vdd!	XI2/net5	4.95312e-17
C643	G30	net19	4.9651e-17
C644	net26	net28	2.10692e-16
C645	XI132/out_b	vdd!	1.13387e-16
C646	P<1>	net49	8.17118e-17
C647	P<6>	net11	1.61143e-16
C648	vdd!	XI3/net5	5.32781e-17
C649	net6	net3	1.76619e-16
C650	XI140/in0_b	XI140/in1_b	5.1487e-17
C651	P<4>	net43	2.01311e-16
C652	G30	net20	9.71607e-17
C653	vdd!	XI1/net5	5.05896e-17
C654	XI131/out_b	vdd!	1.00074e-16
C655	P<6>	net35	2.36009e-16
C656	G<2>	G10	2.86843e-16
C657	G30	net34	1.00499e-16
C658	G50	net19	1.02346e-17
C659	vdd!	XI0/net5	5.02946e-17
C660	P<3>	net3	5.67327e-17
C661	net30	net16	1.48376e-16
C662	G<5>	net13	1.63483e-16
C663	P<5>	net17	2.01631e-16
C664	G30	net43	2.05581e-17
C665	vdd!	XI4/net5	4.78873e-17
C666	G<1>	vdd!	1.41118e-16
C667	P<2>	net9	2.35868e-16
C668	G<5>	net16	1.9817e-17
C669	XI85/net1	G<6>	4.39045e-17
C670	XI137/out_b	vdd!	1.11663e-16
C671	XI136/out_b	P<2>	3.69319e-17
C672	P<7>	XI131/out_b	2.02348e-17
C673	net5	net7	1.30721e-16
C674	G50	net43	1.34677e-16
C675	net30	net11	1.52614e-16
C676	XI132/out_b	G<6>	1.47653e-16
C677	net2	net1	1.31516e-16
C678	net24	net16	1.13675e-16
C679	P<6>	net31	2.73284e-16
C680	XI133/out_b	vdd!	1.08436e-16
C681	G50	net33	1.28828e-17
C682	XI4/net5	net5	3.39097e-17
C683	G<5>	net11	1.13593e-17
C684	net13	net16	1.90768e-16
C685	P<6>	XI0/net5	3.01865e-17
C686	XI138/out_b	vdd!	1.02233e-16
C687	net19	G40	8.69512e-17
C688	G30	net5	3.55158e-17
C689	net30	net27	2.31373e-16
C690	net34	G60	1.04583e-16
C691	net24	net11	2.46905e-16
C692	G<2>	net46	3.70659e-17
C693	G30	net40	2.31403e-17
C694	XI134/out_b	vdd!	1.03933e-16
C695	net20	G40	8.44221e-17
C696	net11	net13	2.93334e-16
C697	XI61/in1_b	XI61/in0_b	5.0308e-17
C698	G<2>	net19	9.0344e-17
C699	G50	net5	1.29744e-17
C700	G40	XI59/in0_b	6.77935e-17
C701	XI0/net5	net40	3.39219e-17
C702	XI144/in0_b	vdd!	1.68704e-16
C703	XI146/in0_b	sum<0>	8.57012e-17
C704	XI96/net5	net16	1.14431e-17
C705	G30	net15	1.17727e-16
C706	XI144/in0_b	XI144/in1_b	5.10734e-17
C707	G<5>	G<4>	4.39956e-16
C708	net24	net27	3.2253e-17
C709	sum<0>	XI146/in1_b	9.61394e-17
C710	net43	G40	2.64478e-17
C711	XI144/in1_b	vdd!	1.6046e-16
C712	G<0>	net49	3.94973e-17
C713	G40	XI59/in1_b	2.45684e-16
C714	net16	net11	3.30659e-16
C715	XI102/net5	net20	9.09346e-17
C716	P<5>	net19	5.27668e-17
C717	G60	XI57/in0_b	5.94519e-17
C718	net21	net30	1.70573e-16
C719	net16	net35	2.22742e-16
C720	G60	XI57/in1_b	2.54891e-16
C721	P<5>	net20	3.17154e-16
C722	net15	G50	1.12528e-16
C723	P<6>	net32	8.26859e-17
C724	G50	XI58/in0_b	5.69603e-17
C725	net13	G<4>	2.49309e-16
C726	net16	net27	2.57808e-16
C727	P<3>	G10	2.17125e-16
C728	net5	G60	9.47367e-17
C729	P<1>	XI137/out_b	1.30658e-17
C730	G50	XI58/in1_b	2.62032e-16
C731	XI141/in0_b	vdd!	1.62041e-16
C732	P<5>	net43	7.22153e-17
C733	net24	net21	2.49292e-16
C734	net40	G60	3.96783e-17
C735	P<3>	net4	1.71743e-16
C736	P<6>	net36	1.81761e-17
C737	XI141/in1_b	vdd!	1.48943e-16
C738	net35	net11	3.28143e-17
C739	G<5>	net17	3.69054e-17
C740	XI84/net1	net30	3.25883e-17
C741	net40	XI5/net2	3.71642e-17
C742	net27	net11	2.21979e-17
C743	G<2>	net49	4.80866e-17
C744	XI63/in0_b	sum<1>	8.52985e-17
C745	sum<1>	XI63/in1_b	8.27542e-17
C746	P<2>	XI2/net5	2.98696e-17
C747	XI144/in0_b	P<2>	8.75176e-17
C748	net2	XI106/net1	8.48739e-17
C749	XI145/in1_b	XI145/in0_b	5.1272e-17
C750	XI96/net5	G30	3.51019e-17
C751	net19	P<6>	3.56453e-17
C752	P<5>	XI59/in0_b	2.85124e-16
C753	XI139/in0_b	vdd!	1.58985e-16
C754	P<2>	XI144/in1_b	1.09149e-16
C755	net13	net17	1.12478e-16
C756	net31	net11	2.73961e-16
C757	XI139/in1_b	vdd!	1.55573e-16
C758	XI59/in1_b	P<5>	2.00115e-16
C759	G<7>	net23	4.04566e-17
C760	XI90/net5	net34	9.3165e-17
C761	G30	XI102/net5	3.47461e-17
C762	net16	net17	3.65277e-16
C763	net21	net11	2.15413e-16
C764	net35	net31	1.22275e-16
C765	P<6>	net34	1.34492e-16
C766	P<3>	net46	1.14148e-16
C767	P<7>	XI139/in0_b	9.50132e-17
C768	G30	XI90/net5	3.64935e-17
C769	P<3>	net19	1.1307e-16
C770	P<7>	XI139/in1_b	8.43881e-17
C771	net24	net22	5.03938e-17
C772	XI145/in0_b	vdd!	1.59703e-16
C773	net9	G<2>	4.49015e-17
C774	G30	net26	6.29843e-17
C775	net3	G10	3.33626e-16
C776	net11	net17	1.54592e-16
C777	net29	net23	9.66764e-17
C778	XI145/in1_b	vdd!	1.57282e-16
C779	net27	net21	1.31674e-16
C780	G<2>	XI136/out_b	1.60955e-16
C781	XI136/net1	XI136/out_b	2.6735e-17
C782	XI134/out_b	P<4>	3.56103e-17
C783	XI62/in0_b	sum<2>	8.90219e-17
C784	net4	net3	2.03695e-16
C785	G30	XI83/net5	3.83974e-17
C786	G<0>	XI115/net5	4.35339e-17
C787	sum<2>	XI62/in1_b	9.74163e-17
C788	G<0>	G<1>	2.40338e-16
C789	G<5>	XI97/net1	1.52242e-17
C790	P<6>	net23	1.25179e-17
C791	XI143/in0_b	vdd!	1.57873e-16
C792	in1<5>	XI85/net1	4.3603e-17
C793	net5	P<6>	1.91808e-16
C794	XI143/in1_b	vdd!	1.56309e-16
C795	P<3>	G20	2.24048e-16
C796	net40	P<6>	2.06744e-16
C797	net35	net32	1.24203e-16
C798	G<0>	XI138/out_b	1.9606e-16
C799	P<3>	net49	1.07949e-17
C800	net23	net30	1.43508e-16
C801	XI140/in0_b	vdd!	1.55646e-16
C802	net16	XI91/net4	1.10026e-17
C803	XI140/in1_b	vdd!	1.57465e-16
C804	net35	net36	1.67384e-16
C805	net27	net22	1.25456e-16
C806	XI135/out_b	G<3>	1.50413e-16
C807	XI135/net1	XI135/out_b	2.68629e-17
C808	G10	XI61/in0_b	1.11357e-17
C809	P<3>	net1	1.04164e-17
C810	net31	net32	1.77661e-16
C811	G10	net10	2.70232e-16
C812	eq	gnd!	1.7345e-16
C813	in0<0>	gnd!	2.98784e-16
C814	in0<1>	gnd!	2.82801e-16
C815	in0<2>	gnd!	2.29971e-16
C816	in0<3>	gnd!	2.44067e-16
C817	in0<4>	gnd!	2.4027e-16
C818	in0<5>	gnd!	2.49144e-16
C819	in0<6>	gnd!	2.87011e-16
C820	in0<7>	gnd!	3.03769e-16
C821	in1<0>	gnd!	3.23921e-16
C822	in1<1>	gnd!	3.09433e-16
C823	in1<2>	gnd!	3.40648e-16
C824	in1<3>	gnd!	3.02816e-16
C825	in1<4>	gnd!	2.4827e-16
C826	in1<5>	gnd!	3.06923e-16
C827	in1<6>	gnd!	3.26969e-16
C828	in1<7>	gnd!	3.1459e-16
C829	sum<0>	gnd!	3.97496e-16
C830	sum<1>	gnd!	1.92467e-16
C831	sum<2>	gnd!	1.98124e-16
C832	sum<3>	gnd!	2.01233e-16
C833	sum<4>	gnd!	2.84375e-16
C834	sum<5>	gnd!	1.63983e-16
C835	sum<6>	gnd!	2.03419e-16
C836	sum<7>	gnd!	2.25185e-16
C837	vdd!	gnd!	1.0041e-15
C838	P<7>	gnd!	4.4817e-16
C839	G<6>	gnd!	2.37149e-16
C840	P<2>	gnd!	5.24194e-16
C841	P<1>	gnd!	3.86445e-16
C842	net2	gnd!	1.66311e-16
C843	P<4>	gnd!	4.90052e-16
C844	G30	gnd!	7.03849e-16
C845	G50	gnd!	3.32226e-16
C846	G<0>	gnd!	2.31352e-16
C847	G60	gnd!	2.8469e-16
C848	G40	gnd!	2.82493e-16
C849	G<2>	gnd!	3.14229e-16
C850	P<5>	gnd!	4.06781e-16
C851	G<7>	gnd!	1.40042e-16
C852	G<3>	gnd!	1.16063e-16
C853	net29	gnd!	1.33702e-16
C854	P<6>	gnd!	5.69588e-16
C855	net6	gnd!	9.85895e-17
C856	P<3>	gnd!	3.72975e-16
C857	net30	gnd!	1.79475e-16
C858	G<5>	gnd!	1.6552e-16
C859	net24	gnd!	1.869e-16
C860	net13	gnd!	2.5565e-16
C861	net16	gnd!	3.46031e-16
C862	net3	gnd!	9.61673e-17
C863	net11	gnd!	3.28937e-16
C864	net35	gnd!	1.14522e-16
C865	net27	gnd!	1.23073e-16
C866	G<4>	gnd!	2.30403e-16
C867	net31	gnd!	1.64977e-16
C868	net21	gnd!	1.65876e-16
C869	net10	gnd!	2.7001e-16
C870	net17	gnd!	1.87148e-16
C871	G10	gnd!	5.16204e-16
C872	net4	gnd!	4.24461e-16
C873	net32	gnd!	1.20009e-16
C874	net22	gnd!	1.47848e-16
C875	net36	gnd!	1.04813e-16
C876	net28	gnd!	1.20753e-16
C877	net46	gnd!	1.35952e-16
C878	net19	gnd!	1.81886e-16
C879	net20	gnd!	2.01944e-16
C880	net34	gnd!	1.80397e-16
C881	net43	gnd!	1.551e-16
C882	net33	gnd!	1.3649e-16
C883	G20	gnd!	3.79519e-16
C884	net23	gnd!	1.65413e-16
C885	net49	gnd!	2.39391e-16
C886	net5	gnd!	1.50505e-16
C887	net40	gnd!	1.61274e-16
C888	net1	gnd!	1.11367e-16
C889	net15	gnd!	1.76033e-16
C890	net7	gnd!	1.51463e-16
C891	net9	gnd!	1.8302e-16
C892	XI136/out_b	gnd!	8.11963e-17
C893	XI136/net1	gnd!	4.17937e-17
C894	XI135/out_b	gnd!	8.92601e-17
C895	XI135/net1	gnd!	4.26741e-17
C896	XI132/out_b	gnd!	9.48068e-17
C897	XI132/net1	gnd!	4.20416e-17
C898	XI131/out_b	gnd!	7.76873e-17
C899	XI131/net1	gnd!	4.37684e-17
C900	G<1>	gnd!	1.38748e-16
C901	XI137/out_b	gnd!	8.68157e-17
C902	XI137/net1	gnd!	4.68509e-17
C903	XI133/out_b	gnd!	9.49965e-17
C904	XI133/net1	gnd!	4.43887e-17
C905	XI138/out_b	gnd!	8.65507e-17
C906	XI138/net1	gnd!	3.90128e-17
C907	XI134/out_b	gnd!	8.28287e-17
C908	XI134/net1	gnd!	4.20652e-17
C909	XI144/in0_b	gnd!	1.65016e-16
C910	XI144/in1_b	gnd!	3.00025e-16
C911	XI144/net3	gnd!	1.16828e-18
C912	XI144/net17	gnd!	1.16058e-18
C913	XI144/net12	gnd!	1.5482e-18
C914	XI144/net4	gnd!	2.54585e-18
C915	XI141/in0_b	gnd!	1.60556e-16
C916	XI141/in1_b	gnd!	2.84727e-16
C917	XI141/net3	gnd!	1.25978e-19
C918	XI141/net17	gnd!	1.17127e-18
C919	XI141/net12	gnd!	6.49259e-19
C920	XI141/net4	gnd!	1.90873e-18
C921	XI139/in0_b	gnd!	1.67166e-16
C922	XI139/in1_b	gnd!	2.87985e-16
C923	XI139/net3	gnd!	2.16127e-18
C924	XI139/net17	gnd!	7.74567e-19
C925	XI139/net12	gnd!	1.54744e-18
C926	XI139/net4	gnd!	1.85343e-18
C927	XI145/in0_b	gnd!	1.67367e-16
C928	XI145/in1_b	gnd!	2.9454e-16
C929	XI145/net3	gnd!	1.17541e-18
C930	XI145/net17	gnd!	1.17541e-18
C931	XI145/net12	gnd!	1.54744e-18
C932	XI145/net4	gnd!	1.90845e-18
C933	XI143/in0_b	gnd!	1.70962e-16
C934	XI143/in1_b	gnd!	2.92518e-16
C935	XI143/net3	gnd!	1.17127e-18
C936	XI143/net17	gnd!	1.17127e-18
C937	XI143/net12	gnd!	1.54744e-18
C938	XI143/net4	gnd!	2.99891e-18
C939	XI140/in0_b	gnd!	1.64834e-16
C940	XI140/in1_b	gnd!	2.97389e-16
C941	XI140/net3	gnd!	1.38546e-18
C942	XI140/net17	gnd!	8.62428e-20
C943	XI140/net12	gnd!	1.36819e-18
C944	XI140/net4	gnd!	1.714e-18
C945	XI142/in0_b	gnd!	1.68307e-16
C946	XI142/in1_b	gnd!	2.93203e-16
C947	XI142/net3	gnd!	1.16115e-18
C948	XI142/net17	gnd!	1.16058e-18
C949	XI142/net12	gnd!	2.52943e-18
C950	XI142/net4	gnd!	8.8519e-19
C951	XI146/in0_b	gnd!	1.62652e-16
C952	XI146/in1_b	gnd!	2.81013e-16
C953	XI146/net3	gnd!	3.48414e-19
C954	XI146/net17	gnd!	1.46453e-18
C955	XI146/net12	gnd!	1.5482e-18
C956	XI146/net4	gnd!	2.53512e-18
C957	XI63/in0_b	gnd!	1.72541e-16
C958	XI63/in1_b	gnd!	2.86065e-16
C959	XI63/net3	gnd!	1.16115e-18
C960	XI63/net17	gnd!	9.67651e-19
C961	XI63/net12	gnd!	1.56038e-18
C962	XI63/net4	gnd!	1.18162e-18
C963	XI62/in0_b	gnd!	1.62637e-16
C964	XI62/in1_b	gnd!	2.83973e-16
C965	XI62/net3	gnd!	2.62854e-20
C966	XI62/net17	gnd!	2.62854e-20
C967	XI62/net12	gnd!	1.5482e-18
C968	XI62/net4	gnd!	3.06164e-18
C969	XI60/in0_b	gnd!	1.66136e-16
C970	XI60/in1_b	gnd!	2.77336e-16
C971	XI60/net3	gnd!	1.80157e-18
C972	XI60/net17	gnd!	1.16058e-18
C973	XI60/net12	gnd!	1.5482e-18
C974	XI60/net4	gnd!	1.85343e-18
C975	XI59/in0_b	gnd!	1.69922e-16
C976	XI59/in1_b	gnd!	2.75082e-16
C977	XI59/net3	gnd!	1.77518e-18
C978	XI59/net17	gnd!	9.92022e-19
C979	XI59/net12	gnd!	3.50472e-20
C980	XI59/net4	gnd!	4.59724e-19
C981	XI57/in0_b	gnd!	1.54511e-16
C982	XI57/in1_b	gnd!	2.82746e-16
C983	XI57/net3	gnd!	1.16115e-18
C984	XI57/net17	gnd!	1.16115e-18
C985	XI57/net12	gnd!	1.55752e-18
C986	XI57/net4	gnd!	2.00577e-18
C987	XI61/in0_b	gnd!	1.62072e-16
C988	XI61/in1_b	gnd!	2.92968e-16
C989	XI61/net3	gnd!	1.13777e-18
C990	XI61/net17	gnd!	1.36851e-18
C991	XI61/net12	gnd!	1.56721e-18
C992	XI61/net4	gnd!	2.03086e-18
C993	XI58/in0_b	gnd!	1.62005e-16
C994	XI58/in1_b	gnd!	2.89407e-16
C995	XI58/net3	gnd!	9.29427e-19
C996	XI58/net17	gnd!	6.66674e-19
C997	XI58/net12	gnd!	1.55752e-18
C998	XI58/net4	gnd!	3.13022e-18
C999	XI115/net7	gnd!	1.16115e-18
C1000	XI115/net5	gnd!	2.22077e-17
C1001	XI105/net7	gnd!	1.11897e-18
C1002	XI105/net5	gnd!	2.1486e-17
C1003	XI96/net7	gnd!	1.16115e-18
C1004	XI96/net5	gnd!	1.56316e-17
C1005	XI102/net7	gnd!	1.16115e-18
C1006	XI102/net5	gnd!	1.75466e-17
C1007	XI90/net7	gnd!	1.00237e-18
C1008	XI90/net5	gnd!	2.56045e-17
C1009	net26	gnd!	1.19776e-16
C1010	XI83/net7	gnd!	1.16115e-18
C1011	XI83/net5	gnd!	2.21902e-17
C1012	XI111/net7	gnd!	1.16115e-18
C1013	XI111/net5	gnd!	2.55778e-17
C1014	XI106/net4	gnd!	4.79388e-17
C1015	XI106/net2	gnd!	1.1478e-18
C1016	XI106/net1	gnd!	1.79806e-18
C1017	XI85/net4	gnd!	5.69297e-17
C1018	XI85/net2	gnd!	1.16058e-18
C1019	XI85/net1	gnd!	1.29431e-17
C1020	XI91/net4	gnd!	4.44396e-17
C1021	XI91/net2	gnd!	8.27064e-19
C1022	XI91/net1	gnd!	1.13105e-17
C1023	XI84/net4	gnd!	5.36984e-17
C1024	XI84/net2	gnd!	1.36611e-18
C1025	XI84/net1	gnd!	1.66638e-17
C1026	XI97/net4	gnd!	5.42477e-17
C1027	XI97/net2	gnd!	1.16814e-18
C1028	XI97/net1	gnd!	2.09232e-18
C1029	XI2/net5	gnd!	8.92528e-18
C1030	XI3/net5	gnd!	5.23521e-18
C1031	XI1/net5	gnd!	5.27178e-18
C1032	XI0/net5	gnd!	5.91912e-18
C1033	XI4/net5	gnd!	4.57142e-18
C1034	XI6/net2	gnd!	5.30788e-17
C1035	XI5/net2	gnd!	4.94167e-17
*
*
.ENDS ALU_8b
*
