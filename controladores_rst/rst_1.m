 clc
close all
clear 

%% caracteristicas entradas
s=tf('s');

Tao=10;
G=tf(1,[Tao 1]);% entrada modelo

Ts=1;
%{
[Ts_Tao,Ts_Frec,Ts_Test]=rango_tiempo_muestreo(G);
Ts=round(mean(Ts_Test),1);

disp("se escogio un ts muestreo Ts="+ mat2str(Ts))
disp(" ")
disp(" ")
%}
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

p1=exp(-1/Tao);

disp("p1 ="+mat2str(p1));


%% data

na=length(A_1)-1;
nb=length(B_1)-1;

ns=na-1;
nr=nb+d-1;


syms x 
syms R [1 nr+1] 
syms S [1 ns+1]

A1=poly2sym(A_1)*poly2sym(flip(R));
B1=poly2sym(B_1)*poly2sym([1 zeros(1,d)])*poly2sym(flip(S));

%% solve coeffs S and R

Q1=A1+B1;

Qd=coeffs(Q1,x);
vpa(Qd,4);
Qi=[1 -p1 zeros(1,length(Qd)-3)];

const=solve(Qi==Qd);
r0=double(const.R1);
s0=double(const.S1);


T=sum(Qi)/sum(B_1);

disp("r0 ="+mat2str(r0));

disp("s0 ="+mat2str(s0));


R_tf=tf(1,r0,Ts);
R_tf.Variable='z^-1';

S_tf=tf(s0,1,Ts);
S_tf.Variable='z^-1';

