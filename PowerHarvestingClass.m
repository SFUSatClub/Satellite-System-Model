classdef PowerHarvestingClass
    
    properties (Constant)
        solarPanelEfficency = 0.283;     %[]
        solarPanelSize = 900;            %[cm^2]
    end
    
    properties
        inEclipse; %boolean
        Wout;      %W (assumes one panel per each of the four sides)
    end
    
    methods
        %   Detects whether the orbiting body is in the shadow of the earth
        function PowerObj = ShadowDetection(PowerObj, SunPositionObj, SatPositionObj)
            EarthRadius = 6371200; %[m]
         
            sunToSatVector = SunPositionObj.ECI + SatPositionObj.ECI;
            sunToEarthEdgeAngle = atan(EarthRadius/SunPositionObj.distanceFromBodyToOrigin);
            sunToSatAngle = acos(norm(sunToSatVector)/SunPositionObj.distanceFromBodyToOrigin);
            
            if sunToSatAngle < sunToEarthEdgeAngle
                if norm(sunToSatVector) > SunPositionObj.distanceFromBodyToOrigin
                    PowerObj.inEclipse = 1;
                else
                    PowerObj.inEclipse = 0;
                end
            else
                PowerObj.inEclipse = 0;
            end
        end
        
        function PowerObj = CalculateInstantaneousPower(PowerObj, SunPositionObj, SatPositionObj, AttitudeDCM)
            
            if (PowerObj.inEclipse)
                PowerObj.Wout = 0.0;
                return;
            end
    
            % The body-centric face vectors of the faces with panels
            A = [0  1  0]';
            B = [0 -1  0]';
            C = [0  0  1]';
            D = [0  0 -1]';
            
            % Attitude-rotated face vectors in ECI
            Ag = AttitudeDCM*A; 
            Bg = AttitudeDCM*B;
            Cg = AttitudeDCM*C;
            Dg = AttitudeDCM*D;
            
            AM0 = 135.3; %[mW/cm^2] Standard value for solar radiation
            
            % We assume one identical panel on each of the four sides.
            RadiationVector = AM0*(SunPositionObj.ECI - SatPositionObj.ECI);
            
            Win_A = 1000*dot(Ag, RadiationVector)*solarPanelSize; % W
            Win_B = 1000*dot(Bg, RadiationVector)*solarPanelSize; % W
            Win_C = 1000*dot(Cg, RadiationVector)*solarPanelSize; % W
            Win_D = 1000*dot(Dg, RadiationVector)*solarPanelSize; % W
            
            PowerObj.Wout = solarPanelEfficieny*(Win_A + Win_B + Win_C + Win_D);
            
        end
    end 
end
