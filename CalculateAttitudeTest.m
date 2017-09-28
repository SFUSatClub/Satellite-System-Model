function NewAttitudeObj = CalculateAttitudeTest(OldSystemTimeObj, NewSystemTimeObj, OldEarthMagneticField_ECEF, SatelliteStructureObj, OldAttitudeObj)
            
            %   Timestep of system
            TimeStep = NewSystemTimeObj.timeSinceLaunch - OldSystemTimeObj.timeSinceLaunch;
            
            %   DCM for ECEF to ECI
            ECEF2ECI_DCM = transpose(dcmeci2ecef('IAU-2000/2006', datevec(OldSystemTimeObj.dateAndTime)));
            
            %   DCM for ECI to Body Ref Frame using current position of the
            %   satellite
            ECI2Body_DCM = R3DCM(OldAttitudeObj.attitude.yaw) * R2DCM(OldAttitudeObj.attitude.pitch) * R1DCM(OldAttitudeObj.attitude.roll);
            
            %   Converting Earth Magnetic Field from ECEF to Body
            EarthMagneticField_Body = ECI2Body_DCM * (ECEF2ECI_DCM * OldEarthMagneticField_ECEF.earthMagneticField_ECEF);
            
            %   Calculating Mu vector of satellite in Body
            SatelliteMu_Body = SatelliteStructureObj.satelliteMagneticField_Body + (SatelliteStructureObj.satelliteHysteresisRod1_Body ...
                               + SatelliteStructureObj.satelliteHysteresisRod2_Body);
                           
            %   Torque acting on satellite in Body frame from Magnetic Force               
            MagneticTorque_Body = cross(SatelliteMu_Body, EarthMagneticField_Body);
            
            %   AngularVelocity derivative
            AngularVelocity_Body_dot = transpose(SatelliteStructureObj.inertiaMatrix_Body)*transpose((-MagneticTorque_Body ... %Need to transpose to match matrix dimensions for multiplication
                                  - cross([OldAttitudeObj.angularVelocity.pitch, OldAttitudeObj.angularVelocity.yaw, OldAttitudeObj.angularVelocity.roll],...
                                          [OldAttitudeObj.angularMomentum.pitch, OldAttitudeObj.angularMomentum.yaw, OldAttitudeObj.angularMomentum.roll])));
                              
            %   Finding new angular velocity by multiplying Time step by
            %   derivative and added to previous timestep values
            NewAttitudeObj.angularVelocity = [OldAttitudeObj.angularVelocity.pitch; OldAttitudeObj.angularVelocity.yaw; OldAttitudeObj.angularVelocity.roll]...
                                             + TimeStep*AngularVelocity_Body_dot;
            
            %   Finding derivative of angular position
            Theta_Body_dot = [0, OldAttitudeObj.attitude.yaw, -OldAttitudeObj.attitude.pitch
                              -OldAttitudeObj.attitude.yaw, 0, OldAttitudeObj.attitude.roll
                              OldAttitudeObj.attitude.pitch, -OldAttitudeObj.attitude.roll, 0]...
                              * [OldAttitudeObj.attitude.pitch; OldAttitudeObj.attitude.yaw; OldAttitudeObj.attitude.roll];
                    
            %   New angular position in Body calculated from angular
            %   position derivative * timestep added to previous timestep
            %   position
            NewAttitudeObj.attitude = [OldAttitudeObj.attitude.pitch; OldAttitudeObj.attitude.yaw; OldAttitudeObj.attitude.roll]...
                                      + TimeStep*Theta_Body_dot;
        end
        