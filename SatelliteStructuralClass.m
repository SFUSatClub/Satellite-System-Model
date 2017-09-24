classdef SatelliteStructuralClass
    properties
        satelliteMagneticField_Body = xyzVectorClass;        %Body Reference Frame
        satelliteHysteresisRod1_Body = xyzVectorClass;      
        satelliteHysteresisRod2_Body = xyzVectorClass;
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
        
        function obj = set.satelliteHysteresisRod1_Body(obj, value)
            if (isvector(value))
                obj.satelliteHysteresisRod1_Body.x = value(1);
                obj.satelliteHysteresisRod1_Body.y = value(2);
                obj.satelliteHysteresisRod1_Body.z = value(3);
            else
                error('Input must be a vector')
            end
        end
        
        function obj = set.satelliteHysteresisRod2_Body(obj, value)
            if (isvector(value))
                obj.satelliteHysteresisRod2_Body.x = value(1);
                obj.satelliteHysteresisRod2_Body.y = value(2);
                obj.satelliteHysteresisRod2_Body.z = value(3);
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
                data.satelliteHysteresisRod1_Body = HysteresisRod1;
                data.satelliteHysteresisRod2_Body = HysteresisRod2;
                data.inertiaMatrix_Body = InertiaMatrix;
            end
        end
    end   
end