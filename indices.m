classdef indices<handle
    %indices class servers to store the used indices for data treatment.
    %   Useful indices are so far:
    %   start of ref segment
    %   end of ref segment
    %   start of measure segment
    %   end of measure segment
    %   start of 2nd measure segment
    %   end of 2nd measure segment
    
    properties
        ini = intInterval;
        med = intInterval;
        fin = intInterval;
    end
    
    methods
        function inilength = inilength(obj)
            inilength = obj.ini.length;
        end
        
        function medlength = medlength(obj)
            medlength = obj.med.length;
        end
        
        function finlength = finlength(obj)
            finlength = obj.fin.length;
        end
    end
    
end

