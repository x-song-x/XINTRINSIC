function updateTrial(~,~)
global Xin

if  Xin.D.Ses.UpdateNumCurrent < Xin.D.Ses.UpdateNumTotal     
%     disp(['updateTrial: ', datestr(now, 'yyyymmdd HH:MM:SS.FFF')]);
	%% Recording Duration Update  
    Xin.D.Ses.UpdateNumCurrent =	Xin.D.Ses.UpdateNumCurrent + 1; 
    Xin.D.Ses.DurCurrent =          Xin.D.Ses.UpdateNumCurrent/...
                                    Xin.D.Sys.NIDAQ.Task_AI_Xin.time.updateRate;
    Xin.D.Ses.CycleDurCurrent =     mod( Xin.D.Ses.DurCurrent,      Xin.D.Ses.CycleDurTotal);
    Xin.D.Trl.DurCurrent =          mod( Xin.D.Ses.CycleDurCurrent, Xin.D.Trl.DurTotal); 
	set(Xin.UI.H.hSes_DurCurrent_Edit,      'string',	sprintf('%5.1f (s)', Xin.D.Ses.DurCurrent));
    set(Xin.UI.H.hSes_CycleDurCurrent_Edit,	'string',	sprintf('%5.1f (s)', Xin.D.Ses.CycleDurCurrent)); 
    set(Xin.UI.H.hTrl_DurCurrent_Edit,      'string',   sprintf('%5.1f (s)', Xin.D.Trl.DurCurrent));

    %% Recording Cycle Number Update  
	c = floor(Xin.D.Ses.DurCurrent/Xin.D.Ses.CycleDurTotal)+1;  % Current Cycle Number
    if c~= Xin.D.Ses.CycleNumCurrent && c<=Xin.D.Ses.CycleNumTotal % && c
        % Cycle Update: (c changed & c<=CNT)
        Xin.D.Ses.CycleNumCurrent =    c;
        set(Xin.UI.H.hSes_CycleNumCurrent_Edit,'string',	num2str(Xin.D.Ses.CycleNumCurrent));
        msg =   [datestr(now, 'yy/mm/dd HH:MM:SS.FFF') '\tupdatePower\tCycle # is ' num2str(c) '\r\n'];
        updateMsg(Xin.D.Exp.hLog, msg);
    end
    %% Recording Trial Number Update
    t =	floor(Xin.D.Ses.CycleDurCurrent/Xin.D.Trl.DurTotal)+1;  % Current Trial Number
    if Xin.D.Ses.UpdateNumCurrent == Xin.D.Ses.UpdateNumTotal   % Session ends
        Xin.D.Trl.DurCurrent =      Xin.D.Trl.DurTotal;
        set(Xin.UI.H.hTrl_DurCurrent_Edit,	'string',   sprintf('%5.1f', Xin.D.Trl.DurCurrent));
    elseif t ~= Xin.D.Trl.NumCurrent 
        % Trial update: (t changed & session not ended) 
        Xin.D.Trl.NumCurrent =      t;
        tt =                        (c-1)*Xin.D.Trl.NumTotal + t; % # of total trl played
        stimnum =                   Xin.D.Ses.TrlOrderVec(tt);
        Xin.D.Trl.StimNumCurrent =	['#', num2str(Xin.D.Ses.TrlOrderVec(tt))];
        try 
            Xin.D.Trl.StimNumNext =	['#', num2str(Xin.D.Ses.TrlOrderVec(tt+1))];
        catch
            Xin.D.Trl.StimNumNext =	'end';
        end
        Xin.D.Trl.SoundNumCurrent = Xin.D.Ses.TrlIndexSoundNum(stimnum);
        try
            Xin.D.Trl.SoundNameCurrent = ...
                                    Xin.D.Trl.Names{Xin.D.Trl.SoundNumCurrent};
        catch
            Xin.D.Trl.SoundNameCurrent = ...
                                    '???';
        end                                           
        Xin.D.Trl.AttDesginCurrent =Xin.D.Trl.Attenuations(Xin.D.Trl.SoundNumCurrent);
        Xin.D.Trl.AttNumCurrent =	Xin.D.Ses.TrlIndexAddAttNum(stimnum);
        Xin.D.Trl.AttAddCurrent =   Xin.D.Ses.AddAtts(Xin.D.Trl.AttNumCurrent);        
        Xin.D.Trl.AttCurrent =      Xin.D.Trl.AttDesginCurrent + Xin.D.Trl.AttAddCurrent;
        
        % Real Updates
        invoke(Xin.HW.TDT.PA5,                  'SetAtten', Xin.D.Trl.AttCurrent);        
        set(Xin.UI.H.hTrl_NumCurrent_Edit,      'String',	num2str(Xin.D.Trl.NumCurrent));
        set(Xin.UI.H.hTrl_StimNumCurrent_Edit,  'String',	num2str(Xin.D.Trl.StimNumCurrent));
        set(Xin.UI.H.hTrl_StimNumNext_Edit,     'String',	num2str(Xin.D.Trl.StimNumNext));
        set(Xin.UI.H.hTrl_SoundNumCurrent_Edit,	'String',	num2str(Xin.D.Trl.SoundNumCurrent));
        set(Xin.UI.H.hTrl_SoundNameCurrent_Edit,'String',	num2str(Xin.D.Trl.SoundNameCurrent));
        set(Xin.UI.H.hTrl_AttDesignCurrent_Edit,'String',	sprintf('%5.1f (dB)',Xin.D.Trl.AttDesginCurrent));
        set(Xin.UI.H.hTrl_AttAddCurrent_Edit,	'String',	sprintf('%5.1f (dB)',Xin.D.Trl.AttAddCurrent));
        set(Xin.UI.H.hTrl_AttCurrent_Edit,      'String',	sprintf('%5.1f (dB)',Xin.D.Trl.AttCurrent));
        msg =   [datestr(now, 'yy/mm/dd HH:MM:SS.FFF') '\tupdatePower\tTrial # is ' num2str(t) '\r\n'];
        updateMsg(Xin.D.Exp.hLog, msg);
    end

end
