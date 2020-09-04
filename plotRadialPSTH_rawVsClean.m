clear
close all
clc
location = determineComputer;
%%
files = {
    'WU_LE_RadFreqLoc1_nsp1_20170626_002_thresh35';
    'WU_LE_RadFreqLoc2_nsp1_20170706_004_thresh35';
    'WU_LE_RadFreqLoc2_nsp1_20170703_003_thresh35';
    'WU_LE_RadFreqLoc2_nsp1_20170707_002_thresh35';
    'WU_LE_RadFreqLoc2_nsp1_20170704_005_thresh35';
    'WU_LE_RadFreqSparse_nsp1_20170522_002_thresh35';
    'WU_LE_RadFreqLoc2_nsp1_20170705_005_thresh35';
    
    'WU_RE_RadFreqLoc1_nsp1_20170626_006_thresh35';
    'WU_RE_RadFreqLoc2_nsp1_20170705_002_thresh35';
    'WU_RE_RadFreqLoc1_nsp1_20170627_002_thresh35';
    'WU_RE_RadFreqLoc2_nsp1_20170706_002_thresh35';
    'WU_RE_RadFreqLoc1_nsp1_20170628_002_thresh35';
    'WU_RE_RadFreqLoc2_nsp1_20170707_005_thresh35';
    'WU_RE_RadFreqLoc2_nsp1_20170704_002_thresh35';
    'WU_RE_RadFreqSparse_nsp1_20170522_004_thresh35';
    'WU_RE_RadFreqLoc2_nsp1_20170704_003_thresh35';
    
    'WU_RE_RadFreqLoc1_nsp2_20170626_006_thresh35';
    'WU_RE_RadFreqSparse_nsp2_20170607_004_thresh35';
    'WU_RE_RadFreqLoc1_nsp2_20170627_002_thresh35';
    'WU_RE_RadFreqSparse_nsp2_20170607_005_thresh35';
    'WU_RE_RadFreqLoc1_nsp2_20170628_002_thresh35';
    'WU_RE_RadFreq_nsp2_20170215_009_thresh35';
    'WU_RE_RadFreqLoc2_nsp2_20170704_002_thresh35';
    'WU_RE_RadFreq_nsp2_20170215_010_thresh35';
    'WU_RE_RadFreqLoc2_nsp2_20170704_003_thresh35';
    'WU_RE_RadFreq_nsp2_20170215_011_thresh35';
    'WU_RE_RadFreqLoc2_nsp2_20170705_002_thresh35';
    'WU_RE_RadFreq_nsp2_20170217_006_thresh35';
    'WU_RE_RadFreqLoc2_nsp2_20170706_002_thresh35';
    'WU_RE_RadFreq_nsp2_20170217_007_thresh35';
    'WU_RE_RadFreqLoc2_nsp2_20170707_005_thresh35';
    'WU_RE_RadFreq_nsp2_20170217_008_thresh35';
    
    'WU_LE_RadFreqLoc1_nsp2_20170626_002_thresh35';
    'WU_LE_RadFreqSparse_nsp2_20170609_002_thresh35';
    'WU_LE_RadFreqLoc2_nsp2_20170703_003_thresh35';
    'WU_LE_RadFreq_nsp2_20170215_005_thresh35';
    'WU_LE_RadFreqLoc2_nsp2_20170704_005_thresh35';
    'WU_LE_RadFreq_nsp2_20170215_006_thresh35';
    'WU_LE_RadFreqLoc2_nsp2_20170705_005_thresh35';
    'WU_LE_RadFreq_nsp2_20170215_007_thresh35';
    'WU_LE_RadFreqLoc2_nsp2_20170706_004_thresh35';
    'WU_LE_RadFreq_nsp2_20170215_008_thresh35';
    'WU_LE_RadFreqLoc2_nsp2_20170707_002_thresh35';
    'WU_LE_RadFreq_nsp2_20170217_004_thresh35';
    'WU_LE_RadFreqSparse_nsp2_20170607_002_thresh35';
    'WU_LE_RadFreq_nsp2_20170217_005_thresh35';
    
    'WV_RE_RadFreqHighSF_nsp2_20190315_002_thresh35';
    'WV_RE_RadFreqLowSF_nsp2_20190321_002_thresh35';
    'WV_RE_RadFreqHighSF_nsp2_20190318_001_thresh35';
    'WV_RE_RadFreqLowSF_nsp2_20190322_001_thresh35';
    'WV_RE_RadFreqHighSF_nsp2_20190318_002_thresh35';
    'WV_RE_RadFreqLowSF_nsp2_20190325_001_thresh35';
    'WV_RE_RadFreqHighSF_nsp2_20190319_001_thresh35';
    'WV_RE_RadFreqLowSF_nsp2_20190325_002_thresh35';
    'WV_RE_RadFreqHighSF_nsp2_20190319_002_thresh35';
    'WV_RE_RadFreqLowSF_nsp2_20190325_003_thresh35';
    'WV_RE_RadFreqLowSF_nsp2_20190320_001_thresh35';
    'WV_RE_RadFreqLowSF_nsp2_20190327_001_thresh35';
    'WV_RE_RadFreqLowSF_nsp2_20190321_001_thresh35';
    'WV_RE_RadFreqLowSF_nsp2_20190327_002_thresh35';
    
    'WV_LE_RadFreqHighSF_nsp2_20190312_002_thresh35';
    'WV_LE_RadFreqLowSF_nsp2_20190328_002_thresh35';
    'WV_LE_RadFreqHighSF_nsp2_20190313_001_thresh35';
    'WV_LE_RadFreqLowSF_nsp2_20190329_001_thresh35';
    'WV_LE_RadFreqHighSF_nsp2_20190313_002_thresh35';
    'WV_LE_RadFreqLowSF_nsp2_20190329_002_thresh35';
    'WV_LE_RadFreqHighSF_nsp2_20190314_001_thresh35';
    'WV_LE_RadFreqLowSF_nsp2_20190401_001_thresh35';
    'WV_LE_RadFreqHighSF_nsp2_20190315_001_thresh35';
    'WV_LE_RadFreqLowSF_nsp2_20190402_001_thresh35';
    'WV_LE_RadFreqLowSF_nsp2_20190328_001_thresh35';
    
    'WV_RE_RadFreqHighSF_nsp1_20190315_002_thresh35';
    'WV_RE_RadFreqLowSF_nsp1_20190321_002_thresh35';
    'WV_RE_RadFreqHighSF_nsp1_20190318_001_thresh35';
    'WV_RE_RadFreqLowSF_nsp1_20190322_001_thresh35';
    'WV_RE_RadFreqHighSF_nsp1_20190318_002_thresh35';
    'WV_RE_RadFreqLowSF_nsp1_20190325_001_thresh35';
    'WV_RE_RadFreqHighSF_nsp1_20190319_001_thresh35';
    'WV_RE_RadFreqLowSF_nsp1_20190325_002_thresh35';
    'WV_RE_RadFreqHighSF_nsp1_20190319_002_thresh35';
    'WV_RE_RadFreqLowSF_nsp1_20190325_003_thresh35';
    'WV_RE_RadFreqLowSF_nsp1_20190320_001_thresh35';
    'WV_RE_RadFreqLowSF_nsp1_20190327_001_thresh35';
    'WV_RE_RadFreqLowSF_nsp1_20190321_001_thresh35';
    'WV_RE_RadFreqLowSF_nsp1_20190327_002_thresh35';
    
    'WV_LE_RadFreqHighSF_nsp1_20190312_002_thresh35';
    'WV_LE_RadFreqLowSF_nsp1_20190328_002_thresh35';
    'WV_LE_RadFreqHighSF_nsp1_20190313_001_thresh35';
    'WV_LE_RadFreqLowSF_nsp1_20190329_001_thresh35';
    'WV_LE_RadFreqHighSF_nsp1_20190313_002_thresh35';
    'WV_LE_RadFreqLowSF_nsp1_20190329_002_thresh35';
    'WV_LE_RadFreqHighSF_nsp1_20190314_001_thresh35';
    'WV_LE_RadFreqLowSF_nsp1_20190401_001_thresh35';
    'WV_LE_RadFreqHighSF_nsp1_20190315_001_thresh35';
    'WV_LE_RadFreqLowSF_nsp1_20190402_001_thresh35';
    'WV_LE_RadFreqLowSF_nsp1_20190328_001_thresh35';
    
    'XT_RE_RadFreqHighSFV4_nsp2_20190304_002_thresh35';
    'XT_RE_radFreqHighSF_nsp2_20181227_001_thresh35';
    'XT_RE_RadFreqHighSFV4_nsp2_20190305_001_thresh35';
    'XT_RE_radFreqHighSF_nsp2_20181228_001_thresh35';
    'XT_RE_RadFreqHighSFV4_nsp2_20190305_002_thresh35';
    'XT_RE_radFreqHighSF_nsp2_20181228_002_thresh35';
    'XT_RE_RadFreqHighSFV4_nsp2_20190306_001_thresh35';
    'XT_RE_radFreqHighSF_nsp2_20181231_001_thresh35';
    'XT_RE_RadFreqHighSFV4_nsp2_20190306_002_thresh35';
    'XT_RE_radFreqLowSF_nsp2_20181217_001_thresh35';
    'XT_RE_RadFreqLowSFV4_nsp2_20190228_001_thresh35';
    'XT_RE_radFreqLowSF_nsp2_20181217_002_thresh35';
    'XT_RE_RadFreqLowSFV4_nsp2_20190228_002_thresh35';
    'XT_RE_radFreqLowSF_nsp2_20181217_003_thresh35';
    'XT_RE_RadFreqLowSFV4_nsp2_20190301_001_thresh35';
    'XT_RE_radFreqLowSF_nsp2_20181217_004_thresh35';
    'XT_RE_RadFreqLowSFV4_nsp2_20190301_002_thresh35';
    'XT_RE_radFreqLowSF_nsp2_20181217_005_thresh35';
    'XT_RE_RadFreqLowSFV4_nsp2_20190304_001_thresh35';
    
    'XT_LE_RadFreqHighSFV4_nsp2_20190306_003_thresh35';
    'XT_LE_RadFreqLowSF_nsp2_20181211_001_thresh35';
    'XT_LE_RadFreqHighSFV4_nsp2_20190307_001_thresh35';
    'XT_LE_RadFreqLowSF_nsp2_20181211_002_thresh35';
    'XT_LE_RadFreqLowSFV4_nsp2_20190226_002_thresh35';
    'XT_LE_RadFreqLowSF_nsp2_20181213_001_thresh35';
    'XT_LE_RadFreqLowSFV4_nsp2_20190226_003_thresh35';
    'XT_LE_RadFreqLowSF_nsp2_20181213_002_thresh35';
    'XT_LE_RadFreqLowSFV4_nsp2_20190227_001_thresh35';
    'XT_LE_radFreqHighSF_nsp2_20190102_001_thresh35';
    'XT_LE_RadFreqLowSFV4_nsp2_20190227_002_thresh35';
    'XT_LE_radFreqHighSF_nsp2_20190102_002_thresh35';
    'XT_LE_RadFreqLowSFV4_nsp2_20190227_003_thresh35';
    'XT_LE_radFreqHighSF_nsp2_20190103_001_thresh35';
    'XT_LE_RadFreqLowSF_nsp2_20181210_002_thresh35';
    'XT_LE_radFreqHighSF_nsp2_20190103_002_thresh35';
    
    'XT_RE_RadFreqHighSFV4_nsp1_20190304_002_thresh35';
    'XT_RE_radFreqHighSF_nsp1_20181227_001_thresh35';
    'XT_RE_RadFreqHighSFV4_nsp1_20190305_001_thresh35';
    'XT_RE_radFreqHighSF_nsp1_20181228_001_thresh35';
    'XT_RE_RadFreqHighSFV4_nsp1_20190305_002_thresh35';
    'XT_RE_radFreqHighSF_nsp1_20181228_002_thresh35';
    'XT_RE_RadFreqHighSFV4_nsp1_20190306_001_thresh35';
    'XT_RE_radFreqHighSF_nsp1_20181231_001_thresh35';
    'XT_RE_RadFreqHighSFV4_nsp1_20190306_002_thresh35';
    'XT_RE_radFreqLowSF_nsp1_20181217_001_thresh35';
    'XT_RE_RadFreqLowSFV4_nsp1_20190228_001_thresh35';
    'XT_RE_radFreqLowSF_nsp1_20181217_002_thresh35';
    'XT_RE_RadFreqLowSFV4_nsp1_20190228_002_thresh35';
    'XT_RE_radFreqLowSF_nsp1_20181217_003_thresh35';
    'XT_RE_RadFreqLowSFV4_nsp1_20190301_001_thresh35';
    'XT_RE_radFreqLowSF_nsp1_20181217_004_thresh35';
    'XT_RE_RadFreqLowSFV4_nsp1_20190301_002_thresh35';
    'XT_RE_radFreqLowSF_nsp1_20181217_005_thresh35';
    'XT_RE_RadFreqLowSFV4_nsp1_20190304_001_thresh35';
    
    'XT_LE_RadFreqHighSFV4_nsp1_20190306_003_thresh35';
    'XT_LE_RadFreqLowSF_nsp1_20181211_001_thresh35';
    'XT_LE_RadFreqHighSFV4_nsp1_20190307_001_thresh35';
    'XT_LE_RadFreqLowSF_nsp1_20181211_002_thresh35';
    'XT_LE_RadFreqLowSFV4_nsp1_20190226_002_thresh35';
    'XT_LE_RadFreqLowSF_nsp1_20181213_001_thresh35';
    'XT_LE_RadFreqLowSFV4_nsp1_20190226_003_thresh35';
    'XT_LE_RadFreqLowSF_nsp1_20181213_002_thresh35';
    'XT_LE_RadFreqLowSFV4_nsp1_20190227_001_thresh35';
    'XT_LE_radFreqHighSF_nsp1_20190102_001_thresh35';
    'XT_LE_RadFreqLowSFV4_nsp1_20190227_002_thresh35';
    'XT_LE_radFreqHighSF_nsp1_20190102_002_thresh35';
    'XT_LE_RadFreqLowSFV4_nsp1_20190227_003_thresh35';
    'XT_LE_radFreqHighSF_nsp1_20190103_001_thresh35';
    'XT_LE_RadFreqLowSF_nsp1_20181210_002_thresh35';
    'XT_LE_radFreqHighSF_nsp1_20190103_002_thresh35';
    };
failNdx = 0;
%% load data and extract info
for fi = 1:length(files)
    try
    filename = files{fi};
    cleanData = load(files{fi});
    
    %extract information from filename
    chunks = strsplit(files{fi},'_');
    animal = chunks{1};
    eye = chunks{2};
    program = chunks{3};
    array = chunks{4};
    date = chunks{5};
    runNum = chunks{6};
    
    % Find unique x and y locations used
    xloc  = unique(cleanData.pos_x);
    yloc  = unique(cleanData.pos_y);
    
    for y = 1:length(yloc)
        for x = 1:length(xloc)
            posX(x,y) = xloc(x);
            posY(x,y) = yloc(y);
        end
    end
    
    % all of the other unique parameters are stored in the file name and need
    % to be parsed out.
    for i = 1:length(cleanData.filename)
        [name, rf, rad, mod, ori, sf] = parseRFName(cleanData.filename(i,:));
        
        cleanData.rf(i,1)  = rf;
        cleanData.amplitude(i,1) = mod;
        cleanData.orientation(i,1) = ori;
        cleanData.spatialFrequency(i,1) = sf;
        cleanData.radius(i,1) = rad; %remember, size of RF stimuli is in mean radius
%         name  = string(name);
%         cleanData.name(i,:) = name;
    end    
    % Make all of the vectors the same dimensions
    cleanData.pos_x = cleanData.pos_x';
    cleanData.pos_y = cleanData.pos_y';
    
    % add other information
    cleanData.animal = animal;
    cleanData.array = array;
    cleanData.eye = eye;
    cleanData.program = program;
    cleanData.date = date;
    cleanData.runNum = runNum;
    aMap = getBlackrockArrayMap(files(1,:));
    cleanData.amap = aMap;
    %% now do the same for the raw data
    rawName = strrep(filename,'_thresh35','');
    rawData = load(rawName);
    
    % Find unique x and y locations used
    xloc  = unique(rawData.pos_x);
    yloc  = unique(rawData.pos_y);
    
    for y = 1:length(yloc)
        for x = 1:length(xloc)
            posX(x,y) = xloc(x);
            posY(x,y) = yloc(y);
        end
    end
    
    % all of the other unique parameters are stored in the file name and need
    % to be parsed out.
    for i = 1:length(rawData.filename)
        [name, rf, rad, mod, ori, sf] = parseRFName(rawData.filename(i,:));
        
        rawData.rf(i,1)  = rf;
        rawData.amplitude(i,1) = mod;
        rawData.orientation(i,1) = ori;
        rawData.spatialFrequency(i,1) = sf;
        rawData.radius(i,1) = rad; %remember, size of RF stimuli is in mean radius
%         name  = char(name);
%         rawData.name(i,:) = name;
    end
    numCh = size(rawData.bins,3);
    
    % Make all of the vectors the same dimensions
    rawData.pos_x = rawData.pos_x';
    rawData.pos_y = rawData.pos_y';
    
    % add other information
    rawData.animal = animal;
    rawData.array = array;
    rawData.eye = eye;
    rawData.program = program;
    rawData.date = date;
    %% plot stim vs blank PSTH to look for timing funkiness
    if location == 0
        figDir =  sprintf( '/Users/brittany/Dropbox/Figures/%s/radialFrequency/%s/PSTH/%s/stimVblank',cleanData.animal, cleanData.array,eye);
        
        if ~exist(figDir,'dir')
            mkdir(figDir)
        end
    else
        figDir =  sprintf( '/Local/Users/bushnell/Dropbox/Figures/%s/radialFrequency/%s/PSTH/%s/stimVblank',cleanData.animal,cleanData.array,eye);
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
        
        blankResp = sum(smoothdata(cleanData.bins((cleanData.rf == 10000), 1:35 ,ch),'gaussian',3));
        stimResp = sum(smoothdata(cleanData.bins((cleanData.rf ~= 10000), 1:35 ,ch),'gaussian',3));
        plot(1:35,blankResp,'b','LineWidth',0.5);
        plot(1:35,stimResp,'b','LineWidth',2);

        
        blankResp = sum(smoothdata(rawData.bins((rawData.rf == 10000), 1:35 ,ch),'gaussian',3));
        stimResp = sum(smoothdata(rawData.bins((rawData.rf ~= 10000), 1:35 ,ch),'gaussian',3));
        plot(1:35,blankResp,'r','LineWidth',0.5);
        plot(1:35,stimResp,'r','LineWidth',2);
        
        title(ch)
        set(gca,'Color','none','tickdir','out','FontAngle','italic','FontSize',10,'XTick',[]);
        
    end
    suptitle({(sprintf('%s %s %s radial frequency %s run %s', cleanData.animal, cleanData.eye,cleanData.array,cleanData.date,cleanData.runNum));...
        'blue: cleaned  red: raw'})
    
    figName = [cleanData.animal,'_',cleanData.eye,'_',cleanData.array,'_radialFrequency_PSTH_',cleanData.date,'_',cleanData.runNum,'.pdf'];
    print(gcf, figName,'-dpdf','-bestfit')
    
    catch ME
        failNdx = failNdx+1;
        failInfo{failNdx,1} = ME.message;
        failName{failNdx,1}= filename;
    end
        
end