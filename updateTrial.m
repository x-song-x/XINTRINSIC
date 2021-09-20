function updateTrial(~,~)
global Xin

if  Xin.D.Ses.UpdateNumCurrent < Xin.D.Ses.UpdateNumTotal     
%     disp(['updateTrial: ', datestr(now, 'yyyymmdd HH:MM:SS.FFF')]);
	%% Recording Duration Update  
    Xin.D.Ses.UpdateNumCurrent =	Xin.D.Ses.UpdateNumCurrent + 1; 
    Xin.D.Ses.Load.DurCurrent =     Xin.D.Ses.UpdateNumCurrent/...
                                    Xin.D.Sys.NIDAQ.Task_AI_Xin.time.updateRate;
    Xin.D.Ses.Load.CycleDurCurrent =     mod( Xin.D.Ses.Load.DurCurrent,      Xin.D.Ses.Load.CycleDurTotal);
    Xin.D.Trl.Load.DurCurrent =          mod( Xin.D.Ses.Load.CycleDurCurrent, Xin.D.Trl.Load.DurTotal); 
	set(Xin.UI.H.hSes_DurCurrent_Edit,      'string',	sprintf('%5.1f (s)', Xin.D.Ses.Load.DurCurrent));
    set(Xin.UI.H.hSes_CycleDurCurrent_Edit,	'string',	sprintf('%5.1f (s)', Xin.D.Ses.Load.CycleDurCurrent)); 
    set(Xin.UI.H.hTrl_DurCurrent_Edit,      'string',   sprintf('%5.1f (s)', Xin.D.Trl.Load.DurCurrent));

    %% Recording Cycle Number Update  
	c = floor(Xin.D.Ses.Load.DurCurrent/Xin.D.Ses.Load.CycleDurTotal)+1;  % Current Cycle Number
    if c~= Xin.D.Ses.Load.CycleNumCurrent && c<=Xin.D.Ses.Load.CycleNumTotal % && c
%         % Cycle Update: (c changed & c<=CNT)
        Xin.D.Ses.Load.CycleNumCurrent =    c;
        if c>1      % here is the best place to callback any cycle based stimulus control
        end
        set(Xin.UI.H.hSes_CycleNumCurrent_Edit,'string',	num2str(Xin.D.Ses.Load.CycleNumCurrent));
        msg =   [datestr(now, 'yy/mm/dd HH:MM:SS.FFF') '\tupdateTrial\tCycle # is ' num2str(c) '\r\n'];
        updateMsg(Xin.D.Exp.hLog, msg);
    end
    %% Recording Trial Number Update
    t =	floor(Xin.D.Ses.Load.CycleDurCurrent/Xin.D.Trl.Load.DurTotal)+1;  % Current Trial Number
    if Xin.D.Ses.UpdateNumCurrent == Xin.D.Ses.UpdateNumTotal   % Session ends
        Xin.D.Trl.Load.DurCurrent =      Xin.D.Trl.Load.DurTotal;
        set(Xin.UI.H.hTrl_DurCurrent_Edit,	'string',   sprintf('%5.1f', Xin.D.Trl.Load.DurCurrent));
    elseif t ~= Xin.D.Trl.Load.NumCurrent 
        % Trial update: (t changed & session not ended)         
        Xin.D.Trl.Load.NumCurrent =      t;
        tt =                        (c-1)*Xin.D.Trl.Load.NumTotal + t; % # of total trl played
        stimnum =                   Xin.D.Ses.Load.TrlOrderVec(tt);
            Xin.D.Trl.Load.StimNumCurrent =	['#', num2str(Xin.D.Ses.Load.TrlOrderVec(tt))];
        try 
            Xin.D.Trl.Load.StimNumNext =	['#', num2str(Xin.D.Ses.Load.TrlOrderVec(tt+1))];
        catch
            Xin.D.Trl.Load.StimNumNext =	'end';
        end
            Xin.D.Trl.Load.SoundNumCurrent = Xin.D.Ses.Load.TrlIndexSoundNum(stimnum);
        try
            Xin.D.Trl.Load.SoundNameCurrent = ...
                                            Xin.D.Trl.Load.Names{Xin.D.Trl.Load.SoundNumCurrent};
        catch
            Xin.D.Trl.Load.SoundNameCurrent = ...
                                            '???';
        end                                           
        Xin.D.Trl.Load.AttDesginCurrent =   Xin.D.Trl.Load.Attenuations(Xin.D.Trl.Load.SoundNumCurrent);
        Xin.D.Trl.Load.AttNumCurrent =      Xin.D.Ses.Load.TrlIndexAddAttNum(stimnum);
        Xin.D.Trl.Load.AttAddCurrent =      Xin.D.Ses.Load.AddAtts(Xin.D.Trl.Load.AttNumCurrent);        
        Xin.D.Trl.Load.AttCurrent =         Xin.D.Trl.Load.AttDesginCurrent + Xin.D.Trl.Load.AttAddCurrent;
        
        % Real Updates, for PA5
        if Xin.D.Sys.TDT_PA5_OnOff
            Xin.HW.TDT.PA5.SetAtten(Xin.D.Trl.Load.AttCurrent);    
        end
        % Real Updates, for GUI
        set(Xin.UI.H.hTrl_NumCurrent_Edit,      'String',	num2str(Xin.D.Trl.Load.NumCurrent));
        set(Xin.UI.H.hTrl_StimNumCurrent_Edit,  'String',	Xin.D.Trl.Load.StimNumCurrent);
        set(Xin.UI.H.hTrl_StimNumNext_Edit,     'String',	Xin.D.Trl.Load.StimNumNext);
        set(Xin.UI.H.hTrl_SoundNumCurrent_Edit,	'String',	num2str(Xin.D.Trl.Load.SoundNumCurrent));
        set(Xin.UI.H.hTrl_SoundNameCurrent_Edit,'String',	Xin.D.Trl.Load.SoundNameCurrent);
        set(Xin.UI.H.hTrl_AttDesignCurrent_Edit,'String',	sprintf('%5.1f (dB)',Xin.D.Trl.Load.AttDesginCurrent));
        set(Xin.UI.H.hTrl_AttAddCurrent_Edit,	'String',	sprintf('%5.1f (dB)',Xin.D.Trl.Load.AttAddCurrent));
        set(Xin.UI.H.hTrl_AttCurrent_Edit,      'String',	sprintf('%5.1f (dB)',Xin.D.Trl.Load.AttCurrent));
        msg =   [datestr(now, 'yy/mm/dd HH:MM:SS.FFF') '\tupdateTrial\tTrial # is ' num2str(t) '\r\n'];
        updateMsg(Xin.D.Exp.hLog, msg);
    end

end
