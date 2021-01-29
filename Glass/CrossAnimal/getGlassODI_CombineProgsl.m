function [data] = getGlassODI_CombineProgs(data)
%%
REtr = data.trRE;
REcr = data.conRadRE;

LEtr = data.trLE;
LEcr = data.conRadLE;

REzScores = horzcat(REtr.allStimZscore,REcr.allStimZscore);
LEzScores = horzcat(LEtr.allStimZscore,LEcr.allStimZscore);
%%
ODI = zeros(1,96);

REDprime = zeros(1,96);
LEDprime = zeros(1,96);

for ch = 1:96
    if REdata.goodCh(1,ch) == 0
        REDprime(1,ch) = 0;
    else
        REDprime(1,ch) = abs(REdata.allStimZscore(1,ch));
    end
    
    if LEdata.goodCh(1,ch) == 0
        LEDprime(1,ch) = 0;
    else
        LEDprime(1,ch) = abs(LEdata.allStimZscore(1,ch));
    end
    
    ODI(1,ch) = (LEDprime(1,ch) - REDprime(1,ch)) / (LEDprime(1,ch) + REDprime(1,ch));
end
data.RE.ODI = ODI;
data.LE.ODI = ODI;