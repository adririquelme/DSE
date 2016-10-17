function [radio]=f_radio(beta)
% Función que calcula el radio del círculo en función del ángulo de
% buzamiento
radio = sin(beta)/(1+cos(beta));
end