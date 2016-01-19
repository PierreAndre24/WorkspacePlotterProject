classdef Spin_Plot < handle
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        
        hfig
        
        axes1
        RAW_DATA
        DERIVATIVE
        THRESHOLD_MODE
        EDGE_MODE
        X_MIN
        X_MAX
        Y_MIN
        Y_MAX
        PLOT_RATIO
        PRINT_FIG_1
        
        hcurs1
        INTERVAL_CURSOR_1
        hcurs2
        INTERVAL_CURSOR_2
        hcursth
        THRESHOLD_CURSOR
        DISPLAY_THRESHOLD
        
        FILTER_ON
        FILTER_OFF
        MAX_EVENTS_TOL
        MIN_EVENTS_TOL
        POSTSEL
        LOAD_POSTSEL

        axes2
        T1_PLOT
        HISTOGRAM_PLOT
        REVERT
        N_BIN
        PRINT_FIG_2

        MEASURE_LINE
        STEP2_START
        STEP2_STOP
        LOAD
        RUN
        AUTO_REFRESH
        EXPORT
        FILENAME
        DIALOG_BOX      

        LSD
        Selected_data
        Timeaxis
        Tload
        Tload_label
        PostSel
        Proba
        Norm
        Err
        Toff
        Tdwell
        Ndwell
        Edge_threshold
        
    end
    
    methods
        function [app] = Spin_Plot(varargin)
                   
            % Creating main figure

            app.hfig = figure(...
            'Units','normalized',...
            'PaperUnits',get(0,'defaultfigurePaperUnits'),...
            'Color',[0.941176470588235 0.941176470588235 0.941176470588235],...
            'Colormap',[0 0 0.5625;0 0 0.625;0 0 0.6875;0 0 0.75;0 0 0.8125;0 0 0.875;0 0 0.9375;0 0 1;0 0.0625 1;0 0.125 1;0 0.1875 1;0 0.25 1;0 0.3125 1;0 0.375 1;0 0.4375 1;0 0.5 1;0 0.5625 1;0 0.625 1;0 0.6875 1;0 0.75 1;0 0.8125 1;0 0.875 1;0 0.9375 1;0 1 1;0.0625 1 1;0.125 1 0.9375;0.1875 1 0.875;0.25 1 0.8125;0.3125 1 0.75;0.375 1 0.6875;0.4375 1 0.625;0.5 1 0.5625;0.5625 1 0.5;0.625 1 0.4375;0.6875 1 0.375;0.75 1 0.3125;0.8125 1 0.25;0.875 1 0.1875;0.9375 1 0.125;1 1 0.0625;1 1 0;1 0.9375 0;1 0.875 0;1 0.8125 0;1 0.75 0;1 0.6875 0;1 0.625 0;1 0.5625 0;1 0.5 0;1 0.4375 0;1 0.375 0;1 0.3125 0;1 0.25 0;1 0.1875 0;1 0.125 0;1 0.0625 0;1 0 0;0.9375 0 0;0.875 0 0;0.8125 0 0;0.75 0 0;0.6875 0 0;0.625 0 0;0.5625 0 0],...
            'IntegerHandle','off',...
            'Name','SpinPlot',...
            'NumberTitle','off',...
            'WindowStyle','normal',...
            'Position',[0.1 0.1 0.8 0.8],...
            'Tag','Spin_Plot_fig',...
            'Visible','on');

            % Creating axes2 panel

            h2 = uipanel(...
            'Parent',app.hfig,...
            'Units','normalized',...
            'FontSize',10,...
            'FontWeight','bold',...
            'Title','Graph 2',...
            'Tag','uipanel11',...
            'Clipping','on',...
            'Position',[0.505 0.45 0.485 0.54]);

            % Creating axes2

            app.axes2 = axes(...
            'Parent',h2,...
            'Units','normalized',...
            'Position',[0.1 0.15 0.8 0.7],...
            'Tag','axes2');

            % creating 'Print to Fig2' button

            app.PRINT_FIG_2 = uicontrol(...
            'Parent',h2,...
            'Units','normalized',...
            'Callback',@app.PRINT_FIG_2_Callback,...
            'FontWeight','bold',...
            'Position',[0.4 0.9 0.2 0.05],...
            'String','Print to Figure',...
            'Tag','PRINT_FIG_2' );

            % Creating 'T1_PLOT' radio button

            app.T1_PLOT = uicontrol(...
            'Parent',h2,...
            'Units','normalized',...
            'Callback',@app.T1_PLOT_Callback,...
            'Position',[0.7 0.95 0.25 0.05],...
            'String','Excited state proba vs. Tload',...
            'Style','radiobutton',...
            'Tag','T1_PLOT' );

            % Creating 'HISTOGRAM_PLOT' radio button

            app.HISTOGRAM_PLOT = uicontrol(...
            'Parent',h2,...
            'Units','normalized',...
            'Callback',@app.HISTOGRAM_PLOT_Callback,...
            'Position',[0.7 0.9 0.25 0.05],...
            'String','Tunneling time histogram',...
            'Style','radiobutton',...
            'Tag','HISTOGRAM_PLOT');
        
            % Creating 'REVERT' radio button
            
            app.REVERT = uicontrol(...
            'Parent',h2,...
            'Units','normalized',...
            'Callback',@app.REVERT_Callback,...
            'Position',[0.05 0.05 0.15 0.05],...
            'String','Revert Proba',...
            'Style','radiobutton',...
            'Enable', 'on',...
            'Tag','REVERT' );

            % Creating 'N_BIN' edit text

            app.N_BIN = uicontrol(...
            'Parent',h2,...
            'BackgroundColor',[1 1 1],...
            'Units','normalized',...
            'Callback',@app.N_BIN_Callback,...
            'Position',[0.94 0.05 0.05 0.05],...
            'String','Nbin',...
            'Style','edit',...
            'Tag','N_BIN');

            % Creating 'N_BIN' text 

            uicontrol(...
            'Parent',h2,...
            'Units','normalized',...
            'FontWeight','bold',...
            'Position',[0.94 0.1 0.05 0.03],...
            'String','Nbin',...
            'Style','text',...
            'Tag','text22');

            % Creating 'Info' panel

            h13 = uibuttongroup(...
            'Parent',app.hfig,...
            'Units','normalized',...
            'FontWeight','bold',...
            'Title','Info:',...
            'Tag','uipanel3',...
            'Clipping','on',...
            'Position',[0.8 0.325 0.19 0.1]);

            % text line 1

            uicontrol(...
            'Parent',h13,...
            'Units','normalized',...
            'FontAngle','italic',...
            'Position',[0.05 0.44 0.85 0.4],...
            'String','event <=> (data value > Ith) in Raw data mode',...
            'Style','text',...
            'Tag','text20' );

            % text line 2

            uicontrol(...
            'Parent',h13,...
            'Units','normalized',...
            'FontAngle','italic',...
            'Position',[0.05 0.04 0.85 0.4],...
            'String','event <=> (data value > |Ith|) in Derivative mode',...
            'Style','text',...
            'Tag','text21' );

            % Creating Thresholds panel

            h16 = uibuttongroup(...
            'Parent',app.hfig,...
            'Units','normalized',...
            'FontWeight','bold',...
            'Title','Threshold Setting',...
            'Tag','uipanel8',...
            'Clipping','on',...
            'Position',[0.01 0.25 0.5 0.2]);

            % Creating 'Ith' text

            uicontrol(...
            'Parent',h16,...
            'Units','normalized',...
            'FontWeight','bold',...
            'Position',[0.94 0.9 0.05 0.1],...
            'String','I_th',...
            'Style','text',...
            'Tag','text14' );

            % Creating 'Interval 1' Slider

            app.INTERVAL_CURSOR_1 = uicontrol(...
            'Parent',h16,...
            'Units','normalized',...
            'BackgroundColor',[0.9 0.9 0.9],...
            'Callback',@app.INTERVAL_CURSOR_1_Callback,...
            'Position',[0.08 0.6 0.82 0.2],...
            'String','CursorInt1',...
            'Style','slider',...
            'Tag','INTERVAL_CURSOR_1');

            % Creating 'Interval 2' Slider

            app.INTERVAL_CURSOR_2 = uicontrol(...
            'Parent',h16,...
            'Units','normalized',...
            'BackgroundColor',[0.9 0.9 0.9],...
            'Callback',@app.INTERVAL_CURSOR_2_Callback,...
            'Position',[0.08 0.2 0.82 0.2],...
            'String','CursorInt2',...
            'Style','slider',...
            'Tag','INTERVAL_CURSOR_2');

            % Creating 'Threshold' Slider

            app.THRESHOLD_CURSOR = uicontrol(...
            'Parent',h16,...
            'Units','normalized',...
            'BackgroundColor',[0.9 0.9 0.9],...
            'Callback',@app.THRESHOLD_CURSOR_Callback,...
            'Position',[0.94 0.02 0.05 0.75],...
            'String','CursorTh',...
            'Style','slider',...
            'Tag','THRESHOLD_CURSOR');

            % Creating 'Threshold' edit text

            app.DISPLAY_THRESHOLD = uicontrol(...
            'Parent',h16,...
            'Units','normalized',...
            'BackgroundColor',[1 1 1],...
            'Callback',@app.DISPLAY_THRESHOLD_Callback,...
            'Position',[0.94 0.78 0.05 0.15],...
            'String','Ith value',...
            'Style','edit',...
            'Tag','DisplayThreshold');

            % Creating 'Run' panel

            h22 = uibuttongroup(...
            'Parent',app.hfig,...
            'Units','normalized',...
            'Title',blanks(0),...
            'Tag','uipanel9',...
            'Clipping','on',...
            'Position',[0.52 0.02 0.16 0.28]);

            % Creating 'RUN' button

            app.RUN = uicontrol(...
            'Parent',h22,...
            'Units','normalized',...
            'Callback',@app.RUN_Callback,...
            'FontWeight','bold',...
            'Position',[0.3 0.55 0.4 0.15],...
            'String','RUN',...
            'Tag','RUN');

            % Creating 'LOAD' button

            app.LOAD = uicontrol(...
            'Parent',h22,...
            'Units','normalized',...
            'Callback',@app.LOAD_Callback,...
            'FontWeight','bold',...
            'Position',[0.3 0.75 0.4 0.15],...
            'String','LOAD',...
            'Tag','LOAD');

            % Creating 'EXPORT' button

            app.EXPORT = uicontrol(...
            'Parent',h22,...
            'Units','normalized',...
            'Callback',@app.EXPORT_Callback,...
            'FontWeight','bold',...
            'Position',[0.25 0.25 0.5 0.1],...
            'String','Export to Workspace',...
            'Tag','EXPORT');

            % Creating 'AUTO_REFRESH' checkbox

            app.AUTO_REFRESH = uicontrol(...
            'Parent',h22,...
            'Units','normalized',...
            'Callback',@app.AUTO_REFRESH_Callback,...
            'Position',[0.28 0.44 0.45 0.1],...
            'String','Auto Refresh',...
            'Style','checkbox',...
            'Tag','AUTO_REFRESH');

            % Creating 'Filename' text

            uicontrol(...
            'Parent',h22,...
            'Units','normalized',...
            'Position',[0.05 0.1 0.2 0.1],...
            'String','Filename:',...
            'Style','text',...
            'Tag','text19' );

            % Creating 'FILENAME' edit text

            app.FILENAME = uicontrol(...
            'Parent',h22,...
            'Units','normalized',...
            'BackgroundColor',[1 1 1],...
            'Callback',@app.FILENAME_Callback,...
            'Position',[0.25 0.12 0.5 0.1],...
            'String','enter filename',...
            'Style','edit',...
            'Tag','FILENAME');

            % Creating 'axes1' panel

            h29 = uipanel(...
            'Parent',app.hfig,...
            'Units','normalized',...
            'FontSize',10,...
            'FontWeight','bold',...
            'Title','Graph 1',...
            'Tag','uipanel12',...
            'Clipping','on',...
            'Position',[0.01 0.45 0.485 0.54] );

            % Creating 'RAW_DATA' radio button

            app.RAW_DATA = uicontrol(...
            'Parent',h29,...
            'Units','normalized',...
            'Callback',@app.RAW_DATA_Callback,...
            'Position',[0.8 0.95 0.15 0.05],...
            'String','Using Raw Data',...
            'Style','radiobutton',...
            'Tag','RAW_DATA');

            % Creating 'DERIVATIVE' radio button

            app.DERIVATIVE = uicontrol(...
            'Parent',h29,...
            'Units','normalized',...
            'Callback',@app.DERIVATIVE_Callback,...
            'Position',[0.8 0.9 0.15 0.05],...
            'String','Using Derivative',...
            'Style','radiobutton',...
            'Tag','DERIVATIVE');
        
            % Creating 'THRESHOLD MODE' checkbox

            app.THRESHOLD_MODE = uicontrol(...
            'Parent',h29,...
            'Units','normalized',...
            'Callback',@app.THRESHOLD_MODE_Callback,...
            'Position',[0.12 0.95 0.2 0.05],...
            'String','Threshold mode',...
            'Style','checkbox',...
            'Value', 1,...
            'Tag','THRESHOLD_MODE');
        
            % Creating 'EDGE DETECTION MODE' checkbox

            app.EDGE_MODE = uicontrol(...
            'Parent',h29,...
            'Units','normalized',...
            'Callback',@app.EDGE_MODE_Callback,...
            'Position',[0.12 0.9 0.2 0.05],...
            'String','Edge Detection mode',...
            'Style','checkbox',...
            'Value', 0,...
            'Tag','EDGE_MODE');      

            % Creating 'axes1'

            app.axes1 = axes(...
            'Parent',h29,...
            'Units','normalized',...
            'Position',[0.1 0.15 0.8 0.7],...
            'Tag','axes1');

            % Creating 'PRINT_FIG_1' button

            app.PRINT_FIG_1 = uicontrol(...
            'Parent',h29,...
            'Units','normalized',...
            'Callback',@app.PRINT_FIG_1_Callback,...
            'FontWeight','bold',...
            'Position',[0.4 0.9 0.2 0.05],...
            'String','Print to Figure',...
            'Tag','PRINT_FIG_1' );

            % Creating 'Y_MAX' edit text

            app.Y_MAX = uicontrol(...
            'Parent',h29,...
            'Units','normalized',...
            'BackgroundColor',[1 1 1],...
            'Callback',@app.Y_MAX_Callback,...
            'Position',[0.015 0.825 0.05 0.05],...
            'String','Y MAX',...
            'Style','edit',...
            'Tag','Y_MAX');

            % Creating 'Y_MIN' edit text 

            app.Y_MIN = uicontrol(...
            'Parent',h29,...
            'Units','normalized',...
            'BackgroundColor',[1 1 1],...
            'Callback',@app.Y_MIN_Callback,...
            'Position',[0.015 0.125 0.05 0.05],...
            'String','Y MIN',...
            'Style','edit',...
            'Tag','Y_MIN');

            % Creating 'X_MIN' edit text

            app.X_MIN = uicontrol(...
            'Parent',h29,...
            'Units','normalized',...
            'BackgroundColor',[1 1 1],...
            'Callback',@app.X_MIN_Callback,...
            'Position',[0.075 0.015 0.05 0.05],...
            'String','X MIN',...
            'Style','edit',...
            'Tag','X_MIN');

            % Creating 'X_MAX' edit text 

            app.X_MAX = uicontrol(...
            'Parent',h29,...
            'Units','normalized',...
            'BackgroundColor',[1 1 1],...
            'Callback',@app.X_MAX_Callback,...
            'Position',[0.875 0.015 0.05 0.05],...
            'String','X MAX',...
            'Style','edit',...
            'Tag','X_MAX');

            % Creating 'Y max' text

            uicontrol(...
            'Parent',h29,...
            'Units','normalized',...
            'FontWeight','bold',...
            'Position',[0.015 0.875 0.05 0.03],...
            'String','Ymax',...
            'Style','text',...
            'Tag','text15' );

            % Creating 'Y min' text

            uicontrol(...
            'Parent',h29,...
            'Units','normalized',...
            'FontWeight','bold',...
            'Position',[0.015 0.175 0.05 0.03],...
            'String','Ymin',...
            'Style','text',...
            'Tag','text16' );

            % Creating 'X min' text

            uicontrol(...
            'Parent',h29,...
            'Units','normalized',...
            'FontWeight','bold',...
            'Position',[0.075 0.065 0.05 0.03],...
            'String','Xmin',...
            'Style','text',...
            'Tag','text17');
        
            % Creating 'Xmax' text

            uicontrol(...
            'Parent',h29,...
            'Units','normalized',...
            'FontWeight','bold',...
            'Position',[0.875 0.065 0.05 0.03],...
            'String','Xmax',...
            'Style','text',...
            'Tag','text18');

            % Creating plot ratio text

            uicontrol(...
            'Parent',h29,...
            'Units','normalized',...
            'Position',[0.4 0.015 0.2 0.05],...
            'String','plot 1 out of                     step2',...
            'Style','text',...
            'Tag','text13' );

            % Creating 'PLOT_RATIO' edit text

            app.PLOT_RATIO = uicontrol(...
            'Parent',h29,...
            'Units','normalized',...
            'BackgroundColor',[1 1 1],...
            'Callback',@app.PLOT_RATIO_Callback,...
            'Position',[0.5 0.03 0.05 0.05],...
            'String','N',...
            'Style','edit',...
            'Tag','PLOT_RATIO');

            % Creating Step2 selection panel

            h48 = uipanel(...
            'Parent',app.hfig,...
            'Units','normalized',...
            'FontWeight','bold',...
            'Title','Step2 ',...
            'Tag','uipanel1',...
            'Clipping','on',...
            'Position',[0.52 0.325 0.25 0.1]);

            % Creating 'STEP2_START' pop up

            app.STEP2_START = uicontrol(...
            'Parent',h48,...
            'Units','normalized',...
            'BackgroundColor',[1 1 1],...
            'Callback',@app.STEP2_START_Callback,...
            'Position',[0.15 0.7 0.2 0.2],...
            'String',{  'Pop-up Menu' },...
            'Style','popupmenu',...
            'Value',1,...
            'Tag','STEP2_START');

            % Creating 'STEP2_STOP' pop up

            app.STEP2_STOP = uicontrol(...
            'Parent',h48,...
            'Units','normalized',...
            'BackgroundColor',[1 1 1],...
            'Callback',@app.STEP2_STOP_Callback,...
            'Position',[0.15 0.25 0.2 0.2],...
            'String',{  'Pop-up Menu' },...
            'Style','popupmenu',...
            'Value',1,...
            'Tag','STEP2_STOP');

            % Creating 'Stop' text

            uicontrol(...
            'Parent',h48,...
            'Units','normalized',...
            'Position',[0.03 0.65 0.1 0.2],...
            'String','Stop:',...
            'Style','text',...
            'Tag','text2' );

            % Creating 'Start' text

            uicontrol(...
            'Parent',h48,...
            'Units','normalized',...
            'Position',[0.03 0.2 0.1 0.2],...
            'String','Start:',...
            'Style','text',...
            'Tag','text1' );

            % Creating Switch Filter panel

            h53 = uipanel(...
            'Parent',app.hfig,...
            'Units','normalized',...
            'FontWeight','bold',...
            'Title','SWITCH FILTER',...
            'Tag','uipanel13',...
            'Clipping','on',...
            'Position',[0.01 0.02 0.5 0.23] );

            % Creating upper bound for filter text

            uicontrol(...
            'Parent',h53,...
            'Units','normalized',...
            'FontAngle','oblique',...
            'Position',[0.02 0.35 0.3 0.1],...
            'String','more than                         events per step2',...
            'Style','text',...
            'Tag','text24' );

            % Creating lower bound for filter text

            uicontrol(...
            'Parent',h53,...
            'Units','normalized',...
            'FontAngle','oblique',...
            'Position',[0.02 0.15 0.3 0.1],...
            'String','  less than                         events per step2',...
            'Style','text',...
            'Tag','text25' );

            % Creating 'MAX_EVENTS_TOL' edit text

            app.MAX_EVENTS_TOL = uicontrol(...
            'Parent',h53,...
            'Units','normalized',...
            'BackgroundColor',[1 1 1],...
            'Callback',@app.MAX_EVENTS_TOL_Callback,...
            'Position',[0.12 0.37 0.05 0.1],...
            'String','15',...
            'Enable', 'off',...
            'Style','edit','Tag','MAX_EVENTS_TOL');

            % Creating 'MIN_EVENTS_TOL' edit text

            app.MIN_EVENTS_TOL = uicontrol(...
            'Parent',h53,...
            'Units','normalized',...
            'BackgroundColor',[1 1 1],...
            'Callback',@app.MIN_EVENTS_TOL_Callback,...
            'Position',[0.12 0.17 0.05 0.1],...
            'String','0',...
            'Style','edit',...
            'Enable', 'off',...
            'Tag','MIN_EVENTS_TOL');

            % Creating 'FILTER_ON' edit text

            app.FILTER_ON = uicontrol(...
            'Parent',h53,...
            'Units','normalized',...
            'Callback',@app.FILTER_ON_Callback,...
            'Position',[0.05 0.8 0.1 0.1],...
            'String','ON',...
            'Style','radiobutton',...
            'Enable', 'off',...
            'Tag','FILTER_ON' );

            % Creating 'FILTER_OFF' radio button

            app.FILTER_ON = uicontrol(...
            'Parent',h53,...
            'Units','normalized',...
            'Callback',@app.FILTER_OFF_Callback,...
            'Position',[0.05 0.65 0.1 0.1],...
            'String','OFF',...
            'Style','radiobutton',...
            'Enable', 'off',...
            'Tag','FILTER_OFF' );
        
            % Creating 'POSTSEL' button

            app.POSTSEL = uicontrol(...
            'Parent',h53,...
            'Units','normalized',...
            'Callback',@app.POSTSEL_Callback,...
            'FontWeight','bold',...
            'Position',[0.75 0.7 0.14 0.18],...
            'String',' POST SEL.',...
            'Tag','POSTSEL' );
        
            % Creating 'POSTSEL' button

            app.LOAD_POSTSEL = uicontrol(...
            'Parent',h53,...
            'Units','normalized',...
            'Callback',@app.LOAD_POSTSEL_Callback,...
            'FontWeight','bold',...
            'Position',[0.75 0.48 0.14 0.18],...
            'String',' LOAD POSTSEL',...
            'Tag','LOAD_POSTSEL' );

            % Creating 'DIALOG_BOX' text box

            app.DIALOG_BOX = uicontrol(...
            'Parent',app.hfig,...
            'Units','normalized',...
            'BackgroundColor',[1 1 1],...
            'Callback',@app.DIALOG_BOX_Callback,...
            'HorizontalAlignment','left',...
            'Max',10,...
            'Position',[0.7 0.02 0.29 0.28],...
            'String',blanks(0),...
            'Style','text','Tag','DIALOG_BOX');

            % Creating 'MEASURE_LINE' pop up

            app.MEASURE_LINE = uicontrol(...
            'Parent',h48,...
            'Units','normalized',...
            'BackgroundColor',[1 1 1],...
            'Callback',@app.MEASURE_LINE_Callback,...
            'Position',[0.55 0.4 0.4 0.2],...
            'String','Measure Line',...
            'Style','popupmenu',...
            'Value',1,...
            'Tag','MEASURE_LINE');

            % Creating measure line text

            uicontrol(...
            'Parent',h48,...
            'Units','normalized',...
            'Position',[0.55 0.6 0.4 0.2],...
            'String','Measure Line',...
            'Style','text',...
            'Tag','text27' );
        
            set(app.hfig,'Toolbar','figure');  % Display the standard toolbar
        
            set(app.DIALOG_BOX,'string', 'MESSAGES:');
            dialog=get(app.DIALOG_BOX,'string');
            set(app.DIALOG_BOX,'string', {dialog, ''});
            set(app.T1_PLOT,'Value', 1);
            set(app.HISTOGRAM_PLOT,'Value', 0);
            set(app.RAW_DATA,'Value', 1);
            set(app.DERIVATIVE,'Value', 0);
            set(app.N_BIN,'String',num2str(20));
            set(app.PLOT_RATIO,'String', num2str(10));
            set(app.AUTO_REFRESH,'Value', 1);
            set(app.FILTER_ON,'Value', 0);
            set(app.FILTER_OFF,'Value', 1);
            set(app.MAX_EVENTS_TOL,'String', num2str(15));
            set(app.MIN_EVENTS_TOL,'String', num2str(0));
        
            p = inputParser;
            defaultLoad_Manager_Object=-1;
            defaultPostSel=-1;
            addOptional(p,'data',defaultLoad_Manager_Object);
            addOptional(p,'PostSel',defaultPostSel);
            parse(p,varargin{:});
            
            app.LSD=p.Results.data;
            app.PostSel=p.Results.PostSel;
            if app.LSD==-1
                return
            else
                if app.PostSel==-1
                    app.PostSel=ones(app.LSD.Nstep,app.LSD.Nstep2);
                    app.add_line_to_dialog('WARNING: No PostSel matrix found in the argument list - all curves are kept by default');
                end
                if evalin('base','exist(''Tload'',''var'')')==1
                    app.Tload=evalin('base','Tload');
                else
                    app.Tload=app.LSD.step_dim.param_values';
                    if size(app.Tload,2)>1
                        f=figure;
                        Tload_table=uitable('Parent',f,'Units','normalized','Position',[0.05 0.1 0.88 0.8]);
                        set(Tload_table,'Data',app.Tload);
                        prompt = {'Select column to use for Tload?'};
                        dlg_title = 'enter column number';
                        num_lines= 1;
                        def     = {'1'};
                        values  = inputdlg(prompt,dlg_title,num_lines,def);
                        app.Tload=app.Tload(:,str2double(values(1)));
                        close(f);
                    end
                end

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
                Tmin=min(app.Timeaxis);
                Tmax=max(app.Timeaxis);
                set(app.axes1,'xlim',[Tmin Tmax]);
                set(app.X_MAX,'String',num2str(Tmax));
                set(app.X_MIN,'String',num2str(Tmin));

                Step2String=1:app.LSD.Nstep2;
                set(app.STEP2_START,'String', Step2String);
                set(app.STEP2_START,'Value', 1);
                set(app.STEP2_STOP,'String', Step2String);
                set(app.STEP2_STOP,'Value', app.LSD.Nstep2);
                MeasurelineString=1:app.LSD.Nmeasure;
                set(app.MEASURE_LINE,'String', MeasurelineString);
                set(app.MEASURE_LINE,'Value', 1);

                init_value_IntCursor1=1;
                set(app.INTERVAL_CURSOR_1,'Min',1);
                set(app.INTERVAL_CURSOR_1,'Max',app.LSD.Nsweep);
                set(app.INTERVAL_CURSOR_1,'Value',init_value_IntCursor1);
                set(app.INTERVAL_CURSOR_1,'SliderStep',[1/(app.LSD.Nsweep-1) 20/(app.LSD.Nsweep-1)]);

                init_value_IntCursor2=app.LSD.Nsweep;
                set(app.INTERVAL_CURSOR_2,'Min',1);
                set(app.INTERVAL_CURSOR_2,'Max',init_value_IntCursor2);
                set(app.INTERVAL_CURSOR_2,'Value',init_value_IntCursor2);
                set(app.INTERVAL_CURSOR_2,'SliderStep',[1/(app.LSD.Nsweep-1) 20/(app.LSD.Nsweep-1)]);

                Imax=max(max(max(app.LSD.data(:,:,:,get(app.MEASURE_LINE,'Value')))));
                Imin=min(min(min(app.LSD.data(:,:,:,get(app.MEASURE_LINE,'Value')))));
                set(app.axes1,'ylim',[Imin Imax]);
                set(app.Y_MAX,'String',num2str(Imax));
                set(app.Y_MIN,'String',num2str(Imin));
                set(app.THRESHOLD_CURSOR,'Min',Imin);
                set(app.THRESHOLD_CURSOR,'Max',Imax);
                set(app.THRESHOLD_CURSOR,'Value',(Imax+Imin)/2);
                set(app.THRESHOLD_CURSOR,'SliderStep',[0.005 0.02]);
                set(app.DISPLAY_THRESHOLD,'String',num2str((Imax+Imin)/2));

                set(app.FILENAME,'string',Load_Manager.remove_path(Load_Manager.remove_extension(app.LSD.filename)));

                app.Selected_data=app.select_data();
                app.refresh_fig1();
                drawnow;
                figure(app.hfig);
            end 
        end

        function LOAD_Callback(app, hObject, eventdata)
            
%                 %Alternate function to load scans without metadata
%                 if get(app.STEP2_STOP, 'Value')==size(get(app.STEP2_STOP, 'String'),1)
%                     step2_stop_was_set_to_max=true;
%                 else
%                     step2_stop_was_set_to_max=false;
%                 end
%                 [filename, pathname] = uigetfile({'*.lvm;*.mat;','Supported Files (*.lvm,*.mat)';'*.lvm','LabView data (*.lvm)';'*.mat','MAT-files (*.mat)';'*.*', 'All Files (*.*)'}, 'Please pick the file to load'); %open browse window
%                 if filename==0 % if user canceled, return
%                    return
%                 end
%                 F=[pathname filename];
%                 app.add_line_to_dialog('LOADING NEW FILE... PLEASE WAIT');
%                 set(app.LOAD, 'Enable', 'off');
%                 drawnow;
%                 app.LSD=Load_Manager();
%                 app.LSD.data=cell2mat(struct2cell(load(F)));
%                 app.LSD.Nsweep=size(app.LSD.data,1);
%                 app.LSD.Nstep=size(app.LSD.data,2);
%                 app.LSD.Nstep2=size(app.LSD.data,3);
%                 app.LSD.Nmeasure=1;
%                 set(app.LOAD, 'Enable', 'on');
%                 
%                 cla(app.axes1)                                                          % clear figures and dialog box
%                 cla(app.axes2)
%                 set(app.DIALOG_BOX,'string', 'MESSAGES:');
%                 dialog=get(app.DIALOG_BOX,'string');
%                 set(app.DIALOG_BOX,'string', {dialog, ''});
%                 app.PostSel=ones(app.LSD.Nstep,app.LSD.Nstep2);
%                 app.Tload=1:app.LSD.Nstep;
%                 app.Timeaxis=1:app.LSD.Nsweep;
%                 Step2String=1:app.LSD.Nstep2;
%                 set(app.STEP2_START,'String', Step2String);
%                 if get(app.STEP2_START,'Value')>app.LSD.Nstep2
%                     set(app.STEP2_START,'Value', 1);
%                 end
%                 set(app.STEP2_STOP,'String', Step2String);
%                 if get(app.STEP2_STOP,'Value')>app.LSD.Nstep2 || step2_stop_was_set_to_max
%                     set(app.STEP2_STOP,'Value', app.LSD.Nstep2);
%                 end
% 
%                 MeasurelineString=1:app.LSD.Nmeasure;
%                 set(app.MEASURE_LINE,'String', MeasurelineString);
%                 if get(app.MEASURE_LINE,'Value')>app.LSD.Nmeasure
%                     set(app.MEASURE_LINE,'Value', 1);
%                 end
% 
%                 init_value_IntCursor1=1;
%                 set(app.INTERVAL_CURSOR_1,'Min',1);
%                 set(app.INTERVAL_CURSOR_1,'Max',app.LSD.Nsweep);
%                 if get(app.INTERVAL_CURSOR_1,'Value')>app.LSD.Nsweep || get(app.INTERVAL_CURSOR_1,'Value')<1
%                     set(app.INTERVAL_CURSOR_1,'Value',init_value_IntCursor1);
%                 end
%                 set(app.INTERVAL_CURSOR_1,'SliderStep',[1/(app.LSD.Nsweep-1) 20/(app.LSD.Nsweep-1)]);
% 
%                 init_value_IntCursor2=app.LSD.Nsweep;
%                 set(app.INTERVAL_CURSOR_2,'Min',1);
%                 set(app.INTERVAL_CURSOR_2,'Max',init_value_IntCursor2);
%                 if get(app.INTERVAL_CURSOR_2,'Value')>app.LSD.Nsweep || get(app.INTERVAL_CURSOR_2,'Value')<1
%                     set(app.INTERVAL_CURSOR_2,'Value',init_value_IntCursor2);
%                 end
%                 set(app.INTERVAL_CURSOR_2,'SliderStep',[1/(app.LSD.Nsweep-1) 20/(app.LSD.Nsweep-1)]);
% 
%                 if get(app.RAW_DATA,'Value')
%                     Imax=max(max(max(app.LSD.data(:,:,:,get(app.MEASURE_LINE,'Value')))));
%                     Imin=min(min(min(app.LSD.data(:,:,:,get(app.MEASURE_LINE,'Value')))));
%                     set(app.axes1,'ylim',[Imin Imax]);
%                     set(app.Y_MAX,'String',num2str(Imax));
%                     set(app.Y_MIN,'String',num2str(Imin));
%                     set(app.THRESHOLD_CURSOR,'Min',Imin);
%                     set(app.THRESHOLD_CURSOR,'Max',Imax);
%                     if get(app.THRESHOLD_CURSOR,'Value')>Imax || get(app.THRESHOLD_CURSOR,'Value')<Imin
%                         set(app.THRESHOLD_CURSOR,'Value',(Imax+Imin)/2);
%                         set(app.DISPLAY_THRESHOLD,'String',num2str((Imax+Imin)/2));
%                     end
%                     set(app.THRESHOLD_CURSOR,'SliderStep',[0.005 0.02]);
%                 end
% 
%                 set(app.FILENAME,'string',Load_Manager.remove_path(Load_Manager.remove_extension(app.LSD.filename)));
% 
%                 app.Selected_data=app.select_data();
%                 app.refresh_fig1();
%                 drawnow;
%                 figure(app.hfig);
% 
%                 if get(app.AUTO_REFRESH,'Value')
%                     app.RUN_Callback(hObject, eventdata);
%                 end
%                 
                

        
            
            if get(app.STEP2_STOP, 'Value')==size(get(app.STEP2_STOP, 'String'),1)
                step2_stop_was_set_to_max=true;
            else
                step2_stop_was_set_to_max=false;
            end
            [filename, pathname] = uigetfile({'*.lvm;*.mat;','Supported Files (*.lvm,*.mat)';'*.lvm','LabView data (*.lvm)';'*.mat','MAT-files (*.mat)';'*.*', 'All Files (*.*)'}, 'Please pick the file to load'); %open browse window
            if filename==0 % if user canceled, return
               return
            end
            F=[pathname filename];
            app.add_line_to_dialog('LOADING NEW FILE... PLEASE WAIT');
            set(app.LOAD, 'Enable', 'off');
            drawnow; 
            app.LSD=Load_Manager(F);
            set(app.LOAD, 'Enable', 'on');

            cla(app.axes1)                                                          % clear figures and dialog box
            cla(app.axes2)
            set(app.DIALOG_BOX,'string', 'MESSAGES:');
            dialog=get(app.DIALOG_BOX,'string');
            set(app.DIALOG_BOX,'string', {dialog, ''});
            
            
            app.PostSel=ones(app.LSD.Nstep,app.LSD.Nstep2);
%             if app.PostSel==-1
%                 app.PostSel=ones(app.LSD.Nstep,app.LSD.Nstep2);
%                 app.add_line_to_dialog('WARNING: No PostSel matrix found in the argument list - all curves are kept by default');
%             end

            if size(app.LSD.step_dim.param_values,1)>1
                f=figure;
                Tload_table=uitable('Parent',f,'Units','normalized','Position',[0.05 0.1 0.88 0.8]);
                set(Tload_table,'Data',app.LSD.step_dim.param_values');
                prompt = {'Select column to use for Tload?'};
                dlg_title = 'enter column number';
                num_lines= 1;
                def     = {'1'};
                values  = inputdlg(prompt,dlg_title,num_lines,def);
                val = str2double(values(1));
                close(f);
            else
                val = 1;
            end
%                 app.Tload=app.Tload(:,val);
            [app.Tload, app.Tload_label]=app.LSD.step_dim.build_dim_axis(val);

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

%             set(app.T1_PLOT,'Value', 1);
%             set(app.HISTOGRAM_PLOT,'Value', 0);
%             set(app.RAW_DATA,'Value', 1);
%             set(app.DERIVATIVE,'Value', 0);
            
            Step2String=1:app.LSD.Nstep2;
            set(app.STEP2_START,'String', Step2String);
            if get(app.STEP2_START,'Value')>app.LSD.Nstep2
                set(app.STEP2_START,'Value', 1);
            end
            set(app.STEP2_STOP,'String', Step2String);
            if get(app.STEP2_STOP,'Value')>app.LSD.Nstep2 || step2_stop_was_set_to_max
                set(app.STEP2_STOP,'Value', app.LSD.Nstep2);
            end
	    
            MeasurelineString=1:app.LSD.Nmeasure;
            set(app.MEASURE_LINE,'String', MeasurelineString);
            if get(app.MEASURE_LINE,'Value')>app.LSD.Nmeasure
                set(app.MEASURE_LINE,'Value', 1);
            end

            init_value_IntCursor1=1;
            set(app.INTERVAL_CURSOR_1,'Min',1);
            set(app.INTERVAL_CURSOR_1,'Max',app.LSD.Nsweep);
            if get(app.INTERVAL_CURSOR_1,'Value')>app.LSD.Nsweep || get(app.INTERVAL_CURSOR_1,'Value')<1
                set(app.INTERVAL_CURSOR_1,'Value',init_value_IntCursor1);
            end
            set(app.INTERVAL_CURSOR_1,'SliderStep',[1/(app.LSD.Nsweep-1) 20/(app.LSD.Nsweep-1)]);

            init_value_IntCursor2=app.LSD.Nsweep;
            set(app.INTERVAL_CURSOR_2,'Min',1);
            set(app.INTERVAL_CURSOR_2,'Max',init_value_IntCursor2);
            if get(app.INTERVAL_CURSOR_2,'Value')>app.LSD.Nsweep || get(app.INTERVAL_CURSOR_2,'Value')<1
                set(app.INTERVAL_CURSOR_2,'Value',init_value_IntCursor2);
            end
            set(app.INTERVAL_CURSOR_2,'SliderStep',[1/(app.LSD.Nsweep-1) 20/(app.LSD.Nsweep-1)]);
            
            if get(app.RAW_DATA,'Value')
                Imax=max(max(max(app.LSD.data(:,:,:,get(app.MEASURE_LINE,'Value')))));
                Imin=min(min(min(app.LSD.data(:,:,:,get(app.MEASURE_LINE,'Value')))));
                set(app.axes1,'ylim',[Imin Imax]);
                set(app.Y_MAX,'String',num2str(Imax));
                set(app.Y_MIN,'String',num2str(Imin));
                set(app.THRESHOLD_CURSOR,'Min',Imin);
                set(app.THRESHOLD_CURSOR,'Max',Imax);
                if get(app.THRESHOLD_CURSOR,'Value')>Imax || get(app.THRESHOLD_CURSOR,'Value')<Imin
                    set(app.THRESHOLD_CURSOR,'Value',(Imax+Imin)/2);
                    set(app.DISPLAY_THRESHOLD,'String',num2str((Imax+Imin)/2));
                end
                set(app.THRESHOLD_CURSOR,'SliderStep',[0.005 0.02]);
            end

            set(app.FILENAME,'string',Load_Manager.remove_path(Load_Manager.remove_extension(app.LSD.filename)));

            app.Selected_data=app.select_data();
            app.refresh_fig1();
            drawnow;
            figure(app.hfig);
            
            if get(app.AUTO_REFRESH,'Value')
                app.RUN_Callback(hObject, eventdata);
            end

        end

        function RUN_Callback(app, hObject, eventdata)

%             if get(app.FILTER_ON,'Value')
%               app.Activate_Filter_Callback(hObject, eventdata);
%             end
%             cla(app.axes2)

            if get(app.EDGE_MODE,'Value')
                [norm, events, toff] = count_edges(app);
                app.Norm=norm;
                app.Toff=toff;
            else
                [norm, events, toff] = count_events(app);
                app.Norm=norm;
                app.Toff=toff;
            end

            
            % FIGURE 2 PROCESSING - EVENTS VS TLOAD CURVE / HISTOGRAM      

            if get(app.T1_PLOT,'Value')                                        % if selected, plot the % events in function of Tload
                if size(app.Tload,1)~=size(events,2) && size(app.Tload,2)~=size(events,2)
                    app.add_line_to_dialog('WARNING: size of Tload seems not correct');
                end
                app.Proba=events./norm;
                app.Err=sqrt(app.Proba.*(1-app.Proba))./(sqrt(norm));                                  % errorbars
                if get(app.REVERT,'Value')
                    errorbar(app.axes2,app.Tload,1-app.Proba,app.Err);
                else
                    errorbar(app.axes2,app.Tload,app.Proba,app.Err);
                end
                set(app.axes2,'ylim',[0 1]);    
                
            elseif get(app.HISTOGRAM_PLOT,'Value')                              % otherwise, plot escape time histogram
                nbin=str2double(get(app.N_BIN,'String'));
                sweepmin=min(get(app.INTERVAL_CURSOR_1,'Value'),get(app.INTERVAL_CURSOR_2,'Value'));    % the two vertical cursors define the sweep range to use for post-treatment
                sweepmax=max(get(app.INTERVAL_CURSOR_1,'Value'),get(app.INTERVAL_CURSOR_2,'Value'));
                app.Ndwell=zeros(app.LSD.Nstep,nbin+1);
                app.Tdwell=sweepmin:(sweepmax-sweepmin)/nbin:sweepmax;                % sweepmin is necessarily >0 so values of toff=0 (<=> no event) are ignored is the processing
                for i=1:app.LSD.Nstep
                    noff=histc(toff(i,:),app.Tdwell);                                % get the histogram data step by step
                    for j=1:nbin
                        app.Ndwell(i,j)=noff(j);                                      % and store it in Toff
                    end
                end
                app.Tdwell=app.Timeaxis(sweepmin):(app.Timeaxis(sweepmax)-app.Timeaxis(sweepmin))/nbin:app.Timeaxis(sweepmax); %conversion of sweep indexes into time unit
                bar(app.axes2,app.Tdwell,app.Ndwell')                                   % and plot the histogram
                app.Tdwell=app.Tdwell(1:end-1);
                app.Ndwell=app.Ndwell(:,1:end-1);
            end

        end

        %% FIGURE 1 CALLBACKS

        function INTERVAL_CURSOR_1_Callback(app, hObject, eventdata)
            val=get(hObject,'Value');
            val=round(val);
            set(hObject,'Value',val);
            XX=xlim(app.axes1);
            YY=ylim(app.axes1);
            delete(app.hcurs1);
            hold(app.axes1,'on')
            app.hcurs1=plot(app.axes1,[app.Timeaxis(val) app.Timeaxis(val)],[YY(1) YY(2)],'--','LineWidth',2);
            set(app.axes1,'xlim',XX);
            if get(app.AUTO_REFRESH,'Value')
                app.RUN_Callback(hObject, eventdata);
            end
        end

        function INTERVAL_CURSOR_2_Callback(app, hObject, eventdata)
            val=get(hObject,'Value');
            val=round(val);
            set(hObject,'Value',val); 
            XX=xlim(app.axes1);
            YY=ylim(app.axes1);
            delete(app.hcurs2);
            hold(app.axes1,'on')
            app.hcurs2=plot(app.axes1,[app.Timeaxis(val) app.Timeaxis(val)],[YY(1) YY(2)],'--','LineWidth',2);
            set(app.axes1,'xlim',XX);
            if get(app.AUTO_REFRESH,'Value')
                app.RUN_Callback(hObject, eventdata);
            end
        end

        function THRESHOLD_CURSOR_Callback(app, hObject, eventdata)
            val=get(hObject,'Value');
            XX=xlim(app.axes1);
            delete(app.hcursth);
            hold(app.axes1,'on')
            if get(app.RAW_DATA,'Value')
                app.hcursth=plot(app.axes1,[XX(1) XX(2)],[val val],'--','LineWidth',2);
            else
                app.hcursth=plot(app.axes1,[XX(1) XX(2)],[abs(val) abs(val)],[XX(1) XX(2)],[-abs(val) -abs(val)],'LineWidth',2,'color','blue');
            end
            set(app.axes1,'xlim',XX);
            set(app.DISPLAY_THRESHOLD,'String',num2str(val));
            if get(app.AUTO_REFRESH,'Value')
                app.RUN_Callback(hObject, eventdata);
            end
        end

        function DISPLAY_THRESHOLD_Callback(app, hObject, eventdata)
            str=get(hObject,'String');
            val=str2double(str);
            set(app.THRESHOLD_CURSOR,'Value',val);
            XX=xlim(app.axes1);
            delete(app.hcursth);
            hold(app.axes1,'on');
            set(app.axes1,'xlim',XX);
            if get(app.RAW_DATA,'Value')
                app.hcursth=plot(app.axes1,[XX(1) XX(2)],[val val],'--','LineWidth',2);
            else
                app.hcursth=plot(app.axes1,[XX(1) XX(2)],[abs(val) abs(val)],[XX(1) XX(2)],[-abs(val) -abs(val)],'LineWidth',2,'color','blue');
            end
            if get(app.AUTO_REFRESH,'Value')
                app.RUN_Callback(hObject, eventdata);
            end    
        end

        function PLOT_RATIO_Callback(app, hObject, eventdata)
            str=get(hObject,'String');
            new_plotratio = str2double(str);
            step2start=get(app.STEP2_START,'Value');
            step2stop=get(app.STEP2_STOP,'Value');
            if new_plotratio>(step2stop-step2start+1)
%                 app.current_plotratio = (app.current_step2_stop-app.current_step2_start+1);
                set(app.PLOT_RATIO,'string', num2str(step2stop-step2start+1));
            end
            app.refresh_fig1();
            if get(app.AUTO_REFRESH,'Value')
                app.RUN_Callback(hObject, eventdata);
            end
        end

        function Y_MAX_Callback(app, hObject, eventdata)
            str=get(hObject,'String');
            ymax=str2double(str);
            YY=ylim(app.axes1);
            set(app.axes1,'ylim',[YY(1) ymax]);
        end

        function Y_MIN_Callback(app, hObject, eventdata)
            str=get(hObject,'String');
            ymin=str2double(str);
            YY=ylim(app.axes1);
            set(app.axes1,'ylim',[ymin YY(2)]);
        end

        function X_MIN_Callback(app, hObject, eventdata)
            str=get(hObject,'String');
            xmin=str2double(str);
            XX=xlim(app.axes1);
            set(app.axes1,'xlim',[xmin XX(2)]);
        end

        function X_MAX_Callback(app, hObject, eventdata)
            str=get(hObject,'String');
            xmax=str2double(str);
            XX=xlim(app.axes1);
            set(app.axes1,'xlim',[XX(1) xmax]);
        end

        function PRINT_FIG_1_Callback(app, hObject, eventdata)
            f=figure;
            copyobj(app.axes1,f);
        end

        function RAW_DATA_Callback(app, hObject, eventdata)

            if get(hObject,'Value')
                set(app.DERIVATIVE,'Value', 0);
            else
                set(app.DERIVATIVE,'Value', 1);
            end
            app.Selected_data=app.select_data();
            Imax=max(max(max(app.Selected_data)));
            Imin=min(min(min(app.Selected_data)));
            
            if Imax>get(app.THRESHOLD_CURSOR,'Max') || Imin<get(app.THRESHOLD_CURSOR,'Min')
                set(app.THRESHOLD_CURSOR,'Min',Imin);
                set(app.THRESHOLD_CURSOR,'Max',Imax);
                set(app.THRESHOLD_CURSOR,'Value',(Imax+Imin)/2);
                set(app.THRESHOLD_CURSOR,'SliderStep',[0.005 0.02]);
                set(app.DISPLAY_THRESHOLD,'String',num2str((Imax+Imin)/2));
            end

            set(app.axes1,'ylim',[Imin Imax]);
            set(app.Y_MAX,'String',num2str(Imax));
            set(app.Y_MIN,'String',num2str(Imin));
            
            app.refresh_fig1();
            if get(app.AUTO_REFRESH,'Value')
                app.RUN_Callback(hObject, eventdata);
            end 

        end

        function DERIVATIVE_Callback(app, hObject, eventdata)

            if get(hObject,'Value')
                set(app.RAW_DATA,'Value', 0);
            else
                set(app.RAW_DATA,'Value', 1);
            end
            app.Selected_data=app.select_data();

            dImax=max(max(max(app.Selected_data)));
            dImin=min(min(min(app.Selected_data)));
            if dImax>get(app.THRESHOLD_CURSOR,'Max')|| dImin<get(app.THRESHOLD_CURSOR,'Min')
                set(app.THRESHOLD_CURSOR,'Min',dImin);
                set(app.THRESHOLD_CURSOR,'Max',dImax);
                set(app.THRESHOLD_CURSOR,'Value',0);
                set(app.THRESHOLD_CURSOR,'SliderStep',[0.005 0.02]);
                set(app.DISPLAY_THRESHOLD,'String',num2str(0));
            end
            set(app.axes1,'ylim',[dImin dImax]);
            set(app.Y_MAX,'String',num2str(dImax));
            set(app.Y_MIN,'String',num2str(dImin));
%                 set(app.axes1,'ylim',[-0.1 0.1]);
%                 set(app.Y_MAX,'String','0.1');
%                 set(app.Y_MIN,'String','-0.1');
            app.refresh_fig1();
            if get(app.AUTO_REFRESH,'Value')
                app.RUN_Callback(hObject, eventdata);
            end 

        end
        
        function THRESHOLD_MODE_Callback(app, hObject, eventdata)

            if get(hObject,'Value')
                set(app.EDGE_MODE,'Value', 0);
            else
                set(app.EDGE_MODE,'Value', 1);
                app.define_edge_threshold();
            end
        end

        function EDGE_MODE_Callback(app, hObject, eventdata)

            if get(hObject,'Value')
                set(app.THRESHOLD_MODE,'Value', 0);
                app.define_edge_threshold();
            else
                set(app.THRESHOLD_MODE,'Value', 1);
            end
        end


        %% FIGURE 2 CALLBACKS

        function PRINT_FIG_2_Callback(app, hObject, eventdata)
%             f=figure;                     %
%             copyobj(app.axes2,f);         % low cost solution
            figure
            if get(app.T1_PLOT,'Value')
                errorbar(app.Tload,app.Proba,app.Err,'LineWidth',2);
            elseif get(app.HISTOGRAM_PLOT,'Value')
                bar(app.Tdwell,app.Ndwell')
            end
            set(gcf, 'renderer', 'zbuffer'); % prevent possible graphic card driver bug cf. http://www.mathworks.com/matlabcentral/answers/53874    
            grid on
            box on
            set(gca,'LineWidth',2);
            set(gca,'fontSize',14);
            xlabel(app.Tload_label,'fontsize',14);
            ylabel('Event Probability','fontsize',14);
            title(WORKSPACE_PLOTTER_OOP.process_underscore(app.LSD.filename),'fontsize',14);
        end

        function T1_PLOT_Callback(app, hObject, eventdata)
            if get(hObject,'Value')
                set(app.HISTOGRAM_PLOT,'Value', 0);
                set(app.REVERT,'enable','on');
            else
                set(app.HISTOGRAM_PLOT,'Value', 1);
                set(app.REVERT,'enable','off');
            end
            app.RUN_Callback(hObject, eventdata);
        end

        function HISTOGRAM_PLOT_Callback(app, hObject, eventdata)
            if get(hObject,'Value')
                set(app.T1_PLOT,'Value', 0);
                set(app.REVERT,'enable','off');
            else
                set(app.T1_PLOT,'Value', 1);
                set(app.REVERT,'enable','on');
            end
            app.RUN_Callback(hObject, eventdata);
        end
        
        function REVERT_Callback(app, hObject, eventdata)
            if get(app.AUTO_REFRESH,'Value')
                app.RUN_Callback(hObject, eventdata);
            end 
        end
        
        function N_BIN_Callback(app, hObject, eventdata)
            str=get(hObject,'String');
            N_bin=str2double(str);
            if (N_bin<=0) || (mod(N_bin,1)~=0)
                N_bin=floor(abs(N_bin));
                set(app.N_BIN,'String',num2str(N_bin));
            end
            if get(app.AUTO_REFRESH,'Value')
                app.RUN_Callback(hObject, eventdata);
            end 
        end


        %% FILTER CALLBACKS

        function MAX_EVENTS_TOL_Callback(app, hObject, eventdata)
        str=get(hObject,'String');
        app.current_event_max=str2double(str);
        end

        function MIN_EVENTS_TOL_Callback(app, hObject, eventdata)
        str=get(hObject,'String');
        app.current_event_min=str2double(str);
        end

        function FILTER_ON_Callback(app, hObject, eventdata)

        app.current_Activate_Filter=get(hObject,'Value');
        app.current_PostSel=app.PostSel;

        if app.current_Activate_Filter==1
            set(app.FILTER_OFF,'Value', 0);
            app.current_Filter_OFF=0;

            step2start=app.current_step2_start;
            step2stop=app.current_step2_stop;
            sweepmin=min(app.current_IntCursor1,app.current_IntCursor2);
            sweepmax=max(app.current_IntCursor1,app.current_IntCursor2);
            Mat=app.mat_to_run(:,:,step2start:step2stop);

            if app.current_RawData==1                                           % if using raw data
              for k=1:(step2stop-step2start)
                nb_events_tot=0;
                  for j=1:app.Nstep
                      above=Mat(sweepmin:sweepmax,j,k)>app.current_CursorTh;  %check if the data is above threshold
                      nb_events=round((sum(abs(diff(above)))+above(1))/2);
                      nb_events_tot=nb_events_tot+nb_events;
                  end  
                if nb_events_tot>app.current_event_max || nb_events_tot<app.current_event_min
                    app.current_PostSel(:,k)=0;
                end
              end
            end

            if app.current_Derivative==1
              for k=1:(step2stop-step2start)
                nb_events_tot=0;
                  for j=1:app.Nstep
                      under=Mat(sweepmin:sweepmax,j,k)<app.current_CursorTh; % for the derivative case, there is an event when the data is below the threshold
                      nb_events=round((sum(abs(diff(under)))+under(1))/2);
                      nb_events_tot=nb_events_tot+nb_events;
                  end
                  if nb_events_tot>app.current_event_max || nb_events_tot<app.current_event_min
                    app.current_PostSel(:,k)=0;
                  end
               end
            end

        else
            set(app.FILTER_OFF,'Value', 1);
            app.current_Filter_OFF=1;
        end

        end

        function FILTER_OFF_Callback(app, hObject, eventdata)
        app.current_Filter_OFF=get(hObject,'Value');
        app.current_PostSel=app.PostSel;
        if app.current_Filter_OFF==1
            set(app.FILTER_ON,'Value', 0);
            app.current_Activate_Filter=0;
        else
            set(app.FILTER_ON,'Value', 1);
            app.current_Activate_Filter=1;

            step2start=app.current_step2_start;
            step2stop=app.current_step2_stop;
            sweepmin=min(app.current_IntCursor1,app.current_IntCursor2);
            sweepmax=max(app.current_IntCursor1,app.current_IntCursor2);
            Mat=app.mat_to_run(:,:,step2start:step2stop);

            if app.current_RawData==1                                           % if using raw data
              for k=1:(step2stop-step2start)
                nb_events_tot=0;
                  for j=1:app.Nstep
                      above=Mat(sweepmin:sweepmax,j,k)>app.current_CursorTh;  %check if the data is above threshold
                      nb_events=round((sum(abs(diff(above)))+above(1))/2);
                      nb_events_tot=nb_events_tot+nb_events;
                  end  
                if nb_events_tot>app.current_event_max || nb_events_tot<app.current_event_min
                    app.current_PostSel(:,k)=0;
                end
              end
            end

            if app.current_Derivative==1
              for k=1:(step2stop-step2start)
                nb_events_tot=0;
                  for j=1:app.Nstep
                      under=Mat(sweepmin:sweepmax,j,k)<app.current_CursorTh; % for the derivative case, there is an event when the data is below the threshold
                      nb_events=round((sum(abs(diff(under)))+under(1))/2);
                      nb_events_tot=nb_events_tot+nb_events;
                  end
                  if nb_events_tot>app.current_event_max || nb_events_tot<app.current_event_min
                    app.current_PostSel(:,k)=0;
                  end
               end
            end
        end

        end
        
        function POSTSEL_Callback(app, hObject, eventdata)
            PS=Post_Sel('data',app.LSD,'Timeaxis',app.Timeaxis,'MeasureLine',get(app.MEASURE_LINE,'Value'));
            waitfor(PS.hfig);
            if isempty(PS.Output)
                app.PostSel=ones(app.LSD.Nstep,app.LSD.Nstep2);
                app.add_line_to_dialog('WARNING: PostSel matrix not defined - all curves kept by default');
            else
                app.PostSel=PS.Output;
%                 assignin('base','PS',PS.Output);
            end
            app.Selected_data=app.select_data();
            app.refresh_fig1();
            if get(app.AUTO_REFRESH,'Value')
                app.RUN_Callback(hObject, eventdata);
            end 
        end
        
        function LOAD_POSTSEL_Callback(app, hObject, eventdata)
        % NOT WRITTEN YET
        end


        %% OTHER CALLBACKS

        function STEP2_START_Callback(app, hObject, eventdata)
            app.Selected_data=app.select_data();
            app.refresh_fig1();
            if get(app.AUTO_REFRESH,'Value')
                app.RUN_Callback(hObject, eventdata);
            end 
        end

        function STEP2_STOP_Callback(app, hObject, eventdata)
            app.Selected_data=app.select_data();
            app.refresh_fig1();
            if get(app.AUTO_REFRESH,'Value')
                app.RUN_Callback(hObject, eventdata);
            end 
        end

        function EXPORT_Callback(app, hObject, eventdata)
            infos.Threshold=get(app.THRESHOLD_CURSOR,'Value');
            infos.meas_start=min(get(app.INTERVAL_CURSOR_1,'Value'),get(app.INTERVAL_CURSOR_2,'Value'));
            infos.meas_stop=max(get(app.INTERVAL_CURSOR_1,'Value'),get(app.INTERVAL_CURSOR_2,'Value'));
            infos.events=app.Proba;
            infos.norm=app.Norm;
            if get(app.RAW_DATA,'Value')
                infos.mode='RAW DATA';
            else
                infos.mode='DERIVATIVE';
            end
            assignin('base',['infos_' get(app.FILENAME,'String')],infos);
            assignin('base',['Tload_' get(app.FILENAME,'String')],app.Tload');
            assignin('base',['proba_' get(app.FILENAME,'String')],app.Proba);
            assignin('base',['norm_' get(app.FILENAME,'String')],app.Norm);
            
            if get(app.HISTOGRAM_PLOT,'Value')
              assignin('base',['Toff_' get(app.FILENAME,'String')],app.Toff');
              assignin('base',['Tdwell_' get(app.FILENAME,'String')],app.Tdwell);
              assignin('base',['Ndwell_' get(app.FILENAME,'String')],app.Ndwell);
            end
            app.add_line_to_dialog([get(app.FILENAME,'String') ' data has been exported to base workspace']);
        end

        function AUTO_REFRESH_Callback(app, hObject, eventdata)
            if get(hObject,'Value')
                app.RUN_Callback(hObject, eventdata);
            end
        end

        function MEASURE_LINE_Callback(app, hObject, eventdata)
            app.Selected_data=app.select_data();
            Imax=max(max(max(app.Selected_data)));
            Imin=min(min(min(app.Selected_data)));
            
            if Imax>get(app.THRESHOLD_CURSOR,'Max') || Imin<get(app.THRESHOLD_CURSOR,'Min')
                set(app.THRESHOLD_CURSOR,'Min',Imin);
                set(app.THRESHOLD_CURSOR,'Max',Imax);
                set(app.THRESHOLD_CURSOR,'Value',(Imax+Imin)/2);
                set(app.THRESHOLD_CURSOR,'SliderStep',[0.005 0.02]);
                set(app.DISPLAY_THRESHOLD,'String',num2str((Imax+Imin)/2));
            end

            set(app.axes1,'ylim',[Imin Imax]);
            set(app.Y_MAX,'String',num2str(Imax));
            set(app.Y_MIN,'String',num2str(Imin));
            app.refresh_fig1();
            if get(app.AUTO_REFRESH,'Value')
                app.RUN_Callback(hObject, eventdata);
            end
        end

        function FILENAME_Callback(app, hObject, eventdata)
%         str=get(hObject,'String');
%         app.filename=str;
        end

        function DIALOG_BOX_Callback(app, hObject, eventdata)
        end


        %% AUXILIARY FUNCTIONS
        function [Selected_data] = select_data(app)
            step2start=get(app.STEP2_START,'Value');
            step2stop=get(app.STEP2_STOP,'Value');
            
            if get(app.RAW_DATA,'Value')
                Selected_data=app.LSD.data(:,:,step2start:step2stop,get(app.MEASURE_LINE,'Value'));
            else
                Selected_data=app.LSD.data(:,:,step2start:step2stop,get(app.MEASURE_LINE,'Value'));
                for k=1:(step2stop-step2start+1)
                    Selected_data(:,:,k)=smooth2a(Selected_data(:,:,k),1,0);
                    Selected_data(1:end-1,:,k)=diff(Selected_data(:,:,k));
                end
                Selected_data(app.LSD.Nsweep,:,:)=Selected_data(app.LSD.Nsweep-1,:,:);
            end
        end
            
        function [GoodPlots] = select_data_for_fig1(app)
            step2start=get(app.STEP2_START,'Value');
            step2stop=get(app.STEP2_STOP,'Value');
%             step2int=step2stop-step2start+1;
            gap=floor(str2double(get(app.PLOT_RATIO,'String')));                                   % keep roughly one curve every "plotratio" for plotting
            if gap<1
                gap=1;
            end
            PS=app.PostSel(:,step2start:step2stop);                                                 % DO IT ONCE IN THE INITIALIZATION !!
            PS=permute(repmat(PS,[1,1,app.LSD.Nsweep]),[3 1 2]);
%             assignin('base','PS2',PS)
%             PS=reshape(PS,app.LSD.Nsweep,app.LSD.Nstep,step2int);
%             assignin('base','PS3',PS)
            GoodPlots=app.Selected_data(logical(PS));
            GoodPlots=reshape(GoodPlots,app.LSD.Nsweep,sum(sum(app.PostSel(:,step2start:step2stop))));
            
            GoodPlots=GoodPlots(:,1:gap:end);
            
        end
        
        function [] = refresh_fig1(app)
            cla(app.axes1)
            % FIGURE 1 PROCESSING - PLOTTING RAW DATA OR DERIVATIVE
            GoodPlots = app.select_data_for_fig1;
            hold(app.axes1,'off')
            XX=xlim(app.axes1);                                             % getting the values of the axis limits
            plot(app.axes1,app.Timeaxis,GoodPlots);
            hold(app.axes1,'on')
            set(app.X_MAX,'String',num2str(XX(2)));                         % refresh the values of axis limits
            set(app.X_MIN,'String',num2str(XX(1)));
            YY=ylim(app.axes1);
            set(app.Y_MAX,'String',num2str(YY(2)));
            set(app.Y_MIN,'String',num2str(YY(1)));
                                                                                % plotting the 3 cursors
            Xcurs1=app.Timeaxis(get(app.INTERVAL_CURSOR_1,'Value'));
            Xcurs2=app.Timeaxis(get(app.INTERVAL_CURSOR_2,'Value'));
            app.hcurs1=plot(app.axes1,[Xcurs1 Xcurs1],[YY(1) YY(2)],'--','LineWidth',2); 
            app.hcurs2=plot(app.axes1,[Xcurs2 Xcurs2],[YY(1) YY(2)],'--','LineWidth',2);
            Threshold_value=get(app.THRESHOLD_CURSOR,'Value');
            if get(app.RAW_DATA,'Value')
                app.hcursth=plot(app.axes1,[XX(1) XX(2)],[Threshold_value Threshold_value],'--','LineWidth',2);
            else
                app.hcursth=plot(app.axes1,[XX(1) XX(2)],[abs(Threshold_value) abs(Threshold_value)],[XX(1) XX(2)],[-abs(Threshold_value) -abs(Threshold_value)],'LineWidth',2,'color','blue');
            end
            set(app.axes1,'xlim',XX);
            set(app.axes1,'ylim',YY);
        end
            
        function [norm, events, toff] = count_events(app)
            step2start=get(app.STEP2_START,'Value');
            step2stop=get(app.STEP2_STOP,'Value');
            sweepmin=min(get(app.INTERVAL_CURSOR_1,'Value'),get(app.INTERVAL_CURSOR_2,'Value'));    % the two vertical cursors define the sweep range to use for post-treatment
            sweepmax=max(get(app.INTERVAL_CURSOR_1,'Value'),get(app.INTERVAL_CURSOR_2,'Value'));
            Mat=app.Selected_data(sweepmin:sweepmax,:,:);                       % get the data (raw or derivative)
            
            events=zeros(1,app.LSD.Nstep);
            toff=zeros(app.LSD.Nstep,app.LSD.Nstep2);
            Threshold=get(app.THRESHOLD_CURSOR,'Value');            
            
            for j=1:app.LSD.Nstep
                step_data=squeeze((Mat(:,j,logical(app.PostSel(j,step2start:step2stop)))));
                above=step_data>Threshold;
                if get(app.RAW_DATA,'Value')
                    events(j)=sum(sum(above,1)>0);
                else
                    under=step_data<-abs(Threshold);
                    events(j)=sum((sum(above+under,1)>0)); 
                end
                
                if get(app.HISTOGRAM_PLOT,'Value')                     % and compute toff if histogram method is used
                   for k=1:size(step_data,2)
                        if sum(above(:,k))>0
                            ind=find(above(:,k),1);
                            toff(j,k)=ind+sweepmin-1;
                        elseif get(app.DERIVATIVE,'Value')
                            if sum(under(k))>0
                                ind=find(under(k),1);
                                toff(j,k)=ind+sweepmin-1;
    %                             toff(j,k)=sweepmin;
                            end
                        end
                   end
                end 
            end
                    
            norm=sum(app.PostSel(:,step2start:step2stop),2)';               % how many curves have been used (for data normalization)
            
            

        end    
        
        function [norm, events, toff] = count_edges(app)
            tic
            app.Edge_threshold=evalin('base','Edge_Threshold_Definer_output');
            step2start=get(app.STEP2_START,'Value');
            step2stop=get(app.STEP2_STOP,'Value');
            sweepmin=min(get(app.INTERVAL_CURSOR_1,'Value'),get(app.INTERVAL_CURSOR_2,'Value'));    % the two vertical cursors define the sweep range to use for post-treatment
            sweepmax=max(get(app.INTERVAL_CURSOR_1,'Value'),get(app.INTERVAL_CURSOR_2,'Value'));
            Mat=app.Selected_data(sweepmin:sweepmax,:,:);                       % get the data (raw or derivative)
            
            events=zeros(1,app.LSD.Nstep);
            toff=zeros(app.LSD.Nstep,app.LSD.Nstep2);
            Threshold=app.Edge_threshold;            
            
            for j=1:app.LSD.Nstep
                step_data=squeeze((Mat(:,j,logical(app.PostSel(j,step2start:step2stop)))));
                step_data_weights=zeros(size(step_data));
                step_data_times=zeros(size(step_data));
                for k=1:size(step_data,2)
                    [time_ind,weights]=Edge_detect(sweepmin:sweepmax,step_data(:,k));
                    step_data_weights(1:size(weights,1),k)=weights;
                    step_data_times(1:size(time_ind,1),k)=time_ind;
                end
                assignin('base','weights',step_data_weights)
                above=step_data_weights>Threshold;
                if get(app.RAW_DATA,'Value')
                    events(j)=sum(sum(above,1)>0);
                else
                    under=step_data_weights<-abs(Threshold);
                    events(j)=sum((sum(above+under,1)>0)); 
                end
                
%                 if get(app.HISTOGRAM_PLOT,'Value')                     % and compute toff if histogram method is used
%                    for k=1:size(step_data,2)
%                         if sum(above(:,k))>0
%                             ind=find(above(:,k),1);
%                             toff(j,k)=ind+sweepmin-1;
%                         elseif get(app.DERIVATIVE,'Value')
%                             if sum(under(k))>0
%                                 ind=find(under(k),1);
%                                 toff(j,k)=ind+sweepmin-1;
%     %                             toff(j,k)=sweepmin;
%                             end
%                         end
%                    end
%                 end 
            end
            toc       
            norm=sum(app.PostSel(:,step2start:step2stop),2)';               % how many curves have been used (for data normalization)
            
            

        end  

        function [] = add_line_to_dialog(app, string_in)
            % --- add 'string_in' in a new line of dialog box 
            dialog=get(app.DIALOG_BOX,'string');
            dialog{size(dialog,1)+1}=string_in;
            set(app.DIALOG_BOX,'string', dialog);
        end       

        function [] = define_edge_threshold(app)
            % --- add 'string_in' in a new line of dialog box
            sweepmin=min(get(app.INTERVAL_CURSOR_1,'Value'),get(app.INTERVAL_CURSOR_2,'Value'));    % the two vertical cursors define the sweep range to use for post-treatment
            sweepmax=max(get(app.INTERVAL_CURSOR_1,'Value'),get(app.INTERVAL_CURSOR_2,'Value')); 
            Edge_Threshold_Definer(app.Selected_data(sweepmin:sweepmax,:,:),app.Timeaxis(sweepmin:sweepmax));
        end      
        
    end
    
end



