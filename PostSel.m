classdef PostSel
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
        EXPORT
        FILENAME
        X_CURSOR
        
        LSD
        Timeaxis
    end
    
    methods
        function [app]=PostSel(varargin)
            app.hfig = figure(...
            'Units','characters',...
            'PaperUnits',get(0,'defaultfigurePaperUnits'),...
            'IntegerHandle','off',...
            'MenuBar','none',...
            'Name','PostSel',...
            'NumberTitle','off',...
            'Position',[103 10 230 77],...
            'Resize','off',...
            'WindowStyle','normal',...
            'Tag','PostSel_fig',...
            'Visible','on');

            app.haxes = axes(...
            'Parent',app.hfig,...
            'Units','characters',...
            'Position',[19.8 15.30 140.2 57.8],...
            'LooseInset',[29.848 8.47 21.812 5.775],...
            'Tag','axes1');


            % 'Y_MAX'

            app.Y_MAX = uicontrol(...
            'Parent',app.hfig,...
            'Units','characters',...
            'Callback',@(hObject,eventdata)PostSel2_export('Y_MAX_Callback',hObject,eventdata,guidata(hObject)),...
            'Position',[1 71.4 10.2 1.7],...
            'String','Y MAX',...
            'Style','edit',...
            'Tag','Y_MAX');

            % 'Y_MIN'

            app.Y_MIN = uicontrol(...
            'Parent',app.hfig,...
            'Units','characters',...
            'Callback',@(hObject,eventdata)PostSel2_export('Y_MIN_Callback',hObject,eventdata,guidata(hObject)),...
            'Position',[1 13.7 10.2 1.7],...
            'String','Y MIN',...
            'Style','edit',...
            'Tag','Y_MIN');

            % 'X_MIN'

            app.X_MIN = uicontrol(...
            'Parent',app.hfig,...
            'Units','characters',...
            'Callback',@(hObject,eventdata)PostSel2_export('X_MIN_Callback',hObject,eventdata,guidata(hObject)),...
            'Position',[19.8 7.7 10.2 1.7],...
            'String','X MIN',...
            'Style','edit',...
            'Tag','X_MIN');


            % 'X_MAX'

            app.X_MAX = uicontrol(...
            'Parent',app.hfig,...
            'Units','characters',...
            'Callback',@(hObject,eventdata)PostSel2_export('X_MAX_Callback',hObject,eventdata,guidata(hObject)),...
            'Position',[149.8 7.7 10.2 1.7],...
            'String','X MAX',...
            'Style','edit',...
            'Tag','X_MAX');

            % 'SLIDER_Xth'

            app.Y_MAX = uicontrol(...
            'Parent',app.hfig,...
            'Units','characters',...
            'BackgroundColor',[0.9 0.9 0.9],...
            'Callback',@(hObject,eventdata)PostSel2_export('SLIDER_Xth_Callback',hObject,eventdata,guidata(hObject)),...
            'Position',[16.8 3.8 146.6 1.5],...
            'String','Xth',...
            'Style','slider',...
            'Tag','SLIDER_Xth');

            % 'LOAD'

            app.LOAD = uicontrol(...
            'Parent',app.hfig,...
            'Units','characters',...
            'Callback',@(hObject,eventdata)PostSel2_export('LOAD_Callback',hObject,eventdata,guidata(hObject)),...
            'Position',[184.8 62.2 20.2 3.2],...
            'String','LOAD',...
            'Tag','LOAD');

            % 'STEP2_START'

            app.STEP2_START = uicontrol(...
            'Parent',app.hfig,...
            'Units','characters',...
            'Callback',@(hObject,eventdata)PostSel2_export('STEP2_START_Callback',hObject,eventdata,guidata(hObject)),...
            'Position',[186.4 53.8 17 2.4],...
            'String','STEP2 START',...
            'Style','popupmenu',...
            'Tag','STEP2_START');

            % 'STEP2_STOP'

            app.STEP2_STOP = uicontrol(...
            'Parent',app.hfig,...
            'Units','characters',...
            'Callback',@(hObject,eventdata)PostSel2_export('STEP2_STOP_Callback',hObject,eventdata,guidata(hObject)),...
            'Position',[186.4 47.6 17 2.4],...
            'String','STEP2 STOP',...
            'Style','popupmenu',...
            'Tag','STEP2_STOP');
        
            % 'MEASURE_LINE'

            app.MEASURE_LINE = uicontrol(...
            'Parent',app.hfig,...
            'Units','characters',...
            'Callback',@(hObject,eventdata)PostSel2_export('STEP2_STOP_Callback',hObject,eventdata,guidata(hObject)),...
            'Position',[186.4 39.2 17 2.4],...
            'String','MEASURE LINE',...
            'Style','popupmenu',...
            'Tag','MEASURE LINE');
        
            % 'PREVIOUS'

            app.PREVIOUS = uicontrol(...
            'Parent',app.hfig,...
            'Units','characters',...
            'Callback',@(hObject,eventdata)PostSel2_export('PREVIOUS_Callback',hObject,eventdata,guidata(hObject)),...
            'Position',[166.4 51.1 17 2.4],...
            'String','PREVIOUS',...
            'Tag','PREVIOUS');

            % 'NEXT'

            app.NEXT = uicontrol(...
            'Parent',app.hfig,...
            'Units','characters',...
            'Callback',@(hObject,eventdata)PostSel2_export('NEXT_Callback',hObject,eventdata,guidata(hObject)),...
            'Position',[206.4 51.1 17 2.4],...
            'String','NEXT',...
            'Tag','NEXT');

            % 'REFRESH'

            app.REFRESH = uicontrol(...
            'Parent',app.hfig,...
            'Units','characters',...
            'Callback',@(hObject,eventdata)PostSel2_export('REFRESH_Callback',hObject,eventdata,guidata(hObject)),...
            'Position',[187.6 43.7 14.6 2.4],...
            'String','REFRESH',...
            'Tag','REFRESH');

            % 'SET_THRESHOLDS'

            app.SET_THRESHOLDS = uicontrol(...
            'Parent',app.hfig,...
            'Units','characters',...
            'Callback',@(hObject,eventdata)PostSel2_export('SET_THRESHOLDS_Callback',hObject,eventdata,guidata(hObject)),...
            'Position',[184.8 34.6153846153846 20.2 3.23076923076923],...
            'String','SET THRESHOLDS',...
            'Tag','SET_THRESHOLDS' );

            % 'EXPORT'

            app.EXPORT = uicontrol(...
            'Parent',app.hfig,...
            'Units','characters',...
            'Callback',@(hObject,eventdata)PostSel2_export('EXPORT_Callback',hObject,eventdata,guidata(hObject)),...
            'Position',[179.8 19.2307692307692 30.2 2.46153846153846],...
            'String','EXPORT TO WORKSPACE',...
            'Tag','EXPORT');

            % 'FILENAME'

            app.FILENAME = uicontrol(...
            'Parent',app.hfig,...
            'Units','characters',...
            'Callback',@(hObject,eventdata)PostSel2_export('FILENAME_Callback',hObject,eventdata,guidata(hObject)),...
            'Position',[182 15.3076923076923 25.8 2.38461538461538],...
            'String','enter filename',...
            'Style','edit',...
            'Tag','FILENAME');

            % 'X_CURSOR'

            app.X_CURSOR = uicontrol(...
            'Parent',app.hfig,...
            'Units','characters',...
            'Callback',@(hObject,eventdata)PostSel2_export('X_TH_Callback',hObject,eventdata,guidata(hObject)),...
            'Position',[164.4 3.84615384615385 10.2 1.69230769230769],...
            'String','X pt',...
            'Style','edit',...
            'Tag','X_CURSOR');
        
            set(app.hfig,'Toolbar','figure');  % Display the standard toolbar
        
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

            %SETTING GRAPH WINDOW
            Xmin=app.Timeaxis(1);
            % app.current_Xmax=app.Timeaxis(app.Nsweep);
            Xmax=app.Timeaxis(app.LSD.Nsweep);
            Ymin=0;
            Ymax=max(max(max(app.LSD.data(:,:,:,get(app.MEASURE_LINE,'Value')))));
            initXth=6;
            app.current_Xth=app.Timeaxis(initXth);
            set(app.X_MIN,'string', Xmin);
            set(app.X_MAX,'string', Xmax);
            set(app.Y_MIN,'string', Ymin);
            set(app.Y_MAX,'string', Ymax);
            set(app.axes1,'xlim',[Xmin Xmax]);
            set(app.axes1,'ylim',[Ymin Ymax]);

            set(app.SLIDER_Xth,'Min',1);
            set(app.SLIDER_Xth,'Max',app.LSD.Nsweep);
            set(app.SLIDER_Xth,'Value',initXth);
            set(app.SLIDER_Xth,'SliderStep',[1/(app.LSD.Nsweep-1) 20/(app.LSD.Nsweep-1)]);
            set(app.X_TH,'string', app.Timeaxis(initXth));

            app.hslider=[];
            app.hgood=[];
            app.hgood=[];

            app.PostSel=zeros(app.Nstep,app.Nstep2);
            app.minth=0;
            app.maxth=0;
            app.indxth=initXth;

            app=replot(hObject,app);
        end





function X_MIN_Callback(app, hObject, eventdata)

str=get(hObject,'String');
if handles.current_Xmin > str2double(str)
    handles.current_Xmin = str2double(str);
    set(handles.axes1,'xlim',[handles.current_Xmin handles.current_Xmax]);
    guidata(hObject,handles);
    handles=replot(hObject,handles);
else
handles.current_Xmin = str2double(str);
set(handles.axes1,'xlim',[handles.current_Xmin handles.current_Xmax]);
end

guidata(hObject,handles);
end
% --- Executes during object creation, after setting all properties.

function X_MAX_Callback(app, hObject, eventdata)

str=get(hObject,'String');
if handles.current_Xmax < str2double(str)
    handles.current_Xmax = str2double(str);
    set(handles.axes1,'xlim',[handles.current_Xmin handles.current_Xmax]);
    guidata(hObject,handles);
    handles=replot(hObject,handles);
else
handles.current_Xmax = str2double(str);
set(handles.axes1,'xlim',[handles.current_Xmin handles.current_Xmax]);
end

guidata(hObject,handles);
end
% --- Executes during object creation, after setting all properties.

function Y_MIN_Callback(app, hObject, eventdata)

str=get(hObject,'String');
if handles.current_Ymin > str2double(str)
    handles.current_Ymin = str2double(str);
    set(handles.axes1,'ylim',[handles.current_Ymin handles.current_Ymax]);
    guidata(hObject,handles);
    handles=replot(hObject,handles);
else
handles.current_Ymin = str2double(str);
set(handles.axes1,'ylim',[handles.current_Ymin handles.current_Ymax]);
end

guidata(hObject,handles);
end
% --- Executes during object creation, after setting all properties.

function Y_MAX_Callback(app, hObject, eventdata)

str=get(hObject,'String');
if handles.current_Ymax < str2double(str)
    handles.current_Ymax = str2double(str);
    set(handles.axes1,'ylim',[handles.current_Ymin handles.current_Ymax]);
    guidata(hObject,handles);
    handles=replot(hObject,handles);
else
handles.current_Ymax = str2double(str);
set(handles.axes1,'ylim',[handles.current_Ymin handles.current_Ymax]);
end

guidata(hObject,handles);
end
% --- Executes during object creation, after setting all properties.

function X_TH_Callback(app, hObject, eventdata)

str=get(hObject,'String');
handles.current_Xth = str2double(str);

time=handles.Timeaxis;
indxth=1;
while time(indxth+1)<=handles.current_Xth && indxth<handles.Nsweep-1
indxth=indxth+1;
end
set(handles.SLIDER_Xth,'Value',indxth);
guidata(hObject,handles);
handles=replot(hObject,handles);
guidata(hObject,handles);
end
% --- Executes during object creation, after setting all properties.

% --- Executes on slider movement.
function SLIDER_Xth_Callback(app, hObject, eventdata)

val=get(hObject,'Value');
indxth=round(val);
handles.current_Xth = handles.Timeaxis(indxth);
set(handles.X_TH,'string',num2str(handles.current_Xth));

time=handles.Timeaxis;
YLIMIT=ylim(handles.axes1);
hold(handles.axes1,'on')
delete(handles.hslider);
handles.hslider=plot(handles.axes1,[time(indxth) time(indxth)],YLIMIT,'--','color','black','LineWidth',2);
% set(handles.axes1,'xlim',XX);
guidata(hObject, handles);
end
% --- Executes during object creation, after setting all properties.






% --- Executes on selection change in STEP2_START.
function STEP2_START_Callback(app, hObject, eventdata)

val=get(hObject,'Value');
handles.current_step2_start = val;
guidata(hObject,handles);
end
% --- Executes during object creation, after setting all properties.

% --- Executes on selection change in STEP2_STOP.
function STEP2_STOP_Callback(app, hObject, eventdata)

val=get(hObject,'Value');
handles.current_step2_stop = val;
guidata(hObject,handles);
end
% --- Executes during object creation, after setting all properties.

% --- Executes on button press in PREVIOUS.
function PREVIOUS_Callback(app, hObject, eventdata)

step2start=handles.current_step2_start;
step2stop=handles.current_step2_stop;
step2gap=step2stop-step2start;
Nstep=handles.Nstep;
minth=handles.minth;
maxth=handles.maxth;
PostSel=handles.PostSel;
measure=handles.measure;
indxth=handles.indxth;

if (step2stop-step2gap)<1

elseif (step2start-step2gap)<1
    handles.current_step2_stop=step2gap+1;
    handles.current_step2_start=1;
    set(handles.STEP2_START,'Value', handles.current_step2_start);
    set(handles.STEP2_STOP,'Value', handles.current_step2_stop);
    
else
    handles.current_step2_stop=handles.current_step2_start;
    handles.current_step2_start=handles.current_step2_start-step2gap;
    set(handles.STEP2_START,'Value', handles.current_step2_start);
    set(handles.STEP2_STOP,'Value', handles.current_step2_stop);    
end

step2start=handles.current_step2_start;
step2stop=handles.current_step2_stop;
if sum(sum(PostSel(:,step2start:step2stop)))<=Nstep
PostSel(:,step2start:step2stop)=(measure(indxth,:,step2start:step2stop)>minth & handles.measure(indxth,:,step2start:step2stop)<maxth);
end
handles.PostSel=PostSel;
guidata(hObject,handles);
handles=replot(hObject,handles);
guidata(hObject,handles);
end
% --- Executes on button press in NEXT.
function NEXT_Callback(app, hObject, eventdata)

step2start=handles.current_step2_start;
step2stop=handles.current_step2_stop;
step2gap=step2stop-step2start;
Nstep=handles.Nstep;
Nstep2=handles.Nstep2;
minth=handles.minth;
maxth=handles.maxth;
PostSel=handles.PostSel;
measure=handles.measure;
indxth=handles.indxth;

if (step2start+step2gap)>=Nstep2

elseif (step2stop+step2gap)>=Nstep2
    handles.current_step2_start=Nstep2-step2gap;
    handles.current_step2_stop=Nstep2;
    set(handles.STEP2_START,'Value', handles.current_step2_start);
    set(handles.STEP2_STOP,'Value', handles.current_step2_stop);
    
else
    handles.current_step2_start=handles.current_step2_stop;
    handles.current_step2_stop=handles.current_step2_stop+step2gap;
    set(handles.STEP2_START,'Value', handles.current_step2_start);
    set(handles.STEP2_STOP,'Value', handles.current_step2_stop);    
end

step2start=handles.current_step2_start;
step2stop=handles.current_step2_stop;
if sum(sum(PostSel(:,step2start:step2stop)))<=Nstep
PostSel(:,step2start:step2stop)=(measure(indxth,:,step2start:step2stop)>minth & handles.measure(indxth,:,step2start:step2stop)<maxth);
end
handles.PostSel=PostSel;
guidata(hObject,handles);
handles=replot(hObject,handles);
guidata(hObject,handles);
end



% --- Executes on button press in SET_THRESHOLDS.
function SET_THRESHOLDS_Callback(app, hObject, eventdata)

GCF_handle=gcf;
measure=handles.measure;
step2start=handles.current_step2_start;
step2stop=handles.current_step2_stop;
step2int=step2stop-step2start+1;
Nsweep=handles.Nsweep;
Nstep=handles.Nstep;
xmin=handles.current_Xmin;
xmax=handles.current_Xmax;
ymin=handles.current_Ymin;
ymax=handles.current_Ymax;
xth=handles.current_Xth;
time=handles.Timeaxis;
PostSel=handles.PostSel;

indxmin=1;
while time(indxmin+1)<=xmin && indxmin<Nsweep-1
indxmin=indxmin+1;
end
indxmax=Nsweep;
while time(indxmax-1)>xmax && indxmax>2
indxmax=indxmax-1;
end
indxth=1;
while time(indxth+1)<=xth && indxth<Nsweep-1
indxth=indxth+1;
end
handles.indxth=indxth;


indxinterval=indxmax-indxmin+1;
NbPlots=Nstep*step2int;
AllPlots=zeros(NbPlots,indxinterval);
a=1;
for k=step2start:step2stop
for j=1:Nstep
    AllPlots(a,:)=measure(indxmin:indxmax,j,k);
    a=a+1; 
end
end
figure
hold on
plot(time(indxmin:indxmax),AllPlots); % green for good curves

ylim([ymin,ymax]);
xlim([xmin xmax]);
plot([time(indxth) time(indxth)],[ymin,ymax],'--','color','black','LineWidth',2);

[~,yth]=ginput(2);
minth=min(yth);
maxth=max(yth);
handles.minth=minth;
handles.maxth=maxth;
close(gcf)


PostSel(:,step2start:step2stop)=(measure(indxth,:,step2start:step2stop)>minth & handles.measure(indxth,:,step2start:step2stop)<maxth);

handles.PostSel=PostSel;
guidata(hObject,handles);
handles=replot(hObject,handles);

figure(GCF_handle)

guidata(hObject,handles);
end





% --- Executes on button press in REFRESH.
function REFRESH_Callback(app, hObject, eventdata)

handles=replot(hObject,handles);
guidata(hObject, handles);  
end


% --- Executes on button press in EXPORT.
function EXPORT_Callback(app, hObject, eventdata)

assignin('base',['PostSel_' handles.current_filename],handles.PostSel);
set(handles.FILENAME,'string', 'enter filename');
handles.current_Filename='no_name';
guidata(hObject,handles);
end

function FILENAME_Callback(app, hObject, eventdata)

str=get(hObject,'String');
handles.current_filename=str;
guidata(hObject,handles);
end

function handles=replot(app, hObject)

measure=handles.measure;
Nsweep=handles.Nsweep;
Nstep=handles.Nstep;

step2start=handles.current_step2_start;
step2stop=handles.current_step2_stop;
step2int=step2stop-step2start+1;

currentXlim=xlim(handles.axes1);                                            %getting the values of the axis limits
set(handles.X_MIN,'String',num2str(currentXlim(1)));
set(handles.X_MAX,'String',num2str(currentXlim(2)));
currentYlim=ylim(handles.axes1);
set(handles.Y_MIN,'String',num2str(currentYlim(1)));
set(handles.Y_MAX,'String',num2str(currentYlim(2)));

handles.current_Xmin=currentXlim(1);
handles.current_Xmax=currentXlim(2);
handles.current_Ymin=currentYlim(1);
handles.current_Ymax=currentYlim(2);

xmin=handles.current_Xmin;
xmax=handles.current_Xmax;
ymin=handles.current_Ymin;
ymax=handles.current_Ymax;

xth=handles.current_Xth;
time=handles.Timeaxis;
PostSel=handles.PostSel;

indxmin=1;
while time(indxmin+1)<=xmin && indxmin<Nsweep-1
indxmin=indxmin+1;
end
indxmax=Nsweep;
while time(indxmax-1)>xmax && indxmax>2
indxmax=indxmax-1;
end
indxth=1;
while time(indxth+1)<=xth && indxth<Nsweep-1
indxth=indxth+1;
end

indxinterval=indxmax-indxmin+1;

NbGood=sum(sum(PostSel(:,step2start:step2stop)));
NbBad=Nstep*step2int-NbGood;
GoodPlots=zeros(NbGood,indxinterval);
BadPlots=zeros(NbBad,indxinterval);
g=1;
b=1;
for k=step2start:step2stop
for j=1:Nstep
    if PostSel(j,k)
        GoodPlots(g,:)=measure(indxmin:indxmax,j,k);
        g=g+1;
    else
        BadPlots(b,:)=measure(indxmin:indxmax,j,k);
        b=b+1;
    end
    
end
end

cla(handles.axes1)
hold(handles.axes1,'on')
if NbGood>0
 handles.hgood=plot(handles.axes1,time(indxmin:indxmax),GoodPlots,'color',[0 0.6000 0]); % green for good curves
end
if NbBad>0
handles.hbad=plot(handles.axes1,time(indxmin:indxmax),BadPlots,'color',[0.8000 0 0]); % red for bad ones
end
handles.hslider=plot(handles.axes1,[time(indxth) time(indxth)],[ymin,ymax],'--','color','black','LineWidth',2);
guidata(hObject,handles);
end

    end
    
end

