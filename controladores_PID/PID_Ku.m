%% este modelo solo entrega el controlador
function [Dz_Ku,Kp,Ti,Td]=PID_Ku(Tipo,G,Ts,KP)
    disp("Controlador por el metodo de ganacia limite "+Tipo+"---------------------------------------------------------")
    if G.InputDelay == 0
        disp("el modelo no tiene retardo")
        Dz_Ku=0;
        return
    end
    Td=0;

    [Gm,Pm,Wcg,Wcp] = margin(G);

    Ku=1/Gm;
    Tu = (2*pi)/(Wcg);
    
    switch upper(Tipo)
        case 'P'
            if KP==0
                Kp = 0.5*Ku;
            else
                Kp=KP;
            end

            Ti=0;
            Td=0;

            q0 = Kp;
            Dz = q0
        
        case 'PI'
            
            if KP==0
                Kp = 0.45*Ku;
            else
                Kp=KP;
            end
            Ti = 0.83*Tu;
            Td=0;

            q0 = Kp*(1 + Ts/(2*Ti));
            q1 = Kp*(Ts/(2*Ti) - 1);
            Dz = tf([q0 q1],[1 -1],Ts)

        case 'PID'  
            
            if KP==0
                Kp = 0.6*Ku;
            else
                Kp=KP;
            end
            Ti = 0.5*Tu;
            Td = 0.125*Tu;
            q0 = Kp*(1+ Ts/(2*Ti) + Td/Ts);
            q1 = Kp*(Ts/(2*Ti) - (2*Td)/Ts -1);
            q2 = Kp*(Td/Ts);
            Dz = tf([q0 q1 q2],[1 -1 0],Ts)
    end
    
    Dz_Ku = Dz;
    disp("ganacia limite= "+mat2str(round(Gm,5)))
    disp("frecuencia para los +-180°= "+mat2str(round(Wcg,5)))      
    disp("Kp = "+mat2str(Kp))
    disp("Ti = "+mat2str(Ti))
    disp("Td = "+mat2str(Td))
    disp("evaluacion de controlador = "+mat2str(dcgain(G)*Ku))
    disp(" ")
    disp(" ")
end