classdef intInterval<handle
    %ordered interval of integer values.
    
    properties
        first;
        last;
    end
    
    methods
        function length = length(obj)
            length = obj.last - obj.first + 1;
        end
        
        function setinterval = setinterval(obj, interv)
            obj.last = interv(2);
            obj.first = interv(1);
        end
    end
    
end

