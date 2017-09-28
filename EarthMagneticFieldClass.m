classdef EarthMagneticFieldClass
    properties
        earthMagneticField_ECEF = xyzVectorClass;        %Teslas
    end
    
    methods
        %   Uses bodyies current position to calculate the magnetic field
        %   strength in ECEF at that location using the IGRF model
        function earthMagneticFieldObject = EarthsMagneticFieldAtPosition(earthMagneticFieldObject, PositionObj, TimeObj)
            [phi, theta, r] = cart2sph(PositionObj.ECEF.x, PositionObj.ECEF.y, PositionObj.ECEF.z);
            Days_since_Jan_1st_2015 = daysact('1-Jan-2015 00:00:00', TimeObj.dateAndTime);
            [Br, Bt, Bp] = IGRF_Model(r, radtodeg(theta), radtodeg(phi), Days_since_Jan_1st_2015);
            [Bx, By, Bz] = sph2cart(Bp, Bt, Br);
            earthMagneticFieldObject.earthMagneticField_ECEF = [Bx, By, Bz];
        end
        
        function TimeStep = TimeStepCalc(OldSystemTimeObj, NewSystemTimeObj)
            TimeStep = NewSystemTimeObj.timeSinceLaunch - OldSystemTimeObj.timeSinceLaunch;
        end
        
        function obj = set.earthMagneticField_ECEF(obj, value)
            if (isvector(value))
                obj.earthMagneticField_ECEF.x = value(1);
                obj.earthMagneticField_ECEF.y = value(2);
                obj.earthMagneticField_ECEF.z = value(3);
            else
                error('Earth Magnetic Field ECEF Input must be a vector')
            end
        end
    end
end
