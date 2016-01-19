classdef Transfer_stat
    %Thresholds the data and compute the statistics to access the number of
    %electrons before and after a SAW burst.
    %   Detailed explanation goes here
    
    properties
        N1xxx
        N10xx
        N1000
        N1001
        N2xxx
        N20xx
        N21xx
        N2000
        N2001
        N2002
        N2100
        N2101
        N210xxx
        N210012
        Nbad1
        Nbad2
        
    end
    
    methods
        
        function[obj]=Transfer_stat(LSD,varargin)
            % deals with argin
            p = inputParser;
            default_fig_nb = 1;
            default_step2_param = 1;
            default_derivative = false;
            default_smooth = false;
            default_smooth_order = 0;
            addRequired(p,'LSD');
            addOptional(p,'step_range',-1);
            addOptional(p,'fig_nb',default_fig_nb);
            addOptional(p,'step2_param',default_step2_param);
            addOptional(p,'derivative',default_derivative);
            addOptional(p,'smooth',default_smooth);
            addOptional(p,'smooth_order',default_smooth_order);
            parse(p,LSD,varargin{:});
            LSD=p.Results.LSD;
            step_range=p.Results.step_range;
            fig_nb=p.Results.fig_nb;
            step2_param=p.Results.step2_param;
            derivative=p.Results.derivative;
            smooth=p.Results.smooth;
            smooth_order=p.Results.smooth_order;
            
            if LSD.Nstep==1
                disp('ERROR: This scan has no step');
                return;
            end
            
            % hack to take into account only the selected step range
            if step_range~=-1
                DATA=LSD.data(:,step_range(1):step_range(2),:,:);
                Nstep=step_range(2)-step_range(1)+1;
                if Nstep==1
                    disp('ERROR: Not enough steps are selected');
                    return;
                end
            else
                Nstep=LSD.Nstep;
            end
            
            step2.Ntot=size(LSD.step2_dim.param_values,2);
            if step2.Ntot>1  
                [step2.values, step2.label]=LSD.step2_dim.build_dim_axis(step2_param);
                while isempty(step2.values) || isequal(step2.values(1),step2.values(max(size(step2.values))))
                    disp('WARNING: The step2 coord. selected is not varying... Switching to next one');
                    step2_param=step2_param+1;
                    [step2.values, step2.label]=LSD.step2_dim.build_dim_axis(step2_param);
                end  
            else
                step2.values=0;
                step2.label='';
            end
            
            [analyse_mode,CANCELED] = Transfer_stat.mode_dialog;
            if CANCELED
              return;
            end
            [plot_choice,CANCELED]=Transfer_stat.fancy_dialog;% Ask what should be plotted at the end
            if CANCELED
                return;
            end

            filename=Load_Manager.remove_extension(LSD.filename);
            file = ['analyse\' filename '-stats.dat'];  % open file to dump most wanted stats
            fid = fopen(file, 'w+')
            if step2.Ntot>1  
               mkdir(['./analyse/' filename]);           % create the subdirectory to save the full stats for each step2.
            end

            % PRE-ASSIGNING DATA TO USE FOR THE PLOT
            [obj]=preassign(obj,step2.Ntot);

            % MAIN COMPUTATION
            [idx,threshold_number_used,QPC_inj,QPC_inj_correction,QPC_rec,QPC_rec_correction] = Transfer_stat.Ask_for_thresholds(); 
            Transfer_stat.Write_header(fid,threshold_number_used,step2);  
            figID=figure(fig_nb);
            clf(figID,'reset');
            [~, Y_label1]=LSD.measure_dim.build_dim_axis(1);
            [~, Y_label2]=LSD.measure_dim.build_dim_axis(2);
            
            skip=false;
            for i = 1:step2.Ntot
                step2.ind = i;
                % SET THRESHOLDS FOR RECEPTION DOT
                [M1]=Transfer_stat.extract_data_to_plot(DATA(:,:,step2.ind,QPC_rec),derivative,smooth,smooth_order);
                M1(idx.fin.first:idx.fin.last,:)=M1(idx.fin.first:idx.fin.last,:)+QPC_rec_correction;
                if strcmp(analyse_mode,'DIF')
                    average_ini=sum(M1(idx.ini.first:idx.ini.last,:)) / double(idx.ini.length);
                    average_fin=sum(M1(idx.fin.first:idx.fin.last,:)) / double(idx.fin.length);
                    dif=average_fin-average_ini;
                    dif=dif(:);
                    M1=[zeros(idx.ini.last,Nstep); repmat(dif',LSD.Nsweep-idx.ini.last,1)];
                end
                if skip==false % ask the user for threshold definitions
                    graph_title=['Select threshold level for reception dot - Step2 number ' num2str(step2.ind)];
                    if strcmp(analyse_mode,'RAW')
                        fancy_plot(fig_nb,idx.ini.first:idx.fin.last,M1(idx.ini.first:idx.fin.last,:),'XLabel','X dimension index','YLabel',Y_label1,'Title',graph_title);
                    elseif strcmp(analyse_mode,'DIF')
                        figure(fig_nb)
                        stem(M1(end,:),'linestyle',':','MarkerFaceColor',[0.9 0.1 0.1],'MarkerEdgeColor',[0.9 0.1 0.1])
                        xlabel('X dimension index')
                        ylabel(Y_label2)
                        title(graph_title)
                    end
                    if step2.ind>1 % add the previous thresholds on the figure
                        hold on
                        plot(xlim, [thresholds2(step2.ind-1,:); thresholds2(step2.ind-1,:)]);
                        hold off
                    end
                    defined=false;
                    while ~defined
                        w = waitforbuttonpress; % wait for user input
                        if w == 0
                            click_type=get(gcf,'selectiontype');
                            if strcmp(click_type,'open') % define new ones if mouse double click
                                [~,yth] = ginput(threshold_number_used); 
                                thresholds2(step2.ind,:) = yth;
                                defined=true;
                            end
                        else
                            thresholds2(step2.ind,:) = thresholds2(step2.ind-1,:); % keep previous thresholds if key pressed
                            defined=true;
                            p=get(gcf,'CurrentCharacter');
                            if p==13
                                skip=true;
                            end
                        end
                    end
                else %skip all the threshold definitions if user pressed ENTER
                    thresholds2(step2.ind,:) = thresholds2(step2.ind-1,:);
                end
                % SET THRESHOLDS FOR INJECTION DOT
                [M2]=Transfer_stat.extract_data_to_plot(DATA(:,:,step2.ind,QPC_inj),derivative,smooth,smooth_order);
                M2(idx.fin.first:idx.fin.last,:)=M2(idx.fin.first:idx.fin.last,:)+QPC_inj_correction;
                if strcmp(analyse_mode,'DIF')
                    average_ini=sum(M2(idx.ini.first:idx.ini.last,:)) / double(idx.ini.length);
                    average_fin=sum(M2(idx.fin.first:idx.fin.last,:)) / double(idx.fin.length);
                    dif=average_fin-average_ini;
                    dif=dif(:);
                    M2=[zeros(idx.ini.last,Nstep); repmat(dif',LSD.Nsweep-idx.ini.last,1)];
                end
                if skip==false % ask the user for threshold definitions
                    graph_title=['Select threshold level for injection dot - Step2 number ' num2str(step2.ind)];
                    if strcmp(analyse_mode,'RAW')
                        fancy_plot(fig_nb,idx.ini.first:idx.fin.last,M2(idx.ini.first:idx.fin.last,:),'XLabel','X dimension index','YLabel',Y_label2,'Title',graph_title);
                    elseif strcmp(analyse_mode,'DIF')
                        stem(M2(end,:),'linestyle',':','MarkerFaceColor',[0.9 0.1 0.1],'MarkerEdgeColor',[0.9 0.1 0.1])
                        xlabel('X dimension index')
                        ylabel(Y_label2)
                        title(graph_title)
                    end
                    if step2.ind>1 % add the previous thresholds on the figure
                        hold on
                        plot(xlim, [thresholds1(step2.ind-1,:); thresholds1(step2.ind-1,:)]);
                        hold off
                    end
                    % wait for user input
                    defined=false;
                    while ~defined
                        w = waitforbuttonpress; % wait for user input
                        if w == 0
                            click_type=get(gcf,'selectiontype');
                            if strcmp(click_type,'open') % define new ones if mouse double click
                                [~,yth] = ginput(threshold_number_used); 
                                thresholds1(step2.ind,:) = yth;
                                defined=true;
                            end
                        else
                            thresholds1(step2.ind,:) = thresholds1(step2.ind-1,:); % keep previous thresholds if key pressed
                            defined=true;
                            p=get(gcf,'CurrentCharacter');
                            if p==13
                                skip=true;
                            end
                        end
                    end
                else
                    thresholds1(step2.ind,:) = thresholds1(step2.ind-1,:);
                end
                M=cat(3,M1,M2);

                % COMPUTE THE STATISTICS
                stat = Transfer_stat.stats(M, idx, thresholds1(step2.ind,:), thresholds2(step2.ind,:));% all is done in stats function
                % save this step2 stats to a .m file
                if step2.Ntot>1
                    save(['analyse\' filename '\' filename '-stats-raw-step2_' num2str(step2.ind-1,'%3i') '.m'], 'stat');
                else
                    save(['analyse\' filename '-stats-raw-step2_' num2str(step2.ind-1,'%3i') '.m'], 'stat');
                end
                % save it also in .txt file
                Transfer_stat.Write_stat_data(fid,threshold_number_used,step2,stat);
                [obj] = obj.store_data(stat,step2,threshold_number_used);
            end
            fclose(fid);

            % PLOT THE RESULTS
            obj.plot_results(LSD,fig_nb,plot_choice,step2,Nstep+1);
        end 
 
        function [obj] = preassign(obj,Nstep2)
           obj.N1xxx=zeros(1,Nstep2);
           obj.N2xxx=zeros(1,Nstep2);
           obj.N10xx=zeros(1,Nstep2);
           obj.N20xx=zeros(1,Nstep2);
           obj.N1000=zeros(1,Nstep2);
           obj.N21xx=zeros(1,Nstep2);
           obj.N1001=zeros(1,Nstep2);
           obj.N2000=zeros(1,Nstep2);
           obj.N2001=zeros(1,Nstep2);
           obj.N2002=zeros(1,Nstep2);
           obj.N2100=zeros(1,Nstep2);
           obj.Nbad1=zeros(1,Nstep2);
           obj.Nbad2=zeros(1,Nstep2);
           obj.N2101=zeros(1,Nstep2);
           obj.N210xxx=zeros(1,Nstep2);
           obj.N210012=zeros(1,Nstep2);
        end
        
        function [obj] = store_data(obj,stat,step2,threshold_number_used)
            obj.N1xxx(step2.ind)=sum(sum(sum(sum(sum(stat.N(2,:,:,:,:,:))))));
            obj.N10xx(step2.ind)=sum(sum(sum(sum(stat.N(2,1,:,:,:,:)))));
            obj.N1000(step2.ind)=sum(sum(stat.N(2,1,:,1,1,:)));
            obj.N1001(step2.ind)=sum(sum(stat.N(2,1,:,1,2,:)));
            if threshold_number_used>1
                obj.N2xxx(step2.ind)=sum(sum(sum(sum(sum(stat.N(3,:,:,:,:,:))))));
                obj.N20xx(step2.ind)=sum(sum(sum(sum(stat.N(3,1,:,:,:,:)))));
                obj.N21xx(step2.ind)=sum(sum(sum(sum(stat.N(3,2,:,:,:,:)))));
                obj.N2000(step2.ind)=sum(sum(stat.N(3,1,:,1,1,:)));
                obj.N2001(step2.ind)=sum(sum(stat.N(3,1,:,1,2,:)));
                obj.N2002(step2.ind)=sum(sum(stat.N(3,1,:,1,3,:)));
                obj.N2100(step2.ind)=sum(sum(stat.N(3,2,:,1,1,:)));
                obj.N2101(step2.ind)=sum(sum(stat.N(3,2,:,1,2,:)));          
                obj.N210xxx(step2.ind)=sum(sum(sum(stat.N(3,2,1,:,:,:))));
                obj.N210012(step2.ind)=sum(sum(stat.N(3,2,1,1,2,3)));  
            end
            bad1=0;
            bad2=0;
            for ind = 1:threshold_number_used+1
               for j = 1:threshold_number_used+1
                  for k = 1:threshold_number_used+1
                    for l = 1:threshold_number_used+1
                      for m = 1:threshold_number_used+1
                        for n = 1:threshold_number_used+1
                            bad1 = bad1 + ((m-l)>(ind-j)) * stat.N(ind,j,k,l,m,n);
                            bad2 = bad2 + ((n-l)>(ind-k)) * stat.N(ind,j,k,l,m,n);
                        end
                      end
                    end
                  end
               end
            end
            obj.Nbad1(step2.ind)=bad1;
            obj.Nbad2(step2.ind)=bad2;
        end
        
        function [] = plot_results(obj,LSD,fig_nb,plot_choice,step2,step_nb)
            green=[0 0.6 0];
            orange=[0.8 0.3 0];
            red=[1 0 0];
            black=[0 0 0];
            grey=[0.3 0.3 0.3];

           if step2.Ntot>1
              figID=figure(fig_nb);
              clf(figID,'reset');
              set(figID,'name','TRANSFER STAT');
              hold on
              if plot_choice.N1xxx
              h=fancy_plot(fig_nb,step2.values,obj.N1xxx);
              set(h.Axes,'color',black,'LineWidth',3,'MarkerFaceColor',black,'Marker','o','LineStyle','--');
              set(h.Axes,'DisplayName','N1XXX');
              end
              if plot_choice.N2xxx
              h=fancy_plot(fig_nb,step2.values,obj.N2xxx); 
              set(h.Axes,'color',black,'LineWidth',3,'MarkerFaceColor',black,'Marker','o','LineStyle','--');
              set(h.Axes,'DisplayName','N2XXX');
              end
              if plot_choice.N10xx || plot_choice.all10
              h=fancy_plot(fig_nb,step2.values,obj.N10xx);
              set(h.Axes,'color',black,'LineWidth',3,'MarkerFaceColor',black,'Marker','o');
              set(h.Axes,'DisplayName','N10XX');
              end
              if plot_choice.N20xx || plot_choice.all2021
              h=fancy_plot(fig_nb,step2.values,obj.N20xx);
              set(h.Axes,'color',black,'LineWidth',3,'MarkerFaceColor',black,'Marker','o');
              set(h.Axes,'DisplayName','N20XX');
              end
              if plot_choice.N1000 || plot_choice.all10
              h=fancy_plot(fig_nb,step2.values,obj.N1000);
              set(h.Axes,'color',red,'LineWidth',3,'MarkerFaceColor',red,'Marker','o');
              set(h.Axes,'DisplayName','N1000');
              end
              if plot_choice.N21xx || plot_choice.all2021
              h=fancy_plot(fig_nb,step2.values,obj.N21xx);
              set(h.Axes,'color',grey,'LineWidth',3,'MarkerFaceColor',grey,'Marker','o','LineStyle','--');
              set(h.Axes,'DisplayName','N21XX');
              end
              if plot_choice.N1001 || plot_choice.all10
              h=fancy_plot(fig_nb,step2.values,obj.N1001);
              set(h.Axes,'color',green,'LineWidth',3,'MarkerFaceColor',green,'Marker','o');
              set(h.Axes,'DisplayName','N1001');
              end
              if plot_choice.N2000 || plot_choice.all2021
              h=fancy_plot(fig_nb,step2.values,obj.N2000);
              set(h.Axes,'color',red,'LineWidth',3,'MarkerFaceColor',red,'Marker','o');
              set(h.Axes,'DisplayName','N2000');
              end
              if plot_choice.N2001 || plot_choice.all2021
              h=fancy_plot(fig_nb,step2.values,obj.N2001);
              set(h.Axes,'color',orange,'LineWidth',3,'MarkerFaceColor',orange,'Marker','o');
              set(h.Axes,'DisplayName','N2001');
              end
              if plot_choice.N2002 || plot_choice.all2021
              h=fancy_plot(fig_nb,step2.values,obj.N2002);
              set(h.Axes,'color',green,'LineWidth',3,'MarkerFaceColor',green,'Marker','o');
              set(h.Axes,'DisplayName','N2002');
              end
              if plot_choice.N2100 || plot_choice.all2021
              h=fancy_plot(fig_nb,step2.values,obj.N2100);
              set(h.Axes,'color',red,'LineWidth',3,'MarkerFaceColor',red,'Marker','o','LineStyle','--');
              set(h.Axes,'DisplayName','N2100');
              end
              if plot_choice.Nbad1
              h=fancy_plot(fig_nb,step2.values,obj.Nbad1);
              set(h.Axes,'color',red,'LineWidth',3,'MarkerFaceColor',red,'Marker','o');
              set(h.Axes,'DisplayName','Nbad1');
              end
              if plot_choice.Nbad2
              h=fancy_plot(fig_nb,step2.values,obj.Nbad2);
              set(h.Axes,'color',red,'LineWidth',3,'MarkerFaceColor',red,'Marker','o');
              set(h.Axes,'DisplayName','Nbad2');
              end
              if plot_choice.N2101 || plot_choice.all2021
              h=fancy_plot(fig_nb,step2.values,obj.N2101);
              set(h.Axes,'color',orange,'LineWidth',3,'MarkerFaceColor',orange,'Marker','o','LineStyle','--');
              set(h.Axes,'DisplayName','N2101');
              end
              if plot_choice.N210xxx
              h=fancy_plot(fig_nb,step2.values,obj.N210xxx);
              set(h.Axes,'color',black,'LineWidth',3,'MarkerFaceColor',black,'Marker','o');
              set(h.Axes,'DisplayName','N210XXX');
              end
              if plot_choice.N210012
              h=fancy_plot(fig_nb,step2.values,obj.N210012);
              set(h.Axes,'color',green,'LineWidth',3,'MarkerFaceColor',green,'Marker','o');
              set(h.Axes,'DisplayName','N210012');
              end
              legend('show')
              box on
              grid on
              set(gca,'LineWidth',2,'ylim',[0 step_nb]);
              graph_title = [WORKSPACE_PLOTTER_OOP.process_underscore(LSD.filename) ' - Transfer Statistics'];
              h.Xlabel=xlabel(step2.label,'fontsize',14);
              h.Xlabel=ylabel('Number of events','fontsize',14);
              h.Title=title(graph_title,'fontsize',14);
              set(gca,'fontSize',14);
              h.savename=graph_title;
              hold off  
           end
        end


        
    end
    
    methods (Static)
        
        function [analyse_mode,CANCELED] = mode_dialog
            analyse_mode = questdlg('Choose the analysis mode:', ...
            'Analysis Mode', ...
            'Raw data thresholding','Differential averaged thresholding','Cancel','Differential averaged thresholding');
            switch analyse_mode
                case 'Raw data thresholding'
                    analyse_mode = 'RAW';
                    CANCELED=false;
                case 'Differential averaged thresholding'
                    analyse_mode = 'DIF';
                    CANCELED=false;
                case 'Cancel'
                    CANCELED=true;
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
            'Nbad1','Nbad1',[];
            '2101','N2101',[];
            'Nbad2','Nbad2',[];
            '210xxx','N210xxx',[];
            '210012','N210012',[];
            'all 10..','all10',[];
            'all 20../21..','all2021',[];};
            check_cell=cell(12,2);
            check_cell(:)={'check'};
            check_cell([5 6 7 10 11 23])={'none'};
            Formats = struct('type',check_cell);
            [ANSWER,CANCELED] = inputsdlg(Prompt,'What to plot',Formats);
        end
        
        function [M]=extract_data_to_plot(step2data,derivative,smooth,smooth_order)
        % --- select only data to be plotted from measure matrix and derivate/smooth it when required
            M=step2data;
            if derivative
                M=smooth2a(M,1,0);
                M=diff(M);
                N=size(M,1);
                M(N+1,:)=M(N,:);
            end
            if smooth
                M=smooth2a(M,smooth_order.sweep,smooth_order.step);   
            end
        end  
        
        function [stat] = stats(matrix, idx, thresholdinj, thresholdrec)
            % --- stats computes the useful statistics on the experimental run.
            % idx_ini_start, idx_ini_stop: delimit the initial position;
            % idx_med_start, idx_med_stop: delimit the intermediate position;
            % idx_fin_start, idx_fin_stop: delimit the final position;
            % thresholdinj: value (array of?) of thresholds for 0-1, 1-2.. electrons on
            %   injections side
            % thresholdrec: value (array of?) of thresholds for 0-1, 1-2.. electrons on
            %   reception side
            %matrix should be a 3D matrix: columns = sweeps
            %                              dim 3 = 1 => rec dot
            %                              dim 3 = 2 => inj dot

            nmax = max(max(size(thresholdinj), size(thresholdrec)));

            %%%%%%%%%% Work on injection data %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            %gets the references and measure for each trace.
            [sini_inj, smed_inj, sfin_inj] = Transfer_stat.calc_levels(matrix(:,:,2), idx);

            % count the number of electrons in each case
            [dnElecInjIni, dnElecInjMed, dnElecInjFin] = Transfer_stat.count_electrons(sini_inj, smed_inj, sfin_inj, thresholdinj);

            %%%%%%%%%% Work on reception data %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            %gets the references and measure for each trace.
            [sini_rec, smed_rec, sfin_rec] = Transfer_stat.calc_levels(matrix(:,:,1), idx);

            % count the number of electrons in each case
            [dnElecRecIni, dnElecRecMed, dnElecRecFin] = Transfer_stat.count_electrons(sini_rec, smed_rec, sfin_rec, thresholdrec);
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            % We now should compute the different conditionnal populations
            % indices will respectively refer to electron numbers:
            %   during ini in injection dot
            %   during med in injection dot
            %   during fin in injection dot
            %   during ini in reception dot
            %   during med in reception dot
            %   during fin in injection dot

            N = zeros(nmax,nmax,nmax,nmax,nmax,nmax);

            for i = 0:nmax
              for j = 0:nmax
                for k = 0:nmax
                  for l = 0:nmax
                    for m = 0:nmax
                      for n = 0:nmax
                    % case i j k l m n:
                    N(i+1,j+1,k+1,l+1,m+1,n+1) = sum(sum(dnElecInjIni == i &...
                        dnElecInjMed == j & dnElecInjFin == k & dnElecRecIni == l &...
                        dnElecRecMed == m & dnElecRecFin == n));
                      end
                    end
                  end
                end
              end
            end

            stat = runstatistics;
            stat.Ntot = size(matrix,2);
            stat.N_injected_1_0 = sum(sum(N(2,1,:,:,:,:)));
            stat.N_rec_inj = N(2,1,:,1,2,:);
            stat.N_rec_ninj = N(2,2,:,1,2,:) + N(1,2,:,1,2,:) + N(1,1,:,1,2,:);
            stat.N_noload = sum(sum(sum(N(1,:,:,:,:,:))));
            % saves all the information
            stat.N = N;
        end
        
        function [dnElecIni, dnElecMed, dnElecFin] = count_electrons(sini, smed, sfin, threshold)
            %count_electrons returns the number of electrons in injection and reception
            %states
            %   sini, smed and sfin are the average signals in initial part,
            %   intermediate part and final part.
            %   threshold gives the counting threshold for (n, n+1) electrons.
            %   threshold(1) should sepparate the (0,1)e- level, threshold(2) the (1,2)...
            %
            % threshold values should correspond to a usual QPC i.e. bigger value means less electrons.

            % let's sort the thresholds, just to be sure...
            threshold = sort(threshold);

            % initialization
            dnElecIni = zeros(size(sini));
            dnElecMed = zeros(size(smed));
            dnElecFin = zeros(size(sfin));

            % below threshold = there is an electron
            for i = 1:size(threshold,2)
              dnElecIni = dnElecIni + (threshold(i)>sini);
              dnElecMed = dnElecMed + (threshold(i)>smed);
              dnElecFin = dnElecFin + (threshold(i)>sfin);
            end

        end
            
        function [sini, smed, sfin] = calc_levels(matrix, indices)
            % computes the average of the signals from 'idx_ini_start' to
            % 'idx_ini_stop' (ini_signal), from 'idx_med_start' to 'idx_med_stop'   
            % (med_signal)...
            % 
            %   matrix is the 2D matrix (columns = sweeps).
            sini = sum(matrix(indices.ini.first:indices.ini.last,:)) / double(indices.ini.length);
            smed = sum(matrix(indices.med.first:indices.med.last,:)) / double(indices.med.length);
            sfin = sum(matrix(indices.fin.first:indices.fin.last,:)) / double(indices.fin.length);
        end
        
        function [] = Write_header(fid,threshold_number_used,step2)
            fprintf(fid, 'N_{tot}'); % total number of electrons

            if ~strcmp(step2.label,'') % if something is varied in step2
                fprintf(fid, '\t%s',step2.label);
            else
                fprintf(fid, '\tDummy'); % for further ease of use with plotting routines
            end
            strHeader = '';
            for step2ind = 1:threshold_number_used       % number of total injection, for load = 1...nmax
              strHeader = [strHeader '\tN_{' num2str(step2ind) '0xXXX}'];
            end
            for step2ind = 1:threshold_number_used+1     % number of loads with 0...nmax electrons
              strHeader = [strHeader '\tN_{load ' num2str(step2ind-1) '}'];
            end
            strHeader = [strHeader '\tN_{21xXXX}'];     % number of loads at 2, 1 sent
            strHeader = [strHeader '\tN_{21x01X}'];     % number of split singlets, the sent electron getting caught
            strHeader = [strHeader '\tN_{20x02X}'];     % number of loads at 2, 2 sent AND received
            strHeader = [strHeader '\tN_{20x01X}'];     % number of loads at 2, 2 sent AND 1 received (start from 0)
            strHeader = [strHeader '\tN_{10x01X}'];     % number of loads at 1, 1 sent AND 1 received (start from 0)
            strHeader = [strHeader '\tN_{10x00X}'];     % number of loads at 1, 1 sent AND 0 received (start from 0)
            strHeader = [strHeader '\tN_{bad}'];        % number of _bad_ traces (more reception than injections)
            strHeader = [strHeader '\tN_{xxx0XX}'];     % number of load 0 for rec dot
            strHeader = [strHeader '\tN_{210XXX}'];     % number of 210XXX
            strHeader = [strHeader '\tN_{210012}'];     % number of total sequence OK
            strHeader = [strHeader '\tN_{xxx012}'];     % number of reception of 2nd electron in 2nd pulse

            fprintf(fid, [strHeader '\n']);
        end
        
        function [idx,threshold_number_used,QPC_inj,QPC_inj_correction,QPC_rec,QPC_rec_correction] = Ask_for_thresholds()
            %% ASK FOR THRESHOLDS %% 2 SAW BURSTS CASE
%             answer = inputdlg({'Init start','Init stop','Intermediate start','Intermediate stop','Final start','Final stop','number of electrons'},'Thresholds', 1, {'200','250','300','350','351','352','2'});
%             if max(size(answer))==0     % user canceled?
%               return;
%             end
%             threshold_number_used = str2double(answer{7});
%             idx = indices;      % codes the intervals ref and measure in idx variable
%             idx.ini.setinterval(uint16([str2double(answer{1}) str2double(answer{2})]));
%             idx.med.setinterval(uint16([str2double(answer{3}) str2double(answer{4})]));
%             idx.fin.setinterval(uint16([str2double(answer{5}) str2double(answer{6})]));

            %% ASK FOR THRESHOLDS %% 1 SAW BURST CASE
            
            answer = inputdlg({'Init start','Init stop','Final start','Final stop','number of electrons','Injection QPC','Injection QPC correction','Reception QPC','Reception QPC correction'},'Thresholds', 1, {'90','130','140','180','2','2','0','1','0'});
            if max(size(answer))==0     % user canceled?
              return;
            end
            threshold_number_used = str2double(answer{5});
            idx = indices;      % codes the intervals ref and measure in idx variable
            idx.ini.setinterval(uint16([str2double(answer{1}) str2double(answer{2})]));
            idx.fin.setinterval(uint16([str2double(answer{3}) str2double(answer{4})]));
            idx.med=idx.fin;
            QPC_inj=str2double(answer{6});
            QPC_rec=str2double(answer{8});
            QPC_inj_correction=str2double(answer{7});
            QPC_rec_correction=str2double(answer{9});
        end
        
        function [] = Write_stat_data(fid,threshold_number_used,step2,stat)
            fprintf(fid, '%i\t', stat.Ntot);
            if step2.Ntot>1
              fprintf(fid, '%f\t', step2.values(step2.ind));
            else
              fprintf(fid, '\t');
            end
                                                        % NB: stat.N(1,...) = for 0 electrons!
            for ind = 2:threshold_number_used+1           % total injections
            fprintf(fid, '%i\t', sum(sum(sum(sum(stat.N(ind,1,:,:,:,:))))));
            end
            for ind = 1:threshold_number_used+1            % number of loads with i electrons
            fprintf(fid, '%i\t', sum(sum(sum(sum(sum(stat.N(ind,:,:,:,:,:)))))));
            end
            if threshold_number_used>1
                fprintf(fid, '%i\t', sum(sum(sum(sum(stat.N(3,2,:,:,:,:))))));        % number of 21xxxx
                fprintf(fid, '%i\t', sum(sum(stat.N(3,2,:,1,2,:))));                  % number of 21x01x
                fprintf(fid, '%i\t', sum(sum(stat.N(3,1,:,1,3,:))));                  % number of 20x02x 
                fprintf(fid, '%i\t', sum(sum(stat.N(3,1,:,1,2,:))));                  % number of 20x01x
            end
            fprintf(fid, '%i\t', sum(sum(stat.N(2,1,:,1,2,:))));                  % number of 10x01x
            fprintf(fid, '%i\t', sum(sum(stat.N(2,1,:,1,1,:))));                  % number of 10x00x                                                              
            bad = 0;                                                              % N bad traces (= more reception than injection)
            for ind = 1:threshold_number_used+1
            for j = 1:threshold_number_used+1
              for k = 1:threshold_number_used+1
                for l = 1:threshold_number_used+1
                  for m = 1:threshold_number_used+1
                    for n = 1:threshold_number_used+1
                        bad = bad + ((m-l)>(ind-j)) * stat.N(ind,j,k,l,m,n);
            %                         bad = bad + ((n-l)>(ind-k)) * stat.N(ind,j,k,l,m,n);
                    end
                  end
                end
              end
            end
            end
            fprintf(fid, '%i\t', bad);
            fprintf(fid, '%i\t', sum(sum(sum(sum(sum(stat.N(:,:,:,1,:,:)))))));   % number of xxx0xx
            if threshold_number_used>1
                fprintf(fid, '%i\t', sum(sum(sum(stat.N(3,2,1,:,:,:)))));             % number of 210XXX      
                fprintf(fid, '%i\t', stat.N(3,2,1,1,2,3));                            % number of 210012 
                fprintf(fid, '%i\t', sum(sum(sum(stat.N(:,:,:,1,2,3)))));             % number of xxx012
            end
            fprintf(fid, '\n');                               % Assuming we have all we want, go to new line for next step2
        end
        
    end
    
end

