classdef fancy_plot < handle
    % 1D Plot with predefined plot options and UI menus to useful instances.
    %   Required arguments are figure number for the plot, X and Y data. Y
    %   can be a 2D matrix.
    %   Provides save and export to base utilities functions, and spline &
    %   smooth of a single curve.
    
    
    properties
        figID
        X
        Xlabel
        Y
        Ylabel
        Axes
        Title
        Legend
        savename='';
    end
    
    methods
        
        function [obj] = fancy_plot(ID,X,Y,varargin)
            % deals with argin
            p = inputParser;
            defaultXlabel = 'X';
            defaultYlabel = 'Y';
            defaultTitle = '1D plot';
            defaultLegend = '';
            addRequired(p,'ID');
            addRequired(p,'X');
            addRequired(p,'Y');
            addOptional(p,'Xlabel',defaultXlabel);
            addOptional(p,'Ylabel',defaultYlabel);
            addOptional(p,'title',defaultTitle);
            addOptional(p,'legend',defaultLegend);
            parse(p,ID,X,Y,varargin{:});
            % create the figure
            obj.figID=figure(ID);
            datacursormode off
            plotedit off
            zoom off
            pan off
            rotate3d off
            % plot the graph with all options
            obj.X=p.Results.X;
            obj.Y=p.Results.Y;
            if size(obj.X,1)~=size(obj.Y,1) && size(obj.X,2)~=size(obj.Y,2)
                obj.X=obj.X';
            end   
            obj.Axes = plot(obj.X,obj.Y); 
%           obj.Axes = reduce_plot(obj.X,pobj.Y); this one gets faster to diplay plots when data are too large
            set(obj.Axes,'LineWidth',2);
            set(gca,'fontSize',14);
            obj.Xlabel=xlabel(p.Results.Xlabel,'fontsize',14);
            set(obj.Xlabel,'tag','XLabel');
            obj.Ylabel=ylabel(p.Results.Ylabel,'fontsize',14);
            set(obj.Ylabel,'tag','YLabel');
            obj.savename=p.Results.title;
            obj.Title=title(p.Results.title,'fontsize',14);
            if size(p.Results.legend,2)>0 && size(p.Results.legend,2)<20 && isempty(cell2mat(strfind(p.Results.legend,'counter'))) % insert the legend when it's not too big (<20) && if it's not a counter
                obj.Legend=legend(p.Results.legend);
            end
            set(gcf, 'renderer', 'zbuffer'); % prevent possible graphic card driver bug cf. http://www.mathworks.com/matlabcentral/answers/53874
            colormap(jet(256))
            grid on
            box on
            set(gca,'LineWidth',2);
%             set(obj.figID,'CloseRequestFcn',{@obj.delete});
            
            obj.add_figure_context_menu();
            obj.add_1D_axes_context_menu();

        end
        
%         function delete(obj,hObject, eventdata)
%             delete(obj.figID);
%         end 
        
        
        
        function [] = add_figure_context_menu(obj)
            fig_uimenu=uicontextmenu;
            uimenu(fig_uimenu, 'Label', 'Save figure (.png)', 'Callback', {@obj.save_figure_png});
            uimenu(fig_uimenu, 'Label', 'Save figure (.fig) (! kills rightclick and key callbacks !)', 'Callback', {@obj.save_figure_fig});
            uimenu(fig_uimenu, 'Label', 'Export figure data to base workspace', 'Callback', {@obj.export_figdata_to_base});
            uimenu(fig_uimenu, 'Label', 'Copy to new figure', 'Callback', @obj.copy_to_new_fig);
            set(obj.figID, 'UIContextMenu', fig_uimenu);
        end
        
        function save_figure_png(obj,hObject, eventdata)
            [filename, fig_save_path] = uiputfile([pwd '\' fancy_plot.remove_backslash(obj.savename) '.png'],'Save As');
            if filename==0 % if user canceled
               return
            end
            saveas(obj.figID, [fig_save_path '\' filename], 'png'); 
        end

        function save_figure_fig(obj,hObject, eventdata)
            [filename, fig_save_path] = uiputfile([pwd '\' fancy_plot.remove_backslash(obj.savename) '.fig'],'Save As');
            if filename==0 % if user canceled
               return
            end
            delete(get(obj.figID,'UIContextMenu'));
            set(obj.figID,'KeyPressFcn','');
            fig_children=get(obj.figID,'Children');
            for i=size(fig_children,1):-1:1
                if strcmp(get(fig_children(i),'type'),'uicontextmenu')
                    delete(fig_children(i));
                end
            end
            saveas(gcf, [fig_save_path '\' filename], 'fig');
        end

        function copy_to_new_fig(obj,hObject, eventdata)
        h=get(obj.figID,'Children');
        cmap=(colormap(gcf));
        new_fig = inputdlg({'copy to figure number:'}, 'Please enter new figure number',1, {'10'});
        if max(size(new_fig))==0     % user canceled?
            return;
        end
        new_fig=str2double(new_fig);
        figure(new_fig);
        clf(new_fig,'reset');
        copyobj(h,new_fig);
        set(gcf, 'renderer', 'zbuffer'); % prevent possible graphic card driver bug cf. http://www.mathworks.com/matlabcentral/answers/53874
        colormap(cmap);
        end

        function export_figdata_to_base(obj,hObject, eventdata)
            fig_data.X=obj.X;
            fig_data.Y=obj.Y;
            fig_data.Xlabel=obj.Xlabel;
            fig_data.Ylabel=obj.Ylabel;
            assignin('base','fig1_data',fig_data);
        end
        
        
        
        function []=add_1D_axes_context_menu(obj)
            cline_uimenu=uicontextmenu;
            uimenu(cline_uimenu, 'Label', 'Smooth', 'Callback', {@fancy_plot.smooth_1D_graph});
            uimenu(cline_uimenu, 'Label', 'Spline', 'Callback', {@fancy_plot.spline_1D_graph});
            uimenu(cline_uimenu, 'Label', 'Derivate', 'Callback', {@fancy_plot.derivate_1D_graph});
            uimenu(cline_uimenu, 'Label', 'FFT filter', 'Callback', {@fancy_plot.fft_filter});
            uimenu(cline_uimenu, 'Label', 'Restore Init Data', 'Callback', {@obj.restore_init_values});
            uimenu(cline_uimenu, 'Label', 'Export XY data to base workspace', 'Callback', {@obj.export_XYdata_to_base});
            uimenu(cline_uimenu, 'Label', 'Save XY data', 'Callback', {@obj.save_XY_data});
            set(obj.Axes, 'UIContextMenu', cline_uimenu);          
        end      
    
        function save_XY_data(obj,hObject, eventdata)
            if strcmp(obj.savename,'')
                name='current_line';
            else 
                name=obj.savename;
            end           
            [save_name, save_path] = uiputfile([pwd '\' obj.remove_backslash(name) '_XYplot.mat'],'Save As');
            if save_name==0 % if user canceled
               return
            end
            if ismember(save_name(1),'0123456789')
                save_name=['x' save_name];    % hack for Tobias' way to name files
            end
            line_data.X=get(gco, 'XData');
            line_data.Y=get(gco, 'YData');  
            save([save_path save_name],'line_data');
        end

        function export_XYdata_to_base(obj,hObject, eventdata)
            line_data.X=get(gco, 'XData');
            line_data.Y=get(gco, 'YData');    
            assignin('base','line_data',line_data);
        end
        
        function restore_init_values(obj,hObject,eventdata)
            set(gco,'XData',obj.X)
            set(gco,'YData',obj.Y)
        end

    end
    
    methods (Static)
        
        function spline_1D_graph(hObject, eventdata)
            lineX=get(gco, 'XData');
            lineY=get(gco, 'YData');
            newX=lineX(1):(lineX(2)-lineX(1))/10:lineX(end);
            newY=ppval(spline(lineX,lineY),newX);
            set(gco,'Xdata',newX,'Ydata',newY);
        end
    
        function smooth_1D_graph(hObject, eventdata)
            orderStr = inputdlg({'moving average order:'},'Averaging order',1,{'3'}); 
            if max(size(orderStr))==0     % user canceled?
                return;
            end
            lineY=get(gco, 'YData');
            newY=smooth(lineY,str2double(orderStr));
            set(gco,'Ydata',newY);
        end
        
        function derivate_1D_graph(hObject, eventdata)
            lineX=get(gco, 'XData');
            lineY=get(gco, 'YData');
            newY=diff(lineY)./diff(lineX);
            newY(end+1)=newY(end);
            set(gco,'Ydata',newY);
        end
        
        function fft_filter(hObject,eventdata)

                YY=get(gco,'YData');
                XX=get(gco,'XData');
                XX_label=get(get(gca,'XLabel'),'String');
                h=FFT_filter_designer(XX,YY,'LABEL',XX_label);
                waitfor(h.figID);
                FFT_options=h.Output;
                if isempty(FFT_options)
                    return;
                end
                FFT_options.TYPE='X';
                h=FFT_filter(YY,FFT_options);
                YY=h.Output;
                set(gco,'YData',YY);
        end
        
        function [string_out] = remove_backslash(string_in)
            string_out=string_in;
            string_out(strfind(string_in,'\'))=[];
        end
        
    end
    
end

