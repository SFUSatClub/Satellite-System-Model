classdef SatelliteStructuralClass
    properties
        satelliteMagneticField_Body = xyzVectorClass;        %Body Reference Frame
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
    end   
end