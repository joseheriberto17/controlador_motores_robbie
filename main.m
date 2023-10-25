clc
clear
close all
%% 
[K1,Tao1,Theta1] = modelo_motor(30);
[K2,Tao2,Theta2] = modelo_motor(50);
[K3,Tao3,Theta3] = modelo_motor(80);
[K4,Tao4,Theta4] = modelo_motor(40);

G_P1 = tf(K1,[Tao1 1],"inputDelay",Theta1);
G_P2 = tf(K2,[Tao2 1],"inputDelay",Theta2);
G_P3 = tf(K3,[Tao3 1],"inputDelay",Theta3);
G_P4 = tf(K4,[Tao4 1],"inputDelay",Theta4);

figure()
hold on
step(G_P1)

step(G_P2)
step(G_P3)
step(G_P4)
legend("G_P1","G_P2","G_P3","G_P4")

save("modelo.mat","G_P1","K1","Tao1","Theta1","-append");
save("modelo.mat","G_P2","K2","Tao2","Theta2","-append");
save("modelo.mat","G_P3","K3","Tao3","Theta3","-append");
save("modelo.mat","G_P4","K4","Tao4","Theta4","-append");

hold off
