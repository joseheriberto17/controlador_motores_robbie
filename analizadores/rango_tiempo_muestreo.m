function [Ts_Tao,Ts_Frec,Ts_Test]=rango_tiempo_muestreo(G)
    disp("rango para tiempo muestreo -----------------------------------------------")
    
    Gsr=tf(cell2mat(G.Numerator),cell2mat(G.Denominator));

    Gcsr=feedback(Gsr,1); %realimentamos de sistema para hallar los ts     
    Gc=feedback(G,1);

    polos=pole(Gcsr);
    
    
    tao=abs(1/real(max(polos)))+G.inputDelay; %hallo los polos maximo y lo invierto para el Tao
    
    Wc=bandwidth(Gcsr); %este metodo encuentra la 1st frecuencia donde la ganancia disminuye por debajo del 70,79% (-3 dB) de su valor
    
    S = stepinfo(Gc,"SettlingTimeThreshold",0.05);
    ts=(S.TransientTime); % este me permite encontrar el tiempo de establecimiento con un umblar de 5%
    
    Ts_Tao=tao*[0.2 0.6]; %rango por el metodo de tao equivalente
    Ts_Frec=(2*pi/Wc)*[1/12 1/8];%rango por el metodo de ancho de banda
    Ts_Test=ts*[0.05 0.15];%rango por el tiempo de establecimiento

    disp("polos de mi sistema = "+num2str(polos))
    disp("tao=1/(max(abs(polos))) = ["+num2str(tao)+"]")
    disp("rango Ts_Tao=tao*[0.2 0.6] = ["+num2str(Ts_Tao)+"]")
    disp(" ")
    disp("Wc obtenido por bode = "+num2str(Wc))
    disp("rango Ts_Frec=(2*pi/Wc)*[1/12 1/8] = ["+num2str(Ts_Frec)+"]")
    disp(" ")
    disp("tiempo de est. al 5%  = "+num2str(ts))
    disp("Ts_Test=ts*[0.05 0.15] = ["+num2str(Ts_Test)+"]")
    disp(" ")
    disp("rango del Tao eq. es desde:     "+num2str(Ts_Tao(1))+" a "+num2str(Ts_Tao(2)))
    disp("rango del Frecuencia es desde:  "+num2str(Ts_Frec(1))+" a "+num2str(Ts_Frec(2)))
    disp("rango del Tiempo est. es desde: "+num2str(Ts_Test(1))+" a "+num2str(Ts_Test(2)))
    disp(" ")
    disp("Tao equiva. = "+num2str(tao))
    disp("Frecuencia  = "+num2str(2*pi/Wc))
    disp("Tiempo est. = "+num2str(ts))
    disp(" ")
    disp(" ")
    disp(" ")
end