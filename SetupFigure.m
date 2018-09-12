function msg = SetupFigure(varargin)
% The GUI code for Xintrinsic Setup

global Xin

%% UI Color
S.Color.BG =        [   0       0       0];
S.Color.HL =        [   0       0       0];
S.Color.FG =        [   0.6     0.6     0.6];    
S.Color.TextBG =    [   0.25    0.25    0.25];
S.Color.SelectB =  	[   0       0       0.35];
S.Color.SelectT =  	[   0       0       0.35];

Xin.UI.C = S.Color;

%% UI Figure
    % Screen Scale 
    MonitorPositions =  get(0,'MonitorPositions');
    S.ScreenEnds = [    min(MonitorPositions(:,1)) min(MonitorPositions(:,2)) ...
                        max(MonitorPositions(:,3)) max(MonitorPositions(:,4))];
    S.ScreenWidth =     S.ScreenEnds(3) - S.ScreenEnds(1) +1;
    S.ScreenHeight =    S.ScreenEnds(4) - S.ScreenEnds(2) +1;
                                        
    % Figure scale
    S.FigSideTitleHeight = 30; 	
    S.FigSideToolbarWidth = 60;
    S.FigSideWidth = 20; 
%     S.FigSideWidth = 8; 

    S.FigWidth =        1250;
    S.FigHeight =       1110;
%     S.FigWidth =        S.ScreenWidth - 2*S.FigSideWidth - S.FigSideToolbarWidth;
%     S.FigHeight =       S.ScreenHeight - S.FigSideTitleHeight - S.FigSideWidth;

    % create the UI figure 
    Xin.UI.H0.hFig= figure(...
        'Name',         Xin.D.Sys.FigureTitle,...
        'NumberTitle',  'off',...
        'Resize',       'off',...
        'color',        S.Color.BG,...
        'position',     [   S.FigSideWidth,	S.FigSideWidth,...
                            S.FigWidth,     S.FigHeight],...
        'menubar',      'none',...
        'doublebuffer', 'off');
  
%% UI ImagePanel 
    % Global Spacer Scale
    S.SP = 10;          % Panelette Side Spacer
    S.SD = 4;           % Side Double Spacer
    S.S = 2;            % Small Spacer 
    S.PaneletteTitle = 18;

    % Image Scale
    S.AxesImageHeight =     Xin.D.Sys.PointGreyCam(2).DispHeight;
    S.AxesImageWidth =      Xin.D.Sys.PointGreyCam(2).DispWidth;
    S.AxesHistHeight =      256;
    
    % Image Panel Scale
    S.PanelImageWidth =     S.SD + S.AxesImageWidth + ...
                            S.SD + S.AxesHistHeight + S.SD + S.S;
    S.PanelImageHeight =    S.SD + S.AxesImageHeight + S.PaneletteTitle;

    % create the Image Panel
    S.PanelCurrentW = S.SD;
    S.PanelCurrentH = S.SD;
    Xin.UI.H0.hPanelImage = uipanel(...
        'parent',           Xin.UI.H0.hFig,...
        'BackgroundColor',  S.Color.BG,...
        'Highlightcolor',   S.Color.HL,...
        'ForegroundColor',  S.Color.FG,...
        'units',            'pixels',...
        'Title',            'IMAGE PANEL',...
        'Position',         [   S.PanelCurrentW     S.PanelCurrentH ...
                                S.PanelImageWidth	S.PanelImageHeight]);
         % create the ImageHide Axes
        Xin.UI.H0.hAxesImageHide = axes(...
            'parent',       Xin.UI.H0.hPanelImage,...
            'units',        'pixels',...
            'Position',     [   S.SD               	S.SD   ...              
                                8                   5],...
            'XLimMode',     'Manual',...
            'YLimMode',     'Manual',...
            'ZLimMode',     'Manual',...
            'CLimMode',     'Manual',...
            'ALimMode',     'Manual',...
            'Visible',      'Off');
        Xin.UI.H0.hImageHide = imshow(uint8(zeros(5,8)),...
            'parent',       Xin.UI.H0.hAxesImageHide); 
        
        % create the Image Axes
        Xin.UI.H0.hAxesImage = axes(...
            'parent',       Xin.UI.H0.hPanelImage,...
            'units',        'pixels',...
            'Position',     [   S.SD               	S.SD   ...              
                                S.AxesImageWidth    S.AxesImageHeight],...
            'XLimMode',     'Manual',...
            'YLimMode',     'Manual',...
            'ZLimMode',     'Manual',...
            'CLimMode',     'Manual',...
            'ALimMode',     'Manual');
        Xin.UI.H0.hImage = imshow(Xin.D.Sys.PointGreyCam(2).DispImg,...
            'parent',       Xin.UI.H0.hAxesImage); 
        
        % create the Hist Axes
        Xin.UI.H0.hAxesHist = axes(...
            'parent',       Xin.UI.H0.hPanelImage,...
            'units',        'pixels',...
            'Position',     [   S.SD + S.AxesImageWidth + S.SD  S.SD   ...              
                                S.AxesHistHeight    S.AxesImageHeight],...
            'XLimMode',     'Manual',...
            'YLimMode',     'Manual',...
            'ZLimMode',     'Manual',...
            'CLimMode',     'Manual',...
            'ALimMode',     'Manual',...
            'Box',          'On',...
            'Color',        [0 0 0],...
            'NextPlot',     'Add',...
            'View',         [90 90],...
            'XColor',       S.Color.FG,...            
            'XLim',         [1 length(Xin.D.Sys.PointGreyCam(2).DispHistMax)],...
            'XTick',        [],...
            'YColor',       S.Color.FG,...
            'YGrid',        'On',...
            'YLim',         [0 255],...
            'YTick',        0:32:224,...
            'YTickLabel',   {});
     	Xin.UI.H0.hHistMax =    plot(Xin.D.Sys.PointGreyCam(2).DispHistMax,     '-',...
            'parent',       Xin.UI.H0.hAxesHist,...
            'Color',        S.Color.FG); 
     	Xin.UI.H0.hHistMean =   plot(Xin.D.Sys.PointGreyCam(2).DispHistMean,	'.-',...
            'parent',       Xin.UI.H0.hAxesHist,...
            'Color',        S.Color.FG);                     
     	Xin.UI.H0.hHistMin =    plot(Xin.D.Sys.PointGreyCam(2).DispHistMin,     '--',...
            'parent',       Xin.UI.H0.hAxesHist,...
            'Color',        S.Color.FG); 
                    
                    
%% UI Control Panel
    % Panelette Scale
    S.PaneletteWidth = 100;         S.PaneletteHeight = 150;    
    S.PaneletteTitle = 18;

    % Panelette #
    S.PaneletteRowNum = 3;          S.PaneletteColumnNum = 12;
    
    % Control Panel Scale 
    S.PanelCtrlWidth =  S.PaneletteColumnNum *(S.PaneletteWidth+S.S) + 2*S.SD;
    S.PanelCtrlHeight = S.PaneletteRowNum *(S.PaneletteHeight+S.S) + S.PaneletteTitle;
    
    % create the Control Panel
    S.PanelCurrentW = S.PanelCurrentW;% +  S.SD;
    S.PanelCurrentH = S.PanelCurrentH+  S.PanelImageHeight+   S.SD;
    Xin.UI.H0.hPanelCtrl = uipanel(...
        'parent',               Xin.UI.H0.hFig,...
        'BackgroundColor',      S.Color.BG,...
        'Highlightcolor',       S.Color.HL,...
        'ForegroundColor',      S.Color.FG,...
        'units',                'pixels',...
        'Title',                'CAMERA CONTROL PANEL',...
        'Position',             [   S.PanelCurrentW     S.PanelCurrentH ...
                                    S.PanelCtrlWidth    S.PanelCtrlHeight]);

        % create rows of Empty Panelettes                      
        for i = 1:S.PaneletteRowNum
            for j = 1:S.PaneletteColumnNum
                Xin.UI.H0.Panelette{i,j}.hPanelette = uipanel(...
                'parent', Xin.UI.H0.hPanelCtrl,...
                'BackgroundColor', 	S.Color.BG,...
                'Highlightcolor',  	S.Color.HL,...
                'ForegroundColor',	S.Color.FG,...
                'units','pixels',...
                'Title', ' ',...
                'Position',[S.SD+(S.S+S.PaneletteWidth)*(j-1),...
                            S.SD+(S.S+S.PaneletteHeight)*(i-1),...
                            S.PaneletteWidth, S.PaneletteHeight]);
                        % edge is 2*S.S
            end
        end
        
%% UI Panelettes   
S.PnltCurrent.row = 3;      S.PnltCurrent.column = 1;                
 	WP.name = 'Sys LightSource';
        WP.handleseed = 'Xin.UI.H0.Panelette';
        WP.type = 'ToggleSwitch';	
        WP.row      = S.PnltCurrent.row;
        WP.column   = S.PnltCurrent.column;
            S.PnltCurrent.column = S.PnltCurrent.column + 1;
        WP.text = { 'LED ', 'light source'};
        WP.tip = {  'LED ', 'light source'};
        WP.inputOptions = {'Red', 'Green', ''; 'Blue', 'White', ''};
        WP.inputDefault = [1, 0];
        Panelette(S, WP, 'Xin');
        Xin.UI.H.hSys_LightSource_Toggle1 =   	Xin.UI.H0.Panelette{WP.row,WP.column}.hToggle{1};
        Xin.UI.H.hSys_LightSource_Toggle2 =   	Xin.UI.H0.Panelette{WP.row,WP.column}.hToggle{2};
        set(Xin.UI.H.hSys_LightSource_Toggle1,  'Tag', 'hSys_LightSource_Toggle1');
        set(Xin.UI.H.hSys_LightSource_Toggle2,  'Tag', 'hSys_LightSource_Toggle2');
        clear WP;
         
	WP.name = 'Sys LightPort';
        WP.handleseed = 'Xin.UI.H0.Panelette';
        WP.type = 'RockerSwitch';	
        WP.row      = S.PnltCurrent.row;
        WP.column   = S.PnltCurrent.column;
            S.PnltCurrent.column = S.PnltCurrent.column + 1;
        WP.text = { 'LED light port selection'};
        WP.tip = {  'LED light port selection'};
        WP.inputOptions = {'Koehler', 'Ring', ''};
        WP.inputDefault = 1;
        Panelette(S, WP, 'Xin');
        Xin.UI.H.hSys_LightPort_Rocker =     	Xin.UI.H0.Panelette{WP.row,WP.column}.hRocker{1};
        set(Xin.UI.H.hSys_LightPort_Rocker, 'Tag',  'hSys_LightPort_Rocker');
        clear WP;
        
	WP.name = 'Sys HeadCube';
        WP.handleseed = 'Xin.UI.H0.Panelette';
        WP.type = 'RockerSwitch';	
        WP.row      = S.PnltCurrent.row;
        WP.column   = S.PnltCurrent.column;
            S.PnltCurrent.column = S.PnltCurrent.column + 1;
        WP.text = { 'Imaging head cube selection'};
        WP.tip = {  'Imaging head cube selection'};
        WP.inputOptions = {'Pola_PBS', 'Fluo_GFP', 'Fluo_mKO'};
        WP.inputDefault = 1;
        Panelette(S, WP, 'Xin');
        Xin.UI.H.hSys_HeadCube_Rocker =     	Xin.UI.H0.Panelette{WP.row,WP.column}.hRocker{1};
        set(Xin.UI.H.hSys_HeadCube_Rocker, 'Tag',  'hSys_HeadCube_Rocker');
        clear WP;     

	WP.name = 'Sys CamShutter';
        WP.handleseed =	'Xin.UI.H0.Panelette';
        WP.type =       'Potentiometer';	
        WP.row =        S.PnltCurrent.row;
        WP.column =     S.PnltCurrent.column;
            S.PnltCurrent.column = S.PnltCurrent.column + 1;  
        WP.text = 	{   ['Cam shutter: [', sprintf('%4.2f ', Xin.D.Sys.PointGreyCam(2).ShutterRange), '] (ms)']};
        WP.tip =    {   ['Cam shutter: [', sprintf('%4.2f ', Xin.D.Sys.PointGreyCam(2).ShutterRange), '] (ms)']};
        WP.inputValue =     Xin.D.Sys.PointGreyCam(2).Shutter;
        WP.inputRange =     Xin.D.Sys.PointGreyCam(2).ShutterRange;
        WP.inputSlideStep=  [0.01 0.1];
        Panelette(S, WP, 'Xin');
        Xin.UI.H.hSys_CamShutter_PotenSlider =  	Xin.UI.H0.Panelette{WP.row,WP.column}.hSlider{1};
        Xin.UI.H.hSys_CamShutter_PotenEdit =    	Xin.UI.H0.Panelette{WP.row,WP.column}.hEdit{1};
        clear WP;
        
  	WP.name = 'Sys CamGain';
        WP.handleseed =	'Xin.UI.H0.Panelette';
        WP.type =       'Potentiometer';	
        WP.row =        S.PnltCurrent.row;
        WP.column =     S.PnltCurrent.column;
            S.PnltCurrent.column = S.PnltCurrent.column + 1;  
        WP.text = 	{   ['Cam gain: [', sprintf('%5.3f ', Xin.D.Sys.PointGreyCam(2).GainRange), '] (dB)']};
        WP.tip =    {   ['Cam gain: [', sprintf('%5.3f ', Xin.D.Sys.PointGreyCam(2).GainRange), '] (dB)']};
        WP.inputValue =     Xin.D.Sys.PointGreyCam(2).Gain;
        WP.inputRange =     Xin.D.Sys.PointGreyCam(2).GainRange;
        WP.inputSlideStep=  [0.01 0.1];
        Panelette(S, WP, 'Xin');
        Xin.UI.H.hSys_CamGain_PotenSlider =        Xin.UI.H0.Panelette{WP.row,WP.column}.hSlider{1};
        Xin.UI.H.hSys_CamGain_PotenEdit =          Xin.UI.H0.Panelette{WP.row,WP.column}.hEdit{1};
        clear WP;
        
    WP.name = 'Sys CamDispGain';
        WP.handleseed =	'Xin.UI.H0.Panelette';
        WP.type =       'Potentiometer';	
        WP.row =        S.PnltCurrent.row;
        WP.column =     S.PnltCurrent.column;
            S.PnltCurrent.column = S.PnltCurrent.column + 1;  
        WP.text = 	{   ['Cam frame bin: [', sprintf('%d ', Xin.D.Sys.PointGreyCamDispGainNumRange), '] (frames)']};
        WP.tip =    {   ['Cam frame bin: [', sprintf('%d ', Xin.D.Sys.PointGreyCamDispGainNumRange), '] (frames)']};
        WP.inputRange =     Xin.D.Sys.PointGreyCamDispGainBitRange;
        WP.inputSlideStep=  min(diff(WP.inputRange))/sum(diff(WP.inputRange))*[1 1];
        Panelette(S, WP, 'Xin');
        Xin.UI.H.hSys_CamDispGain_PotenSlider = Xin.UI.H0.Panelette{WP.row,WP.column}.hSlider{1};
        Xin.UI.H.hSys_CamDispGain_PotenEdit =   Xin.UI.H0.Panelette{WP.row,WP.column}.hEdit{1};
        clear WP;    
        
% 	WP.name = 'WhiteBalance R';
%         WP.handleseed =	'Xin.UI.H0.Panelette';
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
%         Xin.UI.H.hSys_CamWhiteBalanceR_PotenSlider = 	Xin.UI.H0.Panelette{WP.row,WP.column}.hSlider{1};
%         Xin.UI.H.hSys_CamWhiteBalanceR_PotenEdit =   	Xin.UI.H0.Panelette{WP.row,WP.column}.hEdit{1};
%         clear WP;
%         
% 	WP.name = 'WhiteBalance B';
%         WP.handleseed =	'Xin.UI.H0.Panelette';
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
%         Xin.UI.H.hSys_CamWhiteBalanceB_PotenSlider = 	Xin.UI.H0.Panelette{WP.row,WP.column}.hSlider{1};
%         Xin.UI.H.hSys_CamWhiteBalanceB_PotenEdit =   	Xin.UI.H0.Panelette{WP.row,WP.column}.hEdit{1};
%         clear WP;
% 
% 	WP.name = 'WhiteBalanceMode';
%         WP.handleseed = 'Xin.UI.H0.Panelette';
%         WP.type = 'RockerSwitch';	
%         WP.row      = S.PnltCurrent.row;
%         WP.column   = S.PnltCurrent.column;
%             S.PnltCurrent.column = S.PnltCurrent.column + 1;
%         WP.text = { 'White Balance RB Mode'};
%         WP.tip = {  'White Balance RBMode'};
%         WP.inputOptions = {'Manual', 'Off', ''};
%         WP.inputDefault = 1;
%         Panelette(S, WP, 'Xin');
%         Xin.UI.H.hSys_CamWhiteBalanceRB_Mode_Rocker =        Xin.UI.H0.Panelette{WP.row,WP.column}.hRocker{1};
%         clear WP; 
 
S.PnltCurrent.row = 3;      S.PnltCurrent.column = 8;     
	WP.name = 'Mky Monkey#';
        WP.handleseed = 'Xin.UI.H0.Panelette';
        WP.type = 'ToggleSwitch';	
        WP.row      = S.PnltCurrent.row;
        WP.column   = S.PnltCurrent.column;
            S.PnltCurrent.column = S.PnltCurrent.column + 1;
        WP.text = { 'Animal', 'ID'};
        WP.tip = {  'Animal', 'ID'};
        WP.inputOptions = Xin.D.Mky.Lists.ID;
        WP.inputDefault = [1, 0];
        Panelette(S, WP, 'Xin');
        Xin.UI.H.hMky_ID_Toggle1 =   	Xin.UI.H0.Panelette{WP.row,WP.column}.hToggle{1};
        Xin.UI.H.hMky_ID_Toggle2 =   	Xin.UI.H0.Panelette{WP.row,WP.column}.hToggle{2};
        set(Xin.UI.H.hMky_ID_Toggle1, 'Tag',    'hMky_ID_Toggle1');
        set(Xin.UI.H.hMky_ID_Toggle2, 'Tag',    'hMky_ID_Toggle2');
        clear WP;
        
	WP.name = 'Mky Side';
        WP.handleseed = 'Xin.UI.H0.Panelette';
        WP.type = 'RockerSwitch';	
        WP.row      = S.PnltCurrent.row;
        WP.column   = S.PnltCurrent.column;
            S.PnltCurrent.column = S.PnltCurrent.column + 1;
        WP.text = { 'LEFT or RIHGT hemesphere'};
        WP.tip = {  'LEFT or RIHGT hemesphere'};
        WP.inputOptions = Xin.D.Mky.Lists.Side;
        WP.inputDefault = 1;
        Panelette(S, WP, 'Xin');
        Xin.UI.H.hMky_Side_Rocker =     Xin.UI.H0.Panelette{WP.row,WP.column}.hRocker{1};
        set(Xin.UI.H.hMky_Side_Rocker,  'Tag',  'hMky_Side_Rocker');
        clear WP;       

S.PnltCurrent.row = 3;      S.PnltCurrent.column = 11;        
  	WP.name = 'Exp RefImage';
        WP.handleseed = 'Xin.UI.H0.Panelette';
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
        Xin.UI.H.hExp_RefImage_Momentary =	Xin.UI.H0.Panelette{WP.row,WP.column}.hMomentary{1}; 
        set(Xin.UI.H.hExp_RefImage_Momentary,	'tag', 'hExp_RefImage_Momentary');
        clear WP;        
        
	WP.name = 'Exp Time&Depth';
        WP.handleseed = 'Xin.UI.H0.Panelette';
        WP.type =       'Edit';          
        WP.row =        S.PnltCurrent.row;         
        WP.column =     S.PnltCurrent.column;
            S.PnltCurrent.column = S.PnltCurrent.column + 1;
        WP.text = {	'Depth \n(in LT1 fine turns)',...
                    'Experiment date [yymmdd-HH]'};
        WP.tip = WP.text; 
        WP.inputValue = {   Xin.D.Exp.Depth,...
                            Xin.D.Exp.DateStr};    
        WP.inputFormat = {'%5.2f','%s'};
        WP.inputEnable = {'on','off'};
        Panelette(S, WP, 'Xin');    
        Xin.UI.H.hExp_Depth_Edit =	Xin.UI.H0.Panelette{WP.row,WP.column}.hEdit{1};
        Xin.UI.H.hExp_Date_Edit =	Xin.UI.H0.Panelette{WP.row,WP.column}.hEdit{2};
        set(Xin.UI.H.hExp_Depth_Edit,	'tag', 'hExp_Depth_Edit');
        set(Xin.UI.H.hExp_Date_Edit,	'tag', 'hExp_Date_Edit');
        clear WP;  
               
S.PnltCurrent.row = 2;      S.PnltCurrent.column = 1;
	WP.name = 'Ses Load&Start';
        WP.handleseed = 'Xin.UI.H0.Panelette';
        WP.type = 'MomentarySwitch'; 
        WP.row =        S.PnltCurrent.row;         
        WP.column =     S.PnltCurrent.column;
            S.PnltCurrent.column = S.PnltCurrent.column + 1;
        WP.text = { 'Load SOUND for the session',...
                    'Start the session'};
        WP.tip = {[ 'Load SOUND for the session',...
                    'Start the session'],...
                  [ 'Load SOUND for the session',...
                    'Start the session'] };
        WP.inputEnable = {'on','off'};
        Panelette(S, WP, 'Xin');
        Xin.UI.H.hSes_Load_Momentary =      Xin.UI.H0.Panelette{WP.row,WP.column}.hMomentary{1}; 
        Xin.UI.H.hSes_Start_Momentary =     Xin.UI.H0.Panelette{WP.row,WP.column}.hMomentary{2};
        set(Xin.UI.H.hSes_Load_Momentary,   'tag', 'hSes_Load_Momentary');
        set(Xin.UI.H.hSes_Start_Momentary,	'tag', 'hSes_Start_Momentary');
        clear WP; 
        
 	WP.name = 'Ses TrlOrder';
        WP.handleseed = 'Xin.UI.H0.Panelette';
        WP.type = 'RockerSwitch';	
        WP.row      = S.PnltCurrent.row;
        WP.column   = S.PnltCurrent.column;
            S.PnltCurrent.column = S.PnltCurrent.column + 1;
        WP.text = { 'Trial Order'};
        WP.tip = {  'Trial Order'};
        WP.inputOptions = {'Sequential', 'Randomized', ''};
        WP.inputDefault = 1;
        Panelette(S, WP, 'Xin');
        Xin.UI.H.hSes_TrlOrder_Rocker =	Xin.UI.H0.Panelette{WP.row,WP.column}.hRocker{1};
        set(Xin.UI.H.hSes_TrlOrder_Rocker,  'Tag',  'hSes_TrlOrder_Rocker');
        clear WP;        
        
  	WP.name = 'Ses CycleNum';
        WP.handleseed =	'Xin.UI.H0.Panelette';
        WP.type = 'Edit';           
        WP.row      = S.PnltCurrent.row;
        WP.column   = S.PnltCurrent.column;
            S.PnltCurrent.column = S.PnltCurrent.column + 1;     
        WP.text = {	'Cycle Num Current (cycle)',...
                    'Cycle Num Total (cycle)'};
        WP.tip = {	'Cycle Num Current (cycle)',...
                    'Cycle Num Total (cycle)'};
        WP.inputValue = {   Xin.D.Ses.Load.CycleNumCurrent,...
                            Xin.D.Ses.Load.CycleNumTotal};
        WP.inputFormat = {'%d','%d'};    
        WP.inputEnable = {'off','on'};
        Panelette(S, WP, 'Xin');    
        Xin.UI.H.hSes_CycleNumCurrent_Edit =	Xin.UI.H0.Panelette{WP.row,WP.column}.hEdit{1};
        Xin.UI.H.hSes_CycleNumTotal_Edit =      Xin.UI.H0.Panelette{WP.row,WP.column}.hEdit{2};
        set(Xin.UI.H.hSes_CycleNumCurrent_Edit,	'Tag', 'hSes_CycleNumCurrent_Edit');
        set(Xin.UI.H.hSes_CycleNumTotal_Edit,	'Tag', 'hSes_CycleNumTotal_Edit');
        clear WP;      
    
	WP.name = 'Ses AddAtt';
        WP.handleseed =	'Xin.UI.H0.Panelette';
        WP.type = 'Edit';           
        WP.row      = S.PnltCurrent.row;
        WP.column   = S.PnltCurrent.column;
            S.PnltCurrent.column = S.PnltCurrent.column + 1;     
        WP.text = {	'Additional Attenuations (dB)',...
                    'Additional Attenuation Number Total'};
        WP.tip = {	'Additional Attenuations (dB)',...
                    'Additional Attenuation Number Total'};
        WP.inputValue = {   Xin.D.Ses.Load.AddAtts,...
                            Xin.D.Ses.Load.AddAttNumTotal};
        WP.inputFormat = {'%d','%d'};    
        WP.inputEnable = {'on','off'};
        Panelette(S, WP, 'Xin');    
        Xin.UI.H.hSes_AddAtts_Edit =            Xin.UI.H0.Panelette{WP.row,WP.column}.hEdit{1};
        Xin.UI.H.hSes_AddAttNumTotal_Edit =     Xin.UI.H0.Panelette{WP.row,WP.column}.hEdit{2};
        set(Xin.UI.H.hSes_AddAtts_Edit,         'Tag', 'hSes_AddAtts_Edit');
        set(Xin.UI.H.hSes_AddAttNumTotal_Edit,	'Tag', 'hSes_AddAttNumTotal_Edit');
        clear WP;    	

	WP.name = 'Ses SoundTime';
        WP.handleseed =	'Xin.UI.H0.Panelette';
        WP.type = 'Edit';           
        WP.row      = S.PnltCurrent.row;
        WP.column   = S.PnltCurrent.column;
            S.PnltCurrent.column = S.PnltCurrent.column + 1;     
        WP.text = {	'',...
                    'Sound Duration Total (s)'};
        WP.tip = {	'',...
                    'Cycle Duration Total (s)'};
        WP.inputValue = {   0,...
                            Xin.D.Ses.Load.SoundDurTotal};
        WP.inputFormat = {'','%5.1f'};    
        WP.inputEnable = {'off','off'};
        Panelette(S, WP, 'Xin');    
        Xin.UI.H.hSes_SoundDurTotal_Edit =      Xin.UI.H0.Panelette{WP.row,WP.column}.hEdit{2}; 
        set(Xin.UI.H.hSes_SoundDurTotal_Edit,   'Tag', 'hSes_SoundDurTotal_Edit');
        clear WP;   
        
    WP.name = 'Ses CycleTime';
        WP.handleseed =	'Xin.UI.H0.Panelette';
        WP.type = 'Edit';           
        WP.row      = S.PnltCurrent.row;
        WP.column   = S.PnltCurrent.column;
            S.PnltCurrent.column = S.PnltCurrent.column + 1;     
        WP.text = {	'Cycle Duration Current (s)',...
                    'Cycle Duration Total (s)'};
        WP.tip = {	'Cycle Duration Current (s)',...
                    'Cycle Duration Total (s)'};
        WP.inputValue = {   Xin.D.Ses.Load.CycleDurCurrent,...
                            Xin.D.Ses.Load.CycleDurTotal};
        WP.inputFormat = {'%5.1f','%5.1f'};    
        WP.inputEnable = {'off','off'};
        Panelette(S, WP, 'Xin');    
        Xin.UI.H.hSes_CycleDurCurrent_Edit =	Xin.UI.H0.Panelette{WP.row,WP.column}.hEdit{1};
        Xin.UI.H.hSes_CycleDurTotal_Edit =      Xin.UI.H0.Panelette{WP.row,WP.column}.hEdit{2}; 
        set(Xin.UI.H.hSes_CycleDurCurrent_Edit,	'Tag', 'hSes_CycleDurCurrent_Edit');
        set(Xin.UI.H.hSes_CycleDurTotal_Edit,   'Tag', 'hSes_CycleDurTotal_Edit');
        clear WP;   
        
  	WP.name = 'Ses Time';
        WP.handleseed =	'Xin.UI.H0.Panelette';
        WP.type = 'Edit';           
        WP.row      = S.PnltCurrent.row;
        WP.column   = S.PnltCurrent.column;
            S.PnltCurrent.column = S.PnltCurrent.column + 1;     
        WP.text = {	'Session Current Time (s)',...
                    'Session Duraion (s)'};
        WP.tip = {	'Session Current Time (s)',...
                    'Session Duraion (s)'};
        WP.inputValue = {   Xin.D.Ses.Load.DurCurrent,...
                            Xin.D.Ses.Load.DurTotal};
        WP.inputFormat = {'%d','%d'};    
        WP.inputEnable = {'off','off'};
        Panelette(S, WP, 'Xin');    
        Xin.UI.H.hSes_DurCurrent_Edit =	Xin.UI.H0.Panelette{WP.row,WP.column}.hEdit{1};
        Xin.UI.H.hSes_DurTotal_Edit =	Xin.UI.H0.Panelette{WP.row,WP.column}.hEdit{2};
        set(Xin.UI.H.hSes_DurCurrent_Edit,	'Tag', 'hSes_DurCurrent_Edit');
        set(Xin.UI.H.hSes_DurTotal_Edit,	'Tag', 'hSes_DurTotal_Edit');        
        clear WP; 
        
S.PnltCurrent.row = 2;      S.PnltCurrent.column = 9;
	WP.name = 'Ses Trigger';
        WP.handleseed = 'Xin.UI.H0.Panelette';
        WP.type = 'RockerSwitch';	
        WP.row      = S.PnltCurrent.row;
        WP.column   = S.PnltCurrent.column;
            S.PnltCurrent.column = S.PnltCurrent.column + 1;
        WP.text = { 'Triggers'};
        WP.tip = {  'Triggers'};
        WP.inputOptions = {'HardwareRec', 'SoftwareRec', 'SoftwareGrab'};
        WP.inputDefault = 3;
        Panelette(S, WP, 'Xin');
        Xin.UI.H.hSes_CamTrigger_Rocker =	Xin.UI.H0.Panelette{WP.row,WP.column}.hRocker{1};
        set(Xin.UI.H.hSes_CamTrigger_Rocker,  'Tag',  'hSes_CamTrigger_Rocker');
        a = get(Xin.UI.H.hSes_CamTrigger_Rocker, 'Children');
        set(a(1), 'Enable', 'inactive'); 
        set(a(2), 'Enable', 'inactive'); 
        set(a(3), 'Enable', 'inactive'); 
        clear WP; 
        
  	WP.name = 'Ses Frame#1';
        WP.handleseed =	'Xin.UI.H0.Panelette';
        WP.type = 'Edit';           
        WP.row      = S.PnltCurrent.row;
        WP.column   = S.PnltCurrent.column;
            S.PnltCurrent.column = S.PnltCurrent.column + 1;     
        WP.text = {	'Frame Available (frames)',...
                    'Frame SesTotal (frames)'};
        WP.tip = {	'Frame Available (frames)',...
                    'Frame SesTotal (frames)'};
        WP.inputValue = {   Xin.D.Ses.FrameAcquired,...
                            Xin.D.Ses.FrameTotal};
        WP.inputFormat = {'%d','%d'};    
        WP.inputEnable = {'off','off'};
        Panelette(S, WP, 'Xin');    
        Xin.UI.H.hSes_FrameAcquired_Edit =	Xin.UI.H0.Panelette{WP.row,WP.column}.hEdit{1};
        Xin.UI.H.hSes_FrameTotal_Edit =     Xin.UI.H0.Panelette{WP.row,WP.column}.hEdit{2}; 
        clear WP;        
        
  	WP.name = 'Ses Frame#2';
        WP.handleseed =	'Xin.UI.H0.Panelette';
        WP.type = 'Edit';           
        WP.row      = S.PnltCurrent.row;
        WP.column   = S.PnltCurrent.column;
            S.PnltCurrent.column = S.PnltCurrent.column + 1;     
        WP.text = {	'Frame Available (frames)',...
                    ''};
        WP.tip = {	'Frame Available (frames)',...
                    ''};
        WP.inputValue = {   Xin.D.Ses.FrameAvailable,...
                            ''};
        WP.inputFormat = {'%d','%s'};    
        WP.inputEnable = {'off','off'};
        Panelette(S, WP, 'Xin');    
        Xin.UI.H.hSes_FrameAvailable_Edit =	Xin.UI.H0.Panelette{WP.row,WP.column}.hEdit{1};
        clear WP;       
        
S.PnltCurrent.row = 1;      S.PnltCurrent.column = 1;  
  	WP.name = 'Trl Number';
        WP.handleseed =	'Xin.UI.H0.Panelette';
        WP.type = 'Edit';           
        WP.row      = S.PnltCurrent.row;
        WP.column   = S.PnltCurrent.column;
            S.PnltCurrent.column = S.PnltCurrent.column + 1;     
        WP.text = {	'Current Trial Number',...
                    'Total Trial Number / Cycle'};
        WP.tip = {	'Current Trial Number',...
                    'Total Trial Number / Cycle'};
        WP.inputValue = {   Xin.D.Trl.Load.NumCurrent,...
                            Xin.D.Trl.Load.NumTotal};
        WP.inputFormat = {'%d','%d'};    
        WP.inputEnable = {'off','off'};
        Panelette(S, WP, 'Xin');    
        Xin.UI.H.hTrl_NumCurrent_Edit =	Xin.UI.H0.Panelette{WP.row,WP.column}.hEdit{1};
        Xin.UI.H.hTrl_NumTotal_Edit =	Xin.UI.H0.Panelette{WP.row,WP.column}.hEdit{2};
        set(Xin.UI.H.hTrl_NumCurrent_Edit,	'Tag', 'hTrl_NumCurrent_Edit');
        set(Xin.UI.H.hTrl_NumTotal_Edit,	'Tag', 'hTrl_NumTotal_Edit');
        clear WP;  
        
	WP.name = 'Trl Stim #';
        WP.handleseed =	'Xin.UI.H0.Panelette';
        WP.type = 'Edit';           
        WP.row      = S.PnltCurrent.row;
        WP.column   = S.PnltCurrent.column;
            S.PnltCurrent.column = S.PnltCurrent.column + 1;     
        WP.text = {	'CURRENT Trial Stim #',...
                    'NEXT Trial Stim #'};
        WP.tip = {	'CURRENT Trial Stim #',...
                    'NEXT Trial Stim #'};
        WP.inputValue = {   Xin.D.Trl.Load.StimNumCurrent,...
                            Xin.D.Trl.Load.StimNumNext};
        WP.inputFormat = {'%d','%d'};    
        WP.inputEnable = {'off','off'};
        Panelette(S, WP, 'Xin');    
        Xin.UI.H.hTrl_StimNumCurrent_Edit =	Xin.UI.H0.Panelette{WP.row,WP.column}.hEdit{1};
        Xin.UI.H.hTrl_StimNumNext_Edit =	Xin.UI.H0.Panelette{WP.row,WP.column}.hEdit{2};
        set(Xin.UI.H.hTrl_StimNumCurrent_Edit,	'Tag', 'hTrl_StimNumCurrent_Edit');
        set(Xin.UI.H.hTrl_StimNumNext_Edit,     'Tag', 'hTrl_StimNumNext_Edit');
        clear WP;  
        
	WP.name = 'Trl Sound #';
        WP.handleseed =	'Xin.UI.H0.Panelette';
        WP.type = 'Edit';           
        WP.row      = S.PnltCurrent.row;
        WP.column   = S.PnltCurrent.column;
            S.PnltCurrent.column = S.PnltCurrent.column + 1;     
        WP.text = {	'Current Sound #',...
                    'Total Sound #'};
        WP.tip = {	'Current Sound #',...
                    'Total Sound #'};
        WP.inputValue = {   Xin.D.Trl.Load.SoundNumCurrent,...
                            Xin.D.Trl.Load.SoundNumTotal};
        WP.inputFormat = {'%s','%d'};    
        WP.inputEnable = {'off','off'};
        Panelette(S, WP, 'Xin');    
        Xin.UI.H.hTrl_SoundNumCurrent_Edit =	Xin.UI.H0.Panelette{WP.row,WP.column}.hEdit{1};
        Xin.UI.H.hTrl_SoundNumTotal_Edit =      Xin.UI.H0.Panelette{WP.row,WP.column}.hEdit{2};
        set(Xin.UI.H.hTrl_SoundNumCurrent_Edit,	'Tag', 'hTrl_SoundNumCurrent_Edit');
        set(Xin.UI.H.hTrl_SoundNumTotal_Edit,	'Tag', 'hTrl_SoundNumTotal_Edit');
        clear WP;  	
        
    WP.name = 'Trl SoundFeature';
        WP.handleseed =	'Xin.UI.H0.Panelette';
        WP.type = 'Edit';           
        WP.row      = S.PnltCurrent.row;
        WP.column   = S.PnltCurrent.column;
            S.PnltCurrent.column = S.PnltCurrent.column + 1;     
        WP.text = {	'Sound Design Attenuation (dB)',...
                    'CURRENT Sound Name'};
        WP.tip = {	'Sound Design Attenuation (dB)',...
                    'CURRENT Sound Name'};
        WP.inputValue = {   Xin.D.Trl.Load.AttDesignCurrent,...
                            Xin.D.Trl.Load.SoundNameCurrent};
        WP.inputFormat = {'%5.1f','%d'};    
        WP.inputEnable = {'off','off'};
        Panelette(S, WP, 'Xin');    
        Xin.UI.H.hTrl_AttDesignCurrent_Edit =	Xin.UI.H0.Panelette{WP.row,WP.column}.hEdit{1};
        Xin.UI.H.hTrl_SoundNameCurrent_Edit =	Xin.UI.H0.Panelette{WP.row,WP.column}.hEdit{2};
        set(Xin.UI.H.hTrl_SoundNameCurrent_Edit, 'FontSize', 9);
        set(Xin.UI.H.hTrl_AttDesignCurrent_Edit,	'Tag', 'hTrl_AttDesignCurrent_Edit');
        set(Xin.UI.H.hTrl_SoundNameCurrent_Edit,	'Tag', 'hTrl_SoundNameCurrent_Edit');
        clear WP; 
        
	WP.name = 'Trl Attenuation';
        WP.handleseed =	'Xin.UI.H0.Panelette';
        WP.type = 'Edit';           
        WP.row      = S.PnltCurrent.row;
        WP.column   = S.PnltCurrent.column;
            S.PnltCurrent.column = S.PnltCurrent.column + 1;     
        WP.text = {	'Additional Attenuation (dB)',...
                    'Total Attenuation (dB)'};
        WP.tip = {	'Additional Attenuation (dB)',...
                    'Total Attenuation (dB)'};
        WP.inputValue = {  	Xin.D.Trl.Load.AttAddCurrent,...
                            Xin.D.Trl.Load.AttCurrent};
        WP.inputFormat = {'%5.1f','%5.1f'};    
        WP.inputEnable = {'off','off'};
        Panelette(S, WP, 'Xin');    
        Xin.UI.H.hTrl_AttAddCurrent_Edit =	Xin.UI.H0.Panelette{WP.row,WP.column}.hEdit{1};
        Xin.UI.H.hTrl_AttCurrent_Edit =     Xin.UI.H0.Panelette{WP.row,WP.column}.hEdit{2};
        set(Xin.UI.H.hTrl_AttAddCurrent_Edit,	'Tag', 'hTrl_AttAddCurrent_Edit');
        set(Xin.UI.H.hTrl_AttCurrent_Edit,      'Tag', 'hTrl_AttCurrent_Edit');
        clear WP;  
        
  	WP.name = 'Trl Time';
        WP.handleseed =	'Xin.UI.H0.Panelette';
        WP.type = 'Edit';           
        WP.row      = S.PnltCurrent.row;
        WP.column   = S.PnltCurrent.column;
            S.PnltCurrent.column = S.PnltCurrent.column + 1;     
        WP.text = {	'Trial Current Time',...
                    'Trial Duraion'};
        WP.tip = {	'Trial Current Time',...
                    'Trial Duraion'};
        WP.inputValue = {   Xin.D.Trl.Load.DurCurrent,...
                            Xin.D.Trl.Load.DurTotal};
        WP.inputFormat = {'%d','%d'};    
        WP.inputEnable = {'off','off'};
        Panelette(S, WP, 'Xin');    
        Xin.UI.H.hTrl_DurCurrent_Edit =	Xin.UI.H0.Panelette{WP.row,WP.column}.hEdit{1};
        Xin.UI.H.hTrl_DurTotal_Edit =	Xin.UI.H0.Panelette{WP.row,WP.column}.hEdit{2};
        set(Xin.UI.H.hTrl_DurCurrent_Edit,	'Tag', 'hTrl_DurCurrent_Edit');
        set(Xin.UI.H.hTrl_DurTotal_Edit,	'Tag', 'hTrl_DurTotal_Edit');
        clear WP;   
        
S.PnltCurrent.row = 1;      S.PnltCurrent.column = 8;        
     WP.name = 'Mon PreviewSwt';
        WP.handleseed =	'Xin.UI.H0.Panelette';
        WP.type =       'RockerSwitch';	
        WP.row =        S.PnltCurrent.row;
        WP.column =     S.PnltCurrent.column;
            S.PnltCurrent.column = S.PnltCurrent.column + 1;
        WP.text =   {   'Preview Switch'};
        WP.tip =    {   'Preview Switch'};
        WP.inputOptions = {'Preview ON', 'Preview OFF', ''};
        WP.inputDefault = 2;
        Panelette(S, WP, 'Xin');
        Xin.UI.H.hMon_PreviewSwitch_Rocker = Xin.UI.H0.Panelette{WP.row,WP.column}.hRocker{1};
        set(Xin.UI.H.hMon_PreviewSwitch_Rocker, 'Tag', 'hMon_PreviewSwitch_Rocker');
        clear WP;  
        
  	WP.name = 'Mon CamPrevPara';
        WP.handleseed =	'Xin.UI.H0.Panelette';
        WP.type = 'Edit';           
        WP.row      = S.PnltCurrent.row;
        WP.column   = S.PnltCurrent.column;
            S.PnltCurrent.column = S.PnltCurrent.column + 1;     
        WP.text = {	'Previewing frame rate',...
                    'Previewing TimeStamp [HH:MM:SS.S]'};
        WP.tip = {	'Previewing frame rate',...
                    'Previewing TimeStamp [HH:MM:SS.S]'};
        WP.inputValue = {   Xin.D.Sys.PointGreyCam(2).PreviewStrFR,...
                            Xin.D.Sys.PointGreyCam(2).PreviewStrTS};
        WP.inputFormat = {'%s','%s'};    
        WP.inputEnable = {'off','off'};
        Panelette(S, WP, 'Xin');    
        Xin.UI.H.hVol_CamPreviewFR_Edit =	Xin.UI.H0.Panelette{WP.row,WP.column}.hEdit{1};
        Xin.UI.H.hVol_CamPreviewTS_Edit =	Xin.UI.H0.Panelette{WP.row,WP.column}.hEdit{2};
        set(Xin.UI.H.hVol_CamPreviewFR_Edit, 'tag', 'hVol_CamPreviewFR_Edit');
        set(Xin.UI.H.hVol_CamPreviewTS_Edit, 'tag', 'hVol_CamPreviewTS_Edit');
        clear WP;
        
    WP.name = 'Mon DisplayMode';
        WP.handleseed = 'Xin.UI.H0.Panelette';
        WP.type = 'RockerSwitch';	
        WP.row      = S.PnltCurrent.row;
        WP.column   = S.PnltCurrent.column;
            S.PnltCurrent.column = S.PnltCurrent.column + 1;
        WP.text = { 'Display Mode'};
        WP.tip = {  'Display Mode'};
        WP.inputOptions = {'Disp Full', 'Disp ROI', 'Draw ROI'};
        WP.inputDefault = 1;
        Panelette(S, WP, 'Xin');
        Xin.UI.H.hVol_DisplayMode_Rocker =	Xin.UI.H0.Panelette{WP.row,WP.column}.hRocker{1};
        set(Xin.UI.H.hVol_DisplayMode_Rocker,   'Tag',   'hVol_DisplayMode_Rocker');
        a = get(Xin.UI.H.hVol_DisplayMode_Rocker, 'Children');
        set(a(2), 'Enable', 'inactive');        
        clear WP;   
        
  	WP.name = 'Mon Animal';
        WP.handleseed = 'Xin.UI.H0.Panelette';
        WP.type = 'MomentarySwitch'; 
        WP.row =        S.PnltCurrent.row;         
        WP.column =     S.PnltCurrent.column;
            S.PnltCurrent.column = S.PnltCurrent.column + 1;
        WP.text = { 'Animal Monitor',...
                    ''};
        WP.tip = {[ 'Animal Monitor',...
                    ''],...
                  [ 'Monitoring animal''s condition',...
                    ''] };
        WP.inputEnable = {'on','off'};
        Panelette(S, WP, 'Xin');
        Xin.UI.H.hMon_AnimalMon_Momentary =     Xin.UI.H0.Panelette{WP.row,WP.column}.hMomentary{1};
        set(Xin.UI.H.hMon_AnimalMon_Momentary,      'tag', 'hMon_AnimalMon_Momentary');
        set(Xin.UI.H.hMon_AnimalMon_Momentary,      'UserData', 1');
        clear WP;  
        
Xin.UI.FigPGC(2).hImage =                       Xin.UI.H0.hImage;
Xin.UI.FigPGC(2).hImageHide =                   Xin.UI.H0.hImageHide;
Xin.UI.FigPGC(2).CP.hMon_CamPreviewFR_Edit =    Xin.UI.H.hVol_CamPreviewFR_Edit;
Xin.UI.FigPGC(2).CP.hMon_CamPreviewTS_Edit =    Xin.UI.H.hVol_CamPreviewTS_Edit;
Xin.UI.FigPGC(2).hHistMax =                     Xin.UI.H0.hHistMax;
Xin.UI.FigPGC(2).hHistMean =                    Xin.UI.H0.hHistMean; 
Xin.UI.FigPGC(2).hHistMin =                     Xin.UI.H0.hHistMin; 
Xin.UI.FigPGC(2).CP.hSys_CamShutter_PotenSlider =   Xin.UI.H.hSys_CamShutter_PotenSlider;
Xin.UI.FigPGC(2).CP.hSys_CamShutter_PotenEdit =     Xin.UI.H.hSys_CamShutter_PotenEdit;
Xin.UI.FigPGC(2).CP.hSys_CamGain_PotenSlider =      Xin.UI.H.hSys_CamGain_PotenSlider;
Xin.UI.FigPGC(2).CP.hSys_CamGain_PotenEdit =        Xin.UI.H.hSys_CamGain_PotenEdit;
Xin.UI.FigPGC(2).CP.hSys_CamDispGain_PotenSlider =	Xin.UI.H.hSys_CamDispGain_PotenSlider;
Xin.UI.FigPGC(2).CP.hSys_CamDispGain_PotenEdit =	Xin.UI.H.hSys_CamDispGain_PotenEdit;
Xin.UI.FigPGC(2).CP.hExp_RefImage_Momentary =       Xin.UI.H.hExp_RefImage_Momentary;
Xin.UI.FigPGC(2).CP.hSes_CamTrigger_Rocker =        Xin.UI.H.hSes_CamTrigger_Rocker;
Xin.UI.FigPGC(2).CP.hMon_PreviewSwitch_Rocker =     Xin.UI.H.hMon_PreviewSwitch_Rocker;
set(Xin.UI.FigPGC(2).CP.hSys_CamShutter_PotenSlider,	'UserData',	2);
set(Xin.UI.FigPGC(2).CP.hSys_CamShutter_PotenEdit,    	'UserData',	2);
set(Xin.UI.FigPGC(2).CP.hSys_CamGain_PotenSlider,     	'UserData',	2);
set(Xin.UI.FigPGC(2).CP.hSys_CamGain_PotenEdit,      	'UserData',	2);
set(Xin.UI.FigPGC(2).CP.hSys_CamDispGain_PotenSlider,	'UserData',	2);
set(Xin.UI.FigPGC(2).CP.hSys_CamDispGain_PotenEdit,     'UserData',	2);
set(Xin.UI.FigPGC(2).CP.hExp_RefImage_Momentary,        'UserData',	2);
set(Xin.UI.FigPGC(2).CP.hSes_CamTrigger_Rocker,         'UserData', 2);
set(Xin.UI.FigPGC(2).CP.hMon_PreviewSwitch_Rocker,      'UserData', 2);

%% Turn the JAVA LookAndFeel Scheme on "Windows"
%     javax.swing.UIManager.setLookAndFeel('com.sun.java.swing.plaf.windows.WindowsLookAndFeel');

%% LOG MSG
msg = [datestr(now, 'yy/mm/dd HH:MM:SS.FFF') '\tSetupFigure\tSetup the GUI for the program\r\n'];
updateMsg(Xin.D.Exp.hLog, msg);