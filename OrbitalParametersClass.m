classdef OrbitalParametersClass
%        This class is defined to encapsulate all variables related to
%        keplers orbital model. 
%        It also contains methods to calculate the orbital parameters like
%        true anomaly and mean anomaly that are used for position
%        determination

    properties                  %Constants
        eccentricity;           %[unitless]
        inclination;            %[rad]
        semimajorAxis;          %[m]
        RAAN;                   %[rad]
        argOfPerigee;           %[rad]
        gravitationalParameter; %[m^3 s^-2]
    end
    properties
        trueAnomaly;            %[rad]
        meanAnomaly;            %[rad]
        epoch;                  %[datetime()]
    end
    
    methods
        %   Constructor for constant properties
        function data = OrbitalParametersClass(Eccentricity, Inclination, Semimajor_Axis, RAAN, Arg_of_Perigee, GM)
            if nargin == 0 %    if number of input args to function is 0 return an empty class
            else %  Populate class with the constant orbital parameters provided
                %   OrbitalParameters Class intialization
                data.eccentricity = Eccentricity;
                data.inclination = Inclination;
                data.semimajorAxis = Semimajor_Axis;
                data.RAAN = RAAN;
                data.argOfPerigee = Arg_of_Perigee;               
                data.gravitationalParameter = GM;
            end
        end
        
        %   Determine Mean Anomaly based off of objects Epoch and current
        %   date and time
        function meanAnomaly = MeanAnomalyFromTime(OrbitalObj, TimeObj)
            timeSinceEpoch = seconds(TimeObj.dateAndTime - OrbitalObj.epoch);
            orbitalPeriod = sqrt((4*(pi^2)*OrbitalObj.semimajorAxis^3)/(OrbitalObj.gravitationalParameter));
            meanAnomaly = mod(2*pi*(timeSinceEpoch/orbitalPeriod), 2*pi);
        end
        
        %   Calculate Epoch from mean anomaly and orbital parameters
        function epoch = EpochFromMeanAnomaly(OrbitalObj, TimeObj)
            timeSinceEpoch = (OrbitalObj.meanAnomaly/(2*pi))*sqrt((4*(pi^2)*OrbitalObj.semimajorAxis^3)/(OrbitalObj.gravitationalParameter)); % (M/2pi)*OrbitalPeriod
            epoch = TimeObj.dateAndTime - seconds(timeSinceEpoch);
        end
        
        %   Calculate mean anomaly from true anomaly and orbital parameters
        function meanAnomaly = MeanAnomalyFromTrueAnomaly(OrbitalObj)
            meanAnomaly = OrbitalObj.trueAnomaly - 2.*OrbitalObj.eccentricity.*sin(OrbitalObj.trueAnomaly);
        end
        
        %   Calculate true anomaly from mean anomaly and orbital parameters
        function trueAnomaly = TrueAnomalyFromMeanAnomaly(OrbitalObj)
            Num_of_Terms_in_infinite_Series = 10;
            eccentricAnomaly = OrbitalObj.meanAnomaly;
            for n = 1:Num_of_Terms_in_infinite_Series
                eccentricAnomaly = eccentricAnomaly + (2/n) * besselj(n,n*OrbitalObj.eccentricity).*sin(n*OrbitalObj.meanAnomaly);
            end
            trueAnomaly = 2 .* atan(sqrt((1 + OrbitalObj.eccentricity)/(1 - OrbitalObj.eccentricity)) .* tan(eccentricAnomaly/2));
        end   
        
        %   Propagates orbit forward using the orbital parameters and the
        %   current time as variables to calculate the new position
        function NewOrbitalParametersObj = OrbitPropagator(NewOrbitalParametersObj, OldOrbitalParametersObj, NewSystemTimeObj)
            NewOrbitalParametersObj = OldOrbitalParametersObj;
            NewOrbitalParametersObj.meanAnomaly = MeanAnomalyFromTime(NewOrbitalParametersObj, NewSystemTimeObj);
            NewOrbitalParametersObj.trueAnomaly = TrueAnomalyFromMeanAnomaly(NewOrbitalParametersObj);
        end
    end
end