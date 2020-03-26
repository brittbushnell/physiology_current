function subcircplot(TotalNumberOfOrientations,CurrentOrientationPosition)
% function subcircplot(TotalNumberOfOrientations,CurrentOrientationPosition)
%

if (TotalNumberOfOrientations > 17)
    disp('This type of plot is not recommended.');
    return;
end

if ~exist('radius','var')
    if (round(TotalNumberOfOrientations/2)*2 <= 12)
        radius=-((round(TotalNumberOfOrientations/2)*2)-4)*0.01+0.14;
    else
        radius=-((round(TotalNumberOfOrientations/2)*2)-14)*0.0025 + 0.055;
    end
end


switch CurrentOrientationPosition
    case -2        
        radius2=0.85*(0.45-radius*sqrt(2))/(sqrt(2));
        subplot('position',[0.51-radius2,0.5-radius2,radius2*2,radius2*2]);
    case -1
        subplot('position',[0.51-radius,0.5-radius,radius*2,radius*2]);
    otherwise
        lrad = 0.45-radius;
        orirad = (360/TotalNumberOfOrientations)*(CurrentOrientationPosition-1)*(pi/180);
        [x,y] = pol2cart(orirad,lrad);
        subplot('position',[0.51+x-radius,0.5+y-radius,radius*2,radius*2]);


end
axis square;
