classdef Post_Sel < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        hfig
        haxes
        Y_MAX
        Y_MIN
        X_MAX
        X_MIN
        X_SLIDER
        STEP2_START
        STEP2_STOP
        MEASURE_LINE
        LOAD
        PREVIOUS
        NEXT
        REFRESH
        SET_THRESHOLDS
        SAVE
        APPLY
        FILENAME
        X_STRING
        AUTO_EXTEND
        
        LSD
        Timeaxis
        PostSel
        minTh
        maxTh
        hslider
        Output
    end
    
    methods
        function [app]=Post_Sel(varargin)
            app.hfig = figure(...
            'Units','normalized',...
            'PaperUnits',get(0,'defaultfigurePaperUnits'),...
            'IntegerHandle','off',...
            'MenuBar','none',...
            'Name','PostSel',...
            'NumberTitle','off',...
            'Position',[0.2 0.05 0.6 0.9],...
            'Resize','off',...
            'WindowStyle','normal',...
            'Tag','PostSel_fig',...
            'Visible','on');

            app.haxes = axes(...
            'Parent',app.hfig,...
            'Units','normalized',...
            'Position',[0.1 0.15 0.6 0.8],...
            'LooseInset',[29.848 8.47 21.812 5.775],...
            'Tag','axes1');


            % 'Y_MAX'

            app.Y_MAX = uicontrol(...
            'Parent',app.hfig,...
            'Units','normalized',...
            'Callback',@app.Y_MAX_Callback,...
            'Position',[0.02 0.935 0.04 0.03],...
            'String','Y MAX',...
            'Style','edit',...
            'Tag','Y_MAX');

            % 'Y_MIN'

            app.Y_MIN = uicontrol(...
            'Parent',app.hfig,...
            'Units','normalized',...
            'Callback',@app.Y_MIN_Callback,...
            'Position',[0.02 0.135 0.04 0.03],...
            'String','Y MIN',...
            'Style','edit',...
            'Tag','Y_MIN');

            % 'X_MIN'

            app.X_MIN = uicontrol(...
            'Parent',app.hfig,...
            'Units','normalized',...
            'Callback',@app.X_MIN_Callback,...
            'Position',[0.08 0.1 0.04 0.03],...
            'String','X MIN',...
            'Style','edit',...
            'Tag','X_MIN');


            % 'X_MAX'

            app.X_MAX = uicontrol(...
            'Parent',app.hfig,...
            'Units','normalized',...
            'Callback',@app.X_MAX_Callback,...
            'Position',[0.68 0.1 0.04 0.03],...
            'String','X MAX',...
            'Style','edit',...
            'Tag','X_MAX');

            % 'X_SLIDER'

            app.X_SLIDER = uicontrol(...
            'Parent',app.hfig,...
            'Units','normalized',...
            'BackgroundColor',[0.9 0.9 0.9],...
            'Callback',@app.X_SLIDER_Callback,...
            'Position',[0.08 0.05 0.64 0.02],...
            'String','X_SLIDER',...
            'Style','slider',...
            'Tag','X_SLIDER');

            % 'LOAD'

            app.LOAD = uicontrol(...
            'Parent',app.hfig,...
            'Units','normalized',...
            'Callback',@app.LOAD_Callback,...
            'Position',[0.8 0.25 0.1 0.03],...
            'String','LOAD',...
            'Tag','LOAD');

            % 'STEP2_START'

            app.STEP2_START = uicontrol(...
            'Parent',app.hfig,...
            'Units','normalized',...
            'Callback',@app.STEP2_START_Callback,...
            'Position',[0.8 0.9 0.1 0.02],...
            'String','STEP2 START',...
            'Style','popupmenu',...
            'Tag','STEP2_START');

            % 'STEP2_STOP'

            app.STEP2_STOP = uicontrol(...
            'Parent',app.hfig,...
            'Units','normalized',...
            'Callback',@app.STEP2_STOP_Callback,...
            'Position',[0.8 0.79 0.1 0.02],...
            'String','STEP2 STOP',...
            'Style','popupmenu',...
            'Tag','STEP2_STOP');
        
            % 'MEASURE_LINE'

            app.MEASURE_LINE = uicontrol(...
            'Parent',app.hfig,...
            'Units','normalized',...
            'Callback',@app.MEASURE_LINE_Callback,...
            'Position',[0.8 0.65 0.1 0.02],...
            'String','MEASURE LINE',...
            'Style','popupmenu',...
            'Tag','MEASURE LINE');
        
            % 'PREVIOUS'

            app.PREVIOUS = uicontrol(...
            'Parent',app.hfig,...
            'Units','normalized',...
            'Callback',@app.PREVIOUS_Callback,...
            'Position',[0.74 0.83 0.06 0.05],...
            'String','PREVIOUS',...
            'Tag','PREVIOUS');

            % 'NEXT'

            app.NEXT = uicontrol(...
            'Parent',app.hfig,...
            'Units','normalized',...
            'Callback',@app.NEXT_Callback,...
            'Position',[0.9 0.83 0.06 0.05],...
            'String','NEXT',...
            'Tag','NEXT');

            % 'REFRESH'

            app.REFRESH = uicontrol(...
            'Parent',app.hfig,...
            'Units','normalized',...
            'Callback',@app.REFRESH_Callback,...
            'Position',[0.82 0.84 0.06 0.03],...
            'String','REFRESH',...
            'Tag','REFRESH');

            % 'SET_THRESHOLDS'

            app.SET_THRESHOLDS = uicontrol(...
            'Parent',app.hfig,...
            'Units','normalized',...
            'Callback',@app.SET_THRESHOLDS_Callback,...
            'Position',[0.8 0.5 0.1 0.03],...
            'String','SET THRESHOLDS',...
            'Tag','SET_THRESHOLDS' );

            % 'SAVE'

            app.SAVE = uicontrol(...
            'Parent',app.hfig,...
            'Units','normalized',...
            'Callback',@app.SAVE_Callback,...
            'Position',[0.82 0.17 0.06 0.03],...
            'String','EXPORT',...
            'Tag','EXPORT');
        
            % 'APPLY'

            app.APPLY = uicontrol(...
            'Parent',app.hfig,...
            'Units','normalized',...
            'Callback',@app.APPLY_Callback,...
            'Position',[0.82 0.12 0.06 0.03],...
            'String','APPLY',...
            'Tag','APPLY');

            % 'FILENAME'

            app.FILENAME = uicontrol(...
            'Parent',app.hfig,...
            'Units','normalized',...
            'Callback',@app.FILENAME_Callback,...
            'Position',[0.8 0.2 0.1 0.03],...
            'String','enter filename',...
            'Style','edit',...
            'Tag','FILENAME');

            % 'X_STRING'

            app.X_STRING = uicontrol(...
            'Parent',app.hfig,...
            'Units','normalized',...
            'Callback',@app.X_STRING_Callback,...
            'Position',[0.72 0.05 0.04 0.02],...
            'String','X pt',...
            'Style','edit',...
            'Tag','X_STRING');
        
            % 'AUTO_EXTEND'

            app.AUTO_EXTEND = uicontrol(...
            'Parent',app.hfig,...
            'Units','normalized',...
            'BackgroundColor',[0.8 0.8 0.8],...
            'Position',[0.78 0.45 0.15  0.03],...
            'String','Auto extend current threshold',...
            'Style','checkbox',...
            'Value',1,...
            'Tag','AUTO_EXTEND');
        
            set(app.hfig,'Toolbar','figure');  % Display the standard toolbar
            set(app.hfig,'ButtonDownFcn',@app.SET_THRESHOLDS_Callback);
            set(app.haxes,'ButtonDownFcn',@app.SET_THRESHOLDS_Callback);
            
            p = inputParser;
            defaultLoad_Manager_Object=-1;
            defaultTimeaxis=-1;
            defaultMeasureLine=1;
            addOptional(p,'data',defaultLoad_Manager_Object);
            addOptional(p,'Timeaxis',defaultTimeaxis);  
            addOptional(p,'MeasureLine',defaultMeasureLine);
            parse(p,varargin{:});
            
            app.Timeaxis=p.Results.Timeaxis;
            app.LSD=p.Results.data;
            if app.LSD==-1
               return
            else
                Step2String=1:app.LSD.Nstep2;
                set(app.STEP2_START,'String', Step2String);
                set(app.STEP2_START,'Value', 1);
                set(app.STEP2_STOP,'String', Step2String);
                set(app.STEP2_STOP,'Value', min(app.LSD.Nstep2,101));

                MeasurelineString=1:app.LSD.Nmeasure;
                set(app.MEASURE_LINE,'String', MeasurelineString);
                set(app.MEASURE_LINE,'Value', p.Results.MeasureLine);
                %SETTING GRAPH WINDOW
                Xmin=app.Timeaxis(1);
                Xmax=app.Timeaxis(app.LSD.Nsweep);
                if Xmax==Xmin
                    Xmax=app.Timeaxis(app.LSD.Nsweep-1);
                    disp('WARNING: start and end values are the same. Time axis cannot be built properly.')
                end
                Ymin=min(min(min(app.LSD.data(:,:,:,get(app.MEASURE_LINE,'Value')))));
                Ymax=max(max(max(app.LSD.data(:,:,:,get(app.MEASURE_LINE,'Value')))));
                initXth=12;
                set(app.X_SLIDER,'Min',1);  
                set(app.X_SLIDER,'Max',app.LSD.Nsweep);
                set(app.X_SLIDER,'Value',initXth);
                set(app.X_SLIDER,'SliderStep',[1/(app.LSD.Nsweep-1) 20/(app.LSD.Nsweep-1)]);
                set(app.X_STRING,'string', app.Timeaxis(initXth));
                set(app.X_MIN,'string', Xmin);
                set(app.X_MAX,'string', Xmax);
                set(app.Y_MIN,'string', Ymin);
                set(app.Y_MAX,'string', Ymax);
                set(app.haxes,'xlim',[Xmin Xmax]);
                set(app.haxes,'ylim',[Ymin Ymax]);
                app.PostSel=zeros(app.LSD.Nstep,app.LSD.Nstep2);
                app.replot();
            end 
        
        end
        
        function LOAD_Callback(app, hObject, eventdata)

            [filename, pathname] = uigetfile({'*.lvm;*.mat;','Supported Files (*.lvm,*.mat)';'*.lvm','LabView data (*.lvm)';'*.mat','MAT-files (*.mat)';'*.*', 'All Files (*.*)'}, 'Please pick the file to load'); %open browse window
            if filename==0 % if user canceled, return
               return
            end
            F=[pathname filename];
            set(app.LOAD, 'Enable', 'off');
            drawnow; 
            app.LSD=Load_Manager(F);
            set(app.LOAD, 'Enable', 'on');

            set(app.FILENAME,'string',Load_Manager.remove_path(Load_Manager.remove_extension(app.LSD.filename)));

            app.Timeaxis=app.LSD.sweep_dim.param_values';
            if size(app.Timeaxis,2)>1
                f=figure;
                Timeaxis_table=uitable('Parent',f,'Units','normalized','Position',[0.05 0.1 0.88 0.8]);
                set(Timeaxis_table,'Data',app.Timeaxis);
                prompt = {'Select column to use as time axis?'};
                dlg_title = 'enter column number';
                num_lines= 1;
                def     = {'1'};
                values  = inputdlg(prompt,dlg_title,num_lines,def);
                app.Timeaxis=app.Timeaxis(:,str2double(values(1)));
                close(f);
            end


            % SETTING STEP2 STRINGS
            Step2String=1:app.LSD.Nstep2;
            set(app.STEP2_START,'String', Step2String);
            set(app.STEP2_START,'Value', 1);
            set(app.STEP2_STOP,'String', Step2String);
            if app.LSD.Nstep2>100
              set(app.STEP2_STOP,'Value', 101);
            else
              set(app.STEP2_STOP,'Value', 1);
            end
            MeasurelineString=1:app.LSD.Nmeasure;
            set(app.MEASURE_LINE,'String', MeasurelineString);
            set(app.MEASURE_LINE,'Value', 1);
            %SETTING GRAPH WINDOW
            Xmin=app.Timeaxis(1);
            Xmax=app.Timeaxis(app.LSD.Nsweep);
            if Xmax==Xmin
                Xmax=app.Timeaxis(app.LSD.Nsweep-1);
                disp('WARNING: start and end values are the same. Time axis cannot be built properly.')
            end
                
            Ymin=0;
            Ymax=max(max(max(app.LSD.data(:,:,:,get(app.MEASURE_LINE,'Value')))));
            initXth=6;
            set(app.X_SLIDER,'Min',1);  
            set(app.X_SLIDER,'Max',app.LSD.Nsweep);
            set(app.X_SLIDER,'Value',initXth);
            set(app.X_SLIDER,'SliderStep',[1/(app.LSD.Nsweep-1) 20/(app.LSD.Nsweep-1)]);
            set(app.X_STRING,'string', app.Timeaxis(initXth));
            set(app.X_MIN,'string', Xmin);
            set(app.X_MAX,'string', Xmax);
            set(app.Y_MIN,'string', Ymin);
            set(app.Y_MAX,'string', Ymax);
            set(app.haxes,'xlim',[Xmin Xmax]);
            set(app.haxes,'ylim',[Ymin Ymax]);

            app.PostSel=zeros(app.LSD.Nstep,app.LSD.Nstep2);

            app.replot();
        end

        function X_MIN_Callback(app, hObject, eventdata)

            str=get(hObject,'String');
            val=str2double(str);
            Xlim=get(app.haxes,'xlim');
            set(app.haxes,'xlim',[val Xlim(2)]);
            if val < Xlim(1)
                app.replot();
            end
        end

        function X_MAX_Callback(app, hObject, eventdata)

            str=get(hObject,'String');
            val=str2double(str);
            Xlim=get(app.haxes,'xlim');
            set(app.haxes,'xlim',[Xlim(1) val]);
            if val > Xlim(2)
                app.replot();
            end
        end

        function Y_MIN_Callback(app, hObject, eventdata)

            str=get(hObject,'String');
            val=str2double(str);
            Ylim=get(app.haxes,'ylim');
            set(app.haxes,'ylim',[val Ylim(2)]);
            if val < Ylim(1)
                app.replot();
            end
        end

        function Y_MAX_Callback(app, hObject, eventdata)

            str=get(hObject,'String');
            val=str2double(str);
            Ylim=get(app.haxes,'ylim');
            set(app.haxes,'ylim',[Ylim(1) val]);
            if val > Ylim(2)
                app.replot();
            end
        end

        function X_STRING_Callback(app, hObject, eventdata)

            str=get(hObject,'String');
            val=str2double(str);
            t=find(app.Timeaxis<val,1,'last');
            set(app.X_SLIDER,'Value',t);
            app.replot();
        end
        
        function X_SLIDER_Callback(app, hObject, eventdata)
            val=get(hObject,'Value');
            val=round(val);
            set(hObject,'Value',val);
            set(app.X_STRING,'String',app.Timeaxis(val));
            ymin=str2double(get(app.Y_MIN,'String'));
            ymax=str2double(get(app.Y_MAX,'String'));
            if ~isempty(app.hslider)
                delete(app.hslider)
            end
            app.hslider=plot(app.haxes,[app.Timeaxis(val) app.Timeaxis(val)],[ymin ymax],'--','color','black','LineWidth',2);
        end

        function STEP2_START_Callback(app, hObject, eventdata)
            app.replot();
        end

        function STEP2_STOP_Callback(app, hObject, eventdata)
            app.replot();
        end
        
        function MEASURE_LINE_Callback(app, hObject, eventdata)
            app.replot();
        end

        function PREVIOUS_Callback(app, hObject, eventdata)

            step2start=get(app.STEP2_START,'Value');
            step2stop=get(app.STEP2_STOP,'Value');
            step2gap=step2stop-step2start;
            M=app.LSD.data(:,:,:,get(app.MEASURE_LINE,'Value'));
            indxth=get(app.X_SLIDER,'Value');

            if (step2stop-step2gap)<1
                return;
            elseif (step2start-step2gap)<1
                step2start=1;
                step2stop=step2gap+1;
            else
                step2stop=step2start;
                step2start=step2start-step2gap;
            end

            set(app.STEP2_START,'Value', step2start);
            set(app.STEP2_STOP,'Value', step2stop);
            if get(app.AUTO_EXTEND,'Value')
                app.PostSel(:,step2start:step2stop)=(M(indxth,:,step2start:step2stop)>app.minTh & M(indxth,:,step2start:step2stop)<app.maxTh);
            end
            app.replot();
        end

        function NEXT_Callback(app, hObject, eventdata)

            step2start=get(app.STEP2_START,'Value');
            step2stop=get(app.STEP2_STOP,'Value');
            step2gap=step2stop-step2start;
            M=app.LSD.data(:,:,:,get(app.MEASURE_LINE,'Value'));
            indxth=get(app.X_SLIDER,'Value');

            if (step2start+step2gap)>=app.LSD.Nstep2
                return;
            elseif (step2stop+step2gap)>=app.LSD.Nstep2
                step2start=app.LSD.Nstep2-step2gap;
                step2stop=app.LSD.Nstep2;
            else
                step2start=step2stop;
                step2stop=step2stop+step2gap;
            end
            
            set(app.STEP2_START,'Value', step2start);
            set(app.STEP2_STOP,'Value', step2stop);  
            if get(app.AUTO_EXTEND,'Value')
                app.PostSel(:,step2start:step2stop)=(M(indxth,:,step2start:step2stop)>app.minTh & M(indxth,:,step2start:step2stop)<app.maxTh);
            end
            app.replot();
        end

        function SET_THRESHOLDS_Callback(app, hObject, eventdata)
            if hObject~=app.SET_THRESHOLDS
                click_type=get(app.hfig,'selectiontype');
                if ~strcmp(click_type,'open')
                    return;
                end
            end
            M=app.LSD.data(:,:,:,get(app.MEASURE_LINE,'Value'));
            step2start=get(app.STEP2_START,'Value');
            step2stop=get(app.STEP2_STOP,'Value');
            indxth=get(app.X_SLIDER,'Value');

            [~,yth]=ginput(2);
            app.minTh=min(yth);
            app.maxTh=max(yth);

            app.PostSel(:,step2start:step2stop)=(M(indxth,:,step2start:step2stop)>app.minTh & M(indxth,:,step2start:step2stop)<app.maxTh);

            app.replot();
        end

        function REFRESH_Callback(app, hObject, eventdata)
            app.replot();
        end

        function SAVE_Callback(app, hObject, eventdata)
            filename=get(app.FILENAME,'String');
            assignin('base',[filename '_PostSel'],app.PostSel);
            save([filename '_PostSel'],'app.PostSel');
        end
        
        function APPLY_Callback(app, hObject, eventdata)
            app.Output=app.PostSel;
            close(app.hfig)
        end

        function FILENAME_Callback(app, hObject, eventdata)
        end

        function replot(app)
            M=app.LSD.data(:,:,:,get(app.MEASURE_LINE,'Value'));
            step2start=get(app.STEP2_START,'Value');
            step2stop=get(app.STEP2_STOP,'Value');
            step2int=step2stop-step2start+1;

            xmin=str2double(get(app.X_MIN,'String'));
            xmax=str2double(get(app.X_MAX,'String'));
            ymin=str2double(get(app.Y_MIN,'String'));
            ymax=str2double(get(app.Y_MAX,'String'));

            indxth=get(app.X_SLIDER,'Value');
            indxmin=find(app.Timeaxis(1:end-1)<=xmin,1,'last');
            indxmax=find(app.Timeaxis<=xmax,1,'last');

            indxinterval=indxmax-indxmin+1;

            NbGood=sum(sum(app.PostSel(:,step2start:step2stop)));
            NbBad=app.LSD.Nstep*step2int-NbGood;
            GoodPlots=zeros(NbGood,indxinterval);
            BadPlots=zeros(NbBad,indxinterval);
            g=1;
            b=1;
            for k=step2start:step2stop
            for j=1:app.LSD.Nstep
                if app.PostSel(j,k)
                    GoodPlots(g,:)=M(indxmin:indxmax,j,k);
                    g=g+1;
                else
                    BadPlots(b,:)=M(indxmin:indxmax,j,k);
                    b=b+1;
                end

            end
            end

            cla(app.haxes)
            hold(app.haxes,'on')
            if NbGood>0
                plot(app.haxes,app.Timeaxis(indxmin:indxmax),GoodPlots,'color',[0 0.6000 0]); % green for good curves app.hgood=
            end
            if NbBad>0
                plot(app.haxes,app.Timeaxis(indxmin:indxmax),BadPlots,'color',[0.8000 0 0]); % red for bad ones app.hbad=
            end
                app.hslider=plot(app.haxes,[app.Timeaxis(indxth) app.Timeaxis(indxth)],[ymin ymax],'--','color','black','LineWidth',2);
            end

    end
    
end

