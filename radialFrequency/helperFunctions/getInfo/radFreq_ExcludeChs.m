function[badCh] = radFreq_ExcludeChs(dataT)
badCh = [];
if contains(dataT.animal,'WU')
    if contains(dataT.date2,'20170626') && contains(dataT.runNum,'002') && contains(dataT.array,'V4')
        badCh = [25 13 23 20 22 19 27 24 54 21 29 26 52 62 31 28 58 60 64 30];
    elseif contains(dataT.date2,'20170705') && contains(dataT.runNum,'002') && contains(dataT.array,'V4')
        badCh = [51 56 58 53 55 57 87 89 91];
    elseif contains(dataT.array,'V4') && contains(dataT.eye,'AE') && contains(dataT.programID,'1')
        badCh = [68 39 78 85 59 55 32 47 56 94];
    end
elseif contains(dataT.animal,'XT')
    if contains(dataT.array,'V1') && contains(dataT.programID,'high','IgnoreCase',true) && ~contains(dataT.programID,'V4','IgnoreCase',true) && contains(dataT.eye,'RE')
        badCh = [94 90 87 86 84 80 78 75 74 73 72 64 62 60 59 57 54 52 51 47 46 44 42 41 38 37 36 31 29 28 27 26 24 23 22 21 20 15 13];
        
    elseif contains(dataT.array,'V1') && contains(dataT.programID,'high','IgnoreCase',true) && contains(dataT.programID,'V4','IgnoreCase',true) && contains(dataT.eye,'RE')
        badCh = [81 65 67 69 71 79 83 2 66 76 78 1 33 35 3 34 49 86 85 4 34 49 85 7 5 42 88 17 9 6 8 11 52 12 23 96 14 16 20 10 18 22 28 95 80];
    end
end
%%