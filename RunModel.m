function [ systemData ] = RunModel( inputLaunchDate, inputSatTrueAnomaly, inputRunTime, inputTimeStep, inputSatOrbitalParameters, inputInertiaTensor, inputMagneticMoment )
%   Responsible for running the model using the initial conditions
%   specified when calling this function

    %%  Initialize Data Storage Class
    numberOfPreallocatedRows = round(inputRunTime/inputTimeStep); %Determine how much preallocation is necessary

    systemData((numberOfPreallocatedRows + 1), 1) = FrameworkClass; %Preallocate array
    for i = 1:(numberOfPreallocatedRows + 1)    %Assign Framework class to array and fill in timeSinceLaunch data
        systemData(i, 1) = FrameworkClass;
        systemData(i).systemTime.timeSinceLaunch = (i-1)*inputTimeStep;
    end

    %   Initialize data at launch time = 0 using input data from user
    systemData(1) = FrameworkClass(inputLaunchDate, inputSatTrueAnomaly, inputSatOrbitalParameters, inputInertiaTensor, inputMagneticMoment);

    %%  Iterative Model Operation
    for k = 2:size(systemData)
        %%  Time and Date Data
        systemData(k).systemTime = DetermineUTCDateAndTime(systemData(k).systemTime, systemData(k-1).systemTime);

        %%  Orbital Model Propagator
        %   Keplerian Orbital Propagtor
        systemData(k).satelliteOrbitalParameters = OrbitPropagator(systemData(k).satelliteOrbitalParameters, systemData(k-1).satelliteOrbitalParameters, systemData(k).systemTime);
        systemData(k).satellitePosition = CalculatePosition(systemData(k).satellitePosition, systemData(k).satelliteOrbitalParameters, systemData(k).systemTime);

        %%  IGRF Model (Earths Magnetic Field Model)
        systemData(k).earthMagneticField = EarthsMagneticFieldAtPosition(systemData(k).earthMagneticField, systemData(k).satellitePosition, systemData(k).systemTime);

        %%  Satellites Dynamic Model Propagator

        %%  Suns Orbital Keplerian Model for shadow detection
        systemData(k).sunOrbitalParameters = OrbitPropagator(systemData(k).sunOrbitalParameters, systemData(k-1).sunOrbitalParameters, systemData(k).systemTime);
        systemData(k).sunPosition = CalculatePosition(systemData(k).sunPosition, systemData(k).sunOrbitalParameters, systemData(k).systemTime);

        %%  Power Harvesting
        systemData(k).powerHarvesting = ShadowDetection(systemData(k).powerHarvesting, systemData(k).sunPosition, systemData(k).satellitePosition);

        %%  Radio Transmission
        %%  Power Management
    end
end

