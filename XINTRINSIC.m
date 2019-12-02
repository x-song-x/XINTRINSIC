function varargout = XINTRINSIC(varargin)
% This is the control software for Xindong's Xintrinsic setup in Wang lab.
% 
%% For Standarized SubFunction Callback Control
if nargin==0                % INITIATION
    InitializeTASKS
elseif ischar(varargin{1})  % INVOKE NAMED SUBFUNCTION OR CALLBACK
    try
        if (nargout)                        
            [varargout{1:nargout}] = feval(varargin{:});
                            % FEVAL switchyard, w/ output
        else
            feval(varargin{:}); 
                            % FEVAL switchyard, w/o output  
        end
    catch MException
        rethrow(MException); 
    end
end
   
function InitializeTASKS

%% CHECK WHETHER LAST PROGRAM IS STILL RUNNING, IF SO, RETURN
if CheckRunning
    return; 
end  

%% CLEAN AND RECREATE THE WORKSPACE
clc;
clear global;
global Xin;

%% INITIALIZATION
Xin.D.Sys.Name =        mfilename;          % Grab the current script's name
SetupD;                                     % Initiate parameters
[idx,tf] = listdlg(	'ListString',       Xin.D.Sys.Configurations.SystemOptionName,...
                	'SelectionMode',    'single',...
                    'ListSize',         [350 80],...
                    'InitialValue',     2,...
                    'Name',             'XINTRINSIC System Configuration',...
                    'PromptString',     'Select a system configuration');
if tf == 0
    idx = 2;    % the Xin 2.0
end
switch Xin.D.Sys.Configurations.CameraDriver{idx}
    case 'PointGrey'
        Xin.D.Sys.PointGreyCam(3).SerialNumber = ...
            Xin.D.Sys.Configurations.CameraSerialNumber{idx};
%     case 'Thorlabs'
    otherwise
        errordlg('Camera Brand Not Supported Yet!')
        clear global;
        return
end     
SetupTDTSys3PA5('Xin');
SetupPointGreyCams;
SetupFigure;                    set( Xin.UI.H0.hFig,	'Visible',  'on');
    CtrlPointGreyCams('InitializeCallbacks', 3);     
    CtrlPointGreyCams('Cam_Shutter',	3, Xin.D.Sys.PointGreyCam(3).Shutter);
  	CtrlPointGreyCams('Cam_Gain',       3, Xin.D.Sys.PointGreyCam(3).Gain); 
    CtrlPointGreyCams('Cam_DispGain',	3, Xin.D.Sys.PointGreyCam(3).DispGainNum);  
                                set( Xin.UI.H0.hFig,	'Visible',  'on');    	
pause(0.5);    
  	CtrlPointGreyCams('Preview_Switch', 3, 'ON');   
hc =   get(Xin.UI.FigPGC(3).CP.hMon_PreviewSwitch_Rocker, 'Children');
for i = 1:3
    set(hc(i), 'Enable',    'inactive');
end
 
%% SETUP GUI CALLBACKS
set(Xin.UI.H0.hFig,                     'CloseRequestFcn',      [Xin.D.Sys.Name, '(''Cam_CleanUp'')']);
set(Xin.UI.H.hSys_LightSource_Toggle1,	'SelectionChangeFcn',   [Xin.D.Sys.Name, '(''GUI_Toggle'')']);
set(Xin.UI.H.hSys_LightSource_Toggle2,	'SelectionChangeFcn',   [Xin.D.Sys.Name, '(''GUI_Toggle'')']);
set(Xin.UI.H.hSys_LightConfig_Rocker,   'SelectionChangeFcn',	[Xin.D.Sys.Name, '(''GUI_Rocker'')']);
set(Xin.UI.H.hSys_LightMonitor_Rocker,  'SelectionChangeFcn',	[Xin.D.Sys.Name, '(''GUI_Rocker'')']);
set(Xin.UI.H.hSys_LightDiffuser_PotenSlider,	'Callback',     [Xin.D.Sys.Name, '(''GUI_Poten'')']);
set(Xin.UI.H.hSys_LightDiffuser_PotenEdit,      'Callback',     [Xin.D.Sys.Name, '(''GUI_Poten'')']);
set(Xin.UI.H.hSys_CameraLensAngle_PotenSlider,	'Callback',     [Xin.D.Sys.Name, '(''GUI_Poten'')']);
set(Xin.UI.H.hSys_CameraLensAngle_PotenEdit,	'Callback',     [Xin.D.Sys.Name, '(''GUI_Poten'')']);
set(Xin.UI.H.hSys_CameraLensAperture_PotenSlider,	'Callback', [Xin.D.Sys.Name, '(''GUI_Poten'')']);
set(Xin.UI.H.hSys_CameraLensAperture_PotenEdit,     'Callback', [Xin.D.Sys.Name, '(''GUI_Poten'')']);
set(Xin.UI.H.hMky_ID_Toggle1,           'SelectionChangeFcn',   [Xin.D.Sys.Name, '(''GUI_Toggle'')']);
set(Xin.UI.H.hMky_ID_Toggle2,           'SelectionChangeFcn',   [Xin.D.Sys.Name, '(''GUI_Toggle'')']);
set(Xin.UI.H.hMky_ID_Toggle3,           'SelectionChangeFcn',   [Xin.D.Sys.Name, '(''GUI_Toggle'')']);
set(Xin.UI.H.hMky_ID_Toggle4,           'SelectionChangeFcn',   [Xin.D.Sys.Name, '(''GUI_Toggle'')']);
set(Xin.UI.H.hMky_Side_Rocker,          'SelectionChangeFcn',   [Xin.D.Sys.Name, '(''GUI_Rocker'')']);
set(Xin.UI.H.hMky_Prep_Rocker,          'SelectionChangeFcn',   [Xin.D.Sys.Name, '(''GUI_Rocker'')']);
set(Xin.UI.H.hExp_Depth_PotenSlider,	'Callback',             [Xin.D.Sys.Name, '(''GUI_Poten'')']);
set(Xin.UI.H.hExp_Depth_PotenEdit,      'Callback',             [Xin.D.Sys.Name, '(''GUI_Poten'')']);
set(Xin.UI.H.hExp_RotationBPA_PotenSlider,	'Callback',         [Xin.D.Sys.Name, '(''GUI_Poten'')']);
set(Xin.UI.H.hExp_RotationBPA_PotenEdit,	'Callback',         [Xin.D.Sys.Name, '(''GUI_Poten'')']);
set(Xin.UI.H.hSes_CycleNumTotal_Edit,	'Callback',             [Xin.D.Sys.Name, '(''GUI_Edit'')']);
set(Xin.UI.H.hSes_AddAtts_Edit,         'Callback',             [Xin.D.Sys.Name, '(''GUI_Edit'')']);
set(Xin.UI.H.hSes_TrlOrder_Rocker,      'SelectionChangeFcn',   [Xin.D.Sys.Name, '(''GUI_Rocker'')']);
set(Xin.UI.H.hSes_Load_Momentary,       'Callback',             [Xin.D.Sys.Name, '(''Ses_Load'')']);
set(Xin.UI.H.hSes_Start_Momentary,      'Callback',             [Xin.D.Sys.Name, '(''Ses_Start'')']);
set(Xin.UI.H.hVol_DisplayMode_Rocker,	'SelectionChangeFcn',   [Xin.D.Sys.Name, '(''GUI_Rocker'')']);
set(Xin.UI.H.hVol_DisplayRef_Rocker,	'SelectionChangeFcn',   [Xin.D.Sys.Name, '(''GUI_Rocker'')']);
set(Xin.UI.H.hMon_AnimalMon_Momentary,  'callback',             [Xin.D.Sys.Name, '(''SetupFigurePointGrey'')']);
set(Xin.UI.H.hMon_Pupillometry_Momentary,'callback',            [Xin.D.Sys.Name, '(''SetupFigurePointGrey'')']);
set(Xin.UI.H.hMon_SyncRec_Rocker,       'SelectionChangeFcn',   [Xin.D.Sys.Name, '(''GUI_Rocker'')']);

GUI_Toggle( 'hSys_LightSource_Toggle',      'Green');
GUI_Rocker( 'hSys_LightConfig_Rocker',      'Koehler + PBS');
GUI_Poten(	'hSys_LightDiffuser_Poten',     Xin.D.Sys.Light.Diffuser);
GUI_Poten(	'hSys_CameraLensAngle_Poten',   Xin.D.Sys.CameraLens.Angle);
GUI_Poten(	'hSys_CameraLensAperture_Poten',Xin.D.Sys.CameraLens.Aperture);
GUI_Toggle( 'hMky_ID_Toggle',               Xin.D.Mky.Lists.ID{1});
GUI_Rocker( 'hMky_Side_Rocker',             Xin.D.Mky.Side);
GUI_Rocker( 'hMky_Prep_Rocker',             Xin.D.Mky.Prep);
GUI_Poten(	'hExp_Depth_Poten',             Xin.D.Exp.Depth);

%% CALLBACK FUNCTIONS
function flag = CheckRunning
    global Xin
    if ~isempty(Xin)
        errordlg('The last program is still running');
        flag = 1;
    else
        flag = 0;
    end
            
function GUI_Edit(varargin)
    global Xin 	
    %% Where the Call is from   
    if nargin == 0      % from GUI 
        tag =   get(gcbo,   'tag');
        s =     get(gcbo,   'string');
           
    else                % from Program
        tag =   varargin{1};
        s =     varargin{2};
    end
    %% Update D and GUI
    switch tag
        case 'hExp_Depth_Edit'
            t = str2double(s);
            if round(t*4) ~= t*4
                errordlg('Depth is not in integer multiples of 1/4 turns');
            else
                Xin.D.Exp.Depth = t;
                set(Xin.UI.H.hExp_Depth_Edit,	'string', sprintf('%5.2f',Xin.D.Exp.Depth));
            end
        case 'hSes_CycleNumTotal_Edit'
            try 
                t = round(str2double(s));
                Xin.D.Ses.Load.CycleNumTotal = t;
            catch
                errordlg('Cycle Number Total input is not valid');
            end
            %% Setup Session Loading
            SetupSesLoad('Xin', 'CycleNumTotal'); 
        case 'hSes_AddAtts_Edit'
            try
                eval(['Xin.D.Ses.Load.AddAtts = [', s, '];']);
                Xin.D.Ses.Load.AddAttString = s;
            catch
                errordlg('Additonal attenuations input is not valid');
            end            
            %% Setup Session Loading
            SetupSesLoad('Xin', 'AddAtts');            
        otherwise
    end
	%% MSG LOG
    msg = [datestr(now, 'yy/mm/dd HH:MM:SS.FFF') '\tGUI_Edit\t' tag ' updated to ' s '\r\n'];
    updateMsg(Xin.D.Exp.hLog, msg);

function GUI_Rocker(varargin)
    global Xin;
  	%% where the call is from      
    if nargin==0
        % called by GUI:            GUI_Rocker
        label =     get(gcbo,'Tag'); 
        val =       get(get(gcbo,'SelectedObject'),'string');
    else
        % called by general update: GUI_Rocker('hSys_LightConfig_Rocker', 'Koehler + PBS')
        label =     varargin{1};
        val =       varargin{2};
    end   
    %% Update GUI
    eval(['h = Xin.UI.H.', label ';'])
    hc = get(h,     'Children');
            js = 0;
    for j = 1:3
        if strcmp( get(hc(j), 'string'), val )
            js = j;  % for later reference 
            set(hc(j),	'backgroundcolor', Xin.UI.C.SelectB);
            set(h,      'SelectedObject',  hc(j));
        else                
            set(hc(j),	'backgroundcolor', Xin.UI.C.TextBG);
        end
    end
    %% Update D & Log
    switch label
        case 'hSys_LightConfig_Rocker'
            Xin.D.Sys.Light.Port =      getappdata(hc(js),  'Port');    
            Xin.D.Sys.Light.HeadCube =	getappdata(hc(js),  'HeadCube');
            hcc = get(Xin.UI.H.hSys_LightMonitor_Rocker,    'children');
            switch Xin.D.Sys.Light.Port
                case 'LtGuide'
                    GUI_Rocker('hSys_LightMonitor_Rocker', 'No Monitor');
                    set(hcc(1), 'Enable',   'inactive');
                    set(hcc(2), 'Enable',   'inactive');
                case 'Koehler'
                    GUI_Rocker('hSys_LightMonitor_Rocker', 'No Monitor');
                    set(hcc(1), 'Enable',   'on');
                    set(hcc(2), 'Enable',   'on');
                otherwise
                    disp('Light port not recognized!')
            end
            msg = [datestr(now, 'yy/mm/dd HH:MM:SS.FFF'), '\tSys_LightConfig\tSetup the light Port & HeadCube as: ', ...
                Xin.D.Sys.Light.Port, ' & ', Xin.D.Sys.Light.HeadCube, '\r\n'];
        case 'hSys_LightMonitor_Rocker'
            Xin.D.Sys.Light.Monitoring =   val(1);
            msg = [datestr(now, 'yy/mm/dd HH:MM:SS.FFF') '\tSys_LightMonitor\tSetup the Light Monitoring Mode as: '...
                Xin.D.Sys.Light.Monitoring '\r\n'];
        case 'hMky_Side_Rocker'
            Xin.D.Mky.Side = val;
            msg = [datestr(now, 'yy/mm/dd HH:MM:SS.FFF') '\tMky_Side\tSetup the Monkey Side as: '...
                Xin.D.Mky.Side '\r\n'];
        case 'hMky_Prep_Rocker'
            Xin.D.Mky.Prep = val;
            msg = [datestr(now, 'yy/mm/dd HH:MM:SS.FFF') '\tMky_Prep\tSetup the Monkey Prep as: '...
                Xin.D.Mky.Prep '\r\n'];
        case 'hSes_TrlOrder_Rocker'
            Xin.D.Ses.Load.TrlOrder = val;
            msg = [datestr(now, 'yy/mm/dd HH:MM:SS.FFF') '\tSes_TrlOrder\tSession trial order selected as: '...
                Xin.D.Ses.Load.TrlOrder '\r\n']; 
            % Setup Session Loading
            SetupSesLoad('Xin', 'TrlOrder');
        case 'hVol_DisplayMode_Rocker'
            switch js
                case 1          % Draw ROI
                    axes(Xin.UI.H0.hAxesImage);
                    Xin.D.Sys.PointGreyCam(3).ROI =     roipoly;    
                    Xin.D.Sys.PointGreyCam(3).ROIi =    uint8(Xin.D.Sys.PointGreyCam(3).ROI);
                    set(hc(2), 'Enable', 'on'); 
                    GUI_Rocker('hVol_DisplayMode_Rocker', 'ROI');
                    msg = [datestr(now, 'yy/mm/dd HH:MM:SS.FFF') '\tExp_SurROI\tExperiment surface ROI circled\r\n'];
                case 2          % Disp ROI
                    Xin.D.Sys.PointGreyCam(3).PreviewClipROI = 1;
                    msg = [datestr(now, 'yy/mm/dd HH:MM:SS.FFF') '\tVol_DisplayMode\tDispClipROI was selected as"' ...
                        num2str(Xin.D.Sys.PointGreyCam(3).PreviewClipROI) '"\r\n'];
                case 3          % Disp Full
                    Xin.D.Sys.PointGreyCam(3).PreviewClipROI = 0;
                    msg = [datestr(now, 'yy/mm/dd HH:MM:SS.FFF') '\tVol_DisplayMode\tDispClipROI was selected as"' ...
                        num2str(Xin.D.Sys.PointGreyCam(3).PreviewClipROI) '"\r\n'];
                otherwise
            end 
        case 'hVol_DisplayRef_Rocker'
            switch js
                case 1          % Load      
                    [Xin.D.Ses.DisplayRefImageFile, Xin.D.Ses.DisplayRefImageDir, FilterIndex] = ...
                        uigetfile('.tif','Select a display reference ''TIF'' File',...
                        [Xin.D.Sys.SoundDir, 'test.wav']);
                    RawRefImage = imread([Xin.D.Ses.DisplayRefImageDir Xin.D.Ses.DisplayRefImageFile]);
                  	Xin.D.Sys.PointGreyCam(3).DisplayRefImage = ...
                        uint8(255/65535*imresize(RawRefImage, size( Xin.D.Sys.PointGreyCam(3).DispImg)));    
                    msg = [datestr(now, 'yy/mm/dd HH:MM:SS.FFF') '\tVol_DisplayMode\tDisplay Ref Image loaded\r\n'];
                    GUI_Rocker('hVol_DisplayRef_Rocker', 'Ref');
                case 2          % Disp Ref                         
                    Xin.D.Sys.PointGreyCam(3).PreviewRef = 1;
                    msg = [datestr(now, 'yy/mm/dd HH:MM:SS.FFF') '\tVol_DisplayMode\tDisplay Ref Image displaying\r\n'];
                case 3          % Disp Raw                     
                    Xin.D.Sys.PointGreyCam(3).PreviewRef = 0;
                    msg = [datestr(now, 'yy/mm/dd HH:MM:SS.FFF') '\tVol_DisplayRef\tDo not display a Preview Ref\r\n'];
                otherwise
            end 
        case 'hMon_SyncRec_Rocker'
            switch val
                case 'No'
                	Xin.D.Ses.MonitoringCams =  0;
                case 'Pupil'
                    if      ~isfield(Xin.UI.FigPGC(1), 'hFig'); SetupFigurePointGrey(1);
                    elseif   isempty(Xin.UI.FigPGC(1).hFig);    SetupFigurePointGrey(1);
                    elseif  ~isvalid(Xin.UI.FigPGC(1).hFig);    SetupFigurePointGrey(1);
                    end 
                    warndlg([   'This will allow the following recording sessions to record ',...
                                'Pupillometry camera synchronized with the ',...
                                'main camera as well']);
                 	Xin.D.Ses.MonitoringCams =  1;
                case 'Both'   
                    if      ~isfield(Xin.UI.FigPGC(1), 'hFig'); SetupFigurePointGrey(1);
                    elseif   isempty(Xin.UI.FigPGC(1).hFig);    SetupFigurePointGrey(1);
                    elseif  ~isvalid(Xin.UI.FigPGC(1).hFig);    SetupFigurePointGrey(1);
                    end 
                    if      ~isfield(Xin.UI.FigPGC(2), 'hFig'); SetupFigurePointGrey(2);
                    elseif   isempty(Xin.UI.FigPGC(2).hFig);    SetupFigurePointGrey(2);
                    elseif  ~isvalid(Xin.UI.FigPGC(2).hFig);    SetupFigurePointGrey(2);
                    end              
                    warndlg([   'This will allow the following recording sessions to record both ',...
                                'Animal Monitoring & Pupillometry cameras synchronized with the ',...
                                'main camera as well']);
                	Xin.D.Ses.MonitoringCams =  2;
            end
            msg = [datestr(now, 'yy/mm/dd HH:MM:SS.FFF') '\tSes_MonitoringCams\tSession monitoring cams recording selected as: '...
                val '\r\n']; 
        otherwise
            errordlg('Rocker tag unrecognizable!');
    end
    updateMsg(Xin.D.Exp.hLog, msg);
    
function GUI_Toggle(varargin)
    global Xin;
  	%% where the call is from      
    if nargin==0
        % called by GUI:            GUI_Toggle
        label =     get(gcbo,'Tag'); 
        val =       get(get(gcbo,'SelectedObject'),'string');
    else
        % called by general update: GUI_Toggle('hSys_LightSource_Toggle', 'Blue')
        label =     [varargin{1} '0'];
        val =       varargin{2};
    end    
    %% Update GUI
    switch label(1:end-1)
        case 'hSys_LightSource_Toggle'; Ttotal = 2;
        case 'hMky_ID_Toggle';          Ttotal = 4;
        otherwise
             disp(['GUI_Toggle tag: ', label(1:end-5), 'not recognized!']);
    end
    for i = 1:Ttotal
        eval([ 'h{', num2str(i), '} = Xin.UI.H.', label(1:end-1), num2str(i), ';'])  
        hc{i}.h =   get(h{i}, 'Children');
    end
    is = 0;     js = 0;
  	for i = 1:Ttotal
        for j = 1:3
            if strcmp( get(hc{i}.h(j), 'string'), val )
                is = i; js = j;
                set(h{i},   'SelectedObject', hc{i}.h(j) );
                set(h{Ttotal+1-i}, 'SelectedObject', '');
                set(hc{i}.h(j),	'backgroundcolor', Xin.UI.C.SelectB);
            else                
                set(hc{i}.h(j),	'backgroundcolor', Xin.UI.C.TextBG);
            end
        end
    end
	%% Update D & Log
    switch label(1:end-1)
        case 'hSys_LightSource_Toggle'                
            Xin.D.Sys.Light.Source =        val;
            Xin.D.Sys.Light.Wavelength =    get(hc{is}.h(js), 'UserData');
            msg = [datestr(now, 'yy/mm/dd HH:MM:SS.FFF') '\tSys_LightSource\tSetup the light source as: '...
                Xin.D.Sys.Light.Source, sprintf(' @ %dnm', Xin.D.Sys.Light.Wavelength) '\r\n'];
        case 'hMky_ID_Toggle'
            Xin.D.Mky.ID = val;
            Xin.D.Exp.DataDir =     [   Xin.D.Sys.DataDir,...
                                        Xin.D.Mky.ID, '-',...
                                        Xin.D.Exp.DateStr, '\'];  
            msg = [datestr(now, 'yy/mm/dd HH:MM:SS.FFF') '\tMky_ID\tSetup the Monkey ID as: '...
                Xin.D.Mky.ID '\r\n']; 
        otherwise
             disp('GUI_Toggle tag not recognized!');
    end
    updateMsg(Xin.D.Exp.hLog, msg);
      
function GUI_Poten(varargin)
    global Xin;
  	%% where the call is from      
    if nargin==0
        % called by GUI:            GUI_Poten   
        label =         get(gcbo,   'Tag');    
        [~, label] =    strtok(reverse(label), '_');
        label =         reverse(label(2:end));
        uictrlstyle =   get(gcbo,   'Style');
        switch uictrlstyle
            case 'slider'
                value = get(gcbo,   'Value');
            case 'edit'
                value = str2double(get(gcbo,'string'));
            otherwise
                errordlg('What''s the hell is this?');
                return;
        end
    else
        % called by general update: GUI_Poten('hSys_LightDiffuser_Poten', 20)
        label =         varargin{1};
        [~, label] =    strtok(reverse(label), '_');
        label =         reverse(label(2:end));
        value =         varargin{2};
    end 
    %% Update D & Log & GUI
    eval(['hEdit = Xin.UI.H.',  label,'_PotenEdit;']);
    eval(['hSlider = Xin.UI.H.',label,'_PotenSlider;']);
	switch label
        case 'hSys_LightDiffuser'
            [~, i] = min(abs(Xin.D.Sys.Light.Diffusers - value));
            Xin.D.Sys.Light.Diffuser = Xin.D.Sys.Light.Diffusers(i);
            value = Xin.D.Sys.Light.Diffuser;
            set(hEdit,      'string',   sprintf('%dº',value));            
            msg = [datestr(now, 'yy/mm/dd HH:MM:SS.FFF') '\tSys_LightDiffuser\tupdated as: '...
                num2str(Xin.D.Sys.Light.Diffuser) ' degrees \r\n'];        
        case 'hSys_CameraLensAngle'
            value = round(value);
            if value>=0 || value<=360
                Xin.D.Sys.CameraLens.Angle = value;
            else
                value = Xin.D.Sys.CameraLens.Angle;
            end
            set(hEdit,      'string',   sprintf('%dº',value));            
            msg = [datestr(now, 'yy/mm/dd HH:MM:SS.FFF') '\tSys_CameraLensAngle\tupdated as: '...
                num2str(Xin.D.Sys.CameraLens.Angle) '\r\n'];
        case 'hSys_CameraLensAperture'
            if value < Xin.D.Sys.CameraLens.Apertures(1)	% value is from GUI, not commend
                value = 10^value;
            end
            [~, i] = min(abs(Xin.D.Sys.CameraLens.Apertures - value));
            Xin.D.Sys.CameraLens.Aperture = Xin.D.Sys.CameraLens.Apertures(i);
            value = log10(Xin.D.Sys.CameraLens.Aperture);
            set(hEdit,      'string',   sprintf('f/%.2g', Xin.D.Sys.CameraLens.Aperture));            
            msg = [datestr(now, 'yy/mm/dd HH:MM:SS.FFF') '\tSys_CameraLensAperture\tupdated as: f/'...
                num2str(Xin.D.Sys.CameraLens.Aperture) ' \r\n'];  
        case 'hExp_Depth'            
            [~, i] = min(abs(Xin.D.Exp.Depths - value));
            Xin.D.Exp.Depth = Xin.D.Exp.Depths(i);
            value = Xin.D.Exp.Depth;
            set(hEdit,      'string',   sprintf('%d turn',value));            
            msg = [datestr(now, 'yy/mm/dd HH:MM:SS.FFF') '\tExp_Depth\tupdated as: '...
                num2str(Xin.D.Exp.Depth) ' LT1 turns \r\n'];     
        case 'hExp_RotationBPA'        
            [~, i] = min(abs(Xin.D.Exp.RotationBPAs - value));
            Xin.D.Exp.RotationBPA = Xin.D.Exp.RotationBPAs(i);
            value = Xin.D.Exp.RotationBPA;
            set(hEdit,      'string',   sprintf('%3.1fº',value));            
            msg = [datestr(now, 'yy/mm/dd HH:MM:SS.FFF') '\tExp_RotationBPA\tupdated as: '...
                num2str(Xin.D.Exp.RotationBPA) ' º \r\n'];      
        otherwise
             disp('GUI_Poten tag not recognized!');            
	end
            set(hSlider,    'value',    value);
    updateMsg(Xin.D.Exp.hLog, msg);
    
function Ses_Load(varargin)
    global Xin;
    
  	%% where the call is from     
    if nargin==0
        % called by GUI:      
        [Xin.D.Ses.Load.SoundFile, Xin.D.Ses.Load.SoundDir, FilterIndex] = ...
            uigetfile('.wav','Select a Sound File',...
            [Xin.D.Sys.SoundDir, 'test.wav']);
        if FilterIndex == 0
            return
        end
    else
        % called by general update: Ses_Load('D:\Sound.wav')
        filestr = varargin{1};
        [filepath,name,ext] = fileparts(filestr);
        Xin.D.Ses.Load.SoundDir =        filepath;
        Xin.D.Ses.Load.SoundFile =       [name ext];
    end
    
    %% Setup Session Loading
    SetupSesLoad('Xin', 'Sound');
        
    %% XINTRINSIC Specific Updates    
    Xin.D.Sys.FigureTitle =                 [   Xin.D.Sys.FullName ...
                                                Xin.D.Ses.Load.SoundFigureTitle];
    set(Xin.UI.H0.hFig,                     'Name',     Xin.D.Sys.FigureTitle);
    set(Xin.UI.H.hSes_Start_Momentary,      'Enable',	'on');  % Enable start
    if strcmp(Xin.D.Ses.Load.TrlOrder, 'Pre-arranged')
        GUI_Rocker('hSes_TrlOrder_Rocker',	'Pre-arranged');        
    elseif 	Xin.D.Trl.Load.SoundNumTotal == 1
        GUI_Rocker('hSes_TrlOrder_Rocker',	'Sequential');
    elseif  Xin.D.Trl.Load.SoundNumTotal >1
        GUI_Rocker('hSes_TrlOrder_Rocker',	'Randomized');
    end
       
    %% LOG MSG
    msg = [datestr(now, 'yy/mm/dd HH:MM:SS.FFF') '\tSes_Load\tSession sound loaded as from file: "' ...
        Xin.D.Ses.Load.SoundFile '"\r\n'];
    updateMsg(Xin.D.Exp.hLog, msg);
    
function Ses_Start
    global Xin
    %% Check if this starts or cancels the recording session
    if Xin.D.Ses.Status == 1            % Session is running right now,
                                        % about to be cancelled
        choice = questdlg('Session cancelling?',...
            'Do you really want to CANCELL the current recording session?',...
            'Yes, really want to cancel', 'No, clicked by error',...
            'No, clicked by error');
        switch choice
            case 'No, clicked by error'
                disp('session continues');
            case 'Yes, really want to cancel'
                Xin.D.Ses.Status =	-1; % Session status switched to cancelling
                disp('session about to be cancelled');
        end           
        return;                         % Return and leave the cancelling procedures 
                                        % to the recording thread
    end                                 % Otherwise proceed to start recording
    %% Check Surface Image
    tag =   0;
    try
        ds =    dir(Xin.D.Exp.DataDir);
        for i=3:length(ds)
            if strcmp(ds(i).name(end-3:end), '.tif');   tag = 1;    end
        end
    catch
    end
    if tag==0
        errordlg({  'No surface image has been taken yet.',...
                    'Take one before starting a session.'    });
        return;
    end
    %% Update Xin.D.Sys.NI & Power Meter
        Xin.D.Sys.NIDAQ.Task_AO_Xin.time.sampsPerChanToAcquire = ...
                                    length( Xin.D.Ses.Load.SoundWave)*...
                                    Xin.D.Ses.Load.AddAttNumTotal*...
                                    Xin.D.Ses.Load.CycleNumTotal; 
    % Xin.D.Sys.NIDAQ.Task_AO_Xin.everyN.everyNSamples = ...
    %                                 round(Xin.D.Sys.Sound.SR*Xin.D.Trl.Load.DurTotal);  
    if strcmp(Xin.D.Ses.Load.TrlOrder, 'Pre-arranged')     
        Xin.D.Sys.NIDAQ.Task_AO_Xin.write.writeData = Xin.D.Ses.Load.SoundWave;
    else
        Xin.D.Sys.NIDAQ.Task_AO_Xin.write.writeData =...
                                    reshape(Xin.D.Ses.Load.SoundMat(:,Xin.D.Ses.Load.TrlOrderSoundVec),[],1);
    end
        Xin.D.Ses.DataFileSize =	Xin.D.Vol.ImageHeight/Xin.D.Vol.VideoBin *...
                                    Xin.D.Vol.ImageWidth/Xin.D.Vol.VideoBin *...
                                    Xin.D.Ses.FrameTotal*2/10^9;
    if          Xin.D.Sys.Light.Monitoring == 'N'
            Xin.D.Vol.FramePowerSampleNum =             NaN;
            Xin.D.Ses.Save.SesPowerMeter =              [];  
                                        % TB changed
    else
        if      Xin.D.Sys.Light.Monitoring == 'S'  
            Xin.D.Sys.PowerMeter{1}.INPutFILTering =    1;  % 15Hz :1, 100kHz :0
            Xin.D.Sys.PowerMeter{1}.AVERageCOUNt =      round(...
                        (1/Xin.D.Sys.PointGreyCam(3).RecUpdateRate/2)/0.0003); 
                                                            % average Counts (1~=.3ms)
            Xin.D.Sys.PowerMeter{1}.InitialMEAsurement= 1;  % send the initial messurement request
            Xin.D.Ses.Save.SesPowerMeter =              zeros(	Xin.D.Ses.UpdateNumTotal,...
                                                                Xin.D.Sys.PointGreyCam(3).RecFrameBlockNum);
            Xin.D.Vol.FramePowerSampleNum =             NaN;      
        elseif	Xin.D.Sys.Light.Monitoring == 'F'
            Xin.D.Sys.PowerMeter{1}.INPutFILTering =    0;  % 15Hz :1, 100kHz :0
            Xin.D.Sys.PowerMeter{1}.AVERageCOUNt =      1;  % average Counts (1~=.3ms)
            Xin.D.Vol.FramePowerSampleNum =             round(...
                        Xin.D.Sys.PointGreyCam(3).Shutter/1000*...
                        Xin.D.Sys.NIDAQ.Task_AI_Xin.time.rate); 
            Xin.D.Ses.Save.SesPowerMeter =              zeros(	Xin.D.Ses.FrameTotal,...
                                                                Xin.D.Vol.FramePowerSampleNum);
        else
            errordlg('Light monitoring mode not recognizable');
        end
            Xin.D.Sys.PowerMeter{1}.WAVelength =        Xin.D.Sys.Light.Wavelength;
            SetupThorlabsPowerMeters('Xin');
    end
	%% Questdlg the information
    disp('Trial Order:');
    disp(Xin.D.Ses.Load.TrlOrderMat);
  	videoinfo = {...
        ['System Light Source: ',           Xin.D.Sys.Light.Source,                             '; '],...
        ['System Light Wavelength: ',       num2str(Xin.D.Sys.Light.Wavelength),                'nm; '],...
     	['System Light Port: ',             Xin.D.Sys.Light.Port,                               '; '],...
        ['System Light Monitoring: ',       Xin.D.Sys.Light.Monitoring,                         '; '],...
        ['System Light Diffuser: ',         num2str(Xin.D.Sys.Light.Diffuser),                  'º; '],...
     	['System Light Head Cube: ',        Xin.D.Sys.Light.HeadCube,                           '; '],...
        ['System Camera Lens Angle: ',      num2str(Xin.D.Sys.CameraLens.Angle),                'º; '],...
        ['System Camera Lens Aperture: ',   sprintf('f/%.2g',Xin.D.Sys.CameraLens.Aperture),	'; '],...
        ['System Cam DispGainNum: ',        num2str(Xin.D.Sys.PointGreyCam(3).DispGainNum),	' (frames); '],...
        ['System Cam Shutter: ',            sprintf('%5.2f',Xin.D.Sys.PointGreyCam(3).Shutter),	' (ms); '],...
        ['System Cam Gain: ',               sprintf('%5.2f',Xin.D.Sys.PointGreyCam(3).Gain),	' (dB); '],...
    	['Monkey ID: ',                     Xin.D.Mky.ID,                                       '; '],...
     	['Monkey Side: ',                   Xin.D.Mky.Side,                                     '; '],...
        ['Monkey Prep: ',                   Xin.D.Mky.Prep,                                     '; '],...
     	['Experiment Date: ',               Xin.D.Exp.DateStr,                                  '; '],...
        ['Experiment Depth: ',              sprintf('%d',Xin.D.Exp.Depth),      ' (LT1 fine turn); '],...
        ['Session Sound File: ',            Xin.D.Ses.Load.SoundFile,                           '; '],...
        ['Session Sound Dir: ',             Xin.D.Ses.Load.SoundDir,                            '; '],...
        ['Session Sound Title: ',           Xin.D.Ses.Load.SoundTitle,                          '; '],...
        ['Session Sound Artist: ',          Xin.D.Ses.Load.SoundArtist,                         '; '],...
        ['Session Cycle Duration: ',        sprintf('%5.1f',Xin.D.Ses.Load.CycleDurTotal),	' (s); '],...
        ['Session Cycle Number Total: ',    sprintf('%d',   Xin.D.Ses.Load.CycleNumTotal),	'; '],...
        ['Session Duration Total: ',        sprintf('%5.1f',Xin.D.Ses.Load.DurTotal),       ' (s); '],...
        ['Session Data File Size: ',        sprintf('%5.2f',Xin.D.Ses.DataFileSize),        ' (GB); '],...
        ['Trial Number per Sound: ',        sprintf('%d',   Xin.D.Trl.Load.NumTotal),       '; '],...
        ['Trial Duration: ',                sprintf('%5.2f',Xin.D.Trl.Load.DurTotal),       ' (s); '],...
        ['Trial Duration PreStim: ',        sprintf('%5.2f',Xin.D.Trl.Load.DurPreStim),     ' (s); '],...
        ['Trial Duration Stim: ',           sprintf('%5.2f',Xin.D.Trl.Load.DurStim),        ' (s); '],...
        ['Trial Duration PostStim: ',       sprintf('%5.2f',Xin.D.Trl.Load.DurPostStim),    ' (s); ']...
        };
    promptinfo = [...
        videoinfo,...
        {''},...
        {'Are these settings correct?'}];
    choice = questdlg(promptinfo,...
        'Recording conditions:',...
        'No, Cancel and Reset', 'Yes, Take a Recording',...
        'No, Cancel and Reset');
   	switch choice
        case 'No, Cancel and Reset';    return;
        case 'Yes, Take a Recording'     
    end  
    
    %% Setup Recording File & Memory Allocation
    datanamet =    datestr(now, 30);
    dataname =     [datanamet(3:end),  '_',...
        Xin.D.Sys.Light.Source,  '_',...
        Xin.D.Sys.Light.Port,    '_',...
        Xin.D.Sys.Light.HeadCube];   
    Xin.D.Ses.DataFile =   [dataname '.rec'];
    hFile =                 fopen([Xin.D.Exp.DataDir, Xin.D.Ses.DataFile],'w');   
    
	Xin.D.Ses.Save.SysLightSource =     Xin.D.Sys.Light.Source;   
	Xin.D.Ses.Save.SysLightWavelength = Xin.D.Sys.Light.Wavelength;
	Xin.D.Ses.Save.SysLightPort =       Xin.D.Sys.Light.Port;
    Xin.D.Ses.Save.SysLight.Monitoring= Xin.D.Sys.Light.Monitoring;
	Xin.D.Ses.Save.SysLightDiffuser =	Xin.D.Sys.Light.Diffuser;
	Xin.D.Ses.Save.SysLightHeadCube =	Xin.D.Sys.Light.HeadCube;
    Xin.D.Ses.Save.SysCameraLensAngle = Xin.D.Sys.CameraLens.Angle;
    Xin.D.Ses.Save.SysCameraLensAperture = ...
                                        Xin.D.Sys.CameraLens.Aperture;
	Xin.D.Ses.Save.SysCamShutter =      Xin.D.Sys.PointGreyCam(3).Shutter;
	Xin.D.Ses.Save.SysCamGain =         Xin.D.Sys.PointGreyCam(3).Gain;
	Xin.D.Ses.Save.SysCamDispGainNum =  Xin.D.Sys.PointGreyCam(3).DispGainNum;
  	Xin.D.Ses.Save.MkyID =              Xin.D.Mky.ID;
    Xin.D.Ses.Save.MkySide =            Xin.D.Mky.Side;
    Xin.D.Ses.Save.MkyPrep =            Xin.D.Mky.Prep;
    Xin.D.Ses.Save.ExpDateStr =         Xin.D.Exp.DateStr;
    Xin.D.Ses.Save.ExpDepth =           Xin.D.Exp.Depth;
    Xin.D.Ses.Save.SesSoundFile =       Xin.D.Ses.Load.SoundFile;
    Xin.D.Ses.Save.SesSoundDir =        Xin.D.Ses.Load.SoundDir;    
    Xin.D.Ses.Save.SesSoundTitle =      Xin.D.Ses.Load.SoundTitle;
    Xin.D.Ses.Save.SesSoundArtist =     Xin.D.Ses.Load.SoundArtist; 
    Xin.D.Ses.Save.SesSoundComment =	Xin.D.Ses.Load.SoundComment;  
    Xin.D.Ses.Save.SesSoundWave =       Xin.D.Ses.Load.SoundWave;  
    Xin.D.Ses.Save.SesSoundDurTotal =   Xin.D.Ses.Load.SoundDurTotal; 
    Xin.D.Ses.Save.AddAtts =            Xin.D.Ses.Load.AddAtts; 
    Xin.D.Ses.Save.AddAttNumTotal =     Xin.D.Ses.Load.AddAttNumTotal; 
    Xin.D.Ses.Save.SesCycleDurTotal =   Xin.D.Ses.Load.CycleDurTotal;
    Xin.D.Ses.Save.SesCycleNumTotal =	Xin.D.Ses.Load.CycleNumTotal; 
    Xin.D.Ses.Save.SesDurTotal =        Xin.D.Ses.Load.DurTotal;
    Xin.D.Ses.Save.SesFrameTotal =      Xin.D.Ses.FrameTotal;
    Xin.D.Ses.Save.SesFrameNum =        zeros(      Xin.D.Ses.FrameTotal,    1);
    Xin.D.Ses.Save.SesTimestamps =      char(zeros( Xin.D.Ses.FrameTotal,    21));
    % Xin.D.Ses.Save.SesPowerMeter is setup above 
    Xin.D.Ses.Save.TrlIndexSoundNum =   Xin.D.Ses.Load.TrlIndexSoundNum;
    Xin.D.Ses.Save.TrlIndexAddAttNum =  Xin.D.Ses.Load.TrlIndexAddAttNum;    
    Xin.D.Ses.Save.SesTrlOrder =        Xin.D.Ses.Load.TrlOrder;
    Xin.D.Ses.Save.SesTrlOrderMat =     Xin.D.Ses.Load.TrlOrderMat;
    Xin.D.Ses.Save.SesTrlOrderVec =     Xin.D.Ses.Load.TrlOrderVec;
    Xin.D.Ses.Save.SesTrlOrderSoundVec =Xin.D.Ses.Load.TrlOrderSoundVec;
    Xin.D.Ses.Save.TrlNumTotal =        Xin.D.Trl.Load.NumTotal;
    Xin.D.Ses.Save.TrlDurTotal =        Xin.D.Trl.Load.DurTotal;
    Xin.D.Ses.Save.TrlDurPreStim =      Xin.D.Trl.Load.DurPreStim;
    Xin.D.Ses.Save.TrlDurStim =         Xin.D.Trl.Load.DurStim;
    Xin.D.Ses.Save.TrlDurPostStim =     Xin.D.Trl.Load.DurPostStim;
    Xin.D.Ses.Save.TrlNames =           Xin.D.Trl.Load.Names;
    Xin.D.Ses.Save.TrlAttenuations =	Xin.D.Trl.Load.Attenuations;  
    
    %% GUI Update & Lock, then do the Session Initiation Function     
    Xin.D.Ses.Load.SoundFigureTitle =   [   ': now playing "' ...
                                            Xin.D.Ses.Load.SoundFile '"'];    
    Xin.D.Sys.FigureTitle =             [   Xin.D.Sys.FullName ...
                                            Xin.D.Ses.Load.SoundFigureTitle];
    set(Xin.UI.H0.hFig, 'Name', Xin.D.Sys.FigureTitle);
    EnableGUI('inactive');    
    msg =   [datestr(now, 'yy/mm/dd HH:MM:SS.FFF') '\tSesStart\tSession is about to start with the sound: "' ...
        Xin.D.Ses.Load.SoundFile '"\r\n'];
    updateMsg(Xin.D.Exp.hLog, msg);
    msg =   [datestr(now, 'yy/mm/dd HH:MM:SS.FFF') '\tSesStart\tTDT PA5 set up\r\n'];
    updateMsg(Xin.D.Exp.hLog, msg);
    %% Camera Trigger Settings & Start the Video Recording   
    if Xin.D.Ses.MonitoringCams
        for i = 1:Xin.D.Ses.MonitoringCams
%             hVWC{i} = VideoWriter([Xin.D.Exp.DataDir, datanamet(3:end),'_#',...
%                 Xin.D.Sys.PointGreyCam(i).Comments,'.mj2'], 'Archival');
%             hVWC{i}.FrameRate =             Xin.D.Sys.PointGreyCam(i).FrameRate;
%             hVWC{i}.LosslessCompression =   true;
%             hVWC{i}.MJ2BitDepth =           8;
            hVWC{i} = VideoWriter([Xin.D.Exp.DataDir, datanamet(3:end),'_#',...
                Xin.D.Sys.PointGreyCam(i).Comments,'.avi'], 'Grayscale AVI');
            hVWC{i}.FrameRate =             Xin.D.Sys.PointGreyCam(i).FrameRate;
                Xin.HW.PointGrey.Cam(i).hVid.LoggingMode =	'disk';            
                Xin.HW.PointGrey.Cam(i).hVid.DiskLogger =	hVWC{i};
                Xin.HW.PointGrey.Cam(i).hVid.TriggerRepeat = ...
                    Xin.D.Ses.Load.DurTotal*Xin.D.Sys.PointGreyCam(i).FrameRate - 1;
            CtrlPointGreyCams('Trigger_Mode', i, 'HardwareRec'); 
            start(Xin.HW.PointGrey.Cam(i).hVid);  
        end
    end
    CtrlPointGreyCams('Trigger_Mode', 3, 'HardwareRec'); 
	Xin.HW.PointGrey.Cam(3).hVid.TriggerRepeat = Xin.D.Ses.FrameTotal - 1;
	start(          Xin.HW.PointGrey.Cam(3).hVid);
    msg =   [datestr(now, 'yy/mm/dd HH:MM:SS.FFF') '\tSesStart\tPointGrey set up\r\n'];
    updateMsg(Xin.D.Exp.hLog, msg);
    %% Initialize Ses timing related stuff
    Xin.D.Ses.UpdateNumCurrent   = -1;  
    Xin.D.Ses.UpdateNumCurrentAI = 0;  
    updateTrial;    % this also updates the PA5     
    %% NI Start
    StartNIDAQ;     
                Xin.D.Ses.Status =	1;  % Session status switched to started
    %% Capturing Video
    while(1)
        %% Wait until at least a full block (assume 16) of frames is available
        while(1)
            Xin.D.Ses.FrameAvailable =  Xin.HW.PointGrey.Cam(3).hVid.FramesAvailable;
            if Xin.D.Ses.FrameAvailable >= Xin.D.Vol.UpdFrameNum; break; end
        	pause(0.01);
        end
        %% Update Trial
        updateTrial;
        %% Update PowerMeter Readings
        if Xin.D.Sys.Light.Monitoring == 'S'
            Xin.D.Ses.Save.SesPowerMeter(Xin.D.Ses.UpdateNumCurrent,:) = ...
            	str2double(Xin.HW.Thorlabs.PM100{1}.h.fscanf)*...
                ones(1,Xin.D.Sys.PointGreyCam(3).RecFrameBlockNum);
            fprintf(Xin.HW.Thorlabs.PM100{1}.h,  'MEAS:POW?'); 
        end        
        %% Read a block (assume 16) of frames
        [   Xin.D.Vol.UpdFrameBlockRaw, ~,...
            Xin.D.Vol.UpdMetadataBlockRaw] = ...
            getdata(Xin.HW.PointGrey.Cam(3).hVid, Xin.D.Vol.UpdFrameNum,...
                    'uint16', 'numeric');       
        %% (4x4 Binning Pixels) & Save the Data
    	Xin.D.Vol.UpdFrameBlockS1 = reshape(Xin.D.Vol.UpdFrameBlockRaw,...
            Xin.D.Vol.VideoBin,     Xin.D.Vol.ImageHeight/Xin.D.Vol.VideoBin,...
            Xin.D.Vol.VideoBin,     Xin.D.Vol.ImageWidth/Xin.D.Vol.VideoBin,...
            Xin.D.Vol.UpdFrameNum); 
        Xin.D.Vol.UpdFrameBlockS2 = sum(Xin.D.Vol.UpdFrameBlockS1, 1, 'native');  
        Xin.D.Vol.UpdFrameBlockS3 = sum(Xin.D.Vol.UpdFrameBlockS2, 3, 'native');
        Xin.D.Vol.UpdFrameBlockS4 = squeeze(Xin.D.Vol.UpdFrameBlockS3);
        fwrite(hFile, Xin.D.Vol.UpdFrameBlockS4, 'uint16');
        % Metadata: AbsTime, FrameNumber, RelativeFrame, TriggerIndex
        Xin.D.Vol.UpdMetadataBlockS1 = struct2cell(Xin.D.Vol.UpdMetadataBlockRaw);
        Xin.D.Vol.UpdMetadataBlockS2 = cell2mat(Xin.D.Vol.UpdMetadataBlockS1(1,:)');
        Xin.D.Vol.UpdMetadataBlockS3 = cell2mat(Xin.D.Vol.UpdMetadataBlockS1(2,:)');
        Xin.D.Vol.UpdMetadataBlockS4 = datestr(Xin.D.Vol.UpdMetadataBlockS2, 'yy-mm-dd HH:MM:SS.FFF');
        Xin.D.Ses.Save.SesFrameNum(    Xin.D.Vol.UpdMetadataBlockS3,:) = Xin.D.Vol.UpdMetadataBlockS3;
        Xin.D.Ses.Save.SesTimestamps(  Xin.D.Vol.UpdMetadataBlockS3,:) = Xin.D.Vol.UpdMetadataBlockS4;           
        msg =   [datestr(now, 'yy/mm/dd HH:MM:SS.FFF')...
            '\tSesStart\tPointGrey frame block read: '...
            num2str(Xin.D.Vol.UpdMetadataBlockS3(1)) '-',...
            num2str(Xin.D.Vol.UpdMetadataBlockS3(end)) '\r\n'];
        updateMsg(Xin.D.Exp.hLog, msg);
        %% Update the Frame Schedule       
    	Xin.D.Ses.FrameRequested =  Xin.HW.PointGrey.Cam(3).hVid.TriggersExecuted;
       	Xin.D.Ses.FrameAcquired =   Xin.HW.PointGrey.Cam(3).hVid.FramesAcquired;          
     	Xin.D.Ses.FrameAvailable =  Xin.HW.PointGrey.Cam(3).hVid.FramesAvailable;
    	set(Xin.UI.H.hSes_FrameAcquired_Edit,   'string', ...
            sprintf('%d)%d', [Xin.D.Ses.FrameAvailable Xin.D.Ses.FrameAcquired]) );
        %% Stopping or Cancelling
        if  Xin.D.Ses.FrameAcquired == Xin.D.Ses.FrameTotal && ...
            Xin.HW.PointGrey.Cam(3).hVid.FramesAvailable == 0
                                        % if All Frames Are Acquired and
                                        % Read, stopping
                Xin.D.Ses.Status =	0;  % Session status switched to stopped  
                msg =   [datestr(now, 'yy/mm/dd HH:MM:SS.FFF') '\tSesStart\tAll frames recorded. Session about to stop\r\n'];
                updateMsg(Xin.D.Exp.hLog, msg);
                pause(2);
            break;
        elseif  Xin.D.Ses.Status ==	-1  % cancelling flag is raised 
            break;            
        end
    end
    %% NI Stop
    StopNIDAQ;   
    %% GUI Release
    if      Xin.D.Ses.Status ==	0       % stopped 
        %% Final Save
        if Xin.D.Sys.Light.Monitoring == 'S'
            Xin.D.Ses.Save.SesPowerMeter = reshape(...
                                            Xin.D.Ses.Save.SesPowerMeter',...
                                            Xin.D.Ses.FrameTotal,...
                                            1);
        end
        S = Xin.D.Ses.Save;
        save([Xin.D.Exp.DataDir, dataname '.mat'], 'S', '-v7.3');
        msg =   [datestr(now, 'yy/mm/dd HH:MM:SS.FFF') '\tSesStart\tData file saved. Session stopped\r\n']; 
        Xin.D.Ses.Load.SoundFigureTitle =   [   ': now "' ...
                                                Xin.D.Ses.Load.SoundFile '" recording session has ended'];
    elseif	Xin.D.Ses.Status ==	-1      % cancelled
        %% Camera Stop
        stop(          Xin.HW.PointGrey.Cam(3).hVid);
        msg =   [datestr(now, 'yy/mm/dd HH:MM:SS.FFF') '\tSesStart\tSession cancelled\r\n']; 
        Xin.D.Ses.Load.SoundFigureTitle =   [   ': now "' ...
                                                Xin.D.Ses.Load.SoundFile '" recording session cancelled'];
                Xin.D.Ses.Status =	0;  % Session status switched to stopped
    end
    %% Release the camera and the recording file
	fclose(hFile);      
            CtrlPointGreyCams('Trigger_Mode', 3, 'SoftwareGrab');
	if Xin.D.Ses.MonitoringCams
        for i = 1:Xin.D.Ses.MonitoringCams
            stop(Xin.HW.PointGrey.Cam(i).hVid);
            CtrlPointGreyCams('Trigger_Mode', i, 'SoftwareGrab');
                Xin.HW.PointGrey.Cam(i).hVid.LoggingMode =	'memory'; 
        end
	end
    %% MSG & GUI Updates
    updateMsg(Xin.D.Exp.hLog, msg);   
    Xin.D.Sys.FigureTitle =             [   Xin.D.Sys.FullName ...
                                            Xin.D.Ses.Load.SoundFigureTitle];
    set(Xin.UI.H0.hFig, 'Name', Xin.D.Sys.FigureTitle);
	EnableGUI('on'); 
        
function Cam_CleanUp
    global Xin         
    %% Check Surface After Image
    if exist(Xin.D.Exp.DataDir, 'dir')
        dirall1 =               dir(Xin.D.Exp.DataDir);
        dirall2 =               struct2cell(dirall1)';
        dirdatestrall =         cell2mat(dirall2(:,3));
        dirdatenumfiles =       datenum(dirdatestrall(3:end,:));
        [~,lastestfilenum] =	max(dirdatenumfiles);
        lastestfilenum =        lastestfilenum +2;
        lastfilename =          dirall2{lastestfilenum,1};
        if ~strcmp(lastfilename(end-3:end), '.tif')
            errordlg({  'The latest file in the experiment folder is not a surface image file.',...
                        'Take one before finishing an experiment.'    });
            return;
        end 
    end
    %% Closing dlg
    choice = questdlg (...
        'Stop & Clean Up Everything?',...   % Question
        'Clean Up',...                      % Title
        'Yes, Clean Up',...                 % Btn1
        'Do Nothing',...                    % Btn2
        'Yes, Clean Up'...                  % Default
        );
    switch choice
        case 'Yes, Clean Up'
            %% Stop & Delete Thorlabs Power Meters
            try 
                for i =1:length(Xin.D.Sys.PowerMeter)
                    fprintf(    Xin.HW.Thorlabs.PM100{i}.h,'*RST');
                    fclose(     Xin.HW.Thorlabs.PM100{i}.h);
                end
                instrreset;
            catch
%                 warndlg('Can not close Thorlabs Power Meters'); 
%                 % not necessary for Xintrinsic
            end      
            %% Stop & Delete PointGrey Cameras
            try 
                for i =1:length(Xin.D.Sys.PointGreyCam)   
                    stoppreview(Xin.HW.PointGrey.Cam(i).hVid);
                    delete(     Xin.HW.PointGrey.Cam(i).hVid);
                end
                imaqreset;
            catch
                warndlg('Can not clear PointGrey Cameras');
            end 
            %% Stop & Delete NI-DAQ tasks
            try
                if  isfield(Xin.HW, 'NI')
                    TaskNames = fieldnames(Xin.HW.NI.T);
                    for i = 1:length(TaskNames)
                        TaskName = strcat('Xin.HW.NI.T.',TaskNames{i});
                        eval(strcat('try;',TaskName,'.abort(); end;'));
                        eval(strcat('try;',TaskName,'.delete(); end;'));
                    end
                end
            catch
                warndlg('Can not delete NI-DAQ tasks');
            end           
            %% Clean Up Figure and Data
            try
                delete(Xin.UI.H0.hFig);
                if isfield(Xin.UI.FigPGC(1), 'hFig')
                    delete(Xin.UI.FigPGC(1).hFig);
                end
            catch
                warndlg('Can not delete the UI Figure');
            end
            %% MSG LOG and close log file
            try
                msg = [datestr(now, 'yy/mm/dd HH:MM:SS.FFF') '\t' Xin.D.Sys.Name...
                    '\tXINTRINSIC ROCKED and goodbye! \r\n'];
                updateMsg(Xin.D.Exp.hLog, msg);
                fclose(  Xin.D.Exp.hLog);
                if exist(Xin.D.Exp.DataDir, 'dir')   
                    movefile(   [Xin.D.Sys.DataDir, Xin.D.Exp.LogFileName],...
                                [Xin.D.Exp.DataDir, Xin.D.Exp.LogFileName]); 
                end
            catch
                warndlg('Can not write & close log file');
            end
            %% Clear the workspace
            clear all;
        case 'Do Nothing'
        otherwise
    end
  
function EnableGUI(mode)
    global Xin
    a{1} =  get(Xin.UI.H.hSys_LightSource_Toggle1,	'Children');
    a{2} =  get(Xin.UI.H.hSys_LightSource_Toggle2,	'Children');    
    a{3} =  get(Xin.UI.H.hSys_LightConfig_Rocker,	'Children'); 
    a{4} =  get(Xin.UI.H.hSys_LightMonitor_Rocker,	'Children');    
    a{5} =  get(Xin.UI.H.hMky_ID_Toggle1,           'Children');   
    a{6} =  get(Xin.UI.H.hMky_ID_Toggle2,           'Children');
    a{7} =  get(Xin.UI.H.hMky_Side_Rocker,          'Children');
    a{8} =  get(Xin.UI.H.hMky_Prep_Rocker,          'Children');
    a{9} =  get(Xin.UI.H.hSes_TrlOrder_Rocker,      'Children');
    a{10} = get(Xin.UI.H.hMon_SyncRec_Rocker,      'Children');
    
    hArray = [...
        a{1}(1),    a{1}(2),    a{1}(3),...
        a{2}(1),    a{2}(2),    a{2}(3),...
        a{3}(1),    a{3}(2),    a{3}(3),...
        a{4}(1),    a{4}(2),    a{4}(3),...  
        a{5}(1),    a{5}(2),    a{5}(3),...
        a{6}(1),    a{6}(2),    a{6}(3),...    
                    a{7}(2),    a{7}(3),...
                    a{8}(2),    a{8}(3),...
        a{9}(1),    a{9}(2),    a{9}(3),...   
                    a{10}(2),   a{10}(3),... 
        Xin.UI.H.hSys_LightDiffuser_PotenSlider,...
        Xin.UI.H.hSys_LightDiffuser_PotenEdit,...
        Xin.UI.H.hSys_CameraLensAngle_PotenSlider,...
        Xin.UI.H.hSys_CameraLensAngle_PotenEdit,...
        Xin.UI.H.hSys_CameraLensAperture_PotenSlider,...           
        Xin.UI.H.hSys_CamShutter_PotenSlider,...
        Xin.UI.H.hSys_CamShutter_PotenEdit,...
        Xin.UI.H.hSys_CamGain_PotenSlider,...
        Xin.UI.H.hSys_CamGain_PotenEdit,...
        Xin.UI.H.hExp_RefImage_Momentary,...
        Xin.UI.H.hExp_Depth_PotenSlider,...
        Xin.UI.H.hExp_Depth_PotenEdit,...
        Xin.UI.H.hSes_Load_Momentary,...
        Xin.UI.H.hSes_CycleNumTotal_Edit,...
        Xin.UI.H.hSes_AddAtts_Edit];
    set(hArray, 'Enable',   mode);
    if strcmp(Xin.D.Ses.Load.TrlOrder, 'Pre-arranged')
        set(Xin.UI.H.hSes_CycleNumTotal_Edit, 'Enable', 'off');
    end
