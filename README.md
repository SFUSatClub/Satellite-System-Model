# Satellite-System-Model
Object Oriented Program version of Satellite System Model

How to use:
RunModel.m is the main function that is called when you want to run the model. It requires passing of initial condition variables:

Launch_Date                     %[UTC in datetime format]
RunTime                         %[s]
TimeStep                        %[mesh size]
Sat_Starting_True_Anomaly       %[rad]

Satellite Orbital Properties (Passed in as an OrbitalParameterClass, example of initialization is shown below)
*Values shown are for ISS orbital parameters
Eccentricity = 0.0007373;       %[unitless]
Inclination = 0.9013;           %[rad]
Semimajor_Axis = 6775200;       %[m]
RAAN = 2.1078;                  %[rad]
Arg_of_Perigee = 5.495;         %[rad]
GMEarth = 3.986004418*10^14;    %[m^3 s^-2]
SatOrbitalParameters = OrbitalParametersClass(Eccentricity, Inclination, Semimajor_Axis, RAAN, Arg_of_Perigee, GMEarth);

The model is organized using the following classes.
For each timestep in the model a set of objects are created using these classes that define the system at that specific time frame

OrbitalParameterClass (Object is used to store the 6 classical orbital elements at some instant of time)
PositionClass (Orbiting Bodies position in ECEF and ECI at some time stamp)
SystemTimeClass (Specifies the time since launch and current UTC time)
EarthMagneticFieldClass (Magnetic Field of earth in ECEF reference frame axes with origin at the orbiting bodies CM)
SatelliteAttitudeClass (Specifies that satellites attitude in pitch, yaw, roll relative to ECI reference frame axes with origin at CM)
SatelliteStructuralClass (Inertia Tensor, and magnetic properties of the satellite under Body reference frame)
PowerHarvestingClass (current battery energy level since launch, power harvesting capabilities at that instant of time)

Key Methods
- OrbitPropagator 
    Requires a SystemTimeClass Object to specify the time at which you want to propagate the orbit too, and the previous timestep OrbitalParameterClass Object
- CalculatePosition
    Requires a SystemTimeClass Object to specify the time of the position calculation and OrbitalParameterClass Object for that time
    
    
