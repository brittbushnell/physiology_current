% This is just to be used for debugging and fucking around with things.
% Creating a saved script for it after losing info due to crashes.
%%
allXs = [REx,LEx];
[sortXs, xInd] = sort(allXs); % Indices > 5 are from LE
allYs = [REy,LEy];
[sortYs, yInd] = sort(allYs);
eyeXsort = eyeRef(xInd);
eyeYsort = eyeRef(yInd);
%%
BEmtx = nan(10,10,96,55); % setup empty matrix

for ch = 1:96
    ndx = 1;
    for y = 1:10
        for x = 1:10
            if eyeXsort(x) == 1 && eyeYsort(y) == 1
                BEmtx(y,x,ch,:) = REresps(yInd(y),xInd(x),ch,:);
                ndx = ndx+1;
            elseif eyeXsort(x) == 2 && eyeYsort(y) == 2
                fprintf('%d,%d\n',xInd(x),yInd(y))
                BEmtx(y,x,ch,:) = LErespSample(yInd(y)-5,xInd(x)-5,ch,:);
                ndx = ndx+1;
            end
        end        
    end
end