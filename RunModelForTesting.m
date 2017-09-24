%%  Initialization of system model for testing purposes
tic;
Launch_Date = datetime();       %[UTC]
RunTime = 80;                %[s]
TimeStep = 10;                 %[mesh size]
Sat_Starting_True_Anomaly = 0;  %[rad]
%%   Satellite Orbital Properties
Eccentricity = 0.0007373;       %[unitless]
Inclination = 0.9013;           %[rad]
Semimajor_Axis = 6775200;       %[m]
RAAN = 2.1078;                  %[rad]
Arg_of_Perigee = 5.495;         %[rad]
GMEarth = 3.986004418*10^14;    %[m^3 s^-2]
SatOrbitalParameters = OrbitalParametersClass(Eccentricity, Inclination, Semimajor_Axis, RAAN, Arg_of_Perigee, GMEarth);

%%   Structural Properties 
Inertia_Tensor = [0.0267, 0.03, 0.1; 0.03, 0.1333, 0.01; 0.03, 0.01, 0.1333]; %[kg*m2]
Magnetic_Moment = [0.5, 0.1, 0.1];
Hysteresis_Rod1 = [0.0001, 0.0002, 0.0003];
Hysteresis_Rod2 = [0.0004, 0.0005, 0.0006];
SatStructuralParameters = SatelliteStructuralClass(Magnetic_Moment, Hysteresis_Rod1, Hysteresis_Rod2, Inertia_Tensor);

%%  Satellite Attitude Properties
Attitude = [0, 0, 0];
Angular_Velocity = [0, 0, 0];
Angular_Momentum = [0, 0, 0];
SatAttitudeParameters = SatelliteAttitudeClass(Attitude, Angular_Velocity, Angular_Momentum);
%%  Power Properties

%%  Run System Model
Results = RunModel(Launch_Date, Sat_Starting_True_Anomaly, RunTime, TimeStep, SatOrbitalParameters, SatStructuralParameters, SatAttitudeParameters);
toc;