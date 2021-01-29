function [ODI] = getGlassODI_zScore(LEdata,REdata)
%%
REzScores = abs(REdata.allStimZscore);
LEzScores = abs(LEdata.allStimZscore);
%%
ODI = zeros(1,96);
RE  = zeros(1,96);
LE  = zeros(1,96);

for ch = 1:96
    if REdata.goodCh(ch) == 0 && REdata.inStim(ch) == 1
        RE(ch) = 0;
    else
        RE(ch) = REzScores(ch);
    end
    
    if LEdata.goodCh(ch) == 0 && LEdata.inStim(ch) == 1
        LE(ch) = 0;
    else
        LE(ch) = LEzScores(ch);
    end
    
    ODI(ch) = (LE(ch) - RE(ch)) / (LE(ch) + RE(ch));
end
