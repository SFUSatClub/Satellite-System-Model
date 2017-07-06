classdef PositionClass
    properties
        distanceFromBodyToOrigin;                 %m  
        ECI = xyzVectorClass;        %m in IAU2000/2006
        ECEF = xyzVectorClass;%m
    end
    
    methods
        
        %   set functions that set the xyz components if in vector form to
        %   the xyzVectorClass format
        function obj = set.ECI(obj, value)
            if (isvector(value))
                obj.ECI.x = value(1);
                obj.ECI.y = value(2);
                obj.ECI.z = value(3);
            else
                error('ECI Input must be a vector')
            end
        end
        
        function obj = set.ECEF(obj, value)
            if (isvector(value))
                obj.ECEF.x = value(1);
                obj.ECEF.y = value(2);
                obj.ECEF.z = value(3);
            else
                error('ECEF Input must be a vector')
            end
        end
        
        %   Calculates the position in ECI and ECEF of the orbiting body
        %   using kepler orbital properties 
        %   ****Maybe split ECI and ECEF into seperate functions****
        function PositionObj = CalculatePosition(PositionObj, OrbitalParametersObj, SystemTimeObj)
            PositionObj.distanceFromBodyToOrigin = OrbitalParametersObj.semimajorAxis .* (1 - OrbitalParametersObj.eccentricity.^2) ./ (1 + OrbitalParametersObj.eccentricity.*cos(OrbitalParametersObj.trueAnomaly));  
            cartCoordinatesOnOrbitalPlane = [PositionObj.distanceFromBodyToOrigin .* cos(OrbitalParametersObj.trueAnomaly), ...
                                             PositionObj.distanceFromBodyToOrigin .* sin(OrbitalParametersObj.trueAnomaly), ...
                                             0];
            rotationMatrix = OrbitalPlaneToECIDCM(OrbitalParametersObj.inclination, OrbitalParametersObj.RAAN, OrbitalParametersObj.argOfPerigee);
            PositionObj.ECI = cartCoordinatesOnOrbitalPlane * rotationMatrix;  %WTF why does this work backwards look into this (maybe) agrees with other models
            ECI2ECEF_Matrix = dcmeci2ecef('IAU-2000/2006', datevec(SystemTimeObj.dateAndTime));
            PositionObj.ECEF = ECI2ECEF_Matrix * PositionObj.ECI; 
        end
    end   
end


