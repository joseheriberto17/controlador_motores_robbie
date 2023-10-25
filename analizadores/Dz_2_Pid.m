%% Dz = arreglo tiene la constantes 
% q0 q1 q2 para un PID
% q0 q1  para un PI

%% esta funcion no sirve para un "P"
function [Kp,Ti,Td]=Dz_2_Pid(q0,q1,q2,Ts)
    if q2 ~= 0
        
        Ac=[-q0  Ts/2  1/Ts;
            -q1  Ts/2 -2/Ts;
            -q2  0     1/Ts];% matriz de convercion q0 q1 q2 a ki Ti Td
        
        Bc=[-1;1;0];
        
        Xc=Ac\Bc;
        
        Kp=1/Xc(1);
        Ti=1/Xc(2);
        Td=Xc(3);

    else
        
        
        Ac=[-q0  Ts/2;
            q1  -Ts/2];% matriz de convercion q0 q1 a ki Ti
        
        Bc=[-1;-1];
        
        Xc=Ac\Bc;
        
        Kp=1/Xc(1);
        Ti=1/Xc(2);
        Td=0;
    end
end