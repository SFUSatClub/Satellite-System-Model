classdef FrameworkClass %   Metaclass
%   This class is defined to provide the framework for all the necessary
%   classes that describe the systems properties

    properties
        systemTime = SystemTimeClass;
        satelliteOrbitalParameters = OrbitalParametersClass;
        satellitePosition = PositionClass;
        earthMagneticField = EarthMagneticFieldClass;
        satelliteAttitude = SatelliteAttitudeClass;
        satelliteStructural = SatelliteStructuralClass;
        sunOrbitalParameters = OrbitalParametersClass;
        sunPosition = PositionClass;
        powerHarvesting = PowerHarvestingClass;
        radioTransmission = RadioTransmissionClass();
    end
    
    methods
        %   Initalize data object from User input data
        %   ****Needs to be rewritten****
        function data = FrameworkClass(launchDate, satTrueAnomaly, satOrbitalParameters, satelliteStructure, satDynamics)
            if nargin > 0
                
                %%   SystemTime Class intialization
                data.systemTime = SystemTimeClass(launchDate, 0);
                
                %%   Satellite OrbitalParameters Class intialization
                data.satelliteOrbitalParameters = satOrbitalParameters;
                data.satelliteOrbitalParameters.trueAnomaly = satTrueAnomaly; 
                data.satelliteOrbitalParameters.meanAnomaly = MeanAnomalyFromTrueAnomaly(data.satelliteOrbitalParameters);
                data.satelliteOrbitalParameters.epoch = EpochFromMeanAnomaly(data.satelliteOrbitalParameters, data.systemTime);
                
                %%   SatelliteStructural Class intialization
                data.satelliteStructural = satelliteStructure;
                            
                %%   Sun Orbital Properties Constants
                % Satellite: SUN
                % Catalog: 0
                % Epoch Time: 15001.00000000000 (year 2015, day 1.00000) 
                % Inclination: 23.4406 deg (Earth's axis tilted 23 deg from ecliptic)
                % RA of Node: 0.0000 deg (definition of Right Ascension) 
                % Eccentricity: 0.0167133 
                % Arg of Perigee: 282.7685 deg (perihelion in early January)
                % Mean Anomaly: 357.6205 deg (The Earth is quite close to perihelion on Jan 1) 
                % Mean Motion: 0.002737778522 Rev/day (one revolution per year) 
                % Decay rate: 0.00000 Rev/day^2 
                % Epoch rev: 2017 (orbit number equals the year) 
                % Semimajor Axis: 149597870 km

                Sun_Inclination = 23.4406*pi/180;
                Sun_RAAN = 0;
                Sun_Eccentricity = 0.0167133;
                Sun_Arg_of_Perigee = (282.7685*pi/180);
                Sun_Semimajor_Axis = 149597870*1000;
                Sun_GM = 1.32712440018*10^20;             %[m^3 s^-2]  
                Sun_Epoch = datetime(2015, 1, 1, 0, 0, 0);
                
                %%   Sun OrbitalParameters Class intialization
                data.sunOrbitalParameters = OrbitalParametersClass(Sun_Eccentricity, Sun_Inclination, Sun_Semimajor_Axis, Sun_RAAN, Sun_Arg_of_Perigee, Sun_GM);
                data.sunOrbitalParameters.epoch = Sun_Epoch;
                data.sunOrbitalParameters.meanAnomaly = MeanAnomalyFromTime(data.sunOrbitalParameters, data.systemTime);
                data.sunOrbitalParameters.trueAnomaly = TrueAnomalyFromMeanAnomaly(data.sunOrbitalParameters);
                
                %%   Radio Transmission
               
                %%  SatelliteAttitude Class intialization
                data.satelliteAttitude = satDynamics;
                     
            end
        end
    
    end
end

