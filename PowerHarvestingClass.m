classdef PowerHarvestingClass
    properties
        inShadow;               %boolean
        solarPanelEfficency;    %m
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
                    PowerObj.inShadow = 1;
                else
                    PowerObj.inShadow = 0;
                end
            else
                PowerObj.inShadow = 0;
            end
        end    
    end 
end
