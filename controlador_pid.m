clc
close all
clear 

warning off
%%

%%modelo de motor

load("modelo.mat","G_P2");

Ts = 0.1; %seg.
setPoint =50;

Gz_P1 = c2d(G_P2,Ts);

%% controladores

% ganacia limite
[Dz_Ku,Kp_ku,Ti_ku,Td_ku]=PID_Ku('PID',G_P2,Ts,0);

% curva reaccion
[Dz_Cr,Kp_cr,Ti_cr,Td_cr]=PID_CR('PI',G_P2,Ts,0);

% asignacion de polos

% altenativa de sacar el zetta por el OS
% zetta_AP_alt = 0.1;
% OS_AP_alt =(exp(-pi*zetta_AP_alt/sqrt(1-power(zetta_AP_alt,2))));

OS_AP = 0.15; % overshoot deseado
tss_AP = 0.7; % TransientTime al 2% deseado

zetta_AP = sqrt((log(OS_AP)/(power(log(OS_AP),2)-power(pi,2))));
Wn_AP = 4/(tss_AP*zetta_AP);

[Dz_AP,Kp_AP,Ti_AP,Td_AP]=PID_AP('PI',G_P2,Ts,tss_AP,zetta_AP);


%% plotter

figure()
step(setPoint*Gz_P1)
hold on
step(setPoint*feedback(Gz_P1*Dz_Ku,1))
hold on
step(setPoint*feedback(Gz_P1*Dz_Cr,1))
hold on
step(setPoint*feedback(Gz_P1*Dz_AP,1)) % el controlador diverge
hold off

legend('sin controlador','PID Ganacia limite','PI curva reaccion','PI Asignacion de polos');
grid on

%% analisis plotter

G_modelo = stepinfo(setPoint*Gz_P1);
G_control_Ku = stepinfo(setPoint*feedback(Gz_P1*Dz_Ku,1));
G_control_Cr = stepinfo(setPoint*feedback(Gz_P1*Dz_Cr,1));
G_control_AP = stepinfo(setPoint*feedback(Gz_P1*Dz_AP,1));

disp("datos de modelo sin controlador");
disp("overshoot: "+mat2str(G_modelo.Overshoot));
disp("TransientTime al 2%: "+mat2str(G_modelo.TransientTime)+" seg.");
disp("Value finish: "+mat2str(G_modelo.Peak));
disp(" ");
disp(" ");

disp("datos del controlador Ganancia limite (PID)");
disp("overshoot: "+mat2str(G_control_Ku.Overshoot));
disp("TransientTime al 2%: "+mat2str(G_control_Ku.TransientTime)+" seg.");
disp("Value finish: "+mat2str(G_control_Ku.Peak));
disp("Controlador propuesto Ganacia limite: Kp: " + mat2str(round(Kp_ku,4)) ...
                                       + ", Ti: " + mat2str(round(Ti_ku,4)) ...
                                       + ", Td: " + mat2str(round(Td_ku,4)));
disp("Controlador propuesto Ganacia limite: Dz: " + mat2str(round(cell2mat(Dz_Ku.Numerator),4)));

disp(" ");
disp(" ");

disp("datos del controlador de curva reaccion (PI) ");
disp("overshoot: "+mat2str(G_control_Cr.Overshoot));
disp("TransientTime al 2%: "+mat2str(G_control_Cr.TransientTime)+" seg.");
disp("Value finish: "+mat2str(G_control_Cr.Peak));
disp("Controlador propuesto Ganacia limite: Kp: " + mat2str(round(Kp_cr,4)) ...
                                       + ", Ti: " + mat2str(round(Ti_cr,4)) ...
                                       + ", Td: " + mat2str(round(Td_cr,4)));
disp("Controlador propuesto Ganacia limite: Dz: " + mat2str(round(cell2mat(Dz_Cr.Numerator),4)));


disp(" ");
disp(" ");

disp("datos del controlador Asignacion de polos (PI)");
disp("overshoot: "+mat2str(G_control_AP.Overshoot));
disp("TransientTime al 2%: "+mat2str(G_control_AP.TransientTime)+" seg.");
disp("Value finish: "+mat2str(G_control_AP.Peak));
disp("Controlador propuesto Ganacia limite: Kp: " + mat2str(round(Kp_AP,4)) ...
                                       + ", Ti: " + mat2str(round(Ti_AP,4)) ...
                                       + ", Td: " + mat2str(round(Td_AP,4)));
disp("Controlador propuesto Ganacia limite: Dz: " + mat2str(round(cell2mat(Dz_AP.Numerator),4)));

selet_control = 3;

switch (selet_control)
    case 1
        controller = "ganacia limite";
        controlador =round(cell2mat(Dz_Ku.Numerator),4);
        
    case 2
        controller = "curva reaccion";
        controlador =round(cell2mat(Dz_Cr.Numerator),4);
    case 3
        controller = "asignacion de polos";
        controlador =round(cell2mat(Dz_Cr.Numerator),4);
end
save("controllers.mat","controlador")