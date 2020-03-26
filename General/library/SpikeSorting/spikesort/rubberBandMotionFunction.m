function rubberBandMotionFunction %window motion callback function
utemp=get(gcf,'UserData');
try %Adding try/catch to improve error handling -02Apr2013 Adam C. Snyder
    ptemp=get(utemp.h,'CurrentPoint');
    ptemp=ptemp(1,1:2);
    % Use 5 point to draw a rectangular rubberband box
    set(utemp.lh,'XData',[ptemp(1),ptemp(1),utemp.p1(1),utemp.p1(1),ptemp(1)],'YData',[ptemp(2),utemp.p1(2),utemp.p1(2),ptemp(2),ptemp(2)]);
catch ME
    switch ME.identifier
        case 'MATLAB:class:InvalidHandle'
            %ignore this error for now
        case 'MATLAB:nonStrucReference'
            %ignore this error for now
        otherwise
            display(ME); %rethrow all other errors
    end;
end;
