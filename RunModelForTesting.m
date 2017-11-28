%%  Initialization of system model for testing purposes
tic;
Launch_Date = datetime();       %[UTC]
RunTime = 8000;                %[s]
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
Inertia_Tensor = [0.0206500000000000,1.72070000000000e-05,0.000144180000000000;1.72070000000000e-05,0.0205700000000000,-0.000253040000000000;0.000144180000000000,-0.000253040000000000,0.00315310000000000]; %[kg*m2]
Magnetic_Moment = [0.3, 0, 0]; %[A*m^2]

Hysteresis_Rod1_Axis = [0 1 0];
Hysteresis_Rod2_Axis = [0 0 1];
Hysteresis_Rod_Length = 0.2983; %[cm]
Hysteresis_Rod_Diameter = 0.194; %[cm]
Hysteresis_Rod_Remanance = 0.96; %[Tesla]
Hysteresis_Rod_Saturation = 0.35; %[Tesla]
Hysteresis_Rod_Coercivity = 0.74; %[A/m]

Hysteresis_Rod1 = HysteresisRodClass(Hysteresis_Rod1_Axis, Hysteresis_Rod_Length, Hysteresis_Rod_Diameter, Hysteresis_Rod_Coercivity, Hysteresis_Rod_Remanance, Hysteresis_Rod_Saturation);
Hysteresis_Rod2 = HysteresisRodClass(Hysteresis_Rod2_Axis, Hysteresis_Rod_Length, Hysteresis_Rod_Diameter, Hysteresis_Rod_Coercivity, Hysteresis_Rod_Remanance, Hysteresis_Rod_Saturation);
SatStructuralParameters = SatelliteStructuralClass(Magnetic_Moment, Hysteresis_Rod1, Hysteresis_Rod2, Inertia_Tensor);

%%  Satellite Attitude Properties
Attitude = [0, 0, 0];
Angular_Velocity = [0, 0, 0];
Angular_Momentum = Inertia_Tensor*Angular_Velocity';
SatAttitudeParameters = SatelliteAttitudeClass(Attitude, Angular_Velocity, Angular_Momentum);
%%  Power Properties

%%  Run System Model
Results = RunModel(Launch_Date, Sat_Starting_True_Anomaly, RunTime, TimeStep, SatOrbitalParameters, SatStructuralParameters, SatAttitudeParameters);
toc;

fileID = fopen('stk_results.e','w');
fprintf(fileID, 'stk.v.11.0');
fprintf(fileID, 'BEGIN Ephemeris');EphemerisTimePos
fprintf(fileID, 'ScenarioEpoch %s.0', strrep(Launch_Date, '-', ' '));
fprintf(fileID, 'CentralBody Earth');
fprintf(fileID, 'CoordinateSystem Inertial');
fprintf(fileID, 'CoordinateSystemEpoch 1 Jan 2000 12:00:00.0');
fprintf(fileID, 'NumberofEphemerisPoints %d', size(Results));
fprintf(fileID, 'TimeFormat JDate');
positions = [Results.satellitePosition.ECI];
times = [Results.systemTime];
fprintf(fileID,'%s %f.6 %f.6 %f.6\n',[strrep(times.dateAndTime, '-', ' '),positions.x,positions.y,positions.z]);
fprintf(fileID, 'END Ephemeris');
fclose(fileID);

fileID = fopen('stk_results.a','w');
fprintf(fileID, 'stk.v.11.0');
fprintf(fileID, 'BEGIN Attitude');
fprintf(fileID, 'ScenarioEpoch %s.0', strrep(Launch_Date, '-', ' '));
fprintf(fileID, 'CentralBody Earth');
fprintf(fileID, 'CoordinateSystem Inertial');
fprintf(fileID, 'CoordinateSystemEpoch 1 Jan 2000 12:00:00.0');
fprintf(fileID, 'NumberofEphemerisPoints %d', size(Results));
fprintf(fileID, 'TimeFormat JDate');
attitudes = [Results.satelliteAttitude];
attitude = attitudes.attitude;
fprint(fileID,'%s %f.6 %f.6 %f.6',[strrep(times.dateAndTime, '-', ' '), attitude.pitch, attitude.yaw, attitude.roll]);
fprintf(fileID, 'END Attitude');
fclose(fileID);
