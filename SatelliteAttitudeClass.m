classdef SatelliteAttitudeClass
    properties
        attitude = EulerVectorClass;        %Pitch, yaw, roll
        angularVelocity = EulerVectorClass;
        angularMomentum = EulerVectorClass;
    end
    
    methods
        
        %   Old is for previous timestep, new is for current timestep
        %   attitude is being calculated for
        function NewAttitudeObj = CalculateAttitude(OldSystemTimeObj, NewSystemTimeObj, OldEarthMagneticField_ECEF, SatelliteStructureObj, OldAttitudeObj)
            
            %   Timestep of system
            TimeStep = NewSystemTimeObj.timeSinceLaunch - OldSystemTimeObj.timeSinceLaunch;
            
            %   DCM for ECEF to ECI
            ECEF2ECI_DCM = transpose(dcmeci2ecef('IAU-2000/2006', datevec(OldSystemTimeObj.dateAndTime)));
            
            %   DCM for ECI to Body Ref Frame using current position of the
            %   satellite
            ECI2Body_DCM = R3DCM(OldAttitudeObj.attitude.yaw) * R2DCM(OldAttitudeObj.attitude.pitch) * R1DCM(OldAttitudeObj.attitude.roll);
            
            %   Converting Earth Magnetic Field from ECEF to Body
            EarthMagneticField_Body = ECI2Body_DCM * (ECEF2ECI_DCM * OldEarthMagneticField_ECEF);
            
            %   Calculating Mu vector of satellite in Body
            SatelliteMu_Body = SatelliteStructureObj.satelliteMagneticField_Body + SatelliteStructureObj.satelliteHysteresisRod1_Body ...
                               + SatelliteStructureObj.satelliteHysteresisRod2_Body;
                           
            %   Torque acting on satellite in Body frame from Magnetic Force               
            MagneticTorque_Body = cross(SatelliteMu_Body, EarthMagneticField_Body);
            
            %   AngularVelocity derivative
            AngularVelocity_Body_dot = transpose(SatelliteStructureObj.inertiaMatrix_Body)*(-MagneticTorque_Body ...
                                  - cross(OldAttitudeObj.angularVelocity - OldAttitudeObj.angularMomentum));
                              
            %   Finding new angular velocity by multiplying Time step by
            %   derivative and added to previous timestep values
            NewAttitudeObj.angularVelocity = OldAttitudeObj.angularVelocity + TimeStep*AngularVelocity_Body_dot;
            
            %   Finding derivative of angular position
            Theta_Body_dot = [0, OldAttitudeObj.attitude.yaw, -OldAttitudeObj.attitude.pitch
                              -OldAttitudeObj.attitude.yaw, 0, OldAttitudeObj.attitude.roll
                              OldAttitudeObj.attitude.pitch, -OldAttitudeObj.attitude.roll, 0] * OldAttitudeObj.attitude;
                    
            %   New angular position in Body calculated from angular
            %   position derivative * timestep added to previous timestep
            %   position
            NewAttitudeObj.attitude = OldAttitudeObj.attitude + TimeStep*Theta_Body_dot;
        end
        
        function obj = set.attitude(obj, value)
            if (isvector(value))
                obj.attitude.pitch = value(1);
                obj.attitude.yaw = value(2);
                obj.attitude.roll = value(3);
            else
                error('Input must be a vector')
            end
        end
        
        function obj = set.angularVelocity(obj, value)
            if (isvector(value))
                obj.angularVelocity.pitch = value(1);
                obj.angularVelocity.yaw = value(2);
                obj.angularVelocity.roll = value(3);
            else
                error('Input must be a vector')
            end
        end
        
        function obj = set.angularMomentum(obj, value)
            if (isvector(value))
                obj.angularMomentum.pitch = value(1);
                obj.angularMomentum.yaw = value(2);
                obj.angularMomentum.roll = value(3);
            else
                error('Input must be a vector')
            end
        end
        
        %   Constructor for intial conditions
        function data = SatelliteAttitudeClass(Attitude, AngularVelocity, AngularMomentum)
            if nargin == 0 %    if number of input args to function is 0 return an empty class
            else %  Populate class with the constant orbital parameters provided
                %   SatelliteAttitudeClass intialization
                data.attitude = Attitude;
                data.angularVelocity = AngularVelocity;
                data.angularMomentum = AngularMomentum;
            end
        end
    end   
end