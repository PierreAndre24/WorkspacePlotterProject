classdef WORKSPACE_PLOTTER_OOP < handle    
    %Graphical User Interface used to explore data returned by Sylvain's
    %LabView program.
    
    properties
        % data
        LOADED_SCAN_DATA
        % GUI handles
        FIGURE
        LOAD
        RELOAD
        PLOT_2D
        PLOT_1D
        AVERAGE
        ANALYSE
        SCAN_INFOS
        SAVE_MAT
        SWEEP_PARAM_TXT
        SWEEP_LABEL
        STEP_PARAM_TXT
        STEP_LABEL
        STEP2_PARAM_TXT
        STEP2_LABEL
        SWEEP_START_TXT
        SWEEP_START
        SWEEP_STOP_TXT
        SWEEP_STOP
        SWEEP_FULL_RANGE
        STEP_START_TXT
        STEP_START
        STEP_STOP_TXT
        STEP_STOP
        STEP_FULL_RANGE
        STEP2_TXT
        STEP2
        MEASURE_LINE_TXT
        MEASURE_LINE
        USING_RAWDATA
        USING_DERIVATIVE
        SMOOTH
        FFT_FILTER
        COUNTER_TO_TIME
        AUTO_SAVE
        MESSAGE_DISPLAY
        PANEL
        PERMUTE
        % figures & analyse objects
        plot2D
        plot1D
        plotAverage
        AnalyseOutput
        % variables
        current_directory
    end
    
    methods
        function app = WORKSPACE_PLOTTER_OOP()
        % This is the "constructor" for the class
        % It runs when an object of this class is created
        Background_Color=[0.871 0.922 0.98];
        Popup_Color=[1 1 1];
        
            app.FIGURE = figure('MenuBar'                  , 'none',...           % Main figure
                                'NumberTitle'              , 'off',...
                                'Name'                     , 'WORKSPACE PLOTTER',...
                                'Units'                    , 'normalized',...
                                'Position'                 , [0.25 0.4 0.52 0.22],...
                                'WindowStyle'              , 'normal',... 
                                'Color'                    , Background_Color,...
                                'IntegerHandle'            ,'off',...
                                'CloseRequestFcn'          ,@app.CLOSE_App);
                     
           app.LOAD = uicontrol('style'                    , 'pushbutton', ...
                                'string'                   , 'LOAD', ...
                                'callback'                 , @app.LOAD_Callback, ...
                                'enable'                   , 'on', ...
                                'parent'                   , app.FIGURE, ...
                                'Units'                    , 'normalized',...
                                'Position'                 , [0.04 0.76 0.08 0.11],...
                                'tag'                      , 'LOAD');
                   
           app.PLOT_2D = uicontrol('style'                 , 'pushbutton', ...
                                'string'                   , '2D PLOT', ...
                                'callback'                 , @app.PLOT_2D_Callback, ...
                                'enable'                   , 'on', ...
                                'parent'                   , app.FIGURE, ...
                                'Units'                    , 'normalized',...
                                'Position'                 , [0.145 0.76 0.08 0.11],...
                                'tag'                      , 'PLOT_2D');

           app.PLOT_1D = uicontrol('style'                 , 'pushbutton', ...
                                'string'                   , '1D PLOT', ...
                                'callback'                 , @app.PLOT_1D_Callback, ...
                                'enable'                   , 'on', ...
                                'parent'                   , app.FIGURE, ...
                                'Units'                    , 'normalized',...
                                'Position'                 , [0.25 0.76 0.08 0.11],...
                                'tag'                      , 'PLOT_1D');

           app.RELOAD = uicontrol('style'                  , 'pushbutton', ...
                                'string'                   , 'RELOAD', ...
                                'callback'                 , @app.RELOAD_Callback, ...
                                'enable'                   , 'on', ...
                                'parent'                   , app.FIGURE, ...
                                'Units'                    , 'normalized',...
                                'Position'                 , [0.04 0.55 0.08 0.11],...
                                'tag'                      , 'RELOAD');

           app.AVERAGE = uicontrol('style'                 , 'pushbutton', ...
                                'string'                   , 'AVERAGE', ...
                                'callback'                 , @app.AVERAGE_Callback, ...
                                'enable'                   , 'on', ...
                                'parent'                   , app.FIGURE, ...
                                'Units'                    , 'normalized',...
                                'Position'                 , [0.145 0.55 0.08 0.11],...
                                'tag'                      , 'AVERAGE');

           app.ANALYSE = uicontrol('style'                 , 'pushbutton', ...
                                'string'                   , 'ANALYSE', ...
                                'callback'                 , @app.ANALYSE_Callback, ...
                                'enable'                   , 'on', ...
                                'parent'                   , app.FIGURE, ...
                                'Units'                    , 'normalized',...
                                'Position'                 , [0.25 0.55 0.08 0.11],...
                                'tag'                      , 'ANALYSE');
           
           app.SWEEP_PARAM_TXT = uicontrol('style'          , 'text', ...
                                'foregroundcolor'           , 'black', ...
                                'backgroundcolor'           , Background_Color, ...
                                'horizontalalignment'       , 'center', ...
                                'fontweight'                , 'bold', ...
                                'string'                    , 'Sweep Param.', ...
                                'parent'                    , app.FIGURE, ...
                                'Units'                     , 'normalized',...
                                'Position'                  , [0.39 0.86 0.11 0.05],...
                                'tag'                       , 'SWEEP_PARAM_TXT');
                            
            app.SWEEP_LABEL = uicontrol('style'             , 'popupmenu', ...
                                'foregroundcolor'           , 'black', ... 
                                'backgroundcolor'           , Popup_Color, ...
                                'horizontalalignment'       , 'center', ...
                                'callback'                  , @app.SWEEP_LABEL_Callback, ...
                                'string'                    , 'SWEEP', ...
                                'parent'                    , app.FIGURE, ...
                                'Units'                     , 'normalized',...
                                'Position'                  , [0.39 0.78 0.11 0.08],...
                                'tag'                       , 'SWEEP_LABEL');
                            
           app.STEP_PARAM_TXT = uicontrol('style'           , 'text', ...
                                'foregroundcolor'           , 'black', ...
                                'backgroundcolor'           , Background_Color, ...
                                'horizontalalignment'       , 'center', ...
                                'fontweight'                , 'bold', ...
                                'string'                    , 'Step Param.', ...
                                'parent'                    , app.FIGURE, ...
                                'Units'                     , 'normalized',...
                                'Position'                  , [0.39 0.65 0.11 0.05],...
                                'tag'                       , 'SWEEP_PARAM_TXT');
                            
            app.STEP_LABEL = uicontrol('style'              , 'popupmenu', ...
                                'foregroundcolor'           , 'black', ... 
                                'backgroundcolor'           , Popup_Color, ...
                                'horizontalalignment'       , 'center', ...
                                'callback'                  , @app.STEP_LABEL_Callback, ...
                                'string'                    , 'STEP', ...
                                'parent'                    , app.FIGURE, ...
                                'Units'                     , 'normalized',...
                                'Position'                  , [0.39 0.57 0.11 0.08],...
                                'tag'                       , 'STEP_LABEL');
                            
           app.STEP2_PARAM_TXT = uicontrol('style'          , 'text', ...
                                'foregroundcolor'           , 'black', ...
                                'backgroundcolor'           , Background_Color, ...
                                'horizontalalignment'       , 'center', ...
                                'fontweight'                , 'bold', ...
                                'string'                    , 'Step2 Param.', ...
                                'parent'                    , app.FIGURE, ...
                                'Units'                     , 'normalized',...
                                'Position'                  , [0.39 0.46 0.11 0.05],...
                                'tag'                       , 'SWEEP_PARAM_TXT');
                            
            app.STEP2_LABEL = uicontrol('style'             , 'popupmenu', ...
                                'foregroundcolor'           , 'black', ... 
                                'backgroundcolor'           , Popup_Color, ...
                                'horizontalalignment'       , 'center', ...
                                'callback'                  , @app.STEP2_LABEL_Callback, ...
                                'string'                    , 'STEP2', ...
                                'parent'                    , app.FIGURE, ...
                                'Units'                     , 'normalized',...
                                'Position'                  , [0.39 0.38 0.11 0.08],...
                                'tag'                       , 'STEP2_LABEL');
                            
           app.SWEEP_START_TXT = uicontrol('style'          , 'text', ...
                                'foregroundcolor'           , 'black', ...
                                'backgroundcolor'           , Background_Color, ...
                                'horizontalalignment'       , 'center', ...
                                'fontweight'                , 'bold', ...
                                'string'                    , 'Sweep Start', ...
                                'parent'                    , app.FIGURE, ...
                                'Units'                     , 'normalized',...
                                'Position'                  , [0.535 0.86 0.12 0.05],...
                                'tag'                       , 'SWEEP_START_TXT');
                            
            app.SWEEP_START = uicontrol('style'             , 'popupmenu', ...
                                'foregroundcolor'           , 'black', ... 
                                'backgroundcolor'           , Popup_Color, ...
                                'horizontalalignment'       , 'center', ...
                                'string'                    , 'SWEEP START', ...
                                'parent'                    , app.FIGURE, ...
                                'Units'                     , 'normalized',...
                                'Position'                  , [0.535 0.78 0.12 0.08],...
                                'tag'                       , 'SWEEP_START');
                            
           app.SWEEP_STOP_TXT = uicontrol('style'           , 'text', ...
                                'foregroundcolor'           , 'black', ... 
                                'backgroundcolor'           , Background_Color, ...
                                'horizontalalignment'       , 'center', ...
                                'fontweight'                , 'bold', ...
                                'string'                    , 'Sweep Stop', ...
                                'parent'                    , app.FIGURE, ...
                                'Units'                     , 'normalized',...
                                'Position'                  , [0.535 0.65 0.12 0.05],...
                                'tag'                       , 'SWEEP_STOP_TXT');
                            
            app.SWEEP_STOP = uicontrol('style'              , 'popupmenu', ...
                                'foregroundcolor'           , 'black', ... 
                                'backgroundcolor'           , Popup_Color, ...
                                'horizontalalignment'       , 'center', ...
                                'string'                    , 'SWEEP STOP', ...
                                'parent'                    , app.FIGURE, ...
                                'Units'                     , 'normalized',...
                                'Position'                  , [0.535 0.57 0.12 0.08],...
                                'tag'                       , 'SWEEP_STOP');
                            
           app.SWEEP_FULL_RANGE = uicontrol('style'        , 'pushbutton', ...
                                'string'                   , '', ...
                                'callback'                 , @app.SWEEP_FULL_RANGE_Callback, ...
                                'enable'                   , 'on', ...
                                'parent'                   , app.FIGURE, ...
                                'Units'                    , 'normalized',...
                                'Position'                 , [0.58 0.44 0.025 0.09],...
                                'tag'                      , 'SWEEP_FULL_RANGE');

           app.STEP_START_TXT = uicontrol('style'           , 'text', ...
                                'foregroundcolor'           , 'black', ...
                                'backgroundcolor'           , Background_Color, ...
                                'horizontalalignment'       , 'center', ...
                                'fontweight'                , 'bold', ...
                                'string'                    , 'Step Start', ...
                                'parent'                    , app.FIGURE, ...
                                'Units'                     , 'normalized',...
                                'Position'                  , [0.69 0.86 0.12 0.05],...
                                'tag'                       , 'STEP_START_TXT');
                            
            app.STEP_START = uicontrol('style'              , 'popupmenu', ...
                                'foregroundcolor'           , 'black', ... 
                                'backgroundcolor'           , Popup_Color, ...
                                'horizontalalignment'       , 'center', ...
                                'string'                    , 'STEP START', ...
                                'parent'                    , app.FIGURE, ...
                                'Units'                     , 'normalized',...
                                'Position'                  , [0.69 0.78 0.12 0.08],...
                                'tag'                       , 'STEP_START');
                            
           app.STEP_STOP_TXT = uicontrol('style'            , 'text', ...
                                'foregroundcolor'           , 'black', ...
                                'backgroundcolor'           , Background_Color, ...
                                'horizontalalignment'       , 'center', ...
                                'fontweight'                , 'bold', ...
                                'string'                    , 'Step Stop', ...
                                'parent'                    , app.FIGURE, ...
                                'Units'                     , 'normalized',...
                                'Position'                  , [0.69 0.65 0.12 0.05],...
                                'tag'                       , 'STEP_STOP_TXT');
                            
            app.STEP_STOP = uicontrol('style'               , 'popupmenu', ...
                                'foregroundcolor'           , 'black', ... 
                                'backgroundcolor'           , Popup_Color, ...
                                'horizontalalignment'       , 'center', ...
                                'string'                    , 'STEP STOP', ...
                                'parent'                    , app.FIGURE, ...
                                'Units'                     , 'normalized',...
                                'Position'                  , [0.69 0.57 0.12 0.08],...
                                'tag'                       , 'STEP_STOP');
                            
           app.STEP_FULL_RANGE = uicontrol('style'                  , 'pushbutton', ...
                                'string'                   , '', ...
                                'callback'                 , @app.STEP_FULL_RANGE_Callback, ...
                                'enable'                   , 'on', ...
                                'parent'                   , app.FIGURE, ...
                                'Units'                    , 'normalized',...
                                'Position'                 , [0.735 0.44 0.025 0.09],...
                                'tag'                      , 'STEP_FULL_RANGE');
                            
           app.STEP2_TXT = uicontrol('style'                , 'text', ...
                                'foregroundcolor'           , 'black', ...
                                'backgroundcolor'           , Background_Color, ...
                                'horizontalalignment'       , 'center', ...
                                'fontweight'                , 'bold', ...
                                'string'                    , 'Step2', ...
                                'parent'                    , app.FIGURE, ...
                                'Units'                     , 'normalized',...
                                'Position'                  , [0.845 0.86 0.12 0.05],...
                                'tag'                       , 'STEP2_TXT');
                            
            app.STEP2 = uicontrol('style'                   , 'popupmenu', ...
                                'foregroundcolor'           , 'black', ... 
                                'backgroundcolor'           , Popup_Color, ...
                                'horizontalalignment'       , 'center', ...
                                'string'                    , 'STEP2', ...
                                'parent'                    , app.FIGURE, ...
                                'Units'                     , 'normalized',...
                                'Position'                  , [0.845 0.78 0.12 0.08],...
                                'tag'                       , 'STEP2');
                            
           app.MEASURE_LINE_TXT = uicontrol('style'         , 'text', ...
                                'foregroundcolor'           , 'black', ...
                                'backgroundcolor'           , Background_Color, ...
                                'horizontalalignment'       , 'center', ...
                                'fontweight'                , 'bold', ...
                                'string'                    , 'Measure Line', ...
                                'parent'                    , app.FIGURE, ...
                                'Units'                     , 'normalized',...
                                'Position'                  , [0.845 0.65 0.12 0.05],...
                                'tag'                       , 'MEASURE_LINE_TXT');
                            
            app.MEASURE_LINE = uicontrol('style'               , 'popupmenu', ...
                                'foregroundcolor'           , 'black', ... 
                                'backgroundcolor'           , Popup_Color, ...
                                'horizontalalignment'       , 'center', ...
                                'string'                    , 'MEASURE LINE', ...
                                'parent'                    , app.FIGURE, ...
                                'Units'                     , 'normalized',...
                                'Position'                  , [0.845 0.57 0.12 0.08],...
                                'tag'                       , 'MEASURE_LINE');
                            
           app.USING_RAWDATA = uicontrol('style'           , 'radiobutton', ...
                                'backgroundcolor'          , Background_Color, ...
                                'string'                   , 'Using Raw Data', ...
                                'fontweight'               , 'bold', ...
                                'callback'                 , @app.USING_RAWDATA_Callback, ...
                                'parent'                   , app.FIGURE, ...
                                'Units'                    , 'normalized',...
                                'Position'                 , [0.05 0.34 0.15 0.05],...
                                'tag'                      , 'USING_RAWDATA');
                            
           app.USING_DERIVATIVE = uicontrol('style'        , 'radiobutton', ...
                                'backgroundcolor'          , Background_Color, ...
                                'string'                   , 'Using Derivative', ...
                                'fontweight'               , 'bold', ...
                                'callback'                 , @app.USING_DERIVATIVE_Callback, ...
                                'parent'                   , app.FIGURE, ...
                                'Units'                    , 'normalized',...
                                'Position'                 , [0.05 0.245 0.15 0.05],...
                                'tag'                      , 'USING_DERIVATIVE');
                            
           app.SMOOTH = uicontrol('style'                  , 'checkbox', ...
                                'backgroundcolor'          , Background_Color, ...
                                'string'                   , 'Smooth', ...
                                'fontweight'               , 'bold', ...
                                'callback'                 , @app.SMOOTH_Callback, ...
                                'parent'                   , app.FIGURE, ...
                                'Units'                    , 'normalized',...
                                'Position'                 , [0.25 0.34 0.1 0.05],...
                                'tag'                      , 'SMOOTH');
                            
           app.FFT_FILTER = uicontrol('style'                , 'checkbox', ...
                                'backgroundcolor'          , Background_Color, ...
                                'string'                   , 'FFT Filter', ...
                                'fontweight'               , 'bold', ...
                                'callback'                 , @app.FFT_FILTER_Callback, ...
                                'parent'                   , app.FIGURE, ...
                                'Units'                    , 'normalized',...
                                'Position'                 , [0.25 0.245 0.1 0.05],...
                                'tag'                      , 'FFT_FILTER');
                            
           app.COUNTER_TO_TIME = uicontrol('style'         , 'checkbox', ...
                                'backgroundcolor'          , Background_Color, ...
                                'string'                   , 'Convert sweep counter to time', ...
                                'fontweight'               , 'bold', ...
                                'callback'                 , @app.COUNTER_TO_TIME_Callback, ...
                                'parent'                   , app.FIGURE, ...
                                'Units'                    , 'normalized',...
                                'Position'                 , [0.39 0.245 0.2 0.05],...
                                'tag'                      , 'COUNTER_TO_TIME');
                            
           app.AUTO_SAVE = uicontrol('style'                  , 'checkbox', ...
                                'backgroundcolor'          , Background_Color, ...
                                'string'                   , 'Auto Save', ...
                                'fontweight'               , 'bold', ...
                                'parent'                   , app.FIGURE, ...
                                'Units'                    , 'normalized',...
                                'Position'                 , [0.875 0.19 0.1 0.05],...
                                'tag'                      , 'AUTO_SAVE');
                            
           app.PERMUTE = uicontrol('style'                  , 'radiobutton', ...
                                'backgroundcolor'          , Background_Color, ...
                                'string'                   , 'Permute next', ...
                                'fontweight'               , 'bold', ...
                                'parent'                   , app.FIGURE, ...
                                'Units'                    , 'normalized',...
                                'Position'                 , [0.862 0.37 0.11 0.05],...
                                'tag'                      , 'PERMUTE');
                            
           app.SCAN_INFOS = uicontrol('style'              , 'pushbutton', ...
                                'string'                   , 'SCAN INFOS', ...
                                'callback'                 , @app.SCAN_INFOS_Callback, ...
                                'enable'                   , 'on', ...
                                'parent'                   , app.FIGURE, ...
                                'Units'                    , 'normalized',...
                                'Position'                 , [0.7 0.25 0.1 0.11],...
                                'tag'                      , 'SCAN_INFOS');

           app.SAVE_MAT = uicontrol('style'                , 'pushbutton', ...
                                'string'                   , 'SAVE TO .MAT', ...
                                'callback'                 , @app.SAVE_MAT_Callback, ...
                                'enable'                   , 'on', ...
                                'parent'                   , app.FIGURE, ...
                                'Units'                    , 'normalized',...
                                'Position'                 , [0.865 0.25 0.1 0.11],...
                                'tag'                      , 'SAVE_MAT');
              
           app.PANEL = uipanel('Units'                      , 'normalized',...
                                'Position'                  ,[0.04 0.07 0.925 0.1]);
         
           app.MESSAGE_DISPLAY = uicontrol('style'          , 'text', ...
                                'foregroundcolor'           , 'black', ...
                                'backgroundcolor'           , [0.988 0.914 0.792], ...
                                'horizontalalignment'       , 'center', ...
                                'fontsize'                  , 11, ...
                                'string'                    , 'Message display', ...
                                'parent'                    , app.FIGURE, ...
                                'Units'                     , 'normalized',...
                                'Position'                  , [0.0425 0.075 0.92 0.09],...
                                'tag'                       , 'MESSAGE_DISPLAY');
                            
                            
            set(app.USING_RAWDATA,'Value', 1);
            set(app.USING_DERIVATIVE,'Value', 0);
            set(app.SMOOTH,'Value', 0);
            set(app.FFT_FILTER,'Value', 0);
            set(app.COUNTER_TO_TIME,'Value', 0);
            set(0,'DefaultFigureWindowStyle','docked');
            assignin('base','WP_handle',app)
        end
        
        function CLOSE_App(app,hObject,eventdata)
        % This function runs when the app is closed
            selection = questdlg('WARNING: Closing the App. also closes linked figures (1D and 2D PLOT). Continue?','Close Request Function','Yes','No','Yes');
            switch selection
                case 'No'
                    return
                case 'Yes'
                try
                    if  ~isempty(app.LOADED_SCAN_DATA)
                        delete(app.LOADED_SCAN_DATA.sweep_dim);
                        delete(app.LOADED_SCAN_DATA.step_dim);
                        delete(app.LOADED_SCAN_DATA.step2_dim);
                        delete(app.LOADED_SCAN_DATA.measure_dim);
                        delete(app.LOADED_SCAN_DATA);
                    end
                    if ~isempty(app.plot2D)
                        delete(app.plot2D);
                    end
                    if ~isempty(app.plot1D)
                        delete(app.plot1D);
                    end
                catch err
                    disp(err);
                end
                delete(app.FIGURE);
                delete(app);
                try
                    evalin('base','clear WP_handle')
                catch err
                    disp(err);
                end
            end
        end
        
        function LOAD_Callback(app,hObject,eventdata)
                abort_handle=app.RELOAD; %the handle of the object that must be checked for the 'abort load' function.
                green=[213/256 232/256 217/256];
                orange=[252/256 233/256 202/256];
                red=[255/256 204/256 204/256];
                
                %BACKUP OF PREVIOUS CONFIGURATION
                previous_string=get(app.MESSAGE_DISPLAY,'string');
                if get(app.STEP_STOP, 'Value')==size(get(app.STEP_STOP, 'String'),1)
                    step_stop_was_set_to_max=true;
                else
                    step_stop_was_set_to_max=false;
                end
                if get(app.SWEEP_STOP, 'Value')==size(get(app.SWEEP_STOP, 'String'),1)
                    sweep_stop_was_set_to_max=true;
                else
                    sweep_stop_was_set_to_max=false;
                end
                
                %% LOADING FILE
                
                if ~get(app.RELOAD,'value') % pick the file name and path
                    try
                        [filename, pathname] = uigetfile({'*.lvm;*.mat;','Supported Files (*.lvm,*.mat)';'*.lvm','LabView data (*.lvm)';'*.mat','MAT-files (*.mat)';'*.*', 'All Files (*.*)'}, 'Please pick the file to load',app.current_directory); %open browse window
                    catch err
%                         disp(err);
                        [filename, pathname] = uigetfile({'*.lvm;*.mat;','Supported Files (*.lvm,*.mat)';'*.lvm','LabView data (*.lvm)';'*.mat','MAT-files (*.mat)';'*.*', 'All Files (*.*)'}, 'Please pick the file to load'); %open browse window
                    end
                    if filename==0 % if user canceled, return
                       set(app.MESSAGE_DISPLAY,'string', ['LOADING ABORTED. ' previous_string]);
                       return
                    end
                app.current_directory=pathname;
                F=[pathname filename];
                else
                    set(app.RELOAD,'value',0);
                    F=app.LOADED_SCAN_DATA.filepath;
                end
                set(app.RELOAD,'string','ABORT LOAD');
                set(app.MESSAGE_DISPLAY,'string', 'LOADING FILE... PLEASE WAIT');
                set(app.MESSAGE_DISPLAY,'Backgroundcolor', orange);
                set(app.LOAD, 'Enable', 'off');
                drawnow;

                try
                    app.LOADED_SCAN_DATA=Load_Manager(F,abort_handle);
                catch err
                    set(app.LOAD, 'Enable', 'on');
                    disp('ERROR: An error occured during the file loading.')
                    rethrow(err);
                end
                LSD=app.LOADED_SCAN_DATA;

                set(app.LOAD, 'Enable', 'on');
                set(app.RELOAD, 'String', 'RELOAD');
                
                %% SETTING UI BUTTONS VALUES
                try
                    %PARAMS DIM POPUPS
                    sweep_label_index=min(get(app.SWEEP_LABEL, 'Value'),LSD.sweep_dim.used_param_number);
                    set(app.SWEEP_LABEL,'string', LSD.sweep_dim.build_dimlabel_string);
                    set(app.SWEEP_LABEL, 'Value', max(sweep_label_index,1));
                    step_label_index=min(get(app.STEP_LABEL, 'Value'), LSD.step_dim.used_param_number);
                    set(app.STEP_LABEL,'string', LSD.step_dim.build_dimlabel_string);
                    set(app.STEP_LABEL, 'Value', max(step_label_index,1));
                    step2_label_index=min(get(app.STEP2_LABEL, 'Value'), LSD.step2_dim.used_param_number);
                    set(app.STEP2_LABEL,'string', LSD.step2_dim.build_dimlabel_string);
                    set(app.STEP2_LABEL, 'Value', max(step2_label_index,1));
                    measures_label_index=min(get(app.MEASURE_LINE, 'Value'),LSD.measure_dim.used_param_number);
                    set(app.MEASURE_LINE,'string', LSD.measure_dim.build_dimlabel_string);
                    set(app.MEASURE_LINE, 'Value', max(measures_label_index,1));
                    
                    % SWEEP START & STOP POPUPS
                    sweep_start_index=get(app.SWEEP_START, 'Value');
                    if sweep_start_index>LSD.Nstep 
                        sweep_start_index=1;
                    else
                        sweep_start_index=max(sweep_start_index,1);
                    end
                    if sweep_stop_was_set_to_max
                        sweep_stop_index=LSD.Nsweep;
                    else
                        sweep_stop_index=get(app.SWEEP_STOP, 'Value');
                        sweep_stop_index=min(LSD.Nsweep,sweep_stop_index);
                    end
                    
                    set(app.SWEEP_START,'string', app.build_popup_string('sweep'), 'Value', sweep_start_index);
                    set(app.SWEEP_STOP, 'string', app.build_popup_string('sweep'), 'Value', sweep_stop_index);
                    
                    loaded_sweep=size(LSD.sweep_dim.param_values,2);
                    if LSD.Nsweep~=loaded_sweep
                        warning(['Sweep number smaller than the expected value. File might have been interrupted at sweep n°' num2str(loaded_sweep-1)]);
                        set(app.SWEEP_STOP, 'Value', loaded_sweep);
                        LSD.Warning_flag=true;
                    end
                    
                    % STEP START & STOP POPUPS
                    step_start_index=get(app.STEP_START, 'Value');
                    if step_start_index>LSD.Nstep 
                        step_start_index=1;
                    else
                        step_start_index=max(step_start_index,1);
                    end
                    if step_stop_was_set_to_max
                        step_stop_index=LSD.Nstep;
                    else
                        step_stop_index=get(app.STEP_STOP, 'Value');
                        step_stop_index=min(LSD.Nstep,step_stop_index);
                    end
                    set(app.STEP_START,'string', app.build_popup_string('step'), 'Value', step_start_index);
                    set(app.STEP_STOP, 'string', app.build_popup_string('step'), 'Value', step_stop_index);
                    loaded_step=size(LSD.step_dim.param_values,2);
                    if LSD.Nstep~=loaded_step && loaded_step>0
                        warning(['Step number does not match the expected value. File might have been interrupted at step n°' num2str(loaded_step-1)]);
                        set(app.STEP_STOP, 'Value', loaded_step);
                        LSD.Warning_flag=true;
                    end
                    
                    % STEP2 POPUP
                    step2_index=get(app.STEP2, 'Value');
                    set(app.STEP2,'string', app.build_popup_string('step2'));
                    set(app.STEP2, 'Value', min(step2_index,LSD.Nstep2));
                    loaded_step2=size(LSD.step2_dim.param_values,2);
                    if LSD.Nstep2~=loaded_step2 && loaded_step2>0
                        warning(['Step2 number does not match the expected value. File might have been interrupted at step2 n°' num2str(loaded_step2-1)]);
                        LSD.Warning_flag=true;
                    end
                catch UI_set_err
                    set(app.LOAD,'enable','on');
                    disp('ERROR: An error occured during the initialization of the user interface.')
                    rethrow(UI_set_err);
                end
                
                %% SETTING MESSAGE DISPLAY
                short_name=LSD.remove_path(LSD.filepath);
                if LSD.Error_flag
                    set(app.MESSAGE_DISPLAY,'Backgroundcolor', red);
                    set(app.MESSAGE_DISPLAY,'string', ['ERROR OCCURED WHILE LOADING ' short_name]);
                    rethrow(LSD.load_err)
                elseif exist('UI_set_err','var')
                    set(app.MESSAGE_DISPLAY,'Backgroundcolor', red);
                    set(app.MESSAGE_DISPLAY,'string', ['ERROR OCCURED DURING GUI INIT. (' short_name ')']);
                    rethrow(UI_set_err)
                elseif LSD.Warning_flag || LSD.Abort_flag
                    set(app.RELOAD,'value',0);
                    set(app.MESSAGE_DISPLAY,'Backgroundcolor', orange);
                    set(app.MESSAGE_DISPLAY,'string', ['CURRENTLY LOADED: ' short_name ' (incomplete)']);
                else
                    set(app.MESSAGE_DISPLAY,'Backgroundcolor', green);
                    set(app.MESSAGE_DISPLAY,'string', ['CURRENTLY LOADED: ' short_name]);
                end
                
                if get(app.AUTO_SAVE,'value') && strcmp(LSD.filename(end-3:end),'.lvm')
                    app.SAVE_MAT_Callback(hObject, eventdata);
                end
                % PATCH FOR BUGGED VERSIONS OF THE LABVIEW MEASUREMENT
                % SOFTWARE (LAST SWEEP POINT MISSING IN THE DATA FILES...)
                if LSD.sweep_dim.param_values(:,1)==LSD.sweep_dim.param_values(:,end)
                    LSD.Nsweep=LSD.Nsweep-1;
                    LSD.sweep_dim.param_values=LSD.sweep_dim.param_values(1:end-1);
                    set(app.SWEEP_START,'string', app.build_popup_string('sweep'), 'Value', sweep_start_index);
                    set(app.SWEEP_STOP, 'string', app.build_popup_string('sweep'), 'Value', sweep_stop_index-1);
                end
                
                % PATCH TO KEEP POPUP VALUES IN RANGE FOR UNEXPECTED
                % CONFIGURATIONS (E.G. POPUP TO LARGE TO BE BUILT)
                if get(app.SWEEP_STOP,'Value')>size(get(app.SWEEP_STOP,'string'),1)
                    set(app.SWEEP_STOP,'Value',size(get(app.SWEEP_STOP,'string'),1))
                end
                if get(app.STEP_STOP,'Value')>size(get(app.STEP_STOP,'string'),1)
                    get(app.STEP_STOP,'Value',size(get(app.STEP_STOP,'string'),1))
                end
                if get(app.STEP2,'Value')>size(get(app.STEP2,'string'),1)
                    get(app.STEP2,'Value',size(get(app.STEP2,'string'),1))
                end
                
                
        end
        
        function RELOAD_Callback(app,hObject,eventdata)
            %ABORT PART
            if strcmp(get(app.RELOAD,'string'),'ABORT LOAD')
                set(app.RELOAD,'userdata',1);
            end
            %RELOAD PART
            if strcmp(get(app.RELOAD,'string'),'RELOAD')
                app.LOAD_Callback(hObject, eventdata);
            end
            
        end
        
        function PLOT_2D_Callback(app,hObject,eventdata)
        % GET RANGE TO USE FOR THE PLOT

            sweep_start=get(app.SWEEP_START, 'Value');
            sweep_stop=get(app.SWEEP_STOP, 'Value');
            step_start=get(app.STEP_START, 'Value');
            step_stop=get(app.STEP_STOP, 'Value');

        % CHECKING IF THE RANGE IS OK
            LSD=app.LOADED_SCAN_DATA;
            if LSD.Nstep==1
                msgbox('2D Plot impossible: This file has not any step');
                return
            elseif step_start==step_stop
                msgbox('Not enough steps are selected for plotting');
                return
            elseif step_start>step_stop
                msgbox('ERROR: start step is higher than stop step');
                return
            elseif sweep_start==sweep_stop
                msgbox('Not enough sweeps are selected for plotting');
                return
            elseif sweep_start>sweep_stop
                msgbox('ERROR: start sweep is higher than stop sweep');
                return
            end

            [Y, Y_label]=LSD.sweep_dim.build_dim_axis(get(app.SWEEP_LABEL,'value'),get(app.COUNTER_TO_TIME,'value'),get(app.COUNTER_TO_TIME,'UserData'));
            [X, X_label]=LSD.step_dim.build_dim_axis(get(app.STEP_LABEL,'value'));
            if X(1)==X(end)
                msgbox('The step coord. selected is not varying. Use a different one');
                return
            elseif Y(1)==Y(end)
                msgbox('The sweep coord. selected is not varying. Use a different one');
                return
            end
            [M]=app.extract_data_to_plot;
            
            [~, cb_label]=LSD.measure_dim.build_dim_axis(get(app.MEASURE_LINE,'value'));
            graph_title = [WORKSPACE_PLOTTER_OOP.process_underscore(LSD.filename) ' - step2 n°' num2str(get(app.STEP2, 'Value')-1)];
            graph_legend=app.build_graph_legend('step2','2D');
            
            app.plot2D=fancy_pcolor(2,X(step_start:step_stop),Y(sweep_start:sweep_stop),M,'Xlabel',X_label,'Ylabel',Y_label,'Zlabel',cb_label,'Title',graph_title,'Legend',graph_legend);
            set(app.plot2D.figID,'name','2D PLOT');

            set(gcf,'KeyPressFcn',@app.ReadKey_2D_plot);
            
            
            if strfind(X_label, '\delta')
                axis_uimenu=app.add_axis_context_menu(app.plot2D.Xlabel);
                set(app.plot2D.Xlabel, 'UIContextMenu', axis_uimenu);
            end
            if strfind(Y_label, '\delta')
                axis_uimenu=app.add_axis_context_menu(app.plot2D.Ylabel);
                set(app.plot2D.Ylabel, 'UIContextMenu', axis_uimenu);
            end
            
            
        end
        
        function PLOT_1D_Callback(app,hObject,eventdata)
        % GET RANGE TO USE FOR THE PLOT
    
            sweep_start=get(app.SWEEP_START, 'Value');
            sweep_stop=get(app.SWEEP_STOP, 'Value');
            step_start=get(app.STEP_START, 'Value');
            step_stop=get(app.STEP_STOP, 'Value');

        % CHECKING IF THE RANGE IS OK
            LSD=app.LOADED_SCAN_DATA;
            if sweep_start==sweep_stop
                msgbox('Not enough sweep points are selected for plotting');
                return
            elseif sweep_start>sweep_stop
                msgbox('ERROR: start sweep is higher than stop sweep');
                return
            end
            if step_start>step_stop
                msgbox('ERROR: start step is higher than stop step');
                return
            end

        % GETTING THE DATA AND PLOT  
        
            [X, X_label]=LSD.sweep_dim.build_dim_axis(get(app.SWEEP_LABEL,'value'),get(app.COUNTER_TO_TIME,'value'),get(app.COUNTER_TO_TIME,'UserData'));
            if  X(1)==X(end)
                msgbox('The sweep coord. selected is not varying. Use a different one');
                return
            end
            [~, Y_label]=LSD.measure_dim.build_dim_axis(get(app.MEASURE_LINE,'value'));
            [M]=app.extract_data_to_plot;
            graph_title = [WORKSPACE_PLOTTER_OOP.process_underscore(LSD.filename)  ' - step2 n°' num2str(get(app.STEP2, 'Value')-1) ' - step ' num2str(get(app.STEP_START, 'Value')-1) ' to ' num2str(get(app.STEP_STOP, 'Value')-1)];
            graph_legend=app.build_graph_legend('step','1D');
            app.plot1D=fancy_plot(1,X(sweep_start:sweep_stop),M,'Xlabel',X_label,'Ylabel',Y_label,'Title',graph_title,'Legend',graph_legend);
            set(app.plot1D.figID,'name','1D PLOT');
            set(gcf,'KeyPressFcn',@app.ReadKey_1D_plot); 
            set(gca,'Xlim',[min(X(sweep_start:sweep_stop)) max(X(sweep_start:sweep_stop))]);
            
            if strfind(X_label, '\delta')
                axis_uimenu=app.add_axis_context_menu(app.plot1D.Xlabel);
                set(app.plot1D.Xlabel, 'UIContextMenu', axis_uimenu);
            end
            if strfind(Y_label, '\delta')
                axis_uimenu=app.add_axis_context_menu(app.plot1D.Ylabel);
                set(app.plot1D.Ylabel, 'UIContextMenu', axis_uimenu);
            end
            
        end
        
        function AVERAGE_Callback(app,hObject,eventdata)
        % Average data matrix along selected dimension.
        % Can work in raw or derivative modes. Smooth options are ignored in this
        % function. Data ca be displayed in 1D or 2D (question raised to the user
        % when possible).

        % GET RANGE TO USE FOR THE PLOT
            LSD=app.LOADED_SCAN_DATA;
            sweep_start=get(app.SWEEP_START, 'Value');
            sweep_stop=get(app.SWEEP_STOP, 'Value');
            step_start=get(app.STEP_START, 'Value');
            step_stop=get(app.STEP_STOP, 'Value');
            loaded_step2=size(LSD.step2_dim.param_values,2);


        % CHECK IF DATA CAN BE AVERAGED OR NOT

            if LSD.Nstep<=1 && LSD.Nstep2<=1                               
                msgbox('File contains only one curve. Averaging is not possible');
                return
            elseif step_start==step_stop && loaded_step2==0
                msgbox('Not enough steps are selected for averaging');
                return
            elseif sweep_start==sweep_stop && loaded_step2==0
                msgbox('Not enough sweeps are selected for averaging');
                return
            end

        % DERIVATE DATASET IF REQUIRED
            measure_line=get(app.MEASURE_LINE, 'Value');
            if get(app.USING_RAWDATA,'value')
                Mat_to_Use=LSD.data(sweep_start:sweep_stop,step_start:step_stop,:,measure_line);
            else
                Mat_to_Use=LSD.data(sweep_start:sweep_stop,step_start:step_stop,:,measure_line);
                for k=1:LSD.Nstep2
                   Deriv=Mat_to_Use(:,:,k);
                   Deriv=smooth2a(Deriv,1,0);
                   Deriv=diff(Deriv);
                   Deriv(sweep_stop-sweep_start+1,:)=Deriv(sweep_stop-sweep_start,:);
                   Mat_to_Use(:,:,k)=Deriv;
                end
            end

        % ##################### IN CASE THERE ARE NO STEP2 ######################## 

        % ASK USER FOR THE DIMENSION TO AVERAGE
            if LSD.Nstep2<=1 
                dim='step';
                dim = inputdlg({'Along which dimension averaging data? (sweep, step)'},'Averaging dimension', 1, {dim}); % ask for the dimension to average   
                if isempty(dim)     % user canceled?
                    return;
                end
                dim=dim{1};

        % AVERAGE DATA AND GET CORRECT AXIS LABELS FOR PLOTTING
                switch lower(dim)
                    case 'sweep'
                        Average=squeeze(mean(Mat_to_Use,1));
                        [X, X_label]=LSD.step_dim.build_dim_axis(get(app.STEP_LABEL,'value'));
                        X=X(step_start:step_stop);
                    case 'step'
                        Average=squeeze(mean(Mat_to_Use,2));
                        [X, X_label]=LSD.sweep_dim.build_dim_axis(get(app.SWEEP_LABEL,'value'),get(app.COUNTER_TO_TIME,'value'),get(app.COUNTER_TO_TIME,'UserData'));
                        X=X(sweep_start:sweep_stop);
                    case 'shooter_please' 
                        shooter03
                        return
                    otherwise
                        msgbox('ERROR: input not supported (different from sweep or step)');
                        return
                end

        % PLOTTING THE FIGURE
                [~, Z_label]=LSD.measure_dim.build_dim_axis(get(app.MEASURE_LINE,'value'));
                graph_title = 'Average Result';
                app.plotAverage=fancy_plot(6,X,Average,'Xlabel',X_label,'Ylabel',Z_label,'Title',graph_title);
                set(app.plotAverage.figID,'name','AVERAGED DATA');
                set(gca,'Xlim',[min(X) max(X)]);

        % ###################### IN CASE THERE ARE STEP2 ##########################        
            else

        % ASK USER FOR THE DIMENSION TO AVERAGE
                dim='step2';
                dim = inputdlg({'Along which dimension averaging data? (sweep, step, step2)'},'Averaging dimension', 1, {dim}); % ask user for dimension to average
                if isempty(dim)     % user canceled?
                    return;
                end
                dim=dim{1};

        % AVERAGE DATA AND GET CORRECT AXIS LABELS FOR PLOTTING
                switch lower(dim)
                    case 'sweep'
                        Average=squeeze(mean(Mat_to_Use,1));
                        [X, X_label]=LSD.step_dim.build_dim_axis(get(app.STEP_LABEL,'value'));
                        X=X(step_start:step_stop);
                        [Y, Y_label]=LSD.step2_dim.build_dim_axis(get(app.STEP2_LABEL,'value'));
                        if step_start==step_stop
                            msgbox('Not enough steps are selected for plotting');
                            return
                        elseif  X(1)==X(end)
                            msgbox('The step coord. selected is not varying. Use a different one');
                            return
                        elseif Y(1)==Y(end)
                            msgbox('The step2 coord. selected is not varying. Use a different one');
                            return
                        end
                        graph_legend=app.build_graph_legend('step2','1D');
                    case 'step'
                        Average=squeeze(mean(Mat_to_Use,2));
                        [X, X_label]=LSD.sweep_dim.build_dim_axis(get(app.SWEEP_LABEL,'value'),get(app.COUNTER_TO_TIME,'value'),get(app.COUNTER_TO_TIME,'UserData'));
                        X=X(sweep_start:sweep_stop);
                        [Y, Y_label]=LSD.step2_dim.build_dim_axis(get(app.STEP2_LABEL,'value'));
                        graph_legend=app.build_graph_legend('step2','1D');
                        if sweep_start==sweep_stop
                            msgbox('Not enough sweeps are selected for plotting');
                            return
                        elseif  X(1)==X(end)
                            msgbox('The sweep coord. selected is not varying. Use a different one');
                            return
                        elseif Y(1)==Y(end)
                            msgbox('The step2 coord. selected is not varying. Use a different one');
                            return
                        end
                    case 'step2'
                        Average=squeeze(mean(Mat_to_Use(:,:,1:loaded_step2),3));
                        [X, X_label]=LSD.sweep_dim.build_dim_axis(get(app.SWEEP_LABEL,'value'),get(app.COUNTER_TO_TIME,'value'),get(app.COUNTER_TO_TIME,'UserData'));
                        X=X(sweep_start:sweep_stop);
                        [Y, Y_label]=LSD.step_dim.build_dim_axis(get(app.STEP_LABEL,'value'));
                        Y=Y(step_start:step_stop);
                        graph_legend=app.build_graph_legend('step','1D');
                        if sweep_start==sweep_stop
                            msgbox('Not enough sweeps are selected for plotting');
                            return
                        elseif  X(1)==X(end)
                            msgbox('The sweep coord. selected is not varying. Use a different one');
                            return
                        elseif Y(1)==Y(end)
                            msgbox('The step coord. selected is not varying. Use a different one');
                            return
                        end
                    case 'shooter_please'
                        shooter03
                        return
                    otherwise
                        msgbox('ERROR: input not supported (different from sweep, step or step2)');
                        return
                end


        % PLOTTING THE FIGURE
                if LSD.Nstep2>0
                        plot_choice = questdlg('What kind of plot do you want?','Select plot to use','1D plot','2D plot','Cancel','2D plot'); % ask user to choose between 1D or 2D plot
                end
                switch plot_choice
                    case '1D plot'
                        [~, Z_label]=LSD.measure_dim.build_dim_axis(get(app.MEASURE_LINE,'value'));
                        graph_title = [WORKSPACE_PLOTTER_OOP.process_underscore(LSD.filename) ' - ' dim ' Averaged'];
                        app.plotAverage=fancy_plot(6,X,Average,'Xlabel',X_label,'Ylabel',Z_label,'Title',graph_title,'Legend',graph_legend);
                        set(gcf,'KeyPressFcn',{@app.ReadKey_1D_average,Average,dim});
                        set(gca,'Xlim',[min(X) max(X)]);
                    case '2D plot'  
                        if strcmp(dim,'step2')&&(size(Y,2)==1)
                                msgbox('Not enough steps are selected for a 2D plot');
                                return
                        end
                        [~, Z_label]=LSD.measure_dim.build_dim_axis(get(app.MEASURE_LINE,'value'));
                        graph_title = [WORKSPACE_PLOTTER_OOP.process_underscore(LSD.filename) ' - ' dim ' Averaged'];
                        app.plotAverage=fancy_pcolor(6,Y,X,Average,'Xlabel',Y_label,'Ylabel',X_label,'Zlabel',Z_label,'Title',graph_title);
                    case 'Cancel'
                        return
                end 
                set(app.plotAverage.figID,'name','AVERAGED DATA');
            end
        end
        
        function ANALYSE_Callback(app,hObject,eventdata)
            [selection,ok] = listdlg('PromptString','What do you want to do?','SelectionMode','single','ListString',{'Transfer statistics' ; 'µs pulse mapping' ; 'Spin Plot' ; 'Patch Vivien'},'ListSize',[160 150]);
            if ok==0
                return
            end
            switch selection
                case 1
                    app.transfer_stat(hObject, eventdata);
                case 2
                    app.sending_map(hObject, eventdata);
                case 3
                    spinplot_handle=Spin_Plot('data',app.LOADED_SCAN_DATA);
                    assignin('base','spinplot_handle',spinplot_handle);
                case 4
                    gros_Babar
                otherwise
                    return
            end
        end
        
        function SCAN_INFOS_Callback(app,hObject,eventdata)
            close(findobj('type','figure','name','SCAN INFOS'))
            f5=figure(5);
            set(f5,'name','SCAN INFOS');
            set(gcf,'WindowStyle','normal')
            set(gcf,'Units','normalized')
            set(gcf,'Position',[0.3 0.3 0.4 0.6]);
            
            LSD=app.LOADED_SCAN_DATA;
            DAC_data = LSD.DAC_init_values'; 
            cnames = {'0','1','2','3','4','5','6','7'};
            rnames = {'0','1','2','3','4','5','6','7'};
            DAC_table=uitable('Parent',f5,'Units','normalized','Position',[0.05 0.65 0.88 0.26]);
            set(DAC_table,'Data',DAC_data,'ColumnName',cnames,'RowName',rnames);
            title_DAC=uicontrol('Parent',f5,'Style','text','Units','normalized','Position',[0.3 0.94 0.4 0.04]);
            set(title_DAC,'string','DAC INITIAL VALUES','FontSize',14);

            Sweep_description=cell(LSD.sweep_dim.used_param_number,1);
            for i=1:LSD.sweep_dim.used_param_number
                Sweep_description{i}=[LSD.sweep_dim.param_infos{i}{1} ' varying from ' LSD.sweep_dim.param_infos{i}{2} ' to ' LSD.sweep_dim.param_infos{i}{3} ' ' LSD.sweep_dim.param_infos{i}{4}];
            end
            if LSD.Nstep>1
                Step_description=cell(LSD.step_dim.used_param_number,1);
                for i=1:LSD.step_dim.used_param_number
                    Step_description{i}=[LSD.step_dim.param_infos{i}{1} ' varying from ' LSD.step_dim.param_infos{i}{2} ' to ' LSD.step_dim.param_infos{i}{3} ' ' LSD.step_dim.param_infos{i}{4}];
                end
            else
                Step_description{1}='NO STEP USED';   
            end
            if LSD.Nstep2>1
                usedStep2=size(LSD.step2_dim.param_infos,2);
                Step2_description=cell(usedStep2,1);
                for i=1:usedStep2
                    Step2_description{i}=[LSD.step2_dim.param_infos{i}{1} ' varying from ' LSD.step2_dim.param_infos{i}{2} ' to ' LSD.step2_dim.param_infos{i}{3} ' ' LSD.step2_dim.param_infos{i}{4}];
                end
            else
                Step2_description{1}='NO STEP2 USED';   
            end

            sweeptable=uitable('Parent',f5,'Data',Sweep_description,'ColumnName','SWEEP','Units','normalized','Position',[0.05 0.39 0.88 0.15]);
            steptable=uitable('Parent',f5,'Data',Step_description,'ColumnName','STEP','Units','normalized','Position',[0.05 0.22 0.88 0.15]);
            step2table=uitable('Parent',f5,'Data',Step2_description,'ColumnName','STEP2','Units','normalized','Position',[0.05 0.05 0.88 0.15]);
            screen_size = get(0,'ScreenSize');
            screen_size = screen_size(3);
            col_width=round(0.4*0.88*screen_size);
            set(sweeptable,'ColumnWidth', num2cell(col_width));
            set(steptable,'ColumnWidth', num2cell(col_width));
            set(step2table,'ColumnWidth', num2cell(col_width));
            title_SCAN=uicontrol('Parent',f5,'Style','text','Units','normalized','Position',[0.3 0.58 0.4 0.04]);
            set(title_SCAN,'string','SWEEP, STEP, STEP2 INFOS','FontSize',14);
        end
        
        function SAVE_MAT_Callback(app,hObject,eventdata)
            app.LOADED_SCAN_DATA.saveobj(get(app.PERMUTE,'Value'));
%             set(app.PERMUTE,'Value',0)
        end
        
        function SWEEP_FULL_RANGE_Callback(app,hObject,eventdata)
            LSD=app.LOADED_SCAN_DATA;
            set(app.SWEEP_START,'Value', 1);
            set(app.SWEEP_STOP,'Value', LSD.Nsweep);
        end
        
        function STEP_FULL_RANGE_Callback(app,hObject,eventdata)
            LSD=app.LOADED_SCAN_DATA;
            set(app.STEP_START,'Value', 1);
            set(app.STEP_STOP,'Value', LSD.Nstep);
        end
        
        function USING_RAWDATA_Callback(app,hObject,eventdata)
            if get(hObject,'Value')==1
                set(app.USING_DERIVATIVE,'Value', 0);
            else
                set(app.USING_DERIVATIVE,'Value', 1);
            end
        end
        
        function USING_DERIVATIVE_Callback(app,hObject,eventdata)
            if get(hObject,'Value')==1
                set(app.USING_RAWDATA,'Value', 0);
            else
                set(app.USING_RAWDATA,'Value', 1);
            end
        end
        
        function SMOOTH_Callback(app,hObject,eventdata)
            if get(app.SMOOTH,'Value')
                orderStr = inputdlg({'Sweep moving average order:','Step moving average order:'},'Averaging order',1,{'1','0'}); 
                if isempty(orderStr)    % user canceled?
                    set(app.SMOOTH,'Value',0)
                    return;
                end
                smooth_order.sweep=str2double(orderStr(1));
                smooth_order.step=str2double(orderStr(2));
                set(app.SMOOTH,'UserData',smooth_order);
            end
        end
        
        function FFT_FILTER_Callback(app,hObject,eventdata)
            LSD=app.LOADED_SCAN_DATA;
            if get(app.FFT_FILTER,'Value')
                orderStr = inputdlg({'Use filter for:'},'Dimension',1,{'sweep'});
                if isempty(orderStr)     % user canceled?
                    FFT_options=get(app.FFT_FILTER,'UserData');
                    FFT_options.TYPE='none';
                    set(app.FFT_FILTER,'Value',0);
                    set(app.FFT_FILTER,'UserData',FFT_options); 
                    return;
                end
                set(app.FFT_FILTER,'Value',0); % to avoid applying default filter while extracting current data
                [M]=app.extract_data_to_plot;
                set(app.FFT_FILTER,'Value',1);
                options=get(app.FFT_FILTER,'UserData');
                switch orderStr{1}
                    case 'sweep'
                        sweep_start=get(app.SWEEP_START, 'Value');
                        sweep_stop=get(app.SWEEP_STOP, 'Value');
                        [Y, Y_label]=LSD.sweep_dim.build_dim_axis(get(app.SWEEP_LABEL,'value'),get(app.COUNTER_TO_TIME,'value'),get(app.COUNTER_TO_TIME,'UserData'));
                        if isempty(options)||~isfield(options,'CENTER')
                            h=FFT_filter_designer(Y(sweep_start:sweep_stop),M','LABEL',Y_label);
                        else
                            h=FFT_filter_designer(Y(sweep_start:sweep_stop),M','LABEL',Y_label,'CENTER',options.CENTER,'WIDTH',options.WIDTH,'SHAPE',options.SHAPE,'FILTERMODE',options.FILTERMODE);
                        end
                    case 'step'
                        step_start=get(app.STEP_START, 'Value');
                        step_stop=get(app.STEP_STOP, 'Value');
                        [X, X_label]=LSD.step_dim.build_dim_axis(get(app.STEP_LABEL,'value'));
                        if isempty(options)
                            h=FFT_filter_designer(X(step_start:step_stop),M,'LABEL',X_label);
                        else
                            h=FFT_filter_designer(X(step_start:step_stop),M,'LABEL',X_label,'CENTER',options.CENTER,'WIDTH',options.WIDTH,'SHAPE',options.SHAPE,'FILTERMODE',options.FILTERMODE);
                        end
                    otherwise
                        msgbox('ERROR: Unknown dimension');
                        set(app.FFT_FILTER,'Value',0);
                    return;
                end
                waitfor(h.figID)
                FFT_options=h.Output;
                if isempty(FFT_options)
                    FFT_options=get(app.FFT_FILTER,'UserData'); 
                    FFT_options.TYPE='none';
                    set(app.FFT_FILTER,'UserData',FFT_options); 
                    set(app.FFT_FILTER,'Value',0);
                    return;
                end
                FFT_options.TYPE=orderStr{1};
                set(app.FFT_FILTER,'UserData',FFT_options);
                
            else
                FFT_options=get(app.FFT_FILTER,'UserData'); 
                FFT_options.TYPE='none';
                set(app.FFT_FILTER,'UserData',FFT_options); 
            end
        end
        
        function COUNTER_TO_TIME_Callback(app,hObject,eventdata)
            if get(app.COUNTER_TO_TIME,'Value')==1
                duration_str = inputdlg({'Sweep duration (ms):'}, 'Please enter sweep duration (ms)',1, {'50'});
                set(app.COUNTER_TO_TIME,'UserData',str2double(duration_str));
            end
                set(app.SWEEP_START,'string', app.build_popup_string('sweep'));
                set(app.SWEEP_STOP, 'string', app.build_popup_string('sweep'));
        end
             
        function SWEEP_LABEL_Callback(app,hObject,eventdata)
            if strcmp(get(app.SWEEP_LABEL,'string'),'Not Used')
                return
            end
            set(app.SWEEP_START,'string', app.build_popup_string('sweep'));
            set(app.SWEEP_STOP,'string',  app.build_popup_string('sweep'));
        end
        
        function STEP_LABEL_Callback(app,hObject,eventdata)
            if strcmp(get(app.STEP_LABEL,'string'),'Not Used')
                return
            end
            set(app.STEP_START,'string', app.build_popup_string('step'));
            set(app.STEP_STOP,'string',  app.build_popup_string('step'));
        end
        
        function STEP2_LABEL_Callback(app,hObject,eventdata)
            if strcmp(get(app.STEP2_LABEL,'string'),'Not Used')
                return
            end
            set(app.STEP2,'string', app.build_popup_string('step2'));
        end
        

        
        
                
        function [M]=extract_data_to_plot(app)
        % --- select only data to be plotted from measure matrix (or derivative) and smooth it when required
            LSD=app.LOADED_SCAN_DATA;
            current_step2=get(app.STEP2, 'Value');
            step_start=get(app.STEP_START, 'Value');
            step_stop=get(app.STEP_STOP, 'Value');
            sweep_start=get(app.SWEEP_START, 'Value');
            sweep_stop=get(app.SWEEP_STOP, 'Value');
            measure_line=get(app.MEASURE_LINE, 'Value');
            if get(app.USING_RAWDATA,'Value');
                M=LSD.data(sweep_start:sweep_stop,step_start:step_stop,current_step2,measure_line);
            else
                M=LSD.data(sweep_start:sweep_stop,step_start:step_stop,current_step2,measure_line);
                M=smooth2a(M,1,0);
                M=diff(M);
                N=(sweep_stop-sweep_start);
                M(N+1,:)=M(N,:);
            end
            if get(app.SMOOTH,'Value')
                smooth_order=get(app.SMOOTH,'UserData');
                M=smooth2a(M,smooth_order.sweep,smooth_order.step);    
            end
            M=full(M);
            if get(app.FFT_FILTER,'Value')
                FFT_options=get(app.FFT_FILTER,'UserData');
                h=FFT_filter(M,FFT_options);
                M=h.Output;
            end
        end   
        
        function transfer_stat(app,hObject, eventdata)
            LSD=app.LOADED_SCAN_DATA;
            step_start=get(app.STEP_START,'Value');
            step_stop=get(app.STEP_STOP,'Value');
            derivative=get(app.USING_DERIVATIVE,'Value');
            smooth=get(app.SMOOTH,'Value');
            smooth_order=get(app.SMOOTH,'UserData');
            app.AnalyseOutput=Transfer_stat(LSD,'step_range',[step_start step_stop],'fig_nb',3,'derivative',derivative,'smooth',smooth,'smooth_order',smooth_order,'step2_param',get(app.STEP2_LABEL,'Value'));
        end
        
        function sending_map(app,hObject, eventdata)
            LSD=app.LOADED_SCAN_DATA;
            if LSD.Nstep==1
                disp('ERROR: This file does not have any step');
                return
            elseif LSD.Nstep2==1
                disp('ERROR: This file does not have any step2');
                return
            end
            set(app.STEP_START, 'Value', 1);
            set(app.STEP_STOP, 'Value', LSD.Nstep);
            if LSD.Nstep>1  
              [stepvalues, steplabel]=LSD.step_dim.build_dim_axis(get(app.STEP_LABEL,'value'));
              if isempty(stepvalues)
                  msgbox('The step coord. selected is not varying. Use a different one');
                  return
              elseif  stepvalues(1)==stepvalues(size(stepvalues))
                  msgbox('The step coord. selected is not varying. Use a different one');
                  return
              end  
            end
            if LSD.Nstep2>1  
              [step2values, step2label]=LSD.step2_dim.build_dim_axis(get(app.STEP2_LABEL,'value'));
              if isempty(step2values)
                  msgbox('The step2 coord. selected is not varying. Use a different one');
                  return
              elseif  step2values(1)==step2values(size(step2values))
                  msgbox('The step2 coord. selected is not varying. Use a different one');
                  return
              end  
            end
            answer = inputdlg({'Init start','Init stop','Final start','Final stop'},'Thresholds', 1, {'200','250','300','350'});
            if isempty(answer)     % user canceled?
              return;
            end
            ini_int_start=str2double(answer{1});
            ini_int_stop=str2double(answer{2});
            fin_int_start=str2double(answer{3});
            fin_int_stop=str2double(answer{4});
            step_start=get(app.STEP_START, 'Value');
            step_stop=get(app.STEP_STOP, 'Value');
            measure_line=get(app.MEASURE_LINE, 'Value');
            M=squeeze(mean(LSD.data(fin_int_start:fin_int_stop,step_start:step_stop,1:size(step2values,2),measure_line),1)-mean(LSD.data(ini_int_start:ini_int_stop,step_start:step_stop,1:size(step2values,2),measure_line),1));
            [~, cb_label]=LSD.measure_dim.build_dim_axis(get(app.MEASURE_LINE,'value'));
            cb_label=['\Delta' cb_label];
            graph_title = [WORKSPACE_PLOTTER_OOP.process_underscore(LSD.filename) ' - µs pulse mapping'];
            app.AnalyseOutput=fancy_pcolor(3,step2values,stepvalues,M,'Xlabel',step2label,'Ylabel',steplabel,'Zlabel',cb_label,'Title',graph_title);
            set(app.AnalyseOutput.figID,'name','µs MAP');
        end
        
        
        function [string] = build_popup_string(app,dim)
            LSD=app.LOADED_SCAN_DATA;
            switch dim
                case 'sweep'
                    label=get(app.SWEEP_LABEL,'string');
%                     if strcmp(label,'Not Used');string='0';return;end    % should be useless:there must be sthing swept to have a data file
                    if get(app.COUNTER_TO_TIME,'value') && ( strcmp(label,'counter') || strcmp(label,'Counter'))
                        duration=get(app.COUNTER_TO_TIME,'UserData');
                        value_str=0:duration/(LSD.Nsweep-1):duration;
                        unit_str = 'ms';
                        dim_length=LSD.Nsweep;
                    else
                    param_nb=get(app.SWEEP_LABEL,'value');
                    dim_length=LSD.Nsweep;
                    value_str=LSD.sweep_dim.param_values(param_nb,:);
                    unit_str = LSD.sweep_dim.param_infos{param_nb}{4};
                    end
                case 'step'
                    label=get(app.STEP_LABEL,'string');
                    if strcmp(label,'Not Used');string='0';return;end
                    param_nb=get(app.STEP_LABEL,'value');
                    dim_length=LSD.Nstep;
                    value_str=LSD.step_dim.param_values(param_nb,:);
                    unit_str = LSD.step_dim.param_infos{param_nb}{4};
                case 'step2'
                    label=get(app.STEP2_LABEL,'string');
                    if strcmp(label,'Not Used');string='0';return;end
                    param_nb=get(app.STEP2_LABEL,'value');
                    dim_length=LSD.Nstep2;
                    value_str=LSD.step2_dim.param_values(param_nb,:);
                    unit_str = LSD.step2_dim.param_infos{param_nb}{4};
            end
            if dim_length>100000
                string='too large to be built';
                return
            end
            index_str = 0:dim_length-1;
%             index_str = num2str(index_str');
            valsize=size(value_str,2);
            if valsize~=dim_length % hack to deal with interrupted files
                value_str(valsize+1:dim_length)=NaN;
            end
%             value_str = num2str(value_str');
%             string=strcat(index_str, {' - ('}, value_str, {' '}, unit_str,{')'});
            string = textscan(sprintf(['%d - ( %g ' unit_str ' ) \n'],[index_str;value_str]),'%s','delimiter','\n');
            string = string{1};
            assignin('base','str',string)

        end
        
        function [string_matrix]=build_graph_legend(app,dimstr,plot_type)
            % --- build legend to plot
            LSD=app.LOADED_SCAN_DATA;
            try
                switch dimstr
                case 'step'
                    if LSD.Nstep<=1
                       string_matrix='';
                    else
                        step_start=get(app.STEP_START, 'Value');
                        step_stop=get(app.STEP_STOP, 'Value');
                        step_label_used=get(app.STEP_LABEL,'value');
                        string_matrix{step_stop-step_start+1}='';
                        string_matrix{1}=[LSD.step_dim.param_infos{step_label_used}{1} ' = ' num2str(LSD.step_dim.param_values(step_label_used,step_start)) ' ' LSD.step_dim.param_infos{step_label_used}{4}];
                        for i=1:(step_stop-step_start)
                        string_matrix{1+i}=[LSD.step_dim.param_infos{step_label_used}{1} ' = ' num2str(LSD.step_dim.param_values(step_label_used,step_start+i)) ' ' LSD.step_dim.param_infos{step_label_used}{4}];
                        end
                    end
                case 'step2'
                    loaded_step2=size(LSD.step2_dim.param_values,2);
                    if LSD.Nstep2<=1
                        string_matrix='';
                    else
                        current_step2=get(app.STEP2, 'Value');
                        step2_label_used=get(app.STEP2_LABEL,'value');
                        if strcmp(plot_type,'1D')
                            string_matrix{LSD.Nstep2}='';
                            string_matrix{1}=[LSD.step2_dim.param_infos{step2_label_used}{1} ' = ' num2str(LSD.step2_dim.param_values(step2_label_used,1)) ' ' LSD.step2_dim.param_infos{step2_label_used}{4}];
                            for i=2:loaded_step2 % instead of 2:Nstep2 to deal with interrupted files
                                string_matrix{i}=[LSD.step2_dim.param_infos{step2_label_used}{1} ' = ' num2str(LSD.step2_dim.param_values(step2_label_used,i)) ' ' LSD.step2_dim.param_infos{step2_label_used}{4}];
                            end
                        elseif strcmp(plot_type,'2D')
                            string_matrix{1}=[LSD.step2_dim.param_infos{step2_label_used}{1} ' = ' num2str(LSD.step2_dim.param_values(step2_label_used,current_step2)) ' ' LSD.step2_dim.param_infos{step2_label_used}{4}];
                        end
                    end
                end    
            catch err
                string_matrix='';
                warning(['Error made it impossible to buid graph legend:' err.message]);
            end
        end
        
        function [cmenu] = add_axis_context_menu(app,caller_handle)
            cmenu=uicontextmenu;
            uimenu(cmenu, 'Label', 'offset -> DAC value', 'Callback', {@app.offset_to_value, caller_handle});
        end

        function offset_to_value(app,hObject, eventdata, caller_handle)
            LSD=app.LOADED_SCAN_DATA;
            axis_label=get(caller_handle,'Tag');
            switch axis_label
                case 'XLabel'
                        ticks='XTick';
                case 'YLabel'
                        ticks='YTick';
                otherwise
                    disp('ERROR: Caller''s tag not recognized');
                    return
            end
            DAC_string=cell2mat(regexp(get(caller_handle,'string'),'{\d:\d}','match'));
            DAC_col=str2double(DAC_string(2))+1;
            DAC_row=str2double(DAC_string(4))+1;
            DAC_dc_value=LSD.DAC_init_values(DAC_col,DAC_row);

            graph_handle=findobj(gca,'Type','Surface');
            if isempty(graph_handle)
                graph_handle=findobj(gca,'Type','Line');
            end
            if strcmp(get(hObject,'Label'),'offset -> DAC value')
                switch ticks
                    case 'XTick'
                        if size(graph_handle,1)>1
                            Xcell=get(graph_handle,'XData');
                            Xcell=cell2mat(Xcell)+DAC_dc_value;
                            Xcell=mat2cell(Xcell,ones(1,size(Xcell,1)),size(Xcell,2));
                            set(graph_handle,{'XData'},Xcell);
                            set(gca,'XLim',get(gca,'XLim')+DAC_dc_value);
                        else
                            Xcell=get(graph_handle,'XData')+DAC_dc_value;
                            set(graph_handle,'XData',Xcell);
                            set(gca,'XLim',get(gca,'XLim')+DAC_dc_value);
                        end
                    case 'YTick'
                        if size(graph_handle,1)>1
                            Ycell=get(graph_handle,'YData');
                            Ycell=cell2mat(Ycell)+DAC_dc_value;
                            Ycell=mat2cell(Ycell,ones(1,size(Ycell,1)),size(Ycell,2));
                            set(graph_handle,{'YData'},Ycell);
                            set(gca,'YLim',get(gca,'YLim')+DAC_dc_value);
                        else
                            Ycell=get(graph_handle,'YData')+DAC_dc_value;
                            set(graph_handle,'YData',Ycell);
                            set(gca,'YLim',get(gca,'YLim')+DAC_dc_value);
                        end
                end
                set(hObject,'Label','DAC value -> offset');
                caller_string=sprintf('V_{%i:%i} (V)',DAC_col-1,DAC_row-1);
                set(caller_handle,'String',caller_string);
            else
                switch ticks
                    case 'XTick'
                        if size(graph_handle,1)>1
                            Xcell=get(graph_handle,'XData');
                            Xcell=cell2mat(Xcell)-DAC_dc_value;
                            Xcell=mat2cell(Xcell,ones(1,size(Xcell,1)),size(Xcell,2));
                            set(graph_handle,{'XData'},Xcell);
                            set(gca,'XLim',get(gca,'XLim')-DAC_dc_value);
                        else
                            Xcell=get(graph_handle,'XData')-DAC_dc_value;
                            set(graph_handle,'XData',Xcell);
                            set(gca,'XLim',get(gca,'XLim')-DAC_dc_value);
                        end
                    case 'YTick'
                        if size(graph_handle,1)>1
                            Ycell=get(graph_handle,'YData');
                            Ycell=cell2mat(Ycell)-DAC_dc_value;
                            Ycell=mat2cell(Ycell,ones(1,size(Ycell,1)),size(Ycell,2));
                            set(graph_handle,{'YData'},Ycell);
                            set(gca,'YLim',get(gca,'YLim')-DAC_dc_value);
                        else
                            Ycell=get(graph_handle,'YData')-DAC_dc_value;
                            set(graph_handle,'YData',Ycell);
                            set(gca,'YLim',get(gca,'YLim')-DAC_dc_value);
                        end
                end
                set(hObject,'Label','offset -> DAC value');
                caller_string=sprintf('\\delta V_{%i:%i} (V)',DAC_col-1,DAC_row-1);
                set(caller_handle,'String',caller_string);
            end
        end
        

        
        function ReadKey_2D_plot(app,hObject,eventdata)
        % Interprets key presses from the Figure window.
        % When a key is pressed, interprets key and calls corresponding function.
        if WORKSPACE_PLOTTER_OOP.isMultipleCall()
            return;  
        end
        LSD=app.LOADED_SCAN_DATA;
        key=get(gcf,'CurrentCharacter');
        
        switch key

            case 31 % down arrow key
                min_reached=(get(app.STEP2, 'Value')==1);
                if ~min_reached
                    set(app.STEP2, 'Value', max(get(app.STEP2, 'Value')-1, 1));
                    graph_title = [WORKSPACE_PLOTTER_OOP.process_underscore(LSD.filename) ' - step2 n°' num2str(get(app.STEP2, 'Value')-1)];
                else
                    return;
                end

            case 30 % up arrow key
                max_reached=(get(app.STEP2, 'Value')==LSD.Nstep2);
                if ~max_reached
                    set(app.STEP2, 'Value', min(get(app.STEP2, 'Value')+1, LSD.Nstep2));
                    graph_title = [WORKSPACE_PLOTTER_OOP.process_underscore(LSD.filename) ' - step2 n°' num2str(get(app.STEP2, 'Value')-1)];
                else
                    return;
                end

            case 50 % 2 key
                min_reached=(get(app.STEP2, 'Value')==1);
                if ~min_reached
                    set(app.STEP2, 'Value', max(get(app.STEP2, 'Value')-10, 1));
                    graph_title = [WORKSPACE_PLOTTER_OOP.process_underscore(LSD.filename) ' - step2 n°' num2str(get(app.STEP2, 'Value')-1)];
                else
                    return;
                end

            case 53 % 5 key
                max_reached=(get(app.STEP2, 'Value')==LSD.Nstep2);
                if ~max_reached
                    set(app.STEP2, 'Value', min(get(app.STEP2, 'Value')+10, LSD.Nstep2));
                    graph_title = [WORKSPACE_PLOTTER_OOP.process_underscore(LSD.filename) ' - step2 n°' num2str(get(app.STEP2, 'Value')-1)];
                else
                    return;
                end         

            case 43 % + key
                nb_QPC=size(LSD.measure_dim.param_infos,2);
                max_reached=(get(app.MEASURE_LINE, 'Value')==nb_QPC);
                if ~max_reached
                    set(app.MEASURE_LINE, 'Value', get(app.MEASURE_LINE, 'Value')+1);
                    graph_title = [WORKSPACE_PLOTTER_OOP.process_underscore(LSD.filename) ' - step2 n°' num2str(get(app.STEP2, 'Value')-1)];
                    [~, cb_label]=LSD.measure_dim.build_dim_axis(get(app.MEASURE_LINE,'Value'));
                    set(app.plot2D.CBlabel,'String',cb_label);
                else
                    return;
                end  

            case 45 % - key
                min_reached=(get(app.MEASURE_LINE, 'Value')==1);
                if ~min_reached
                    set(app.MEASURE_LINE, 'Value', get(app.MEASURE_LINE, 'Value')-1);
                    graph_title = [WORKSPACE_PLOTTER_OOP.process_underscore(LSD.filename) ' - step2 n°' num2str(get(app.STEP2, 'Value')-1)];
                    [~, cb_label]=LSD.measure_dim.build_dim_axis(get(app.MEASURE_LINE,'Value'));
                    set(app.plot2D.CBlabel,'String',cb_label);
                else
                    return;
                end
                
            case 46 % . key
                deriv_on=(get(app.USING_DERIVATIVE, 'Value')==1);
                if deriv_on
                    set(app.USING_DERIVATIVE, 'Value', 0);
                    set(app.USING_RAWDATA, 'Value', 1);
                else
                    set(app.USING_DERIVATIVE, 'Value', 1);
                    set(app.USING_RAWDATA, 'Value', 0);
                end
                graph_title = get(app.plot2D.Title,'String');
            otherwise
                return;
        end
        M=app.extract_data_to_plot;
        assignin('base','M',M)
        graph_legend=app.build_graph_legend('step2','2D');
        set(app.plot2D.Title,'String',graph_title);
        set(app.plot2D.Legend,'String',graph_legend);
        app.plot2D.M=M;
        set(app.plot2D.Axes,'CData',M);
        drawnow;
        end

        function ReadKey_1D_plot(app,hObject,eventdata)
        % Interprets key presses from the Figure window.
        % When a key is pressed, interprets key and calls corresponding function.
        if WORKSPACE_PLOTTER_OOP.isMultipleCall()
            return;  
        end
        LSD=app.LOADED_SCAN_DATA;
        key=get(gcf,'CurrentCharacter');
        step_value=get(app.STEP_START,'value');

        switch key

            case 28 % left arrow
                min_reached=(step_value==1);
                if  min_reached
                    return;
                else
                    step_value=step_value-1;
                    set(app.STEP_START,'value',step_value);
                    set(app.STEP_STOP,'value',step_value);
                    graph_title = [WORKSPACE_PLOTTER_OOP.process_underscore(LSD.filename)  ' - step2 n°' num2str(get(app.STEP2, 'Value')-1) ' - step n°' num2str(step_value-1)];
                end

            case 29 % right arrow
                max_reached=(step_value==LSD.Nstep);
                if  max_reached
                    return;
                else
                    step_value=step_value+1;
                    set(app.STEP_START,'value',step_value);
                    set(app.STEP_STOP,'value',step_value);
                    graph_title = [WORKSPACE_PLOTTER_OOP.process_underscore(LSD.filename)  ' - step2 n°' num2str(get(app.STEP2, 'Value')-1) ' - step n°' num2str(step_value-1)];
                end

            case 30 % up arrow
                if  get(app.STEP2, 'Value')~=LSD.Nstep2  
                    set(app.STEP2, 'Value', min(get(app.STEP2, 'Value')+1, LSD.Nstep2));
                    graph_title = [WORKSPACE_PLOTTER_OOP.process_underscore(LSD.filename)  ' - step2 n°' num2str(get(app.STEP2, 'Value')-1) ' - step n°' num2str(step_value-1)];
                    [M]=app.extract_data_to_plot;
                    graph_legend=app.build_graph_legend('step','1D');
                    app.plot1D=fancy_plot(1,app.plot1D.X,M,'Xlabel',get(app.plot1D.Xlabel,'string'),'Ylabel',get(app.plot1D.Ylabel,'string'),'Title',graph_title,'Legend',graph_legend);
                    set(app.plot1D.figID,'name','1D PLOT');
                    set(gcf,'KeyPressFcn',@app.ReadKey_1D_plot);
                    set(gca,'Xlim',[min(app.plot1D.X) max(app.plot1D.X)]);
                end
                return;

            case 31 % down arrow
                if  get(app.STEP2, 'Value')~=1 
                    set(app.STEP2, 'Value', max(get(app.STEP2, 'Value')-1, 1));
                    graph_title = [WORKSPACE_PLOTTER_OOP.process_underscore(LSD.filename)  ' - step2 n°' num2str(get(app.STEP2, 'Value')-1) ' - step n°' num2str(step_value-1)];
                    [M]=app.extract_data_to_plot;
                    graph_legend=app.build_graph_legend('step','1D');
                    app.plot1D=fancy_plot(1,app.plot1D.X,M,'Xlabel',get(app.plot1D.Xlabel,'string'),'Ylabel',get(app.plot1D.Ylabel,'string'),'Title',graph_title,'Legend',graph_legend);
                    set(app.plot1D.figID,'name','1D PLOT');
                    set(gcf,'KeyPressFcn',@app.ReadKey_1D_plot);
                    set(gca,'Xlim',[min(app.plot1D.X) max(app.plot1D.X)]);
                end
                return;

            case 51 % 3 key
                max_reached=(step_value>(LSD.Nstep-10));
                if  max_reached
                    step_value=LSD.Nstep;
                else
                    step_value=step_value+10;
                end
                set(app.STEP_START,'value',step_value);
                set(app.STEP_STOP,'value',step_value);
                graph_title = [WORKSPACE_PLOTTER_OOP.process_underscore(LSD.filename)  ' - step2 n°' num2str(get(app.STEP2, 'Value')-1) ' - step n°' num2str(step_value-1)];

            case 49 % 1 key
                min_reached=(step_value<=11);
                if  min_reached
                    step_value=1;
                else
                    step_value=step_value-10;
                end
                set(app.STEP_START,'value',step_value);
                set(app.STEP_STOP,'value',step_value);
                graph_title = [WORKSPACE_PLOTTER_OOP.process_underscore(LSD.filename)  ' - step2 n°' num2str(get(app.STEP2, 'Value')-1) ' - step n°' num2str(step_value-1)];
                

            case 53 % 5 key
                if  get(app.STEP2, 'Value')<LSD.Nstep2 
                    set(app.STEP2, 'Value', min(get(app.STEP2, 'Value')+10, LSD.Nstep2));
                    graph_title = [WORKSPACE_PLOTTER_OOP.process_underscore(LSD.filename)  ' - step2 n°' num2str(get(app.STEP2, 'Value')-1) ' - step n°' num2str(step_value-1)];
                    [M]=app.extract_data_to_plot;
                    graph_legend=app.build_graph_legend('step','1D');
                    app.plot1D=fancy_plot(1,app.plot1D.X,M,'Xlabel',get(app.plot1D.Xlabel,'string'),'Ylabel',get(app.plot1D.Ylabel,'string'),'Title',graph_title,'Legend',graph_legend);
                    set(app.plot1D.figID,'name','1D PLOT');
                    set(gcf,'KeyPressFcn',@app.ReadKey_1D_plot);
                    set(gca,'Xlim',[min(app.plot1D.X) max(app.plot1D.X)]);
                end
                return;

            case 50 % 2 key
                if  get(app.STEP2, 'Value')~=1 
                    set(app.STEP2, 'Value', max(get(app.STEP2, 'Value')-10, 1));
                    graph_title = [WORKSPACE_PLOTTER_OOP.process_underscore(LSD.filename)  ' - step2 n°' num2str(get(app.STEP2, 'Value')-1) ' - step n°' num2str(step_value-1)];
                    [M]=app.extract_data_to_plot;
                    graph_legend=app.build_graph_legend('step','1D');
                    app.plot1D=fancy_plot(1,app.plot1D.X,M,'Xlabel',get(app.plot1D.Xlabel,'string'),'Ylabel',get(app.plot1D.Ylabel,'string'),'Title',graph_title,'Legend',graph_legend);
                    set(app.plot1D.figID,'name','1D PLOT');
                    set(gcf,'KeyPressFcn',@app.ReadKey_1D_plot);
                    set(gca,'Xlim',[min(app.plot1D.X) max(app.plot1D.X)]);
                end
                return;

            case 43 % + key
                nb_QPC=size(LSD.measure_dim.param_infos,2);
                max_reached=(get(app.MEASURE_LINE, 'Value')==nb_QPC);
                if ~max_reached
                    set(app.MEASURE_LINE, 'Value', get(app.MEASURE_LINE, 'Value')+1);
                    graph_title = [WORKSPACE_PLOTTER_OOP.process_underscore(LSD.filename)  ' - step2 n°' num2str(get(app.STEP2, 'Value')-1) ' - step n°' num2str(step_value-1)];
                    [M]=app.extract_data_to_plot;
                    graph_legend=app.build_graph_legend('step','1D');
                    [~, Y_label]=LSD.measure_dim.build_dim_axis(get(app.MEASURE_LINE,'value'));
                    app.plot1D=fancy_plot(1,app.plot1D.X,M,'Xlabel',get(app.plot1D.Xlabel,'string'),'Ylabel',Y_label,'Title',graph_title,'Legend',graph_legend);
                    set(app.plot1D.figID,'name','1D PLOT');
                    set(gcf,'KeyPressFcn',@app.ReadKey_1D_plot);
                    set(gca,'Xlim',[min(app.plot1D.X) max(app.plot1D.X)]);
                end  
                return;

            case 45 % - key
                min_reached=(get(app.MEASURE_LINE, 'Value')==1);
                if ~min_reached
                    set(app.MEASURE_LINE, 'Value', get(app.MEASURE_LINE, 'Value')-1);
                    graph_title = [WORKSPACE_PLOTTER_OOP.process_underscore(LSD.filename)  ' - step2 n°' num2str(get(app.STEP2, 'Value')-1) ' - step n°' num2str(step_value-1)];
                    [M]=app.extract_data_to_plot;
                    graph_legend=app.build_graph_legend('step','1D');
                    [~, Y_label]=LSD.measure_dim.build_dim_axis(get(app.MEASURE_LINE,'value'));
                    app.plot1D=fancy_plot(1,app.plot1D.X,M,'Xlabel',get(app.plot1D.Xlabel,'string'),'Ylabel',Y_label,'Title',graph_title,'Legend',graph_legend);
                    set(app.plot1D.figID,'name','1D PLOT');
                    set(gcf,'KeyPressFcn',@app.ReadKey_1D_plot);
                    set(gca,'Xlim',[min(app.plot1D.X) max(app.plot1D.X)]);
                end
                return;
                
            case 48 % 0 key
                set(app.STEP_START,'value',1);
                set(app.STEP_STOP,'value',LSD.Nstep);
                graph_title = [WORKSPACE_PLOTTER_OOP.process_underscore(LSD.filename)  ' - step2 n°' num2str(get(app.STEP2, 'Value')-1) ' - all steps'];
                [M]=app.extract_data_to_plot;
                graph_legend=app.build_graph_legend('step','1D');
                app.plot1D=fancy_plot(1,app.plot1D.X,M,'Xlabel',get(app.plot1D.Xlabel,'string'),'Ylabel',get(app.plot1D.Ylabel,'string'),'Title',graph_title,'Legend',graph_legend);
                set(app.plot1D.figID,'name','1D PLOT');
                set(gcf,'KeyPressFcn',@app.ReadKey_1D_plot);
                set(gca,'Xlim',[min(app.plot1D.X) max(app.plot1D.X)]);
                return;
                
            case 46 % . key
                deriv_on=(get(app.USING_DERIVATIVE, 'Value')==1);
                if deriv_on
                    set(app.USING_DERIVATIVE, 'Value', 0);
                    set(app.USING_RAWDATA, 'Value', 1);
                else
                    set(app.USING_DERIVATIVE, 'Value', 1);
                    set(app.USING_RAWDATA, 'Value', 0);
                end
                graph_title = get(app.plot1D.Title,'string');
                [M]=app.extract_data_to_plot;
                graph_legend=app.build_graph_legend('step','1D');
                app.plot1D=fancy_plot(1,app.plot1D.X,M,'Xlabel',get(app.plot1D.Xlabel,'string'),'Ylabel',get(app.plot1D.Ylabel,'string'),'Title',graph_title,'Legend',graph_legend);
                set(app.plot1D.figID,'name','1D PLOT');
                set(gcf,'KeyPressFcn',@app.ReadKey_1D_plot);
                set(gca,'Xlim',[min(app.plot1D.X) max(app.plot1D.X)]);
                return;
            otherwise
                return;
        end 
        Y=app.extract_data_to_plot;
        graph_legend=app.build_graph_legend('step','1D');
        set(app.plot1D.Title,'string',graph_title);
        set(app.plot1D.Legend,'string',graph_legend);
        app.plot1D.Y=Y;
        if iscell(get(app.plot1D.Axes,'YData'))
            app.plot1D=fancy_plot(1,app.plot1D.X,Y,'Xlabel',get(app.plot1D.Xlabel,'string'),'Ylabel',get(app.plot1D.Ylabel,'string'),'Title',graph_title,'Legend',graph_legend);
            set(gca,'Xlim',[min(app.plot1D.X) max(app.plot1D.X)]);
        else
            set(app.plot1D.Axes,'YData',Y);
            drawnow;
        end
        end

        function ReadKey_1D_average(app,hObject,eventdata,Average,dim)
        % Interprets key presses from the Figure window.
        % When a key is pressed, interprets key and calls corresponding function.
        if WORKSPACE_PLOTTER_OOP.isMultipleCall()
            return;  
        end
        LSD=app.LOADED_SCAN_DATA;
        key=get(gcf,'CurrentCharacter');

        step_value=get(app.STEP_START,'value');
        step2_value=get(app.STEP2,'value');

        switch key

            case 28 % left arrow
                if strcmp(dim,'step2')
                    min_reached=(step_value==1);
                    if  min_reached
                        return;
                    end
                    step_value=step_value-1;
                    set(app.STEP_START,'value',step_value);
                    set(app.STEP_STOP,'value',step_value);
                    graph_title = [WORKSPACE_PLOTTER_OOP.process_underscore(LSD.filename) ' - ' dim ' Averaged - step n°' num2str(step_value-1)];
                    Y=Average(:,step_value);
                else
                    min_reached=(step2_value==1);
                    if  min_reached
                        return;
                    end
                    step2_value=step2_value-1;
                    set(app.STEP2,'value',step2_value);
                    graph_title = [WORKSPACE_PLOTTER_OOP.process_underscore(LSD.filename) ' - ' dim ' Averaged - step2 n°' num2str(step2_value-1)];
                    Y=Average(:,step2_value);
                end

            case 29 % right arrow

                if strcmp(dim,'step2')
                    max_reached=(step_value==LSD.Nstep);
                    if  max_reached
                        return;
                    end
                    step_value=step_value+1;
                    set(app.STEP_START,'value',step_value);
                    set(app.STEP_STOP,'value',step_value);
                    graph_title = [WORKSPACE_PLOTTER_OOP.process_underscore(LSD.filename) ' - ' dim ' Averaged - step n°' num2str(step_value-1)];
                    Y=Average(:,step_value);
                else
                    max_reached=(step2_value==LSD.Nstep2);
                    if  max_reached
                        return;
                    end
                    step2_value=step2_value+1;
                    set(app.STEP2,'value',step2_value);
                    graph_title = [WORKSPACE_PLOTTER_OOP.process_underscore(LSD.filename) ' - ' dim ' Averaged - step2 n°' num2str(step2_value-1)];
                    Y=Average(:,step2_value);
                end

            case 49 % 1 key

                if strcmp(dim,'step2')
                    min_reached=(step_value<=10);
                    if min_reached
                        step_value=1;
                    else
                        step_value=step_value-10;
                    end
                    set(app.STEP_START,'value',step_value);
                    set(app.STEP_STOP,'value',step_value);
                    graph_title = [WORKSPACE_PLOTTER_OOP.process_underscore(LSD.filename) ' - ' dim ' Averaged - step n°' num2str(step_value-1)];
                    Y=Average(:,step_value);
                else
                    min_reached=(step2_value<=10);
                    if min_reached
                        step2_value=1;
                    else
                        step2_value=step2_value-10;
                    end
                    set(app.STEP2,'value',step2_value);
                    graph_title = [WORKSPACE_PLOTTER_OOP.process_underscore(LSD.filename) ' - ' dim ' Averaged - step2 n°' num2str(step2_value-1)];
                    Y=Average(:,step2_value);
                end

            case 51 % 3 key

                if strcmp(dim,'step2')
                    max_reached=(step_value>=LSD.Nstep-10);
                    if  max_reached
                        step_value=LSD.Nstep;
                    else
                        step_value=step_value+10;
                    end
                    set(app.STEP_START,'value',step_value);
                    set(app.STEP_STOP,'value',step_value);
                    graph_title = [WORKSPACE_PLOTTER_OOP.process_underscore(LSD.filename) ' - ' dim ' Averaged - step n°' num2str(step_value-1)];
                    Y=Average(:,step_value);
                else
                    max_reached=(step2_value>=LSD.Nstep2-10);
                    if  max_reached
                        step2_value=LSD.Nstep2;
                    else
                        step2_value=step2_value+10;
                    end
                    set(app.STEP2,'value',step2_value);
                    graph_title = [WORKSPACE_PLOTTER_OOP.process_underscore(LSD.filename) ' - ' dim ' Averaged - step2 n°' num2str(step2_value-1)];
                    Y=Average(:,step2_value);
                end
                
            case 48 % 0 key
                
                if strcmp(dim,'step2')
                    all_string='all steps';
                    set(app.STEP_START,'value',1);
                    set(app.STEP_STOP,'value',LSD.Nstep);
                    graph_legend=app.build_graph_legend('step','1D');
                else
                    all_string='all step2';
                    graph_legend=app.build_graph_legend('step','2D');
                end
                graph_title = [WORKSPACE_PLOTTER_OOP.process_underscore(LSD.filename) ' - ' dim ' Averaged - ' all_string];
                app.plotAverage=fancy_plot(6,app.plotAverage.X,Average,'Xlabel',get(app.plotAverage.Xlabel,'string'),'Ylabel',get(app.plotAverage.Ylabel,'string'),'Title',graph_title,'Legend',graph_legend);
                set(app.plotAverage.figID,'name','1D PLOT');
                set(gcf,'KeyPressFcn',{@app.ReadKey_1D_average,Average,dim});
                set(gca,'Xlim',[min(app.plotAverage.X) max(app.plotAverage.X)]);
                return;

            otherwise
                return;
        end

        if strcmp(dim,'step2')
            graph_legend=app.build_graph_legend('step','1D');
        else
            graph_legend=app.build_graph_legend('step','2D');
        end
        
        set(app.plotAverage.Title,'string',graph_title);
        set(app.plotAverage.Legend,'string',graph_legend);
        app.plotAverage.Y=Y;
        set(app.plotAverage.Axes,'YData',Y);
%         app.plotAverage.switch_YData(Y);
        drawnow;

        end
        
    end
    
    methods (Static)
        
        function [string_out] = process_underscore(string_in)
            % --- Replace _ by \_ for strings to be displayed correctly
            offset=0;
            string_length=size(string_in,2);
            string_out='';
            for i = 1:string_length
                if string_in(i)=='_'
                   string_out(i+offset) = '\';
                   string_out(i+offset+1) = '_';
                   offset=offset+1;
                else
                   string_out(i+offset)=string_in(i);
                end
            end
        end
        
        function [ANSWER,CANCELED] = fancy_dialog
            Prompt = {
            '1xxx','N1xxx',[];
            '2xxx','N2xxx',[];
            '10xx','N10xx',[];
            '20xx','N20xx',[];
            '1000','N1000',[];
            '21xx','N21xx',[];
            '1001','N1001',[];
            '2000','N2000',[];
            '2001','N2001',[];
            '2002','N2002',[];
            '2100','N2100',[];
            'Nbad','Nbad',[];
            '2101','N2101',[];
            '210xxx','N210xxx',[];
            '210012','N210012',[];};
            check_cell=cell(10,2);
            check_cell(:)={'check'};
            check_cell([5 6 7 9 10])={'none'};
            Formats = struct('type',check_cell);
            [ANSWER,CANCELED] = inputsdlg(Prompt,'What to plot',Formats);
        end
        
        function [flag]=isMultipleCall()
              flag = false; 
              % Get the stack
              s = dbstack();
              if numel(s)<=2
                % Stack too short for a multiple call
                return
              end
              % How many calls to the calling function are in the stack?
              names = {s(:).name};
              TF = strcmp(s(2).name,names);
              count = sum(TF);
              if count>1
                % More than 1
                flag = true; 
              end
        end
        
        
    end
    
    
end

