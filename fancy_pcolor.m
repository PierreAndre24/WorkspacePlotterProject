classdef fancy_pcolor < handle
    %2D plot with predefined options and useful instances. 
    %   Required arguments are figure number for the plot, X, Y & M data. 
    %   Provides save and export to base utilities functions, data slices,
    %   smooth and so on...
    
    properties
        figID
        X
        Xlabel
        Y
        Ylabel
        M
        CB
        CBlabel
        Axes
        Title
        Legend
        savename='';
        
    end
    
    methods
        function [obj] = fancy_pcolor(ID,X,Y,M,varargin)
            % deals with argin
            p = inputParser;
            defaultXlabel = 'X';
            defaultYlabel = 'Y';
            defaultCBlabel = '';
            defaultTitle = '2D plot';
            defaultLegend = '';
            addRequired(p,'ID');
            addRequired(p,'X');
            addRequired(p,'Y');
            addRequired(p,'M');
            addOptional(p,'Xlabel',defaultXlabel);
            addOptional(p,'Ylabel',defaultYlabel);
            addOptional(p,'Zlabel',defaultCBlabel);
            addOptional(p,'Title',defaultTitle);
            addOptional(p,'Legend',defaultLegend);
            parse(p,ID,X,Y,M,varargin{:});
            % create the figure
            obj.figID=figure(p.Results.ID);
            datacursormode off
            plotedit off
            zoom off
            pan off
            rotate3d off
            % plot the graph with all options
            obj.X=p.Results.X;
            obj.Y=p.Results.Y;
            obj.M=p.Results.M;
            obj.Axes = pcolor(obj.X,obj.Y,obj.M); 
            set(obj.Axes, 'LineStyle', 'none', 'FaceColor', 'Flat');
            set(gca,'fontSize',14);
            obj.Xlabel=xlabel(p.Results.Xlabel,'fontsize',14);
            set(obj.Xlabel,'tag','XLabel');
            obj.Ylabel=ylabel(p.Results.Ylabel,'fontsize',14);
            set(obj.Ylabel,'tag','YLabel');
            obj.savename=p.Results.Title;
            obj.Title=title(p.Results.Title,'fontsize',14);
            if size(p.Results.Legend,2)>0 && isempty(cell2mat(strfind(p.Results.Legend,'counter'))) % insert legend if there are several step2 (except when counter is used)
                obj.Legend=legend(p.Results.Legend);
            end
            obj.CB=colorbar;
            set(gca,'fontSize',14);
            obj.CBlabel=ylabel(obj.CB, p.Results.Zlabel,'fontsize',14);
            set(gcf, 'renderer', 'zbuffer'); % prevent possible graphic card driver bug cf. http://www.mathworks.com/matlabcentral/answers/53874
            colormap(parula(256))
            box on
            set(gca,'layer','top');
%             set(obj.figID,'CloseRequestFcn',{@obj.delete});

            obj.add_figure_context_menu();
            obj.add_2D_axes_context_menu();
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
            [filename, fig_save_path] = uiputfile([pwd '\' fancy_pcolor.remove_backslash(obj.savename) '.png'],'Save As');
            if filename==0 % if user canceled
               return
            end
            saveas(obj.figID, [fig_save_path '\' filename], 'png'); 
        end

        function save_figure_fig(obj,hObject, eventdata)
            [filename, fig_save_path] = uiputfile([pwd '\' fancy_pcolor.remove_backslash(obj.savename) '.fig'],'Save As');
            if filename==0 % if user canceled
               return
            end
            delete(get(obj.figID,'UIContextMenu'));
            set(obj.figID,'KeyPressFcn','');
%             set(obj.figID,'CloseRequestFcn',@delete);
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
%             if strcmp(obj.savename,'')
%                 name='current_fig';
%             else 
%                 name=genvarname(obj.savename);
%             end
%             assignin('base','X',obj.X);
%             assignin('base','Y',obj.Y);
%             assignin('base','X_label',get(obj.Xlabel,'String'));
%             assignin('base','Y_label',get(obj.Ylabel,'String'));
%             assignin('base','M',obj.M);
            fig_properties.X=obj.X;
            fig_properties.Y=obj.Y;
            fig_properties.M=obj.M;
            fig_properties.Xlabel=obj.Xlabel;
            fig_properties.Ylabel=obj.Ylabel;
            fig_properties.CB=obj.CB;
            fig_properties.CBlabel=obj.CBlabel;
            fig_properties.Title=obj.Title;
            fig_properties.Legend=obj.Legend;
            assignin('base','fig2_data',fig_properties);
        end
        
        
        
        function []=add_2D_axes_context_menu(obj)
            caxes_uimenu=uicontextmenu;
            uimenu(caxes_uimenu, 'Label', 'Interactive Slice', 'Callback', {@obj.data_slice});
            uimenu(caxes_uimenu, 'Label', 'Angle Slice', 'Callback', {@obj.data_angle_slice});
            uimenu(caxes_uimenu, 'Label', 'AspectRatio ON/OFF', 'Callback', @fancy_pcolor.aspectratio_on_off);
            uimenu(caxes_uimenu, 'Label', 'Transpose Graph', 'Callback', @fancy_pcolor.transpose_2D_graph);
            uimenu(caxes_uimenu, 'Label', 'Switch 3D/2D', 'Callback', {@obj.switch_3D});
            uimenu(caxes_uimenu, 'Label', 'Smooth', 'Callback', {@obj.smooth_2D_graph});
            uimenu(caxes_uimenu, 'Label', 'FFT Filter', 'Callback', {@obj.fft_filter});
%             uimenu(caxes_uimenu, 'Label', 'Substract Sweep Means', 'Callback', {@obj.substract_mean});
            uimenu(caxes_uimenu, 'Label', 'Remove Slope', 'Callback', {@obj.substract2Dslope});
            uimenu(caxes_uimenu, 'Label', 'Derivate', 'Callback', {@obj.derivation});
            uimenu(caxes_uimenu, 'Label', 'Restore Init Data', 'Callback', {@obj.restore_init_values});
            colormap_menu = uimenu(caxes_uimenu, 'label','Colormap');
            uimenu(colormap_menu, 'Label', 'Colormap: Red Blue', 'Callback', @fancy_pcolor.red_blue_colormap);
            uimenu(colormap_menu, 'Label', 'Colormap: haxby', 'Callback', @fancy_pcolor.haxby_colormap);
            uimenu(colormap_menu, 'Label', 'Colormap: pmkmp1', 'Callback', @fancy_pcolor.pmkmp1_colormap);
            set(obj.Axes, 'UIContextMenu', caxes_uimenu);          
        end
        
        function data_slice(obj,hObject, eventdata)
            XY_Interactive_Slices();
        end

        function data_angle_slice(obj,hObject, eventdata)
            XX=get(gco,'XData');
            YY=get(gco,'YData');
            srcfigID=gcf;
            [x_start,y_start] = ginput(1);
            hold on
            plot(x_start, y_start,'Marker', '+','MarkerSize', 10,'MarkerFaceColor','blue');
            hold off
            [x_stop,y_stop] = ginput(1); 

            x_slice=[x_start, x_stop];
            y_slice=[y_start, y_stop];

            if ~issorted(x_slice)
                x_slice=flipud(x_slice);
                y_slice=flipud(y_slice);
            end
            xstart=x_slice(1);
            xstop=x_slice(2);
            if XX(1)<XX(end)
                xindstart=find(XX > xstart, 1, 'first');
                xindstop=find(XX > xstop, 1, 'first');
            else
                xindstart=find(XX < xstart, 1, 'first');
                xindstop=find(XX < xstop, 1, 'first');
            end
            dx_sign=1;
            xindrange=xindstop-xindstart;
            if xindrange<0
                xindrange=abs(xindrange);
                dx_sign=-1;
            end

            ystart=y_slice(1);
            ystop=y_slice(2);
            if YY(1)<YY(end)
                yindstart=find(YY > ystart, 1, 'first');
                yindstop=find(YY > ystop, 1, 'first');
            else
                yindstart=find(YY < ystart, 1, 'first');
                yindstop=find(YY < ystop, 1, 'first');
            end
            dy_sign=1;
            yindrange=yindstop-yindstart;
            if yindrange<0
                yindrange=abs(yindrange);
                dy_sign=-1;
            end

            sourcematrix=get(gco, 'CData');
            if max(size(YY))==size(sourcematrix,1)
                sourcematrix=sourcematrix';
            end

            N=max(xindrange,yindrange);
            squared_range=sqrt((xstop-xstart)^2 + (ystop-ystart)^2);
            epsilon=0:squared_range/N:squared_range;
            Slice(N+1)=0;
            for i=1:N+1
                xpicked=round(xindstart+dx_sign*i*xindrange/N);
                ypicked=round(yindstart+dy_sign*i*yindrange/N);
                Slice(i)=sourcematrix(xpicked,ypicked);
            end
            hold on
            previous_line=findobj(srcfigID,'type','line');
            delete(previous_line)
            slice_line=plot([XX(xindstart) XX(xindstop)], [YY(yindstart) YY(yindstop)]);
            set(slice_line,'LineStyle', '--','LineWidth', 2,'Marker', 'o','MarkerSize', 5,'MarkerFaceColor','blue');
            hold off



            X_label=get(gca,'Xlabel');
            X_label=get(X_label,'String');
            Y_label=get(gca,'Ylabel');
            Y_label=get(Y_label,'String');
            colorbar_handle = findobj(get(gcf,'Children'),'Tag','Colorbar');
            Z_label=get(colorbar_handle,'Ylabel');
            Z_label=get(Z_label,'string');

            epsilon_label=['\epsilon ' '( \surd(\DeltaX² +\DeltaY²) )'];
            graph_title=['( X axis: ' X_label ' from ' num2str(xstart) ' to ' num2str(xstop) ' ; Y axis: ' Y_label ' from ' num2str(ystart) ' to ' num2str(ystop) ' )'];
            f4=fancy_plot(4,epsilon,Slice,'Xlabel',epsilon_label,'Ylabel',Z_label,'Title',graph_title);
            set(f4.figID,'name','Data Slice');
            set(f4.figID,'UserData',srcfigID);
            set(f4.figID,'CloseRequestFcn','delete(findobj(get(gcf,''UserData''),''type'',''line''));close(gcf);')
            end

        function switch_3D(obj,hObject, eventdata)
            ZData=get(gco,'ZData');
            if any(ZData(:))
                set(gco,'ZData',zeros(size(ZData)));
                lighting none;
                material default; 
                view(2);
                return
            end
            MM=get(gco,'CData');
            set(gco,'ZData',MM)
            lighting phong;
            material shiny;
            lightangle(10,75);
            set(gca,'color','none');
            view(3);
        end
            
        function smooth_2D_graph(obj,hObject,eventdata)
            orderStr = inputdlg({'moving average order for X direction:','moving average order for Y direction:'},'Averaging order',1,{'0','1'}); 
            if max(size(orderStr))==0     % user canceled?
                return;
            end
            smooth_order.X=str2double(orderStr(1));
            smooth_order.Y=str2double(orderStr(2));
            MM=get(gco,'CData');
            MM=smooth2a(MM,smooth_order.Y,smooth_order.X);
            set(gco,'CData',MM);
        end
        
        function substract_mean(obj,hObject,eventdata)
            data=get(gco,'CDATA');
            newdata=data-(ones(size(data,1),1)*mean(data));
            set(gco,'CDATA',newdata);
        end
        
        function substract2Dslope(obj,hObject,eventdata)
            x=get(gco,'XDATA');
            y=get(gco,'YDATA');
            data=get(gco,'CDATA');
           
% ######################################################################### 
%             rect=getrect; %rect=[xmin ymin width height]
%             point1=[rect(1), rect(2)];
%             point2=[rect(1)+rect(3), rect(2)+rect(4)];
% ######################################################################### 
            % REPLACE THE 3 LINES ABOVE BY THESE LINES IN CASE OF LICENSING ERROR
% #########################################################################            
            waitforbuttonpress;
            point1 = get(gca,'CurrentPoint');    % button down detected
            rbbox;                   % return figure units
            point2 = get(gca,'CurrentPoint');    % button up detected
            point1 = point1(1,1:2);              % extract x and y
            point2 = point2(1,1:2);
% BE CAREFUL : THE FUNCTION IS SENSITIVE TO THE MOUSE POSITION DURING THE
% CLICK, NOT TO THE RECTANGLE WHICH IS DRAWN (bugs in some matlab versions) 
% ######################################################################### 

            i1=find(abs(x-point1(1))==min(abs(x-point1(1)))); % find corresponding matrix indices
            i2=find(abs(x-point2(1))==min(abs(x-point2(1))));
            j1=find(abs(y-point1(2))==min(abs(y-point1(2))));
            j2=find(abs(y-point2(2))==min(abs(y-point2(2))));

            xstart=min(i1,i2);
            xstop=max(i1,i2);
            ystart=min(j1,j2);
            ystop=max(j1,j2);

            XX=x(xstart:xstop);
            YY=y(ystart:ystop);
            C1=repmat(XX,[ystop-ystart+1,1]);
            C2=repmat(YY,[1,xstop-xstart+1]);
            C3=data(ystart:ystop,xstart:xstop);
            D=[C1(1:end);C2(1:end);C3(1:end)]';

            [n,~,p]=affine_fit(D); %fit vectors
            d=sum(n'.*p);

            S1=repmat(x,[size(y,2),1]);
            S2=repmat(y,[size(x,2),1])';
            ND=data+(S1*n(1)+S2*n(2)-d)/n(3);
            set(gco,'CDATA',ND);
        end
        
        function fft_filter(obj,hObject,eventdata)
            dimStr = inputdlg({'Use filter for:'},'Dimension',1,{'X'});
                if isempty(dimStr)     % user canceled?
                    return;
                end
                MM=get(gco,'CData');
                dim=upper(dimStr{1});% using upper to make it case insensitive
                switch dim
                    case 'Y'
                        YY=get(gco,'YData');
                        YY_label=get(get(gca,'YLabel'),'String');
                        h=FFT_filter_designer(YY,MM','LABEL',YY_label);
                    case 'X'
                        XX=get(gco,'XData');
                        XX_label=get(get(gca,'XLabel'),'String');
                        h=FFT_filter_designer(XX,MM,'LABEL',XX_label);
                    otherwise
                        msgbox('ERROR: Unknown dimension - X or Y only.');
                    return;
                end
                waitfor(h.figID);
                FFT_options=h.Output;
                if isempty(FFT_options)
                    return;
                end
                FFT_options.TYPE=dimStr{1};
                h=FFT_filter(MM,FFT_options);
                MM=h.Output;
                set(gco,'CData',MM);
        end
        
        function restore_init_values(obj,hObject,eventdata)
            set(gco,'XData',obj.X)
            set(gco,'YData',obj.Y)
            set(gco,'CData',obj.M)
        end
        
        function derivation(obj,hObject,eventdata)
            Str = inputdlg({'derivate along:','pre-smooth order'},'Dimension',1,{'Y','3'});
            if isempty(Str)     % user canceled?
                return;
            end
            dimStr = Str(1);
            order = str2double(Str(2));

            
            dim=upper(dimStr{1});% using upper to make it case insensitive
            switch dim
                case 'Y'
                    MM=get(gco,'CData');
                case 'X'
                    MM=get(gco,'CData')';
                otherwise
                    msgbox('ERROR: Unknown dimension - X or Y only.');
                return;
            end
            MM=smooth2a(MM,order,0);
            MM=diff(MM);
            N=size(MM,1);
            MM(N+1,:)=MM(N,:);
            set(gco,'CData',MM)
            switch dim
                case 'Y'
                    set(gco,'CData',MM)
                case 'X'
                    set(gco,'CData',MM')
            end
        end

        
    end   
     
    methods (Static)
        
        function pmkmp1_colormap(hObject, eventdata)
            colormap(gca,pmkmp(256,'CubicL'))
        end

        function pmkmp2_colormap(hObject, eventdata)
            colormap(gca,pmkmp(256,'CubicYF'))
        end

        function pmkmp3_colormap(hObject, eventdata)
            colormap(gca,pmkmp(256,'Edge'))
        end
        
        function red_blue_colormap(hObject, eventdata)
            colormap(gca,bluewhitered(256))
        end

        function haxby_colormap(hObject, eventdata)
            colormap(gca,haxby(256))
        end
        
        function transpose_2D_graph(hObject, eventdata)
            [az,el] = view;
            if az==0  && el==90
                view(90,-90)
            elseif az==90 && el==-90
                view(0,90)
            end 
        end
        
        function aspectratio_on_off(hObject, eventdata)
            aspect_ratio=get(gca,'DataAspectRatio');
            X_lim=get(gca,'xlim');
            Y_lim=get(gca,'ylim');
            if aspect_ratio==[1 1 1]
        %         axis auto
                axis normal
                pbaspect(aspect_ratio);
                set(gca,'xlim',X_lim);
                set(gca,'ylim',Y_lim);
            else
                axis equal
                pbaspect(aspect_ratio);
                set(gca,'xlim',X_lim);
                set(gca,'ylim',Y_lim);
            end
        end
        
        function [string_out] = remove_backslash(string_in)
            string_out=string_in;
            string_out(strfind(string_in,'\'))=[];
        end
        
    end
end

