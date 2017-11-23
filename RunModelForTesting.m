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

times = [Results.systemTime];
ts = [times.timeSinceLaunch];
satAts = [Results.satelliteAttitude];
atts = [satAts.attitude];
pow = [Results.powerHarvesting];
plot([times.timeSinceLaunch], [atts.pitch]);
hold on
plot([times.timeSinceLaunch], [atts.yaw]);
hold on
plot([times.timeSinceLaunch], [atts.roll]);
hold on
plot([times.timeSinceLaunch], [pow.Wout]);
hold on
legend('Pitch','Yaw','Roll', 'Wout');

Wh = 0;
for W = [pow.Wout]
    Wh = Wh + W*(0.00278);
end
Wh