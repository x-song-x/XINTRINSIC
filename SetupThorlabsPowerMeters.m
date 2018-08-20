function msg = SetupThorlabsPowerMeters
% This function setup Thorlabs Power Meters
% as defined in SetupD

%% import handles and data
global Xin

%% instrreset for clean up !!!
instrreset;
pause(1);

%% Power Meter through NI VISA interface
temp = Xin.D.Sys.PowerMeter;
for i = 1:length(temp)
    Xin.HW.Thorlabs.PM100{i}.name =     Xin.D.Sys.PowerMeter{1}.Console;
    Xin.HW.Thorlabs.PM100{i}.h =        visa('ni', Xin.D.Sys.PowerMeter{1}.RSRCNAME);
    fopen(          Xin.HW.Thorlabs.PM100{i}.h);    
    fprintf(        Xin.HW.Thorlabs.PM100{i}.h,'*RST');     % Reset the device
	fprintf(        Xin.HW.Thorlabs.PM100{i}.h,'*TST?');	% Self test
  	temp =          Xin.HW.Thorlabs.PM100{i}.h.fscanf;
    if ~strcmp(temp(1),'0')
        errordlg('The Thorlabs Power Meter cannot pass self test');
        return;
    end 
    fprintf(        Xin.HW.Thorlabs.PM100{i}.h,'*IDN?');	% Identification 
    temp =          Xin.HW.Thorlabs.PM100{i}.h.fscanf;
    Xin.D.Sys.PowerMeter{1}.IDeNtification = temp;
                        % Thorlabs,PM100A,P1003352,2.4.0
                        % Thorlabs,PM100USB,P2004081,1.4.0
                        % THORLABS,MMM,SSS,X.X.X  
                        % Where:    MMM  is the model code 
                        %           SSS  is the serial number 
                        %           X.X.X is the instrument firmware revision level  
    fprintf(        Xin.HW.Thorlabs.PM100{i}.h, ...
        ['SYST:LFR ', num2str(Xin.D.Sys.PowerMeter{1}.LineFRequency)]);
                                                            % Setup line filter
    fprintf(        Xin.HW.Thorlabs.PM100{i}.h,'SYST:SENS:IDN?');  
    temp =          Xin.HW.Thorlabs.PM100{i}.h.fscanf;   	% Sensor
   	Xin.D.Sys.PowerMeter{1}.SENSor = temp;
                % strtok(Xin.HW.Thorlabs.PM100{i}.h.fscanf,',');
                        % S140C,11040529,05-Apr-2011,1,18,289
                        % S121C,14081201,12-Aug-2014,1,18,289
                        % S310C,130801,29-JUL-2013,2,18,289
                        % S170C,701207,17-Dec-2014,1,2,33
                        % <name>,<sn>,<cal_msg>,<type>, <subtype>,<flags>
                        % <name>:       Sensor name in string response format 
                        % <sn>:         Sensor serial number in string response format 
                        % <cal_msg>:    Calibration message in string response format 
                        % <type>:       Sensor type in NR1 format 
                        % <subtype>:    Sensor subtype in NR1 format 
                        % <flags>:      Sensor flags as bitmap in NR1 format. 
                        % Flag:  Dec.value: 
                        % Is power sensor           1 
                        % Is energy sensor          2 
                        % Response settable         16 
                        % Wavelength settable       32 
                        % Tau settable              64 
                        % Has temperature sensor	256 
    fprintf(        Xin.HW.Thorlabs.PM100{i}.h,'DISP:BRIG 0');...
                                                            % Disp Brightness (0-1)  
    fprintf(        Xin.HW.Thorlabs.PM100{i}.h,'CAL:STR?');
    temp =          Xin.HW.Thorlabs.PM100{i}.h.fscanf;      % CALibration STRing
    Xin.D.Sys.PowerMeter{1}.CALibrationSTRing = temp;
    fprintf(        Xin.HW.Thorlabs.PM100{i}.h,...          % Average Counts (1~=.3ms)
        ['SENS:AVER:COUN ', num2str(Xin.D.Sys.PowerMeter{1}.AVERageCOUNt)]);
  	fprintf(        Xin.HW.Thorlabs.PM100{i}.h,...      	% Wavelength (nm)
        ['SENS:CORR:WAV ',  num2str(Xin.D.Sys.PowerMeter{1}.WAVelength)]);
 	fprintf(        Xin.HW.Thorlabs.PM100{i}.h,...          % Power Range Upper (W)
        ['SENS:POW:RANG:UPP ', num2str(Xin.D.Sys.PowerMeter{1}.POWerRANGeUPPer)]);
    fprintf(        Xin.HW.Thorlabs.PM100{i}.h,...          % Sensor Bandwidth (0=High, 1=Low)
        ['INP:PDI:FILT:LPAS:STAT ', num2str(Xin.D.Sys.PowerMeter{1}.INPutFILTering)]);
    
    % Send request 1st to save following read time
    if Xin.D.Sys.PowerMeter{1}.InitialMEAsurement == 1
        fprintf(    Xin.HW.Thorlabs.PM100{1}.h,  'MEAS:POW?'); 
        Xin.D.Mon.Power.QueryFlag = 1;
    end
end

%% LOG MSG
msg = [datestr(now, 'yy/mm/dd HH:MM:SS.FFF') '\tSetupThorlabsPowerMeter\tSetup Thorlabs Power Meters\r\n'];
updateMsg(Xin.D.Exp.hLog, msg);
