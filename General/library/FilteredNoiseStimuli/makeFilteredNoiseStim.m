clear all 
close all
clc
%%
%%% -- General Params -- %%%
ppd = 64; % pixels per degree
imN = 64; % size in pixels
sizeDeg = imN/ppd; % size in degrees
nSamp = 3; % samples per filter
saveDir = '/Local/Users/bushnell/Dropbox/MWorks/FilteredNoise/';
fileExt = '.png';

noiseStd = 1/6;

%%% -- SF Filter Params -- %%%
nSf = 4; % number of sf
sfMin = 0.5; % lowest sf
octBw = 1; % sf bandwidth (octaves)
bwOrd = 8; % order of Butterworth filter
sfC = sfMin.*2.^(0:nSf-1); % center SF
sfL = sfC.*2^(-octBw/2); % low cutoff SF
sfH = sfC.*2^(octBw/2); % high cutoff SF

%%% -- ORI Filter Params -- %%%
nOri = 4; % number of orientations
oriC = (0:nOri-1)*(pi/nOri); % center orientations (radians)
oriPow = 6; % power of raised cosine filter

%%% -- TF Filter Params -- %%%
tN = 1; % tN=1 for static frame
fps = 1;
tfH = nan;
tfL = nan;
bwOrdT = nan;

%%% -- Envelope (raised cosine) -- %%%
envIDOD = sizeDeg*[0.9 1]; % inner and outer diameter of envelope (degrees)
env = MakeCosineMask(imN,ppd,envIDOD); % create envelope

%%% -- Generate Stimuli -- %%%
for iS = 1:nSf
    for iO = 1:nOri
        [~,~,D{iS,iO}] = MakeBwRcBwFilteredStim(ppd,fps,imN,tN,...
            sfH(iS),sfL(iS),bwOrd,tfH,tfL,bwOrdT,oriC(iO),oriPow,1,env);
        Y = MakeBwRcBwFilteredStim(ppd,fps,imN,tN,...
            sfH(iS),sfL(iS),bwOrd,tfH,tfL,bwOrdT,oriC(iO),oriPow,nSamp,env);

%         if iO==1
%             figure
%             hist(Y(:),100);
%             title(prctile(Y(:),[5,95]))
%         end
        fileNameBase = ['s',num2str(iS),'o',num2str(iO)];
        for k = 1:nSamp
            y = Y(:,:,1,k);
            y = 2*noiseStd*y./std(y(:));
            fracClip(k,iS,iO) = (sum(y(:)<-1) + (sum(y(:)>1)))./imN^2;
            im = uint8(255*(0.5+0.5.*y));
            
            fileName = [fileNameBase,'_',num2str(k),fileExt];
            imwrite(im,[saveDir,'/',fileName])
        end
    end
end

%%% -- View filters -- %%%
figure
subplot(1,2,1)
for iS = 1:nSf
    semilogx(D{iS,1}.sf,D{iS,1}.sfFilt), hold on
    xlabel('SF (cpd)')
end
subplot(1,2,2)
for iO = 1:nOri
    plot(D{1,iO}.ori,D{1,iO}.oriFilt), hold on
    xlabel('ORI (radians)')
end