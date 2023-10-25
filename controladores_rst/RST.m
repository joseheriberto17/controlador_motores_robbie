clc
clear
close all


% G=tf(0.6354,[0.2429 1]);
% 
% [Ts_Tao,Ts_Frec,Ts_Test]=rango_tiempo_muestreo(G);
% 
% Ts=0.05;
% 
% G_z=c2d(G,Ts);
% 
% polo=exp(Ts/0.2429)
% 
% S = stepinfo(G,"SettlingTimeThreshold",0.02);
% ts=(S.Transien tTime);

%% -------------------------------
zetta =0.6;
Tss=1;
Ts=0.1;
Wn=4/(zetta*Tss)

G=tf(1,[0.1 1.1 1]);

G_z=c2d(G,Ts)

p1=-2*exp(-zetta*Wn*Ts)*cos(Wn*Ts*sqrt(1-zetta^2))
p2=exp(-2*zetta*Wn*Ts)

A=[      1      0      0      0;
    -1.273      1 0.0355      0;
    0.3329 -1.273 0.2465 0.0355;
         0 0.3324      0 0.2465];
B=[1;-1.1544;0.4493;0];

X=A\B;