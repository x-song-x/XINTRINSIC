function SetupThorlabsSciCams

global Xin
%% Initiatial the .NET assembly
pathdll = 'C:\Program Files\Thorlabs\Scientific Imaging\Scientific Camera Support\Scientific Camera Interfaces\MATLAB';
% pathdll = 'D:\GitHub\XINTRINSIC\ThorlabsSciCams';
% pathdll = 'D:\GitHub\XINTRINSIC\';
cd(pathdll);
NET.addAssembly([pathdll, '\Thorlabs.TSI.TLCamera.dll']);   % Load TLCamera .NET assembly
% NET.addAssembly([pwd '\Thorlabs.TSI.TLCamera.dll']);   % Load TLCamera .NET assembly
Xin.HW.Thorlabs = [];
Xin.HW.Thorlabs.tlCameraSDK = Thorlabs.TSI.TLCamera.TLCameraSDK.OpenTLCameraSDK;
Xin.HW.Thorlabs.tlCameraSerialNumbers = Xin.HW.Thorlabs.tlCameraSDK.DiscoverAvailableCameras;
	% Get serial numbers of connected TLCameras.
	% Xin.HW.Thorlabs.serialNumbers.Item(i) == '06019', range of i: 0:Xin.HW.Thorlabs.serialNumbers.Count-1
for i = 1:length(Xin.D.Sys.ThorlabsSciCam)
    Xin.HW.Thorlabs.hSciCam{i} = Xin.HW.Thorlabs.tlCameraSDK.OpenCamera(Xin.D.Sys.ThorlabsSciCam(i).serialNumber, false); 
    % For Thorlabs CM2100-USB, SN:06019
    %                                       Model: 	CS2100M-USB
    %                                        Name:  '' [1×1 System.String]
    %                                SerialNumber:  '06019' [1×1 System.String]
    %                            CameraSensorType: Monochrome
    %                                    BitDepth: 16
    %                       SensorPixelSize_bytes: 2
    %                           CameraUSBPortType: USB3_0
    %                      CommunicationInterface: USB
    %                             FirmwareVersion: [1×1 System.String]
    %                          IsCoolingSupported: 0
    %                         IsNIRBoostSupported: 0
    %                       IsTapBalanceSupported: 0
    %               IsUsingOnlyLatestPendingImage: 0
    %                                       IsXyz: 0
    %                MaximumNumberOfFramesToQueue: 1
        % Xin.HW.Thorlabs.hSciCam{i}.GetIsTapsSupported(Thorlabs.TSI.TLCameraInterfaces.Taps.SingleTap) == 0;
        % Xin.HW.Thorlabs.hSciCam{i}.GetIsTapsSupported(Thorlabs.TSI.TLCameraInterfaces.Taps.DualTap)   == 0;
        % Xin.HW.Thorlabs.hSciCam{i}.GetIsTapsSupported(Thorlabs.TSI.TLCameraInterfaces.Taps.QuadTap)   == 0;
    
    Xin.HW.Thorlabs.hSciCam{i}.ExposureTime_us = uint32(Xin.D.Sys.ThorlabsSciCam(i).ExposureTime_ms*1000);   
    %                             ExposureTime_us: 18016
    %                        ExposureTimeRange_us:	Maximum:7767200 Minimum:29
    %                             BlackLevelRange:  Maximum: 0      Minimum: 0
    %                                   GainRange:  Maximum: 0      Minimum: 0
    
    switch Xin.D.Sys.ThorlabsSciCam(i).DataRate
        case 'FPS50';   Xin.HW.Thorlabs.hSciCam{i}.DataRate = Thorlabs.TSI.TLCameraInterfaces.DataRate.FPS50;
        case 'FPS30';   Xin.HW.Thorlabs.hSciCam{i}.DataRate = Thorlabs.TSI.TLCameraInterfaces.DataRate.FPS30;
        case '20MHz';   Xin.HW.Thorlabs.hSciCam{i}.DataRate = Thorlabs.TSI.TLCameraInterfaces.DataRate.ReadoutSpeed20MHz;
        case '40MHz';   Xin.HW.Thorlabs.hSciCam{i}.DataRate = Thorlabs.TSI.TLCameraInterfaces.DataRate.ReadoutSpeed40MHz;
        otherwise
    end
    %                                    DataRate: FPS50
    %                             FramesPerSecond: 50.3449
    %                                FrameTime_us: 19863
    %              FrameRateControlValueRange_fps:  Maximum: 0      Minimum: 0
    %                        SensorReadoutTime_ns: 19863376
    %          IsDynamicFrameRateControlSupported: 0    
    
    roiAndBin = Xin.HW.Thorlabs.hSciCam{i}.ROIAndBin;
        roiAndBin.BinX =    int32(Xin.D.Sys.ThorlabsSciCam(i).BinX);
        roiAndBin.BinY =    int32(Xin.D.Sys.ThorlabsSciCam(i).BinY);
        roiAndBin.ROIOriginX_pixels =   Xin.D.Sys.ThorlabsSciCam(i).ROIOriginX;	% 0-1919
        roiAndBin.ROIOriginY_pixels =   Xin.D.Sys.ThorlabsSciCam(i).ROIOriginY;	% 0-1079
        roiAndBin.ROIWidth_pixels =     Xin.D.Sys.ThorlabsSciCam(i).ROIWidth;
        roiAndBin.ROIHeight_pixels =    Xin.D.Sys.ThorlabsSciCam(i).ROIHeight;
        Xin.HW.Thorlabs.hSciCam{i}.ROIAndBin = roiAndBin;
    %                                   ROIAndBin: [1×1 Thorlabs.TSI.TLCameraInterfaces.ROIAndBin]
    %                                                 ROIOriginX_pixels: 0
    %                                                 ROIOriginY_pixels: 0
    %                                                   ROIWidth_pixels: 1920
    %                                                  ROIHeight_pixels: 1080
    %                                                              BinX: 1
    %                                                              BinY: 1
    %                                   BinXRange:  Maximum: 16     Minimum: 1
    %                                   BinYRange:  Maximum: 16     Minimum: 1
    %                             ROIOriginXRange: 	Maximum: 1912   Minimum: 0
    %                             ROIOriginYRange: 	Maximum: 1078   Minimum: 0
    %                          SensorWidth_pixels: 1920
    %                         SensorHeight_pixels: 1080
    %                         SensorPixelWidth_um: 5.0400
    %                           ImageWidth_pixels: 960
    %                          ImageHeight_pixels: 540  
    
    
    Xin.HW.Thorlabs.hSciCam{i}.FramesPerTrigger_zeroForUnlimited = 0; % 0 = continuous
    Xin.HW.Thorlabs.hSciCam{i}.OperationMode =      Thorlabs.TSI.TLCameraInterfaces.OperationMode.SoftwareTriggered;
    switch Xin.D.Sys.ThorlabsSciCam(i).TriggerPolarity
        case 'ActiveHigh';  Xin.HW.Thorlabs.hSciCam{i}.TriggerPolarity =    Thorlabs.TSI.TLCameraInterfaces.TriggerPolarity.ActiveHigh;
        case 'ActiveLow';   Xin.HW.Thorlabs.hSciCam{i}.TriggerPolarity =    Thorlabs.TSI.TLCameraInterfaces.TriggerPolarity.ActiveLow;
    end
    %                               OperationMode: SoftwareTriggered
    %           FramesPerTrigger_zeroForUnlimited: 0
    %                       FramesPerTriggerRange:  Maximum:4294967280 Minimum:0
    %                             TriggerPolarity: ActiveHigh
    %                              IsEEPSupported: 1 % equal exposure pulse
    %                                   EEPStatus: Disabled
        % Hardware Trigger Settings: "None",    Thorlabs.TSI.TLCameraInterfaces.OperationMode.SoftwareTriggered;
        % Hardware Trigger Settings: "Standard",Thorlabs.TSI.TLCameraInterfaces.OperationMode.HardwareTriggered;
        % Hardware Trigger Settings: "PDX",     Thorlabs.TSI.TLCameraInterfaces.OperationMode.Bulb; 
        % Hardware Trigger Polarity: "On High"  Thorlabs.TSI.TLCameraInterfaces.TriggerPolarity.ActiveHigh;
        % Hardware Trigger Polarity: "On Low"   Thorlabs.TSI.TLCameraInterfaces.TriggerPolarity.ActiveLow;
    
    %                 IsHotPixelCorrectionEnabled: 0
    %                 HotPixelCorrectionThreshold: 8191
    %            HotPixelCorrectionThresholdRange:  Maximum: 65535  Minimum: 655
    %                                  Dispatcher: [1×1 System.Windows.Threading.Dispatcher]
    %                                     IsLEDOn: 1
    %                              IsLEDSupported: 1
    %                    timeStampClockBaseOrNull: [1×1 System.Nullable<System*UInt64>]
    %        IsVerboseDiagnosticsMessagingEnabled: 0
    %                      numberExposureAttempts: 3
    %                        NumberOfQueuedFrames: 0
    % CameraColorCorrectionMatrixOutputColorSpace: CCIR_709
    
    %                                     IsArmed: 0
    %                                  IsDisposed: 0

    %%    

    Xin.D.Sys.ThorlabsSciCam(i).Shutter =       Xin.D.Sys.ThorlabsSciCam(i).ExposureTime_ms; 
    Xin.D.Sys.ThorlabsSciCam(i).DispGainBit =	0;
	Xin.D.Sys.ThorlabsSciCam(i).DispGainNum =	2^Xin.D.Sys.ThorlabsSciCam(i).DispGainBit;
    Xin.D.Sys.ThorlabsSciCam(i).DispPeriod =	1/Xin.D.Sys.ThorlabsSciCam(i).PreviewRate;
    
    Xin.D.Sys.ThorlabsSciCam(i).PreviewClipROI =	0;
    Xin.D.Sys.ThorlabsSciCam(i).PreviewRef =        0;   
    if i == 1
        Xin.D.Sys.ThorlabsSciCam(i).DispImgGO =     uint8(zeros(Xin.D.Sys.Camera.DispHeight,...
                                                                Xin.D.Sys.Camera.DispWidth));
        Xin.D.Sys.ThorlabsSciCam(i).DispImgOO =     Xin.D.Sys.ThorlabsSciCam(i).DispImgGO;
        Xin.D.Sys.ThorlabsSciCam(i).DispImg =       Xin.D.Sys.ThorlabsSciCam(i).DispImgGO;
        Xin.D.Sys.ThorlabsSciCam(i).DispImg3 =      uint8(zeros(Xin.D.Sys.Camera.DispHeight,...
                                                                Xin.D.Sys.Camera.DispWidth, 3));
        Xin.D.Sys.ThorlabsSciCam(i).DispHeightIndex = (1:Xin.D.Sys.ThorlabsSciCam(i).pvRawHeight) + ...
                                                    round((Xin.D.Sys.Camera.DispHeight - ...
                                                    Xin.D.Sys.ThorlabsSciCam(i).pvRawHeight)/2);
        Xin.D.Sys.ThorlabsSciCam(i).DispWidthIndex = (1:Xin.D.Sys.ThorlabsSciCam(i).pvRawWidth) + ...
                                                    round((Xin.D.Sys.Camera.DispWidth - ...
                                                    Xin.D.Sys.ThorlabsSciCam(i).pvRawWidth)/2); 
    end
    if Xin.D.Sys.ThorlabsSciCam(i).UpdatePreviewHistogram
        Xin.D.Sys.ThorlabsSciCam(i).DispHistMax =	max(Xin.D.Sys.ThorlabsSciCam(i).DispImg, [], 2);
        Xin.D.Sys.ThorlabsSciCam(i).DispHistMean =	Xin.D.Sys.ThorlabsSciCam(i).DispHistMax; 
        Xin.D.Sys.ThorlabsSciCam(i).DispHistMin =	Xin.D.Sys.ThorlabsSciCam(i).DispHistMax;
    end
    
end

%% LOG MSG
msg = [datestr(now, 'yy/mm/dd HH:MM:SS.FFF') '\tSetupThorlabsCams\tSetup Thorlabs Cameras\r\n'];  
updateMsg(Xin.D.Exp.hLog, msg);

return




