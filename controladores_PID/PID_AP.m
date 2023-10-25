function [Dz_AP,Kp,Ti,Td]=PID_AP(Tipo,G,Ts,tss,zetta)
    syms z q0 q1 q2;

    switch upper(Tipo)
        case 'P'
            Dz = q0;
            
        case 'PI'
            Dz = (q0*z + q1)/(z-1);
            
        case 'PID'
            Dz = (q0*z^2 + q1*z + q2)/(z^2 - z);
            
    end
    
    G_z=c2d(G,Ts);
    theta =G_z.IODelay; 
    Wn=4/(tss*zetta); % tts al 2%

    %% parte actual
    
    % G_z se dividio en 2 polinomios de 2 partes del numerador y
    % denominador
    G_z_num=poly2sym(cell2mat(G_z.Numerator),z);
    G_z_den=poly2sym(horzcat(cell2mat(G_z.Denominator),zeros(1,theta)),z);
    
    [C_num,C_den]=numden(Dz);
    
    % producto de polinomio de control realimentado actual
    Pa=vpa(collect((G_z_den*C_den+G_z_num*C_num),z),4);
    
    D_Pd= length(coeffs(Pa,z))-3;
    if D_Pd > 1

        Dz_AP = 0;

        Kp = 0;
        Ti = 0;
        Td = 0;

        disp("se recomienda que tenga un tipo de controlador que solo genere una incognita")
        return;
    end


    syms a [1 D_Pd]

    %% parte deseada
    Mag=exp(-zetta*Wn*Ts);
    Re=Mag*cos(Wn*Ts*sqrt(1-zetta^2));
    im=Mag*sin(Wn*Ts*sqrt(1-zetta^2));
    
    p1=Re+im*1i;
    p2=Re-im*1i;    
    
    Pd=(z-p1)*(z-p2);
    Pd=Pd*(z+a);

    % polinomio deseado  a comparar
    Pd=vpa(collect(Pd,z),4);
    
    %% solucion al modelo AP
    %verificar si los signo de monomio mayor son iguales
    Qa=vpa(coeffs(Pa,z),4);
    Qd=vpa(coeffs(Pd,z),4);
    const=solve(Qd==Qa);

    switch upper(Tipo)
        case 'P'
            q0 = double(const.q0);
            q1 = 0;
            q2 = 0;   
    
            Kp=q0;
            Ti=q1;
            Td=q2;

            Dz_AP = q0;
    
            disp("no bien definido")



        case 'PI'
            q0 = double(const.q0);
            q1 = double(const.q1);
            q2 = 0;

            Dz_AP = tf([q0 q1],[1 -1],Ts);
    
            [Kp,Ti,Td]=Dz_2_Pid(q0,q1,q2,Ts);

        case 'PID'
            q0 = double(const.q0);
            q1 = double(const.q1);
            q2 = double(const.q2);

            Dz_AP = tf([q0 q1 q2],[1 -1 0],Ts);
    
            [Kp,Ti,Td]=Dz_2_Pid(q0,q1,q2,Ts);

    end    
end

