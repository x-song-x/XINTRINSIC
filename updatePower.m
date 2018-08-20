function updatePower(~,evnt)
global Xin

if  Xin.D.Ses.UpdateNumCurrentAI < Xin.D.Ses.UpdateNumTotal    
	%% Recording Duration Update  
    Xin.D.Ses.UpdateNumCurrentAI =	Xin.D.Ses.UpdateNumCurrentAI + 1; 
    %% Read Data & Power Calculation
        rstart =    (Xin.D.Ses.UpdateNumCurrentAI-1)*    Xin.D.Vol.UpdFrameNum+1;
        rstop =     (Xin.D.Ses.UpdateNumCurrentAI)*      Xin.D.Vol.UpdFrameNum;
        Xin.D.Vol.UpdPowerRaw =     evnt.data;
        Xin.D.Vol.UpdPowerAligned = reshape(...
            Xin.D.Vol.UpdPowerRaw,...
            Xin.D.Vol.UpdPowerSampleNum/Xin.D.Vol.UpdFrameNum, ...
            Xin.D.Vol.UpdFrameNum);
        Xin.D.Ses.Save.SesPowerMeter(rstart:rstop,:) = ...
             Xin.D.Vol.UpdPowerAligned(1:Xin.D.Vol.FramePowerSampleNum,:)';
end
