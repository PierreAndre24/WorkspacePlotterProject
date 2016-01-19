function varargout = PostSel2_export(varargin)
% POSTSEL2_EXPORT MATLAB code for PostSel2_export.fig
%      POSTSEL2_EXPORT, by itself, creates a new POSTSEL2_EXPORT or raises the existing
%      singleton*.
%
%      H = POSTSEL2_EXPORT returns the handle to a new POSTSEL2_EXPORT or the handle to
%      the existing singleton*.
%
%      POSTSEL2_EXPORT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in POSTSEL2_EXPORT.M with the given input arguments.
%
%      POSTSEL2_EXPORT('Property','Value',...) creates a new POSTSEL2_EXPORT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before PostSel2_export_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to PostSel2_export_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help PostSel2_export

% Last Modified by GUIDE v2.5 03-Dec-2013 15:48:39

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @PostSel2_export_OpeningFcn, ...
                   'gui_OutputFcn',  @PostSel2_export_OutputFcn, ...
                   'gui_LayoutFcn',  @PostSel2_export_LayoutFcn, ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before PostSel2_export is made visible.
function PostSel2_export_OpeningFcn(hObject, eventdata, handles, varargin)


% Choose default command line output for PostSel2_export
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes PostSel2_export wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = PostSel2_export_OutputFcn(hObject, eventdata, handles) 

varargout{1} = handles.output;








% --- Executes on button press in LOAD.
function LOAD_Callback(hObject, eventdata, handles)

cla(handles.axes1)

% IMPORTING DATA FILE
[filename,pathname] = uigetfile('*.mat','Please select the file to open');
if filename==0
   return
end
handles.measure = load([pathname filename]);
filename=filename(1:end-4);                                                 %
handles.measure = handles.measure.(filename);                               % changing from structure to variable



handles.measure = handles.measure(:,:,:,1);


[handles.Nsweep, handles.Nstep, handles.Nstep2] = size(handles.measure);
size(handles.measure)
string_ind=1;
while filename(string_ind)~='_' && string_ind~=size(filename,2)             % getting only the file number (if it is after _)
string_ind=string_ind+1;
filenumber=filename(string_ind+1:end);
end
set(handles.FILENAME,'string',filenumber);
handles.current_filename=filenumber;

% IMPORTING TIME AXIS VALUES
if evalin('base','exist(''Y'',''var'')')==1
    handles.Timeaxis=evalin('base','Y');  
else
    filename = uigetfile([filename '.lvm'], 'Please select the file to use to import Time axis values');
    handles.Timeaxis=Sweepvalues(filename);
    assignin('base','Y',handles.Timeaxis);
end


% SETTING STEP2 STRINGS
Step2String=1:handles.Nstep2;
set(handles.STEP2_START,'string', Step2String);
set(handles.STEP2_START,'Value', 1);
handles.current_step2_start = 1;
set(handles.STEP2_STOP,'string', Step2String);
if handles.Nstep2>100
  set(handles.STEP2_STOP,'Value', 101);
  handles.current_step2_stop = 101;
else
  set(handles.STEP2_STOP,'Value', 1);
  handles.current_step2_stop = 1;
end

%SETTING GRAPH WINDOW
handles.current_Xmin=handles.Timeaxis(1);
% handles.current_Xmax=handles.Timeaxis(handles.Nsweep);
handles.current_Xmax=handles.Timeaxis(15);
handles.current_Ymin=0;
handles.current_Ymax=max(max(max(handles.measure)));
initXth=6;
handles.current_Xth=handles.Timeaxis(initXth);
set(handles.X_MIN,'string', handles.current_Xmin);
set(handles.X_MAX,'string', handles.current_Xmax);
set(handles.Y_MIN,'string', handles.current_Ymin);
set(handles.Y_MAX,'string', handles.current_Ymax);
set(handles.axes1,'xlim',[handles.current_Xmin handles.current_Xmax]);
set(handles.axes1,'ylim',[handles.current_Ymin handles.current_Ymax]);

set(handles.SLIDER_Xth,'Min',1);
set(handles.SLIDER_Xth,'Max',handles.Nsweep);
set(handles.SLIDER_Xth,'Value',initXth);
set(handles.SLIDER_Xth,'SliderStep',[1/(handles.Nsweep-1) 20/(handles.Nsweep-1)]);
set(handles.X_TH,'string', handles.Timeaxis(initXth));

handles.hslider=[];
handles.hgood=[];
handles.hgood=[];

handles.PostSel=zeros(handles.Nstep,handles.Nstep2);
handles.minth=0;
handles.maxth=0;
handles.indxth=initXth;


guidata(hObject, handles);
handles=replot(hObject,handles);
guidata(hObject, handles);






function X_MIN_Callback(hObject, eventdata, handles)

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

% --- Executes during object creation, after setting all properties.
function X_MIN_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function X_MAX_Callback(hObject, eventdata, handles)

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

% --- Executes during object creation, after setting all properties.
function X_MAX_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Y_MIN_Callback(hObject, eventdata, handles)

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

% --- Executes during object creation, after setting all properties.
function Y_MIN_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Y_MAX_Callback(hObject, eventdata, handles)

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

% --- Executes during object creation, after setting all properties.
function Y_MAX_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function X_TH_Callback(hObject, eventdata, handles)

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

% --- Executes during object creation, after setting all properties.
function X_TH_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on slider movement.
function SLIDER_Xth_Callback(hObject, eventdata, handles)

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

% --- Executes during object creation, after setting all properties.
function SLIDER_Xth_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end






% --- Executes on selection change in STEP2_START.
function STEP2_START_Callback(hObject, eventdata, handles)

val=get(hObject,'Value');
handles.current_step2_start = val;
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function STEP2_START_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in STEP2_STOP.
function STEP2_STOP_Callback(hObject, eventdata, handles)

val=get(hObject,'Value');
handles.current_step2_stop = val;
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function STEP2_STOP_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in PREVIOUS.
function PREVIOUS_Callback(hObject, eventdata, handles)

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

% --- Executes on button press in NEXT.
function NEXT_Callback(hObject, eventdata, handles)

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




% --- Executes on button press in SET_THRESHOLDS.
function SET_THRESHOLDS_Callback(hObject, eventdata, handles)

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






% --- Executes on button press in REFRESH.
function REFRESH_Callback(hObject, eventdata, handles)

handles=replot(hObject,handles);
guidata(hObject, handles);  



% --- Executes on button press in EXPORT.
function EXPORT_Callback(hObject, eventdata, handles)

assignin('base',['PostSel_' handles.current_filename],handles.PostSel);
set(handles.FILENAME,'string', 'enter filename');
handles.current_Filename='no_name';
guidata(hObject,handles);


function FILENAME_Callback(hObject, eventdata, handles)

str=get(hObject,'String');
handles.current_filename=str;
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function FILENAME_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end







function handles=replot(hObject,handles)

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



% --- Creates and returns a handle to the GUI figure. 
function h1 = PostSel2_export_LayoutFcn(policy)
% policy - create a new figure or use a singleton. 'new' or 'reuse'.

persistent hsingleton;
if strcmpi(policy, 'reuse') & ishandle(hsingleton)
    h1 = hsingleton;
    return;
end

appdata = [];
appdata.GUIDEOptions = struct(...
    'active_h', [], ...
    'taginfo', struct(...
    'figure', [], ...
    'axes', [], ...
    'edit', 7, ...
    'slider', [], ...
    'pushbutton', 8, ...
    'listbox', [], ...
    'togglebutton', [], ...
    'popupmenu', 3), ...
    'override', 0, ...
    'release', 13, ...
    'resize', 'none', ...
    'accessibility', 'callback', ...
    'mfile', [], ...
    'callbacks', [], ...
    'singleton', [], ...
    'syscolorfig', [], ...
    'blocking', 0, ...
    'lastSavedFile', 'C:\Users\benoit.bertrand\Documents\MATLAB\GUI CODES\begining_OOP\Class_def\PostSel2_export.m', ...
    'lastFilename', 'C:\Users\benoit.bertrand\Documents\MATLAB\GUI CODES\PostSel2\PostSel2.fig');
appdata.lastValidTag = 'figure1';
appdata.GUIDELayoutEditor = [];
appdata.initTags = struct(...
    'handle', [], ...
    'tag', 'figure1');

h1 = figure(...
'Units','characters',...
'PaperUnits',get(0,'defaultfigurePaperUnits'),...
'Color',[0.941176470588235 0.941176470588235 0.941176470588235],...
'Colormap',[0 0 0.5625;0 0 0.625;0 0 0.6875;0 0 0.75;0 0 0.8125;0 0 0.875;0 0 0.9375;0 0 1;0 0.0625 1;0 0.125 1;0 0.1875 1;0 0.25 1;0 0.3125 1;0 0.375 1;0 0.4375 1;0 0.5 1;0 0.5625 1;0 0.625 1;0 0.6875 1;0 0.75 1;0 0.8125 1;0 0.875 1;0 0.9375 1;0 1 1;0.0625 1 1;0.125 1 0.9375;0.1875 1 0.875;0.25 1 0.8125;0.3125 1 0.75;0.375 1 0.6875;0.4375 1 0.625;0.5 1 0.5625;0.5625 1 0.5;0.625 1 0.4375;0.6875 1 0.375;0.75 1 0.3125;0.8125 1 0.25;0.875 1 0.1875;0.9375 1 0.125;1 1 0.0625;1 1 0;1 0.9375 0;1 0.875 0;1 0.8125 0;1 0.75 0;1 0.6875 0;1 0.625 0;1 0.5625 0;1 0.5 0;1 0.4375 0;1 0.375 0;1 0.3125 0;1 0.25 0;1 0.1875 0;1 0.125 0;1 0.0625 0;1 0 0;0.9375 0 0;0.875 0 0;0.8125 0 0;0.75 0 0;0.6875 0 0;0.625 0 0;0.5625 0 0],...
'IntegerHandle','off',...
'InvertHardcopy',get(0,'defaultfigureInvertHardcopy'),...
'MenuBar','none',...
'Name','PostSel2',...
'NumberTitle','off',...
'PaperPosition',get(0,'defaultfigurePaperPosition'),...
'PaperSize',get(0,'defaultfigurePaperSize'),...
'PaperType',get(0,'defaultfigurePaperType'),...
'Position',[103.8 -15.1538461538462 229.6 77],...
'Resize','off',...
'WindowStyle',get(0,'defaultfigureWindowStyle'),...
'HandleVisibility','callback',...
'UserData',[],...
'Tag','figure1',...
'Visible','on',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'axes1';

h2 = axes(...
'Parent',h1,...
'Units','characters',...
'Position',[19.8 15.3076923076923 140.2 57.7692307692308],...
'CameraPosition',[0.5 0.5 9.16025403784439],...
'CameraPositionMode',get(0,'defaultaxesCameraPositionMode'),...
'Color',get(0,'defaultaxesColor'),...
'ColorOrder',get(0,'defaultaxesColorOrder'),...
'LooseInset',[29.848 8.47 21.812 5.775],...
'XColor',get(0,'defaultaxesXColor'),...
'YColor',get(0,'defaultaxesYColor'),...
'ZColor',get(0,'defaultaxesZColor'),...
'Tag','axes1',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

h3 = get(h2,'title');

set(h3,...
'Parent',h2,...
'Units','data',...
'FontUnits','points',...
'BackgroundColor','none',...
'Color',[0 0 0],...
'DisplayName',blanks(0),...
'EdgeColor','none',...
'EraseMode','normal',...
'DVIMode','auto',...
'FontAngle','normal',...
'FontName','Helvetica',...
'FontSize',[],...
'FontWeight','normal',...
'HorizontalAlignment','center',...
'LineStyle','-',...
'LineWidth',0.5,...
'Margin',[],...
'Position',[0.5 1.008655126498 1.00005459937205],...
'Rotation',0,...
'String',blanks(0),...
'Interpreter','tex',...
'VerticalAlignment','bottom',...
'ButtonDownFcn',[],...
'CreateFcn', {@local_CreateFcn, [], ''} ,...
'DeleteFcn',[],...
'BusyAction','queue',...
'HandleVisibility','off',...
'HelpTopicKey',blanks(0),...
'HitTest','on',...
'Interruptible','on',...
'SelectionHighlight','on',...
'Serializable','on',...
'Tag',blanks(0),...
'UserData',[],...
'Visible','on',...
'XLimInclude','on',...
'YLimInclude','on',...
'ZLimInclude','on',...
'CLimInclude','on',...
'ALimInclude','on',...
'IncludeRenderer','on',...
'Clipping','off');

h4 = get(h2,'xlabel');

set(h4,...
'Parent',h2,...
'Units','data',...
'FontUnits','points',...
'BackgroundColor','none',...
'Color',[0 0 0],...
'DisplayName',blanks(0),...
'EdgeColor','none',...
'EraseMode','normal',...
'DVIMode','auto',...
'FontAngle','normal',...
'FontName','Helvetica',...
'FontSize',[],...
'FontWeight','normal',...
'HorizontalAlignment','center',...
'LineStyle','-',...
'LineWidth',0.5,...
'Margin',[],...
'Position',[0.498573466476462 -0.0312916111850865 1.00005459937205],...
'Rotation',0,...
'String',blanks(0),...
'Interpreter','tex',...
'VerticalAlignment','cap',...
'ButtonDownFcn',[],...
'CreateFcn', {@local_CreateFcn, [], ''} ,...
'DeleteFcn',[],...
'BusyAction','queue',...
'HandleVisibility','off',...
'HelpTopicKey',blanks(0),...
'HitTest','on',...
'Interruptible','on',...
'SelectionHighlight','on',...
'Serializable','on',...
'Tag',blanks(0),...
'UserData',[],...
'Visible','on',...
'XLimInclude','on',...
'YLimInclude','on',...
'ZLimInclude','on',...
'CLimInclude','on',...
'ALimInclude','on',...
'IncludeRenderer','on',...
'Clipping','off');

h5 = get(h2,'ylabel');

set(h5,...
'Parent',h2,...
'Units','data',...
'FontUnits','points',...
'BackgroundColor','none',...
'Color',[0 0 0],...
'DisplayName',blanks(0),...
'EdgeColor','none',...
'EraseMode','normal',...
'DVIMode','auto',...
'FontAngle','normal',...
'FontName','Helvetica',...
'FontSize',[],...
'FontWeight','normal',...
'HorizontalAlignment','center',...
'LineStyle','-',...
'LineWidth',0.5,...
'Margin',[],...
'Position',[-0.0406562054208274 0.49866844207723 1.00005459937205],...
'Rotation',90,...
'String',blanks(0),...
'Interpreter','tex',...
'VerticalAlignment','bottom',...
'ButtonDownFcn',[],...
'CreateFcn', {@local_CreateFcn, [], ''} ,...
'DeleteFcn',[],...
'BusyAction','queue',...
'HandleVisibility','off',...
'HelpTopicKey',blanks(0),...
'HitTest','on',...
'Interruptible','on',...
'SelectionHighlight','on',...
'Serializable','on',...
'Tag',blanks(0),...
'UserData',[],...
'Visible','on',...
'XLimInclude','on',...
'YLimInclude','on',...
'ZLimInclude','on',...
'CLimInclude','on',...
'ALimInclude','on',...
'IncludeRenderer','on',...
'Clipping','off');

h6 = get(h2,'zlabel');

set(h6,...
'Parent',h2,...
'Units','data',...
'FontUnits','points',...
'BackgroundColor','none',...
'Color',[0 0 0],...
'DisplayName',blanks(0),...
'EdgeColor','none',...
'EraseMode','normal',...
'DVIMode','auto',...
'FontAngle','normal',...
'FontName','Helvetica',...
'FontSize',[],...
'FontWeight','normal',...
'HorizontalAlignment','right',...
'LineStyle','-',...
'LineWidth',0.5,...
'Margin',[],...
'Position',[-0.141940085592011 1.0659121171771 1.00005459937205],...
'Rotation',0,...
'String',blanks(0),...
'Interpreter','tex',...
'VerticalAlignment','middle',...
'ButtonDownFcn',[],...
'CreateFcn', {@local_CreateFcn, [], ''} ,...
'DeleteFcn',[],...
'BusyAction','queue',...
'HandleVisibility','off',...
'HelpTopicKey',blanks(0),...
'HitTest','on',...
'Interruptible','on',...
'SelectionHighlight','on',...
'Serializable','on',...
'Tag',blanks(0),...
'UserData',[],...
'Visible','off',...
'XLimInclude','on',...
'YLimInclude','on',...
'ZLimInclude','on',...
'CLimInclude','on',...
'ALimInclude','on',...
'IncludeRenderer','on',...
'Clipping','off');

appdata = [];
appdata.lastValidTag = 'Y_MAX';

h7 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[],...
'Callback',@(hObject,eventdata)PostSel2_export('Y_MAX_Callback',hObject,eventdata,guidata(hObject)),...
'Position',[1 71.3846153846154 10.2 1.69230769230769],...
'String','Y MAX',...
'Style','edit',...
'CreateFcn', {@local_CreateFcn, @(hObject,eventdata)PostSel2_export('Y_MAX_CreateFcn',hObject,eventdata,guidata(hObject)), appdata} ,...
'Tag','Y_MAX');

appdata = [];
appdata.lastValidTag = 'Y_MIN';

h8 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[],...
'Callback',@(hObject,eventdata)PostSel2_export('Y_MIN_Callback',hObject,eventdata,guidata(hObject)),...
'Position',[1 13.6923076923077 10.2 1.69230769230769],...
'String','Y MIN',...
'Style','edit',...
'CreateFcn', {@local_CreateFcn, @(hObject,eventdata)PostSel2_export('Y_MIN_CreateFcn',hObject,eventdata,guidata(hObject)), appdata} ,...
'Tag','Y_MIN');

appdata = [];
appdata.lastValidTag = 'X_MIN';

h9 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[],...
'Callback',@(hObject,eventdata)PostSel2_export('X_MIN_Callback',hObject,eventdata,guidata(hObject)),...
'Position',[19.8 7.69230769230769 10.2 1.69230769230769],...
'String','X MIN',...
'Style','edit',...
'CreateFcn', {@local_CreateFcn, @(hObject,eventdata)PostSel2_export('X_MIN_CreateFcn',hObject,eventdata,guidata(hObject)), appdata} ,...
'Tag','X_MIN');

appdata = [];
appdata.lastValidTag = 'X_MAX';

h10 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[],...
'Callback',@(hObject,eventdata)PostSel2_export('X_MAX_Callback',hObject,eventdata,guidata(hObject)),...
'Position',[149.8 7.69230769230769 10.2 1.69230769230769],...
'String','X MAX',...
'Style','edit',...
'CreateFcn', {@local_CreateFcn, @(hObject,eventdata)PostSel2_export('X_MAX_CreateFcn',hObject,eventdata,guidata(hObject)), appdata} ,...
'Tag','X_MAX');

appdata = [];
appdata.lastValidTag = 'SLIDER_Xth';

h11 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[0.9 0.9 0.9],...
'Callback',@(hObject,eventdata)PostSel2_export('SLIDER_Xth_Callback',hObject,eventdata,guidata(hObject)),...
'Position',[16.8 3.76923076923077 146.6 1.53846153846154],...
'String','Xth',...
'Style','slider',...
'CreateFcn', {@local_CreateFcn, @(hObject,eventdata)PostSel2_export('SLIDER_Xth_CreateFcn',hObject,eventdata,guidata(hObject)), appdata} ,...
'Tag','SLIDER_Xth');

appdata = [];
appdata.lastValidTag = 'LOAD';

h12 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'Callback',@(hObject,eventdata)PostSel2_export('LOAD_Callback',hObject,eventdata,guidata(hObject)),...
'Position',[184.8 62.1538461538462 20.2 3.23076923076923],...
'String','LOAD',...
'Tag','LOAD',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'STEP2_START';

h13 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[],...
'Callback',@(hObject,eventdata)PostSel2_export('STEP2_START_Callback',hObject,eventdata,guidata(hObject)),...
'Position',[186.4 53.7692307692308 17 2.38461538461538],...
'String','STEP2 START',...
'Style','popupmenu',...
'Value',[],...
'CreateFcn', {@local_CreateFcn, @(hObject,eventdata)PostSel2_export('STEP2_START_CreateFcn',hObject,eventdata,guidata(hObject)), appdata} ,...
'Tag','STEP2_START');

appdata = [];
appdata.lastValidTag = 'STEP2_STOP';

h14 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[],...
'Callback',@(hObject,eventdata)PostSel2_export('STEP2_STOP_Callback',hObject,eventdata,guidata(hObject)),...
'Position',[186.4 47.6153846153846 17 2.38461538461538],...
'String','STEP2 STOP',...
'Style','popupmenu',...
'Value',[],...
'CreateFcn', {@local_CreateFcn, @(hObject,eventdata)PostSel2_export('STEP2_STOP_CreateFcn',hObject,eventdata,guidata(hObject)), appdata} ,...
'Tag','STEP2_STOP');

appdata = [];
appdata.lastValidTag = 'PREVIOUS';

h15 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'Callback',@(hObject,eventdata)PostSel2_export('PREVIOUS_Callback',hObject,eventdata,guidata(hObject)),...
'Position',[166.400000000001 51.0769230769231 17 2.46153846153846],...
'String','PREVIOUS',...
'Tag','PREVIOUS',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'NEXT';

h16 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'Callback',@(hObject,eventdata)PostSel2_export('NEXT_Callback',hObject,eventdata,guidata(hObject)),...
'Position',[206.4 51.0769230769231 17 2.46153846153846],...
'String','NEXT',...
'Tag','NEXT',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'REFRESH';

h17 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'Callback',@(hObject,eventdata)PostSel2_export('REFRESH_Callback',hObject,eventdata,guidata(hObject)),...
'Position',[187.6 43.6923076923077 14.6 2.46153846153846],...
'String','REFRESH',...
'Tag','REFRESH',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'SET_THRESHOLDS';

h18 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'Callback',@(hObject,eventdata)PostSel2_export('SET_THRESHOLDS_Callback',hObject,eventdata,guidata(hObject)),...
'Position',[184.8 34.6153846153846 20.2 3.23076923076923],...
'String','SET THRESHOLDS',...
'Tag','SET_THRESHOLDS',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'EXPORT';

h19 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'Callback',@(hObject,eventdata)PostSel2_export('EXPORT_Callback',hObject,eventdata,guidata(hObject)),...
'Position',[179.8 19.2307692307692 30.2 2.46153846153846],...
'String','EXPORT TO WORKSPACE',...
'Tag','EXPORT',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'FILENAME';

h20 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[],...
'Callback',@(hObject,eventdata)PostSel2_export('FILENAME_Callback',hObject,eventdata,guidata(hObject)),...
'Position',[182 15.3076923076923 25.8 2.38461538461538],...
'String','enter filename',...
'Style','edit',...
'CreateFcn', {@local_CreateFcn, @(hObject,eventdata)PostSel2_export('FILENAME_CreateFcn',hObject,eventdata,guidata(hObject)), appdata} ,...
'Tag','FILENAME');

appdata = [];
appdata.lastValidTag = 'X_TH';

h21 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[],...
'Callback',@(hObject,eventdata)PostSel2_export('X_TH_Callback',hObject,eventdata,guidata(hObject)),...
'Position',[164.4 3.84615384615385 10.2 1.69230769230769],...
'String','X_TH',...
'Style','edit',...
'CreateFcn', {@local_CreateFcn, @(hObject,eventdata)PostSel2_export('X_TH_CreateFcn',hObject,eventdata,guidata(hObject)), appdata} ,...
'Tag','X_TH');


hsingleton = h1;


% --- Set application data first then calling the CreateFcn. 
function local_CreateFcn(hObject, eventdata, createfcn, appdata)

if ~isempty(appdata)
   names = fieldnames(appdata);
   for i=1:length(names)
       name = char(names(i));
       setappdata(hObject, name, getfield(appdata,name));
   end
end

if ~isempty(createfcn)
   if isa(createfcn,'function_handle')
       createfcn(hObject, eventdata);
   else
       eval(createfcn);
   end
end


% --- Handles default GUIDE GUI creation and callback dispatch
function varargout = gui_mainfcn(gui_State, varargin)

gui_StateFields =  {'gui_Name'
    'gui_Singleton'
    'gui_OpeningFcn'
    'gui_OutputFcn'
    'gui_LayoutFcn'
    'gui_Callback'};
gui_Mfile = '';
for i=1:length(gui_StateFields)
    if ~isfield(gui_State, gui_StateFields{i})
        error(message('MATLAB:guide:StateFieldNotFound', gui_StateFields{ i }, gui_Mfile));
    elseif isequal(gui_StateFields{i}, 'gui_Name')
        gui_Mfile = [gui_State.(gui_StateFields{i}), '.m'];
    end
end

numargin = length(varargin);

if numargin == 0
    % POSTSEL2_EXPORT
    % create the GUI only if we are not in the process of loading it
    % already
    gui_Create = true;
elseif local_isInvokeActiveXCallback(gui_State, varargin{:})
    % POSTSEL2_EXPORT(ACTIVEX,...)
    vin{1} = gui_State.gui_Name;
    vin{2} = [get(varargin{1}.Peer, 'Tag'), '_', varargin{end}];
    vin{3} = varargin{1};
    vin{4} = varargin{end-1};
    vin{5} = guidata(varargin{1}.Peer);
    feval(vin{:});
    return;
elseif local_isInvokeHGCallback(gui_State, varargin{:})
    % POSTSEL2_EXPORT('CALLBACK',hObject,eventData,handles,...)
    gui_Create = false;
else
    % POSTSEL2_EXPORT(...)
    % create the GUI and hand varargin to the openingfcn
    gui_Create = true;
end

if ~gui_Create
    % In design time, we need to mark all components possibly created in
    % the coming callback evaluation as non-serializable. This way, they
    % will not be brought into GUIDE and not be saved in the figure file
    % when running/saving the GUI from GUIDE.
    designEval = false;
    if (numargin>1 && ishghandle(varargin{2}))
        fig = varargin{2};
        while ~isempty(fig) && ~ishghandle(fig,'figure')
            fig = get(fig,'parent');
        end
        
        designEval = isappdata(0,'CreatingGUIDEFigure') || isprop(fig,'__GUIDEFigure');
    end
        
    if designEval
        beforeChildren = findall(fig);
    end
    
    % evaluate the callback now
    varargin{1} = gui_State.gui_Callback;
    if nargout
        [varargout{1:nargout}] = feval(varargin{:});
    else       
        feval(varargin{:});
    end
    
    % Set serializable of objects created in the above callback to off in
    % design time. Need to check whether figure handle is still valid in
    % case the figure is deleted during the callback dispatching.
    if designEval && ishghandle(fig)
        set(setdiff(findall(fig),beforeChildren), 'Serializable','off');
    end
else
    if gui_State.gui_Singleton
        gui_SingletonOpt = 'reuse';
    else
        gui_SingletonOpt = 'new';
    end

    % Check user passing 'visible' P/V pair first so that its value can be
    % used by oepnfig to prevent flickering
    gui_Visible = 'auto';
    gui_VisibleInput = '';
    for index=1:2:length(varargin)
        if length(varargin) == index || ~ischar(varargin{index})
            break;
        end

        % Recognize 'visible' P/V pair
        len1 = min(length('visible'),length(varargin{index}));
        len2 = min(length('off'),length(varargin{index+1}));
        if ischar(varargin{index+1}) && strncmpi(varargin{index},'visible',len1) && len2 > 1
            if strncmpi(varargin{index+1},'off',len2)
                gui_Visible = 'invisible';
                gui_VisibleInput = 'off';
            elseif strncmpi(varargin{index+1},'on',len2)
                gui_Visible = 'visible';
                gui_VisibleInput = 'on';
            end
        end
    end
    
    % Open fig file with stored settings.  Note: This executes all component
    % specific CreateFunctions with an empty HANDLES structure.

    
    % Do feval on layout code in m-file if it exists
    gui_Exported = ~isempty(gui_State.gui_LayoutFcn);
    % this application data is used to indicate the running mode of a GUIDE
    % GUI to distinguish it from the design mode of the GUI in GUIDE. it is
    % only used by actxproxy at this time.   
    setappdata(0,genvarname(['OpenGuiWhenRunning_', gui_State.gui_Name]),1);
    if gui_Exported
        gui_hFigure = feval(gui_State.gui_LayoutFcn, gui_SingletonOpt);

        % make figure invisible here so that the visibility of figure is
        % consistent in OpeningFcn in the exported GUI case
        if isempty(gui_VisibleInput)
            gui_VisibleInput = get(gui_hFigure,'Visible');
        end
        set(gui_hFigure,'Visible','off')

        % openfig (called by local_openfig below) does this for guis without
        % the LayoutFcn. Be sure to do it here so guis show up on screen.
        movegui(gui_hFigure,'onscreen');
    else
        gui_hFigure = local_openfig(gui_State.gui_Name, gui_SingletonOpt, gui_Visible);
        % If the figure has InGUIInitialization it was not completely created
        % on the last pass.  Delete this handle and try again.
        if isappdata(gui_hFigure, 'InGUIInitialization')
            delete(gui_hFigure);
            gui_hFigure = local_openfig(gui_State.gui_Name, gui_SingletonOpt, gui_Visible);
        end
    end
    if isappdata(0, genvarname(['OpenGuiWhenRunning_', gui_State.gui_Name]))
        rmappdata(0,genvarname(['OpenGuiWhenRunning_', gui_State.gui_Name]));
    end

    % Set flag to indicate starting GUI initialization
    setappdata(gui_hFigure,'InGUIInitialization',1);

    % Fetch GUIDE Application options
    gui_Options = getappdata(gui_hFigure,'GUIDEOptions');
    % Singleton setting in the GUI M-file takes priority if different
    gui_Options.singleton = gui_State.gui_Singleton;

    if ~isappdata(gui_hFigure,'GUIOnScreen')
        % Adjust background color
        if gui_Options.syscolorfig
            set(gui_hFigure,'Color', get(0,'DefaultUicontrolBackgroundColor'));
        end

        % Generate HANDLES structure and store with GUIDATA. If there is
        % user set GUI data already, keep that also.
        data = guidata(gui_hFigure);
        handles = guihandles(gui_hFigure);
        if ~isempty(handles)
            if isempty(data)
                data = handles;
            else
                names = fieldnames(handles);
                for k=1:length(names)
                    data.(char(names(k)))=handles.(char(names(k)));
                end
            end
        end
        guidata(gui_hFigure, data);
    end

    % Apply input P/V pairs other than 'visible'
    for index=1:2:length(varargin)
        if length(varargin) == index || ~ischar(varargin{index})
            break;
        end

        len1 = min(length('visible'),length(varargin{index}));
        if ~strncmpi(varargin{index},'visible',len1)
            try set(gui_hFigure, varargin{index}, varargin{index+1}), catch break, end
        end
    end

    % If handle visibility is set to 'callback', turn it on until finished
    % with OpeningFcn
    gui_HandleVisibility = get(gui_hFigure,'HandleVisibility');
    if strcmp(gui_HandleVisibility, 'callback')
        set(gui_hFigure,'HandleVisibility', 'on');
    end

    feval(gui_State.gui_OpeningFcn, gui_hFigure, [], guidata(gui_hFigure), varargin{:});

    if isscalar(gui_hFigure) && ishghandle(gui_hFigure)
        % Handle the default callbacks of predefined toolbar tools in this
        % GUI, if any
        guidemfile('restoreToolbarToolPredefinedCallback',gui_hFigure); 
        
        % Update handle visibility
        set(gui_hFigure,'HandleVisibility', gui_HandleVisibility);

        % Call openfig again to pick up the saved visibility or apply the
        % one passed in from the P/V pairs
        if ~gui_Exported
            gui_hFigure = local_openfig(gui_State.gui_Name, 'reuse',gui_Visible);
        elseif ~isempty(gui_VisibleInput)
            set(gui_hFigure,'Visible',gui_VisibleInput);
        end
        if strcmpi(get(gui_hFigure, 'Visible'), 'on')
            figure(gui_hFigure);
            
            if gui_Options.singleton
                setappdata(gui_hFigure,'GUIOnScreen', 1);
            end
        end

        % Done with GUI initialization
        if isappdata(gui_hFigure,'InGUIInitialization')
            rmappdata(gui_hFigure,'InGUIInitialization');
        end

        % If handle visibility is set to 'callback', turn it on until
        % finished with OutputFcn
        gui_HandleVisibility = get(gui_hFigure,'HandleVisibility');
        if strcmp(gui_HandleVisibility, 'callback')
            set(gui_hFigure,'HandleVisibility', 'on');
        end
        gui_Handles = guidata(gui_hFigure);
    else
        gui_Handles = [];
    end

    if nargout
        [varargout{1:nargout}] = feval(gui_State.gui_OutputFcn, gui_hFigure, [], gui_Handles);
    else
        feval(gui_State.gui_OutputFcn, gui_hFigure, [], gui_Handles);
    end

    if isscalar(gui_hFigure) && ishghandle(gui_hFigure)
        set(gui_hFigure,'HandleVisibility', gui_HandleVisibility);
    end
end

function gui_hFigure = local_openfig(name, singleton, visible)

% openfig with three arguments was new from R13. Try to call that first, if
% failed, try the old openfig.
if nargin('openfig') == 2
    % OPENFIG did not accept 3rd input argument until R13,
    % toggle default figure visible to prevent the figure
    % from showing up too soon.
    gui_OldDefaultVisible = get(0,'defaultFigureVisible');
    set(0,'defaultFigureVisible','off');
    gui_hFigure = openfig(name, singleton);
    set(0,'defaultFigureVisible',gui_OldDefaultVisible);
else
    gui_hFigure = openfig(name, singleton, visible);  
    %workaround for CreateFcn not called to create ActiveX
    if feature('HGUsingMATLABClasses')
        peers=findobj(findall(allchild(gui_hFigure)),'type','uicontrol','style','text');    
        for i=1:length(peers)
            if isappdata(peers(i),'Control')
                actxproxy(peers(i));
            end            
        end
    end
end

function result = local_isInvokeActiveXCallback(gui_State, varargin)

try
    result = ispc && iscom(varargin{1}) ...
             && isequal(varargin{1},gcbo);
catch
    result = false;
end

function result = local_isInvokeHGCallback(gui_State, varargin)

try
    fhandle = functions(gui_State.gui_Callback);
    result = ~isempty(findstr(gui_State.gui_Name,fhandle.file)) || ...
             (ischar(varargin{1}) ...
             && isequal(ishghandle(varargin{2}), 1) ...
             && (~isempty(strfind(varargin{1},[get(varargin{2}, 'Tag'), '_'])) || ...
                ~isempty(strfind(varargin{1}, '_CreateFcn'))) );
catch
    result = false;
end


