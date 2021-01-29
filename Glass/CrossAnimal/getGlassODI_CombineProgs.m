function [data] = getGlassODI_CombineProgs(data)
%%
REtr = data.trRE;
REcr = data.conRadRE;

LEtr = data.trLE;
LEcr = data.conRadLE;

REzScores = abs(horzcat(REtr.allStimZscore,REcr.allStimZscore));
LEzScores = abs(horzcat(LEtr.allStimZscore,LEcr.allStimZscore));
%%
ODI = zeros(1,96);
RE = zeros(1,96);
LE = zeros(1,96);

for ch = 1:96
    if REtr.goodCh(ch) == 0 && REtr.inStim(ch) == 1
        RE(ch) = 0;
    else
        RE(ch) = REzScores(ch);
    end
    
    if LEtr.goodCh(ch) == 0 && LEtr.inStim(ch) == 1
        LE(ch) = 0;
    else
        LE(ch) = LEzScores(ch);
    end
    
    ODI(ch) = (LE(ch) - RE(ch)) / (LE(ch) + RE(ch));
end
data.ODIcombo = ODI;
data.ODIcombo = ODI;