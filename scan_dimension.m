classdef scan_dimension < handle
    %define the methods associated to either sweep, step or step2 dimension
    
    properties
        used_param_number=0;
        param_infos={{'';'';'';''}}; %name,start value,end value,units
        param_values
    end
    
    methods
        function obj = scan_dimension(used_param_number,param_infos,param_values)
            if nargin > 0
                obj.used_param_number=used_param_number;
                obj.param_infos=param_infos;
                obj.param_values=param_values;
            end
        end
        
        function [AXIS, LABEL]=build_dim_axis(obj,used_param,convert_counter,duration)
            % --- build axis for the given dimension to be plotted
            if nargin<4
                convert_counter=false; %  sets default value for optional arguments.
                duration=0;
            end
            if used_param>obj.used_param_number
                error('ERROR: index exceeds the actual number of parameters used');
            end
            AXIS=[];
            if ~isempty(obj.param_values)
            AXIS=obj.param_values(used_param,:);
            end
            LABEL=[obj.param_infos{used_param}{1} ' (' obj.param_infos{used_param}{4} ')'];
            
            if convert_counter && strcmpi(obj.param_infos{used_param}{1},'counter')
               N=size(obj.param_values,2);
               AXIS=(0:N-1).*duration/N;
               LABEL='Time (ms)'; 
            end
        end
        
        function [string] = build_dimlabel_string(obj)
            % --- build string for the popup menu of dim
            string = obj.param_infos{1}{1};
            for i = 2:size(obj.param_infos,2)
                string = [string '|' obj.param_infos{i}{1}];
            end
            if strcmp(string,'')
                string='Not Used';
            end
        end
    end
end

