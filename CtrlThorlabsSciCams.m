function varargout = CtrlThorlabsSciCams(varargin)
% This is the control part of ThorlabsSci cameras
 
%% For Standarized SubFunction Callback Control
if nargin==0                % INITIATION
%     InitializeTASKS
elseif ischar(varargin{1})  % INVOKE NAMED SUBFUNCTION OR CALLBACK?
    try
        if (nargout)                        
            [varargout{1:nargout}] = feval(varargin{:});
                            % FEVAL switchyard, w/ output
        else
            feval(varargin{:}); 
                            % FEVAL switchyard, w/o output  
        end
                            % feval('GUI_xxx', varargin);
                            % feval(@GUI_xxx, varargin); 
    catch MException
        rethrow(MException);
    end
end
   
function InitializeTASKS

%% INITIALIZATION

%% CALLBACK FUNCTIONS
function msg = InitializeCallbacks(N)
global Xin
% set(Xin.UI.FigTLSC(N).hFig,	'CloseRequestFcn',	[mfilename, '(@Cam_CleanUp,', num2str(N),')']);
set(Xin.UI.FigTLSC(N).CP.hSys_CamShutter_PotenSlider,	'Callback',	[mfilename, '(''Cam_Shutter'')']);
set(Xin.UI.FigTLSC(N).CP.hSys_CamShutter_PotenEdit,    	'Callback',	[mfilename, '(''Cam_Shutter'')']);
set(Xin.UI.FigTLSC(N).CP.hSys_CamDispGain_PotenSlider,	'Callback',	[mfilename, '(''Cam_DispGain'')']);
set(Xin.UI.FigTLSC(N).CP.hSys_CamDispGain_PotenEdit,	'Callback',	[mfilename, '(''Cam_DispGain'')']);
set(Xin.UI.FigTLSC(N).CP.hExp_RefImage_Momentary,       'Callback',	[mfilename, '(''Ref_Image'')']);
% set(Xin.UI.FigTLSC(N).CP.hMon_PreviewSwitch_Rocker,	'SelectionChangeFcn',	[mfilename, '(''Preview_Switch'')']);
	%% LOG MSG
    msg = [datestr(now, 'yy/mm/dd HH:MM:SS.FFF') '\tInitializeCallbacks\tSetup the Thorlabs Sci Camera #' ...
        num2str(N), '''s GUI Callbacks\r\n'];
    updateMsg(Xin.D.Exp.hLog, msg);
        
function Cam_Shutter(varargin)
    global Xin
	%% get the numbers
    if nargin==0
        % called by GUI: 
        N =                 get(gcbo, 'UserData');
      	uictrlstyle =       get(gcbo, 'Style');
        switch uictrlstyle
            case 'slider';  Shutter = get(gcbo, 'value');
            case 'edit';    Shutter = str2double(get(gcbo,'string'));	
            otherwise;      errordlg('What''s the hell?');
                            return;
        end
    else
        % called by general update: e.g. Cam_Shutter(1, 20.00)
        N =                 varargin{1};    % Camera number
        Shutter =           varargin{2};    % Shutter value (ms)
    end
    %% check the constraints
    maxshutter = Xin.HW.Thorlabs.hSciCam{N}.ExposureTimeRange_us.Maximum/1000;
    minshutter = Xin.HW.Thorlabs.hSciCam{N}.ExposureTimeRange_us.Minimum/1000;
    if isnan(Shutter) || Shutter<minshutter || Shutter>maxshutter
        Shutter =                               Xin.D.Sys.ThorlabsSciCam(N).Shutter;
        warndlg('Input Shutter value is out of the device constraits')        
    else
        Xin.D.Sys.ThorlabsSciCam(N).Shutter =	Shutter;
    end
    Xin.HW.Thorlabs.hSciCam{N}.ExposureTime_us =    Xin.D.Sys.ThorlabsSciCam(N).Shutter*1000;
    s = sprintf('%05.2f',Shutter);
    set(Xin.UI.FigTLSC(N).CP.hSys_CamShutter_PotenSlider,	'value',	Shutter);    
    set(Xin.UI.FigTLSC(N).CP.hSys_CamShutter_PotenEdit,     'string',   s);
	%% LOG MSG
    msg = [datestr(now, 'yy/mm/dd HH:MM:SS.FFF') '\tCam_Shutter\tSetup the ThorlabsSci Camera #' ...
        num2str(N), '''s Shutter as: ' s ' (ms)\r\n'];
    updateMsg(Xin.D.Exp.hLog, msg);
    
function Cam_DispGain(varargin)
    global Xin
    %% get the numbers
    if nargin==0
        % called by GUI: 
        N =                 get(gcbo, 'UserData');
      	uictrlstyle =       get(gcbo, 'Style');
        switch uictrlstyle
            case 'slider';  DispGainBit = get(gcbo, 'value');
                            DispGainNum = 2^DispGainBit;
            case 'edit';    DispGainNum = str2double(get(gcbo,'string'));	
                            DispGainBit = log2(DispGainNum);
            otherwise;      errordlg('What''s the hell?');
                            return;
        end
    else
        % called by general update: e.g. Disp_Gain(16)
        N =                 varargin{1};    % Camera number
        DispGainNum =       varargin{2};    % DispGain number
        DispGainBit =       log2(DispGainNum); 
    end
    %% Check whether the number is valid to update  
    if  ismember(DispGainBit, Xin.D.Sys.Camera.DispGainBitRange)
        Xin.D.Sys.ThorlabsSciCam(N).DispGainBit =	DispGainBit;
        Xin.D.Sys.ThorlabsSciCam(N).DispGainNum =	DispGainNum;
    end
    s = sprintf(' %d', Xin.D.Sys.ThorlabsSciCam(N).DispGainNum);
    set(Xin.UI.FigTLSC(N).CP.hSys_CamDispGain_PotenSlider,	'value',	Xin.D.Sys.ThorlabsSciCam(N).DispGainBit);    
    set(Xin.UI.FigTLSC(N).CP.hSys_CamDispGain_PotenEdit,	'string',   s);   
    %% LOG MSG
    msg = [datestr(now, 'yy/mm/dd HH:MM:SS.FFF') '\tDisp_Gain\tSetup the ThorlabsSci Camera #' ...
        num2str(N), '''s DISP gain as: ' s '\r\n'];
    updateMsg(Xin.D.Exp.hLog, msg);

    
function Ref_Image(varargin)
    global Xin
	%% Get the Inputs
    if nargin==0
        % called by GUI: 
        N =                 get(gcbo, 'UserData');
    else
        % called by general update:	e.g. Ref_Image(2)
        N =                 varargin{1}; 
    end
    %% Setup Parameters
	imageinfo = {...
        ['System Cam Shutter: ',        sprintf('%5.2f',Xin.D.Sys.ThorlabsSciCam(N).Shutter),  ' (ms); '],...
        ['System Cam DispGainNum: ',	num2str(Xin.D.Sys.ThorlabsSciCam(N).DispGainNum),  ' (frames); '],...
        };    
    if ~exist(Xin.D.Exp.DataDir, 'dir')
        mkdir(Xin.D.Exp.DataDir);
    end
        	imageinfo = [imageinfo,{...
                ['System Light Source: ',           Xin.D.Sys.Light.Source,                             '; '],...
                ['System Light Wavelength: ',       num2str(Xin.D.Sys.Light.Wavelength),                'nm; '],...
                ['System Light Port: ',             Xin.D.Sys.Light.Port,                               '; '],...
                ['System Light Diffuser: ',         num2str(Xin.D.Sys.Light.Diffuser),                  'º; '],...
                ['System Light Head Cube: ',        Xin.D.Sys.Light.HeadCube,                           '; '],...
                ['System Camera Lens Angle: ',      num2str(Xin.D.Sys.CameraLens.Angle),                'º; '],...
                ['System Camera Lens Aperture: ',   sprintf('f/%.2g',Xin.D.Sys.CameraLens.Aperture),	'; '],...
                ['Monkey ID: ',                     Xin.D.Mky.ID,                                       '; '],...
                ['Monkey Side: ',                   Xin.D.Mky.Side,                                     '; '],...
                ['Monkey Prep: ',                   Xin.D.Mky.Prep,                                     '; '],...
                ['Experiment Date: ',               Xin.D.Exp.DateStr,                                  '; '],...
                ['Experiment Depth: ',              sprintf('%d',Xin.D.Exp.Depth),                      ' (LT1 fine turn); ']...
                }];  
	ShutterMultiplier =	Xin.D.Sys.ThorlabsSciCam(N).DispGainNum* ...
                        Xin.D.Sys.Camera.SaveBinNum^2; 
% 	DataBit =           16;
% 	PowerMeterFlag =	0;         
    DataNumApp =        ['_',...
                        Xin.D.Sys.Light.Source,  '_',...
                        Xin.D.Sys.Light.Port,    '_',...
                        Xin.D.Sys.Light.HeadCube];      
    %% Questdlg the information
    promptinfo = [...
        imageinfo,...
        {''},...
        {'Are these settings correct?'}];
    choice = questdlg(promptinfo,...
        'Imaging conditions:',...
        'No, Cancel and Reset', 'Yes, Take an Image',...
        'No, Cancel and Reset');
   	switch choice
        case 'No, Cancel and Reset';    return;
        case 'Yes, Take an Image'
    end
    %% Setup the Acquisation
    Xin.D.Exp.TakingRefImage = 1;
    Xin.HW.Thorlabs.hSciCam{N}.ExposureTime_us = Xin.D.Sys.ThorlabsSciCam(N).Shutter *1000 *ShutterMultiplier;
    SetupAndArm(    N,  1,      1,      'soft');
	%               N,  bin,    FPT,	trigger 
    %% Issue Camera Trigger & Run
    Xin.HW.Thorlabs.hSciCam{N}.IssueSoftwareTrigger;
    while Xin.D.Sys.ThorlabsSciCam(N).Running
        pause(Xin.D.Sys.ThorlabsSciCam(N).DispPeriod/100);
        status = updatePreviewFrameThorlabs(N);
        if status
            Xin.D.Sys.ThorlabsSciCam(N).Running = false;
        end
    end
    if (isvalid(Xin.HW.Thorlabs.hSciCam{N}))
        Xin.HW.Thorlabs.hSciCam{N}.Disarm;
    end   
    Xin.D.Exp.TakingRefImage = 0;
    Xin.HW.Thorlabs.hSciCam{N}.ExposureTime_us = Xin.D.Sys.ThorlabsSciCam(N).Shutter *1000;                                            
    Xin.D.Sys.ThorlabsSciCam(N).rawFrameData = uint16(Xin.D.Sys.ThorlabsSciCam(N).imageFrame.ImageData.ImageData_monoOrBGR);
    Xin.D.Sys.ThorlabsSciCam(N).RefImage  =  reshape(Xin.D.Sys.ThorlabsSciCam(N).rawFrameData,...
                                                [   Xin.D.Sys.ThorlabsSciCam(N).rawWidth,...
                                                    Xin.D.Sys.ThorlabsSciCam(N).rawHeight])';
    %% Power Meter
%     if ~strcmp(Xin.D.Sys.Light.Monitoring, 'N') && strcmp(CamName, 'Grasshopper3 GS3-U3-23S6M')
%         Xin.D.Sys.PowerMeter{1}.WAVelength =        Xin.D.Sys.Light.Wavelength;
%         Xin.D.Sys.PowerMeter{1}.INPutFILTering =    1*strcmp(Xin.D.Sys.Light.Monitoring, 'S'); 
%                                                     % 15Hz :1, 100kHz :0
%         Xin.D.Sys.PowerMeter{1}.AVERageCOUNt =      round( (TriggerRepeat+1)*(1/Xin.HW.Thorlabs.hSciCam(N).hSrc.FrameRate)/0.0003 ); 
%                                                     % average Counts (1~=.3ms)
%         Xin.D.Sys.PowerMeter{1}.InitialMEAsurement= 1;  % send the initial messurement request
%         SetupThorlabsPowerMeters('Xin');
%         pause((TriggerRepeat+1)*(1/Xin.HW.Thorlabs.hSciCam(N).hSrc.FrameRate)+0.1);
%                                                     % wait for the power
%                                                     % integration
%         power =     Xin.HW.Thorlabs.PM100{1}.h.fscanf;
%         imageinfo = [ imageinfo,...
%         {['Power Port: ',  	power,              ' (W); ']} ];
%     end
    %% Save the Image
    datestrfull =	datestr(now, 30);
    dataname =      [datestrfull(3:end), DataNumApp];    
    figure(...
        'Name',             dataname,...
        'NumberTitle',      'off',...
        'Color',            Xin.UI.C.BG,...
        'MenuBar',          'none',...
        'DoubleBuffer',     'off');
    imshow(Xin.D.Sys.ThorlabsSciCam(N).RefImage);
    box on
    imagedescription = strjoin(imageinfo);
    imwrite(Xin.D.Sys.ThorlabsSciCam(N).RefImage, [Xin.D.Exp.DataDir, dataname, '.tif'],...
        'Compression',          'deflate',...
        'Description',          imagedescription);
    %% LOG MSG    
    msg = [datestr(now, 'yy/mm/dd HH:MM:SS.FFF') '\tRef_Image\tA reference image has been taken from ThorlabsSci Camera #'...
        num2str(N), ':xxx \r\n'];
    updateMsg(Xin.D.Exp.hLog, msg);
    
function SoftwareTriggerPreview(varargin) 
    global Xin
	%% get the numbers
    if nargin==0
        % called by GUI: 
    else
        % called by general update: e.g. Cam_Shutter(1, 20.00)
        N =                 varargin{1};    % Camera number
    end
    set(Xin.UI.FigTLSC(N).CP.hExp_RefImage_Momentary,	'Enable', 'off');
    SetupAndArm(    N,  2,      0,      'soft');
	%               N,  bin,    FPT, 	trigger 
    %% Issue Camera Trigger & Run
    Xin.HW.Thorlabs.hSciCam{N}.IssueSoftwareTrigger;
    while Xin.D.Sys.ThorlabsSciCam(N).Running
        pause(Xin.D.Sys.ThorlabsSciCam(N).DispPeriod/100);
        updatePreviewFrameThorlabs(N);
    end
    %% Stop the camera
    if (isvalid(Xin.HW.Thorlabs.hSciCam{N}))
        Xin.HW.Thorlabs.hSciCam{N}.Disarm;
    end
    set(Xin.UI.FigTLSC(N).CP.hExp_RefImage_Momentary,	'Enable', 'on');
    
 function SetupAndArm(N, bin, FPT, trigger)
	global Xin
    %% Allocate Memory for the Image  
    Xin.D.Sys.ThorlabsSciCam(N).BinX = bin;
    Xin.D.Sys.ThorlabsSciCam(N).BinY = bin;
    Xin.D.Sys.ThorlabsSciCam(N).rawHeight =	Xin.D.Sys.ThorlabsSciCam(N).ROIHeight/Xin.D.Sys.ThorlabsSciCam(N).BinY;
    Xin.D.Sys.ThorlabsSciCam(N).rawWidth =	Xin.D.Sys.ThorlabsSciCam(N).ROIWidth /Xin.D.Sys.ThorlabsSciCam(N).BinX;
    Xin.D.Sys.ThorlabsSciCam(N).rawFrameData =  uint16(zeros(1, Xin.D.Sys.ThorlabsSciCam(N).rawWidth*...
                                                                Xin.D.Sys.ThorlabsSciCam(N).rawHeight));
    Xin.D.Sys.ThorlabsSciCam(N).rawFrame =  reshape(Xin.D.Sys.ThorlabsSciCam(N).rawFrameData,...
                                                [   Xin.D.Sys.ThorlabsSciCam(N).rawWidth,...
                                                    Xin.D.Sys.ThorlabsSciCam(N).rawHeight])';
    Xin.D.Sys.ThorlabsSciCam(N).DispTimer =	second(now);
    
        Xin.D.Sys.ThorlabsSciCam(N).frameTimerBuff =    now;
        Xin.D.Sys.ThorlabsSciCam(N).frameTimerCurr =    now;
        Xin.D.Sys.ThorlabsSciCam(N).frameNumBuff =      0;
        Xin.D.Sys.ThorlabsSciCam(N).frameNumCurr =      0;
        Xin.D.Sys.ThorlabsSciCam(N).DispTimer =	now;
        Xin.D.Sys.ThorlabsSciCam(N).Running =   true;
        
    %% Setup Camera 
    roiAndBin = Xin.HW.Thorlabs.hSciCam{N}.ROIAndBin;
        roiAndBin.BinX =    int32(Xin.D.Sys.ThorlabsSciCam(N).BinX);
        roiAndBin.BinY =    int32(Xin.D.Sys.ThorlabsSciCam(N).BinY);
        roiAndBin.ROIOriginX_pixels =   Xin.D.Sys.ThorlabsSciCam(N).ROIOriginX;	% 0-1919
        roiAndBin.ROIOriginY_pixels =   Xin.D.Sys.ThorlabsSciCam(N).ROIOriginY;	% 0-1079
        roiAndBin.ROIWidth_pixels =     Xin.D.Sys.ThorlabsSciCam(N).ROIWidth;
        roiAndBin.ROIHeight_pixels =    Xin.D.Sys.ThorlabsSciCam(N).ROIHeight;
        Xin.HW.Thorlabs.hSciCam{N}.ROIAndBin = roiAndBin;
    Xin.HW.Thorlabs.hSciCam{N}.FramesPerTrigger_zeroForUnlimited = FPT; % 0 = continuous 
    switch trigger
        case 'soft'; Xin.HW.Thorlabs.hSciCam{N}.OperationMode = Thorlabs.TSI.TLCameraInterfaces.OperationMode.SoftwareTriggered;
        case 'hard'; Xin.HW.Thorlabs.hSciCam{N}.OperationMode = Thorlabs.TSI.TLCameraInterfaces.OperationMode.HardwareTriggered;
    end
    Xin.HW.Thorlabs.hSciCam{N}.Arm;
    
    %% Search & allocate the mode
    if      strcmp(trigger, 'hard');            ic = 3;
    elseif  strcmp(trigger, 'soft') && FPT ==0; ic = 2;
    elseif  strcmp(trigger, 'soft') && FPT >0;  ic = 1;
    end
    %% Update Trigger GUI
    try
        a = get(Xin.UI.FigTLSC(N).CP.hSes_CamTrigger_Rocker, 'Children');
        set(Xin.UI.FigTLSC(N).CP.hSes_CamTrigger_Rocker, 'SelectedObject', a(ic));
        for j = 1:3
            if j == ic
                set(a(j),	'backgroundcolor', Xin.UI.C.SelectB); 
            else                
                set(a(j),	'backgroundcolor', Xin.UI.C.TextBG);
            end
        end
    catch
        disp('GUI update on trigger mode does not apply');
    end    
    %% LOG MSG    
    msg = [datestr(now, 'yy/mm/dd HH:MM:SS.FFF') '\tSetupAndArm\tSetup the ThorlabsSci Camera #' ...
        num2str(N), '''s Bin#=', num2str(bin), '; ', trigger, 'wareTrigger for ' ...
        FPT 'frames (0=continuous)\r\n'];
    updateMsg(Xin.D.Exp.hLog, msg);
    

    
% function Preview_Switch(varargin)
%     global Xin
%   	%% where the call is from      
%     if nargin==0
%         % called by GUI:            Camera_Preview
%         N =         get(get(get(gcbo, 'SelectedObject'), 'Parent'), 'UserData');
%         val =       get(get(gcbo,'SelectedObject'),'string');
%         [~, val] =  strtok(val, ' ');
%         val =       val(2:end);
%     else
%         % called by general update: Prreview_Switch(1, 'ON') or Prreview_Switch(1, 'OFF')
%         N =         varargin{1};            % Camera number
%         val =       varargin{2};            % 'ON' or 'OFF' 
%     end
% 	hc =   get(Xin.UI.FigTLSC(N).CP.hMon_PreviewSwitch_Rocker, 'Children');
%     for j = 1:3
%         switch j
%             case 1
%             case 2  % OFF 
%                     if  strcmp(val, 'OFF')
%                         set(hc(j),	'backgroundcolor', Xin.UI.C.SelectB);
%                         set(Xin.UI.FigTLSC(N).CP.hMon_PreviewSwitch_Rocker,...
%                                     'SelectedObject',   hc(j));
%                         stoppreview(Xin.HW.Thorlabs.hSciCam(N).hVid);  
%                         Xin.D.Sys.ThorlabsSciCam(N).DispImg = ...
%                             uint8(0*Xin.D.Sys.ThorlabsSciCam(N).DispImg);
%                     	set(Xin.UI.FigTLSC(N).hImage, 'CData',...
%                             Xin.D.Sys.ThorlabsSciCam(N).DispImg);
%                     else                
%                         set(hc(j),	'backgroundcolor', Xin.UI.C.TextBG);
%                     end
%             case 3  % ON
%                     if  strcmp(val, 'ON')
%                         set(hc(j),	'backgroundcolor', Xin.UI.C.SelectB);
%                         set(Xin.UI.FigTLSC(N).CP.hMon_PreviewSwitch_Rocker,...
%                                     'SelectedObject',   hc(j));
%                         setappdata(Xin.UI.FigTLSC(N).hImageHide,...
%                             'UpdatePreviewWindowFcn',...
%                             Xin.D.Sys.ThorlabsSciCam(N).UpdatePreviewWindowFcn);
%                         preview(Xin.HW.Thorlabs.hSciCam(N).hVid,...
%                             Xin.UI.FigTLSC(N).hImageHide);  
%                     else                
%                         set(hc(j),	'backgroundcolor', Xin.UI.C.TextBG);
%                     end
%             otherwise
%         end
%     end
%     %% LOG MSG
%     msg = [datestr(now, 'yy/mm/dd HH:MM:SS.FFF') '\tMon_PreviewSwitch\tThorlabsSci Camera #' ...
%         num2str(N), ' switched to ', val, '\r\n'];
%     updateMsg(Xin.D.Exp.hLog, msg);

    
% function Trigger_Mode(varargin)
%     global Xin    
%     N =     varargin{1};
%     mode =  varargin{2};
%     %% Search & allocate the mode
%     for i = 1: length(Xin.D.Sys.ThorlabsSciCam(N).TriggerMode)
%         if strcmp(Xin.D.Sys.ThorlabsSciCam(N).TriggerMode(i).Name, mode)
%             ic = i;
%         end
%     end     
%     Xin.D.Sys.ThorlabsSciCam(N).TriggerName =      Xin.D.Sys.ThorlabsSciCam(N).TriggerMode(ic).Name;  
%     Xin.D.Sys.ThorlabsSciCam(N).TriggerType =      Xin.D.Sys.ThorlabsSciCam(N).TriggerMode(ic).TriggerType;         
%     Xin.D.Sys.ThorlabsSciCam(N).TriggerCondition = Xin.D.Sys.ThorlabsSciCam(N).TriggerMode(ic).TriggerCondition; 
%     Xin.D.Sys.ThorlabsSciCam(N).TriggerSource =    Xin.D.Sys.ThorlabsSciCam(N).TriggerMode(ic).TriggerSource;
%     %% Update Trigger GUI
%     try
%         a = get(Xin.UI.FigTLSC(N).CP.hSes_CamTrigger_Rocker, 'Children');
%         set(Xin.UI.FigTLSC(N).CP.hSes_CamTrigger_Rocker, 'SelectedObject', a(ic));
%         for j = 1:3
%             if j == ic
%                 set(a(j),	'backgroundcolor', Xin.UI.C.SelectB); 
%             else                
%                 set(a(j),	'backgroundcolor', Xin.UI.C.TextBG);
%             end
%         end
%     catch
%         disp('GUI update on trigger mode does not apply');
%     end
%     %% Set the VideoInput object
%     triggerconfig(Xin.HW.Thorlabs.hSciCam(N).hVid, ...
%         Xin.D.Sys.ThorlabsSciCam(N).TriggerType,...
%         Xin.D.Sys.ThorlabsSciCam(N).TriggerCondition,...
%         Xin.D.Sys.ThorlabsSciCam(N).TriggerSource);     
%     %% LOG MSG    
%     msg = [datestr(now, 'yy/mm/dd HH:MM:SS.FFF') '\tTrigger_Mode\tSetup the ThorlabsSci Camera #' ...
%         num2str(N), '''s Trigger mode selected as: "' ...
%          Xin.D.Sys.ThorlabsSciCam(N).TriggerName '"\r\n'];
%     updateMsg(Xin.D.Exp.hLog, msg);