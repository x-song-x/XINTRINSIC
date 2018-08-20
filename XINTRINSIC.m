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
Xin.D.Sys.Name =        mfilename;         % Grab the current script's name
SetupD;                % Initiate parameters
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
                Xin.D.Ses.CycleNumTotal = t;
            catch
                errordlg('Cycle Number Total input is not valid');
            end
            Xin.D.Ses.CycleNumCurrent =	NaN; 
            Xin.D.Ses.DurTotal =        Xin.D.Ses.CycleDurTotal * Xin.D.Ses.CycleNumTotal;        
            Xin.D.Ses.DurCurrent =      NaN;  
            Xin.D.Ses.UpdateNumTotal =	Xin.D.Ses.DurTotal * Xin.D.Sys.NIDAQ.Task_AI_Xin.time.updateRate;
            Xin.D.Ses.UpdateNumCurrent =NaN;      
            Xin.D.Ses.UpdateNumCurrentAI =NaN;    
            Xin.D.Ses.FrameTotal =      Xin.D.Ses.DurTotal * Xin.D.Sys.PointGreyCam(2).FrameRate; 
            Xin.D.Ses.FrameRequested =	NaN;    
            Xin.D.Ses.FrameAcquired =   NaN;    
            Xin.D.Ses.FrameAvailable =  NaN;                     
            Xin.D.Sys.NIDAQ.Task_AO_Xin.time.sampsPerChanToAcquire = ...
                                        length( Xin.D.Ses.SoundWave)*...
                                        Xin.D.Ses.AddAttNumTotal*...
                                        Xin.D.Ses.CycleNumTotal;
            set(Xin.UI.H.hSes_CycleNumTotal_Edit,	'String',   num2str(Xin.D.Ses.CycleNumTotal));
            set(Xin.UI.H.hSes_CycleNumCurrent_Edit,	'String',   num2str(Xin.D.Ses.CycleNumCurrent));
            set(Xin.UI.H.hSes_DurTotal_Edit,        'String',   sprintf('%5.1f (s)', Xin.D.Ses.DurTotal));
            set(Xin.UI.H.hSes_DurCurrent_Edit,      'String',   sprintf('%5.1f (s)', Xin.D.Ses.DurCurrent)); 
            set(Xin.UI.H.hSes_FrameTotal_Edit,      'String', 	num2str(Xin.D.Ses.FrameTotal));
            set(Xin.UI.H.hSes_FrameAcquired_Edit,   'String',   num2str(Xin.D.Ses.FrameAcquired) );
            set(Xin.UI.H.hSes_FrameAvailable_Edit,  'String',   num2str(Xin.D.Ses.FrameAvailable) );             
        case 'hSes_AddAtts_Edit'
            try
                eval(['Xin.D.Ses.AddAtts = [', s, '];']);
                Xin.D.Ses.AddAttString = s;
            catch
                errordlg('Additonal attenuations input is not valid');
            end
            Xin.D.Ses.AddAttNumTotal =  length(Xin.D.Ses.AddAtts);
            Xin.D.Ses.CycleDurTotal =   Xin.D.Ses.SoundDurTotal * Xin.D.Ses.AddAttNumTotal;        
            Xin.D.Ses.CycleDurCurrent =	NaN;
            Xin.D.Trl.NumTotal =        Xin.D.Trl.SoundNumTotal * Xin.D.Ses.AddAttNumTotal;
            Xin.D.Trl.NumCurrent =      NaN;
            Xin.D.Ses.TrlIndexSoundNum =    repmat(1:Xin.D.Trl.SoundNumTotal, 1, Xin.D.Ses.AddAttNumTotal);
            Xin.D.Ses.TrlIndexAddAttNum =   repelem(1:Xin.D.Ses.AddAttNumTotal, Xin.D.Trl.SoundNumTotal);
            
            set(Xin.UI.H.hSes_AddAttNumTotal_Edit,	'String',   num2str(Xin.D.Ses.AddAttNumTotal));
            set(Xin.UI.H.hSes_CycleDurTotal_Edit, 	'String',	sprintf('%5.1f (s)', Xin.D.Ses.CycleDurTotal));
            set(Xin.UI.H.hSes_CycleDurCurrent_Edit,	'String',   sprintf('%5.1f (s)', Xin.D.Ses.CycleDurCurrent));
            set(Xin.UI.H.hTrl_NumTotal_Edit,        'String',   num2str(Xin.D.Trl.NumTotal));
            set(Xin.UI.H.hTrl_NumCurrent_Edit,      'String',   num2str(Xin.D.Trl.NumCurrent));
          GUI_Edit('hSes_CycleNumTotal_Edit', num2str(Xin.D.Ses.CycleNumTotal));
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
            Xin.D.Ses.TrlOrder = val;
            msg = [datestr(now, 'yy/mm/dd HH:MM:SS.FFF') '\tSes_TrlOrder\tSession trial order selected as: '...
                Xin.D.Ses.TrlOrder '\r\n']; 
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
        [Xin.D.Ses.SoundFile, Xin.D.Ses.SoundDir, FilterIndex] = ...
            uigetfile('.wav','Select a Sound File',...
            [Xin.D.Sys.SoundDir, Xin.D.Ses.SoundFile]);
        filestr = [Xin.D.Ses.SoundDir, Xin.D.Ses.SoundFile];
        if FilterIndex == 0
            return
        end
    else
        % called by general update: Ses_Load('D:\Sound.wav')
        filestr = varargin{1};
        [filepath,name,ext] = fileparts(filestr);
        Xin.D.Ses.SoundDir =        filepath;
        Xin.D.Ses.SoundFile =       [name ext];
    end
    %% Load the Sound File & Update Parameters
    SoundRaw =                      audioread(filestr, 'native');
	if round(   length(SoundRaw)/Xin.D.Sys.NIDAQ.Task_AO_Xin.time.rate ) ~=...
                length(SoundRaw)/Xin.D.Sys.NIDAQ.Task_AO_Xin.time.rate
        errordlg('The sound length is NOT in integer seconds');
        eval('return;');
	else
        SoundInfo =                 audioinfo(filestr);   
        
        % Update Xin.D.Ses      
        Xin.D.Ses.SoundTitle =      SoundInfo.Title;
        Xin.D.Ses.SoundArtist =     SoundInfo.Artist;
        Xin.D.Ses.SoundComment =	SoundInfo.Comment;
        Xin.D.Ses.SoundWave =       SoundRaw;         
        Xin.D.Ses.SoundDurTotal =	length(SoundRaw)/Xin.D.Sys.NIDAQ.Task_AO_Xin.time.rate;  

        % Update Xin.D.Trl
        part = {}; i = 1;
        remain =                    Xin.D.Ses.SoundComment;
        while ~isempty(remain)
            [part{i}, remain] = strtok(remain, ';');
            [argu, value]=      strtok(part{i}, ':');
            argu =              argu(2:end);
            value =             value(3:end);
            switch argu                
                case 'TrialNames';          value = textscan(value, '%s', 'Delimiter', ' ');
                                            Xin.D.Trl.Names = value{1};
                case 'TrialAttenuations';   value = textscan(value, '%f');
                                            Xin.D.Trl.Attenuations = value{1};
                case 'TrialNumberTotal';	Xin.D.Trl.SoundNumTotal =	str2double(value);
                case 'TrialDurTotal(sec)';	Xin.D.Trl.DurTotal =        str2double(value);
                case 'TrialDurPreStim(sec)';Xin.D.Trl.DurPreStim =      str2double(value);
                case 'TrialDurStim(sec)';   Xin.D.Trl.DurStim =         str2double(value);
                case ''
                otherwise;                  disp(argu);
            end
            i = i+1;
        end
                                            Xin.D.Trl.DurPostStim = Xin.D.Trl.DurTotal - ...
                                                                    Xin.D.Trl.DurPreStim - ...
                                                                    Xin.D.Trl.DurStim;
                                            Xin.D.Trl.NumCurrent =	NaN;
                                            Xin.D.Trl.DurCurrent =	NaN;  
                                            Xin.D.Trl.StimNumCurrent =      NaN;
                                            Xin.D.Trl.StimNumNext =         NaN;
                                            Xin.D.Trl.SoundNumCurrent =    	NaN;
                                            Xin.D.Trl.SoundNameCurrent =    '';
                                            Xin.D.Trl.AttNumCurrent =       NaN;
                                            Xin.D.Trl.AttDesignCurrent =    NaN;
                                            Xin.D.Trl.AttAddCurrent =       NaN;
                                            Xin.D.Trl.AttCurrent =          NaN;
                                            
                                            
        % Update SoundMat, Divide SoundWave by Trl.NumTotal
        Xin.D.Ses.SoundMat =                reshape(Xin.D.Ses.SoundWave,...
                                                length(Xin.D.Ses.SoundWave)/Xin.D.Trl.SoundNumTotal,...
                                                Xin.D.Trl.SoundNumTotal); 
	end       
    %% Update GUI    
    Xin.D.Ses.SoundFigureTile =	[   Xin.D.Sys.FullName ': sound "' ...
                                    Xin.D.Ses.SoundFile '" loaded'];
    set(Xin.UI.H0.hFig,                     'Name',     Xin.D.Ses.SoundFigureTile);
	set(Xin.UI.H.hSes_SoundDurTotal_Edit,   'String',   sprintf('%5.1f (s)', Xin.D.Ses.SoundDurTotal));
	set(Xin.UI.H.hTrl_SoundNumTotal_Edit,	'String',   num2str(Xin.D.Trl.SoundNumTotal));
    set(Xin.UI.H.hTrl_SoundNumCurrent_Edit,	'String',   num2str(Xin.D.Trl.SoundNumCurrent));
    set(Xin.UI.H.hTrl_DurTotal_Edit,        'String',   sprintf('%5.1f (s)', Xin.D.Trl.DurTotal));
    set(Xin.UI.H.hTrl_DurCurrent_Edit,      'String',   sprintf('%5.1f (s)', Xin.D.Trl.DurCurrent)); 
    set(Xin.UI.H.hTrl_StimNumCurrent_Edit,  'String',	num2str(Xin.D.Trl.StimNumCurrent));
    set(Xin.UI.H.hTrl_StimNumNext_Edit,     'String',	num2str(Xin.D.Trl.StimNumNext));
    set(Xin.UI.H.hTrl_SoundNumCurrent_Edit,	'String',	num2str(Xin.D.Trl.SoundNumCurrent));
    set(Xin.UI.H.hTrl_SoundNameCurrent_Edit,'String',	num2str(Xin.D.Trl.SoundNameCurrent));
    set(Xin.UI.H.hTrl_AttDesignCurrent_Edit,'String',	sprintf('%5.1f (dB)',Xin.D.Trl.AttDesignCurrent));
    set(Xin.UI.H.hTrl_AttAddCurrent_Edit,	'String',	sprintf('%5.1f (dB)',Xin.D.Trl.AttAddCurrent));
    set(Xin.UI.H.hTrl_AttCurrent_Edit,      'String',	sprintf('%5.1f (dB)',Xin.D.Trl.AttCurrent));

    set(Xin.UI.H.hSes_Start_Momentary,      'Enable',	'on');  % Enable start
    %% Update Others
        GUI_Edit('hSes_AddAtts_Edit', Xin.D.Ses.AddAttString);       
    %% LOG MSG
    msg = [datestr(now, 'yy/mm/dd HH:MM:SS.FFF') '\tSes_Load\tSession sound loaded as from file: "' ...
        Xin.D.Ses.SoundFile '"\r\n'];
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
    %% Arrange the Sound Trial Order & Update Xin.D.Sys.NI
    switch Xin.D.Ses.TrlOrder
        case 'Sequential'
            Xin.D.Ses.TrlOrderMat =     repmat(1:Xin.D.Trl.NumTotal, Xin.D.Ses.CycleNumTotal, 1);
        case 'Randomized'
            Xin.D.Ses.TrlOrderMat =     [];
            for i = 1:Xin.D.Ses.CycleNumTotal
                Xin.D.Ses.TrlOrderMat = [Xin.D.Ses.TrlOrderMat; randperm(Xin.D.Trl.NumTotal)];
            end            
        otherwise
            errordlg('wrong trial order option');
    end
    Xin.D.Ses.TrlOrderVec =         reshape(Xin.D.Ses.TrlOrderMat',1,[]); % AddAtt Order
    Xin.D.Ses.TrlOrderSoundVec =    Xin.D.Ses.TrlIndexSoundNum(Xin.D.Ses.TrlOrderVec);
    Xin.D.Sys.NIDAQ.Task_AO_Xin.write.writeData =...
                                    reshape(Xin.D.Ses.SoundMat(:,Xin.D.Ses.TrlOrderSoundVec),1,[])';
    Xin.D.Ses.DataFileSize =        Xin.D.Vol.ImageHeight/Xin.D.Vol.VideoBin *...
                                    Xin.D.Vol.ImageWidth/Xin.D.Vol.VideoBin *...
                                    Xin.D.Ses.FrameTotal*2/10^9;
    Xin.D.Vol.FramePowerSampleNum = round(...
                                    Xin.D.Sys.PointGreyCam(2).Shutter/1000*...
                                    Xin.D.Sys.NIDAQ.Task_AI_Xin.time.rate);                           
    
	%% Questdlg the information
    disp('Trial Order:');
    disp(Xin.D.Ses.TrlOrderMat);
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
        ['Session Sound File: ',        Xin.D.Ses.SoundFile,        '; '],...
        ['Session Sound Dir: ',         Xin.D.Ses.SoundDir,         '; '],...
        ['Session Sound Title: ',       Xin.D.Ses.SoundTitle,       '; '],...
        ['Session Sound Artist: ',      Xin.D.Ses.SoundArtist,      '; '],...
        ['Session Cycle Duration: ',    sprintf('%5.1f',Xin.D.Ses.CycleDurTotal),	' (s); '],...
        ['Session Cycle Number Total: ',sprintf('%d',   Xin.D.Ses.CycleNumTotal),	'; '],...
        ['Session Duration Total: ',	sprintf('%5.1f',Xin.D.Ses.DurTotal),        ' (s); '],...
        ['Session Data File Size: ',    sprintf('%5.2f',Xin.D.Ses.DataFileSize),	' (GB); '],...
        ['Trial Number per Sound: ',    sprintf('%d',   Xin.D.Trl.NumTotal),        '; '],...
        ['Trial Duration: ',            sprintf('%5.2f',Xin.D.Trl.DurTotal),        ' (s); '],...
        ['Trial Duration PreStim: ',	sprintf('%5.2f',Xin.D.Trl.DurPreStim),      ' (s); '],...
        ['Trial Duration Stim: ',       sprintf('%5.2f',Xin.D.Trl.DurStim),         ' (s); '],...
        ['Trial Duration PostStim: ',	sprintf('%5.2f',Xin.D.Trl.DurPostStim),     ' (s); ']...
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
    Xin.D.Ses.Save.SesSoundFile =       Xin.D.Ses.SoundFile;
    Xin.D.Ses.Save.SesSoundDir =        Xin.D.Ses.SoundDir;    
    Xin.D.Ses.Save.SesSoundTitle =      Xin.D.Ses.SoundTitle;
    Xin.D.Ses.Save.SesSoundArtist =     Xin.D.Ses.SoundArtist; 
    Xin.D.Ses.Save.SesSoundComment =	Xin.D.Ses.SoundComment;  
    Xin.D.Ses.Save.SesSoundWave =       Xin.D.Ses.SoundWave;  
    Xin.D.Ses.Save.SesSoundDurTotal =   Xin.D.Ses.SoundDurTotal;  
    Xin.D.Ses.Save.AddAtts =            Xin.D.Ses.AddAtts; 
    Xin.D.Ses.Save.AddAttNumTotal =     Xin.D.Ses.AddAttNumTotal; 
    Xin.D.Ses.Save.SesCycleDurTotal =   Xin.D.Ses.CycleDurTotal;
    Xin.D.Ses.Save.SesCycleNumTotal =	Xin.D.Ses.CycleNumTotal; 
    Xin.D.Ses.Save.SesDurTotal =        Xin.D.Ses.DurTotal;
    Xin.D.Ses.Save.SesFrameTotal =      Xin.D.Ses.FrameTotal;
    Xin.D.Ses.Save.SesFrameNum =        zeros(      Xin.D.Ses.FrameTotal,    1);
    Xin.D.Ses.Save.SesTimestamps =      char(zeros( Xin.D.Ses.FrameTotal,    21));
    Xin.D.Ses.Save.SesPowerMeter =      zeros(      Xin.D.Ses.FrameTotal,...
                                                    Xin.D.Vol.FramePowerSampleNum);                                           
    Xin.D.Ses.Save.TrlIndexSoundNum =   Xin.D.Ses.TrlIndexSoundNum;
    Xin.D.Ses.Save.TrlIndexAddAttNum =  Xin.D.Ses.TrlIndexAddAttNum;    
    Xin.D.Ses.Save.SesTrlOrder =        Xin.D.Ses.TrlOrder;
    Xin.D.Ses.Save.SesTrlOrderMat =     Xin.D.Ses.TrlOrderMat;
    Xin.D.Ses.Save.SesTrlOrderVec =     Xin.D.Ses.TrlOrderVec;
    Xin.D.Ses.Save.SesTrlOrderSoundVec =Xin.D.Ses.TrlOrderSoundVec;
    Xin.D.Ses.Save.TrlNumTotal =        Xin.D.Trl.NumTotal;
    Xin.D.Ses.Save.TrlDurTotal =        Xin.D.Trl.DurTotal;
    Xin.D.Ses.Save.TrlDurPreStim =      Xin.D.Trl.DurPreStim;
    Xin.D.Ses.Save.TrlDurStim =         Xin.D.Trl.DurStim;
    Xin.D.Ses.Save.TrlDurPostStim =     Xin.D.Trl.DurPostStim;
    Xin.D.Ses.Save.TrlNames =           Xin.D.Trl.Names;
    Xin.D.Ses.Save.TrlAttenuations =	Xin.D.Trl.Attenuations;
    
    %% GUI Update & Lock     
    Xin.D.Ses.SoundFigureTile =     [Xin.D.Sys.FullName ': now playing "' ...
                                    Xin.D.Ses.SoundFile '"'];
    set(Xin.UI.H0.hFig, 'Name', Xin.D.Ses.SoundFigureTile);
    EnableGUI('inactive');    
    msg =   [datestr(now, 'yy/mm/dd HH:MM:SS.FFF') '\tSesStart\tSession is about to start with the sound: "' ...
        Xin.D.Ses.SoundFile '"\r\n'];
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
    Xin.D.Ses.SoundFigureTile =     [Xin.D.Sys.FullName ': now "' ...
                                    Xin.D.Ses.SoundFile '" recording session has ended'];
    set(Xin.UI.H0.hFig, 'Name', Xin.D.Ses.SoundFigureTile);
    
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
