function varargout = CtrlPointGreyCams(varargin)
% This is the control part of pointgrey cameras
 
%% For Standarized SubFunction Callback Control
if nargin==0                % INITIATION
    InitializeTASKS
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
% set(Xin.UI.FigPGC(N).hFig,	'CloseRequestFcn',	[mfilename, '(@Cam_CleanUp,', num2str(N),')']);
set(Xin.UI.FigPGC(N).CP.hSys_CamShutter_PotenSlider,	'Callback',	[mfilename, '(''Cam_Shutter'')']);
set(Xin.UI.FigPGC(N).CP.hSys_CamShutter_PotenEdit,    	'Callback',	[mfilename, '(''Cam_Shutter'')']);
set(Xin.UI.FigPGC(N).CP.hSys_CamGain_PotenSlider,     	'Callback',	[mfilename, '(''Cam_Gain'')']);
set(Xin.UI.FigPGC(N).CP.hSys_CamGain_PotenEdit,      	'Callback',	[mfilename, '(''Cam_Gain'')']);
set(Xin.UI.FigPGC(N).CP.hSys_CamDispGain_PotenSlider,	'Callback',	[mfilename, '(''Cam_DispGain'')']);
set(Xin.UI.FigPGC(N).CP.hSys_CamDispGain_PotenEdit,     'Callback',	[mfilename, '(''Cam_DispGain'')']);
set(Xin.UI.FigPGC(N).CP.hExp_RefImage_Momentary,        'Callback',	[mfilename, '(''Ref_Image'')']);
set(Xin.UI.FigPGC(N).CP.hMon_PreviewSwitch_Rocker,	'SelectionChangeFcn',	[mfilename, '(''Preview_Switch'')']);
	%% LOG MSG
    msg = [datestr(now, 'yy/mm/dd HH:MM:SS.FFF') '\tInitializeCallbacks\tSetup the PointGrey Camera #' ...
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
    pSrc = propinfo(Xin.HW.PointGrey.Cam(N).hSrc);
    if isnan(Shutter) || Shutter<pSrc.Shutter.ConstraintValue(1) || Shutter>pSrc.Shutter.ConstraintValue(2)
        Shutter =                           Xin.D.Sys.PointGreyCam(N).Shutter;
        warndlg('Input Shutter value is out of the device constraits')        
    else
        Xin.D.Sys.PointGreyCam(N).Shutter =	Shutter;
    end
    Xin.HW.PointGrey.Cam(N).hSrc.Shutter = 	Xin.D.Sys.PointGreyCam(N).Shutter; 
    s = sprintf('%05.2f',Shutter);
    set(Xin.UI.FigPGC(N).CP.hSys_CamShutter_PotenSlider,	'value',	Shutter);    
    set(Xin.UI.FigPGC(N).CP.hSys_CamShutter_PotenEdit,      'string',   s);
	%% LOG MSG
    msg = [datestr(now, 'yy/mm/dd HH:MM:SS.FFF') '\tCam_Shutter\tSetup the PointGrey Camera #' ...
        num2str(N), '''s Shutter as: ' s ' (ms)\r\n'];
    updateMsg(Xin.D.Exp.hLog, msg);
    
function Cam_Gain(varargin)
    global Xin
	%% get the numbers
    if nargin==0
        % called by GUI: 
        N =                 get(gcbo, 'UserData');
      	uictrlstyle =       get(gcbo, 'Style');
        switch uictrlstyle
            case 'slider';  Gain =  get(gcbo, 'value');
            case 'edit';    Gain =  str2double(get(gcbo,'string'));	
            otherwise;      errordlg('What''s the hell?');
                            return;
        end
    else
        % called by general update: e.g. Cam_Gain(2, 18.00)
        N =                 varargin{1};    % Camera number
        Gain =              varargin{2};    % Gain value (dB)
    end
    
    %% check the constraints
    pSrc = propinfo(Xin.HW.PointGrey.Cam(N).hSrc);
    if isnan(Gain) || Gain<pSrc.Gain.ConstraintValue(1) || Gain>pSrc.Gain.ConstraintValue(2)
        Gain =                              Xin.D.Sys.PointGreyCam(N).Gain;
        warndlg('Input Gain value is out of the device constraits')        
    else
        Xin.D.Sys.PointGreyCam(N).Gain =    Gain;
    end 
    Xin.HW.PointGrey.Cam(N).hSrc.Gain = 	Xin.D.Sys.PointGreyCam(N).Gain; 
    s = sprintf('%05.2f', Gain);
    set(Xin.UI.FigPGC(N).CP.hSys_CamGain_PotenSlider,	'value',	Gain);    
    set(Xin.UI.FigPGC(N).CP.hSys_CamGain_PotenEdit, 	'string',   s);
  	%% LOG MSG
    msg = [datestr(now, 'yy/mm/dd HH:MM:SS.FFF') '\tCam_Gain\tSetup the PointGrey Camera #' ...
        num2str(N), '''s gain as: ' s ' (dB)\r\n'];
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
    if  ismember(DispGainBit, Xin.D.Sys.PointGreyCamDispGainBitRange)
        Xin.D.Sys.PointGreyCam(N).DispGainBit =	DispGainBit;
        Xin.D.Sys.PointGreyCam(N).DispGainNum =	DispGainNum;
    end
    s = sprintf(' %d', Xin.D.Sys.PointGreyCam(N).DispGainNum);
    set(Xin.UI.FigPGC(N).CP.hSys_CamDispGain_PotenSlider,	'value',	Xin.D.Sys.PointGreyCam(N).DispGainBit);    
    set(Xin.UI.FigPGC(N).CP.hSys_CamDispGain_PotenEdit,	'string',   s);   
    %% LOG MSG
    msg = [datestr(now, 'yy/mm/dd HH:MM:SS.FFF') '\tDisp_Gain\tSetup the PointGrey Camera #' ...
        num2str(N), '''s DISP gain as: ' s '\r\n'];
    updateMsg(Xin.D.Exp.hLog, msg);
    
function Preview_Switch(varargin)
    global Xin
  	%% where the call is from      
    if nargin==0
        % called by GUI:            Camera_Preview
        N =         get(get(get(gcbo, 'SelectedObject'), 'Parent'), 'UserData');
        val =       get(get(gcbo,'SelectedObject'),'string');
        [~, val] =  strtok(val, ' ');
        val =       val(2:end);
    else
        % called by general update: Prreview_Switch(1, 'ON') or Prreview_Switch(1, 'OFF')
        N =         varargin{1};            % Camera number
        val =       varargin{2};            % 'ON' or 'OFF' 
    end
	hc =   get(Xin.UI.FigPGC(N).CP.hMon_PreviewSwitch_Rocker, 'Children');
    for j = 1:3
        switch j
            case 1
            case 2  % OFF 
                    if  strcmp(val, 'OFF')
                        set(hc(j),	'backgroundcolor', Xin.UI.C.SelectB);
                        set(Xin.UI.FigPGC(N).CP.hMon_PreviewSwitch_Rocker,...
                                    'SelectedObject',   hc(j));
                        stoppreview(Xin.HW.PointGrey.Cam(N).hVid);  
                        Xin.D.Sys.PointGreyCam(N).DispImg = ...
                            uint8(0*Xin.D.Sys.PointGreyCam(N).DispImg);
                    	set(Xin.UI.FigPGC(N).hImage, 'CData',...
                            Xin.D.Sys.PointGreyCam(N).DispImg);
                    else                
                        set(hc(j),	'backgroundcolor', Xin.UI.C.TextBG);
                    end
            case 3  % ON
                    if  strcmp(val, 'ON')
                        set(hc(j),	'backgroundcolor', Xin.UI.C.SelectB);
                        set(Xin.UI.FigPGC(N).CP.hMon_PreviewSwitch_Rocker,...
                                    'SelectedObject',   hc(j));
                        setappdata(Xin.UI.FigPGC(N).hImageHide,...
                            'UpdatePreviewWindowFcn',...
                            Xin.D.Sys.PointGreyCam(N).UpdatePreviewWindowFcn);
                        preview(Xin.HW.PointGrey.Cam(N).hVid,...
                            Xin.UI.FigPGC(N).hImageHide);  
                    else                
                        set(hc(j),	'backgroundcolor', Xin.UI.C.TextBG);
                    end
            otherwise
        end
    end
    %% LOG MSG
    msg = [datestr(now, 'yy/mm/dd HH:MM:SS.FFF') '\tMon_PreviewSwitch\tPointGrey Camera #' ...
        num2str(N), ' switched to ', val, '\r\n'];
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
    CamName =                           Xin.D.Sys.PointGreyCam(N).DeviceName;
	TriggerRepeat =                     Xin.D.Sys.PointGreyCam(N).DispGainNum - 1;
	DataBit =                           8;
	PowerMeterFlag =                    0;
	imageinfo = {...
        ['System Cam Shutter: ',        sprintf('%5.2f',Xin.D.Sys.PointGreyCam(N).Shutter),  ' (ms); '],...
        ['System Cam Gain: ',           sprintf('%5.2f',Xin.D.Sys.PointGreyCam(N).Gain),     ' (dB); '],...
        ['System Cam DispGainNum: ',	num2str(Xin.D.Sys.PointGreyCam(N).DispGainNum),  ' (frames); '],...
        };    
    if ~exist(Xin.D.Exp.DataDir, 'dir')
        mkdir(Xin.D.Exp.DataDir);
    end
    switch CamName
        case 'Firefly MV FMVU-03MTM'
            DataNumApp =                '_AnimalMonitor'; 
        case 'Flea3 FL3-U3-88S2C'
            DataNumApp =                '_BrainSurface';   
        case 'Grasshopper3 GS3-U3-23S6M'
        	imageinfo = [imageinfo,{...
                ['System Light Source: ',       Xin.D.Sys.Light.Source,     '; '],...
                ['System Light Port: ',     	Xin.D.Sys.Light.Port,       '; '],...
                ['System Light Head Cube: ',	Xin.D.Sys.Light.HeadCube,	'; '],...
                ['Monkey ID: ',         Xin.D.Mky.ID,                       '; '],...
                ['Monkey Side: ',       Xin.D.Mky.Side,                     '; '],...
                ['Experiment Date: ',	Xin.D.Exp.DateStr,                  '; '],...
                ['Experiment Depth: ',	sprintf('%5.2f',Xin.D.Exp.Depth),   ' (LT1 fine turn); ']...
                }];  
            TriggerRepeat =             Xin.D.Sys.PointGreyCam(N).DispGainNum*2^(16-12) - 1;
            if strcmp(Xin.D.Sys.Light.Port, 'Koehler')
                PowerMeterFlag = 1;
            end
            DataBit =                   16;           
            DataNumApp =                ['_',...
                                        Xin.D.Sys.Light.Source,  '_',...
                                        Xin.D.Sys.Light.Port,    '_',...
                                        Xin.D.Sys.Light.HeadCube];      
        otherwise
    end
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
    %% Camera Trigger Settings   
    Trigger_Mode(N, 'SoftwareGrab');
	Xin.HW.PointGrey.Cam(N).hVid.TriggerRepeat = TriggerRepeat;
    %% Capturing Images
	start(          Xin.HW.PointGrey.Cam(N).hVid);
    if PowerMeterFlag
        fprintf(    Xin.HW.Thorlabs.PM100{1}.h,  'MEAS:POW?');
        pause(0.1);
        power =     Xin.HW.Thorlabs.PM100{1}.h.fscanf;
    end
    if Xin.HW.PointGrey.Cam(N).hVid.TriggerRepeat ~= 0
        wait(Xin.HW.PointGrey.Cam(N).hVid,   Xin.HW.PointGrey.Cam(N).hVid.TriggerRepeat);  
    end
    [idata,~,~] = getdata(Xin.HW.PointGrey.Cam(N).hVid,...
        Xin.HW.PointGrey.Cam(N).hVid.TriggerRepeat+1,   'native', 'numeric');  
    if Xin.HW.PointGrey.Cam(N).hVid.TriggerRepeat ~= 0  
        RefImage =                      uint16( rot90(squeeze(sum(idata,4)), ...
                                        	(360-Xin.D.Sys.PointGreyCam(N).PreviewRot)/90) );
    else
        RefImage =                      uint16( rot90(idata, ...
                                        	(360-Xin.D.Sys.PointGreyCam(N).PreviewRot)/90) );        
    end
    if      DataBit == 8
        Xin.D.Sys.PointGreyCam(N).RefImage = uint8(RefImage);
    elseif  DataBit == 16
        Xin.D.Sys.PointGreyCam(N).RefImage = uint16(RefImage);        
    end
    %% Save the Image
    datestrfull =	datestr(now, 30);
    dataname =      [datestrfull(3:end), DataNumApp];    
    figure(...
        'Name',             dataname,...
        'NumberTitle',      'off',...
        'Color',            Xin.UI.C.BG,...
        'MenuBar',          'none',...
        'DoubleBuffer',     'off');
    imshow(Xin.D.Sys.PointGreyCam(N).RefImage);
    box on
    if PowerMeterFlag
        imageinfo = [ imageinfo,...
        {['Power Port: ',  	power,              ' (W); ']} ];
    end
    imagedescription = strjoin(imageinfo);
    imwrite(Xin.D.Sys.PointGreyCam(N).RefImage, [Xin.D.Exp.DataDir, dataname, '.tif'],...
        'Compression',          'deflate',...
        'Description',          imagedescription);
    %% LOG MSG    
    msg = [datestr(now, 'yy/mm/dd HH:MM:SS.FFF') '\tRef_Image\tA reference image has been taken from PointGrey Camera #'...
        num2str(N), ':', Xin.D.Sys.PointGreyCam(N).Comments,'\r\n'];
    updateMsg(Xin.D.Exp.hLog, msg);
    
function Trigger_Mode(varargin)
    global Xin    
    N =     varargin{1};
    mode =  varargin{2};
    %% Search & allocate the mode
    for i = 1: length(Xin.D.Sys.PointGreyCamTriggerMode)
        if strcmp(Xin.D.Sys.PointGreyCamTriggerMode(i).Name, mode)
            ic = i;
        end
    end     
    Xin.D.Sys.PointGreyCam(N).TriggerName =      Xin.D.Sys.PointGreyCamTriggerMode(ic).Name;  
    Xin.D.Sys.PointGreyCam(N).TriggerType =      Xin.D.Sys.PointGreyCamTriggerMode(ic).TriggerType;         
    Xin.D.Sys.PointGreyCam(N).TriggerCondition = Xin.D.Sys.PointGreyCamTriggerMode(ic).TriggerCondition; 
    Xin.D.Sys.PointGreyCam(N).TriggerSource =    Xin.D.Sys.PointGreyCamTriggerMode(ic).TriggerSource;
    %% Update Trigger GUI
    try
        a = get(Xin.UI.FigPGC(N).CP.hSes_CamTrigger_Rocker, 'Children');
        set(Xin.UI.FigPGC(N).CP.hSes_CamTrigger_Rocker, 'SelectedObject', a(ic));
        for j = 1:3
            if j == ic
                set(a(j),	'backgroundcolor', Xin.UI.C.SelectB); 
            else                
                set(a(j),	'backgroundcolor', Xin.UI.C.TextBG);
            end
        end
    catch
        disp('Trigger mode GUI update does not apply');
    end
    %% Set the VideoInput object
    triggerconfig(Xin.HW.PointGrey.Cam(N).hVid, ...
        Xin.D.Sys.PointGreyCam(N).TriggerType,...
        Xin.D.Sys.PointGreyCam(N).TriggerCondition,...
        Xin.D.Sys.PointGreyCam(N).TriggerSource);     
    %% LOG MSG    
    msg = [datestr(now, 'yy/mm/dd HH:MM:SS.FFF') '\tTrigger_Mode\tSetup the PointGrey Camera #' ...
        num2str(N), '''s Trigger mode selected as: "' ...
         Xin.D.Sys.PointGreyCam(N).TriggerName '"\r\n'];
    updateMsg(Xin.D.Exp.hLog, msg);