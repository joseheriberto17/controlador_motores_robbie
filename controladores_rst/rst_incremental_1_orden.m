clc
close all
clear 

%% caracteristicas data
s=tf('s');

G=3/((s+3)*(s+15)); % entrada modelo

[Ts_Tao,Ts_Frec,Ts_Test]=rango_tiempo_muestreo(G);
Ts=round(mean(Ts_Test),1);

disp("se escogio un ts muestreo Ts="+ mat2str(Ts))
disp(" ")
disp(" ")


zetta=0.69;
tss=1;
Wn=4/(tss*zetta);

%% conversion

Bc=cell2mat(G.Numerator);
Ac=cell2mat(G.Denominator);

G_z=c2d(G,Ts);


Ad=cell2mat(G_z.Denominator);
Bd=cell2mat(G_z.Numerator); 


%% coeffs de tipo filtro

value=find(Bd,1,"first");
A_1=flip(Ad);
B_1=flip(Bd(value:end));

d=length(A_1)-length(B_1);


%% polo de segundo orden

p1=-2*exp(-zetta*Wn*Ts)*cos((Wn*Ts)*sqrt(1-zetta^2));
p2=exp(-2*zetta*Wn*Ts);

%% data

na=length(A_1)-1;
nb=length(B_1)-1;

ns=na;
nr=nb+d-1;


syms x 
syms R [1 nr+1] 
syms S [1 ns+1]

A1=poly2sym(conv(A_1,[-1 1]))*poly2sym(flip(R));
B1=poly2sym(B_1)*poly2sym([1 zeros(1,d)])*poly2sym(flip(S));

%% solve coeffs S and R

Q1=A1+B1;

Qd=coeffs(Q1,x);
Qi=[1 p1 p2 zeros(1,length(Qd)-3)];

const=solve(Qi==Qd);
r0=double(const.R1);
r1=double(const.R2);
s0=double(const.S1);
s1=double(const.S2);
s2=double(const.S3);
T=s0+s1+s2;

disp("r0 ="+mat2str(r0));
disp("r1 ="+mat2str(r1));
disp("s0 ="+mat2str(s0));
disp("s1 ="+mat2str(s1));
disp("s2 ="+mat2str(s2));
disp("T ="+mat2str(T));

R_tf=tf([1 0],[r0 r1],Ts)*tf([1 0],[1 -1],Ts);
R_tf.Variable='z^-1';

S_tf=tf([s0 s1 s2],[1 0 0],Ts);
S_tf.Variable='z^-1';

save('PID_data.mat','s0','s1','s2','-append')
