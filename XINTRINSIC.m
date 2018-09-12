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
SetupThorlabsPowerMeters;
SetupPointGreyCams;
SetupFigure;                    set( Xin.UI.H0.hFig,	'Visible',  'on');
    CtrlPointGreyCams('InitializeCallbacks', 2);     
    CtrlPointGreyCams('Cam_Shutter',	2, Xin.D.Sys.PointGreyCam(2).Shutter);
  	CtrlPointGreyCams('Cam_Gain',       2, Xin.D.Sys.PointGreyCam(2).Gain); 
    CtrlPointGreyCams('Cam_DispGain',	2, Xin.D.Sys.PointGreyCam(2).DispGainNum);  
                                set( Xin.UI.H0.hFig,	'Visible',  'on');    	
pause(0.5);    
  	CtrlPointGreyCams('Preview_Switch', 2, 'ON');   
hc =   get(Xin.UI.FigPGC(2).CP.hMon_PreviewSwitch_Rocker, 'Children');
for i = 1:3
    set(hc(i), 'Enable',    'inactive');
end
 
%% SETUP GUI CALLBACKS
set(Xin.UI.H0.hFig,	'CloseRequestFcn',      [Xin.D.Sys.Name,'(''Cam_CleanUp'')']);
set(Xin.UI.H.hSys_LightSource_Toggle1,	'SelectionChangeFcn',   [Xin.D.Sys.Name, '(''GUI_Toggle'')']);
set(Xin.UI.H.hSys_LightSource_Toggle2,	'SelectionChangeFcn',   [Xin.D.Sys.Name, '(''GUI_Toggle'')']);
set(Xin.UI.H.hSys_LightPort_Rocker,     'SelectionChangeFcn',   [Xin.D.Sys.Name, '(''GUI_Rocker'')']);
set(Xin.UI.H.hSys_HeadCube_Rocker,      'SelectionChangeFcn',   [Xin.D.Sys.Name, '(''GUI_Rocker'')']);
set(Xin.UI.H.hMky_ID_Toggle1,           'SelectionChangeFcn',   [Xin.D.Sys.Name, '(''GUI_Toggle'')']);
set(Xin.UI.H.hMky_ID_Toggle2,           'SelectionChangeFcn',   [Xin.D.Sys.Name, '(''GUI_Toggle'')']);
set(Xin.UI.H.hMky_Side_Rocker,          'SelectionChangeFcn',   [Xin.D.Sys.Name, '(''GUI_Rocker'')']);
set(Xin.UI.H.hExp_Depth_Edit,           'Callback',             [Xin.D.Sys.Name, '(''GUI_Edit'')']);
set(Xin.UI.H.hSes_Load_Momentary,       'Callback',             [Xin.D.Sys.Name, '(''Ses_Load'')']);
set(Xin.UI.H.hSes_CycleNumTotal_Edit,	'Callback',             [Xin.D.Sys.Name, '(''GUI_Edit'')']);
set(Xin.UI.H.hSes_AddAtts_Edit,         'Callback',             [Xin.D.Sys.Name, '(''GUI_Edit'')']);
set(Xin.UI.H.hSes_TrlOrder_Rocker,      'SelectionChangeFcn',   [Xin.D.Sys.Name, '(''GUI_Rocker'')']);
set(Xin.UI.H.hSes_Start_Momentary,      'Callback',             [Xin.D.Sys.Name, '(''Ses_Start'')']);
set(Xin.UI.H.hVol_DisplayMode_Rocker,	'SelectionChangeFcn',   [Xin.D.Sys.Name, '(''GUI_Rocker'')']);
set(Xin.UI.H.hMon_AnimalMon_Momentary,  'callback',             [Xin.D.Sys.Name, '(''GUI_NewPointGrey'')']);

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
        % called by general update: GUI_Rocker('hSys_LightPort_Rocker', 'Koehler')
        label =     varargin{1};
        val =       varargin{2};
    end   
    %% Update GUI
    eval(['h = Xin.UI.H.', label ';'])
    hc = get(h,     'Children');
    for j = 1:3
        if strcmp( get(hc(j), 'string'), val )
            set(hc(j),	'backgroundcolor', Xin.UI.C.SelectB);
            k = j;
        else                
            set(hc(j),	'backgroundcolor', Xin.UI.C.TextBG);
        end
    end
    %% Update D & Log
    switch label
        case 'hSys_LightPort_Rocker'
            Xin.D.Sys.Light.Port = val;    
            msg = [datestr(now, 'yy/mm/dd HH:MM:SS.FFF') '\tSys_LightPort\tSetup the light port as: '...
                Xin.D.Sys.Light.Port '\r\n'];
        case 'hSys_HeadCube_Rocker'
            Xin.D.Sys.Light.HeadCube = val;
            msg = [datestr(now, 'yy/mm/dd HH:MM:SS.FFF') '\tSys_LightHeadCube\tSetup the light head cube as: '...
                Xin.D.Sys.Light.HeadCube '\r\n'];
        case 'hMky_Side_Rocker'
            Xin.D.Mky.Side = val;
            msg = [datestr(now, 'yy/mm/dd HH:MM:SS.FFF') '\tMky_Side\tSetup the Monkey Side as: '...
                Xin.D.Mky.Side '\r\n'];
        case 'hSes_TrlOrder_Rocker'
            Xin.D.Ses.Load.TrlOrder = val;
            msg = [datestr(now, 'yy/mm/dd HH:MM:SS.FFF') '\tSes_TrlOrder\tSession trial order selected as: '...
                Xin.D.Ses.Load.TrlOrder '\r\n']; 
            % Setup Session Loading
            SetupSesLoad('Xin', 'TrlOrder');
        case 'hVol_DisplayMode_Rocker'
            switch k
                case 1          % Draw ROI
                    axes(Xin.UI.H0.hAxesImage);
                    Xin.D.Sys.PointGreyCam(2).ROI =     roipoly;    
                    Xin.D.Sys.PointGreyCam(2).ROIi =    uint8(Xin.D.Sys.PointGreyCam(2).ROI);
                    set(hc(2), 'Enable', 'on'); 
                    msg = [datestr(now, 'yy/mm/dd HH:MM:SS.FFF') '\tExp_SurROI\tExperiment surface ROI circled\r\n'];
                case 2          % Disp ROI
                    Xin.D.Sys.PointGreyCam(2).PreviewClipROI = 1;
                    msg = [datestr(now, 'yy/mm/dd HH:MM:SS.FFF') '\tVol_DisplayMode\tDispClipROI was selected as"' ...
                        num2str(Xin.D.Sys.PointGreyCam(2).PreviewClipROI) '"\r\n'];
                case 3          % Disp Full
                    Xin.D.Sys.PointGreyCam(2).PreviewClipROI = 0;
                    msg = [datestr(now, 'yy/mm/dd HH:MM:SS.FFF') '\tVol_DisplayMode\tDispClipROI was selected as"' ...
                        num2str(Xin.D.Sys.PointGreyCam(2).PreviewClipROI) '"\r\n'];
                otherwise
            end 
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
        label =     varargin{1};
        val =       varargin{2};
    end    
    %% Update GUI
    eval(['h{1} = Xin.UI.H.', label(1:end-1) '1;'])
    eval(['h{2} = Xin.UI.H.', label(1:end-1) '2;'])   
	hc{1}.h =   get(h{1}, 'Children');
	hc{2}.h =   get(h{2}, 'Children');
  	for i = 1:2
        for j = 1:3
            if strcmp( get(hc{i}.h(j), 'string'), val )
                set(h{i},   'SelectedObject', hc{i}.h(j) );
                set(h{3-i}, 'SelectedObject', '');
                set(hc{i}.h(j),	'backgroundcolor', Xin.UI.C.SelectB);
            else                
                set(hc{i}.h(j),	'backgroundcolor', Xin.UI.C.TextBG);
            end
        end
    end
	%% Update D & Log
    switch label(1:end-1)
        case 'hSys_LightSource_Toggle'                
            Xin.D.Sys.Light.Source = val;
            msg = [datestr(now, 'yy/mm/dd HH:MM:SS.FFF') '\tSys_LightSource\tSetup the light source as: '...
                Xin.D.Sys.Light.Source '\r\n'];
        case 'hMky_ID_Toggle'
            Xin.D.Mky.ID = val;
            msg = [datestr(now, 'yy/mm/dd HH:MM:SS.FFF') '\tMky_ID\tSetup the Monkey ID as: '...
                Xin.D.Mky.ID '\r\n']; 
        otherwise
    end
    updateMsg(Xin.D.Exp.hLog, msg);
    
function GUI_NewPointGrey(varargin)  
    %% Where the call is from
    global Xin
    if nargin==0
        N = get(gcbo,   'UserData');
    else
        N = varagin(1);
    end
    SetupFigurePointGrey(N);
    CtrlPointGreyCams('InitializeCallbacks', N);  
    CtrlPointGreyCams('Cam_Shutter',	N, Xin.D.Sys.PointGreyCam(N).Shutter);
  	CtrlPointGreyCams('Cam_Gain',       N, Xin.D.Sys.PointGreyCam(N).Gain); 
    CtrlPointGreyCams('Cam_DispGain',	N, Xin.D.Sys.PointGreyCam(N).DispGainNum);      
    
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
        
    %% XINTRINSIC Specific GUI Updates    
    Xin.D.Sys.FigureTitle =                 [   Xin.D.Sys.FullName ...
                                                Xin.D.Ses.Load.SoundFigureTitle];
    set(Xin.UI.H0.hFig,                     'Name',     Xin.D.Sys.FigureTitle);
    set(Xin.UI.H.hSes_Start_Momentary,      'Enable',	'on');  % Enable start
       
    %% LOG MSG
    msg = [datestr(now, 'yy/mm/dd HH:MM:SS.FFF') '\tSes_Load\tSession sound loaded as from file: "' ...
        Xin.D.Ses.Load.SoundFile '"\r\n'];
    updateMsg(Xin.D.Exp.hLog, msg);
    
function Ses_Start
    global Xin
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
    %% Update Xin.D.Sys.NI
    Xin.D.Sys.NIDAQ.Task_AO_Xin.write.writeData =...
                                    reshape(Xin.D.Ses.Load.SoundMat(:,Xin.D.Ses.Load.TrlOrderSoundVec),1,[])';
    Xin.D.Ses.DataFileSize =        Xin.D.Vol.ImageHeight/Xin.D.Vol.VideoBin *...
                                    Xin.D.Vol.ImageWidth/Xin.D.Vol.VideoBin *...
                                    Xin.D.Ses.FrameTotal*2/10^9;
    Xin.D.Vol.FramePowerSampleNum = round(...
                                    Xin.D.Sys.PointGreyCam(2).Shutter/1000*...
                                    Xin.D.Sys.NIDAQ.Task_AI_Xin.time.rate);                           
    
	%% Questdlg the information
    disp('Trial Order:');
    disp(Xin.D.Ses.Load.TrlOrderMat);
  	videoinfo = {...
        ['System Light Source: ',       Xin.D.Sys.Light.Source,     '; '],...
     	['System Light Port: ',     	Xin.D.Sys.Light.Port,       '; '],...
     	['System Light Head Cube: ',	Xin.D.Sys.Light.HeadCube,	'; '],...
        ['System Cam DispGainNum: ',	num2str(Xin.D.Sys.PointGreyCam(2).DispGainNum),  ' (frames); '],...
        ['System Cam Shutter: ',        sprintf('%5.2f',Xin.D.Sys.PointGreyCam(2).Shutter),  ' (ms); '],...
        ['System Cam Gain: ',           sprintf('%5.2f',Xin.D.Sys.PointGreyCam(2).Gain),     ' (dB); '],...
    	['Monkey ID: ',         Xin.D.Mky.ID,                       '; '],...
     	['Monkey Side: ',       Xin.D.Mky.Side,                     '; '],...
     	['Experiment Date: ',	Xin.D.Exp.DateStr,                  '; '],...
        ['Experiment Depth: ',	sprintf('%5.2f',Xin.D.Exp.Depth),   ' (LT1 fine turn); '],...
        ['Session Sound File: ',        Xin.D.Ses.Load.SoundFile,        '; '],...
        ['Session Sound Dir: ',         Xin.D.Ses.Load.SoundDir,         '; '],...
        ['Session Sound Title: ',       Xin.D.Ses.Load.SoundTitle,       '; '],...
        ['Session Sound Artist: ',      Xin.D.Ses.Load.SoundArtist,      '; '],...
        ['Session Cycle Duration: ',    sprintf('%5.1f',Xin.D.Ses.Load.CycleDurTotal),	' (s); '],...
        ['Session Cycle Number Total: ',sprintf('%d',   Xin.D.Ses.Load.CycleNumTotal),	'; '],...
        ['Session Duration Total: ',	sprintf('%5.1f',Xin.D.Ses.Load.DurTotal),        ' (s); '],...
        ['Session Data File Size: ',    sprintf('%5.2f',Xin.D.Ses.DataFileSize),	' (GB); '],...
        ['Trial Number per Sound: ',    sprintf('%d',   Xin.D.Trl.Load.NumTotal),        '; '],...
        ['Trial Duration: ',            sprintf('%5.2f',Xin.D.Trl.Load.DurTotal),        ' (s); '],...
        ['Trial Duration PreStim: ',	sprintf('%5.2f',Xin.D.Trl.Load.DurPreStim),      ' (s); '],...
        ['Trial Duration Stim: ',       sprintf('%5.2f',Xin.D.Trl.Load.DurStim),         ' (s); '],...
        ['Trial Duration PostStim: ',	sprintf('%5.2f',Xin.D.Trl.Load.DurPostStim),     ' (s); ']...
        };
    promptinfo = [...
        videoinfo,...
        {''},...
        {'Are these settings correct?'}];
    choice = questdlg(promptinfo,...
        'Imaging conditions:',...
        'No, Cancel and Reset', 'Yes, Take a Recording',...
        'No, Cancel and Reset');
   	switch choice
        case 'No, Cancel and Reset';    return;
        case 'Yes, Take an Image'     
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
	Xin.D.Ses.Save.SysLightPort =       Xin.D.Sys.Light.Port;
	Xin.D.Ses.Save.SysLightHeadCube =	Xin.D.Sys.Light.HeadCube;
	Xin.D.Ses.Save.SysCamShutter =      Xin.D.Sys.PointGreyCam(2).Shutter;
	Xin.D.Ses.Save.SysCamGain =         Xin.D.Sys.PointGreyCam(2).Gain;
	Xin.D.Ses.Save.SysCamDispGainNum =  Xin.D.Sys.PointGreyCam(2).DispGainNum;
  	Xin.D.Ses.Save.MkyID =              Xin.D.Mky.ID;
    Xin.D.Ses.Save.MkySide =            Xin.D.Mky.Side;
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
    Xin.D.Ses.Save.SesPowerMeter =      zeros(      Xin.D.Ses.FrameTotal,...
                                                    Xin.D.Vol.FramePowerSampleNum);                                           
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
    
    %% GUI Update & Lock     
    Xin.D.Ses.Load.SoundFigureTitle =   [   ': now playing "' ...
                                            Xin.D.Ses.Load.SoundFile '"'];    
    Xin.D.Sys.FigureTitle =             [   Xin.D.Sys.FullName ...
                                            Xin.D.Ses.Load.SoundFigureTitle];
    set(Xin.UI.H0.hFig, 'Name', Xin.D.Sys.FigureTitle);
    EnableGUI('inactive');    
    msg =   [datestr(now, 'yy/mm/dd HH:MM:SS.FFF') '\tSesStart\tSession is about to start with the sound: "' ...
        Xin.D.Ses.Load.SoundFile '"\r\n'];
    updateMsg(Xin.D.Exp.hLog, msg);
    %% TDT PA5 Setup
  	Xin.HW.TDT.PA5 = actxcontrol('PA5.x',[0 0 1 1]);
    pause(1);
    invoke(Xin.HW.TDT.PA5,'ConnectPA5','USB',1);
    msg =   [datestr(now, 'yy/mm/dd HH:MM:SS.FFF') '\tSesStart\tTDT PA5 set up\r\n'];
    updateMsg(Xin.D.Exp.hLog, msg);
    %% Camera Trigger Settings & Start the Video Recording   
    % CtrlPointGreyCams('Trigger_Mode', 2, 'SoftwareRec');
    CtrlPointGreyCams('Trigger_Mode', 2, 'HardwareRec'); 
	Xin.HW.PointGrey.Cam(2).hVid.TriggerRepeat = Xin.D.Ses.FrameTotal - 1;
	start(          Xin.HW.PointGrey.Cam(2).hVid);
    msg =   [datestr(now, 'yy/mm/dd HH:MM:SS.FFF') '\tSesStart\tPointGrey set up\r\n'];
    updateMsg(Xin.D.Exp.hLog, msg);
    %% Initialize Ses timing related stuff
    Xin.D.Ses.UpdateNumCurrent   = -1;  
    Xin.D.Ses.UpdateNumCurrentAI = 0;  
    updateTrial;    % this also updates the PA5     
    %% NI Start
    StartNIDAQ;     
    %% Capturing Video
    while(1)
        %% Wait until at least a full block (assume 16) of frames is available
        while(1)
            Xin.D.Ses.FrameAvailable =  Xin.HW.PointGrey.Cam(2).hVid.FramesAvailable;
            if Xin.D.Ses.FrameAvailable >= Xin.D.Vol.UpdFrameNum; break; end
        	pause(0.01);
        end
        %% Update Trial
        updateTrial;
        %% Read a block (assume 16) of frames
        [   Xin.D.Vol.UpdFrameBlockRaw, ~,...
            Xin.D.Vol.UpdMetadataBlockRaw] = ...
            getdata(Xin.HW.PointGrey.Cam(2).hVid, Xin.D.Vol.UpdFrameNum,...
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
    	Xin.D.Ses.FrameRequested =  Xin.HW.PointGrey.Cam(2).hVid.TriggersExecuted;
       	Xin.D.Ses.FrameAcquired =   Xin.HW.PointGrey.Cam(2).hVid.FramesAcquired;          
     	Xin.D.Ses.FrameAvailable =  Xin.HW.PointGrey.Cam(2).hVid.FramesAvailable;
    	set(Xin.UI.H.hSes_FrameAcquired_Edit,   'string',   num2str(Xin.D.Ses.FrameAcquired) );
        set(Xin.UI.H.hSes_FrameAvailable_Edit,  'string',   num2str(Xin.D.Ses.FrameAvailable) );
        %% Stop if All Frames Are Acquired and Read
        if  Xin.D.Ses.FrameAcquired == Xin.D.Ses.FrameTotal && ...
            Xin.HW.PointGrey.Cam(2).hVid.FramesAvailable == 0
            break;
        end
    end
    msg =   [datestr(now, 'yy/mm/dd HH:MM:SS.FFF') '\tSesStart\tAll frames recorded. Session about to stop\r\n'];
    updateMsg(Xin.D.Exp.hLog, msg);
    %% NI Stop
    pause(2);
    StopNIDAQ;        
    %% GUI & Trigger Release
    CtrlPointGreyCams('Trigger_Mode', 2, 'SoftwareGrab');
    set(Xin.UI.H0.hFig, 'Name', Xin.D.Sys.FullName);
    EnableGUI('on');  
    %% Final Save
    S = Xin.D.Ses.Save;
    save([Xin.D.Exp.DataDir, dataname '.mat'], 'S', '-v7.3');
	fclose(hFile);    
    msg =   [datestr(now, 'yy/mm/dd HH:MM:SS.FFF') '\tSesStart\tData file saved. Session stopped\r\n'];
    updateMsg(Xin.D.Exp.hLog, msg);   
    Xin.D.Ses.Load.SoundFigureTitle =   [   ': now "' ...
                                            Xin.D.Ses.Load.SoundFile '" recording session has ended']; 
    Xin.D.Sys.FigureTitle =             [   Xin.D.Sys.FullName ...
                                            Xin.D.Ses.Load.SoundFigureTitle];
    set(Xin.UI.H0.hFig, 'Name', Xin.D.Sys.FigureTitle);
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
                warndlg('Can not close Thorlabs Power Meters');
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
    a{3} =  get(Xin.UI.H.hSys_LightPort_Rocker,     'Children'); 
    a{4} =  get(Xin.UI.H.hSys_HeadCube_Rocker,      'Children');    
    a{5} =  get(Xin.UI.H.hMky_ID_Toggle1,           'Children');   
    a{6} =  get(Xin.UI.H.hMky_ID_Toggle2,           'Children');
    a{7} =  get(Xin.UI.H.hMky_Side_Rocker,          'Children');
    a{8} =  get(Xin.UI.H.hSes_TrlOrder_Rocker,      'Children');
    
    hArray = [...
        a{1}(2),    a{1}(3),...
        a{2}(2),    a{2}(3),...
        a{3}(2),    a{3}(3),...
        a{4}(1),    a{4}(2),    a{4}(3),...   
        a{5}(3),...
        a{6}(2),    a{6}(3),... 
        a{7}(2),    a{7}(3),...
        a{8}(2),    a{8}(3),...
        Xin.UI.H.hSys_CamShutter_PotenSlider,...
        Xin.UI.H.hSys_CamShutter_PotenEdit,...
        Xin.UI.H.hSys_CamGain_PotenSlider,...
        Xin.UI.H.hSys_CamGain_PotenEdit,...
        Xin.UI.H.hSys_CamDispGain_PotenSlider,...
        Xin.UI.H.hSys_CamDispGain_PotenEdit,...
        Xin.UI.H.hExp_RefImage_Momentary,...
        Xin.UI.H.hExp_Depth_Edit,...
        Xin.UI.H.hSes_Load_Momentary,...
        Xin.UI.H.hSes_Start_Momentary,...
        Xin.UI.H.hSes_CycleNumTotal_Edit,...
        Xin.UI.H.hSes_AddAtts_Edit];
    set(hArray, 'Enable',   mode);
