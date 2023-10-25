function [K_num,K_den,r_num,r_den] = factorizar(num,den)
% sacamos la raices pricipales y la constantes
r_num=poly(roots(num));
r_den=poly(roots(den));

% sacamos la constantes de cada polinomio
K_num= deconv(num,r_num);
K_den = deconv(den,r_den);
 
disp("K_num = "+string(vpa(K_num,4)))
disp("K_den = "+string(vpa(K_den,4)))
disp("las raices del polinomio es num = "+string(vpa(roots(num),4)))
disp("las raices del polinomio es den = "+string(vpa(roots(den),4)))
end

