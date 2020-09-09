clear
close all
clc
location = determineComputer;
%%
files = {
    'WU_LE_GlassTR_nsp2_20170822_002_thresh35'
    'WU_LE_GlassTR_nsp2_20170824_001_thresh35'
    'WU_LE_GlassTR_nsp2_20170825_002_thresh35'
    'WU_LE_Glass_nsp2_20170817_001_thresh35'
    'WU_LE_Glass_nsp2_20170821_002_thresh35'
    'WU_LE_Glass_nsp2_20170822_001_thresh35'
    'WU_LE_GlassTR_nsp1_20170822_002_thresh35'
    'WU_LE_GlassTR_nsp1_20170824_001_thresh35'
    'WU_LE_GlassTR_nsp1_20170825_002_thresh35'
    'WU_LE_Glass_nsp1_20170817_001_thresh35'
    'WU_LE_Glass_nsp1_20170821_002_thresh35'
    'WU_LE_Glass_nsp1_20170822_001_thresh35'
    'WU_RE_GlassTR_nsp2_20170825_001_thresh35'
    'WU_RE_GlassTR_nsp2_20170828_002_thresh35'
    'WU_RE_GlassTR_nsp2_20170828_003_thresh35'
    'WU_RE_GlassTR_nsp2_20170829_001_thresh35'
    'WU_RE_Glass_nsp2_20170817_002_thresh35'
    'WU_RE_Glass_nsp2_20170818_001_thresh35'
    'WU_RE_Glass_nsp2_20170818_002_thresh35'
    'WU_RE_Glass_nsp2_20170821_001_thresh35'
    'WU_RE_GlassTR_nsp1_20170825_001_thresh35'
    'WU_RE_GlassTR_nsp1_20170828_002_thresh35'
    'WU_RE_GlassTR_nsp1_20170828_003_thresh35'
    'WU_RE_GlassTR_nsp1_20170829_001_thresh35'
    'WU_RE_Glass_nsp1_20170817_002_thresh35'
    'WU_RE_Glass_nsp1_20170818_001_thresh35'
    'WU_RE_Glass_nsp1_20170821_001_thresh35'
    'WV_LE_glassCohSmall_nsp2_20190425_002_thresh35'
    'WV_LE_glassCohSmall_nsp2_20190425_003_thresh35'
    'WV_LE_glassCohSmall_nsp2_20190429_001_thresh35'
    'WV_LE_glassCohSmall_nsp2_20190429_002_thresh35'
    'WV_LE_glassCoh_nsp2_20190402_002_thresh35'
    'WV_LE_glassCoh_nsp2_20190402_003_thresh35'
    'WV_LE_glassCoh_nsp2_20190402_004_thresh35'
    'WV_LE_glassCoh_nsp2_20190403_001_thresh35'
    'WV_LE_glassCoh_nsp2_20190403_002_thresh35'
    'WV_LE_glassCoh_nsp2_20190404_001_thresh35'
    'WV_LE_glassTRCohSmall_nsp2_20190429_003_thresh35'
    'WV_LE_glassTRCohSmall_nsp2_20190429_004_thresh35'
    'WV_LE_glassTRCoh_nsp2_20190411_001_thresh35'
    'WV_LE_glassTRCoh_nsp2_20190412_001_thresh35'
    'WV_LE_glassTRCoh_nsp2_20190415_001_thresh35'
    'WV_LE_glassTRCoh_nsp2_20190415_002_thresh35'
    'WV_LE_glassTRCoh_nsp2_20190416_001_thresh35'
    'WV_LE_glassTRCoh_nsp2_20190416_002_thresh35'
    'WV_LE_glassTRCoh_nsp2_20190416_003_thresh35'
    'WV_LE_glassTRCoh_nsp2_20190417_001_thresh35'
    'WV_LE_glassTRCoh_nsp2_20190417_002_thresh35'
    'WV_LE_glassCohSmall_nsp1_20190425_002_thresh35'
    'WV_LE_glassCohSmall_nsp1_20190425_003_thresh35'
    'WV_LE_glassCohSmall_nsp1_20190429_001_thresh35'
    'WV_LE_glassCohSmall_nsp1_20190429_002_thresh35'
    'WV_LE_glassCoh_nsp1_20190402_002_thresh35'
    'WV_LE_glassCoh_nsp1_20190402_003_thresh35'
    'WV_LE_glassCoh_nsp1_20190402_004_thresh35'
    'WV_LE_glassCoh_nsp1_20190403_001_thresh35'
    'WV_LE_glassCoh_nsp1_20190403_002_thresh35'
    'WV_LE_glassCoh_nsp1_20190404_001_thresh35'
    'WV_LE_glassTRCohSmall_nsp1_20190429_003_thresh35'
    'WV_LE_glassTRCohSmall_nsp1_20190429_004_thresh35'
    'WV_LE_glassTRCohSmall_nsp1_20190430_001_thresh35'
    'WV_LE_glassTRCohSmall_nsp1_20190430_002_thresh35'
    'WV_LE_glassTRCohSmall_nsp1_20190430_003_thresh35'
    'WV_LE_glassTRCohSmall_nsp1_20190501_001_thresh35'
    'WV_LE_glassTRCohSmall_nsp1_20190501_002_thresh35'
    'WV_LE_glassTRCohSmall_nsp1_20190502_001_thresh35'
    'WV_LE_glassTRCohSmall_nsp1_20190503_001_thresh35'
    'WV_LE_glassTRCoh_nsp1_20190411_001_thresh35'
    'WV_LE_glassTRCoh_nsp1_20190412_001_thresh35'
    'WV_LE_glassTRCoh_nsp1_20190415_001_thresh35'
    'WV_LE_glassTRCoh_nsp1_20190415_002_thresh35'
    'WV_LE_glassTRCoh_nsp1_20190416_001_thresh35'
    'WV_LE_glassTRCoh_nsp1_20190416_002_thresh35'
    'WV_LE_glassTRCoh_nsp1_20190416_003_thresh35'
    'WV_LE_glassTRCoh_nsp1_20190417_001_thresh35'
    'WV_LE_glassTRCoh_nsp1_20190417_002_thresh35'
    'WV_RE_glassCohSmall_nsp2_20190423_001_thresh35'
    'WV_RE_glassCohSmall_nsp2_20190423_002_thresh35'
    'WV_RE_glassCohSmall_nsp2_20190424_001_thresh35'
    'WV_RE_glassCoh_nsp2_20190404_002_thresh35'
    'WV_RE_glassCoh_nsp2_20190404_003_thresh35'
    'WV_RE_glassCoh_nsp2_20190405_001_thresh35'
    'WV_RE_glassTRCoh_nsp2_20190405_002_thresh35'
    'WV_RE_glassTRCoh_nsp2_20190408_001_thresh35'
    'WV_RE_glassTRCoh_nsp2_20190409_001_thresh35'
    'WV_RE_glassTRCoh_nsp2_20190409_002_thresh35'
    'WV_RE_glassTRCoh_nsp2_20190410_001_thresh35'
    'WV_RE_glassTRCoh_nsp2_20190410_002_thresh35'
    'WV_RE_glassCohSmall_nsp1_20190423_001_thresh35'
    'WV_RE_glassCohSmall_nsp1_20190423_002_thresh35'
    'WV_RE_glassCohSmall_nsp1_20190424_001_thresh35'
    'WV_RE_glassCoh_nsp1_20190404_002_thresh35'
    'WV_RE_glassCoh_nsp1_20190404_003_thresh35'
    'WV_RE_glassCoh_nsp1_20190405_001_thresh35'
    'WV_RE_glassTRCohSmall_nsp1_20190503_002_thresh35'
    'WV_RE_glassTRCohSmall_nsp1_20190506_001_thresh35'
    'WV_RE_glassTRCohSmall_nsp1_20190506_002_thresh35'
    'WV_RE_glassTRCohSmall_nsp1_20190507_001_thresh35'
    'WV_RE_glassTRCohSmall_nsp1_20190508_001_thresh35'
    'WV_RE_glassTRCoh_nsp1_20190405_002_thresh35'
    'WV_RE_glassTRCoh_nsp1_20190408_001_thresh35'
    'WV_RE_glassTRCoh_nsp1_20190409_001_thresh35'
    'WV_RE_glassTRCoh_nsp1_20190409_002_thresh35'
    'WV_RE_glassTRCoh_nsp1_20190410_001_thresh35'
    'WV_RE_glassTRCoh_nsp1_20190410_002_thresh35'
    
    'XT_LE_GlassCoh_nsp2_20190324_005_thresh35'
    'XT_LE_GlassCoh_nsp2_20190325_001_thresh35'
    'XT_LE_GlassCoh_nsp2_20190325_002_thresh35'
    'XT_LE_GlassCoh_nsp2_20190325_003_thresh35'
    'XT_LE_GlassCoh_nsp2_20190325_004_thresh35'
    
    'XT_LE_GlassTRCoh_nsp2_20190325_005_thresh35'
    
    'XT_LE_GlassTR_nsp2_20190130_001_thresh35'
    'XT_LE_GlassTR_nsp2_20190130_002_thresh35'
    'XT_LE_GlassTR_nsp2_20190130_003_thresh35'
    'XT_LE_GlassTR_nsp2_20190130_004_thresh35'
    'XT_LE_GlassTR_nsp2_20190131_001_thresh35'
    
    'XT_LE_Glass_nsp2_20190123_001_thresh35'
    'XT_LE_Glass_nsp2_20190124_001_thresh35'
    'XT_LE_Glass_nsp2_20190124_002_thresh35'
    'XT_LE_Glass_nsp2_20190124_003_thresh35'
    
    'XT_LE_GlassCoh_nsp1_20190324_005_thresh35'
    'XT_LE_GlassCoh_nsp1_20190325_001_thresh35'
    'XT_LE_GlassCoh_nsp1_20190325_002_thresh35'
    'XT_LE_GlassCoh_nsp1_20190325_003_thresh35'
    'XT_LE_GlassCoh_nsp1_20190325_004_thresh35'
    
    'XT_LE_GlassTRCoh_nsp1_20190325_005_thresh35'
    
    'XT_LE_GlassTR_nsp1_20190130_001_thresh35'
    'XT_LE_GlassTR_nsp1_20190130_002_thresh35'
    'XT_LE_GlassTR_nsp1_20190130_003_thresh35'
    'XT_LE_GlassTR_nsp1_20190130_004_thresh35'
    'XT_LE_GlassTR_nsp1_20190131_001_thresh35'
    
    'XT_LE_Glass_nsp1_20190123_001_thresh35'
    'XT_LE_Glass_nsp1_20190123_002_thresh35'
    'XT_LE_Glass_nsp1_20190124_001_thresh35'
    'XT_LE_Glass_nsp1_20190124_002_thresh35'
    'XT_LE_Glass_nsp1_20190124_003_thresh35'
    
    'XT_RE_GlassCoh_nsp2_20190321_002_thresh35'
    'XT_RE_GlassCoh_nsp2_20190321_003_thresh35'
    'XT_RE_GlassCoh_nsp2_20190322_001_thresh35'
    
    'XT_RE_GlassTRCoh_nsp2_20190322_002_thresh35'
    'XT_RE_GlassTRCoh_nsp2_20190322_003_thresh35'
    'XT_RE_GlassTRCoh_nsp2_20190322_004_thresh35'
    'XT_RE_GlassTRCoh_nsp2_20190324_001_thresh35'
    'XT_RE_GlassTRCoh_nsp2_20190324_002_thresh35'
    'XT_RE_GlassTRCoh_nsp2_20190324_003_thresh35'
    'XT_RE_GlassTRCoh_nsp2_20190324_004_thresh35'
    
    'XT_RE_GlassTR_nsp2_20190125_001_thresh35'
    'XT_RE_GlassTR_nsp2_20190125_002_thresh35'
    'XT_RE_GlassTR_nsp2_20190125_003_thresh35'
    'XT_RE_GlassTR_nsp2_20190125_004_thresh35'
    'XT_RE_GlassTR_nsp2_20190125_005_thresh35'
    'XT_RE_GlassTR_nsp2_20190128_001_thresh35'
    'XT_RE_GlassTR_nsp2_20190128_002_thresh35'
    
    'XT_RE_Glass_nsp2_20190123_003_thresh35'
    'XT_RE_Glass_nsp2_20190123_004_thresh35'
    'XT_RE_Glass_nsp2_20190123_005_thresh35'
    'XT_RE_Glass_nsp2_20190123_006_thresh35'
    'XT_RE_Glass_nsp2_20190123_007_thresh35'
    'XT_RE_Glass_nsp2_20190123_008_thresh35'
    'XT_RE_Glass_nsp2_20190124_005_thresh35'
    
    'XT_RE_GlassCoh_nsp1_20190321_002_thresh35'
    'XT_RE_GlassCoh_nsp1_20190322_001_thresh35'
    'XT_RE_GlassTRCoh_nsp1_20190322_002_thresh35'
    'XT_RE_GlassTRCoh_nsp1_20190322_003_thresh35'
    'XT_RE_GlassTRCoh_nsp1_20190322_004_thresh35'
    'XT_RE_GlassTRCoh_nsp1_20190324_001_thresh35'
    'XT_RE_GlassTRCoh_nsp1_20190324_002_thresh35'
    'XT_RE_GlassTRCoh_nsp1_20190324_003_thresh35'
    'XT_RE_GlassTRCoh_nsp1_20190324_004_thresh35'
    
    'XT_RE_GlassTR_nsp1_20190125_001_thresh35'
    'XT_RE_GlassTR_nsp1_20190125_002_thresh35'
    'XT_RE_GlassTR_nsp1_20190125_003_thresh35'
    'XT_RE_GlassTR_nsp1_20190125_004_thresh35'
    'XT_RE_GlassTR_nsp1_20190125_005_thresh35'
    'XT_RE_GlassTR_nsp1_20190128_001_thresh35'
    'XT_RE_GlassTR_nsp1_20190128_002_thresh35'
    
    'XT_RE_Glass_nsp1_20190123_003_thresh35'
    'XT_RE_Glass_nsp1_20190123_004_thresh35'
    'XT_RE_Glass_nsp1_20190123_005_thresh35'
    'XT_RE_Glass_nsp1_20190123_006_thresh35'
    'XT_RE_Glass_nsp1_20190123_007_thresh35'
    'XT_RE_Glass_nsp1_20190123_008_thresh35'
    'XT_RE_Glass_nsp1_20190124_005_thresh35'
    };
%%
for fi = 1:length(files)
    %% Get basic information about experiments from clean data
        aMap = getBlackrockArrayMap(files{1});
        
        filename = files{fi};
        cleanData = load(filename);

        fprintf('*** file %d/%d *** \n',fi,length(files))
        
        nChan = 96;
        tmp = strsplit(filename,'_');
        
        % extract information about what was run from file name.
        if length(tmp) == 6
            [animal, eye, cleanData.programID, array, date2,runNum] = deal(tmp{:});
            % get date in a format that's useable in figure titles (ex: 09/1/2019 vs 20190901)
            date = convertDate(date2);
        elseif length(tmp) == 7
            [animal, eye, cleanData.programID, array, date2,runNum,reThreshold] = deal(tmp{:});
            date = convertDate(date2);
        else
            [animal, eye, cleanData.programID, array, date2] = deal(tmp{:});
            date = date2;
        end
        
        if strcmp(array, 'nsp1')
            array = 'V1';
        elseif strcmp(array, 'nsp2')
            array = 'V4';
        end
        
        if contains(animal,'XX')
            cleanData.filename = reshape(cleanData.filename,[numel(cleanData.filename),1]);
            cleanData.filename = char(cleanData.filename);
        end
        
        ndx = 1;
        for i = 1:size(cleanData.filename,1)
            [type, numDots, dx, coh, sample] = parseGlassName(cleanData.filename(i,:));
            
            %  type: numeric versions of the first letter of the pattern type
            %     0:  noise
            %     1: concentric
            %     2: radial
            %     3: translational
            %     100:blank
            cleanData.type(1,ndx)    = type;
            cleanData.numDots(1,ndx) = numDots;
            cleanData.dx(1,ndx)      = dx;
            cleanData.coh(1,ndx)     = coh;
            cleanData.sample(1,ndx)  = sample;
            ndx = ndx+1;
        end
        
        %[numTypes,numDots,numDxs,numCoh,numSamp,types,dots,dxs,coherences,samples] = getGlassParameters(cleanData);       
        %%
        if sum(ismember(cleanData.numDots,100)) ~=0 % if 100 and 0.01 were run, remove them.
            if ~contains(cleanData.programID,'TR')
                cleanData = removeTranslationalStim(cleanData); % a small number of experiments were run with all 3 patterns
            end
            
            cleanData = GlassRemoveLowDx(cleanData);
            cleanData = GlassRemoveLowDots(cleanData);
        end
        % cleanData.stimOrder = getStimPresentationOrder(cleanData);
        % add in anything that's missing from the new cleanData structure.
        if length(tmp) == 6
            [cleanData.animal, cleanData.eye, cleanData.programID, cleanData.array, cleanData.date2,cleanData.runNum] = deal(tmp{:});
            % get date in a format that's useable in figure titles (ex: 09/1/2019 vs 20190901)
            cleanData.date = convertDate(cleanData.date2);
            cleanData.reThreshold = '';
        elseif length(tmp) == 7
            [cleanData.animal, cleanData.eye, cleanData.programID, cleanData.array, cleanData.date2,cleanData.runNum,cleanData.reThreshold] = deal(tmp{:});
            cleanData.date = convertDate(cleanData.date2);
        else
            [cleanData.animal, cleanData.eye, cleanData.programID, cleanData.array, cleanData.date2] = deal(tmp{:});
            cleanData.date = cleanData.date2;
            cleanData.reThreshold = '';
        end
        
        if strcmp(cleanData.array, 'nsp1')
            cleanData.array = 'V1';
        elseif strcmp(cleanData.array, 'nsp2')
            cleanData.array = 'V4';
        end
        
        cleanData.amap = aMap;
        %% now do the same for the raw data
        rawName = strrep(filename,'_thresh35','');
        rawData = load(rawName);
                nChan = 96;
        tmp = strsplit(filename,'_');
        
        % extract information about what was run from file name.
        if length(tmp) == 6
            [animal, eye, rawData.programID, array, date2,runNum] = deal(tmp{:});
            % get date in a format that's useable in figure titles (ex: 09/1/2019 vs 20190901)
            date = convertDate(date2);
        elseif length(tmp) == 7
            [animal, eye, rawData.programID, array, date2,runNum,reThreshold] = deal(tmp{:});
            date = convertDate(date2);
        else
            [animal, eye, rawData.programID, array, date2] = deal(tmp{:});
            date = date2;
        end
        
        if strcmp(array, 'nsp1')
            array = 'V1';
        elseif strcmp(array, 'nsp2')
            array = 'V4';
        end
        
        if contains(animal,'XX')
            rawData.filename = reshape(rawData.filename,[numel(rawData.filename),1]);
            rawData.filename = char(rawData.filename);
        end
        
        ndx = 1;
        for i = 1:size(rawData.filename,1)
            [type, numDots, dx, coh, sample] = parseGlassName(rawData.filename(i,:));
            
            %  type: numeric versions of the first letter of the pattern type
            %     0:  noise
            %     1: concentric
            %     2: radial
            %     3: translational
            %     100:blank
            rawData.type(1,ndx)    = type;
            rawData.numDots(1,ndx) = numDots;
            rawData.dx(1,ndx)      = dx;
            rawData.coh(1,ndx)     = coh;
            rawData.sample(1,ndx)  = sample;
            ndx = ndx+1;
        end
        
        %[numTypes,numDots,numDxs,numCoh,numSamp,types,dots,dxs,coherences,samples] = getGlassParameters(rawData);       
        %%
        if sum(ismember(rawData.numDots,100)) ~=0 % if 100 and 0.01 were run, remove them.
            if ~contains(rawData.programID,'TR')
                rawData = removeTranslationalStim(rawData); % a small number of experiments were run with all 3 patterns
            end
            
            rawData = GlassRemoveLowDx(rawData);
            rawData = GlassRemoveLowDots(rawData);
        end
        % rawData.stimOrder = getStimPresentationOrder(rawData);
        % add in anything that's missing from the new rawData structure.
        if length(tmp) == 6
            [rawData.animal, rawData.eye, rawData.programID, rawData.array, rawData.date2,rawData.runNum] = deal(tmp{:});
            % get date in a format that's useable in figure titles (ex: 09/1/2019 vs 20190901)
            rawData.date = convertDate(rawData.date2);
            rawData.reThreshold = '';
        elseif length(tmp) == 7
            [rawData.animal, rawData.eye, rawData.programID, rawData.array, rawData.date2,rawData.runNum,rawData.reThreshold] = deal(tmp{:});
            rawData.date = convertDate(rawData.date2);
        else
            [rawData.animal, rawData.eye, rawData.programID, rawData.array, rawData.date2] = deal(tmp{:});
            rawData.date = rawData.date2;
            rawData.reThreshold = '';
        end
        
        if strcmp(rawData.array, 'nsp1')
            rawData.array = 'V1';
        elseif strcmp(rawData.array, 'nsp2')
            rawData.array = 'V4';
        end
        
        rawData.amap = aMap;
        %% plot stim vs blank PSTH to look for timing funkiness
        if location == 0
            figDir =  sprintf( '/Users/brittany/Dropbox/Figures/%s/%s/%s/PSTH/%s/stimVblank',cleanData.animal, cleanData.programID, cleanData.array,eye);
            
            if ~exist(figDir,'dir')
                mkdir(figDir)
            end
        else
            figDir =  sprintf( '/Local/Users/bushnell/Dropbox/Figures/%s/%s/%s/PSTH/%s/stimVblank',cleanData.animal, cleanData.programID, cleanData.array,eye);
            if ~exist(figDir,'dir')
                mkdir(figDir)
            end
        end
        cd(figDir)
        
        figure(200);
        clf
        pos = get(gcf,'Position');
        set(gcf,'Position',[pos(1) pos(2) 1200 900])
        set(gcf,'PaperOrientation','Landscape');
        for ch = 1:96
            
            subplot(cleanData.amap,10,10,ch)
            hold on;
            
            REcoh = (cleanData.coh == 1);
            REnoiseCoh = (cleanData.coh == 0);
            REcohNdx = logical(REcoh + REnoiseCoh);
            
            blankResp = mean(smoothdata(cleanData.bins((cleanData.numDots == 0), 1:35 ,ch),'gaussian',3))//0.01;
            stimResp = mean(smoothdata(cleanData.bins((REcohNdx), 1:35 ,ch),'gaussian',3))./0.01;
            plot(1:35,blankResp,'b','LineWidth',0.5);
            plot(1:35,stimResp,'b','LineWidth',2);
            
            REcoh = (rawData.coh == 1);
            REnoiseCoh = (rawData.coh == 0);
            REcohNdx = logical(REcoh + REnoiseCoh);
            
            blankResp = mean(smoothdata(rawData.bins((rawData.numDots == 0), 1:35 ,ch),'gaussian',3))./0.01;
            stimResp = mean(smoothdata(rawData.bins((REcohNdx), 1:35 ,ch),'gaussian',3))./0.01;
            plot(1:35,blankResp,'r','LineWidth',0.5);
            plot(1:35,stimResp,'r','LineWidth',2);
            
            title(ch)
            set(gca,'Color','none','tickdir','out','FontAngle','italic','FontSize',10,'XTick',[]);

        end
        suptitle({(sprintf('%s %s %s %s %s run %s', cleanData.animal, cleanData.eye,cleanData.array, cleanData.programID,cleanData.date,cleanData.runNum));...
            'blue: cleaned  red: raw'})
        
        figName = [cleanData.animal,'_',cleanData.eye,'_',cleanData.array,'_',cleanData.programID,'_PSTH_',cleanData.date2,'_',cleanData.runNum,'.pdf'];
        print(gcf, figName,'-dpdf','-bestfit')
end