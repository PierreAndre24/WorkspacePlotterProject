function [] = gros_Babar()
%%Script to transform a file with data in a single colum to a file which can
%be read with the WORKSPACE PLOTTER

%% Main figure
FIGURE = figure('MenuBar'                  , 'none',...           
                    'NumberTitle'              , 'off',...
                    'Name'                     , 'PATCH',...
                    'Units'                    , 'normalized',...
                    'Position'                 , [0.25 0.4 0.52 0.22],...
                    'WindowStyle'              , 'normal',... 
                    'IntegerHandle'            ,'off');

%% Sweep column text label
          uicontrol('style'         , 'text', ...
                    'foregroundcolor'           , 'black', ...
                    'horizontalalignment'       , 'center', ...
                    'fontweight'                , 'bold', ...
                    'string'                    , 'Sweep', ...
                    'fontsize'                  , 15,...
                    'parent'                    , FIGURE, ...
                    'Units'                     , 'normalized',...
                    'Position'                  , [0.1 0.82 0.15 0.08],...
                    'tag'                       , 'MEASURE_LINE_TXT');


% Sweep parameter text label                
          uicontrol('style'         , 'text', ...
                    'foregroundcolor'           , 'black', ...
                    'horizontalalignment'       , 'center', ...
                    'fontweight'                , 'bold', ...
                    'string'                    , 'Parameter', ...
                    'parent'                    , FIGURE, ...
                    'Units'                     , 'normalized',...
                    'Position'                  , [0.1 0.75 0.15 0.06],...
                    'tag'                       , 'MEASURE_LINE_TXT');

SWEEP_CHANNEL = uicontrol('style'                    , 'edit', ...
                    'enable'                   , 'on', ...
                    'parent'                   , FIGURE, ...
                    'Units'                    , 'normalized',...
                    'String'                   , 'Time',...
                    'Position'                 , [0.1 0.7 0.15 0.07],...
                    'tag'                      , 'SWEEP_CHANNEL');
                
% Sweep start value text label               
          uicontrol('style'         , 'text', ...
                    'foregroundcolor'           , 'black', ...
                    'horizontalalignment'       , 'center', ...
                    'fontweight'                , 'bold', ...
                    'string'                    , 'Start value', ...
                    'parent'                    , FIGURE, ...
                    'Units'                     , 'normalized',...
                    'Position'                  , [0.1 0.6 0.15 0.06],...
                    'tag'                       , 'MEASURE_LINE_TXT');

SWEEP_START = uicontrol('style'                , 'edit', ...
                    'enable'                   , 'on', ...
                    'parent'                   , FIGURE, ...
                    'Units'                    , 'normalized',...
                    'string'                    , '0', ...
                    'Position'                 , [0.1 0.55 0.15 0.07],...
                    'tag'                      , 'SWEEP_START');
                
% Sweep stop value text label               
          uicontrol('style'         , 'text', ...
                    'foregroundcolor'           , 'black', ...
                    'horizontalalignment'       , 'center', ...
                    'fontweight'                , 'bold', ...
                    'string'                    , 'Stop value', ...
                    'parent'                    , FIGURE, ...
                    'Units'                     , 'normalized',...
                    'Position'                  , [0.1 0.45 0.15 0.06],...
                    'tag'                       , 'MEASURE_LINE_TXT');
               
SWEEP_STOP = uicontrol('style'                    , 'edit', ...
                    'enable'                   , 'on', ...
                    'parent'                   , FIGURE, ...
                    'Units'                    , 'normalized',...
                    'string'                    , '0.4', ...
                    'Position'                 , [0.1 0.4 0.15 0.07],...
                    'tag'                      , 'SWEEP_STOP'); 

% Sweep points nb text label
          uicontrol('style'         , 'text', ...
                    'foregroundcolor'           , 'black', ...
                    'horizontalalignment'       , 'center', ...
                    'fontweight'                , 'bold', ...
                    'string'                    , 'Nb points', ...
                    'parent'                    , FIGURE, ...
                    'Units'                     , 'normalized',...
                    'Position'                  , [0.1 0.3 0.15 0.06],...
                    'tag'                       , 'MEASURE_LINE_TXT');
                
SWEEP_POINTS = uicontrol('style'                    , 'edit', ... 
                    'enable'                   , 'on', ...
                    'parent'                   , FIGURE, ...
                    'Units'                    , 'normalized',...
                    'string'                    , '400', ...
                    'Position'                 , [0.1 0.25 0.15 0.07],...
                    'tag'                      , 'SWEEP_POINTS');
                
% Sweep unit text label                
          uicontrol('style'         , 'text', ...
                    'foregroundcolor'           , 'black', ...
                    'horizontalalignment'       , 'center', ...
                    'fontweight'                , 'bold', ...
                    'string'                    , 'Unit', ...
                    'parent'                    , FIGURE, ...
                    'Units'                     , 'normalized',...
                    'Position'                  , [0.1 0.15 0.15 0.06],...
                    'tag'                       , 'MEASURE_LINE_TXT');

                
SWEEP_UNIT = uicontrol('style'                    , 'edit', ... 
                    'enable'                   , 'on', ...
                    'parent'                   , FIGURE, ...
                    'Units'                    , 'normalized',...
                    'String'                   , 'ms',...
                    'Position'                 , [0.1 0.1 0.15 0.07],...
                    'tag'                      , 'SWEEP_POINTS');

                

                
%% Step column text label
          uicontrol('style'         , 'text', ...
                    'foregroundcolor'           , 'black', ...
                    'horizontalalignment'       , 'center', ...
                    'fontweight'                , 'bold', ...
                    'string'                    , 'Step', ...
                    'fontsize'                  , 15,...
                    'parent'                    , FIGURE, ...
                    'Units'                     , 'normalized',...
                    'Position'                  , [0.425 0.82 0.15 0.08],...
                    'tag'                       , 'MEASURE_LINE_TXT');
                
% Step parameter text label              
          uicontrol('style'         , 'text', ...
                    'foregroundcolor'           , 'black', ...
                    'horizontalalignment'       , 'center', ...
                    'fontweight'                , 'bold', ...
                    'string'                    , 'Parameter', ...
                    'parent'                    , FIGURE, ...
                    'Units'                     , 'normalized',...
                    'Position'                  , [0.425 0.75 0.15 0.06],...
                    'tag'                       , 'MEASURE_LINE_TXT'); 
                
STEP_CHANNEL = uicontrol('style'                    , 'edit', ...
                    'enable'                   , 'on', ...
                    'parent'                   , FIGURE, ...
                    'Units'                    , 'normalized',...
                    'String'                   , 'V 05',...
                    'Position'                 , [0.425 0.7 0.15 0.07],...
                    'tag'                      , 'STEP_CHANNEL'); 

% Step start value text label
          uicontrol('style'         , 'text', ...
                    'foregroundcolor'           , 'black', ...
                    'horizontalalignment'       , 'center', ...
                    'fontweight'                , 'bold', ...
                    'string'                    , 'Start value', ...
                    'parent'                    , FIGURE, ...
                    'Units'                     , 'normalized',...
                    'Position'                  , [0.425 0.6 0.15 0.06],...
                    'tag'                       , 'MEASURE_LINE_TXT');
                
STEP_START = uicontrol('style'                    , 'edit', ...
                    'enable'                   , 'on', ...
                    'parent'                   , FIGURE, ...
                    'Units'                    , 'normalized',...
                    'string'                    , '0', ...
                    'Position'                 , [0.425 0.55 0.15 0.07],...
                    'tag'                      , 'STEP_START');
                
% Step stop value text label 
            uicontrol('style'         , 'text', ...
                    'foregroundcolor'           , 'black', ...
                    'horizontalalignment'       , 'center', ...
                    'fontweight'                , 'bold', ...
                    'string'                    , 'Stop value', ...
                    'parent'                    , FIGURE, ...
                    'Units'                     , 'normalized',...
                    'Position'                  , [0.425 0.45 0.15 0.06],...
                    'tag'                       , 'MEASURE_LINE_TXT');
                
STEP_STOP = uicontrol('style'                    , 'edit', ...
                    'enable'                   , 'on', ...
                    'parent'                   , FIGURE, ...
                    'Units'                    , 'normalized',...
                    'string'                    , '-2', ...
                    'Position'                 , [0.425 0.4 0.15 0.07],...
                    'tag'                      , 'STEP_STOP');  

% Step nb text label
          uicontrol('style'         , 'text', ...
                    'foregroundcolor'           , 'black', ...
                    'horizontalalignment'       , 'center', ...
                    'fontweight'                , 'bold', ...
                    'string'                    , 'Nb steps', ...
                    'parent'                    , FIGURE, ...
                    'Units'                     , 'normalized',...
                    'Position'                  , [0.425 0.3 0.15 0.06],...
                    'tag'                       , 'MEASURE_LINE_TXT');
                
STEP_POINTS = uicontrol('style'                    , 'edit', ...
                    'enable'                   , 'on', ...
                    'parent'                   , FIGURE, ...
                    'Units'                    , 'normalized',...
                    'string'                    , '10', ...
                    'Position'                 , [0.425 0.25 0.15 0.07],...
                    'tag'                      , 'STEP_POINTS');
 
% Step unit text label                
          uicontrol('style'         , 'text', ...
                    'foregroundcolor'           , 'black', ...
                    'horizontalalignment'       , 'center', ...
                    'fontweight'                , 'bold', ...
                    'string'                    , 'Unit', ...
                    'parent'                    , FIGURE, ...
                    'Units'                     , 'normalized',...
                    'Position'                  , [0.425 0.15 0.15 0.06],...
                    'tag'                       , 'MEASURE_LINE_TXT');

                
STEP_UNIT = uicontrol('style'                    , 'edit', ... 
                    'enable'                   , 'on', ...
                    'parent'                   , FIGURE, ...
                    'Units'                    , 'normalized',...
                    'String'                   , 'V',...
                    'Position'                 , [0.425 0.1 0.15 0.07],...
                    'tag'                      , 'SWEEP_POINTS');
                

%% Step2 column text label
          uicontrol('style'         , 'text', ...
                    'foregroundcolor'           , 'black', ...
                    'horizontalalignment'       , 'center', ...
                    'fontweight'                , 'bold', ...
                    'string'                    , 'Step2', ...
                    'fontsize'                  , 15,...
                    'parent'                    , FIGURE, ...
                    'Units'                     , 'normalized',...
                    'Position'                  , [0.75 0.82 0.15 0.08],...
                    'tag'                       , 'MEASURE_LINE_TXT');
                
% Step2 parameter text label                
          uicontrol('style'         , 'text', ...
                    'foregroundcolor'           , 'black', ...
                    'horizontalalignment'       , 'center', ...
                    'fontweight'                , 'bold', ...
                    'string'                    , 'Parameter', ...
                    'parent'                    , FIGURE, ...
                    'Units'                     , 'normalized',...
                    'Position'                  , [0.75 0.75 0.15 0.06],...
                    'tag'                       , 'MEASURE_LINE_TXT'); 
                
STEP2_CHANNEL = uicontrol('style'                    , 'edit', ...
                    'enable'                   , 'on', ...
                    'parent'                   , FIGURE, ...
                    'Units'                    , 'normalized',...
                    'String'                   , 'DAC 21',...
                    'Position'                 , [0.75 0.7 0.15 0.07],...
                    'tag'                      , 'STEP2_CHANNEL'); 

% Step2 start value text label
          uicontrol('style'         , 'text', ...
                    'foregroundcolor'           , 'black', ...
                    'horizontalalignment'       , 'center', ...
                    'fontweight'                , 'bold', ...
                    'string'                    , 'Start value', ...
                    'parent'                    , FIGURE, ...
                    'Units'                     , 'normalized',...
                    'Position'                  , [0.75 0.6 0.15 0.06],...
                    'tag'                       , 'MEASURE_LINE_TXT');
                
STEP2_START = uicontrol('style'                    , 'edit', ...
                    'enable'                   , 'on', ...
                    'parent'                   , FIGURE, ...
                    'Units'                    , 'normalized',...
                    'string'                    , '0', ...
                    'Position'                 , [0.75 0.55 0.15 0.07],...
                    'tag'                      , 'STEP2_START');

% Step2 stop value text label                
          uicontrol('style'         , 'text', ...
                    'foregroundcolor'           , 'black', ...
                    'horizontalalignment'       , 'center', ...
                    'fontweight'                , 'bold', ...
                    'string'                    , 'Stop value', ...
                    'parent'                    , FIGURE, ...
                    'Units'                     , 'normalized',...
                    'Position'                  , [0.75 0.45 0.15 0.06],...
                    'tag'                       , 'MEASURE_LINE_TXT');
                
STEP2_STOP = uicontrol('style'                    , 'edit', ...
                    'enable'                   , 'on', ...
                    'parent'                   , FIGURE, ...
                    'Units'                    , 'normalized',...
                    'string'                    , '1', ...
                    'Position'                 , [0.75 0.4 0.15 0.07],...
                    'tag'                      , 'STEP2_STOP');  

% Step2 nb text label                
          uicontrol('style'         , 'text', ...
                    'foregroundcolor'           , 'black', ...
                    'horizontalalignment'       , 'center', ...
                    'fontweight'                , 'bold', ...
                    'string'                    , 'Nb steps', ...
                    'parent'                    , FIGURE, ...
                    'Units'                     , 'normalized',...
                    'Position'                  , [0.75 0.3 0.15 0.06],...
                    'tag'                       , 'MEASURE_LINE_TXT');
                
STEP2_POINTS = uicontrol('style'                    , 'edit', ...
                    'enable'                   , 'on', ...
                    'parent'                   , FIGURE, ...
                    'Units'                    , 'normalized',...
                    'string'                    , '1', ...
                    'Position'                 , [0.75 0.25 0.15 0.07],...
                    'tag'                      , 'STEP2_POINTS');
                
% Step2 unit text label
          uicontrol('style'         , 'text', ...
                    'foregroundcolor'           , 'black', ...
                    'horizontalalignment'       , 'center', ...
                    'fontweight'                , 'bold', ...
                    'string'                    , 'Unit', ...
                    'parent'                    , FIGURE, ...
                    'Units'                     , 'normalized',...
                    'Position'                  , [0.75 0.15 0.15 0.06],...
                    'tag'                       , 'MEASURE_LINE_TXT');

                
STEP2_UNIT = uicontrol('style'                    , 'edit', ... 
                    'enable'                   , 'on', ...
                    'parent'                   , FIGURE, ...
                    'Units'                    , 'normalized',...
                    'String'                   , 'V',...
                    'Position'                 , [0.75 0.1 0.15 0.07],...
                    'tag'                      , 'SWEEP_POINTS');
                
                  
%%OK button                
          uicontrol('style'                    , 'pushbutton', ...
                    'string'                   , 'OK', ...
                    'callback'                 , @Data_reshaping, ...
                    'enable'                   , 'on', ...
                    'parent'                   , FIGURE, ...
                    'Units'                    , 'normalized',...
                    'Position'                 , [0.25 0 0.5 0.08],...
                    'tag'                      , 'OK');              
   
                
    function [] = Data_reshaping(hObject,eventdata)
        % exctracting the new data shape set by the user in the GUI
        Sweep_channel=get(SWEEP_CHANNEL,'string');
        Sweep_start=str2double(get(SWEEP_START,'string'));
        Sweep_stop=str2double(get(SWEEP_STOP,'string'));
        Sweep_points=str2double(get(SWEEP_POINTS,'string'));
        Sweep_unit = get(SWEEP_UNIT,'string');
        
        Step_channel=get(STEP_CHANNEL,'string');
        Step_start=str2double(get(STEP_START,'string'));
        Step_stop=str2double(get(STEP_STOP,'string'));
        Step_points=str2double(get(STEP_POINTS,'string'));
        Step_unit = get(STEP_UNIT,'string');

        Step2_channel=get(STEP2_CHANNEL,'string');
        Step2_start=str2double(get(STEP2_START,'string'));
        Step2_stop=str2double(get(STEP2_STOP,'string'));
        Step2_points=str2double(get(STEP2_POINTS,'string'));
        Step2_unit = get(STEP2_UNIT,'string');
        
        % loading the data from the workspace plotter        
        a = evalin('base','WP_handle');
        data_length=size(a.LOADED_SCAN_DATA.data,1);
        reshaped_length=Sweep_points*Step_points*Step2_points;
        if reshaped_length<data_length
            warning('The data lengths before and after reshaping are not matching:')
            fprintf('before: %i \n after: %i (%i x %i x %i)' ,data_length,reshaped_length,Sweep_points,Step_points,Step2_points)
        elseif reshaped_length>data_length
            warning('The data lengths before and after reshaping are not matching:')
            a.LOADED_SCAN_DATA.data=[squeeze(a.LOADED_SCAN_DATA.data); NaN*ones(reshaped_length-data_length,a.LOADED_SCAN_DATA.Nmeasure)];
        end
        
        % reshape taking the expected amount from original data
        a.LOADED_SCAN_DATA.data = reshape(a.LOADED_SCAN_DATA.data(1:reshaped_length,1:a.LOADED_SCAN_DATA.Nmeasure),Sweep_points,Step_points,Step2_points,a.LOADED_SCAN_DATA.Nmeasure); 
        
        % update data shape in workspace plotter
        a.LOADED_SCAN_DATA.Nsweep=Sweep_points;
        a.LOADED_SCAN_DATA.Nstep=Step_points;
        a.LOADED_SCAN_DATA.Nstep2=Step2_points;

        a.LOADED_SCAN_DATA.sweep_dim.param_infos{1}(1)= {Sweep_channel};
        a.LOADED_SCAN_DATA.sweep_dim.param_infos{1}(2)= {num2str(Sweep_start)};
        a.LOADED_SCAN_DATA.sweep_dim.param_infos{1}(3)= {num2str(Sweep_stop)};
        a.LOADED_SCAN_DATA.sweep_dim.param_infos{1}(4)= {Sweep_unit};

        a.LOADED_SCAN_DATA.step_dim.used_param_number=1;
        a.LOADED_SCAN_DATA.step_dim.param_infos{1}(1)= {Step_channel};
        a.LOADED_SCAN_DATA.step_dim.param_infos{1}(2)= {num2str(Step_start)};
        a.LOADED_SCAN_DATA.step_dim.param_infos{1}(3)= {num2str(Step_stop)};
        a.LOADED_SCAN_DATA.step_dim.param_infos{1}(4)= {Step_unit};

        a.LOADED_SCAN_DATA.step2_dim.used_param_number=1;
        a.LOADED_SCAN_DATA.step2_dim.param_infos{1}(1)= {Step2_channel};
        a.LOADED_SCAN_DATA.step2_dim.param_infos{1}(2)= {num2str(Step2_start)};
        a.LOADED_SCAN_DATA.step2_dim.param_infos{1}(3)= {num2str(Step2_stop)};
        a.LOADED_SCAN_DATA.step2_dim.param_infos{1}(4)= {Step2_unit};

        a.LOADED_SCAN_DATA.sweep_dim.param_values = Sweep_start : (Sweep_stop-Sweep_start)/(Sweep_points-1) : Sweep_stop;
        a.LOADED_SCAN_DATA.step_dim.param_values = Step_start : (Step_stop-Step_start)/(Step_points-1) : Step_stop;
        a.LOADED_SCAN_DATA.step2_dim.param_values = Step2_start : (Step2_stop-Step2_start)/(Step2_points-1) : Step2_stop;

        set(a.SWEEP_LABEL,'string', a.LOADED_SCAN_DATA.sweep_dim.build_dimlabel_string);
        set(a.STEP_LABEL,'string', a.LOADED_SCAN_DATA.step_dim.build_dimlabel_string);
        set(a.STEP2_LABEL,'string', a.LOADED_SCAN_DATA.step2_dim.build_dimlabel_string);
        
        set(a.SWEEP_START,'string', a.build_popup_string('sweep'),'value',1);
        set(a.SWEEP_STOP,'string', a.build_popup_string('sweep'),'value', Sweep_points);

        set(a.STEP_START,'string', a.build_popup_string('step'),'value',1);
        set(a.STEP_STOP,'string', a.build_popup_string('step'),'value', Step_points); 
        
        set(a.STEP2,'string', a.build_popup_string('step2'),'value',1);


        close(gcf)  
    
    
    end




end


