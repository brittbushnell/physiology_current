clear all
close all
clc
%% WU

%{'WU_LE_GlassTR_nsp1_20170822_002_thresh35.mat'} % leaving this file out because there's something really messed up with the V4 version.
 
files = {'WU_LE_GlassTR_nsp1_20170824_001_thresh35_info';
         'WU_LE_GlassTR_nsp1_20170825_002_thresh35_info'};
newName ='WU_LE_GlassTR_nsp1_Aug2017_all_thresh35_info';

% files = {'WU_LE_Glass_nsp1_20170817_001_thresh35_info';
%          'WU_LE_Glass_nsp1_20170821_002_thresh35_info';
%          'WU_LE_Glass_nsp1_20170822_001_thresh35_info'};
% newName ='WU_LE_Glass_nsp1_Aug2017_all_thresh35_info';

% files = {'WU_LE_Glass_nsp2_20170817_001_thresh35_info';
%          'WU_LE_Glass_nsp2_20170821_002_thresh35_info';
%          'WU_LE_Glass_nsp2_20170822_001_thresh35_info'};
% newName ='WU_LE_Glass_nsp2_Aug2017_all_thresh35_info';
 
% files = {'WU_LE_GlassTR_nsp2_20170824_001_thresh35_info';
%          'WU_LE_GlassTR_nsp2_20170825_002_thresh35_info'};
% newName ='WU_LE_GlassTR_nsp2_Aug2017_all_thresh35_info';

% files = {'WU_RE_GlassTR_nsp1_20170825_001_thresh35_info';
%          'WU_RE_GlassTR_nsp1_20170828_002_thresh35_info';
%          'WU_RE_GlassTR_nsp1_20170828_003_thresh35_info';
%          'WU_RE_GlassTR_nsp1_20170829_001_thresh35_info'};
% newName ='WU_RE_GlassTR_nsp1_Aug2017_all_thresh35_info';
    
% files = {'WU_RE_Glass_nsp1_20170817_002_thresh35_info';
%          'WU_RE_Glass_nsp1_20170818_001_thresh35_info';
%          'WU_RE_Glass_nsp1_20170821_001_thresh35_info'};
% newName ='WU_RE_Glass_nsp1_Aug2017_all_thresh35_info';
% 
% files = {'WU_RE_GlassTR_nsp2_20170825_001_thresh35_info';
%          'WU_RE_GlassTR_nsp2_20170828_002_thresh35_info';
%          'WU_RE_GlassTR_nsp2_20170828_003_thresh35_info';
%          'WU_RE_GlassTR_nsp2_20170829_001_thresh35_info'};
% newName ='WU_RE_GlassTR_nsp2_Aug2017_all_thresh35_info';
    
% files = {'WU_RE_Glass_nsp2_20170817_002_thresh35_info';
%          'WU_RE_Glass_nsp2_20170818_001_thresh35_info';
%          'WU_RE_Glass_nsp2_20170821_001_thresh35_info'};
% newName ='WU_RE_Glass_nsp2_Aug2017_all_thresh35_info';
%%
location = determineComputer;
for fi = 1:length(files)
    filename = files{fi,:};
    load(filename);
    if contains(filename,'RE')
        dataT = data.RE;
    else
        dataT = data.LE;
    end
    
    %     if contains(filename,'XX')
    %         dataT.fix_x = -1;
    %         dataT.fix_y = 2;
    %         if contains(filename,'nsp2')
    %             dataT.bins = dataT.binsV4;
    %         else
    %             dataT.bins = dataT.binsV1;
    %         end
    %     end
    
    dataTComp{fi} = dataT;
end
%% Concatenate sections
action = [];
bins   = [];
filename = [];
fix_x = [];
fix_y = [];
pos_x = [];
pos_y = [];
rotation = [];
% size_x  = [];
stimOn  = [];
stimOff = [];

type = [];
numDots = [];
dx = [];
coh = [];
sample = [];
dxDeg = [];
chReceptiveFieldParams = [];
arrayReceptiveFieldParams = [];
rfQuadrant  = [];
inStim = [];

GlassTRSpikeCount = [];
GlassTRZscore = [];

GlassSpikeCount = [];
noiseSpikeCount = [];
conSpikeCount = [];
radSpikeCount = [];
blankSpikeCount = [];
allStimSpikeCount = [];
allStimZscore = [];
conZscore = [];
radZscore = [];
noiseZscore = [];
blankZscore = [];
%%
for i = 1:length(dataTComp)
    bT     = dataTComp{i}.bins;
    fnm    = dataTComp{i}.filename;
    fx     = dataTComp{i}.fix_x;
    fy     = dataTComp{i}.fix_y;
    stmOn  = dataTComp{i}.stimOn;
    stmOff = dataTComp{i}.stimOff;
    xPos = dataTComp{i}.pos_x;
    yPos = dataTComp{i}.pos_y;
    
    if contains(dataTComp{1}.programID,'TR')
        rot    = dataTComp{i}.rotation;
        gSC = dataTComp{i}.GlassTRSpikeCount;
        nSC = dataTComp{i}.noiseSpikeCount;
        bSC = dataTComp{i}.blankSpikeCount;
        aSC = dataTComp{i}.allStimSpikeCount;
        gZ  = dataTComp{i}.GlassTRZscore;
        nZ  = dataTComp{i}.noiseZscore;
        aZ  = dataTComp{i}.allStimZscore;
        bz  = dataTComp{i}.blankZscore;
        
        rotation = [rotation,rot];
        GlassTRSpikeCount = cat(6,GlassTRSpikeCount,gSC);
        noiseSpikeCount = cat(6,noiseSpikeCount,nSC);
        blankSpikeCount = cat(2,blankSpikeCount,bSC);
        allStimSpikeCount = cat(2,allStimSpikeCount,aSC);
        GlassTRZscore = cat(6,GlassTRZscore,gZ);
        noiseZscore = cat(6,noiseZscore,nZ);
        blankZscore = cat(2, blankZscore,bz);
        allStimZscore = cat(2,allStimZscore,aZ);
        
    else
       % gSC = dataTComp{i}.GlassSpikeCount;
        cSC = dataTComp{i}.conSpikeCount;
        rSC = dataTComp{i}.radSpikeCount;
        nSC = dataTComp{i}.noiseSpikeCount;
        bSC = dataTComp{i}.blankSpikeCount;
        aSC = dataTComp{i}.allStimSpikeCount;
        gZ  = dataTComp{i}.allStimZscore;
        cZ  = dataTComp{i}.conZscore;
        rZ  = dataTComp{i}.radZscore;
        nZ  = dataTComp{i}.noiseZscore;
        bZ  = dataTComp{i}.blankZscore;
        
        %GlassSpikeCount = cat(5,GlassSpikeCount,gSC);
        noiseSpikeCount = cat(5,noiseSpikeCount,nSC);
        blankSpikeCount = cat(2,blankSpikeCount,bSC);
        allStimSpikeCount = cat(2,allStimSpikeCount,aSC);
        conSpikeCount = cat(5,conSpikeCount,cSC);
        radSpikeCount = cat(5,radSpikeCount,rSC);
        allStimZscore = cat(2,allStimZscore,gZ);
        conZscore   = cat(5,conZscore,cZ);
        radZscore   = cat(5,radZscore,rZ);
        noiseZscore = cat(5,noiseZscore,nZ);
        blankZscore = cat(2,blankZscore,bZ);
    end
    
    tps  = dataTComp{i}.type;
    ndt  = dataTComp{i}.numDots;
    nx   = dataTComp{i}.dx;
    ch   = dataTComp{i}.coh;
    smp  = dataTComp{i}.sample;
    ddeg = dataTComp{i}.dxDeg;
    chRF = dataTComp{i}.chReceptiveFieldParams;
    arRF = dataTComp{i}.arrayReceptiveFieldParams;
    rfQ  = dataTComp{i}.rfQuadrant;
    inRF = dataTComp{i}.inStim;
    
    bins = cat(1, bins, bT);
    filename = cat(1, filename, fnm);
    
    fix_x = [fix_x, fx];
    fix_y = [fix_y, fy];
    stimOn = [stimOn, stmOn];
    stimOff = [stimOff, stmOff];
    pos_x = [pos_x, xPos];
    pos_y = [pos_y, yPos];
    
    type = [type, tps];
    numDots = [numDots, ndt];
    dx = [dx, nx];
    coh = [coh, ch];
    sample = [sample, smp];
    dxDeg = [dxDeg, ddeg];
    chReceptiveFieldParams = [chReceptiveFieldParams, chRF];
    arrayReceptiveFieldParams = [arrayReceptiveFieldParams, arRF];
    rfQuadrant  = [rfQuadrant, rfQ];
    inStim = [inStim, inRF];
end

animal = dataTComp{1}.animal;
eye = dataTComp{1}.eye;
programID = dataTComp{1}.programID;
array = dataTComp{1}.array;
amap = dataTComp{1}.amap;
%% sanity check figure
% if contains(newName,'TR')
%     for ses = 1:length(dataTComp)
%         spikeStim{ses} = reshape(dataTComp{ses}.allStimTRSpikeCount,1,numel(dataTComp{ses}.allStimTRSpikeCount));
%         zStim{ses} = reshape(dataTComp{ses}.allStimZscore,1,numel(dataTComp{ses}.allStimTRZscore));
%         
%         spikeBlank{ses} = reshape(dataTComp{ses}.allStimTRSpikeCount,1,numel(dataTComp{ses}.allStimTRSpikeCount));
%         zBlank{ses} = reshape(dataTComp{ses}.blankTRzScore,1,numel(dataTComp{ses}.blankTRzScore));
%     end
%     clear ses;
% else
    for ses = 1:length(dataTComp)
        spikeStim{ses} = reshape(dataTComp{ses}.allStimSpikeCount,1,numel(dataTComp{ses}.allStimSpikeCount));
        zStim{ses} = reshape(dataTComp{ses}.allStimZscore,1,numel(dataTComp{ses}.allStimZscore));
        
        spikeBlank{ses} = reshape(dataTComp{ses}.allStimSpikeCount,1,numel(dataTComp{ses}.allStimSpikeCount));
        zBlank{ses} = reshape(dataTComp{ses}.blankZscore,1,numel(dataTComp{ses}.blankZscore));
    end
    clear ses;
% end
%%
figure(5)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 1000 700])
rows = length(dataTComp);

ndx = 1;
for n = 1:length(dataTComp)
   
    subplot(rows,4,ndx) % left column = stimulus spike counts 
    histogram(spikeStim{n},30,'Normalization','probability')
    set(gca,'box','off','tickdir','out')
    ylim([0 0.5])
    xlim([-2 100])
    ylabel({sprintf('%s %s',dataTComp{n}.date, dataTComp{n}.runNum);...
        'probability'})
     if n == 1
         title('stimulus spike counts')
     end
     if n == length(dataTComp)
         xlabel('spike count')
     end
    
    
    subplot(rows,4,ndx+1) % right column = stimulus z scores
    histogram(zStim{n},30,'Normalization','probability')
    set(gca,'box','off','tickdir','out')
    ylim([0 0.5])
    xlim([-5 20])
    if n == 1
         title('stimulus z scores')
     end
     if n == length(dataTComp)
         xlabel('z score')
     end
     
    subplot(rows,4,ndx+2) % left column = stimulus spike counts 
    histogram(spikeBlank{n},30,'Normalization','probability')
    set(gca,'box','off','tickdir','out')
    ylim([0 0.5])
    xlim([-2 100])
    
    if n == 1
         title('blank spike counts')
    end
    
      if n == length(dataTComp)
         xlabel('spike count')
     end
    subplot(rows,4,ndx+3) % right column = stimulus z scores
    histogram(zBlank{n},30,'Normalization','probability')
    set(gca,'box','off','tickdir','out')
    ylim([0 0.5])
    xlim([-5 20])
     if n == 1
         title('blank z scores')
     end    
    if n == length(dataTComp)
         xlabel('z score')
     end
        
    
    ndx = ndx+4;
end
suptitle(sprintf('%s %s %s %s zscores and spike counts', dataT.animal, dataT.eye, dataT.array, dataT.programID))

location = determineComputer;
if location == 0
    figDir =  sprintf( '/Users/brittany/Dropbox/Figures/%s/%s/%s/spikeZscoreDists/%s/%s/',dataT.animal, dataT.programID, dataT.array,dataT.eye,dataT.date2);
    if ~exist(figDir,'dir')
        mkdir(figDir)
    end
else
    figDir =  sprintf( '/Local/Users/bushnell/Dropbox/Figures/%s/%s/%s/spikeZscoreDists/%s/%s/',dataT.animal, dataT.programID, dataT.array,dataT.eye,dataT.date2);
    if ~exist(figDir,'dir')
        mkdir(figDir)
    end
end
cd(figDir)

figName = [dataT.animal,'_',dataT.eye,'_', dataT.array,'_',dataT.programID,'_',dataT.date2,'_spikeZscoreDist_allSessions','.pdf'];
print(gcf, figName,'-dpdf','-bestfit')
%% save new matrix
if contains(files(1,:),'V1') || contains(files(1,:),'nsp1')
    if location == 3
        saveDir = '/home/bushnell/matFiles/V1/';
    elseif location == 1
        saveDir = '~/bushnell-local/Dropbox/ArrayData/matFiles/V1/Glass/mergedMats/';
    elseif location  == 0
        saveDir = '~/Dropbox/ArrayData/matFiles/V1/Glass/mergedMats/';
    end
else
    if location == 3
        saveDir =  '/home/bushnell/matFiles/V4/';
    elseif location  == 1
        saveDir = '~/bushnell-local/Dropbox/ArrayData/matFiles/V4/Glass/mergedMats/';
    elseif location  == 0
        saveDir = '~/Dropbox/ArrayData/matFiles/V4/Glass/mergedMats/';
    end
end

if ~exist(saveDir,'dir')
    mkdir(saveDir)
end
cd(saveDir)
%%
if contains(programID,'TR')
    save(newName,'bins','fix_x','fix_y','rotation','stimOn','stimOff','filename',...
        'animal','eye','programID','array','amap',...
        'pos_x','pos_y','type','numDots','dx','coh','sample','dxDeg',...
        'chReceptiveFieldParams','arrayReceptiveFieldParams','rfQuadrant','inStim',...
        'GlassTRSpikeCount','noiseSpikeCount','blankSpikeCount','allStimSpikeCount',...
        'GlassTRZscore','blankZscore','noiseZscore','allStimZscore')
else
       save(newName,'bins','fix_x','fix_y','rotation','stimOn','stimOff','filename',...
        'animal','eye','programID','array','amap',...
        'pos_x','pos_y','type','numDots','dx','coh','sample','dxDeg',...
        'chReceptiveFieldParams','arrayReceptiveFieldParams','rfQuadrant','inStim',...
        'noiseSpikeCount','conSpikeCount','radSpikeCount','blankSpikeCount','allStimSpikeCount',...
        'conZscore','radZscore','noiseZscore','allStimZscore','blankZscore') 
end
fprintf('file %s done \n', newName)







