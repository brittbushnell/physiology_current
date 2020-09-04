%{
README_parseRadFreqStimResp

parseRadFreqStimResp is a function that return an cell matrix of the
responses of each channel to each unique stimulus. This readme is long
overdue for this function since it's one that is particularly hairy to work
through. 

The code was written with the goal of making it so the code will work
regardless of how many locations or unique RFs are used. That way if we
either combine across days and different locations, or change the
parameters we use, this should still work. 

%%%%%% July 9, 2018 %%%%%%

Added in call to removeRespOutliers function, which will remove any
artifacts.


%%%%%% July 18, 2018 %%%%%%


%}