classdef FFT_filter
    % Apply a fft filter to a 2D dataset. 
    %   The 'options' argument used in the class constructor must have the
    %   form of a structure as the one returned in the FFT_filter_designer.
    
    properties
        M
        TYPE
        CENTER
        WIDTH
        SHAPE
        FILTERMODE
        Output
    end
    
    methods
        function [obj]=FFT_filter(M,options)
            obj.M=M;
            obj.TYPE=options.TYPE;
            obj.CENTER=options.CENTER;
            obj.WIDTH=options.WIDTH;
            obj.SHAPE=options.SHAPE;
            obj.FILTERMODE=options.FILTERMODE;
            obj.Output=obj.Run_filter();
        end
        
        function [output]=Run_filter(obj)
            if strcmp(obj.TYPE,'step') || strcmp(obj.TYPE,'X')
                Mat=obj.M';
            else
                Mat=obj.M;
            end
            fft_data=fft(Mat);
            centerfrequency=obj.CENTER;
            filterwidth=obj.WIDTH;
            filtershape=obj.SHAPE;
            filtermode=obj.FILTERMODE;
            
            lft1=1:(size(fft_data,1)/2);
            lft2=(size(fft_data,1)/2+1):size(fft_data,1);
            % Compute filter shape.
            if strcmp(filtermode,'Band-pass'),
                   ffilter1=FFT_filter_designer.shape(lft1,centerfrequency+1,filterwidth,filtershape);
                   ffilter2=FFT_filter_designer.shape(lft2,size(fft_data,1)-centerfrequency+1,filterwidth,filtershape);
                   ffilter=[ffilter1,ffilter2];
            end
            if strcmp(filtermode,'High-pass')
                   centerfrequency=size(fft_data,1)/2;
                   ffilter1=FFT_filter_designer.shape(lft1,centerfrequency+1,filterwidth,filtershape);
                   ffilter2=FFT_filter_designer.shape(lft2,size(fft_data,1)-centerfrequency+1,filterwidth,filtershape);
                   ffilter=[ffilter1,ffilter2];
            end
            if strcmp(filtermode,'Low-pass')
                   centerfrequency=0;
                   ffilter1=FFT_filter_designer.shape(lft1,centerfrequency+1,filterwidth,filtershape);
                   ffilter2=FFT_filter_designer.shape(lft2,size(fft_data,1)-centerfrequency+1,filterwidth,filtershape);
                   ffilter=[ffilter1,ffilter2];
            end
            if strcmp(filtermode,'Band-reject (notch)')
                   ffilter1=FFT_filter_designer.shape(lft1,centerfrequency+1,filterwidth,filtershape);
                   ffilter2=FFT_filter_designer.shape(lft2,size(fft_data,1)-centerfrequency+1,filterwidth,filtershape);
                   ffilter=1-[ffilter1,ffilter2]; 
            end
            if size(fft_data,1)>length(ffilter), ffilter=[ffilter ffilter(1)];end
            ffilter=ffilter';
            ffilter=repmat(ffilter,[1,size(Mat,2)]);
            
            fft_output=fft_data.*ffilter;  % Multiply filter by Fourier Transform of signal
            output=real(ifft(fft_output));
            if strcmp(obj.TYPE,'step') || strcmp(obj.TYPE,'X')
                output=output';
            end
        end
            
    end
    
end

