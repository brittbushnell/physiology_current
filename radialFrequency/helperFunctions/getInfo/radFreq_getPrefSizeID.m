function [REdata, LEdata] = radFreq_getPrefSizeID(REdata,LEdata)

LEprefSize = nan(1,96);
REprefSize = nan(1,96);

LEsizeDiff = LEdata.sizeCorrDiff;
REsizeDiff = REdata.sizeCorrDiff;

for ch = 1:96
    if LEsizeDiff(ch) < 0 
        LEprefSize(ch) = 2;
    elseif LEsizeDiff(ch) > 0
        LEprefSize(ch) = 1;
    end
    
    if REsizeDiff(ch) < 0
        REprefSize(ch) = 2;
    elseif REsizeDiff(ch) > 0 
        REprefSize(ch) = 1;
    end
end

LEdata.prefSize = LEprefSize;
REdata.prefSize = REprefSize;