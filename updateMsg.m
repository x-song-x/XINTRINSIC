function updateMsg(hLogFile, msg)
global Xin TP

try
    fprintf(hLogFile, msg);
catch
    disp(msg);
end
