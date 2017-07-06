function [ DCM ] = OrbitalPlaneToECIDCM(inclination, RAAN, argOfPerigee)
    DCM = R3DCM(argOfPerigee)*R1DCM(inclination)*R3DCM(RAAN);
end