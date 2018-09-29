function SetupD
%% SetupD
% To setup all the preset parameters for following procedures 

%% Initiation
global Xin      % initialize Xin

%% User Interface
for d = 1
    Xin.UI.Style =               'dark';
%     Xin.UI.Style =             'norm';
    Xin.UI.LookAndFeel =         'com.sun.java.swing.plaf.windows.WindowsLookAndFeel';
        % lafs = javax.swing.UIManager.getInstalledLookAndFeels; 
        % for lafIdx = 1:length(lafs),  disp(lafs(lafIdx));  end
        % javax.swing.UIManager.setLookAndFeel('javax.swing.plaf.metal.MetalLookAndFeel');
        % javax.swing.UIManager.setLookAndFeel('javax.swing.plaf.nimbus.NimbusLookAndFeel');
        % javax.swing.UIManager.setLookAndFeel('com.sun.java.swing.plaf.motif.MotifLookAndFeel');
        % javax.swing.UIManager.setLookAndFeel('com.sun.java.swing.plaf.windows.WindowsLookAndFeel');
        % javax.swing.UIManager.setLookAndFeel('com.sun.java.swing.plaf.windows.WindowsClassicLookAndFeel');

    Xin.UI.Styles.dark.BG =         [   0       0       0];
    Xin.UI.Styles.dark.HL =         [   0       0       0];
    Xin.UI.Styles.dark.FG =     	[   0.6     0.6     0.6];    
    Xin.UI.Styles.dark.TextBG  =    [   0.25    0.25    0.25];
    Xin.UI.Styles.dark.SelectB =    [   0       0       0.35];
    Xin.UI.Styles.dark.SelectT =    [   0       0       0.35];

    Xin.UI.Styles.norm.BG =         [   0.8     0.8     0.8];
    Xin.UI.Styles.norm.HL =         [   1       1       1];  
    Xin.UI.Styles.norm.FG =         [   0       0       0];
    Xin.UI.Styles.norm.TextBG =     [   0.94    0.94    0.94];
    Xin.UI.Styles.norm.SelectB =    [   0.94    0.94    0.94];
    Xin.UI.Styles.norm.SelectT =    [   0.18    0.57   	0.77];

    % select UI color style
    eval(['Xin.UI.C = Xin.UI.Styles.',Xin.UI.Style,';']);
end

%% D.SYS (System)
for d = 1    
	%%%%%%%%%%%%%%%%%%%%%%% Name & Folder
    % avoid writing again if already run by the main script
        Xin.D.Sys.FullName =	'[XINTRINSIC: X-polarization enhanced INTRINSIC & fluorescent functional imaging]';
    if ~isfield(Xin.D.Sys, 'Name')      % No defined in the main program yet
        Xin.D.Sys.Name =        'XINTRINSIC';
    end    
        Xin.D.Sys.DataDir =     ['D:\=',Xin.D.Sys.Name,'=\'];
    if isempty(dir(Xin.D.Sys.DataDir))  % Create the Sys.Data folder if not yet
        mkdir(Xin.D.Sys.DataDir);
    end     
        Xin.D.Sys.FigureTitle = Xin.D.Sys.FullName;
    
    %%%%%%%%%%%%%%%%%%%%%%% Sound
    Xin.D.Sys.Sound.SR =    100e3;
    Xin.D.Sys.SoundDir =	'D:\Dropbox\==LightUp==\=M #8 Functional Imaging\=S=Sound Stimuli\';
        
    %%%%%%%%%%%%%%%%%%%%%%% Thorlabs Power Meter     
    % Thorlabs Power Meter 1.0.2 is required as of 20170930
    % Using SCPI (Standard Commands for Programmable Instruments)
    % IEEE 488.2 Common Commands
    
    % Thorlabs PM100A, the 2017 one
    Xin.D.Sys.PowerMeter{1} = struct(...
        'Console',              'PM100A',...
        'RSRCNAME',             'USB0::0x1313::0x8079::P1003352::INSTR',...
        'IDeNtification',       '',...
        'LineFRequency',        60,...      & (Hz)
        'SENSor',               '',...
        'CALibrationSTRing',    '',...
        'AVERageCOUNt',         1,...       % averaging rate, 1s~ .3ms, 142-> 23.49fps
        'WAVelength',           530,...     % (nm)
        'POWerRANGeAUTO',       0,...       % auto range
        'POWerRANGeUPPer',      0.01,...	% (W)
        'INPutFILTering',       0,...       % 15Hz :1, 100kHz :0
        'InitialMEAsurement',   0);  
    
    %%%%%%%%%%%%%%%%%%%%%%% PointGrey Cameras
   	% PointGrey cameras can be linked through the Image Acquisition Toolbox
   	% into Matlab 
    % calling FlyCapture 2.5.3.4 on R2015a 15.1.1 as of 20170927, tested
    
    i = 1;
	Xin.D.Sys.PointGreyCam(i).DeviceName =      'Firefly MV FMVU-03MTM';
    Xin.D.Sys.PointGreyCam(i).Format =          'F7_Mono8_752x480_Mode0';
    Xin.D.Sys.PointGreyCam(i).SerialNumber =	'18186401';
    Xin.D.Sys.PointGreyCam(i).Comments =        'Animal Monitor';
    Xin.D.Sys.PointGreyCam(i).Located =         0;
 	Xin.D.Sys.PointGreyCam(i).FrameRate =       10;
    Xin.D.Sys.PointGreyCam(i).ShutterResv =     0;
    Xin.D.Sys.PointGreyCam(i).GainPolar =       'Max';
    Xin.D.Sys.PointGreyCam(i).PreviewRot =      90;
    Xin.D.Sys.PointGreyCam(i).PreviewZoom =     1;
    Xin.D.Sys.PointGreyCam(i).RecUpdateRate =	NaN;
    Xin.D.Sys.PointGreyCam(i).RecFrameBlockNum =        NaN;     
	Xin.D.Sys.PointGreyCam(i).UpdatePreviewHistogram =  0;  
	Xin.D.Sys.PointGreyCam(i).UpdatePreviewWindowFcn =	@updatePreviewFrame;
    
    i = 2;
    Xin.D.Sys.PointGreyCam(i).DeviceName =      'Grasshopper3 GS3-U3-23S6M';
    Xin.D.Sys.PointGreyCam(i).Format =          'F7_Mono12_1920x1200_Mode7';
    Xin.D.Sys.PointGreyCam(i).SerialNumber =	'16307994';
    Xin.D.Sys.PointGreyCam(i).Comments =        'Wide-field Imaging';
    Xin.D.Sys.PointGreyCam(i).Located =         0;
 	Xin.D.Sys.PointGreyCam(i).FrameRate =       80;         % Max is 87.075;
    Xin.D.Sys.PointGreyCam(i).ShutterResv =     2.3962;     % in (ms) Reserve for shutter read  
    Xin.D.Sys.PointGreyCam(i).GainPolar =       'Min';    
    Xin.D.Sys.PointGreyCam(i).PreviewRot =      0;
    Xin.D.Sys.PointGreyCam(i).PreviewZoom =     2;
    Xin.D.Sys.PointGreyCam(i).RecUpdateRate =	5;
    Xin.D.Sys.PointGreyCam(i).RecFrameBlockNum =        Xin.D.Sys.PointGreyCam(i).FrameRate/...
                                                        Xin.D.Sys.PointGreyCam(i).RecUpdateRate;      
	Xin.D.Sys.PointGreyCam(i).UpdatePreviewHistogram =  1;    
	Xin.D.Sys.PointGreyCam(i).UpdatePreviewWindowFcn =	@updatePreviewFrame;            
    
    i = 3;                                  
	Xin.D.Sys.PointGreyCam(i).DeviceName =      'Flea3 FL3-U3-88S2C';
    % Xin.D.Sys.PointGreyCam(i).Format =          'F7_BayerRG8_4000x3000_Mode10';
    Xin.D.Sys.PointGreyCam(i).Format =          'F7_Mono8_4000x3000_Mode10';
    Xin.D.Sys.PointGreyCam(i).SerialNumber =	'14301633';
    Xin.D.Sys.PointGreyCam(i).Comments =        'FANTASIA FOV finder';
    Xin.D.Sys.PointGreyCam(i).Located =         0;
 	Xin.D.Sys.PointGreyCam(i).FrameRate =       10;
    Xin.D.Sys.PointGreyCam(i).ShutterResv =     0;
    Xin.D.Sys.PointGreyCam(i).GainPolar =       'Max';    
    Xin.D.Sys.PointGreyCam(i).PreviewRot =      180;
    Xin.D.Sys.PointGreyCam(i).PreviewZoom =     4;
    Xin.D.Sys.PointGreyCam(i).RecUpdateRate =	NaN;
    Xin.D.Sys.PointGreyCam(i).RecFrameBlockNum =        NaN;       
	Xin.D.Sys.PointGreyCam(i).UpdatePreviewHistogram =  0;  
	Xin.D.Sys.PointGreyCam(i).UpdatePreviewWindowFcn =	@updatePreviewFrame;                                      

    %%%%%%%%%%%%%%%%%%%%%%% NI
    % ScanImage 5.2, released by end of 2016, support Matlab calling from 
    % Matlab R2015a/R2016a, to NI-DAQmx 15.5, in Windows 10 x64 
        %'Dev4' USB-6251 connected for XINTRINSIC testing
        %   AI0         Input from the Koehler Power Meter
        %   AO0         Output: Sound to PA5
        %   AO1         Output: LED Power Control (optional)
        %   Ctr0        Frame trigger (wired through PFI0)
        %   Ctr1        Start trigger (wired through PFI1)

%     Xin.D.Sys.NIDAQ.Config = struct(...
%         'deviceNames',              'Dev4',...                      % 6251
%         'AI_chanIDs',               0,...                           % Power Meter Input
%         'AO_chanIDs',               0,...                           % Sound Output
%         'CO_Frame_chanIDs',         0,...                           % Frame Trigger
%         'CO_Start_chanIDs',         1,...                           % Start Trigger
%         'AI_rate',                  1e6,...                         % AI sampling rate
%         'FrameSourceLine',          'Ctr0InternalOutput',...
%         'FrameBridgeLine',          'PFI0',...
%         'StartSourceLine',          'Ctr1InternalOutput',...
%         'StartBridgeLine',          'PFI1',...
%         'TimebaseSourceLine',     	'20MHzTimebase',...
%         'TimebaseBridgeLine',     	'20MHzTimebase');
        
    Xin.D.Sys.NIDAQ.Config = struct(...
        'deviceNames',              'Dev3',...                      % 6323
        'AI_chanIDs',               4,...                           % Power Meter Input
        'AO_chanIDs',               2,...                           % Sound Output
        'CO_Frame_chanIDs',         3,...                           % Frame Trigger
        'CO_Update_chanIDs',        2,...                           % Update Timer
        'CO_Start_chanIDs',         1,...                           % Start Trigger
        'AI_rate',                  1.0e5,...                       % AI sampling rate
        'FrameSourceLine',          'Ctr3InternalOutput',...
        'FrameBridgeLine',          'PFI3',...
        'StartSourceLine',          'Ctr1InternalOutput',...
        'StartBridgeLine',          'Ctr1InternalOutput',...
        'TimebaseSourceLine',     	'20MHzTimebase',...
        'TimebaseBridgeLine',     	'20MHzTimebase');
    
	%%%%%%%%%%%%%%%%%%%%%%% NI, DEVICE
    Xin.D.Sys.NIDAQ.Dev_Names =    	{Xin.D.Sys.NIDAQ.Config.deviceNames};   

    %%%%%%%%%%%%%%%%%%%%%%% NI, TASK
    T =                             [];
    T.taskName =                    'Koehler Power Meter Input Task';   i = 1;
    T.chan(i).deviceNames =         Xin.D.Sys.NIDAQ.Dev_Names{1};
    T.chan(i).chanIDs =             Xin.D.Sys.NIDAQ.Config.AI_chanIDs;
    T.chan(i).chanNames =           'PowerMeterIn';
    T.chan(i).minVal =              -2;
    T.chan(i).maxVal =              2;
    T.chan(i).units =               'DAQmx_Val_Volts';   
    T.base.sampClkTimebaseRate =    20e6;                
    T.base.sampClkTimebaseSrc =     Xin.D.Sys.NIDAQ.Config.TimebaseBridgeLine; 
    T.time.rate =                   Xin.D.Sys.NIDAQ.Config.AI_rate;
                    % 200kS/s to record the power signal from which the spectrum < 100kHz
                    % 800kS/s to meet the 12bits SNR requirement
    T.time.sampleMode =             'DAQmx_Val_ContSamps';  
    T.time.updateRate =             Xin.D.Sys.PointGreyCam(2).RecUpdateRate;     
                    % AI update rate, 5Hz, 200ms per update
    T.time.sampsPerChanToAcquire =	T.time.rate*100;
                    % Continuous sampling, with buffer size = 100s
                    % 100*2.5e5*2/1024/1024 = 47.68 MB memory
    T.trigger.triggerSource =       Xin.D.Sys.NIDAQ.Config.StartBridgeLine;
    T.trigger.triggerEdge =         'DAQmx_Val_Rising';    
    T.everyN.callbackFunc =         @updatePower;
    T.everyN.everyNSamples =        round(T.time.rate/T.time.updateRate);
    T.everyN.readDataEnable =       true;
    T.everyN.readDataTypeOption =   'Scaled';    
    Xin.D.Sys.NIDAQ.Task_AI_Xin =	T;

    T =                             [];
    T.taskName =                    'Sound Output Task';            i = 1;
    T.chan(i).deviceNames =         Xin.D.Sys.NIDAQ.Dev_Names{1};
    T.chan(i).chanIDs =             Xin.D.Sys.NIDAQ.Config.AO_chanIDs;
    T.chan(i).chanNames =           'SoundOut';
    T.chan(i).minVal =              -10;
    T.chan(i).maxVal =              10;
    T.chan(i).units =               'DAQmx_Val_Volts';     
    T.base.sampClkTimebaseRate =    20e6;                
    T.base.sampClkTimebaseSrc =     Xin.D.Sys.NIDAQ.Config.TimebaseBridgeLine;
    T.time.rate =                   Xin.D.Sys.Sound.SR; 
    T.time.sampleMode =             'DAQmx_Val_FiniteSamps'; 
    T.time.updateRate =             Xin.D.Sys.PointGreyCam(2).RecUpdateRate;  
    T.time.sampsPerChanToAcquire =	T.time.rate*4;
    T.trigger.triggerSource =       Xin.D.Sys.NIDAQ.Config.StartBridgeLine;
    T.trigger.triggerEdge =         'DAQmx_Val_Rising';      
    T.everyN.callbackFunc =         @updateTrial;
    T.everyN.everyNSamples =        round(T.time.rate/Xin.D.Sys.PointGreyCam(2).RecUpdateRate);
    T.write.writeData =             linspace(0, 5, T.time.rate)';
    Xin.D.Sys.NIDAQ.Task_AO_Xin =	T;

    T =                             [];
    T.taskName =                    'Frame Trigger Task';           i = 1;
    T.chan(i).deviceNames =         Xin.D.Sys.NIDAQ.Dev_Names{1};
    T.chan(i).chanIDs =             Xin.D.Sys.NIDAQ.Config.CO_Frame_chanIDs;
    T.chan(i).chanNames =           'FrameTrigger';
    T.chan(i).sourceTerminal =      Xin.D.Sys.NIDAQ.Config.TimebaseBridgeLine;
    T.chan(i).lowTicks =            20e6/Xin.D.Sys.PointGreyCam(2).FrameRate/2;
    T.chan(i).highTicks =           20e6/Xin.D.Sys.PointGreyCam(2).FrameRate/2;
    T.chan(i).initialDelay =        0;
    T.chan(i).idleState =           'DAQmx_Val_Low';
    T.time.sampleMode =             'DAQmx_Val_ContSamps';
    T.time.sampsPerChanToAcquire =	0;
    T.trigger.triggerSource =       Xin.D.Sys.NIDAQ.Config.StartBridgeLine;
    T.trigger.triggerEdge =         'DAQmx_Val_Rising';  
    Xin.D.Sys.NIDAQ.Task_CO_TrigFrame =    T;
    
% 	T =                             [];
%     T.taskName =                    'Update Timer Task';            i = 1;
%     T.chan(i).deviceNames =         Xin.D.Sys.NIDAQ.Dev_Names{1};
%     T.chan(i).chanIDs =             Xin.D.Sys.NIDAQ.Config.CO_Update_chanIDs;
%     T.chan(i).chanNames =           'UpdateTimer';
%     T.chan(i).sourceTerminal =      Xin.D.Sys.NIDAQ.Config.TimebaseBridgeLine;
%     T.chan(i).lowTicks =            20e6/Xin.D.Sys.PointGreyCam(2).RecUpdateRate/2;
%     T.chan(i).highTicks =           20e6/Xin.D.Sys.PointGreyCam(2).RecUpdateRate/2;
%     T.chan(i).initialDelay =        0;
%     T.chan(i).idleState =           'DAQmx_Val_Low';
%     T.time.sampleMode =             'DAQmx_Val_ContSamps';
%     T.time.sampsPerChanToAcquire =	0;
%     T.trigger.triggerSource =       Xin.D.Sys.NIDAQ.Config.StartBridgeLine;
%     T.trigger.triggerEdge =         'DAQmx_Val_Rising';  
%     Xin.D.Sys.NIDAQ.Task_CO_TrigUpdate =    T;
    
    T =                             [];
    T.taskName =                    'Start Trigger Task';           i = 1;
    T.chan(i).deviceNames =         Xin.D.Sys.NIDAQ.Dev_Names{1};
    T.chan(i).chanIDs =             Xin.D.Sys.NIDAQ.Config.CO_Start_chanIDs;
    T.chan(i).chanNames =           'StartTrigger';
    T.chan(i).sourceTerminal =      Xin.D.Sys.NIDAQ.Config.TimebaseBridgeLine;
    T.chan(i).lowTicks =            10e6;
    T.chan(i).highTicks =           10e6;
    T.chan(i).initialDelay =        0;
    T.chan(i).idleState =           'DAQmx_Val_Low';
    Xin.D.Sys.NIDAQ.Task_CO_TrigStart =    T;    

    %%%%%%%%%%%%%%%%%%%%%%% System Configuration Information
    Xin.D.Sys.Light.Source =        'Red';
    Xin.D.Sys.Light.Port =          'Koehler';
    Xin.D.Sys.Light.HeadCube =      'Pola_PBS';    
    
end
 
%% D.Mky (Monkey)
for d = 1
	%%%%%%%%%%%%%%%%%%%%%%% Monkey 
    Xin.D.Mky.Lists.ID =            {'M00x', '', ''; 'M80Z', 'MCal', ''};
    Xin.D.Mky.Lists.Side =          {'LEFT', 'RIGHT', ''};    
    
    Xin.D.Mky.ID =                  Xin.D.Mky.Lists.ID{1};
    Xin.D.Mky.Side =                Xin.D.Mky.Lists.Side{1};
end

%% D.Exp (Experiment, one experiment should be at the same location)
for d = 1
    %%%%%%%%%%%%%%%%%%%%%%% Date
    Xin.D.Exp.Date =                now; 
    Xin.D.Exp.DateStr =             datestr(Xin.D.Exp.Date, 'yymmdd-HH'); 
    Xin.D.Exp.DataDir =             [   Xin.D.Sys.DataDir,...
                                        Xin.D.Mky.ID, '-',...
                                        Xin.D.Exp.DateStr, '\'];                            
    Xin.D.Exp.LogFileName =         [datestr(now, 'yymmddTHHMMSS'), '_', Xin.D.Sys.Name, '_log.txt'];  
    Xin.D.Exp.hLog =                fopen([Xin.D.Sys.DataDir, Xin.D.Exp.LogFileName], 'w');
    msg = [datestr(now, 'yy/mm/dd HH:MM:SS.FFF') '\tXINTRINSIC\tXINTRINSIC Opened, What a BEAUTIFUL day!\r\n'];
        updateMsg(Xin.D.Exp.hLog, msg);
        
	%%%%%%%%%%%%%%%%%%%%%%% Geometry
    Xin.D.Exp.Depth =               0;          % Z depth (in LT1 fine turns)
end

%% D.Ses (Session, one session should be a bunch of trials measure)
for d = 1
   	%%%%%%%%%%%%%%%%%%%%%%% Load (for SetupSesLoad)
    Xin.D.Ses.Load.SoundFile =          'test.wav';
    Xin.D.Ses.Load.SoundDir =           '';
    Xin.D.Ses.Load.SoundSR =            Xin.D.Sys.Sound.SR;
    Xin.D.Ses.Load.SoundTitle =         '';
    Xin.D.Ses.Load.SoundArtist =        '';
    Xin.D.Ses.Load.SoundComment =       '';    
    Xin.D.Ses.Load.SoundFigureTitle =	[': now playing "' Xin.D.Ses.Load.SoundTitle '"'];
    Xin.D.Ses.Load.SoundWave =          int16([]);                          
    Xin.D.Ses.Load.SoundDurTotal =      NaN;    
    Xin.D.Ses.Load.SoundMat =           int16([]);  
    
    Xin.D.Ses.Load.AddAtts =             0; 
    Xin.D.Ses.Load.AddAttString =        num2str(Xin.D.Ses.Load.AddAtts);
    Xin.D.Ses.Load.AddAttNumTotal =      length(Xin.D.Ses.Load.AddAtts);     
    Xin.D.Ses.Load.CycleDurTotal =       NaN;
    Xin.D.Ses.Load.CycleDurCurrent =     NaN;  
    Xin.D.Ses.Load.TrlIndexSoundNum =    [];
    Xin.D.Ses.Load.TrlIndexAddAttNum =   [];
    
	Xin.D.Ses.Load.CycleNumTotal =       2;    
    Xin.D.Ses.Load.CycleNumCurrent =     NaN; 
    Xin.D.Ses.Load.DurTotal =            NaN;
	Xin.D.Ses.Load.DurCurrent =          NaN;   

    Xin.D.Ses.Load.TrlOrder =            'Sequential';
    Xin.D.Ses.Load.TrlOrderMat =         NaN;
    Xin.D.Ses.Load.TrlOrderVec =         reshape(Xin.D.Ses.Load.TrlOrderMat',1,[]);
    Xin.D.Ses.Load.TrlOrderSoundVec =    [];

 
    %%%%%%%%%%%%%%%%%%%%%%% XINTRINSIC Specific  
    Xin.D.Ses.UpdateNumTotal =      NaN;
  	Xin.D.Ses.UpdateNumCurrent =    NaN; 
    Xin.D.Ses.UpdateNumCurrentAI =  NaN;   % NI Analog Input
    Xin.D.Ses.FrameTotal =          NaN;
    Xin.D.Ses.FrameRequested =      NaN;    
    Xin.D.Ses.FrameAcquired =       NaN;    
    Xin.D.Ses.FrameAvailable =      NaN;
    Xin.D.Ses.DataFile =            '';    
    Xin.D.Ses.DataFileSize =        NaN;   
end

%% D.Trl (Trial)
for d = 1
   	%%%%%%%%%%%%%%%%%%%%%%% Load (for SetupSesLoad)
	Xin.D.Trl.Load.Names =              {};
    Xin.D.Trl.Load.Attenuations =       [];
    Xin.D.Trl.Load.SoundNumTotal =      NaN;
    Xin.D.Trl.Load.DurTotal =           NaN;
	Xin.D.Trl.Load.DurCurrent =         NaN;
    Xin.D.Trl.Load.DurPreStim =         NaN;
    Xin.D.Trl.Load.DurStim =            NaN; 
    Xin.D.Trl.Load.DurPostStim =        Xin.D.Trl.Load.DurTotal - ...
                                        Xin.D.Trl.Load.DurPreStim - ...
                                        Xin.D.Trl.Load.DurStim;
    
    Xin.D.Trl.Load.NumTotal =           NaN;
    Xin.D.Trl.Load.NumCurrent =         NaN;
    Xin.D.Trl.Load.AttNumCurrent =      NaN;
    Xin.D.Trl.Load.AttDesignCurrent =	NaN;
    Xin.D.Trl.Load.AttAddCurrent =      NaN;
    Xin.D.Trl.Load.AttCurrent =         NaN;
        
    Xin.D.Trl.Load.StimNumCurrent =     NaN;
    Xin.D.Trl.Load.StimNumNext =        NaN;
    Xin.D.Trl.Load.SoundNumCurrent =	NaN;
    Xin.D.Trl.Load.SoundNameCurrent =	'';

end

%% D.Vol (Volume & Frame)
for d = 1
    % Raw image parameters
    Xin.D.Vol.ImageHeight =  	1200;
    Xin.D.Vol.ImageWidth =    	1920; 
    Xin.D.Vol.VideoBin =        4;
    
    % Updates
    Xin.D.Vol.UpdFrameNum =     Xin.D.Sys.PointGreyCam(2).RecFrameBlockNum;
    Xin.D.Vol.UpdFrameBlockRaw = ...
                                uint16(zeros(...
                                Xin.D.Vol.ImageHeight,...
                                Xin.D.Vol.ImageWidth,...
                                1,...
                                Xin.D.Vol.UpdFrameNum));
    Xin.D.Vol.UpdFrameBlockS1 = reshape(Xin.D.Vol.UpdFrameBlockRaw,...
        Xin.D.Vol.VideoBin,     Xin.D.Vol.ImageHeight/Xin.D.Vol.VideoBin,...
        Xin.D.Vol.VideoBin,     Xin.D.Vol.ImageWidth/Xin.D.Vol.VideoBin,...
        Xin.D.Vol.UpdFrameNum); 
    Xin.D.Vol.UpdFrameBlockS2 = sum(Xin.D.Vol.UpdFrameBlockS1, 1, 'native');  
    Xin.D.Vol.UpdFrameBlockS3 = sum(Xin.D.Vol.UpdFrameBlockS2, 3, 'native');
    Xin.D.Vol.UpdFrameBlockS4 = squeeze(Xin.D.Vol.UpdFrameBlockS3);
        
	Xin.D.Vol.UpdMetadataBlockRaw = [];    
    Xin.D.Vol.UpdMetadataBlockS1 =  [];
    Xin.D.Vol.UpdMetadataBlockS2 =  zeros(Xin.D.Vol.UpdFrameNum,6);
    Xin.D.Vol.UpdMetadataBlockS3 =  zeros(Xin.D.Vol.UpdFrameNum,1);
    Xin.D.Vol.UpdMetadataBlockS4 =  char(zeros(Xin.D.Vol.UpdFrameNum,21));
    
    Xin.D.Vol.UpdPowerSampleNum =   Xin.D.Sys.NIDAQ.Task_AI_Xin.everyN.everyNSamples;
    Xin.D.Vol.UpdPowerRaw =         zeros(Xin.D.Vol.UpdPowerSampleNum, 1);
    Xin.D.Vol.UpdPowerAligned =     zeros(...
                                    	Xin.D.Vol.UpdPowerSampleNum/Xin.D.Vol.UpdFrameNum, ...
                                    	Xin.D.Vol.UpdFrameNum);     
    Xin.D.Vol.FramePowerSamples =	round(Xin.D.Sys.NIDAQ.Task_AI_Xin.time.rate/...
                                    Xin.D.Sys.PointGreyCam(2).FrameRate);   
end

%% D.Mon (Monitor)
for d = 1
end

%% LOG MSG
msg = [datestr(now, 'yy/mm/dd HH:MM:SS.FFF') '\tSetupD\tXin.D initialized\r\n'];
    updateMsg(Xin.D.Exp.hLog, msg);