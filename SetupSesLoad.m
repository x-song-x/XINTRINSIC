function SetupSesLoad(MainVarStr, LoadSourceStr)
% This function load recording session related stuff, and return updated
% information both in the LO (LoadOut) and GUI objects in the MainVarStr 
% ('Xin' or 'TP')
%       MainVarStr:     'Xin' or 'TP'
%       LoadSourceStr:  'Sound', 'AddAtts', 'CycleNumTotal', 'TrlOrder'

%   Sound, Additional Attenuations,  and generate according
% Trl play structures

global TP Xin
persistent L

%% L: Load In
str = ['L.Ses = ', MainVarStr, '.D.Ses.Load;'];	eval(str);
str = ['L.Trl = ', MainVarStr, '.D.Trl.Load;'];	eval(str);

%% LoadSource Selection
                            LS = 0;
switch LoadSourceStr
    case 'Sound',           LS = 4;
    case 'AddAtts',         LS = 3;
    case 'CycleNumTotal',   LS = 2;
    case 'TrlOrder',        LS = 1;
    otherwise
        errordlg('SetupSesLoad input error');
end
%% Load Sound
if LS>=4
    % Load the Sound File & Update Parameters
	filestr =                   [L.Ses.SoundDir, L.Ses.SoundFile];
    SoundRaw =                  audioread(filestr, 'native');
    SoundInfo =                 audioinfo(filestr);       
                                        L.Ses.SoundTitle =      SoundInfo.Title;
                                        L.Ses.SoundArtist =     SoundInfo.Artist;
                                        L.Ses.SoundComment =	SoundInfo.Comment;
                                        L.Ses.SoundFigureTitle= [': sound "' L.Ses.SoundFile '" loaded'];
                                        L.Ses.SoundWave =       SoundRaw;         
                                        L.Ses.SoundDurTotal =	length(SoundRaw)/L.Ses.SoundSR; 
    part = {}; i = 1;
    remain =                            L.Ses.SoundComment;
    while ~isempty(remain)
        [part{i}, remain] = strtok(remain, ';');
        [argu, value]=      strtok(part{i}, ':');
        argu =              argu(2:end);
        value =             value(3:end);
        switch argu                
            case 'TrialNames';          value = textscan(value, '%s', 'Delimiter', ' ');
                                        L.Trl.Names = value{1};
            case 'TrialAttenuations';   value = textscan(value, '%f');
                                        L.Trl.Attenuations = value{1};

            case 'TrialNumberTotal';	L.Trl.SoundNumTotal =	str2double(value);
            case 'TrialDurTotal(sec)';	L.Trl.DurTotal =        str2double(value);
                                        L.Trl.DurCurrent =      NaN;  
            case 'TrialDurPreStim(sec)';L.Trl.DurPreStim =      str2double(value);
            case 'TrialDurStim(sec)';   L.Trl.DurStim =         str2double(value);
            case ''
            otherwise;                  disp(argu);
        end
        i = i+1;
    end
                                        L.Trl.DurPostStim =     L.Trl.DurTotal - ...
                                                                L.Trl.DurPreStim - ...
                                                                L.Trl.DurStim;
                                        L.Ses.SoundMat =        reshape(L.Ses.SoundWave,...
                                                                    length(L.Ses.SoundWave)/L.Trl.SoundNumTotal,...
                                                                    L.Trl.SoundNumTotal);
	if round(   length(SoundRaw)/L.Ses.SoundSR ) ~=...
                length(SoundRaw)/L.Ses.SoundSR
        warndlg('The sound length is NOT in integer seconds');
	end    
	set(findobj('tag', 'hSes_SoundDurTotal_Edit'),      'String',   sprintf('%5.1f (s)', L.Ses.SoundDurTotal));
	set(findobj('tag', 'hTrl_SoundNumTotal_Edit'),      'String',   num2str(L.Trl.SoundNumTotal));
    set(findobj('tag', 'hTrl_DurTotal_Edit'),           'String',   sprintf('%5.1f (s)', L.Trl.DurTotal));
    set(findobj('tag', 'hTrl_DurCurrent_Edit'),         'String',   sprintf('%5.1f (s)', L.Trl.DurCurrent));   
end

%% Load AddAtts
if LS>=3
    L.Ses.AddAttNumTotal =      length(L.Ses.AddAtts);
    L.Ses.CycleDurTotal =       L.Ses.SoundDurTotal * L.Ses.AddAttNumTotal;        
    L.Ses.CycleDurCurrent =     NaN;
    L.Trl.NumTotal =            L.Trl.SoundNumTotal * L.Ses.AddAttNumTotal;
    L.Trl.NumCurrent =          NaN;            
    L.Trl.AttNumCurrent =       NaN;
    L.Trl.AttDesignCurrent =    NaN;
    L.Trl.AttAddCurrent =       NaN;
    L.Trl.AttCurrent =          NaN;
    L.Ses.TrlIndexSoundNum =    repmat(1:L.Trl.SoundNumTotal, 1, L.Ses.AddAttNumTotal);
    L.Ses.TrlIndexAddAttNum =   repelem(1:L.Ses.AddAttNumTotal, L.Trl.SoundNumTotal);

    set(findobj('tag', 'hSes_AddAttNumTotal_Edit'),	'String',   num2str(L.Ses.AddAttNumTotal));
    set(findobj('tag', 'hSes_CycleDurTotal_Edit'), 	'String',	sprintf('%5.1f (s)', L.Ses.CycleDurTotal));
    set(findobj('tag', 'hSes_CycleDurCurrent_Edit'),'String',   sprintf('%5.1f (s)', L.Ses.CycleDurCurrent));
    set(findobj('tag', 'hTrl_NumTotal_Edit'),       'String',   num2str(L.Trl.NumTotal));
    set(findobj('tag', 'hTrl_NumCurrent_Edit'),     'String',   num2str(L.Trl.NumCurrent));
    set(findobj('tag', 'hTrl_AttDesignCurrent_Edit'),'String',	sprintf('%5.1f (dB)',L.Trl.AttDesignCurrent));
    set(findobj('tag', 'hTrl_AttAddCurrent_Edit'),	'String',	sprintf('%5.1f (dB)',L.Trl.AttAddCurrent));
    set(findobj('tag', 'hTrl_AttCurrent_Edit'),     'String',	sprintf('%5.1f (dB)',L.Trl.AttCurrent));

end

%% Load CycleNumTotal
if LS>=2
    L.Ses.CycleNumCurrent =	NaN; 
    L.Ses.DurTotal =        L.Ses.CycleDurTotal * L.Ses.CycleNumTotal;        
    L.Ses.DurCurrent =      NaN;  
    set(findobj('tag', 'hSes_CycleNumTotal_Edit'),	'String',   num2str(L.Ses.CycleNumTotal));
    set(findobj('tag', 'hSes_CycleNumCurrent_Edit'),'String',   num2str(L.Ses.CycleNumCurrent));
    set(findobj('tag', 'hSes_DurTotal_Edit'),       'String',   sprintf('%5.1f (s)', L.Ses.DurTotal));
    set(findobj('tag', 'hSes_DurCurrent_Edit'),     'String',   sprintf('%5.1f (s)', L.Ses.DurCurrent)); 
end


%% Load TrlOrder
if LS>=1
    switch L.Ses.TrlOrder
        case 'Sequential'
            L.Ses.TrlOrderMat =     repmat(1:L.Trl.NumTotal, L.Ses.CycleNumTotal, 1);
        case 'Randomized'
            L.Ses.TrlOrderMat =     [];
            for i = 1:L.Ses.CycleNumTotal
                L.Ses.TrlOrderMat = [L.Ses.TrlOrderMat; randperm(L.Trl.NumTotal)];
            end            
        otherwise
            errordlg('wrong trial order option');
    end
    L.Ses.TrlOrderVec =             reshape(L.Ses.TrlOrderMat',1,[]); % AddAtt Order
    L.Ses.TrlOrderSoundVec =        L.Ses.TrlIndexSoundNum(L.Ses.TrlOrderVec);
        
    L.Trl.StimNumCurrent =      NaN;
    L.Trl.StimNumNext =         NaN;
    L.Trl.SoundNumCurrent =    	NaN;
    L.Trl.SoundNameCurrent =    '';
    set(findobj('tag', 'hTrl_StimNumCurrent_Edit'),     'String',	num2str(L.Trl.StimNumCurrent));
    set(findobj('tag', 'hTrl_StimNumNext_Edit'),        'String',	num2str(L.Trl.StimNumNext));
    set(findobj('tag', 'hTrl_SoundNumCurrent_Edit'),	'String',   num2str(L.Trl.SoundNumCurrent));
    set(findobj('tag', 'hTrl_SoundNameCurrent_Edit'),   'String',	num2str(L.Trl.SoundNameCurrent));    
end

%% L: Load Out
str = [MainVarStr, '.D.Ses.Load = L.Ses;'];	eval(str);
str = [MainVarStr, '.D.Trl.Load = L.Trl;']; eval(str);

%% XINTRINSIC or FANTASIA Specific Updates, after write back Load
switch MainVarStr
    case 'Xin'
        Xin.D.Ses.UpdateNumTotal =      Xin.D.Ses.Load.DurTotal * Xin.D.Sys.NIDAQ.Task_AI_Xin.time.updateRate;
        Xin.D.Ses.UpdateNumCurrent =    NaN;      
        Xin.D.Ses.UpdateNumCurrentAI =  NaN;    
        Xin.D.Ses.FrameTotal =      Xin.D.Ses.Load.DurTotal * Xin.D.Sys.PointGreyCam(2).FrameRate; 
        Xin.D.Ses.FrameRequested =	NaN;    
        Xin.D.Ses.FrameAcquired =   NaN;    
        Xin.D.Ses.FrameAvailable =  NaN;                     
        Xin.D.Sys.NIDAQ.Task_AO_Xin.time.sampsPerChanToAcquire = ...
                                    length( Xin.D.Ses.Load.SoundWave)*...
                                    Xin.D.Ses.Load.AddAttNumTotal*...
                                    Xin.D.Ses.Load.CycleNumTotal;
        set(Xin.UI.H.hSes_FrameTotal_Edit,      'String', 	num2str(Xin.D.Ses.FrameTotal));
        set(Xin.UI.H.hSes_FrameAcquired_Edit,   'String',   num2str(Xin.D.Ses.FrameAcquired) );
        set(Xin.UI.H.hSes_FrameAvailable_Edit,  'String',   num2str(Xin.D.Ses.FrameAvailable) ); 
    case 'TP'
    otherwise
end
