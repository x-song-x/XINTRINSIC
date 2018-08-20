function msg = SetupFigurePointGrey(N)
% The GUI code for Xintrinsic Setup

global TP
global Xin
try         
    Xin.UI.C = TP.UI.C;
catch
end

%% UI Figure                                        
    % Figure scale
    S.FigWidth =            800;   % 
    S.FigHeight =           800;
    S.FigSideTitleHeight =  30;     % for the windows figure title height
    S.FigSideWidth =        100;    % for [FigStartWidth    FigStartHeight]
   
    % Global Spacer Scale
    S.SP =                  10;     % Panelette Side Spacer
    S.SD =                  4;      % Side Double Spacer
    S.S =                   2;      % Small Spacer 
    S.PaneletteTitle =      18; 
    
    % create the UI figure 
    Xin.UI.FigPGC(N).hFig = figure(...
        'Name',         ['PointGrey Camera #', num2str(N),...
                        ' ', Xin.D.Sys.PointGreyCam(N).Comments ],...
        'NumberTitle',  'off',...
        'Resize',       'off',...
        'color',        Xin.UI.C.BG,...
        'position',     [   S.FigSideWidth,	S.FigSideWidth,...
                            S.FigWidth,     S.FigHeight],...
        'menubar',      'none',...
        'doublebuffer', 'off');
                        
%% UI Control Panel
    % Panelette Scale
    S.PaneletteWidth =      100;
    S.PaneletteHeight =     150;    
    S.PaneletteTitle =      18;

    % Panelette #
    S.PaneletteRowNum =     5;
    S.PaneletteColumnNum =  2;
    
    % Control Panel Scale 
    S.PanelCtrlWidth =      S.PaneletteColumnNum *(S.PaneletteWidth+S.S) + 2*S.SD;
    S.PanelCtrlHeight =     S.PaneletteRowNum *(S.PaneletteHeight+S.S) + S.PaneletteTitle;  
    
    % create the Image Panel
    S.PanelCurrentW =       S.SD;
    S.PanelCurrentH =       S.SD;
    
    S.FigWidthT =           S.PanelCurrentW + S.PanelCtrlWidth + S.SD;
    S.FigHeightT =          S.PanelCurrentH + S.PanelCtrlHeight + S.SD;
    
    Xin.UI.FigPGC(N).hPanelCtrl = uipanel(...
        'parent',               Xin.UI.FigPGC(N).hFig,...
        'BackgroundColor',      Xin.UI.C.BG,...
        'Highlightcolor',       Xin.UI.C.HL,...
        'ForegroundColor',      Xin.UI.C.FG,...
        'units',                'pixels',...
        'Title',                'CAMERA CONTROL PANEL',...
        'Position',             [   S.PanelCurrentW     S.PanelCurrentH ...
                                    S.PanelCtrlWidth    S.PanelCtrlHeight]);

        % create rows of Empty Panelettes                      
        for i = 1:S.PaneletteRowNum
            for j = 1:S.PaneletteColumnNum
                Xin.UI.FigPGC(N).Panelette{i,j}.hPanelette = uipanel(...
                'parent', Xin.UI.FigPGC(N).hPanelCtrl,...
                'BackgroundColor', 	Xin.UI.C.BG,...
                'Highlightcolor',  	Xin.UI.C.HL,...
                'ForegroundColor',	Xin.UI.C.FG,...
                'units','pixels',...
                'Title', ' ',...
                'Position',[S.SD+(S.S+S.PaneletteWidth)*(j-1),...
                            S.SD+(S.S+S.PaneletteHeight)*(i-1),...
                            S.PaneletteWidth, S.PaneletteHeight]);
                        % edge is 2*S.S
            end
        end
    
%% UI ImagePanel 

    % Image Scale
    S.AxesImageWidth =      Xin.D.Sys.PointGreyCam(N).DispWidth;
    S.AxesImageHeight =     Xin.D.Sys.PointGreyCam(N).DispHeight;
    
    % Image Panel Scale
    S.PanelImageWidth =     S.SD + S.AxesImageWidth + S.SD + S.S;
    S.PanelImageHeight =    S.SD + S.AxesImageHeight + S.PaneletteTitle;

    
    % create the Control Panel
    S.PanelCurrentW =       S.PanelCurrentW + S.PanelCtrlWidth + S.SD;
    S.PanelCurrentH =       S.SD;
    
    S.FigWidthT =           max(S.FigWidthT,    S.PanelCurrentW + S.PanelImageWidth + S.SD);
    S.FigHeightT =          max(S.FigHeightT,   S.PanelCurrentH + S.PanelImageHeight + S.SD);
    
    Xin.UI.FigPGC(N).hPanelImage = uipanel(...
        'parent',           Xin.UI.FigPGC(N).hFig,...
        'BackgroundColor',  Xin.UI.C.BG,...
        'Highlightcolor',   Xin.UI.C.HL,...
        'ForegroundColor',  Xin.UI.C.FG,...
        'units',            'pixels',...
        'Title',            'IMAGE PANEL',...
        'Position',         [   S.PanelCurrentW,     S.PanelCurrentH, ...
                                S.PanelImageWidth,	S.PanelImageHeight]);
         % create the ImageHide Axes
        Xin.UI.FigPGC(N).hAxesImageHide = axes(...
            'parent',       Xin.UI.FigPGC(N).hPanelImage,...
            'units',        'pixels',...
            'Position',     [   S.SD               	S.SD   ...              
                                8                   5],...
            'XLimMode',     'Manual',...
            'YLimMode',     'Manual',...
            'ZLimMode',     'Manual',...
            'CLimMode',     'Manual',...
            'ALimMode',     'Manual',...
            'Visible',      'Off');
        Xin.UI.FigPGC(N).hImageHide = imshow(uint8(zeros(5,8)),...
            'Parent',       Xin.UI.FigPGC(N).hAxesImageHide); 
        
        % create the Image Axes
        Xin.UI.FigPGC(N).hAxesImage = axes(...
            'parent',       Xin.UI.FigPGC(N).hPanelImage,...
            'units',        'pixels',...
            'Position',     [   S.SD               	S.SD   ...              
                                S.AxesImageWidth    S.AxesImageHeight],...
            'XLimMode',     'Manual',...
            'YLimMode',     'Manual',...
            'ZLimMode',     'Manual',...
            'CLimMode',     'Manual',...
            'ALimMode',     'Manual');
        Xin.UI.FigPGC(N).hImage = imshow(Xin.D.Sys.PointGreyCam(N).DispImg,...
            'parent',       Xin.UI.FigPGC(N).hAxesImage);                   

%% Rest Figure Size
set(Xin.UI.FigPGC(N).hFig,...
            'Position',     [   S.FigSideWidth,	S.FigSideWidth,...
                                S.FigWidthT,    S.FigHeightT]);    
%% UI Panelettes   
S.PnltCurrent.row = 5;      S.PnltCurrent.column = 1;              
	WP.name = 'Sys CamShutter';
        WP.handleseed =	['Xin.UI.FigPGC(', num2str(N), ').Panelette'];
        WP.type =       'Potentiometer';	
        WP.row =        S.PnltCurrent.row;
        WP.column =     S.PnltCurrent.column;
            S.PnltCurrent.column = S.PnltCurrent.column + 1;  
        WP.text = 	{   ['Cam shutter: [', sprintf('%4.2f ', Xin.D.Sys.PointGreyCam(N).ShutterRange), '] (ms)']};
        WP.tip =    {   ['Cam shutter: [', sprintf('%4.2f ', Xin.D.Sys.PointGreyCam(N).ShutterRange), '] (ms)']};
        WP.inputValue =     Xin.D.Sys.PointGreyCam(N).Shutter;
        WP.inputRange =     Xin.D.Sys.PointGreyCam(N).ShutterRange;
        WP.inputSlideStep=  [0.01 0.1];
        Panelette(S, WP, 'Xin');
        Xin.UI.FigPGC(N).CP.hSys_CamShutter_PotenSlider =  	Xin.UI.FigPGC(N).Panelette{WP.row,WP.column}.hSlider{1};
        Xin.UI.FigPGC(N).CP.hSys_CamShutter_PotenEdit =    	Xin.UI.FigPGC(N).Panelette{WP.row,WP.column}.hEdit{1};
        set(Xin.UI.FigPGC(N).CP.hSys_CamShutter_PotenSlider,	'UserData',     N);
        set(Xin.UI.FigPGC(N).CP.hSys_CamShutter_PotenEdit,      'UserData',     N);
        clear WP;
        
  	WP.name = 'Sys CamGain';
        WP.handleseed =	['Xin.UI.FigPGC(', num2str(N), ').Panelette'];
        WP.type =       'Potentiometer';	
        WP.row =        S.PnltCurrent.row;
        WP.column =     S.PnltCurrent.column;
            S.PnltCurrent.column = S.PnltCurrent.column + 1;  
        WP.text = 	{   ['Cam gain: [', sprintf('%5.3f ',  Xin.D.Sys.PointGreyCam(N).GainRange), '] (dB)']};
        WP.tip =    {   ['Cam gain: [', sprintf('%5.3f ', Xin.D.Sys.PointGreyCam(N).GainRange), '] (dB)']};
        WP.inputValue =     Xin.D.Sys.PointGreyCam(N).Gain;
        WP.inputRange =     Xin.D.Sys.PointGreyCam(N).GainRange;
        WP.inputSlideStep=  [0.01 0.1];
        Panelette(S, WP, 'Xin');
        Xin.UI.FigPGC(N).CP.hSys_CamGain_PotenSlider =        Xin.UI.FigPGC(N).Panelette{WP.row,WP.column}.hSlider{1};
        Xin.UI.FigPGC(N).CP.hSys_CamGain_PotenEdit =          Xin.UI.FigPGC(N).Panelette{WP.row,WP.column}.hEdit{1};
        set(Xin.UI.FigPGC(N).CP.hSys_CamGain_PotenSlider,	'UserData',     N);
        set(Xin.UI.FigPGC(N).CP.hSys_CamGain_PotenEdit,     'UserData',     N);
        clear WP;
        
% 	WP.name = 'WhiteBalance R';
%         WP.handleseed =	['Xin.UI.FigPGC(', num2str(N), ').Panelette'];
%         WP.type =       'Potentiometer';	
%         WP.row =        S.PnltCurrent.row;
%         WP.column =     S.PnltCurrent.column;
%             S.PnltCurrent.column = S.PnltCurrent.column + 1;  
%         WP.text = 	{   'WhiteBalance R'};
%         WP.tip =    {   'WhiteBalance R'};
%         WP.inputValue =     CameraD.WhiteBalanceRB_Default(1);
%         WP.inputRange =     CameraD.WhiteBalanceRB_Range;
%         WP.inputSlideStep=  [0.01 0.1];
%         Panelette(S, WP, 'Xin');
%         Xin.UI.FigPGC(N).CP.hSys_CamWhiteBalanceR_PotenSlider = 	Xin.UI.FigPGC(N).Panelette{WP.row,WP.column}.hSlider{1};
%         Xin.UI.FigPGC(N).CP.hSys_CamWhiteBalanceR_PotenEdit =   	Xin.UI.FigPGC(N).Panelette{WP.row,WP.column}.hEdit{1};
%         clear WP;
%         
% 	WP.name = 'WhiteBalance B';
%         WP.handleseed =	['Xin.UI.FigPGC(', num2str(N), ').Panelette'];
%         WP.type =       'Potentiometer';	
%         WP.row =        S.PnltCurrent.row;
%         WP.column =     S.PnltCurrent.column;
%             S.PnltCurrent.column = S.PnltCurrent.column + 1;   
%         WP.text = 	{   'WhiteBalance B'};
%         WP.tip =    {   'WhiteBalance B'};
%         WP.inputValue =     CameraD.WhiteBalanceRB_Default(2);
%         WP.inputRange =     CameraD.WhiteBalanceRB_Range;
%         WP.inputSlideStep=  [0.01 0.1];
%         Panelette(S, WP, 'Xin');
%         Xin.UI.FigPGC(N).CP.hSys_CamWhiteBalanceB_PotenSlider = 	Xin.UI.FigPGC(N).Panelette{WP.row,WP.column}.hSlider{1};
%         Xin.UI.FigPGC(N).CP.hSys_CamWhiteBalanceB_PotenEdit =   	Xin.UI.FigPGC(N).Panelette{WP.row,WP.column}.hEdit{1};
%         clear WP;
% 
% 	WP.name = 'WhiteBalanceMode';
%         WP.handleseed = ['Xin.UI.FigPGC(', num2str(N), ').Panelette'];
%         WP.type = 'RockerSwitch';	
%         WP.row      = S.PnltCurrent.row;
%         WP.column   = S.PnltCurrent.column;
%             S.PnltCurrent.column = S.PnltCurrent.column + 1;
%         WP.text = { 'White Balance RB Mode'};
%         WP.tip = {  'White Balance RBMode'};
%         WP.inputOptions = {'Manual', 'Off', ''};
%         WP.inputDefault = 1;
%         Panelette(S, WP, 'Xin');
%         Xin.UI.FigPGC(N).CP.hSys_CamWhiteBalanceRB_Mode_Rocker =        Xin.UI.FigPGC(N).Panelette{WP.row,WP.column}.hRocker{1};
%         clear WP; 
 
S.PnltCurrent.row = 4;      S.PnltCurrent.column = 1;                                 
    WP.name = 'Mon DispGain';
        WP.handleseed =	['Xin.UI.FigPGC(', num2str(N), ').Panelette'];
        WP.type =       'Potentiometer';	
        WP.row =        S.PnltCurrent.row;
        WP.column =     S.PnltCurrent.column;
            S.PnltCurrent.column = S.PnltCurrent.column + 1;  
        WP.text = 	{   ['Cam frame bin: [', sprintf('%d ', Xin.D.Sys.PointGreyCamDispGainNumRange), '] (frames)']};
        WP.tip =    {   ['Cam frame bin: [', sprintf('%d ', Xin.D.Sys.PointGreyCamDispGainNumRange), '] (frames)']};
        WP.inputValue =     Xin.D.Sys.PointGreyCam(N).DispGainBit;
        WP.inputRange =     Xin.D.Sys.PointGreyCamDispGainBitRange([1, end]);
        WP.inputSlideStep=  1/diff(WP.inputRange)*[1 1];
        Panelette(S, WP, 'Xin');
        Xin.UI.FigPGC(N).CP.hSys_CamDispGain_PotenSlider =	Xin.UI.FigPGC(N).Panelette{WP.row,WP.column}.hSlider{1};
        Xin.UI.FigPGC(N).CP.hSys_CamDispGain_PotenEdit =   Xin.UI.FigPGC(N).Panelette{WP.row,WP.column}.hEdit{1};
        set(Xin.UI.FigPGC(N).CP.hSys_CamDispGain_PotenSlider,	'UserData',     N);
        set(Xin.UI.FigPGC(N).CP.hSys_CamDispGain_PotenEdit, 	'UserData',     N);
        clear WP;

S.PnltCurrent.row = 3;      S.PnltCurrent.column = 1;          
    WP.name = 'Exp RefImage';
        WP.handleseed = ['Xin.UI.FigPGC(', num2str(N), ').Panelette'];
        WP.type = 'MomentarySwitch'; 
        WP.row =        S.PnltCurrent.row;         
        WP.column =     S.PnltCurrent.column;
            S.PnltCurrent.column = S.PnltCurrent.column + 1;
        WP.text = { 'Take a reference image for the experiment',...
                    ''};
        WP.tip = {[ 'Take a reference image for the experiment',...
                    ''],...
                  [ 'Take a reference image for the experiment',...
                    ''] };
        WP.inputEnable = {'on','off'};
        Panelette(S, WP, 'Xin');
        Xin.UI.FigPGC(N).CP.hExp_RefImage_Momentary =	Xin.UI.FigPGC(N).Panelette{WP.row,WP.column}.hMomentary{1}; 
        set(Xin.UI.FigPGC(N).CP.hExp_RefImage_Momentary,	'UserData',     N);
        clear WP;       

S.PnltCurrent.row = 1;      S.PnltCurrent.column = 1;                
    WP.name = 'Mon PreviewSwt';
        WP.handleseed = ['Xin.UI.FigPGC(', num2str(N), ').Panelette'];
        WP.type = 'RockerSwitch';	
        WP.row      = S.PnltCurrent.row;
        WP.column   = S.PnltCurrent.column;
            S.PnltCurrent.column = S.PnltCurrent.column + 1;
        WP.text = { 'Preview Switch'};
        WP.tip = {  'Preview Switch'};
        WP.inputOptions = {'Preview ON', 'Preview OFF', ''};
        WP.inputDefault = 2;
        Panelette(S, WP, 'Xin');
        Xin.UI.FigPGC(N).CP.hMon_PreviewSwitch_Rocker =	Xin.UI.FigPGC(N).Panelette{WP.row,WP.column}.hRocker{1};      
        set(Xin.UI.FigPGC(N).CP.hMon_PreviewSwitch_Rocker,  'UserData',     N);
        clear WP;
         
  	WP.name = 'Mon FrmTiming';
        WP.handleseed =	['Xin.UI.FigPGC(', num2str(N), ').Panelette'];
        WP.type = 'Edit';           
        WP.row      = S.PnltCurrent.row;
        WP.column   = S.PnltCurrent.column;
            S.PnltCurrent.column = S.PnltCurrent.column + 1;     
        WP.text = {	'Previewing frame rate',...
                    'Previewing TimeStamp [HH:MM:SS.S]'};
        WP.tip = {	'Previewing frame rate',...
                    'Previewing TimeStamp [HH:MM:SS.S]'};
        WP.inputValue = {   Xin.D.Sys.PointGreyCam(N).PreviewStrFR,...
                            Xin.D.Sys.PointGreyCam(N).PreviewStrTS};
        WP.inputFormat = {'%s','%s'};    
        WP.inputEnable = {'off','off'};
        Panelette(S, WP, 'Xin');    
        Xin.UI.FigPGC(N).CP.hMon_CamPreviewFR_Edit =	Xin.UI.FigPGC(N).Panelette{WP.row,WP.column}.hEdit{1};
        Xin.UI.FigPGC(N).CP.hMon_CamPreviewTS_Edit =	Xin.UI.FigPGC(N).Panelette{WP.row,WP.column}.hEdit{2};
        clear WP;
        
% S.PnltCurrent.row = 1;      S.PnltCurrent.column = 1;                
%     WP.name = 'Mon ROI';
%         WP.handleseed = ['Xin.UI.FigPGC(', num2str(N), ').Panelette'];
%         WP.type = 'MomentarySwitch'; 
%         WP.row =        S.PnltCurrent.row;         
%         WP.column =     S.PnltCurrent.column;
%             S.PnltCurrent.column = S.PnltCurrent.column + 1;
%         WP.text = { 'Get a surface ref image BEFORE an experiment',...
%                     'Specify polygonal region of interest (ROI)'};
%         WP.tip = {[ 'Get a surface ref image BEFORE an experiment',...
%                     'Specify polygonal region of interest (ROI)'],...
%                   [ 'Get a surface ref image BEFORE an experiment',...
%                     'Specify polygonal region of interest (ROI)'] };
%         WP.inputEnable = {'on','on'};
%         Panelette(S, WP, 'Xin');
%         Xin.UI.FigPGC(N).CP.hExp_BeforeSurRef_Momentary =	Xin.UI.FigPGC(N).Panelette{WP.row,WP.column}.hMomentary{1}; 
%         Xin.UI.FigPGC(N).CP.hExp_BeforeSurROI_Momentary =	Xin.UI.FigPGC(N).Panelette{WP.row,WP.column}.hMomentary{2}; 
%         set(Xin.UI.FigPGC(N).CP.hExp_BeforeSurRef_Momentary,	'tag', 'hExp_BeforeSurRef_Momentary');
%         set(Xin.UI.FigPGC(N).CP.hExp_BeforeSurROI_Momentary,	'tag', 'hExp_BeforeSurROI_Momentary');
%         clear WP;       
%          
%     WP.name = 'Mon DisplayMode';
%         WP.handleseed = ['Xin.UI.FigPGC(', num2str(N), ').Panelette'];
%         WP.type = 'RockerSwitch';	
%         WP.row      = S.PnltCurrent.row;
%         WP.column   = S.PnltCurrent.column;
%             S.PnltCurrent.column = S.PnltCurrent.column + 1;
%         WP.text = { 'Display Mode'};
%         WP.tip = {  'Display Mode'};
%         WP.inputOptions = {'Full Frame', 'ROI only', ''};
%         WP.inputDefault = 1;
%         Panelette(S, WP, 'Xin');
%         Xin.UI.FigPGC(N).CP.hMon_DisplayMode_Rocker =	Xin.UI.FigPGC(N).Panelette{WP.row,WP.column}.hRocker{1};
%         a = get(Xin.UI.FigPGC(N).CP.hMon_DisplayMode_Rocker, 'Children');
%         set(a(2), 'Enable', 'inactive');        
%         clear WP;          

        
%     WP.name = 'Sys CamFrameRate';
%         WP.handleseed =	['Xin.UI.FigPGC(', num2str(N), ').Panelette'];
%         WP.type =       'Potentiometer';	
%         WP.row =        S.PnltCurrent.row;
%         WP.column =     S.PnltCurrent.column;
%             S.PnltCurrent.column = S.PnltCurrent.column + 1;  
%         WP.text = 	{   ['(FPS) Choose from: ', sprintf('%d,', Xin.D.Sys.PointGreyCam(N).FrameRateRange)]};
%         WP.tip =    {   ['(FPS) Choose from: ', sprintf('%d,', Xin.D.Sys.PointGreyCam(N).FrameRateRange)]};
%         WP.inputValue =     Xin.D.Sys.PointGreyCam(N).FrameRate;
%         WP.inputRange =     Xin.D.Sys.PointGreyCam(N).FrameRateRange;
%         WP.inputSlideStep=  min(diff(WP.inputRange))/sum(diff(WP.inputRange))*[1 1];
%         Panelette(S, WP, 'Xin');
%         Xin.UI.FigPGC(N).CP.hSys_CamFrameRate_PotenSlider =	Xin.UI.FigPGC(N).Panelette{WP.row,WP.column}.hSlider{1};
%         Xin.UI.FigPGC(N).CP.hSys_CamFrameRate_PotenEdit =   	Xin.UI.FigPGC(N).Panelette{WP.row,WP.column}.hEdit{1};
%         clear WP;    
        
%% Turn the JAVA LookAndFeel Scheme on "Windows"
%     javax.swing.UIManager.setLookAndFeel('com.sun.java.swing.plaf.windows.WindowsLookAndFeel');

%% LOG MSG
msg = [datestr(now, 'yy/mm/dd HH:MM:SS.FFF') '\tSetupFigurePointGrey\tSetup the GUI for PointGrey Camera #:',...
    num2str(N) ,'\r\n'];
updateMsg(Xin.D.Exp.hLog, msg);