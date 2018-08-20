function updatePreviewFrame(obj,event,~)
% updatePreviewFrame updates an image acquisition plot display.

global Xin

tnow = now;
I = obj.UserData;
i = str2double(I(5));

if  second(tnow -   Xin.D.Sys.PointGreyCam(i).DispTimer) < ...
                    Xin.D.Sys.PointGreyCam(i).DispPeriod	% wihtin 1x preview time
                        % Escape and do nothing
else
    %% Update PrevTimer
    if  second(tnow-Xin.D.Sys.PointGreyCam(i).DispTimer) < ...
            2*      Xin.D.Sys.PointGreyCam(i).DispPeriod	% within 1-2x preview time
        Xin.D.Sys.PointGreyCam(i).DispTimer = addtodate(...
            Xin.D.Sys.PointGreyCam(i).DispTimer, ...
            round(1000*Xin.D.Sys.PointGreyCam(i).DispPeriod), ...
            'millisecond');	% reset the timer by adding a step
    else                                                    % > 2x preview time
        Xin.D.Sys.PointGreyCam(i).DispTimer = now;
                        % reset timer by the current time
    end
    
    %% Get the latest data from the object.
    Xin.D.Sys.PointGreyCam(i).PreviewImageIn =	event.Data;
    Xin.D.Sys.PointGreyCam(i).PreviewStrFR =    event.FrameRate;
    Xin.D.Sys.PointGreyCam(i).PreviewStrTS =    event.Timestamp(1:10);  
        
        %% process display image: .Zoom, Gain, Rotate, ROI        
        % ZOOM in
        Xin.D.Sys.PointGreyCam(i).DispImgB1 =           uint16( Xin.D.Sys.PointGreyCam(i).PreviewImageIn); 
        if Xin.D.Sys.PointGreyCam(i).PreviewZoom == 1
            Xin.D.Sys.PointGreyCam(i).DispImgB2 =       [];
            Xin.D.Sys.PointGreyCam(i).DispImgB3 =       [];
            Xin.D.Sys.PointGreyCam(i).DispImgB4 =       [];
            Xin.D.Sys.PointGreyCam(i).DispImgBO =       Xin.D.Sys.PointGreyCam(i).DispImgB1;
        else 	
            Xin.D.Sys.PointGreyCam(i).DispImgB2 =       reshape(Xin.D.Sys.PointGreyCam(i).DispImgB1,...
                                                            Xin.D.Sys.PointGreyCam(i).PreviewZoom,...
                                                            Xin.D.Sys.PointGreyCam(i).ZoomHeight,...
                                                            Xin.D.Sys.PointGreyCam(i).PreviewZoom,...
                                                            Xin.D.Sys.PointGreyCam(i).ZoomWidth); 
            Xin.D.Sys.PointGreyCam(i).DispImgB3 =       sum(Xin.D.Sys.PointGreyCam(i).DispImgB2, 1, 'native');  
            Xin.D.Sys.PointGreyCam(i).DispImgB4 =       sum(Xin.D.Sys.PointGreyCam(i).DispImgB3, 3, 'native');
            Xin.D.Sys.PointGreyCam(i).DispImgBO =       squeeze(Xin.D.Sys.PointGreyCam(i).DispImgB4);
        end
        % GAIN & NORMALIZATION
            Xin.D.Sys.PointGreyCam(i).DispImgGO =       uint8(...
                                                            Xin.D.Sys.PointGreyCam(i).DispImgBO/...
                                                            Xin.D.Sys.PointGreyCam(i).PreviewZoom^2*...
                                                            Xin.D.Sys.PointGreyCam(i).DispGainNum);        
        % ROTATE
        try
            Xin.D.Sys.PointGreyCam(i).DispImgRO =       rot90(Xin.D.Sys.PointGreyCam(i).DispImgGO, ...
                                                            (360-Xin.D.Sys.PointGreyCam(i).PreviewRot)/90);
        catch
            Xin.D.Sys.PointGreyCam(i).DispImgRO =       Xin.D.Sys.PointGreyCam(i).DispImgGO;
            disp('Preview Rotation Angle Not Support');
        end        
        % ROI 
        if  Xin.D.Sys.PointGreyCam(i).PreviewClipROI
            Xin.D.Sys.PointGreyCam(i).DispImgOO =       Xin.D.Sys.PointGreyCam(i).DispImgRO.*...
                                                        Xin.D.Sys.PointGreyCam(i).ROIi;
        else
            Xin.D.Sys.PointGreyCam(i).DispImgOO =       Xin.D.Sys.PointGreyCam(i).DispImgRO;
        end       
        Xin.D.Sys.PointGreyCam(i).DispImg =             Xin.D.Sys.PointGreyCam(i).DispImgOO;

        % HISTOGRAM
        if Xin.D.Sys.PointGreyCam(i).UpdatePreviewHistogram
            Xin.D.Sys.PointGreyCam(i).DispHistMax =     max(Xin.D.Sys.PointGreyCam(i).DispImg, [], 2);
            Xin.D.Sys.PointGreyCam(i).DispHistMean =	uint8(mean(Xin.D.Sys.PointGreyCam(i).DispImg,2)); 
            Xin.D.Sys.PointGreyCam(i).DispHistMin =     min(Xin.D.Sys.PointGreyCam(i).DispImg, [], 2);
        end
        
    %% Update GUI with hImage, hHist, and timing Data
    set(Xin.UI.FigPGC(i).hImage,                    'CData',	Xin.D.Sys.PointGreyCam(i).DispImg); 
    set(Xin.UI.FigPGC(i).CP.hMon_CamPreviewFR_Edit,	'String',   Xin.D.Sys.PointGreyCam(i).PreviewStrFR);
    set(Xin.UI.FigPGC(i).CP.hMon_CamPreviewTS_Edit,	'String',   Xin.D.Sys.PointGreyCam(i).PreviewStrTS);
	if Xin.D.Sys.PointGreyCam(i).UpdatePreviewHistogram
        set(Xin.UI.FigPGC(i).hHistMax,                  'YData',    Xin.D.Sys.PointGreyCam(i).DispHistMax);
        set(Xin.UI.FigPGC(i).hHistMean,                 'YData',    Xin.D.Sys.PointGreyCam(i).DispHistMean);
        set(Xin.UI.FigPGC(i).hHistMin,                  'YData',    Xin.D.Sys.PointGreyCam(i).DispHistMin); 
	end
end


