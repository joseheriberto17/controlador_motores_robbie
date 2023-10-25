function [Dz_CR,Kp,Ti,Td]=PID_CR(Tipo,G,Ts,KP)
    disp("Controlador por el metodo de curva reaccion "+Tipo+"---------------------------------------------------------")

    den=cell2mat(G.Denominator);
    num=cell2mat(G.Numerator);

    if length(den)~=2
        disp("el modelo no es de primer orden")
        Dz_CR=0;
        
        return
    end
    Theta=G.InputDelay;    
    Tao=den(1,1);
    K=num(1,2);
    
    Gz=c2d(G,Ts);  
    
    nTheta = Theta + Ts/2;
    
    Td=0;

    disp("nueva Theta = "+mat2str(round(nTheta,5)))
    
    eval = nTheta/Tao;
    disp("valor de evaluacion ="+mat2str(round(eval,5)))

    if 0.1 > eval || eval > 1
    disp("eval es fuera de los rangos 0.1 < eval < 1")
    end

    switch upper(Tipo)
        case 'P'
            if KP==0
                Kp = Tao/(K*nTheta);
            else
                Kp=KP;
            end

            Ti = 0;
            Td = 0;

            q0 = Kp;
            Dz = q0
        
        case 'PI'            
            if KP==0
                Kp = (0.9*Tao)/(K*nTheta);
            else
                Kp=KP;
            end
            Ti = 3*nTheta;
            Td = 0;

            q0 = Kp*(1 + Ts/(2*Ti));
            q1 = Kp*(Ts/(2*Ti) - 1);
            Dz = tf([q0 q1],[1 -1],Ts)

        case 'PID'  
            
            if KP==0
                Kp = (1.2*Tao)/(K*nTheta); 
            else
                Kp=KP;
            end
            Ti = 2*nTheta;
            Td = 0.5*nTheta;
            q0 = Kp*(1+ Ts/(2*Ti) + Td/Ts);
            q1 = Kp*(Ts/(2*Ti) - (2*Td)/Ts -1);
            q2 = Kp*(Td/Ts);
            Dz = tf([q0 q1 q2],[1 -1 0],Ts)
    end
    
    Dz_CR = Dz;
    disp("Kp = "+mat2str(Kp))
    disp("Ti = "+mat2str(Ti))
    disp("Td = "+mat2str(Td))
    disp(" ")
    disp(" ")
    disp(" ")

    
end