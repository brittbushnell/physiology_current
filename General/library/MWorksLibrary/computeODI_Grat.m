function [ODI] = computeODI_Grat(LEdata,REdata)
% COMPUTEODI [ODI] = computeODI(data1,data2)
% computes the ocular dominance index for all channels
% in an array
%
% INPUT:
%   Full data structures for each eye
%
% OUTPUT:
%  98 element matrix with ODI and MI (rows 1 and 2 respectively) for each 
%  channel, and the last two elements are the mean ODI/MI for the array 
%  and p-value that declares if the mean is significantly different from 
%  0 based on a ttest.
%
%   ODI = (LE-RE) / (LE+RE) using each eye's maximum response.
%     1: only responds to the LE
%    -1: only responds to the RE
%
%  MI = monocular index
%    calculated by taking the median of the absolute value of the ODIs.
%    
%

ODI = nan(2,98);

for ch = 1:size(LEdata.bins,3)    
    if ~isempty(intersect(REdata.goodChannels,ch))   % limit ODI computations to visually responsive channels.  
        REmax = REdata.maxSfOr(3,ch);
    else
        REmax = 0;
    end
    
    if ~isempty(intersect(LEdata.goodChannels,ch))
        LEmax = LEdata.maxSfOr(3,ch);
    else
        LEmax = 0;
    end

   ODI(1,ch) = (LEmax-REmax)/(LEmax+REmax);
   ODI(2,ch) = abs(ODI(1,ch));
   if ODI(2,ch) > 1
       disp(sprintf('MI of channel %d is %.2f',ch,ODI(2,ch)));
   end
end

foo = median(ODI(1,1:96),'omitnan');
[~,p] = ttest2(ODI(1,1:96),0);
ODI(1,97) = foo;
ODI(1,98) = p;

clear foo;
clear p;

foo = median(ODI(2,1:96),'omitnan'); 
[~,p] = ttest2(ODI(2,1:end-1),0);
ODI(2,97) = foo;
ODI(2,98) = p;