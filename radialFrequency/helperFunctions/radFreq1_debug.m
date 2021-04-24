tic
location = determineComputer;
%%
 failedFiles =  {%'WU_LE_RadFreqSparse_nsp2_20170607_002_thresh35.mat';           
                 %'WU_LE_RadFreqSparse_nsp2_20170609_002_thresh35.mat';           
                 'WU_LE_RadFreq_nsp2_20170215_005_thresh35.mat';                 
                 'WU_LE_RadFreq_nsp2_20170215_006_thresh35.mat';                 
                 'WU_LE_RadFreq_nsp2_20170215_007_thresh35.mat';                 
                 'WU_LE_RadFreq_nsp2_20170215_008_thresh35.mat';                 
                 'WU_LE_RadFreq_nsp2_20170217_004_thresh35.mat';                 
                 'WU_LE_RadFreq_nsp2_20170217_005_thresh35.mat';                 
%                  'WU_LE_RadFreqSparse_nsp1_20170522_002_thresh35.mat';           
%                  'WU_RE_RadFreqSparse_nsp2_20170607_004_thresh35.mat';           
%                  'WU_RE_RadFreqSparse_nsp2_20170607_005_thresh35.mat';           
                 'WU_RE_RadFreq_nsp2_20170215_009_thresh35.mat';                 
                 'WU_RE_RadFreq_nsp2_20170215_010_thresh35.mat';                 
                 'WU_RE_RadFreq_nsp2_20170215_011_thresh35.mat';                 
                 'WU_RE_RadFreq_nsp2_20170217_006_thresh35.mat';                 
                 'WU_RE_RadFreq_nsp2_20170217_007_thresh35.mat';                 
                 'WU_RE_RadFreq_nsp2_20170217_008_thresh35.mat';                 
%                  'WU_RE_RadFreqSparse_nsp1_20170522_004_thresh35.mat';                                                               
                 'XT_LE_RadFreqLowSFV4_nsp2_20190226_003_thresh35.mat';                                                              
                 'XT_RE_RadFreqLowSFV4_nsp2_20190228_002_thresh35.mat';                                                              
                 'XT_LE_RadFreqLowSFV4_nsp2_20190226_003_thresh35.mat';          
                 'XT_RE_RadFreqLowSFV4_nsp1_20190228_002_thresh35.mat';          
                 'XT_RE_RadFreqLowSFV4_nsp2_20190228_002_thresh35.mat'};          
%%
ndx = 1;
for fi = 1:length(failedFiles)
        %% get basic information about what was run overall, and for each trial.
        filename = failedFiles{fi};
        dataT = load(filename);
        
        tmp = strsplit(filename,'_');
        dataT.animal = tmp{1};  dataT.eye = tmp{2}; dataT.programID = tmp{3}; dataT.array = tmp{4}; dataT.date2 = tmp{5};
        dataT.runNum = tmp{6};  dataT.date = convertDate(dataT.date2); % dataT.reThreshold = tmp7;
        
        if strcmp(dataT.array, 'nsp1')
            dataT.array = 'V1';
        elseif strcmp(dataT.array, 'nsp2')
            dataT.array = 'V4';
        end
        
        % all of the other unique parameters are stored in the file name and need
        % to be parsed out.
        for i = 1:length(dataT.filename)
            [name, rf, rad, mod, ori, sf] = parseRFName(dataT.filename(i,:));
            
            dataT.rf(i,1)  = rf;
            dataT.amplitude(i,1) = mod;
            dataT.orientation(i,1) = ori;
            dataT.spatialFrequency(i,1) = sf;
            dataT.radius(i,1) = rad; %remember, size of RF stimuli is in mean radius
            name  = char(name);
            dataT.name{i,1} = name;
        end
        numCh = size(dataT.bins,3);
        
        % Make all of the vectors the same orientations
        dataT.pos_x = dataT.pos_x';
        dataT.pos_y = dataT.pos_y';
        dataT.size_x = dataT.size_x';
        
        dataT.amap = getBlackrockArrayMap(failedFiles(1,:));
        %
        %% Plot PSTH
        if location == 1
            figDir =  sprintf('~/bushnell-local/Dropbox/Figures/%s/%s/%s/PSTH/singleSession/',dataT.animal,dataT.programID,dataT.array);
        elseif location == 0
            figDir =  sprintf('~/Dropbox/Figures/%s/%s/%s/PSTH/singleSession/',dataT.animal,dataT.programID,dataT.array);
        end
        
        if ~exist(figDir,'dir')
            mkdir(figDir)
        end
        cd(figDir)
        %% plot LE
        figure(1);
        clf
        pos = get(gcf,'Position');
        set(gcf,'Position',[pos(1) pos(2) 1000 800])
        set(gcf,'PaperOrientation','Landscape');
        for ch = 1:96
            
            subplot(dataT.amap,10,10,ch)
            hold on;
            
            blankResp = nanmean(smoothdata(dataT.bins((dataT.rf == 10000), 1:35 ,ch),'gaussian',3))./0.01;
            stimResp = nanmean(smoothdata(dataT.bins((dataT.rf ~= 10000), 1:35 ,ch),'gaussian',3))./0.01;
            plot(1:35,blankResp,'Color',[0.2 0.2 0.2],'LineWidth',0.5);
            plot(1:35,stimResp,'-k','LineWidth',2);
            
            title(ch)
            
            set(gca,'Color','none','tickdir','out','XTickLabel',[],'FontAngle','italic');
            ylim([0 inf])
        end
        
        fname = strrep(filename,'_',' ');
        suptitle(sprintf('%s %s %s %s stim vs blank', dataT.animal, dataT.array, dataT.programID, dataT.eye));...
            sprintf(sprintf('%s',string(fname)));
        
        fname2 = strrep(filename,'.mat','');
        figName = [fname2,'_PSTHstimVBlank.pdf'];
        %print(gcf, figName,'-dpdf','-fillpage')
        %% get spike counts and z scores
        [dataT.RFStimResps,dataT.blankResps, dataT.stimResps] = parseRadFreqStimResp(dataT); 
        [dataT.RFspikeCount,dataT.blankSpikeCount,dataT.RFzScore,dataT.blankZscore] = getRadFreqSpikeCountZscore(dataT, dataT.stimResps);
        %% save data    
        if location == 1
            outputDir =  sprintf('~/bushnell-local/Dropbox/ArrayData/matfailedFiles/%s/radialFrequency/info/',dataT.array);
            if ~exist(outputDir,'dir')
                mkdir(outputDir)
            end
        elseif location == 0
            outputDir =  sprintf('~/Dropbox/ArrayData/matfailedFiles/%s/radialFrequency/info/',dataT.array);
            if ~exist(outputDir,'dir')
                mkdir(outputDir)
            end
        end
        
        if contains(filename,'LE')
            data.LE = dataT;
            data.RE = [];
        else
            data.RE = dataT;
            data.LE = [];
        end
        
        saveName = [outputDir fname2 '_' nameEnd '.mat';];
        save(saveName,'data');
        fprintf('%s saved\n\n',saveName)
end

toc/60