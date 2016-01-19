classdef FFT_filter_designer < handle
    % FFT_filter_designer opens a figure, plots one curve out of a dataset, 
    % and allows the user to design a filter that can be later applied to
    % the whoe dataset. 
    % Part of the code is coming from "ifilter", written by T. C. O'Haver  
    % (toh@umd.edu), Version 3, October, 2011 (found on matlab files 
    % exchange). 
    %
    %   The filter parameters are stored in the "Output" property. User can
    %   press keyboard arrows (or 1,2,3,5 keys) to fine (coarse) tune the
    %   filter's center frequency and width. Press 'm' key to change the
    %   filter mode and 'p' key to switch to log/lin scales.
    %   

    
    properties
        X
        Y
        M
        LABEL
        CENTER
        WIDTH
        SHAPE
        PLOTMODE
        FILTERMODE
        figID
        input_axes
        input_plot
        filter_axes
        fft_plot
        filter_plot
        output_axes
        output_plot
        UI_freq
        UI_width
        UI_shape
        UI_mode
        UI_next
        UI_prev
        UI_index
        UI_apply
        UI_cancel
        Output
    end
    
    methods
        
        function [obj]=FFT_filter_designer(X,Y,varargin)
            % deals with argin
            p = inputParser;
            defaultLABEL = '';
            defaultCENTER = 1;
            defaultWIDTH = 10;
            defaultSHAPE = 2;
            defaultPLOTMODE = 1;
            defaultFILTERMODE = 'Band-pass';
            addRequired(p,'X');
            addRequired(p,'Y');
            addOptional(p,'LABEL',defaultLABEL);
            addOptional(p,'CENTER',defaultCENTER);
            addOptional(p,'WIDTH',defaultWIDTH);
            addOptional(p,'SHAPE',defaultSHAPE);
            addOptional(p,'PLOTMODE',defaultPLOTMODE);
            addOptional(p,'FILTERMODE',defaultFILTERMODE);
            parse(p,X,Y,varargin{:});

            obj.X=p.Results.X;
            obj.Y=p.Results.Y;
            obj.LABEL=p.Results.LABEL;
            obj.CENTER=p.Results.CENTER;
            obj.WIDTH=p.Results.WIDTH;
            obj.SHAPE=p.Results.SHAPE;
            obj.PLOTMODE=p.Results.PLOTMODE;
            obj.FILTERMODE=p.Results.FILTERMODE;
            
            % Adjust x and y vector shape to 1 x n (rather than n x 1)
            if min(size(obj.Y))~=1
                obj.M=obj.Y;
                obj.Y=obj.M(1,:);
            end
            obj.X=reshape(obj.X,1,length(obj.X));
            obj.Y=reshape(obj.Y,1,length(obj.Y));
            
            % Plot the signal and its power spectrum
            obj.figID=8;
            figure(obj.figID);
            obj.input_axes=subplot(3,5,1:4);      % Plot original signal in top plot
            obj.input_plot=plot(obj.X,obj.Y,'b');
            title('Input Signal: ')
%             axis([xvector(1) xvector(length(xvector)) min(yvector) max(yvector)]);  
            obj.filter_axes=subplot(3,5,6:9);     % Plot power spectrum and filter in middle plot
            obj.output_axes=subplot(3,5,11:14);   % Plot filtered signal in lower plot
            obj.output_plot=plot(obj.X,obj.Y,'b');

            
            obj.UI_next = uicontrol('style','pushbutton','string','NEXT','callback',@obj.UI_next_Callback,'parent', obj.figID,'Units','normalized','Position', [0.85 0.75 0.1 0.05],'tag','UI_next');
            obj.UI_prev = uicontrol('style','pushbutton','string','PREV','callback',@obj.UI_prev_Callback,'parent', obj.figID,'Units','normalized','Position', [0.85 0.85 0.1 0.05],'tag','UI_prev');
            obj.UI_index = uicontrol('style','edit','String','1','Value',1,'callback',@obj.UI_index_Callback,'parent', obj.figID,'Units','normalized','Position', [0.85 0.8 0.1 0.05],'tag','UI_index');
            obj.UI_freq = uicontrol('style','edit','callback',@obj.UI_freq_Callback,'parent', obj.figID,'Units','normalized','Position', [0.85 0.55 0.1 0.05],'tag','UI_freq');
            uicontrol('style','text','string','CENTER:','parent', obj.figID,'Units','normalized','Position', [0.78 0.535 0.07 0.05],'tag','UI_freq_txt','backgroundcolor',[0.8 0.8 0.8]);
            obj.UI_width = uicontrol('style','edit','callback',@obj.UI_width_Callback,'parent', obj.figID,'Units','normalized','Position', [0.85 0.5 0.1 0.05],'tag','UI_width');
            uicontrol('style','text','string','WIDTH:','parent', obj.figID,'Units','normalized','Position', [0.78 0.485 0.07 0.05],'tag','UI_width_txt','backgroundcolor',[0.8 0.8 0.8]);
            obj.UI_shape = uicontrol('style','edit','callback',@obj.UI_shape_Callback,'parent', obj.figID,'Units','normalized','Position', [0.85 0.45 0.1 0.05],'tag','UI_shape');
            uicontrol('style','text','string','SHAPE:','parent', obj.figID,'Units','normalized','Position', [0.78 0.435 0.07 0.05],'tag','UI_shape_txt','backgroundcolor',[0.8 0.8 0.8]);
            obj.UI_mode =uicontrol('style','text','string',obj.FILTERMODE,'FontWeight','bold','parent', obj.figID,'Units','normalized','Position', [0.85 0.6 0.1 0.05],'tag','UI_mode','backgroundcolor',[0.8 0.8 0.8]);
            obj.UI_apply = uicontrol('style','pushbutton','string','APPLY','callback',@obj.UI_apply_Callback,'parent', obj.figID,'Units','normalized','Position', [0.85 0.25 0.1 0.05],'tag','UI_next');
            obj.UI_cancel = uicontrol('style','pushbutton','string','CANCEL','callback',@obj.UI_cancel_Callback,'parent', obj.figID,'Units','normalized','Position', [0.85 0.15 0.1 0.05],'tag','UI_next');

            obj.RedrawFourierFilter;

            % Attaches KeyPress test function to the figure.
            set(gcf,'KeyPressFcn',@obj.ReadKey)
        end
        
        function [obj]=ReadKey(obj,hObject,eventdata)
        % Interprets key presses from the Figure window.
        % When a key is pressed, interprets key and calls corresponding function.
        % Note: If you don't like my key assignments, you can change the numbers
        % in the case statements below to re-assign that function to any other key.
            key=get(gcf,'CurrentCharacter')
            key+1
            switch key
                case 28
                    % Pans "CENTER" one point down when left arrow pressed.
                      obj.CENTER=obj.CENTER-1;
                      if obj.CENTER<1,obj.CENTER=1;end
                      obj.RedrawFourierFilter;
                case 29
                    % Pans "CENTER" one point up when left arrow pressed.
                      obj.CENTER=obj.CENTER+1;
                     obj.RedrawFourierFilter;
                case 49
                    % Pans "CENTER" 10 points down when 1 key pressed.
                      obj.CENTER=obj.CENTER-10;
                      if obj.CENTER<1,obj.CENTER=1;end
                     obj.RedrawFourierFilter;
                case 51
                    % Pans "CENTER" 10 points up when 3 key pressed.
                      obj.CENTER=obj.CENTER+10;
                     obj.RedrawFourierFilter;
                case 30
                    % Zooms filter width one point up when up arrow pressed.
                      obj.WIDTH=obj.WIDTH+1;
                     obj.RedrawFourierFilter;
                case 31
                    % Zooms filter width one point down when down arrow pressed.
                      obj.WIDTH=obj.WIDTH-1;
                      if obj.WIDTH<1,obj.WIDTH=1;end
                     obj.RedrawFourierFilter;
                case 53
                    % Zooms filter width up when 5 pressed.
                      obj.WIDTH=obj.WIDTH+10;
                    obj.RedrawFourierFilter;
                case 50
                    % Zooms filter width down when 2 pressed.
                      obj.WIDTH=obj.WIDTH-10;
                      if obj.WIDTH<1,obj.WIDTH=1;end
                    obj.RedrawFourierFilter;
                case 45
                    % When '-' key is pressed, shape is made more rectangular
                      obj.SHAPE=obj.SHAPE-1;
                      if obj.SHAPE<0,obj.SHAPE=0;end
                    obj.RedrawFourierFilter;
                case 43
                    % When '+' key is pressed, shape is made more Gaussian
                      obj.SHAPE=obj.SHAPE+1;
                    obj.RedrawFourierFilter;
                case 112 % When 'p' key is pressed, set plot mode to linear/linear
                     obj.PLOTMODE=obj.PLOTMODE+1;
                     if obj.PLOTMODE>4
                         obj.PLOTMODE=1;
                     end
                    obj.RedrawFourierFilter;
                case 109
                    % When 'm' key is pressed, set to bandpass mode
                     if strcmp(obj.FILTERMODE,'Band-pass')
                         obj.FILTERMODE='Band-reject (notch)';
                         set(obj.UI_freq,'String',num2str(obj.CENTER./FFT_filter_designer.range(obj.X)));
                     elseif strcmp(obj.FILTERMODE,'Band-reject (notch)')
                         obj.FILTERMODE='High-pass';
                         set(obj.UI_freq,'Enable','off');
                     elseif strcmp(obj.FILTERMODE,'High-pass')
                         obj.FILTERMODE='Low-pass';
                         set(obj.UI_freq,'Enable','off');
                     elseif strcmp(obj.FILTERMODE,'Low-pass')
                         obj.FILTERMODE='Band-pass';
                         set(obj.UI_freq,'Enable','on');
                     end
                     set(obj.UI_mode,'String',obj.FILTERMODE);
                     obj.RedrawFourierFilter;
            end
        end
            
        function RedrawFourierFilter(obj)
            % Separate graph windows for the original and filtered signals.
            % Computes and plots fourier filter for signal yvector.  
            % Centerfrequency and filterwidth are the center frequency and
            % width of the pass band, in harmonics, 'filtershape' determines
            % the sharpness of the cut-off. Plot modes: mode=1 linear x and y; 
            % mode=2 log x linear y; mode=3 linear x; log y; mode=4 log y log x
            xvector=obj.X;
            yvector=obj.Y;
            centerfrequency=obj.CENTER;
            filterwidth=obj.WIDTH;
            filtershape=obj.SHAPE;
            mode=obj.PLOTMODE;
            filtermode=obj.FILTERMODE;
            
            fy=fft(yvector);
            lft1=1:(length(fy)/2);
            lft2=(length(fy)/2+1):length(fy);
            % Compute filter shape.
            if strcmp(filtermode,'Band-pass'),
                   ffilter1=FFT_filter_designer.shape(lft1,centerfrequency+1,filterwidth,filtershape);
                   ffilter2=FFT_filter_designer.shape(lft2,length(fy)-centerfrequency+1,filterwidth,filtershape);
                   ffilter=[ffilter1,ffilter2];
            end
            if strcmp(filtermode,'High-pass')
                   centerfrequency=length(xvector)/2;
                   ffilter1=FFT_filter_designer.shape(lft1,centerfrequency+1,filterwidth,filtershape);
                   ffilter2=FFT_filter_designer.shape(lft2,length(fy)-centerfrequency+1,filterwidth,filtershape);
                   ffilter=[ffilter1,ffilter2];
            end
            if strcmp(filtermode,'Low-pass')
                   centerfrequency=0;
                   ffilter1=FFT_filter_designer.shape(lft1,centerfrequency+1,filterwidth,filtershape);
                   ffilter2=FFT_filter_designer.shape(lft2,length(fy)-centerfrequency+1,filterwidth,filtershape);
                   ffilter=[ffilter1,ffilter2];
            end
            if strcmp(filtermode,'Band-reject (notch)')
                   ffilter1=FFT_filter_designer.shape(lft1,centerfrequency+1,filterwidth,filtershape);
                   ffilter2=FFT_filter_designer.shape(lft2,length(fy)-centerfrequency+1,filterwidth,filtershape);
                   ffilter=1-[ffilter1,ffilter2]; 
            end
            if length(fy)>length(ffilter), ffilter=[ffilter ffilter(1)];end
            ffy=fy.*ffilter;  % Multiply filter by Fourier Transform of signal
            ry=real(ifft(ffy));

            % Plot original signal in top plot
            obj.input_plot=plot(obj.input_axes,xvector,yvector,'b');
            xlabel(obj.input_axes,obj.LABEL);


            % Plot filtered signal in lower plot
            obj.output_plot=plot(obj.output_axes,xvector,ry,'r');
            xlabel(obj.output_axes,obj.LABEL);

            % Plot power spectrum and filter in middle plot
            py=fy .* conj(fy); % Compute power spectrum
            plotrange=2:length(fy)/2;
            f=((plotrange-1)./FFT_filter_designer.range(xvector));
            obj.filter_plot=plot(obj.filter_axes,f,real(py(plotrange)),f,max(real(py(plotrange))).*ffilter(plotrange),'r');
            xlabel_handle=xlabel(obj.filter_axes,' ');
            set(xlabel_handle,'Units','normalized')
            xlabel_position=get(xlabel_handle,'Position');
            switch mode
                case 1
                    ylabel(obj.filter_axes,'FFT Amplitude & filter (Linear scale)');
                    xlabel(obj.filter_axes,[FFT_filter_designer.inverse_label(obj.LABEL) ' (Linear scale)']);
                case 2
                    set(obj.filter_axes,'Xscale','log');
                    ylabel(obj.filter_axes,'FFT Amplitude & filter (Linear scale)');
                    xlabel(obj.filter_axes,[FFT_filter_designer.inverse_label(obj.LABEL) ' (Log scale)']);
                case 3
                    set(obj.filter_axes,'Yscale','log');
                    ylabel(obj.filter_axes,'FFT Amplitude & filter (Log scale)');
                    xlabel(obj.filter_axes,[FFT_filter_designer.inverse_label(obj.LABEL) ' (Linear scale)']);
                case 4
                    set(obj.filter_axes,'Xscale','log');
                    set(obj.filter_axes,'Yscale','log');
                    ylabel(obj.filter_axes,'FFT Amplitude & filter (Log scale)');
                    xlabel(obj.filter_axes,[FFT_filter_designer.inverse_label(obj.LABEL) ' (Log scale)']);
                otherwise
            end
            set(xlabel_handle,'Position',xlabel_position);
            axis(obj.filter_axes,[0 max(f) min(py) 1.1*max(real(py(plotrange)))]);
            set(obj.UI_freq,'string',num2str(obj.CENTER./FFT_filter_designer.range(xvector)));
            set(obj.UI_width,'string',num2str(obj.WIDTH./FFT_filter_designer.range(xvector)));
            set(obj.UI_shape,'string',num2str(obj.SHAPE));
        end
        
        function UI_next_Callback(obj, hObject, eventdata)
            index=get(obj.UI_index,'Value');
            if index<size(obj.M,1)
                set(obj.UI_index,'String',num2str(index+1));
                set(obj.UI_index,'Value',index+1);
                obj.Y=obj.M(index+1,:);
                obj.RedrawFourierFilter;
            end
        end
        
        function UI_prev_Callback(obj, hObject, eventdata) 
            index=get(obj.UI_index,'Value');
            if index>1
                set(obj.UI_index,'String',num2str(index-1));
                set(obj.UI_index,'Value',index-1);
                obj.Y=obj.M(index-1,:);
                obj.RedrawFourierFilter;
            end
        end
        
        function UI_index_Callback(obj, hObject, eventdata)
            index=str2double(get(hObject,'String'));
            if index>=1 && index<=size(obj.M,1)
                set(obj.UI_index,'String',num2str(index));
                set(obj.UI_index,'Value',index);
                obj.Y=obj.M(index,:);
                obj.RedrawFourierFilter;
            else
                set(obj.UI_index,'String',get(obj.UI_index,'Value'));   
            end
        end
        
        function UI_freq_Callback(obj, hObject, eventdata) 
            val=str2double(get(hObject,'String'));
            obj.CENTER=val*FFT_filter_designer.range(obj.X);
            obj.RedrawFourierFilter;
        end
        
        function UI_width_Callback(obj, hObject, eventdata) 
            val=str2double(get(hObject,'String'));
            obj.WIDTH=val*FFT_filter_designer.range(obj.X);
            obj.RedrawFourierFilter;
        end
        
        function UI_shape_Callback(obj, hObject, eventdata)
            val=str2double(get(hObject,'String'));
            obj.SHAPE=val;
            obj.RedrawFourierFilter;
        end
        
        function UI_apply_Callback(obj, hObject, eventdata)
            obj.Output.CENTER=obj.CENTER;
            obj.Output.WIDTH=obj.WIDTH; 
            obj.Output.SHAPE=obj.SHAPE; 
            obj.Output.FILTERMODE=obj.FILTERMODE;
            close(obj.figID)
        end
        
        function UI_cancel_Callback(obj, hObject, eventdata)
            obj.Output=[];
            close(obj.figID)
        end
        
    end
    
    methods (Static)
        function g = shape(x,pos,wid,n)
        %  shape(x,pos,wid,n) = peak centered on x=pos, half-width=wid
        %  x may be scalar, vector, or matrix, pos and wid both scalar
        %  Shape is Lorentzian (1/x^2) when n=0, Gaussian (exp(-x^2))
        %  when n=1, and becomes more rectangular as n increases.
        %  Example: shape([1 2 3],1,2,1) gives result [1.0000    0.5000    0.0625]
            if n==0
                g=ones(size(x))./(1+((x-pos)./(0.5.*wid)).^2);
            else
                g = exp(-((x-pos)./(0.6.*wid)) .^(2*round(n)));
            end
        end

        function r = range(arr)
            r = max(arr) - min(arr);
        end
        
        function [str_out] = inverse_label(str_in)
            str_out=strrep(str_in, ')', '^{-1})');
            str_out=strrep(str_out, ' (', '^{-1} (');
            if strcmp(str_out,str_in)
                str_out=[str_in '^{-1}'];
            end
        end
        
    end
    
    
    
end

