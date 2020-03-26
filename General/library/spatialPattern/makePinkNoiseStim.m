% function [image] = makePinkNoiseStim(n

clear all
close all
clc
%%

numStim = 5; % number of stimuli to make
numPix = 256;

figure
for i = 1:numStim
    %     x = spatialPattern([numPix, numPix], -1); %-1 is pink noise
    %     clf
    %     imagesc(x)
    %     colormap(gray(512))
        set(gca,'Position',[0 0 1 1])
    %     axis image off
    %     box off
    imagesc(generatepinknoise(numPix));
    colormap gray;
    axis square;
    axis image off
    axis off;
    box off
    iptsetpref('ImshowBorder','tight');
    
    
    fig = gcf;
    %fig.PaperUnits = 'centimeters';
    %fig.PaperPosition = [0 0 numPix numPix];
    print((sprintf('~/Dropbox/Stimuli/pinkNoise/pinkNoise_s%d.png',i)),'-dpng') %162.5 is dpi
    
end