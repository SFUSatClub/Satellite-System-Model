function [ DCM ] = OrbitalElementsDCM(inclination, RAAN, argOfPerigee)
    DCM = R3DCM(argOfPerigee)*R1DCM(inclination)*R3DCM(RAAN);
end

function [ R1 ] = R1DCM(angle)
    R1 = [1, 0, 0; 0, cos(angle), sin(angle); 0, -sin(angle), cos(angle)];
end

function [ R2 ] = R2DCM(angle)
    R2 = [cos(angle), 0, -sin(angle); 0, 1, 0; sin(angle), 0, cos(angle)];
end

function [ R3 ] = R3DCM(angle)
    R3 = [cos(angle), sin(angle), 0; -sin(angle), cos(angle), 0; 0, 0, 1];
end