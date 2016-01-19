classdef expinfos
    %EXPINFOS is loaded with the information on the experiment file
    %   Detailed explanation goes here
    
    properties
        usedStep2 = 0;
        usedStep = 0;
        usedsweep = 1;
        step2infos = {{''}};
%         step2values = [];
        stepinfos = {{''}};
        sweepinfos = {{''}};
        measures = {{''}};
    end
    
    methods
        %% method to build the X label for graphs
        function sweepTxt = sweepTxt(obj, use,sweepcoord)
            switch use
                case '1D' % case of a 1D plot
                    % we want sweep infos as well as step infos
                    sweepTxt = obj.sweepinfos{sweepcoord}{1};
                    if(obj.usedsweep>1)
                        % let's stack up sweep infos
                        sweepTxt = [sweepTxt ' (sweeeps: '];
                        for i = 1:obj.usedsweep
                            sweepTxt = [sweepTxt ' ' sweepinfostxt(obj,i)];
                        end
                        sweepTxt = [sweepTxt ')'];
                    end
                    if(obj.usedStep~=0)
                        % and step infos
                        sweepTxt = [sweepTxt ' (steps: '];
                        for i = 1:obj.usedStep
                            sweepTxt = [sweepTxt ' ; ' stepinfostxt(obj,i)];
                        end
                        sweepTxt = [sweepTxt ')'];
                    end
                otherwise % for other graphs, we just stack sweep infos
                    sweepTxt = obj.sweepinfos{sweepcoord}{1};
                    if(obj.usedsweep>1)
                        sweepTxt = [sweepTxt ' (' sweepinfostxt(obj,1)];
                        for i = 2:obj.usedsweep
                            sweepTxt = [sweepTxt ' ; ' sweepinfostxt(obj,i)];
                        end
                        sweepTxt = [sweepTxt ' )'];
                    end
            end
        end
        
        %% method to get the sweep informations as a prebuilt string
        function sweepinfostxt = sweepinfostxt(obj, i)
            if i>obj.usedsweep
                error('Trying to build sweep infos string from unexisting data....');
            end
            
            sweepinfostxt = [obj.sweepinfos{i}{1} ' ' obj.sweepinfos{i}{2} ' ' obj.sweepinfos{i}{4} ' \rightarrow  ' obj.sweepinfos{i}{3} ' ' obj.sweepinfos{i}{4}];
        end
        
        %% method to get the step informations as a prebuilt string
        function stepinfostxt = stepinfostxt(obj, i)
            if i>obj.usedStep
                error('Trying to build step infos string from unexisting data....');
            end
            stepinfostxt = [obj.stepinfos{i}{1} ' ' obj.stepinfos{i}{2} ' ' obj.stepinfos{i}{4} ' \rightarrow  ' obj.stepinfos{i}{3} ' ' obj.stepinfos{i}{4}];
        end
        
        %% method to build the step info string
        function stepTxt = steptxt(obj,stepcoord)
            stepTxt =obj.stepinfos{stepcoord}{1};
                    if(obj.usedStep>1)
                        % let's stack up step infos
                        stepTxt = [stepTxt ' (' stepinfostxt(obj,1)];
                        for i = 2:obj.usedStep
                            stepTxt = [stepTxt ' ; ' stepinfostxt(obj,i)];
                        end
                        stepTxt = [stepTxt ' )'];
                    end
        end
        
        %% method to generate graph titles
        %function graphTitle = graphtitle2D(obj,step2used,step2value,measureused, derivative)
        function graphTitle = graphtitle2D(obj,measureused, derivative)
            measure = obj.measures{measureused};
            if derivative==2
                graphTitle = [measure{1} '(' measure{2} '/\delta V)'];
            else
                graphTitle = [measure{1} '(' measure{2} ')'];
            end
            %if step2used
            %    graphTitle = [graphTitle '@ step2 = ' step2value];
            %end 
        end
        
    end
    
end

