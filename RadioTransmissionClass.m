classdef RadioTransmissionClass
%        This class is defined to encapsulate all variables related to
%        keplers orbital model. 
%        It also contains methods to calculate the orbital parameters like
%        true anomaly and mean anomaly that are used for position
%        determination
    
    properties
        %   CHIME Cartesian Coordinates assuming sphere
        %   CHIME Coordinates: 	49° 19? 15.6? N, 119° 37? 26.4? W
        %   49.321 (theta),-119.624 (phi) or 240.376
        %   CHIME_Theta = 49.321;   %[deg]
        %   CHIME_Phi = 240.376;    %[deg]
        %   CHIME_Row = 6371.2;     %[km] + 0.545 for non-spherical earth
        %   CHIMEECEFPosition = [-164886.009300717, 3731235.05547077, -5162347.51927725];
        positionOfCHIME_ECEF = xyzVectorClass;
        positionOfGroundStation_ECEF = xyzVectorClass;
        satelliteToCHIME_ECEF = xyzVectorClass;
    end
    
    methods
        function obj = set.positionOfCHIME_ECEF(obj, value)
            if (isvector(value))
                obj.positionOfCHIME_ECEF.x = value(1);
                obj.positionOfCHIME_ECEF.y = value(2);
                obj.positionOfCHIME_ECEF.z = value(3);
            else
                error('CHIMEs position Input must be a vector')
            end
        end
        
        function obj = set.positionOfGroundStation_ECEF(obj, value)
            if (isvector(value))
                obj.positionOfGroundStation_ECEF.x = value(1);
                obj.positionOfGroundStation_ECEF.y = value(2);
                obj.positionOfGroundStation_ECEF.z = value(3);
            else
                error('Ground Station Position Input must be a vector')
            end
        end
        
        function obj = set.satelliteToCHIME_ECEF(obj, value)
            if (isvector(value))
                obj.satelliteToCHIME_ECEF.x = value(1);
                obj.satelliteToCHIME_ECEF.y = value(2);
                obj.satelliteToCHIME_ECEF.z = value(3);
            else
                error('Sat to CHIMEs position Input must be a vector')
            end
        end
        
        function data = RadioTransmissionClass()
            data.positionOfCHIME_ECEF = [-164886.009300717, 3731235.05547077, -5162347.51927725];
        end
        
        function RadioTransmissionObj = SatelliteToChimeVector(RadioTransmissionObj, SatellitePositionObj)
            RadioTransmissionObj.satelliteToCHIME_ECEF = SatellitePositionObj.ECEF - RadioTransmissionObj.positionOfCHIME_ECEF;            
        end
        
        
    end
    
end

