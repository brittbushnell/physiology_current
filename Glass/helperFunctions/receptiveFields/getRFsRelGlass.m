function [inStim] = getRFsRelGlass(dataT)
% This function is a vastly simplified version of the sprinkles plot
% version, and only returns a vector saying which channels have receptive
% field centers within the stimulus bounds.

%%
glassX = unique(dataT.pos_x);
glassY = unique(dataT.pos_y);

if contains(dataT.animal,'XT')
    rfParamsOrig = dataT.chReceptiveFieldParamsBE;
else
    rfParamsOrig = dataT.chReceptiveFieldParams;
end
%% for XT, move receptive field locations to be in same coordinate space as Glass fixation
if contains(dataT.animal,'XT')
    for ch = 1:96
        rfParamsRelGlassFix{ch}(1) = rfParamsOrig{ch}(1) + unique(dataT.fix_x);
        rfParamsRelGlassFix{ch}(2) = rfParamsOrig{ch}(2) + unique(dataT.fix_y);
    end
else
    for ch = 1:96
        rfParamsRelGlassFix{ch}(1) = rfParamsOrig{ch}(1);
        rfParamsRelGlassFix{ch}(2) = rfParamsOrig{ch}(2);
    end
end
%% center stimulus at (0,0)
% Need stimulus to be centered at origin to define the quadrants according
% to their signs

if glassX ~= 0
    for ch = 1:96
        rfParamsStim0{ch}(1) = rfParamsRelGlassFix{ch}(1) - unique(dataT.pos_x);
    end
    glassXstim0 = unique(dataT.pos_x) - unique(dataT.pos_x);
else
    for ch = 1:96
        rfParamsStim0{ch}(1) = rfParamsRelGlassFix{ch}(1);
    end
    glassXstim0 = unique(dataT.pos_x);
end

if glassY ~= 0
    for ch = 1:96
        rfParamsStim0{ch}(2) = rfParamsRelGlassFix{ch}(2) - unique(dataT.pos_y);
    end
    glassYstim0 = unique(dataT.pos_x) - unique(dataT.pos_x);
else
    for ch = 1:96
        rfParamsStim0{ch}(2) = rfParamsRelGlassFix{ch}(2);
    end
    glassYstim0 = unique(dataT.pos_x);
end
if glassXstim0 ~=0 && glassYstim0 ~= 0
    fprintf('stimulus did not move to (0,0) \n')
    keyboard
end

inStim = zeros(1,96);
%%
for ch = 1:96
    rfX = rfParamsStim0{ch}(1);
    rfY = rfParamsStim0{ch}(2);

    inStim(1,ch) = (((rfX-0).^2+(rfY-0).^2 <= 4^2));
end



