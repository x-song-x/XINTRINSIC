function msg = StopNIDAQ
% This function setup NI-DAQ cards wiring, and fundamental tasks
% Terminal Definition is in SetupD

%% import NI DAQmx class
import dabs.ni.daqmx.*

%% import handles and data
global Xin

%% Stop tasks
Xin.HW.NI.T.hTask_CO_TrigStart.abort();
Xin.HW.NI.T.hTask_CO_TrigStart.delete();

Xin.HW.NI.T.hTask_CO_TrigFrame.abort();
Xin.HW.NI.T.hTask_CO_TrigFrame.delete();

Xin.HW.NI.T.hTask_AO_Xin.abort();
Xin.HW.NI.T.hTask_AO_Xin.delete();

Xin.HW.NI.T.hTask_AI_Xin.abort();
Xin.HW.NI.T.hTask_AI_Xin.delete();

%% LOG MSG
msg = [datestr(now, 'yy/mm/dd HH:MM:SS.FFF') '\tStopNIDAQ\tNI-DAQmx tasks terminated\r\n'];
updateMsg(Xin.D.Exp.hLog, msg);