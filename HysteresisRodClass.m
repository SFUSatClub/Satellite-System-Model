classdef HysteresisRodClass
    
    properties (Constant)
        
        u0 = 8.85418782*10^-12  %[s^4 A^2 m^-3 kg^-1] permittivity

    end
    
    properties
        
        volume;                 %[cm^3]
        Hc;                     %[A/m] coercivity
        Br;                     %[Tesla] remanance
        Bs;                     %[Tesla] saturation
        
        axis;                   % normalized, body reference frame
        B;                      %[Tesla] induced (remanent) flux
        m;                      %[Nm/Tesla] dynamic magnetic moment
        H_aligned;              %[A/m] 
        
    end
    
    methods
        % Constructor
        function self = HysteresisRodClass(Axis, Length, Diameter, Hc, Br, Bs)
            if nargin == 0
            else
                self.axis = Axis/norm(Axis);
                self.volume = (Length*pi*(Diameter)^2)/4;
                self.Hc = Hc;
                self.Br = Br;
                self.Bs = Bs;

                self.B = 0;
                self.m = [0 0 0];
                self.H_aligned = 0;
                
            end
        end

        function self = CalculateMagneticMoment(self, H)

            p = tan(pi*self.Br/(2*self.Bs))/self.Hc;

            dH = dot(H, self.axis) - self.H_aligned;
            self.H_aligned = dot(H, self.axis);

            if (dH < 0)
                self.B = 2*self.Bs*atan(p*(self.H_aligned + self.Hc))/pi;
            elseif (dH > 0)
                self.B = 2*self.Bs*atan(p*(self.H_aligned - self.Hc))/pi;
            end
            
            self.m = self.axis * self.B*(self.volume/(100*100*100))/self.u0;

        end
    end
end