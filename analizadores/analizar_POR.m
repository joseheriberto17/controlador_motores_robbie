function [Tao,Theta,K]=analizar_POR(tiempo_1,salida_1,Delta_U,retardo)
    
    p = polyfit(tiempo_1,salida_1,15);
    
    x1 = linspace(retardo,tiempo_1(length(tiempo_1)),1e6);
    y1 = polyval(p,x1);

    disp("valor maximo="+num2str(y1(length(y1))))
    disp("valor minimo="+num2str(0))
   

    y_283=y1(length(y1))*0.283;
    y_632=y1(length(y1))*0.632;
    
    index_1=find((y1>y_283),1);
    index_2=find((y1>y_632),1);

    K=y1(length(y1))/Delta_U;
    
    disp("K = delta_Y/delta_U= " + num2str(K))
    disp("y en el 28.3 = "+num2str(y_283))
    disp("y en el 63.2 = "+num2str(y_632))  


    y2=y1(index_1);
    t1=x1(index_1);
    

    
    y3=y1(index_2);
    t2=x1(index_2);

    disp("t1 = "+num2str(t1))
    disp("t2 = "+num2str(t2))

    Matriz=[1 1/3;1 1]\[t1;t2];

    Theta=Matriz(1);
    Tao=Matriz(2);

    if Theta<0
        Theta=0;
        disp("Theta en negativo")
    end
    
    disp("[t1;t2]=[1 1/3;1 1]*[theta;tao]")
    disp("[theta;tao]=[1 1/3;1 1]^(-1)*[t1;t2]")

    disp("theta = "+num2str(Theta))
    disp("tao = "+num2str(Tao))

    
    plot(tiempo_1,salida_1,'-')
    hold on
    plot(x1,y1,'-')
    plot(t1,y2,'*')
    plot(t2,y3,'*')
    hold off
end