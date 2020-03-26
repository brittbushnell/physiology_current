function [cleanResps] = removeRespOutliers(resps)
%{
   REMOVERESPOUTLIERS is a function that will go through the responses to
   each repitition of a given stimulus, and will remove any that have an
   abnormally high response rate, implying there were artifacts at the time
   of the stimulus presentation.

   Assumes input is a column vector.

Written July 9, 2018 Brittany Bushnell
 
%}

%%

outs = isoutlier(resps);

ndx = 1;
ndx2 = 1;
for do = 1:length(resps)
    if outs(do,1) == 0
        cleanResps(ndx,1) = resps(do,1);
        ndx = ndx+1;
    else
        outResps(ndx2,1) = resps(do,1);
        ndx2 = ndx2+1;
    end
end



out2 = isoutlier(cleanResps);

if sum(out2) > 0
    clear out2
    cleanResps = removeRespOutliers(cleanResps);
%     figure
%     histogram(cleanResps)
%     title('responses after further cleaning')
end


