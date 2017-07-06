classdef SystemTimeClass
%   Class that stores the variables associated with the current time and
%   date in a datetime format and time in seconds since launch of
%   satellite/beginning of model

    properties 
        dateAndTime = datetime();        
        timeSinceLaunch = [];     %seconds
    end
    
    methods
        
        %   Class Constructor
        function data = SystemTimeClass(dateAndTime, timeSinceLaunch)
            if nargin == 0
            else
                %   OrbitalParameters Class intialization
                data.dateAndTime = dateAndTime;
                data.timeSinceLaunch = timeSinceLaunch;
            end
        end
        
        %   Set dateAndTime data field
        function obj = set.dateAndTime(obj, value)
            if (isdatetime(value))
                obj.dateAndTime = value;
            else
                error('Launch Date must be in type datetime')
            end
        end
        
        %   Set timeSinceLaunch data field
        function obj = set.timeSinceLaunch(obj, value)
            if (isa(value, 'double'))
                obj.timeSinceLaunch = value;
            else
                error('Time Since Launch must be type double')
            end
        end
        
        %   Set new Datetime type based off of timestep between two objects
        function newObj = DetermineUTCDateAndTime(newObj, oldObj)
            newObj.dateAndTime = oldObj.dateAndTime + seconds(newObj.timeSinceLaunch - oldObj.timeSinceLaunch);
        end
    end
    
end
