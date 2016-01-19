classdef XY_Interactive_Slices
    %Interactive display of X and Y slices of a 2D plot data.
    %   Detailed explanation goes here
    
    properties
        figID
        axesID
        pcolorID
        X
        Xlabel
        Y
        Ylabel
        M
        Zlabel
        cmap
        colorbarID
        main_title
        Xslice
        Yslice
        textbox
        Xcursor
        Ycursor
        fig_limits              
        
    end
    
    methods
        function [obj]=XY_Interactive_Slices()
                obj.X=get(gco, 'XData');
                obj.Xlabel=get(gca,'Xlabel');
                obj.Xlabel=get(obj.Xlabel,'String');
                obj.Y=get(gco, 'YData');
                obj.Ylabel=get(gca,'Ylabel');
                obj.Ylabel=get(obj.Ylabel,'String');
                gca
                try
                    ref_colorbar_handle = findobj(get(gcf,'Children'),'Tag','Colorbar');
                    obj.Zlabel=get(ref_colorbar_handle,'Ylabel');
                    obj.Zlabel=get(obj.Zlabel,'string');
                catch err
                    obj.Zlabel=get(gca,'Zlabel');
                    obj.Zlabel=get(obj.Zlabel,'string');
                end
                obj.M=get(gco, 'CData');
                obj.cmap=(colormap(gca));
                obj.figID=figure(4);
                set(obj.figID,'name','Slice mode');
                set(obj.figID,'Units','normalized');
                set(obj.figID, 'renderer', 'zbuffer'); % solve possible pb of graphic card driver bug cf. http://www.mathworks.com/matlabcentral/answers/53874

                zmin=min(min(obj.M));
                zmax=max(max(obj.M));

                % figure is divided as follow:
                    %  1  2  3  4   or  1   2   3   4   5  or   1   2   3   4   5   6   
                    %  5  6  7  8       6   7   8   9   10      7   8   9   10  11  12
                    %  9 10 11 12       11  12  13  14  15      13  14  15  16  17  18
                    % 13 14 15 16       16  17  18  19  20      19  20  21  22  23  24
                    %                   21  22  23  24  25      25  26  27  28  29  30
                    %                                           31  32  33  34  35  36

                obj.axesID=subplot(6,6,[1:4,7:10,13:16,19:22]);  %2D colorplot
                obj.pcolorID=pcolor(obj.X,obj.Y,obj.M);
                set(obj.pcolorID,'linestyle','none');
                set(gca, 'XTick', [], 'YTick', []);
                

                obj.colorbarID=colorbar(obj.axesID);
                pcolor_position=get(obj.axesID,'Position');
                set(obj.colorbarID,'Position',[pcolor_position(1)*2/3 pcolor_position(2) pcolor_position(1)/6 pcolor_position(4)]);
                set(obj.colorbarID,'YAxisLocation','left','Fontsize',10);
                colormap(obj.cmap);


                obj.main_title=title(obj.axesID,'','fontsize',14);

                Ysliceplot=subplot(6,6,[5,6,11,12,17,18,23,24]); %right plot (rotated)    
                obj.Yslice=plot(obj.M(:,1),obj.Y,'color','black','linewidth',1);
                set(Ysliceplot,'YaxisLocation','right');
                set(Ysliceplot,'XDir','reverse');
                xlabel(obj.Zlabel,'fontsize',14);
                ylabel(obj.Ylabel,'fontsize',14);
                xlim([zmin zmax]);
                ylim([min(obj.Y) max(obj.Y)]);


                Xsliceplot=subplot(6,6,[25:28,31:34]); %lower plot
                obj.Xslice=plot(obj.X,obj.M(1,:),'color','black','linewidth',1);
                xlabel(obj.Xlabel,'fontsize',14);
                ylabel(obj.Zlabel,'fontsize',14);
                xlim([min(obj.X) max(obj.X)]);
                ylim([zmin zmax]);

                obj.textbox=subplot(6,6,[29, 30, 35, 36]); %too lazy to find out properly the position to set
                text_position=get(obj.textbox,'Position'); %use this trick instead
                delete(obj.textbox);
                obj.textbox=annotation('textbox', text_position,'Linestyle','none', 'string', [{' '};{' '};{' '};{'> Click the 2D plot to freeze the current slice'};{' '};{'> Remove frozen slices by cliking the background'};{' '};{'> Double click on the background closes the figure'}]);

                hold(obj.axesID,'on');
                obj.Xcursor=plot(obj.axesID,[obj.X(1) obj.X(1)],[obj.Y(1) obj.Y(end)],'--k');
                obj.Ycursor=plot(obj.axesID,[obj.X(1) obj.X(end)],[obj.Y(1) obj.Y(1)],'--k');

                drawnow % !!
                
                normalized_axes_limits=get(obj.axesID,'position');
                obj.fig_limits=get(obj.figID,'position');
                axes_limits(1) = normalized_axes_limits(1)*obj.fig_limits(3); % x coord. bottom left corner
                axes_limits(2) = normalized_axes_limits(2)*obj.fig_limits(4); % y coord. bottom left corner
                axes_limits(3) = normalized_axes_limits(3)*obj.fig_limits(3); % width 
                axes_limits(4) = normalized_axes_limits(4)*obj.fig_limits(4); % height
                set(obj.figID,'UserData',axes_limits);

                linkaxes([obj.axesID Xsliceplot],'x',false);
                linkaxes([obj.axesID Ysliceplot],'y',false);

                set(gcf,'ButtonDownFcn',@obj.delete_frozen_lines);
                set(obj.textbox,'ButtonDownFcn',@obj.delete_frozen_lines);
                set(obj.figID,'windowbuttonmotionfcn',{@obj.data_slice_refresh});
                set(obj.figID,'ResizeFcn',{@obj.figure_resized});
                set(obj.pcolorID,'ButtonDownFcn',{@obj.freeze_line});
                set(obj.Xcursor,'ButtonDownFcn',{@obj.freeze_line});
                set(obj.Ycursor,'ButtonDownFcn',{@obj.freeze_line});    
        end
        
        function data_slice_refresh(obj,hObject, eventdata)

            if XY_Interactive_Slices.isMultipleCall()
                return;  
            end
            axes(obj.axesID);
            % look for possible zoom
            main_axes_xlim=get(obj.axesID,'Xlim');
            main_axes_xlim_span=main_axes_xlim(2)-main_axes_xlim(1);
            x_lim=[min(obj.X) max(obj.X)];
            x_lim_span=x_lim(2)-x_lim(1);
            main_axes_ylim=get(obj.axesID,'Ylim');
            main_axes_ylim_span=main_axes_ylim(2)-main_axes_ylim(1);
            y_lim=[min(obj.Y) max(obj.Y)];
            y_lim_span=y_lim(2)-y_lim(1);

            axes_limits=get(obj.figID,'UserData');
            x1_axes=axes_limits(1);
            y1_axes=axes_limits(2);
            x2_axes=axes_limits(3)+x1_axes;
            y2_axes=axes_limits(4)+y1_axes;
            mouse_position = get(obj.figID,'currentpoint');  % The current point w.r.t the figure.
            x_mouse=mouse_position(1);
            y_mouse=mouse_position(2);


            Y_int=size(obj.Y,2);
            X_int=size(obj.X,2);


            x_mouse_in_axes = x1_axes<=x_mouse && x_mouse<=x2_axes;
            y_mouse_in_axes = y1_axes<=y_mouse && y_mouse<=y2_axes;

            if x_mouse_in_axes && y_mouse_in_axes
                if obj.X(1)>obj.X(end)
                    new_X_ind=floor((x2_axes-x_mouse)/(x2_axes-x1_axes)*main_axes_xlim_span/x_lim_span*X_int - (main_axes_xlim(2)-x_lim(2))/x_lim_span*X_int+1);
                else
                    new_X_ind=floor((x_mouse-x1_axes)/(x2_axes-x1_axes)*main_axes_xlim_span/x_lim_span*X_int + (main_axes_xlim(1)-x_lim(1))/x_lim_span*X_int+1);
                end
                if obj.Y(1)>obj.Y(end)
                    new_Y_ind=floor((y2_axes-y_mouse)/(y2_axes-y1_axes)*main_axes_ylim_span/y_lim_span*Y_int - (main_axes_ylim(2)-y_lim(2))/y_lim_span*Y_int+1);
                else
                    new_Y_ind=floor((y_mouse-y1_axes)/(y2_axes-y1_axes)*main_axes_ylim_span/y_lim_span*Y_int + (main_axes_ylim(1)-y_lim(1))/y_lim_span*Y_int+1);
                end



                set(obj.Xcursor,'XData',[obj.X(new_X_ind) obj.X(new_X_ind)]);
                set(obj.Ycursor,'YData',[obj.Y(new_Y_ind) obj.Y(new_Y_ind)]);

                set(obj.main_title,'string',['X value: ' num2str(obj.X(new_X_ind)) '      Y value: ' num2str(obj.Y(new_Y_ind))]);

                set(obj.Yslice,'XData',obj.M(:,new_X_ind));
                set(obj.Xslice,'YData',obj.M(new_Y_ind,:));
            end
            drawnow();
        end
    
        function figure_resized(obj,hObject, eventdata)
            drawnow
            normalized_axes_limits=get(obj.axesID,'position');
            obj.fig_limits=get(obj.figID,'position'); 
            axes_limits(1) = normalized_axes_limits(1)*obj.fig_limits(3); % x coord. bottom left corner
            axes_limits(2) = normalized_axes_limits(2)*obj.fig_limits(4); % y coord. bottom left corner
            axes_limits(3) = normalized_axes_limits(3)*obj.fig_limits(3); % width 
            axes_limits(4) = normalized_axes_limits(4)*obj.fig_limits(4); % height

            set(obj.figID,'UserData',axes_limits);

        end

        function freeze_line(obj,hObject, eventdata)
            if XY_Interactive_Slices.isMultipleCall()
                return;  
            end
            newline_color=lines(32);
            color_ind=size(findobj(gcf,'-regexp','Tag','frozen'),1)/4+1;
            newline_color=newline_color(color_ind,:);

            yslice_X=get(obj.Yslice,'XData');
            yslice_Y=get(obj.Yslice,'YData');
            yslice_plot=get(obj.Yslice,'Parent');
            hold(yslice_plot,'on');
            hy=plot(yslice_plot,yslice_X,yslice_Y,'color',newline_color,'linewidth',1);
            set(hy,'tag','frozen');

            xslice_X=get(obj.Xslice,'XData');
            xslice_Y=get(obj.Xslice,'YData');
            xslice_plot=get(obj.Xslice,'Parent');
            hold(xslice_plot,'on');
            hx=plot(xslice_plot,xslice_X,xslice_Y,'color',newline_color,'linewidth',1);
            set(hx,'tag','frozen');

            X_cursor_data.X=get(obj.Xcursor,'XData');
            X_cursor_data.Y=get(obj.Xcursor,'YData');
            Y_cursor_data.X=get(obj.Ycursor,'XData');
            Y_cursor_data.Y=get(obj.Ycursor,'YData');  
            xcurs=plot(obj.axesID,X_cursor_data.X,X_cursor_data.Y,'color',newline_color,'linewidth',2);
            set(xcurs,'Linestyle','--');
            set(xcurs,'tag','frozen');
            set(xcurs,'ButtonDownFcn',{@freeze_line});
            ycurs=plot(obj.axesID,Y_cursor_data.X,Y_cursor_data.Y,'color',newline_color,'linewidth',2);
            set(ycurs,'Linestyle','--');
            set(ycurs,'tag','frozen');
            set(ycurs,'ButtonDownFcn',{@freeze_line});
        end

        function delete_frozen_lines(obj,hObject, eventdata)
            click_type=get(obj.figID,'selectiontype');
            switch click_type
                case 'normal'
                    h = findobj(obj.figID,'-regexp','Tag','frozen');
                    delete(h);
                case 'open'
                    close(obj.figID);
            end
        end
    end
    
    methods (Static)
    
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

