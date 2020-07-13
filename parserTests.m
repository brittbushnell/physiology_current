clear
close all
clc
tic
%%
p = 'WU_LE_GlassTR_nsp2_20170825_002_thresh35_pyParse_vers2';
m = 'WU_LE_GlassTR_nsp2_20170825_002_thresh35_matParsed_vers2';
r = 'WU_LE_GlassTR_nsp2_20170825_002_vers2';
%%
numPerm = 20;
numBoot = 20;
holdout = 0.9;
%%
pyParsed = load(p);
mParsed  = load(m);
ogParsed = load(r);
%%
pyParsed = pyParsed.data.LE;
mParsed  = mParsed.data.LE;
ogParsed = ogParsed.data.LE;
%%
location = determineComputer;
if location == 1
    outputDir =  sprintf('~/bushnell-local/Dropbox/ArrayData/matFiles/%s/Glass/Parsed/',pyParsed.array);
elseif location == 0
    outputDir =  sprintf('~/Dropbox/ArrayData/matFiles/%s/Glass/Parsed/',pyParsed.array);
elseif location == 3
    outputDir = sprintf('~/matFiles/%s/Parsed/',pyParsed.array);
end
%% do all vs blank permutation test
pyParsed = GlassStimVsBlankPermutations_allStim(pyParsed,numPerm,holdout);
mParsed = GlassStimVsBlankPermutations_allStim(mParsed,numPerm,holdout);
ogParsed = GlassStimVsBlankPermutations_allStim(ogParsed,numPerm,holdout);

fprintf('good channel permutaitons done in %.2f hours \n',toc/3600)
%% decide good channels
[pyParsed.stimBlankChPvals,pyParsed.goodCh] = glassGetPermutationStatsAndGoodCh(pyParsed.allStimBlankDprime,pyParsed.allStimBlankDprimeBootPerm);
[mParsed.stimBlankChPvals, mParsed.goodCh]  = glassGetPermutationStatsAndGoodCh(mParsed.allStimBlankDprime,mParsed.allStimBlankDprimeBootPerm);
[ogParsed.stimBlankChPvals,ogParsed.goodCh] = glassGetPermutationStatsAndGoodCh(ogParsed.allStimBlankDprime,ogParsed.allStimBlankDprimeBootPerm);

fprintf('good channel permutaiton test done in %.2f hours \n',toc/3600)
%% get stimulus responses
pyParsed = getStimResps_GlassTR(pyParsed, numBoot);
mParsed  = getStimResps_GlassTR(mParsed, numBoot);
ogParsed = getStimResps_GlassTR(ogParsed, numBoot);
%% get real dPrimes for stimulus vs blank and orientations vs noise
pyParsed = getStimVsBlankDPrimes_GlassTR_coh(pyParsed,numPerm);
pyParsed = getStimVsNoiseDPrimes_GlassTR_coh(pyParsed);

mParsed = getStimVsBlankDPrimes_GlassTR_coh(mParsed,numPerm);
mParsed = getStimVsNoiseDPrimes_GlassTR_coh(mParsed);

ogParsed = getStimVsBlankDPrimes_GlassTR_coh(ogParsed,numPerm);
ogParsed = getStimVsNoiseDPrimes_GlassTR_coh(ogParsed);

fprintf('real dPrimes computed in %.2f hours \n',toc/3600)
%% get stim vs blank permutations
pyParsed = GlassTR_StimVsBlankPermutations_coh(pyParsed, numPerm, holdout);
mParsed  = GlassTR_StimVsBlankPermutations_coh(mParsed, numPerm, holdout);
ogParsed = GlassTR_StimVsBlankPermutations_coh(ogParsed, numPerm, holdout);

fprintf('stim vs blank permutations done in %.2f hours \n',toc/3600)
%% get stim vs noise permutations
pyParsed = GlassTR_StimVsNoisePermutations_coh(pyParsed, numPerm,holdout);
mParsed = GlassTR_StimVsNoisePermutations_coh(mParsed, numPerm,holdout);
ogParsed = GlassTR_StimVsNoisePermutations_coh(ogParsed, numPerm,holdout);

fprintf('stim vs noise permutations done in %.2f hours \n',toc/3600)
%%
figure%(1)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 1000 800])
set(gcf,'PaperOrientation','Landscape');

for ch = 1:96
    
    subplot(pyParsed.amap,10,10,ch)
    hold on;
    
    pyParsed.goodCh(ch);
    mParsed.goodCh(ch);
    tmp(1,ch) = (pyParsed.goodCh(ch)+ mParsed.goodCh(ch));
    
    pycoh = (pyParsed.coh == 1);
    pynoiseCoh = (pyParsed.coh == 0);
    pycohNdx = logical(pycoh + pynoiseCoh);
    
    mcoh = (mParsed.coh == 1);
    mnoiseCoh = (mParsed.coh == 0);
    mcohNdx = logical(mcoh + mnoiseCoh);
    
    if contains(pyParsed.animal,'XT')
        blankResp = nanmean(smoothdata(pyParsed.bins((pyParsed.numDots == 0), 1:35 ,ch),'gaussian',3))./0.01;
        stimResp = nanmean(smoothdata(pyParsed.bins((pycohNdx), 1:35 ,ch),'gaussian',3))./0.01;
        plot(1:35,blankResp,'color',[0.14 0.63 0.42 0.7],'LineWidth',0.5);
        plot(1:35,stimResp,'color',[0.14 0.63 0.42 0.8],'LineWidth',2);
    else
        blankResp = nanmean(smoothdata(pyParsed.bins((pyParsed.numDots == 0), 1:35 ,ch),'gaussian',3))./0.01;
        stimResp = nanmean(smoothdata(pyParsed.bins((pycohNdx), 1:35 ,ch),'gaussian',3))./0.01;
        plot(1:35,blankResp,'color',[1 0 0 0.7],'LineWidth',0.5);
        plot(1:35,stimResp,'color',[1 0 0 0.8],'LineWidth',2);
    end
    title(ch)
    set(gca,'Color','none','tickdir','out','XTickLabel',[],'FontAngle','italic');%,'FontSize',12);
    %ylim([0 yMax])
    ylim([0 inf])
    
end

suptitle((sprintf('%s %s %s stim vs blank python parsed', pyParsed.animal,pyParsed.eye, pyParsed.array)))
%%

figure%(1)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 1000 800])
set(gcf,'PaperOrientation','Landscape');

for ch = 1:96
    
    subplot(pyParsed.amap,10,10,ch)
    hold on;
    
    pyParsed.goodCh(ch);
    mParsed.goodCh(ch);
    %tmp(1,ch) = (pyParsed.goodCh(ch)+ mParsed.goodCh(ch));
    
    pycoh = (pyParsed.coh == 1);
    pynoiseCoh = (pyParsed.coh == 0);
    pycohNdx = logical(pycoh + pynoiseCoh);
    
    mcoh = (mParsed.coh == 1);
    mnoiseCoh = (mParsed.coh == 0);
    mcohNdx = logical(mcoh + mnoiseCoh);
    
    if contains(pyParsed.animal,'XT')
        blankResp = nanmean(smoothdata(mParsed.bins((mParsed.numDots == 0), 1:35 ,ch),'gaussian',3))%./0.01;
        stimResp = nanmean(smoothdata(mParsed.bins((mcohNdx), 1:35 ,ch),'gaussian',3))%./0.01;
        plot(1:35,blankResp,'color',[0.3 0.3 0.3 0.9],'LineWidth',0.5);
        plot(1:35,stimResp,'color',[0.3 0.3 0.3 0.9],'LineWidth',2.5);
    else
        blankResp = nanmean(smoothdata(mParsed.bins((mParsed.numDots == 0), 1:35 ,ch),'gaussian',3))%./0.01;
        stimResp = nanmean(smoothdata(mParsed.bins((mcohNdx), 1:35 ,ch),'gaussian',3))%./0.01;
        plot(1:35,blankResp,'color',[0 0 1 0.7],'LineWidth',0.5);
        plot(1:35,stimResp,'color',[0 0 1 0.8],'LineWidth',2);
    end
    
    title(ch)
    set(gca,'Color','none','tickdir','out','XTickLabel',[],'FontAngle','italic');%,'FontSize',12);
    %ylim([0 yMax])
    ylim([0 inf])
end

suptitle((sprintf('%s %s %s stim vs blank matlab parsed', pyParsed.animal,pyParsed.eye, pyParsed.array)))
%%
figure%(1)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 1000 800])
set(gcf,'PaperOrientation','Landscape');

for ch = 1:96
    
    subplot(pyParsed.amap,10,10,ch)
    hold on;
    
    pyParsed.goodCh(ch);
    mParsed.goodCh(ch);
    %tmp(1,ch) = (pyParsed.goodCh(ch)+ mParsed.goodCh(ch));
    
    pycoh = (pyParsed.coh == 1);
    pynoiseCoh = (pyParsed.coh == 0);
    pycohNdx = logical(pycoh + pynoiseCoh);
    
    mcoh = (mParsed.coh == 1);
    mnoiseCoh = (mParsed.coh == 0);
    mcohNdx = logical(mcoh + mnoiseCoh);
    
    if contains(pyParsed.animal,'XT')
        blankResp = nanmean(smoothdata(mParsed.bins((mParsed.numDots == 0), 1:35 ,ch),'gaussian',3))./0.01;
        stimResp = nanmean(smoothdata(mParsed.bins((mcohNdx), 1:35 ,ch),'gaussian',3))./0.01;
        plot(1:35,blankResp,'color',[0.3 0.3 0.3 0.9],'LineWidth',0.5);
        plot(1:35,stimResp,'color',[0.3 0.3 0.3 0.9],'LineWidth',2.5);
    else
        blankResp = nanmean(smoothdata(mParsed.bins((mParsed.numDots == 0), 1:35 ,ch),'gaussian',3))./0.01;
        stimResp = nanmean(smoothdata(mParsed.bins((mcohNdx), 1:35 ,ch),'gaussian',3))./0.01;
        plot(1:35,blankResp,'color',[0 0 1 0.7],'LineWidth',0.5);
        plot(1:35,stimResp,'color',[0 0 1 0.8],'LineWidth',2);
    end
    
    if contains(pyParsed.animal,'XT')
        blankResp = nanmean(smoothdata(pyParsed.bins((pyParsed.numDots == 0), 1:35 ,ch),'gaussian',3))./0.01;
        stimResp = nanmean(smoothdata(pyParsed.bins((pycohNdx), 1:35 ,ch),'gaussian',3))./0.01;
        plot(1:35,blankResp,'color',[0.14 0.63 0.42 0.7],'LineWidth',0.5);
        plot(1:35,stimResp,'color',[0.14 0.63 0.42 0.8],'LineWidth',2);
    else
        blankResp = nanmean(smoothdata(pyParsed.bins((pyParsed.numDots == 0), 1:35 ,ch),'gaussian',3))./0.01;
        stimResp = nanmean(smoothdata(pyParsed.bins((pycohNdx), 1:35 ,ch),'gaussian',3))./0.01;
        plot(1:35,blankResp,'color',[1 0 0 0.7],'LineWidth',0.5);
        plot(1:35,stimResp,'color',[1 0 0 0.8],'LineWidth',2);
    end
    
    title(ch)
    set(gca,'Color','none','tickdir','out','XTickLabel',[],'FontAngle','italic');%,'FontSize',12);
    %ylim([0 yMax])
    ylim([0 inf])
end

suptitle((sprintf('%s %s %s stim vs blank both parsers', pyParsed.animal,pyParsed.eye, pyParsed.array)))
%%
pF = pyParsed.filename;
for f = 1:length(pF)
    tmp = strsplit(pF(f,:),'/');
    shortP(f,:) = tmp(end);
end
%%

randTrials = randi(length(pyParsed.numDots),[1,100]);
figure(4)
clf
hold on

plot(1:100,pyParsed.numDots(randTrials),'*b')
plot(1:100,mParsed.numDots(randTrials),'or')
xlabel('matlab parsed')
ylabel('python parsed')