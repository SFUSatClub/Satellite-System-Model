classdef SatelliteStructuralClass
    properties
        satelliteMagneticField_Body = xyzVectorClass;        %Body Reference Frame
        satelliteHysteresisRod1 = HysteresisRodClass;      
        satelliteHysteresisRod2 = HysteresisRodClass;
        inertiaMatrix_Body = zeros(3,3);
    end
    
    methods
        function obj = set.satelliteMagneticField_Body(obj, value)
            if (isvector(value))
                obj.satelliteMagneticField_Body.x = value(1);
                obj.satelliteMagneticField_Body.y = value(2);
                obj.satelliteMagneticField_Body.z = value(3);
            else
                error('Input must be a vector')
            end
        end
        
        %   Constructor for constant properties
        function data = SatelliteStructuralClass(MagneticMoment, HysteresisRod1, HysteresisRod2, InertiaMatrix)
            if nargin == 0 %    if number of input args to function is 0 return an empty class
            else %  Populate class with the constant orbital parameters provided
                %   SatelliteStructure Class intialization
                data.satelliteMagneticField_Body = MagneticMoment;
                data.satelliteHysteresisRod1 = HysteresisRod1;
                data.satelliteHysteresisRod2 = HysteresisRod2;
                data.inertiaMatrix_Body = InertiaMatrix;
            end
        end
        
        function self = CalculateHysteresisEffects(previous, SystemTimeObj, SatelliteAttitudeObj, EarthMagneticField_ECEF) 
            
            self = previous;
            
            %   DCM for ECEF to ECI
            ECEF2ECI_DCM = transpose(dcmeci2ecef('IAU-2000/2006', datevec(SystemTimeObj.dateAndTime)));
            
            %   DCM for ECI to Body Ref Frame using current position of the
            %   satellite
            ECI2Body_DCM = R3DCM(SatelliteAttitudeObj.attitude.yaw) * R2DCM(SatelliteAttitudeObj.attitude.pitch) * R1DCM(SatelliteAttitudeObj.attitude.roll);
            
            %   Converting Earth Magnetic Field from ECEF to Body
            EarthMagneticField_Body = ECI2Body_DCM * (ECEF2ECI_DCM * EarthMagneticField_ECEF.earthMagneticField_ECEF);
            
            self.satelliteHysteresisRod1 = CalculateMagneticMoment(previous.satelliteHysteresisRod1, EarthMagneticField_Body);
            self.satelliteHysteresisRod2 = CalculateMagneticMoment(previous.satelliteHysteresisRod2, EarthMagneticField_Body);
        
        end
    end   
end