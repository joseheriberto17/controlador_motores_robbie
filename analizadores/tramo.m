function [tiempo_x,entrada_x,salida_x]=tramo(paso,entrada,salida,t_muestreo)

    index=find(entrada==paso);
    tiempo_x=t_muestreo*(0:length(index)-1)';
    entrada_x=entrada(index);
    salida_x=salida(index);
end
