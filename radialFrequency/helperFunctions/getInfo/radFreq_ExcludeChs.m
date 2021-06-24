% function[badCh] = radFreq_ExcludeChs(dataT)

if contains(dataT.animal,'WU')
    if contains(dataT.date2,'20170626') && contains(dataT.runNum,'002') && contains(dataT.array,'nsp2')
        badCh = [25 13 23 20 22 19 27 24 54 21 29 26 52 62 31 28 58 60 64 30];
    elseif contains(dataT.date2,'20170705') && contains(dataT.runNum,'002') && contains(dataT.array,'nsp2')
        badCh = [51 56 58 53 55 57 87 89 91];
    end
elseif contains(dataT.animal,'XT')
    if contains(dataT.array,'nsp1') && contains(dataT.programID,'high','IgnoreCase',true) && ~contains(dataT.programID,'V4','IgnoreCase',true)
        badCh = [];
        
    elseif contains(dataT.array,'nsp1') && contains(dataT.programID,'high','IgnoreCase',true) && contains(dataT.programID,'V4','IgnoreCase',true)
        badCh = [];
    end
end
%%