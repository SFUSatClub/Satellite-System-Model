function [ R1 ] = R1DCM(angle)
    R1 = [1, 0, 0; 0, cos(angle), sin(angle); 0, -sin(angle), cos(angle)];
end