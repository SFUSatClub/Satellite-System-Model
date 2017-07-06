classdef xyzVectorClass    
    properties
        x;
        y;
        z;
    end
    
    methods
        %   Matrix multiplication of this class type
        function result = mtimes(obj2, obj1)
            result = obj2 * [obj1.x; obj1.y; obj1.z];
        end
        
        %   Addition between two xyzVectorClasses
        function result = plus(obj1, obj2)
            result = [obj1.x, obj1.y, obj1.z] + [obj2.x, obj2.y, obj2.z];
        end
    end
    
end

