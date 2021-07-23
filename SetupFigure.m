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
    S.AxesImageWidth =      Xin.D.Sys.Camera.DispWidth;
    S.AxesImageHeight =     Xin.D.Sys.Camera.DispHeight;
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
        Xin.UI.H0.hImage = image(Xin.D.Sys.Camera.DispImg,...
            'parent',       Xin.UI.H0.hAxesImage); 
        Xin.UI.FigPGC(3).hText = text(0, 0, {' 0', ' 0', ' 0'},...
            'parent',       Xin.UI.H0.hAxesImage,...
            'Color',        [1 1 1],...
            'VerticalAlignment',    'Top',...
            'HorizontalAlignment',  'Left');  
        
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
            'XLim',         [1 Xin.D.Sys.Camera.DispHeight],...
            'XTick',        [],...
            'YColor',       S.Color.FG,...
            'YGrid',        'On',...
            'YLim',         [0 255],...
            'YTick',        0:32:224,...
            'YTickLabel',   {});
     	Xin.UI.H0.hHistMax =    plot(Xin.D.Sys.Camera.DispHistMax,	'-',...
            'parent',       Xin.UI.H0.hAxesHist,...
            'Color',        S.Color.FG); 
     	Xin.UI.H0.hHistMean =   plot(Xin.D.Sys.Camera.DispHistMean,	'.-',...
            'parent',       Xin.UI.H0.hAxesHist,...
            'Color',        S.Color.FG);                     
     	Xin.UI.H0.hHistMin =    plot(Xin.D.Sys.Camera.DispHistMin,	'--',...
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
        WP.inputOptions = {Xin.D.Sys.Light.Sources{1:3}; Xin.D.Sys.Light.Sources{4:6}};
        WP.inputDefault = [1, 0];
        Panelette(S, WP, 'Xin');
        Xin.UI.H.hSys_LightSource_Toggle1 =   	Xin.UI.H0.Panelette{WP.row,WP.column}.hToggle{1};
        Xin.UI.H.hSys_LightSource_Toggle2 =   	Xin.UI.H0.Panelette{WP.row,WP.column}.hToggle{2};
        set(Xin.UI.H.hSys_LightSource_Toggle1,  'Tag', 'hSys_LightSource_Toggle1');
        set(Xin.UI.H.hSys_LightSource_Toggle2,  'Tag', 'hSys_LightSource_Toggle2');
        clear WP;
        hc = get(Xin.UI.H.hSys_LightSource_Toggle1, 'Children');
            set(hc(3), 'ForegroundColor', [ 1       1       0   ]);
            set(hc(2), 'ForegroundColor', [ 0       1       0   ]);
            set(hc(1), 'ForegroundColor', [ 0       0       1   ]);
            set(hc(3), 'UserData',        Xin.D.Sys.Light.Wavelengths(1));
            set(hc(2), 'UserData',        Xin.D.Sys.Light.Wavelengths(2));
            set(hc(1), 'UserData',        Xin.D.Sys.Light.Wavelengths(3));
        hc = get(Xin.UI.H.hSys_LightSource_Toggle2, 'Children');
            set(hc(3), 'ForegroundColor', [ 1       0       0   ]);
            set(hc(2), 'ForegroundColor', [ 0.75    0       0   ]);
            set(hc(1), 'ForegroundColor', [ 0.5     0       0   ]);
            set(hc(3), 'UserData',        Xin.D.Sys.Light.Wavelengths(4));
            set(hc(2), 'UserData',        Xin.D.Sys.Light.Wavelengths(5));
            set(hc(1), 'UserData',        Xin.D.Sys.Light.Wavelengths(6));
         
	WP.name = 'Sys LightConfig';
        WP.handleseed = 'Xin.UI.H0.Panelette';
        WP.type = 'RockerSwitch';	
        WP.row      = S.PnltCurrent.row;
        WP.column   = S.PnltCurrent.column;
            S.PnltCurrent.column = S.PnltCurrent.column + 1;
        WP.text = { 'LED light port + Imaging headcube'};
        WP.tip = {  'LED light port + Imaging headcube'};
        WP.inputOptions = {'LtGuide + PBS', 'Koehler + PBS', 'Koehler + GFP'};
        WP.inputDefault = 1;
        Panelette(S, WP, 'Xin');
        Xin.UI.H.hSys_LightConfig_Rocker =     	Xin.UI.H0.Panelette{WP.row,WP.column}.hRocker{1};
        set(Xin.UI.H.hSys_LightConfig_Rocker, 'Tag',  'hSys_LightConfig_Rocker');
        clear WP;
        hc = get(Xin.UI.H.hSys_LightConfig_Rocker, 'Children');
        for i = 1:3
            setappdata(hc(i), 'Port',       Xin.D.Sys.Light.Configs(4-i).Port);
            setappdata(hc(i), 'HeadCube',	Xin.D.Sys.Light.Configs(4-i).HeadCube);
        end
          
	WP.name = 'Sys LightMonitor';
        WP.handleseed = 'Xin.UI.H0.Panelette';
        WP.type = 'RockerSwitch';	
        WP.row      = S.PnltCurrent.row;
        WP.column   = S.PnltCurrent.column;
            S.PnltCurrent.column = S.PnltCurrent.column + 1;
        WP.text = { 'Power Meter Settings'};
        WP.tip = {  'Power Meter Settings'};
        WP.inputOptions = {'No Monitor', 'Slow Updates', 'Fast Updates'};
        WP.inputDefault = 1;
        Panelette(S, WP, 'Xin');
        Xin.UI.H.hSys_LightMonitor_Rocker =     	Xin.UI.H0.Panelette{WP.row,WP.column}.hRocker{1};
        set(Xin.UI.H.hSys_LightMonitor_Rocker, 'Tag',  'hSys_LightMonitor_Rocker');
        clear WP;
        
	WP.name = 'Sys LightDiffuser';
        WP.handleseed =	'Xin.UI.H0.Panelette';
        WP.type =       'Potentiometer';	
        WP.row =        S.PnltCurrent.row;
        WP.column =     S.PnltCurrent.column;
            S.PnltCurrent.column = S.PnltCurrent.column + 1;  
        WP.text = 	{   ['Light diffuser: [', sprintf('%d ', Xin.D.Sys.Light.Diffusers), '] (degree)']};
        WP.tip =    {   ['Light diffuser: [', sprintf('%d ', Xin.D.Sys.Light.Diffusers), '] (degree)']};
        WP.inputValue =     Xin.D.Sys.Light.Diffuser;
        WP.inputRange =     Xin.D.Sys.Light.Diffusers([1 end]);
        WP.inputSlideStep=  1/(length(Xin.D.Sys.Light.Diffusers)-1)*[1 1];
        Panelette(S, WP, 'Xin');
        Xin.UI.H.hSys_LightDiffuser_PotenSlider =  	Xin.UI.H0.Panelette{WP.row,WP.column}.hSlider{1};
        Xin.UI.H.hSys_LightDiffuser_PotenEdit =    	Xin.UI.H0.Panelette{WP.row,WP.column}.hEdit{1};
        set(Xin.UI.H.hSys_LightDiffuser_PotenSlider,'Tag',  'hSys_LightDiffuser_PotenSlider');
        set(Xin.UI.H.hSys_LightDiffuser_PotenEdit,  'Tag',  'hSys_LightDiffuser_PotenEdit');
        clear WP;   
        
    WP.name = 'Sys CamLensAngle';
        WP.handleseed =	'Xin.UI.H0.Panelette';
        WP.type =       'Potentiometer';	
        WP.row =        S.PnltCurrent.row;
        WP.column =     S.PnltCurrent.column;
            S.PnltCurrent.column = S.PnltCurrent.column + 1;  
        WP.text = 	{	['camera lens angle reading on LCRM2']};
        WP.tip =    {   'The angle reading on LCRM2',...
                        'For the right side setup, with NMV-6x16#311383 + GS3-U3-23S6M#15452576',...
                        'Flat Angle ~= 74degree'};
        WP.inputRange =     [0 360];
        WP.inputValue =     Xin.D.Sys.CameraLens.Angle;
        WP.inputSlideStep=  [1/360 10/360];
        Panelette(S, WP, 'Xin');
        Xin.UI.H.hSys_CameraLensAngle_PotenSlider =	Xin.UI.H0.Panelette{WP.row,WP.column}.hSlider{1};
        Xin.UI.H.hSys_CameraLensAngle_PotenEdit =	Xin.UI.H0.Panelette{WP.row,WP.column}.hEdit{1};
        set(Xin.UI.H.hSys_CameraLensAngle_PotenSlider,	'tag', 'hSys_CameraLensAngle_PotenSlider');
        set(Xin.UI.H.hSys_CameraLensAngle_PotenEdit,  	'tag', 'hSys_CameraLensAngle_PotenEdit');
        clear WP;
        
	WP.name = 'Sys CamLensAperture';
        WP.handleseed =	'Xin.UI.H0.Panelette';
        WP.type =       'Potentiometer';	
        WP.row =        S.PnltCurrent.row;
        WP.column =     S.PnltCurrent.column;
            S.PnltCurrent.column = S.PnltCurrent.column + 1;  
        WP.text = 	{   ['Lens aperture: f/[', sprintf('%.2g ', Xin.D.Sys.CameraLens.Apertures), ']']};
        WP.tip =    {   ['Lens aperture: f/[', sprintf('%.2g ', Xin.D.Sys.CameraLens.Aperture), ']']};
        WP.inputValue =     log10(Xin.D.Sys.CameraLens.Aperture);
        WP.inputRange =     log10(Xin.D.Sys.CameraLens.Apertures([1 end]));
        WP.inputSlideStep=  1/(length(Xin.D.Sys.CameraLens.Apertures)-1)*[1 1];
        Panelette(S, WP, 'Xin');
        Xin.UI.H.hSys_CameraLensAperture_PotenSlider =	Xin.UI.H0.Panelette{WP.row,WP.column}.hSlider{1};
        Xin.UI.H.hSys_CameraLensAperture_PotenEdit =	Xin.UI.H0.Panelette{WP.row,WP.column}.hEdit{1};
        set(Xin.UI.H.hSys_CameraLensAperture_PotenSlider,'Tag',  'hSys_CameraLensAperture_PotenSlider');
        set(Xin.UI.H.hSys_CameraLensAperture_PotenEdit,  'Tag',  'hSys_CameraLensAperture_PotenEdit');
        set(Xin.UI.H.hSys_CameraLensAperture_PotenEdit,  'Enable',  'off');        
        clear WP;    
        
	WP.name = 'Sys CamShutter';
        WP.handleseed =	'Xin.UI.H0.Panelette';
        WP.type =       'Potentiometer';	
        WP.row =        S.PnltCurrent.row;
        WP.column =     S.PnltCurrent.column;
            S.PnltCurrent.column = S.PnltCurrent.column + 1;  
        WP.text = 	{   ['Cam shutter: [', sprintf('%4.2f ', Xin.D.Sys.Camera.ShutterRange), '] (ms)']};
        WP.tip =    {   ['Cam shutter: [', sprintf('%4.2f ', Xin.D.Sys.Camera.ShutterRange), '] (ms)']};
        WP.inputValue =     Xin.D.Sys.Camera.Shutter;
        WP.inputRange =     Xin.D.Sys.Camera.ShutterRange;
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
        WP.text = 	{   ['Cam gain: [', sprintf('%5.3f ', Xin.D.Sys.Camera.GainRange), '] (dB)']};
        WP.tip =    {   ['Cam gain: [', sprintf('%5.3f ', Xin.D.Sys.Camera.GainRange), '] (dB)']};
        WP.inputValue =     Xin.D.Sys.Camera.Gain;
        WP.inputRange =     Xin.D.Sys.Camera.GainRange;
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
        WP.text = 	{   ['Cam frame bin: [', sprintf('%d ', Xin.D.Sys.Camera.DispGainNumRange), '] (frames)']};
        WP.tip =    {   ['Cam frame bin: [', sprintf('%d ', Xin.D.Sys.Camera.DispGainNumRange), '] (frames)']};
        WP.inputRange =     Xin.D.Sys.Camera.DispGainBitRange;
        WP.inputSlideStep=  min(diff(WP.inputRange))/sum(diff(WP.inputRange))*[1 1];
        Panelette(S, WP, 'Xin');
        Xin.UI.H.hSys_CamDispGain_PotenSlider = Xin.UI.H0.Panelette{WP.row,WP.column}.hSlider{1};
        Xin.UI.H.hSys_CamDispGain_PotenEdit =   Xin.UI.H0.Panelette{WP.row,WP.column}.hEdit{1};
        clear WP;    
 
S.PnltCurrent.row = 3;      S.PnltCurrent.column = 10;     
	WP.name = 'Mky Monkey#';
        WP.handleseed = 'Xin.UI.H0.Panelette';
        WP.type = 'ToggleSwitch';	
        WP.row      = S.PnltCurrent.row;
        WP.column   = S.PnltCurrent.column;
            S.PnltCurrent.column = S.PnltCurrent.column + 1;
        WP.text = { 'Animal', 'ID'};
        WP.tip = {  'Animal', 'ID'};
        WP.inputOptions = Xin.D.Mky.Lists.ID(1:2,:);
        WP.inputDefault = [1, 0];
        Panelette(S, WP, 'Xin');
        Xin.UI.H.hMky_ID_Toggle1 =   	Xin.UI.H0.Panelette{WP.row,WP.column}.hToggle{1};
        Xin.UI.H.hMky_ID_Toggle2 =   	Xin.UI.H0.Panelette{WP.row,WP.column}.hToggle{2};
        set(Xin.UI.H.hMky_ID_Toggle1, 'Tag',    'hMky_ID_Toggle1');
        set(Xin.UI.H.hMky_ID_Toggle2, 'Tag',    'hMky_ID_Toggle2');
        clear WP;   
	WP.name = 'Mky Monkey#';
        WP.handleseed = 'Xin.UI.H0.Panelette';
        WP.type = 'ToggleSwitch';	
        WP.row      = S.PnltCurrent.row;
        WP.column   = S.PnltCurrent.column;
            S.PnltCurrent.column = S.PnltCurrent.column + 1;
        WP.text = { 'Animal', 'ID'};
        WP.tip = {  'Animal', 'ID'};
        WP.inputOptions = Xin.D.Mky.Lists.ID(3:4,:);
        WP.inputDefault = [1, 0];
        Panelette(S, WP, 'Xin');
        Xin.UI.H.hMky_ID_Toggle3 =   	Xin.UI.H0.Panelette{WP.row,WP.column}.hToggle{1};
        Xin.UI.H.hMky_ID_Toggle4 =   	Xin.UI.H0.Panelette{WP.row,WP.column}.hToggle{2};
        set(Xin.UI.H.hMky_ID_Toggle3, 'Tag',    'hMky_ID_Toggle3');
        set(Xin.UI.H.hMky_ID_Toggle4, 'Tag',    'hMky_ID_Toggle4');
        clear WP;
        
	WP.name = 'Mky Side & Prep';
        WP.handleseed = 'Xin.UI.H0.Panelette';
        WP.type = 'ToggleSwitch';	
        WP.row      = S.PnltCurrent.row;
        WP.column   = S.PnltCurrent.column;
            S.PnltCurrent.column = S.PnltCurrent.column + 1;
        WP.text = { 'Side: left/right', 'Prep: win/intact'};
        WP.tip = {  'Side / Hemisphere', 'Preperation: Window or Intact Skull'};
        WP.inputOptions = [Xin.D.Mky.Lists.Side; Xin.D.Mky.Lists.Prep];
        WP.inputDefault = [1, 1];
        Panelette(S, WP, 'Xin');
        Xin.UI.H.hMky_Side_Rocker =   	Xin.UI.H0.Panelette{WP.row,WP.column}.hToggle{1};
        Xin.UI.H.hMky_Prep_Rocker =   	Xin.UI.H0.Panelette{WP.row,WP.column}.hToggle{2};
        set(Xin.UI.H.hMky_Side_Rocker, 'Tag',    'hMky_Side_Rocker');
        set(Xin.UI.H.hMky_Prep_Rocker, 'Tag',    'hMky_Prep_Rocker');
        clear WP;

S.PnltCurrent.row = 2;      S.PnltCurrent.column = 1;        
  	WP.name = 'Exp Ref_Image';
        WP.handleseed = 'Xin.UI.H0.Panelette';
        WP.type = 'MomentarySwitch'; 
        WP.row =        S.PnltCurrent.row;         
        WP.column =     S.PnltCurrent.column;
            S.PnltCurrent.column = S.PnltCurrent.column + 1;
        WP.text = { 'Take a reference image for the Experiment',...
                    'Turn the reference coordinates ON/OFF'};
        WP.tip = {  'Take a reference image for the Experiment',...
                    'Turn the reference coordinates ON/OFF' };
        WP.inputEnable = {'on','on'};
        Panelette(S, WP, 'Xin');
        Xin.UI.H.hExp_RefImage_Momentary =	Xin.UI.H0.Panelette{WP.row,WP.column}.hMomentary{1}; 
        Xin.UI.H.hExp_RefCoord_Momentary =	Xin.UI.H0.Panelette{WP.row,WP.column}.hMomentary{2}; 
        set(Xin.UI.H.hExp_RefImage_Momentary,	'tag', 'hExp_RefImage_Momentary');
        set(Xin.UI.H.hExp_RefCoord_Momentary,	'tag', 'hExp_RefCoord_Momentary');
        clear WP;         
        
    WP.name = 'Exp Depth';
        WP.handleseed =	'Xin.UI.H0.Panelette';
        WP.type =       'Potentiometer';	
        WP.row =        S.PnltCurrent.row;
        WP.column =     S.PnltCurrent.column;
            S.PnltCurrent.column = S.PnltCurrent.column + 1;  
        WP.text = 	{	['Focal depth: (in LT1 fine turns)']};
        WP.tip =    {   'Focal depth: \n(in LT1 fine turns)'};
        WP.inputRange =     Xin.D.Exp.Depths([1 end]);
        WP.inputValue =     Xin.D.Exp.Depth;
        WP.inputSlideStep=  1/(Xin.D.Exp.Depths(end)-Xin.D.Exp.Depths(1))*[1 1];
        Panelette(S, WP, 'Xin');
        Xin.UI.H.hExp_Depth_PotenSlider =	Xin.UI.H0.Panelette{WP.row,WP.column}.hSlider{1};
        Xin.UI.H.hExp_Depth_PotenEdit =	Xin.UI.H0.Panelette{WP.row,WP.column}.hEdit{1};
        set(Xin.UI.H.hExp_Depth_PotenSlider,	'tag', 'hExp_Depth_PotenSlider');
        set(Xin.UI.H.hExp_Depth_PotenEdit,  	'tag', 'hExp_Depth_PotenEdit');
        clear WP;      
        
    WP.name = 'Exp Rotation';
        WP.handleseed =	'Xin.UI.H0.Panelette';
        WP.type =       'Potentiometer';	
        WP.row =        S.PnltCurrent.row;
        WP.column =     S.PnltCurrent.column;
            S.PnltCurrent.column = S.PnltCurrent.column + 1;  
        WP.text = 	{	['Back Plate Angle (degree)']};
        WP.tip =    {   'Back Plate Angle (degree)'};
        WP.inputRange =     Xin.D.Exp.RotationBPAs([1 end]);
        WP.inputValue =     Xin.D.Exp.RotationBPA;
        WP.inputSlideStep=  1/(Xin.D.Exp.RotationBPAs(end)-Xin.D.Exp.RotationBPAs(1))*[0.5 1.0];
        Panelette(S, WP, 'Xin');
        Xin.UI.H.hExp_RotationBPA_PotenSlider =	Xin.UI.H0.Panelette{WP.row,WP.column}.hSlider{1};
        Xin.UI.H.hExp_RotationBPA_PotenEdit =	Xin.UI.H0.Panelette{WP.row,WP.column}.hEdit{1};
        set(Xin.UI.H.hExp_RotationBPA_PotenSlider,	'tag', 'hExp_RotationBPA_PotenSlider');
        set(Xin.UI.H.hExp_RotationBPA_PotenEdit,  	'tag', 'hExp_RotationBPA_PotenEdit');
        clear WP;  
        
S.PnltCurrent.row = 2;      S.PnltCurrent.column = 4;
	WP.name = 'Ses Load & Start';
        WP.handleseed = 'Xin.UI.H0.Panelette';
        WP.type = 'MomentarySwitch'; 
        WP.row =        S.PnltCurrent.row;         
        WP.column =     S.PnltCurrent.column;
            S.PnltCurrent.column = S.PnltCurrent.column + 1;
        WP.text = { 'LOAD SOUND for the session',...
                    'START a session, or CANCEL a                   session'};
        WP.tip = {	'LOAD SOUND for the session',...
                  	'START a session, or CANCEL a session' };
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
        WP.inputOptions = {'Sequential', 'Randomized', 'Pre-arranged'};
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
        
	WP.name = 'Ses Trigger';
        WP.handleseed = 'Xin.UI.H0.Panelette';
        WP.type = 'RockerSwitch';	
        WP.row      = S.PnltCurrent.row;
        WP.column   = S.PnltCurrent.column;
            S.PnltCurrent.column = S.PnltCurrent.column + 1;
        WP.text = { 'Triggers'};
        WP.tip = {  'Triggers'};
        WP.inputOptions = { 'HardwareRec',	'SoftwareRec',	'SoftwareGrab'};
        WP.inputDefault = 3;
        WP.inputEnable = {  'inactive',     'inactive',     'inactive'};
        Panelette(S, WP, 'Xin');
        Xin.UI.H.hSes_CamTrigger_Rocker =	Xin.UI.H0.Panelette{WP.row,WP.column}.hRocker{1};
        set(Xin.UI.H.hSes_CamTrigger_Rocker,  'Tag',  'hSes_CamTrigger_Rocker');
        clear WP; 
        
  	WP.name = 'Ses Frame #';
        WP.handleseed =	'Xin.UI.H0.Panelette';
        WP.type = 'Edit';           
        WP.row      = S.PnltCurrent.row;
        WP.column   = S.PnltCurrent.column;
            S.PnltCurrent.column = S.PnltCurrent.column + 1;     
        WP.text = {	'Frame Available) Frame Acquired (frames)',...
                    'Frame SesTotal (frames)'};
        WP.tip = {	'Frame Available / Frame Acquired (frames)',...
                    'Frame SesTotal (frames)'};
        WP.inputValue = {   [Xin.D.Ses.FrameAvailable Xin.D.Ses.FrameAcquired],...
                            Xin.D.Ses.FrameTotal};
        WP.inputFormat = {'%d)%d','%d'};    
        WP.inputEnable = {'off','off'};
        Panelette(S, WP, 'Xin');    
        Xin.UI.H.hSes_FrameAcquired_Edit =	Xin.UI.H0.Panelette{WP.row,WP.column}.hEdit{1};
        Xin.UI.H.hSes_FrameTotal_Edit =     Xin.UI.H0.Panelette{WP.row,WP.column}.hEdit{2}; 
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

	WP.name = 'Mon PreviewDisp';
        WP.handleseed = 'Xin.UI.H0.Panelette';
        WP.type = 'ToggleSwitch';	
        WP.row      = S.PnltCurrent.row;
        WP.column   = S.PnltCurrent.column;
            S.PnltCurrent.column = S.PnltCurrent.column + 1;
        WP.text = { 'Display ROI', 'Display Ref'};
        WP.tip = {  [   'Display ROI mode:\n',...
                        '\tDisplay full FOV;\n',...
                        '\tDisplay the ROI;\n',...
                        '\tDraw ROI.'] ,...
                    [   'Load & Display a reference image',...
                        '']...
                    };
        WP.inputOptions = {	'Full', 'ROI',  'Draw';...
                            'Raw',  'Ref',  'Load'...
                            };
        WP.inputDefault = [1, 1];
        Panelette(S, WP, 'Xin');
        Xin.UI.H.hVol_DisplayMode_Rocker =   	Xin.UI.H0.Panelette{WP.row,WP.column}.hToggle{1};
        Xin.UI.H.hVol_DisplayRef_Rocker =   	Xin.UI.H0.Panelette{WP.row,WP.column}.hToggle{2};
        set(Xin.UI.H.hVol_DisplayMode_Rocker,   'Tag',	'hVol_DisplayMode_Rocker');
        set(Xin.UI.H.hVol_DisplayRef_Rocker,	'Tag',	'hVol_DisplayRef_Rocker');
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
        WP.inputValue = {   Xin.D.Sys.Camera.PreviewStrFR,...
                            Xin.D.Sys.Camera.PreviewStrTS};
        WP.inputFormat = {'%s','%s'};    
        WP.inputEnable = {'off','off'};
        Panelette(S, WP, 'Xin');    
        Xin.UI.H.hVol_CamPreviewFR_Edit =	Xin.UI.H0.Panelette{WP.row,WP.column}.hEdit{1};
        Xin.UI.H.hVol_CamPreviewTS_Edit =	Xin.UI.H0.Panelette{WP.row,WP.column}.hEdit{2};
        set(Xin.UI.H.hVol_CamPreviewFR_Edit, 'tag', 'hVol_CamPreviewFR_Edit');
        set(Xin.UI.H.hVol_CamPreviewTS_Edit, 'tag', 'hVol_CamPreviewTS_Edit');
        clear WP; 
        
  	WP.name = 'Mon Animal';
        WP.handleseed = 'Xin.UI.H0.Panelette';
        WP.type = 'MomentarySwitch'; 
        WP.row =        S.PnltCurrent.row;         
        WP.column =     S.PnltCurrent.column;
            S.PnltCurrent.column = S.PnltCurrent.column + 1;
        WP.text = { 'Pupillometry',...
                    'Animal Monitor'};
        WP.tip = {[ 'Pupillometry',...
                    'Animal Monitor'],...
                  [ 'Pupillometry',...
                    'Monitoring animal''s condition'] };
        WP.inputEnable = {'on','on'};
        Panelette(S, WP, 'Xin');
        Xin.UI.H.hMon_Pupillometry_Momentary =	Xin.UI.H0.Panelette{WP.row,WP.column}.hMomentary{1};
        Xin.UI.H.hMon_AnimalMon_Momentary =     Xin.UI.H0.Panelette{WP.row,WP.column}.hMomentary{2};
        set(Xin.UI.H.hMon_Pupillometry_Momentary,	'tag', 'hMon_Pupillometry_Momentary');
        set(Xin.UI.H.hMon_AnimalMon_Momentary,      'tag', 'hMon_AnimalMon_Momentary');
        set(Xin.UI.H.hMon_Pupillometry_Momentary,	'UserData', 1');
        set(Xin.UI.H.hMon_AnimalMon_Momentary,      'UserData', 2');
        clear WP;  
       
	WP.name = 'Mon SyncRec';
        WP.handleseed = 'Xin.UI.H0.Panelette';
        WP.type = 'ToggleSwitch';	
        WP.row      = S.PnltCurrent.row;
        WP.column   = S.PnltCurrent.column;
            S.PnltCurrent.column = S.PnltCurrent.column + 1;
        WP.text = { 'Preview Switch', 'Sync Rec'};
        WP.tip = {  'Preview Switch',...
                    [   'Synchronized Monitoring Cameras recording\n'...
                        'including both Animal Monitor & Pupillometry']};
        WP.inputOptions = { 'ON', 'OFF', '';...
                            'NO', 'Pupil', 'Both'};
        WP.inputDefault = [1 1];
        Panelette(S, WP, 'Xin');
        Xin.UI.H.hMon_PreviewSwitch_Rocker =   	Xin.UI.H0.Panelette{WP.row,WP.column}.hToggle{1};
        Xin.UI.H.hMon_SyncRec_Rocker =          Xin.UI.H0.Panelette{WP.row,WP.column}.hToggle{2};
        set(Xin.UI.H.hMon_PreviewSwitch_Rocker, 'Tag', 'hMon_PreviewSwitch_Rocker');
        set(Xin.UI.H.hMon_SyncRec_Rocker,       'Tag',  'hMon_SyncRec_Rocker');
        clear WP;
        hc = get(Xin.UI.H.hVol_DisplayMode_Rocker, 'children');
        set(hc(2), 'Enable', 'inactive');

%% Turn the JAVA LookAndFeel Scheme on "Windows"
%     javax.swing.UIManager.setLookAndFeel('com.sun.java.swing.plaf.windows.WindowsLookAndFeel');

%% LOG MSG
msg = [datestr(now, 'yy/mm/dd HH:MM:SS.FFF') '\tSetupFigure\tSetup the GUI for the program\r\n'];
updateMsg(Xin.D.Exp.hLog, msg);