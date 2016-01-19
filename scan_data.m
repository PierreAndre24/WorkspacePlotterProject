classdef scan_data < handle
    %Object containing all the data from the lvm files returned by
    %Sylvain's LabView program.
    %   Load_Manager inherits of the class and includes the instances to
    %   create this kind of objects from files.
    
    properties
        data
        Nsweep=1;
        Nstep=0;
        Nstep2=0;
        Nmeasure=1;
        sweep_dim
        step_dim
        step2_dim
        measure_dim
        DAC_init_values=zeros(8);
        B_field_value=0;
    end
    
    methods
        function obj = scan_data(sweep_dim,step_dim,step2_dim,measures_dim)
            if nargin > 0
                obj.sweep_dim = sweep_dim; % these "_dim" variables must be scan_dimension class objects
                obj.step_dim = step_dim;
                obj.step2_dim = step2_dim;
                obj.measure_dim = measures_dim;
            end
        end
        
        function delete(obj)
            delete(obj.sweep_dim)
            delete(obj.step_dim)
            delete(obj.step2_dim)
            delete(obj.measure_dim)
        end 
    end
    
end

