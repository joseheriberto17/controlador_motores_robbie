% clear all 
% clc
% close all
%%
function [K1,Tao1,Theta1] = modelo_motor(setpoint)
    figure Name 'muestra 1 metodo POR'
    muestra=table2array(readtable("muestras/datos_motor_100_ms_1khz_robot_F_piso_2.xlsx","Range",'A:D', ...
              'ReadVariableNames',false));
    % setpoint = 30;
    
    
    tiempo = muestra(:,4)*0.1;
    entrada = muestra(:,1);
    salida1 = muestra(:,2);
    salida2 = -muestra(:,3);
    
    subplot(2,2,1),
    
    plot(tiempo,entrada,tiempo,salida1,tiempo,salida2)
    title("muestra sin controlador");
    legend('vel ref','vel motor izq','vel motor der');
    
    [tiempo_1,entrada_1,salida_1]=tramo(setpoint,entrada,salida1,0.1);

    if (salida_1(1) > entrada_1(1))
        salida_1 = -1*(salida_1-salida_1(1));
    end
    
    subplot(2,2,2),plot(tiempo_1,salida_1,tiempo_1,entrada_1)
    title("fragmento de la muestra")
    
    
    %% metodo POR
    
    subplot(2,2,3),[Tao1,Theta1,K1]=analizar_POR(tiempo_1,salida_1-salida_1(1),setpoint,0);
    title("Metodo POR");
    
    G_P1=tf(K1,[Tao1 1],'inputDelay',Theta1);
    
    subplot(2,2,4),plot(tiempo_1,salida_1-salida_1(1),'-')
    hold on
    step(setpoint*G_P1,'-r'),xlim([0 tiempo_1(end)])
    hold off
    title("modelo propuesto")
    
    %% zetta del sor es negativo
    % figure()
    % 
    % subplot(1,2,1),[zetta2,Wn2,Theta2,K2]=analizar_SOR(tiempo_1,salida_1-salida_1(1),setpoint);
    % 
    % G_P2=tf(K2*power(Wn2,2),[1 2*zetta2*Wn2 power(Wn2,2)],'inputDelay',Theta2);
    % 
    % subplot(1,2,2),plot(tiempo_1,salida_1-salida_1(1),'-');
    % hold on
    % step(setpoint*G_P2,'-r')
    % hold off
    
    % save("modelo.mat","G_P1","K1","Tao1",'-append');

end

