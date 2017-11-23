classdef PowerHarvestingClass
    
    properties (Constant)
        solarPanelEfficiency = 0.283;     %[]
        solarPanelSize = 900;            %[cm^2]
    end
    
    properties
        inEclipse; %boolean
        Wout;      %W (assumes one panel per each of the four sides)
    end
    
    methods
    
        function PowerObj = CalculateInstantaneousPower(OldPowerObj, SunPositionObj, SatPositionObj, SatAttitudeObj)
            
            PowerObj = OldPowerObj;
            
            %   Detects whether the orbiting body is in the shadow of the earth
            
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
            
            if (PowerObj.inEclipse)
                PowerObj.Wout = 0.0;
                return;
            end
    
            % The body-centric face vectors of the faces with panels
            A = [0  1  0]';
            B = [0 -1  0]';
            C = [0  0  1]';
            D = [0  0 -1]';
            
            ECI2Body_DCM = R3DCM(SatAttitudeObj.attitude.yaw) * R2DCM(SatAttitudeObj.attitude.pitch) * R1DCM(SatAttitudeObj.attitude.roll);
            Body2ECI_DCM = transpose(ECI2Body_DCM);
            
            % Attitude-rotated face vectors in ECI
            Ag = Body2ECI_DCM*A; 
            Bg = Body2ECI_DCM*B;
            Cg = Body2ECI_DCM*C;
            Dg = Body2ECI_DCM*D;
            
            AM0 = 135.3; %[mW/cm^2] Standard value for solar radiation
            
            % We assume one identical panel on each of the four sides.
            RadiationVector = AM0*(SunPositionObj.ECI - SatPositionObj.ECI)/norm(SunPositionObj.ECI - SatPositionObj.ECI);
            
            Win_A = max(0, dot(Ag, RadiationVector)*PowerObj.solarPanelSize/1000); % W
            Win_B = max(0, dot(Bg, RadiationVector)*PowerObj.solarPanelSize/1000); % W
            Win_C = max(0, dot(Cg, RadiationVector)*PowerObj.solarPanelSize/1000); % W
            Win_D = max(0, dot(Dg, RadiationVector)*PowerObj.solarPanelSize/1000); % W
            
            PowerObj.Wout = PowerObj.solarPanelEfficiency*(Win_A + Win_B + Win_C + Win_D);
            
        end
    end 
end
