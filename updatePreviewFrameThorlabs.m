function status = updatePreviewFrameThorlabs(i)
% updatePreviewFrame updates an image acquisition plot display.
% i is the camera #
% status: % 0=NoFrame;    1=readFrame;   2=previewUpdateWithFrame
global Xin

     tic 
%% Read the frame
if isvalid(Xin.HW.Thorlabs.hSciCam{i}) && (Xin.HW.Thorlabs.hSciCam{i}.NumberOfQueuedFrames > 0)
	Xin.D.Sys.ThorlabsSciCam(i).imageFrame =        Xin.HW.Thorlabs.hSciCam{1}.GetPendingFrameOrNull; 
        % minimal   / typical   / maximum
        % 0.130 ms  / 0.140 ms  / 1.377 ms
    Xin.D.Sys.ThorlabsSciCam(i).frameTimerCurr =    now;
    Xin.D.Sys.ThorlabsSciCam(i).frameNumCurr =      double(Xin.D.Sys.ThorlabsSciCam(i).imageFrame.FrameNumber); 
	Xin.D.Sys.ThorlabsSciCam(i).rawFrameData =      uint16(Xin.D.Sys.ThorlabsSciCam(i).imageFrame.ImageData.ImageData_monoOrBGR);    % 0.50 ms
        status = 1;	% 0=NoFrame;    1=readFrame;   2=previewUpdateWithFrame
else
        status = 0;	% 0=NoFrame;    1=readFrame;   2=previewUpdateWithFrame
    return;      % check if any frame is available on the camera
end
%% Save the frame if recording
if Xin.D.Ses.Status
    fwrite(Xin.D.Ses.hDataFile, Xin.D.Sys.ThorlabsSciCam(i).rawFrameData, 'uint16');
    Xin.D.Ses.Save.SesFrameNum(Xin.D.Sys.ThorlabsSciCam(i).frameNumCurr) = ...
        Xin.D.Sys.ThorlabsSciCam(i).frameNumCurr;
    Xin.D.Ses.Save.SesTimestamps(Xin.D.Sys.ThorlabsSciCam(i).frameNumCurr,:) = ...
        datestr(Xin.D.Sys.ThorlabsSciCam(i).frameTimerCurr, 'yy-mm-dd HH:MM:SS.FFF');
end
% if Xin.D.
%% See if the time to Update the Preview
if  second(Xin.D.Sys.ThorlabsSciCam(i).frameTimerCurr -   Xin.D.Sys.ThorlabsSciCam(i).DispTimer) < ...
                    Xin.D.Sys.ThorlabsSciCam(i).DispPeriod	% wihtin 1x preview time
                            % Escape and do nothing
else
        status = 2;	% 0=NoFrame;    1=readFrame;   2=previewUpdateWithFrame
    if  second(Xin.D.Sys.ThorlabsSciCam(i).frameTimerCurr-Xin.D.Sys.ThorlabsSciCam(i).DispTimer) < ...
            2*      Xin.D.Sys.ThorlabsSciCam(i).DispPeriod	% within 1-2x preview time
        Xin.D.Sys.ThorlabsSciCam(i).DispTimer = addtodate(...
            Xin.D.Sys.ThorlabsSciCam(i).DispTimer, ...
            round(1000*Xin.D.Sys.ThorlabsSciCam(i).DispPeriod), ...
            'millisecond');	% reset the timer by adding a step
    else                                                    % > 2x preview time
        Xin.D.Sys.ThorlabsSciCam(i).DispTimer = now;
                            % reset timer by the current time
    end
    
    %% Processing incoming data             (this section takes ~ 1.2 ms)
    Xin.D.Sys.ThorlabsSciCam(i).rawFrame = reshape(Xin.D.Sys.ThorlabsSciCam(i).rawFrameData, [...                               % 0.37 ms
                Xin.D.Sys.ThorlabsSciCam(i).rawWidth, ...
                Xin.D.Sys.ThorlabsSciCam(i).rawHeight])';

    Xin.D.Sys.ThorlabsSciCam(i).PreviewStrTS =    datestr(Xin.D.Sys.ThorlabsSciCam(i).frameTimerCurr, 'HH:MM:SS.FFF');          % 0.24 ms
    Xin.D.Sys.ThorlabsSciCam(i).PreviewStrFR =    sprintf( '%5.2f FPS', (...                                                    % 0.05 ms
                                                    Xin.D.Sys.ThorlabsSciCam(i).frameNumCurr - ...
                                                    Xin.D.Sys.ThorlabsSciCam(i).frameNumBuff)/second(...
                                                    Xin.D.Sys.ThorlabsSciCam(i).frameTimerCurr - ...
                                                    Xin.D.Sys.ThorlabsSciCam(i).frameTimerBuff) );
    Xin.D.Sys.ThorlabsSciCam(i).frameTimerBuff =	Xin.D.Sys.ThorlabsSciCam(i).frameTimerCurr;
    Xin.D.Sys.ThorlabsSciCam(i).frameNumBuff =      Xin.D.Sys.ThorlabsSciCam(i).frameNumCurr;   
     
	%% process display image: for Thorlabs Cams,   
    %   no need for further Binning, Rotate;
    %   but need for Gain, ROI, ReferenceImage, Histogram
    % GAIN
    switch Xin.D.Sys.ThorlabsSciCam(i).BinX
        case 1
            if  Xin.D.Exp.TakingRefImage    % Full Resolution Reference Image (with long shutter)
            Xin.D.Sys.ThorlabsSciCam(i).DispImgGO(...
                Xin.D.Sys.ThorlabsSciCam(i).DispHeightIndex,...
                Xin.D.Sys.ThorlabsSciCam(i).DispWidthIndex) =    uint8(...
                	squeeze(sum(sum(	reshape(	uint32(Xin.D.Sys.ThorlabsSciCam(i).rawFrame),...
                                                2,	Xin.D.Sys.ThorlabsSciCam(i).pvRawHeight,...
                                                2,  Xin.D.Sys.ThorlabsSciCam(i).pvRawWidth),...
                       	1, 'native'), 3, 'native') )                                        /4/256); 
            else                            % Full Resolution (normal shutter)
            Xin.D.Sys.ThorlabsSciCam(i).DispImgGO(...
                Xin.D.Sys.ThorlabsSciCam(i).DispHeightIndex,...
                Xin.D.Sys.ThorlabsSciCam(i).DispWidthIndex) =    uint8(...
                	squeeze(sum(sum(	reshape(	uint32(Xin.D.Sys.ThorlabsSciCam(i).rawFrame),...
                                                2,	Xin.D.Sys.ThorlabsSciCam(i).pvRawHeight,...
                                                2,  Xin.D.Sys.ThorlabsSciCam(i).pvRawWidth),...
                       	1, 'native'), 3, 'native') )*...
                                                    Xin.D.Sys.ThorlabsSciCam(i).DispGainNum *4/256); 
            end
        case 2                              % Bin=2, for Preview (normal shutter)
            Xin.D.Sys.ThorlabsSciCam(i).DispImgGO(...
                Xin.D.Sys.ThorlabsSciCam(i).DispHeightIndex,...
                Xin.D.Sys.ThorlabsSciCam(i).DispWidthIndex) =    uint8(...
                                                    Xin.D.Sys.ThorlabsSciCam(i).rawFrame*...
                                                    Xin.D.Sys.ThorlabsSciCam(i).DispGainNum *4/256);
        case 4                              % Bin=4, for Recording (normal shutter)
%             Xin.D.Sys.ThorlabsSciCam(i).DispImgGO(...
%                 Xin.D.Sys.ThorlabsSciCam(i).DispHeightIndex,...
%                 Xin.D.Sys.ThorlabsSciCam(i).DispWidthIndex) =    uint8(...
%                                                 repelem(Xin.D.Sys.ThorlabsSciCam(i).rawFrame, 2, 2)*...
%                                                         Xin.D.Sys.ThorlabsSciCam(i).DispGainNum *1/256);  
            Xin.D.Sys.ThorlabsSciCam(i).DispImgGO(...
                Xin.D.Sys.ThorlabsSciCam(i).DispHeightIndex,...
                Xin.D.Sys.ThorlabsSciCam(i).DispWidthIndex) =    repelem(uint8(...
                                                    Xin.D.Sys.ThorlabsSciCam(i).rawFrame*...
                                                    Xin.D.Sys.ThorlabsSciCam(i).DispGainNum *1/256), 2, 2);  
    end
    % ROI 
    if  Xin.D.Sys.ThorlabsSciCam(i).PreviewClipROI
        Xin.D.Sys.ThorlabsSciCam(i).DispImgOO =     Xin.D.Sys.ThorlabsSciCam(i).DispImgGO.*...
                                                    Xin.D.Sys.ThorlabsSciCam(i).ROIi;
    else
        Xin.D.Sys.ThorlabsSciCam(i).DispImgOO =     Xin.D.Sys.ThorlabsSciCam(i).DispImgGO;
    end      
    % IMAGE OUTPUT w/ Reference Image on the green channel
    Xin.D.Sys.ThorlabsSciCam(i).DispImg =               Xin.D.Sys.ThorlabsSciCam(i).DispImgOO;
    if Xin.D.Sys.ThorlabsSciCam(i).PreviewRef
        Xin.D.Sys.ThorlabsSciCam(i).DispImg3(:,:,1) =	Xin.D.Sys.ThorlabsSciCam(i).DispImg;
        Xin.D.Sys.ThorlabsSciCam(i).DispImg3(:,:,2) =	Xin.D.Sys.ThorlabsSciCam(i).DisplayRefImage;
        Xin.D.Sys.ThorlabsSciCam(i).DispImg3(:,:,3) =	Xin.D.Sys.ThorlabsSciCam(i).DispImg;
    else
        Xin.D.Sys.ThorlabsSciCam(i).DispImg3 =	reshape(...
                                                    repmat(Xin.D.Sys.ThorlabsSciCam(i).DispImg, 1, 3),...
                                                    size(Xin.D.Sys.ThorlabsSciCam(i).DispImg,1),...
                                                    size(Xin.D.Sys.ThorlabsSciCam(i).DispImg,2),...
                                                    3);
    end
    % HISTOGRAM
    if Xin.D.Sys.ThorlabsSciCam(i).UpdatePreviewHistogram
        Xin.D.Sys.ThorlabsSciCam(i).DispHistMax =	max(Xin.D.Sys.ThorlabsSciCam(i).DispImg, [], 2);
        Xin.D.Sys.ThorlabsSciCam(i).DispHistMean =	uint8(mean(Xin.D.Sys.ThorlabsSciCam(i).DispImg,2)); 
        Xin.D.Sys.ThorlabsSciCam(i).DispHistMin =	min(Xin.D.Sys.ThorlabsSciCam(i).DispImg, [], 2);
    end 
    t = toc; 
     
    %% Update GUI                           (this section takes ~ 0.9 ms)
    set(Xin.UI.H0.hImage,                   'CData',	Xin.D.Sys.ThorlabsSciCam(i).DispImg3);      % update Image
    set(Xin.UI.H.hVol_CamPreviewFR_Edit,	'String',   Xin.D.Sys.ThorlabsSciCam(i).PreviewStrFR);  % update Str: FrameRate
    set(Xin.UI.H.hVol_CamPreviewTS_Edit,	'String',   Xin.D.Sys.ThorlabsSciCam(i).PreviewStrTS);  % update Str: TimeStamp
	if Xin.D.Sys.ThorlabsSciCam(i).UpdatePreviewHistogram                                           % update Histograms
        set(Xin.UI.H0.hHistMax,     'YData',    Xin.D.Sys.ThorlabsSciCam(i).DispHistMax);
        set(Xin.UI.H0.hHistMean,	'YData',    Xin.D.Sys.ThorlabsSciCam(i).DispHistMean);
        set(Xin.UI.H0.hHistMin,     'YData',    Xin.D.Sys.ThorlabsSciCam(i).DispHistMin); 
	end
%     fprintf('Image frame number: %d, using %5.4f msec\n', Xin.D.Sys.ThorlabsSciCam(i).frameNumCurr, t*1000);
end


