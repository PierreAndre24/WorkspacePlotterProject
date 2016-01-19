classdef Edge_Threshold_Definer < handle
    %Interactive display of X and Y slices of a 2D plot data.
    %   Detailed explanation goes here
    
    properties
        STEP_IND
        STEP2_IND
        WEIGHT_THRESHOLD
        OK
        
        figID
        axesID1
        data_plot
        axesID2
        threshold_line
        track_weight_stem
        X
        DATA           
        
    end
    
    methods
        function [obj]=Edge_Threshold_Definer(DATA,X)
            assignin('base','DATA',DATA)
            assignin('base','X',X)
            obj.DATA=DATA;
            obj.X=X;
%                 obj.Xlabel=Xlabel;
%                 obj.Ylabel=Ylabel;

            obj.figID=figure;
            % figure is divided as follow:
            %   1   2   3   4   5   6   
            %   7   8   9   10  11  12
            %   13  14  15  16  17  18
            %   19  20  21  22  23  24
            %   25  26  27  28  29  30
            %   31  32  33  34  35  36
            obj.axesID1=subplot(6,6,[1:4,7:10,13:16]);
            obj.axesID2=subplot(6,6,[19:22,25:28,31:34]);

            StepString=1:size(obj.DATA,2);
            Step2String=1:size(obj.DATA,3);
            % Creating 'STEP_STOP' pop up
            obj.STEP_IND = uicontrol(...
            'Units','normalized',...
            'BackgroundColor',[1 1 1],...
            'Callback',@obj.STEP_IND_Callback,...
            'Position',[0.8 0.7 0.1 0.15],...
            'String',StepString,...
            'Style','popupmenu',...
            'Value',1,...
            'Tag','STEP_IND');

            % Creating 'STEP2_STOP' pop up
            obj.STEP2_IND = uicontrol(...
            'Units','normalized',...
            'BackgroundColor',[1 1 1],...
            'Callback',@obj.STEP2_IND_Callback,...
            'Position',[0.8 0.5 0.1 0.15],...
            'String',Step2String,...
            'Style','popupmenu',...
            'Value',1,...
            'Tag','STEP2_IND');
        
            % Creating 'WEIGHT_THRESHOLD' edit text
            obj.WEIGHT_THRESHOLD = uicontrol(...
            'Units','normalized',...
            'BackgroundColor',[1 1 1],...
            'Callback',@obj.WEIGHT_THRESHOLD_Callback,...
            'Position',[0.8 0.3 0.1 0.05],...
            'String','Weight Threshold',...
            'Style','edit',...
            'Tag','WEIGHT_THRESHOLD');
        
            % Creating 'RUN' button
            obj.OK = uicontrol(...
            'Units','normalized',...
            'Callback',@obj.OK_Callback,...
            'FontWeight','bold',...
            'Position',[0.8 0.1 0.1 0.05],...
            'String','OK',...
            'Tag','OK');
            
            obj.data_plot=plot(obj.axesID1,obj.X,obj.DATA(:,1,1));
            [time,weight]=Edge_detect(obj.X,obj.DATA(:,1,1));
            drawnow
            obj.track_weight_stem=stem(obj.axesID2,time,weight);
            set(obj.axesID2,'Xlim',get(obj.axesID1,'Xlim'))
            hold on
            th=mean(get(obj.axesID2,'Ylim'))*ones(1,2);
            obj.threshold_line=plot(get(obj.axesID2,'Xlim'),th,'color','red','Linestyle','-');
            set(obj.WEIGHT_THRESHOLD,'String',num2str(th(1)))

        end
        
        function STEP_IND_Callback(obj, hObject, eventdata)
            obj.reprocess_edge_detection;
        end
    
        function STEP2_IND_Callback(obj, hObject, eventdata)
           obj.reprocess_edge_detection;
        end
        
        function WEIGHT_THRESHOLD_Callback(obj, hObject, eventdata)
            set(obj.threshold_line,'YData',str2double(get(obj.WEIGHT_THRESHOLD,'String'))*ones(1,2))
        end
        
        function reprocess_edge_detection(obj, hObject, eventdata)
            set(obj.data_plot,'YData',obj.DATA(:,get(obj.STEP_IND,'Value'),get(obj.STEP2_IND,'Value')))
            [time,weight]=Edge_detect(obj.X,obj.DATA(:,get(obj.STEP_IND,'Value'),get(obj.STEP2_IND,'Value')));
            drawnow
            delete(obj.track_weight_stem)
            obj.track_weight_stem=stem(obj.axesID2,time,weight);
            set(obj.axesID2,'Xlim',get(obj.axesID1,'Xlim'))
        end
        
        function OK_Callback(obj, hObject, eventdata)
            assignin('base','Edge_Threshold_Definer_output',str2double(get(obj.WEIGHT_THRESHOLD,'String')))
            close(obj.figID)
        end
        

    end
    
    methods (Static)
    
        
    end
    
end