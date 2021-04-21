clear
close all
clc
tic
%%
monks = {
    'WU';
    };
ez = {
    'LE';
    };
brArray = {
    'V4';
    'V1';
    };
%%
nameEnd = 'DxComp';
numPerm = 2000;
numBoot = 200;
holdout = 0.9;

plotFlag = 0;
location = determineComputer;
failedFiles = {};
failNdx = 0;
%%
ndx = 1;
corNdx = 1;
filesT = {};
filesC = {};
for an = 1:length(monks)
    monk = monks{an};
    for ey = 1:length(ez)
        eye = ez{ey};
        for ar = 1:length(brArray)
            area = brArray{ar};
            %%
            if location == 0
                dataDir = sprintf('~/Dropbox/ArrayData/matFiles/reThreshold/png/%s/%s/Glass/%s/',monk,area,eye);
            else
                dataDir = sprintf('/Local/Users/bushnell/Dropbox/ArrayData/matFiles/reThreshold/png/%s/%s/Glass/%s/',monk,area,eye);
            end
            cd(dataDir);
            
            tmp = dir;
            %%
            for t = 1:size(tmp,1)
                if contains(tmp(t).name,'.mat')
                    if strcmp(tmp(t).name,'WU_LE_GlassTR_nsp2_20170822_002_thresh35.mat')
                    elseif contains(tmp(t).name,'_og')
                        % make a list of all of the files that have
                        % been realigned
                        filesC{corNdx,1} = tmp(t).name;
                        corNdx = corNdx+1;
                    else
                        % list of un-aligned files
                        filesT{ndx,1} = tmp(t).name;
                        ndx = ndx+1;
                    end
                end
            end
            
            for c = 1:length(filesC)
                shortName = strrep(filesC{c,1},'_ogcorrupt','');
                %remove from the list any _thresh35 files that were
                %later realigned.  No reason to run through everything
                %on all of them.
                filesT(strcmp(shortName,filesT)) = [];
            end
            
            if isempty(filesT)
                files1 = filesC;
            elseif isempty(filesC)
                files1 = filesT;
            else
                files1 = cat(1,filesC,filesT);
            end
        end
    end
end
%%
for i = 1:length(files1)
    if ~isempty(files1{i})
        files{ndx,1} = files1{i};
        ndx = ndx+1;
    end
end
%%
for fi = 1:length(files1)
    %% Get basic information about experiments
%     try
    filename = files1{fi};
    if contains(filename,'TR')
        dataT = load(filename);
        fprintf('\nFile %s\n',filename)
        aMap = getBlackrockArrayMap(filename);
        
        tmp = strsplit(filename,'_');
        dataT.animal = tmp{1};  dataT.eye = tmp{2}; dataT.programID = tmp{3}; array = tmp{4};
        dataT.date2 = tmp{5}; dataT.runNum = tmp{6}; dataT.date = convertDate(dataT.date2); %dataT.reThreshold = tmp{7};
        
        if strcmp(array, 'nsp1')
            dataT.array = 'V1';
        elseif strcmp(array, 'nsp2')
            dataT.array = 'V4';
        end
        
        if contains(dataT.animal,'XX')
            dataT.filename = reshape(dataT.filename,[numel(dataT.filename),1]);
            dataT.filename = char(dataT.filename);
        end
        
        ndx = 1;
        for i = 1:size(dataT.filename,1)
            [type, numDots, dx, coh, sample] = parseGlassName(dataT.filename(i,:));
            
            %  type: numeric versions of the first letter of the pattern type
            %     0:  noise
            %     1: concentric
            %     2: radial
            %     3: translational
            %     100:blank
            dataT.type(1,ndx)    = type;
            dataT.numDots(1,ndx) = numDots;
            dataT.dx(1,ndx)      = dx;
            dataT.coh(1,ndx)     = coh;
            dataT.sample(1,ndx)  = sample;
            ndx = ndx+1;
        end
        
        %         if strcmp(array, 'nsp1')
        %             dataT.array = 'V1';
        %         elseif strcmp(array, 'nsp2')
        %             dataT.array = 'V4';
        %         end
        %
        %         if contains(dataT.animal,'WU')
        %             dataT.fix_x = 0;
        %             dataT.fix_y = 0;
        %         end
        %
                dataT.amap = aMap;
        %% convert dx to a meaningful measurement
        dataT.dxDeg = 8.*dataT.dx;
        %% get spike counts and Zscores
        [dataT.GlassTRSpikeCount,dataT.noiseSpikeCount,dataT.blankSpikeCount,dataT.allStimSpikeCount] = getGlassTRSpikeCounts(dataT);
        [dataT.GlassTRZscore,dataT.allStimZscore, dataT.blankZscore, dataT.noiseZscore] = getGlassTRStimZscore(dataT);
        
        fprintf(sprintf('spike counts done, zscores computed %d minutes \n', toc/60))
        %%
        if location == 1
            figDir =  sprintf('~/bushnell-local/Dropbox/Figures/%s/%s/%s/PSTH/singleSession/',dataT.animal,dataT.programID,dataT.array);
        elseif location == 0
            figDir =  sprintf('~/Dropbox/Figures/%s/%s/%s/PSTH/singleSession/',dataT.animal,dataT.programID,dataT.array);
        end
        
        if ~exist(figDir,'dir')
            mkdir(figDir)
        end
        cd(figDir)
        %% plot stim V blank PSTH
        figure(1);
        clf
        pos = get(gcf,'Position');
        set(gcf,'Position',[pos(1) pos(2) 1000 800])
        set(gcf,'PaperOrientation','Landscape');
        for ch = 1:96
            
            subplot(dataT.amap,10,10,ch)
            hold on;
            
            blankResp = nanmean(smoothdata(dataT.bins((dataT.numDots == 0), 1:35 ,ch),'gaussian',3))./0.01;
            stimResp = nanmean(smoothdata(dataT.bins((dataT.numDots > 0), 1:35 ,ch),'gaussian',3))./0.01;
            plot(1:35,blankResp,'Color',[0.2 0.2 0.2],'LineWidth',0.5);
            plot(1:35,stimResp,'-k','LineWidth',2);
            
            title(ch)
            
            set(gca,'Color','none','tickdir','out','XTickLabel',[],'FontAngle','italic');
            ylim([0 inf])
        end
        fname = strrep(filename,'_',' ');
        suptitle({sprintf('%s %s %s %s stim vs blank', dataT.animal, dataT.array, dataT.programID, dataT.eye);...
            sprintf(sprintf('%s',string(fname)))});
        
        figName = [filename,'_PSTHstimVBlank_realign2.pdf'];
%         print(gcf, figName,'-dpdf','-fillpage')
        %% plot con, rad, noise vs blank
        figure(2)
        clf
        pos = get(gcf,'Position');
        set(gcf,'Position',[pos(1) pos(2) 1000 1200])
        set(gcf,'PaperOrientation','Landscape');
        
        for ch = 1:96
            
            subplot(dataT.amap,10,10,ch)
            hold on;
            
            blankResp = nanmean(smoothdata(dataT.bins((dataT.numDots == 0), 1:35 ,ch),'gaussian',3))./0.01;
            conResp = nanmean(smoothdata(dataT.bins((dataT.type == 1), 1:35 ,ch),'gaussian',3))./0.01;
            radResp = nanmean(smoothdata(dataT.bins((dataT.type == 2), 1:35 ,ch),'gaussian',3))./0.01;
            nozResp = nanmean(smoothdata(dataT.bins((dataT.type == 0), 1:35 ,ch),'gaussian',3))./0.01;
            conNoz = conResp - nozResp;
            radNoz = radResp - nozResp;
            
            plot(1:35,conNoz,'-','color',[0.7 0 0.7],'LineWidth',0.75);
            plot(1:35,radNoz,'-','color',[0 0.6 0.2],'LineWidth',0.75);
            
            title(ch)
            
            set(gca,'Color','none','tickdir','out','XTickLabel',[],'FontAngle','italic');
            ylim([0 inf])
        end
        fname = strrep(filename,'_',' ');
        suptitle({sprintf('%s %s %s %s (pattern - noise) PSTH', dataT.animal, dataT.array, dataT.programID, dataT.eye);...
            sprintf(sprintf('%s',string(fname)))});
        
        figName = [filename,'_PSTH_stimSubNoise_realign2.pdf'];
%         print(gcf, figName,'-dpdf','-fillpage')
        %% save good data
        if location == 1
            outputDir =  sprintf('~/bushnell-local/Dropbox/ArrayData/matFiles/%s/Glass/info/',dataT.array);
        elseif location == 0
            outputDir =  sprintf('~/Dropbox/ArrayData/matFiles/%s/Glass/info/',dataT.array);
        end
        if ~exist(outputDir, 'dir')
            mkdir(outputDir)
        end
        if contains(filename,'LE')
            data.LE = dataT;
            data.RE = [];
        else
            data.RE = dataT;
            data.LE = [];
        end
        shortName = strrep(filename,'.mat','');
        saveName = [outputDir shortName '_' nameEnd '.mat'];
        save(saveName,'data');
        fprintf('%s saved\n  run time: %.2f minutes\n\n', saveName, toc/60)
    end
%     catch
%     end
    clear dataT
end