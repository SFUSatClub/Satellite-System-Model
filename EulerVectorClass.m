classdef EulerVectorClass    
    properties
        pitch;
        yaw;
        roll;
    end
    
    methods
        %   Matrix multiplication of this class type
        function result = mtimes(obj2, obj1)
            result = obj2 * [obj1.pitch; obj1.yaw; obj1.roll];
        end
        
        %   Addition between two xyzVectorClasses
        function result = plus(obj1, obj2)
            result = [obj1.pitch, obj1.yaw, obj1.roll] + [obj2.pitch, obj2.yaw, obj2.roll];
        end
        
        function result = minus(obj1, obj2)
            result = [obj1.pitch, obj1.yaw, obj1.roll] - [obj2.pitch, obj2.yaw, obj2.roll];
        end
    end
    
end