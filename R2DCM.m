function [ R2 ] = R2DCM(angle)
    R2 = [cos(angle), 0, -sin(angle); 0, 1, 0; sin(angle), 0, cos(angle)];
end
