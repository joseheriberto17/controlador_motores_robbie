%% esto genera una nueva figura

function [zetta,Wn,Theta,K]=analizar_SOR(tiempo_1,salida_1,Delta_U)
    p = polyfit(tiempo_1,salida_1,8);
    
    Poly_x = linspace(0,tiempo_1(length(tiempo_1)),1e6);
    Poly_y = polyval(p,Poly_x);

    disp("valor maximo="+num2str(Poly_y(length(Poly_y))))
    disp("valor minimo="+num2str(0))

    y_15=Poly_y(length(Poly_y))*0.15;
    y_45=Poly_y(length(Poly_y))*0.45;
    y_75=Poly_y(length(Poly_y))*0.75;
    
    index_1=find((Poly_y>y_15),1);
    index_2=find((Poly_y>y_45),1);
    index_3=find((Poly_y>y_75),1);

    K=Poly_y(length(Poly_y))/Delta_U;

    disp("K = delta_Y/delta_U= " + num2str(K))
    disp("y en el 15% = " + num2str(y_15))
    disp("y en el 45% = " + num2str(y_45))
    disp("y en el 75% = " + num2str(y_75))  
    

    y15=Poly_y(index_1);
    t15=Poly_x(index_1);   
    
    y45=Poly_y(index_2);
    t45=Poly_x(index_2);

    y75=Poly_y(index_3);
    t75=Poly_x(index_3);

    disp("t1 = "+num2str(t15))
    disp("t2 = "+num2str(t45))
    disp("t3 = "+num2str(t75))
    
    %t15=t1
    %t45=t2
    %t75=t3
    x=(t45-t15)/(t75-t45);
    disp("x=(t2-t1)/(t3-t2) = "+num2str(x))
    
    

    zetta=(0.0805-5.547*(0.475-x)^2)/(x-0.356);
    disp("zetta=(0.0805-5.547*(0.475-x)^2)/(x-0.356) = "+num2str(zetta))

    if(zetta<0)
       disp("zetta es negativo")
       Wn=0;
       Theta=0;
    else
        if(zetta<1)
            F_2=2.6*zetta-0.6;
            disp("F_2=2.6*zetta-0.6 = "+num2str(F_2))
        else
            F_2=(0.708*(2.811)^zetta)-0.6;
            disp("F_2=(0.708*(2.811)^zetta)-0.6 = "+num2str(F_2))
        end
        Wn=F_2/(t45-t15);
        
        F_3=0.922*(1.66)^zetta;

        Theta=t45-(F_3/Wn);

        disp("Wn=F_2/(t2-t1) = "+num2str(Wn))
        disp("F_3=0.922*(1.66)^zetta = "+num2str(F_3))
        disp("Theta=t2-(F_3/Wn) = "+num2str(Theta))

        if(Theta<0)
            Theta=0;
            disp("Theta es negativo")
        end
    end

    
    
    
    plot(tiempo_1,salida_1,'-')
    hold on
    plot(Poly_x,Poly_y,'-')
    plot(t15,y15,'*')
    plot(t45,y45,'*')
    plot(t75,y75,'*')
    hold off
end


