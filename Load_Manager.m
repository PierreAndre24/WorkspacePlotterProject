classdef Load_Manager < handle & scan_data
    %Load data from .lvm or .mat files.
    %   Detailed explanation goes here
    
    properties
        Abort_flag=false;
        Error_flag=false;
        Warning_flag=false;
        load_err
        filepath='';
        filename='';
        fileID=-1;
        fileversion=[1,0];
    end

    methods
        
        function [obj] = Load_Manager(filepath,abort_handle)
        %'abort handle' argument is optionnal. Reference the object to check
        %when you want to allow load abortion of lvm files.
            obj.filepath=filepath;
            obj.filename=obj.remove_path(filepath);
            if nargin > 0
                try
                    if strcmp(filepath(end-3:end),'.lvm')
                        if nargin==2
                        obj=obj.lvmfile_loader(abort_handle);
                        else
                        obj=obj.lvmfile_loader;
                        end
                    elseif strcmp(filepath(end-3:end),'.mat')
                            a = obj.new_mfile_loader(filepath);
                        if isempty(a.data)
%                             delete(a);
                            obj=obj.old_mfile_loader(filepath);
                        else
                            obj=a;
                        end
                    else
                        obj.Error_flag=true;
                        warning('LOAD ERROR: Unknown file extension');
                    end
                    
                catch err
                    obj.Error_flag=true;
                    if obj.fileID~=-1 
                    fclose(obj.fileID); 
                    end
                    obj.load_err=err;
                    warning('LOAD ERROR: An unknown error occured while loading the file. Please check the data file formatting.');
                end
            end
        end
        
        function [obj] = lvmfile_loader(obj, abort_handle)
%         FILENAME can be a MATLABPATH relative partial pathname.  If the
%         file is not found in the current working directory, fopen searches for 
%         it on the MATLAB search path.  On UNIX systems, FILENAME may also start
%         with a "~/" or a "~username/", which fopen expands to the current
%         user's home directory or the specified user's home directory,
%         respectively.
%         Example of input used in workspace_plotter:
%         'C:\Users\...\aca_118.lvm' (string)

            %% OPEN FILE
            fid = fopen(obj.filepath, 'r'); % output the fid to track possible unclosed files
            disp(['loaded file ID:' num2str(fid)]);
            obj.fileID=fid;
            
            %% EXTRACT DATA FROM THE HEADER
            data_flag=0;
            while data_flag==0
                header_line=obj.findnextcomment(fid);
                [obj, data_flag]=obj.header_cases(header_line,fid);
            end

            %% EXTRACT MAIN DATA
           
            if obj.fileversion(1)==2
                obj=obj.lvmunshapeddata_loader(header_line);
            else
                obj=obj.lvmshapeddata_loader(header_line, abort_handle);
            end

            %% Correction of possible errors in the header infos
            if obj.Nsweep~=size(obj.data,1)
                warning('Sweep number is not the expected value. Header file might be incorrect.')
                obj.Nsweep=max(obj.Nsweep,size(obj.data,1));
            end
            if obj.Nstep~=size(obj.data,2)
                warning('Step number is not the expected value. Header file might be incorrect.')
                obj.Nstep=max(obj.Nstep,size(obj.data,2));
            end
            if obj.Nstep2~=size(obj.data,3)
                warning('Step2 number is not the expected value. Header file might be incorrect.')
                obj.Nstep2=max(obj.Nstep2,size(obj.data,3));
            end
            if obj.Nmeasure~=size(obj.data,4)
                warning('Measurement line number is not the expected value. Header file might be incorrect.')
                obj.Nmeasure=max(obj.Nmeasure,size(obj.data,4));
            end
            fclose(fid);

        end
                
        function [obj] = lvmunshapeddata_loader(obj, file_line)
            fid=obj.fileID;
            obj.sweep_dim=scan_dimension();
            obj.step_dim=scan_dimension();
            obj.step2_dim=scan_dimension();
            step_count=1;
            step2_count=1;
            eof_reached=false;
            scan_details=file_line;
            while ~eof_reached
                sweep_param_ind=0;
                while isempty(scan_details) || scan_details(1)=='#'
                    if isempty(scan_details) % directly go to next line if empty
                        scan_details = fgetl(fid);
                        continue 
                    end
                    dim=scan_details(1:7);
                    if strcmp(dim,'#sweep ')
                        sweep_param_ind=sweep_param_ind+1;
                        [obj]=store_infos(obj, scan_details, dim, sweep_param_ind, -1, 1);
                    end
                    scan_details = fgetl(fid);
                end

                data_line = scan_details;
                if data_line==-1
                    eof_reached = true;
                    continue
                end
                % finds how many data columns are contained in the file by
                % looking at the first line.
                columns_string=[];
                data_line = double(sscanf(data_line, '%e\t%e\t%e\t%e\t%e\t%e\t%e\t%e\t%e\t%e\t%e\t%e\t%e'));
                nb_data_columns = size(data_line,1);
                if nb_data_columns>(obj.Nmeasure+obj.sweep_dim.used_param_number)
                    warning(['the data file contains more columns than expected. \n'... 
                         'Make sure the file header contains correct measure line & sweep parameters infos'])
                end
                for i=1:nb_data_columns
                    columns_string=[columns_string '%f '];
                end
                % exctract the whole data
                sweep_data = textscan(fid,columns_string,Inf,'CommentStyle','#'); %'CommentStyle','#'
                try
                    sweep_data = cell2mat(sweep_data);
                    eof_reached=true;
                catch err
                    eof_reached=true;
                    continue
                end
                % store it where it should go
                obj.sweep_dim.param_values=horzcat(data_line(1:obj.sweep_dim.used_param_number),sweep_data(:,1:obj.sweep_dim.used_param_number)');
                for i=1:obj.Nmeasure
                    obj.data(1:size(sweep_data,1)+1,step_count,step2_count,i)=vertcat(data_line(obj.sweep_dim.used_param_number+i),sweep_data(:,obj.sweep_dim.used_param_number+i));
                end
                
            end

        end
        
        function [obj] = lvmshapeddata_loader(obj, file_line, abort_handle)
            fid=obj.fileID;
            obj.sweep_dim=scan_dimension();
            obj.step_dim=scan_dimension();
            obj.step2_dim=scan_dimension();
            step_count=0;
            step2_count=0;
            eof_reached=false;
            scanning_first_sweep=true;
            while ~eof_reached
                sweep_param_ind=0;
                step_param_ind=0;
                step2_param_ind=0;
                
                if scanning_first_sweep
                    scan_details=file_line;
                else
                    scan_details = fgetl(fid); % get scan infos in # lines
                end
                    while isempty(scan_details) || scan_details(1)=='#'
                        if isempty(scan_details) % directly go to next line if empty
                            scan_details = fgetl(fid);
                            continue 
                        end
                        dim=scan_details(1:7);
                        switch dim
                            case '#sweep '
                                sweep_param_ind=sweep_param_ind+1;
                                [obj]=store_infos(obj, scan_details, dim, sweep_param_ind, -1, scanning_first_sweep);
                            case '# step '
                                if step_param_ind==0
                                    step_count=step_count+1;
                                end
                                step_param_ind=step_param_ind+1;
                                [obj]=store_infos(obj, scan_details, dim, step_param_ind, step_count, scanning_first_sweep);
                            case '# step2'
                                if step2_param_ind==0
                                    step2_count=step2_count+1;
                                    step_count=1;
                                end
                                step2_param_ind=step2_param_ind+1;
                                [obj]=store_infos(obj, scan_details, dim, step2_param_ind, step2_count, scanning_first_sweep);
                            case '# step3'
                                % complete it the day files will have step3
                            otherwise
                                warning('ERROR: impossible to extract the dimension used in this line: " %s "', scan_details);
                        end
                        scan_details = fgetl(fid);
                    end

                data_line = scan_details;  

                if scanning_first_sweep % then read it line by line to check that the size info in the header was not crap...
                    obj.sweep_dim.param_values(obj.sweep_dim.used_param_number,obj.Nsweep)=0; 
                    Nsweep=0;
                    step_count=max(step_count,1); % in case there was no step(step2) set the indices to 1.
                    step2_count=max(step2_count,1);
                    line_is_data = true;
                    columns_string=[];

                    while(line_is_data)
                        switch data_line
                            case -1
                                eof_reached = true;
                                line_is_data = false;
                            case ''
                                line_is_data = false;
                            otherwise
                                Nsweep = Nsweep + 1;
                                data_line = double(sscanf(data_line, '%e\t%e\t%e\t%e\t%e\t%e\t%e\t%e\t%e\t%e\t%e\t%e\t%e'));
                                nb_data_columns = size(data_line,1);
                                if nb_data_columns>(obj.Nmeasure+obj.sweep_dim.used_param_number)
                                    warning(['the data file contains more columns than expected. \n'... 
                                    'Make sure the file header contains correct measure line & sweep parameters infos'])
                                end
                                if Nsweep==1
                                    for i=1:obj.sweep_dim.used_param_number
                                        columns_string=[columns_string '%*f ']; %*f tells textscan to skip the value
                                    end
                                    for i=obj.sweep_dim.used_param_number+1:nb_data_columns
                                        columns_string=[columns_string '%f ']; %f tells textscan to read the value
                                    end % in the end, sweep param values are ignored (already read in the first sweep...) and only the "real data" is read
                                end % if wrong info in the file header, crashes or sweep infos can be loaded instead of data (see previous warning)
                                obj.sweep_dim.param_values(1:obj.sweep_dim.used_param_number, Nsweep) = data_line(1:obj.sweep_dim.used_param_number);
                                obj.data(Nsweep,step_count,step2_count,:) = data_line(obj.sweep_dim.used_param_number+1:end)';
                                data_line = fgetl(fid);
                        end
                    end
                    scanning_first_sweep=false;
                else
                    if data_line==-1
                        eof_reached = true;
                        continue
                    end
                    first_data_line = sscanf(data_line, columns_string);
                    sweep_data = textscan(fid,columns_string,Nsweep);
                    try
                        sweep_data = cell2mat(sweep_data);
                    catch err
                        eof_reached=true;
                        continue
                    end
                    sweep_data=[first_data_line';sweep_data];
                    for i=1:obj.Nmeasure
                        obj.data(1:size(sweep_data,1),step_count,step2_count,i)=sweep_data(:,i);
                    end
                    if nargin>2
                        drawnow()
                        if get(abort_handle,'userdata')
                            set(abort_handle,'userdata',0)
                            break
                        end
                    end
                end
            end
        end
        
        function [obj] = store_infos(obj, scan_details, dim, dim_param_ind, dim_ind, scanning_first_sweep)
            [ name, unit, values ] = Load_Manager.switch_cases(scan_details, dim);
            switch dim
                case '#sweep '
                    obj.sweep_dim.param_infos{dim_param_ind} = {name; num2str(values(1)); num2str(values(2)); unit};
                    obj.sweep_dim.used_param_number=dim_param_ind;

                case '# step '
                    if scanning_first_sweep
                        obj.step_dim.param_infos{dim_param_ind} = {name; num2str(values); ''; unit};
                    else
                        obj.step_dim.param_infos{dim_param_ind} = {name; obj.step_dim.param_infos{dim_param_ind}{2}; num2str(values); unit};
                    end
                    obj.step_dim.used_param_number=max(obj.step_dim.used_param_number,dim_param_ind);
                    if dim_ind<=obj.Nstep
                        obj.step_dim.param_values(dim_param_ind,dim_ind) = values;
                    end

                case '# step2'
                    if scanning_first_sweep
                        obj.step2_dim.param_infos{dim_param_ind} = {name; num2str(values); ''; unit};
                    else
                        obj.step2_dim.param_infos{dim_param_ind} = {name; obj.step2_dim.param_infos{dim_param_ind}{2}; num2str(values); unit};
                    end
                    obj.step2_dim.used_param_number=max(obj.step2_dim.used_param_number,dim_param_ind);
                    obj.step2_dim.param_values(dim_param_ind,dim_ind) = values;

                case '# step3'
                    % complete it the day files will have step3
                otherwise
                    warning('ERROR: impossible to extract the dimension used in this line: %s', scan_details);
            end
        end
        
        function [obj] = new_mfile_loader(obj, filepath)
            
            struct = load('-mat', filepath);
            vars = fieldnames(struct);
            if isa(struct.(vars{1}),'Load_Manager') % data directly saved as a Load_Manager object
                obj=struct.(vars{1});
            elseif strcmp(vars,'obj_properties')   % object properties saved as a structure named 'obj_properties'
                obj.filepath=filepath;
                obj.filename=struct.obj_properties.filename;
                obj.data=struct.obj_properties.data;
                obj.Nsweep=struct.obj_properties.Nsweep;
                obj.Nstep=struct.obj_properties.Nstep;
                obj.Nstep2=struct.obj_properties.Nstep2;
                obj.Nmeasure=struct.obj_properties.Nmeasure;
                obj.sweep_dim=scan_dimension(struct.obj_properties.sweep_dim.used_param_number,struct.obj_properties.sweep_dim.param_infos,struct.obj_properties.sweep_dim.param_values);
                obj.step_dim=scan_dimension(struct.obj_properties.step_dim.used_param_number,struct.obj_properties.step_dim.param_infos,struct.obj_properties.step_dim.param_values);
                obj.step2_dim=scan_dimension(struct.obj_properties.step2_dim.used_param_number,struct.obj_properties.step2_dim.param_infos,struct.obj_properties.step2_dim.param_values);
                obj.measure_dim=scan_dimension(struct.obj_properties.measure_dim.used_param_number,struct.obj_properties.measure_dim.param_infos,struct.obj_properties.measure_dim.param_values);
                obj.DAC_init_values=struct.obj_properties.DAC_init_values;
                obj.B_field_value=struct.obj_properties.B_field_value;
            end
        end
                       
        function [obj] = old_mfile_loader(obj, filepath)
            % --- import files stored in matlab format
            name=obj.remove_extension(filepath);
            filename_infos=[name '_infos.mat'];
            measure=load(filepath);
            obj.data = cell2mat(struct2cell(measure));
            [obj.Nsweep, obj.Nstep, obj.Nstep2, obj.Nmeasure]=size(obj.data);
            obj.B_field_value=0;
            if exist(filename_infos, 'file')
                Struc_infofile = load(filename_infos);
                obj.DAC_init_values=Struc_infofile.DAC_init_values;
                obj.sweep_dim=scan_dimension(Struc_infofile.einfos.usedsweep,Struc_infofile.einfos.sweepinfos,Struc_infofile.sweep_param_values);
                obj.step_dim=scan_dimension(Struc_infofile.einfos.usedStep,Struc_infofile.einfos.stepinfos,Struc_infofile.step_param_values);
                obj.step2_dim=scan_dimension(Struc_infofile.einfos.usedStep2,Struc_infofile.einfos.step2infos,Struc_infofile.step2_param_values);
                obj.measure_dim=scan_dimension();
                obj.measure_dim.used_param_number=size(Struc_infofile.einfos.measures,2);
                for i=1:obj.measure_dim.used_param_number
                    obj.measure_dim.param_infos{i}(1)=Struc_infofile.einfos.measures{i}(1);
                    obj.measure_dim.param_infos{i}(4)=Struc_infofile.einfos.measures{i}(2);
                end
                clear('Struc_infofile');
            else
                obj.sweep_dim=scan_dimension(1,{'Unknown parameter'; '0'; num2str(obj.Nsweep-1); ' '},0:obj.Nsweep-1);
                obj.step_dim=scan_dimension(max(min(obj.Nstep-1,1),0),{'Unknown parameter'; '0'; num2str(obj.Nstep-1); ' '},0:obj.Nstep-1);
                obj.step2_dim=scan_dimension(max(min(obj.Nstep2-1,1),0),{'Unknown parameter'; '0'; num2str(obj.Nstep2-1); ' '},0:obj.Nstep2-1);
                obj.measure_dim=scan_dimension();
                obj.measure_dim.used_param_number=obj.Nmeasure;
                for i=1:obj.Nmeasure
                    obj.measure_dim.param_infos={['measure' num2str(i)];'';''; 'Unknown unit'};
                end
            end
            obj.filepath=filepath;
            obj.filename=obj.remove_path(filepath);
        end
        
        function [] = saveobj(obj, ask_for_permutation)
            filename_backup=obj.filename;
            filepath_backup=obj.filepath;
            obj.filename=[obj.filename(1:end-3) 'mat'];
            obj.filepath=[obj.filepath(1:end-3) 'mat'];
            name_to_save=Load_Manager.remove_extension(obj.filename);
            
            % ASK THE USER IF PERMUTATION IS REQUIRED

            if ask_for_permutation
                PermuteStr = inputdlg({'dimension 1','dimension 2','dimension 3'},'Permutation def',1,{'1','2','3'}); 
                if isempty(PermuteStr)    % user canceled?
                    return;
                end
                Permute=str2double(PermuteStr);
                Permute(4)=4;
                data=permute(obj.data,Permute');
                [Nsweep, Nstep, Nstep2, ~]=size(data);
                switch Permute(1)
                    case 1
                        sweep_dim=obj.sweep_dim;
                    case 2
                        sweep_dim=obj.step_dim;
                    case 3
                        sweep_dim=obj.step2_dim;
                end
                switch Permute(2)
                    case 1
                        step_dim=obj.sweep_dim;
                    case 2
                        step_dim=obj.step_dim;
                    case 3
                        step_dim=obj.step2_dim;
                end
                switch Permute(3)
                    case 1
                        step2_dim=obj.sweep_dim;
                    case 2
                        step2_dim=obj.step_dim;
                    case 3
                        step2_dim=obj.step2_dim;
                end
            else
                Nsweep=obj.Nsweep;
                Nstep=obj.Nstep;
                Nstep2=obj.Nstep2;
                sweep_dim=obj.sweep_dim;
                step_dim=obj.step_dim;
                step2_dim=obj.step2_dim;
                data=obj.data;
            end

            % STORE PROPERTIES IN A STRUCTURE
            obj_properties.filepath=obj.filepath;
            obj_properties.filename=obj.filename;
            obj_properties.data=data;
            obj_properties.Nsweep=Nsweep;
            obj_properties.Nstep=Nstep;
            obj_properties.Nstep2=Nstep2;
            obj_properties.Nmeasure=obj.Nmeasure;
            obj_properties.sweep_dim.used_param_number=sweep_dim.used_param_number;
            obj_properties.sweep_dim.param_infos=sweep_dim.param_infos;
            obj_properties.sweep_dim.param_values=sweep_dim.param_values;
            obj_properties.step_dim.used_param_number=step_dim.used_param_number;
            obj_properties.step_dim.param_infos=step_dim.param_infos;
            obj_properties.step_dim.param_values=step_dim.param_values;
            obj_properties.step2_dim.used_param_number=step2_dim.used_param_number;
            obj_properties.step2_dim.param_infos=step2_dim.param_infos;
            obj_properties.step2_dim.param_values=step2_dim.param_values;
            obj_properties.measure_dim.used_param_number=obj.measure_dim.used_param_number;
            obj_properties.measure_dim.param_infos=obj.measure_dim.param_infos;
            obj_properties.measure_dim.param_values=obj.measure_dim.param_values;
            obj_properties.DAC_init_values=obj.DAC_init_values;
            obj_properties.B_field_value=obj.B_field_value;
            
            save(name_to_save,'obj_properties');
            
            obj.filename=filename_backup;
            obj.filepath=filepath_backup;
        end
        
        function [obj, data_flag] = header_cases(obj, string_in, fid)
        %Deals with the different pieces of information found in the header
             data_flag=0;
             switch string_in(1:7)
                 
                 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%              
                case '# measu'
%%%%%%%%%%%%%%%%%%%% file writer version line
                    % exctracts the writer version in case someone needs to use it (useless for the moment)
                    writer_version = sscanf(string_in, '# measurement file writer version %i.%i');
                    if max(size(writer_version))~=2
                        disp(['Warning: file version could not be identified and might be missing';...
                              'Make sure that the loaded file contains such a string on top of the header:';...
                              '# measurement file writer version i.j']);
                    else
                        disp(['file version identified as ' num2str(writer_version(1)) '.' num2str(writer_version(2))])
                        obj.fileversion=[writer_version(1), writer_version(2)];
                    end
%%%%%%%%%%%%%%%%%%%% look for the next non-empty line to find the expected number of points
                    txtScan_size = fgetl(fid);
                    while isempty(txtScan_size)
                        txtScan_size = fgetl(fid);
                    end
                    try
                        % for old versions of the software having no step3 option
                        if strcmp(txtScan_size(1:57),'expected number of points (sweep, step, step2, measures):')
                        sizes = sscanf(txtScan_size, 'expected number of points (sweep, step, step2, measures): %e %e %e %e');
                        if writer_version(1)~=2 % no preallocation required for unshaped data codes
                            obj.data = zeros(sizes(1), sizes(2), sizes(3), sizes(4));
                        end
                        obj.Nsweep=sizes(1);
                        obj.Nstep=sizes(2);
                        obj.Nstep2=sizes(3);
                        obj.Nmeasure=sizes(4);
                        % for newer versions of the software having the step3 option available
                        elseif strcmp(txtScan_size(1:64),'expected number of points (sweep, step, step2, step3, measures):')
                        sizes = sscanf(txtScan_size, 'expected number of points (sweep, step, step2, step3, measures): %e %e %e %e %e');
                        if writer_version(1)~=2 % no preallocation required for unshaped data codes
                            obj.data = zeros(sizes(1), sizes(2), sizes(3), sizes(5));
                        end
                        obj.Nsweep=sizes(1);
                        obj.Nstep=sizes(2);
                        obj.Nstep2=sizes(3);
                        obj.Nmeasure=sizes(5);
                        else
                            warning('Error occured while reading file: impossible to read data size');
                        end
                    catch err
                        disp('Error occured while reading file: impossible to read data size')
                        rethrow(err);
                    end
 %%%%%%%%%%%%%%%%%%% look for names and units of the measured parameters
                    fgetl(fid); % goes through "measured values converted in"
                    txtUnit=fgetl(fid); % gets the measures names and units
                    measure_dim=scan_dimension();
                    while(size(txtUnit) ~= 0)
                        measure_dim.used_param_number = measure_dim.used_param_number+1; % counts the number of measure lines
                        measure_dim.param_infos{measure_dim.used_param_number}{1} = txtUnit; %store the name
                        txtUnit = fgetl(fid); %next line
                        if(size(txtUnit) == 0)
                            measure_dim.param_infos{measure_dim.used_param_number}{4} = ' '; % no specified unit
                        else
                            measure_dim.param_infos{measure_dim.used_param_number}{4} = txtUnit; % store the unit
                        end
                        txtUnit = fgetl(fid);
                    end
                    obj.measure_dim=measure_dim;
                    
                    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                        
                case '#DAC in'
                    % store information about DAC values used
                    DAC_values = zeros(8,8);% store DAC values in a 8x8 array
                    for panel = 1:8
                        for chanel = 1:8
                            txtDACValue = fgetl(fid);
                            DAC_values(panel,chanel) = str2double(txtDACValue);
                        end
                    end
                    obj.DAC_init_values=DAC_values;
            
            
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                case '#Mag fi'
                    % store information about B field used
                    if strcmp(string_in,'#Mag field initial Value')
                            header_line=fgetl(fid); % go to next line to access the value
                            obj.B_field_value=str2double(header_line);
                    elseif strcmp(string_in,'#Mag field initial value (Cartesian)')
                            header_line=fgetl(fid);
                            B_infos.init_value=str2double(header_line);
                            for i=1:3;header_line=fgetl(fid);end
                            B_infos.offset_cartesian=sscanf(header_line,'%f');
                            for i=1:3;header_line=fgetl(fid);end
                            B_infos.angle_offset=sscanf(header_line,'%f');
                    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                case '#DAC lo'
                    disp('INFO: Lock-in configuration is ignored');
                
                case '#AWG501'
                    disp('INFO: AWG configuration is ignored');
                
                case '#sweep '
                    data_flag=1;
            otherwise
                disp('WARNING: unrecognized header data has been ignored');
            end
        end
        
    end
    
    methods(Static)

        function [ name, unit, values ] = switch_cases( scan_details, dim )
            switch dim
                case '#sweep '
                    type = sscanf(scan_details, '#sweep %s');
                    [name, unit, values]=Load_Manager.sweep_cases(scan_details,type);
                case '# step '
                    type = sscanf(scan_details, '# step : %s');
                    [name, unit, values]=Load_Manager.step_cases(scan_details,type);
                case '# step2'
                    type = sscanf(scan_details, '# step2 : %s');
                    [name, unit, values]=Load_Manager.step_cases(scan_details,type);
            end
        end

        function [ name, unit, values ] = sweep_cases( txtSweep, type )
            switch type;
                case 'panel' % case of a DAC
                    X = sscanf(txtSweep, '#sweep panel %i chanel %i from %f V to %f V');
                    name = ['V_{' num2str(X(1)) ':' num2str(X(2)) '}'];
                    unit = 'V';
                    values(1) = X(3);
                    values(2) = X(4);
                case 'anritsuFrequence' % case of the anritsu RF gen, frequency
                    X = sscanf(txtSweep, '#sweep anritsuFrequence from %f GHz to %f GHz');
                    name = 'F_{RF}';
                    unit = 'GHz';
                    values(1) = X(1);
                    values(2) = X(2);
                case 'counter' % counter in case nothing is swept
                    X = sscanf(txtSweep, '#sweep counter from %f a.u. to %f a.u.');
                    name = 'counter';
                    unit = 'a.u.';
                    values(1) = X(1);
                    values(2) = X(2);
                case 'anritsuPower' % case of the anritsu RF gen, output power
                    X = sscanf(txtSweep, '#sweep anritsuPower from %f dBm to %f dBm');
                    name = 'P_{RF}';
                    unit = 'dBm';
                    values(1) = X(1);
                    values(2) = X(2);
                case 'magneticField' % magnetic field sweep
                    X = sscanf(txtSweep, '#sweep magneticField from %f T to %f T');
                    name = 'B (T)';
                    unit = 'T';
                    values(1) = X(1);
                    values(2) = X(2);
                case 'offset' %case of a DAC
                    X = sscanf(txtSweep, '#sweep offset panel %i chanel %i from %f V to %f V');
                    name = ['\delta V_{',num2str(X(1)), ':', num2str(X(2)), '}'];
                    unit = 'V';
                    values(1) = X(3);
                    values(2) = X(4);
                otherwise
                    warning(strcat('ERROR: unknown instrument used! ', type));
            end
        end

        function [ name, unit, value ] = step_cases( txtStep, type )
        %Deals with the different possible instruments
        %and extracts the informations/formats it in accordance
        %  
             switch txtStep(1:8)
               case '# step :'
                 stepstring='# step :';
               case '# step2 ' 
                 stepstring='# step2 :';
               case '# step3 '
                 stepstring='# step3 :';
             end

            switch type
                case 'DAC:'
                    X = sscanf(txtStep, [stepstring, ' DAC: channel %i:%i to %f V']);
                    name = ['V_{' num2str(X(1)) ':' num2str(X(2)) '}'];
                    unit = 'V';
                    value = X(3);
                case 'power:'
                    X = sscanf(txtStep, [stepstring, ' power: %f dBm']);
                    name = 'P_{RF}';
                    unit = 'dBm';
                    value = X(1);
                case 'frequency:' %case of the RF gen, frequency
                    X = sscanf(txtStep, [stepstring,' frequency: %f GHz']);
                    name = 'f_{RF}';
                    unit = 'GHz';
                    value = X(1);
                case 'counter:' %case of the anritsu RF gen, frequency
                    X = sscanf(txtStep, [stepstring,' counter: %f a.u.']);
                    name = 'counter';
                    unit = 'a.u.';
                    value = X(1);
                case 'magneticField:' %case of the anritsu RF gen, frequency
                    X = sscanf(txtStep, [stepstring,' magneticField: %f T']);
                    name = 'magneticField';
                    unit = 'T';
                    value = X(1);
                case 'fast' % fast sequence
                    type = sscanf(txtStep, [stepstring,' fast seq: %s']);
                        switch type(1:5)
                            case 'delta' % delta of a DAC
                                X = sscanf(txtStep, [stepstring,' fast seq: delta_{%i:%i}^{%i}: %f V']);
                                name = ['\delta{}V_{' num2str(X(1)) ':' num2str(X(2)) '}^{' num2str(X(3)) '}'];
                                unit = 'V';
                                value = X(4);
                            case 'timin'
                                X = sscanf(txtStep, [stepstring,' fast seq: timing slot %i: %f ms']);
                                name = ['T_{slot ' num2str(X(1)) '}'];
                                unit = 'ms';
                                value = X(2);
                            case '\delt'
                                X = sscanf(txtStep, [stepstring,' fast seq: %s']);
                                name = X(1:size(X,2)-1);
                                X = sscanf(txtStep, [stepstring,' fast seq: \' name ': %f V']);
                                unit = 'V';
                                value = X;
                        otherwise
                            warning(strcat('CAUTION: unknown fast sequence sub-instrument stepped! ', type));
                        end
                case 'RF_pulse_length:'
                    X = sscanf(txtStep, [stepstring,' RF_pulse_length: %f samples']);
                    name = '\tau_{SAW Burst}';
                    unit = 'samples';
                    value = X(1);
                case 'gate_pulse_high_1:' %case of the tektro arb. gen, pulse value
                    X = sscanf(txtStep, [stepstring,' gate_pulse_high_1: %f V']);
                    name = 'gate pulse V_{pulse 1}';
                    unit = 'V';
                    value = X(1);
                case 'gate_pulse_length_1:' %case of the tektro arb. gen, pulse length
                    X = sscanf(txtStep, [stepstring,' gate_pulse_length_1: %f samples']);
                    name = 'gate pulse length_{pulse 1}';
                    unit = 'samples';
                    value = X(1);
                case 'gate_pulse_delay_1:' %case of the tektro arb. gen, pulse delay
                    X = sscanf(txtStep, [stepstring,' gate_pulse_delay_1: %f samples']);
                    name = 'gate pulse delay_{pulse 1}';
                    unit = 'samples';
                    value = X(1);
                case 'gate_pulse_high_2:' %case of the tektro arb. gen, pulse value
                    X = sscanf(txtStep, [stepstring,' gate_pulse_high_2: %f V']);
                    name = 'gate pulse V_{pulse 2}';
                    unit = 'V';
                    value = X(1);
                case 'gate_pulse_length_2:' %case of the tektro arb. gen, pulse length
                    X = sscanf(txtStep, [stepstring,' gate_pulse_length_2: %f samples']);
                    name = 'gate pulse length_{pulse 2}';
                    unit = 'samples';
                    value = X(1);
                case 'gate_pulse_delay_2:' %case of the tektro arb. gen, pulse delay
                    X = sscanf(txtStep, [stepstring,' gate_pulse_delay_2: %f samples']);
                    name = 'gate pulse delay_{pulse 2}';
                    unit = 'samples';
                    value = X(1);
                case 'AWG5014C:' %case of the AWG5014
                    X = sscanf(txtStep, [stepstring, ' AWG5014C:  channel: %i  stage: %i  parameter: %i to: : %f']);
                    switch X(3)
                       case 1
                           name =['Channel ' num2str(X(1)) ' Stage ' num2str(X(2)) ' Kind'];
                           unit ='type';
                           value=X(4);
                       case 2
                           name =['Channel ' num2str(X(1)) ' Stage ' num2str(X(2)) ' Nmbr of Points'];
                           unit ='points';
                           value=X(4);
                       case 3
                           name =['Channel ' num2str(X(1)) ' Stage ' num2str(X(2)) ' Vini'];
                           unit ='V';
                           value=X(4);
                       case 4
                           name =['Channel ' num2str(X(1)) ' Stage ' num2str(X(2)) ' Vfin'];
                           unit ='V';
                           value=X(4);                   
                       otherwise
                           warning(strcat('there is a problem with the changed parameter', type));
                    end
            otherwise
                warning(strcat('CAUTION: unknown instrument stepped!', type));
            end
        end
        
        function [string_out] = remove_extension(string_in)
            % --- Remove the .lvm, .mat... of filename
            [PATHSTR,NAME]=fileparts(string_in);
            if isempty(PATHSTR)
                string_out=NAME;
            else
                string_out=[PATHSTR '\' NAME];
            end
        end
        
        function [string_out] = remove_path(string_in)
            % --- Remove the .lvm, .mat... of filename
            if isempty(string_in)
                string_out=[];
                return
            end
            [~,NAME,EXT]=fileparts(string_in);
            if isempty(EXT)
                string_out=NAME;
            else
                string_out=[NAME EXT];
            end
        end
        
        function [comment_string] = findnextcomment(fid)
            %finds the next line of the fid file starting with #
            found=0;
            while ~found
                comment_string=fgetl(fid);
                if isempty(comment_string)
                    continue
                elseif strcmp(comment_string(1),'#')
                    found=1;
                else
                    continue
                end
            end
        end
        

    
    end
    
end

