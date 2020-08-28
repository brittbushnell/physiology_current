% This is just to be used for debugging and fucking around with things.
% Creating a saved script for it after losing info due to crashes.

clear
close all
clc
%%
files = {
    'XT_RE_GlassTRCoh_nsp2_20190322_002_thresh35';
    'XT_RE_GlassTRCoh_nsp2_20190322_003_thresh35';
    'XT_RE_GlassTRCoh_nsp2_20190322_004_thresh35';
    'XT_RE_GlassTRCoh_nsp2_20190324_001_cleaned35';
    'XT_RE_GlassTRCoh_nsp2_20190324_001_thresh35';
    'XT_RE_GlassTRCoh_nsp2_20190324_002_thresh35';
    'XT_RE_GlassTRCoh_nsp2_20190324_003_thresh35';
    'XT_RE_GlassTRCoh_nsp2_20190324_004_thresh35';
    
    'XT_LE_Glass_nsp2_20190123_001_thresh35';
    'XT_LE_Glass_nsp2_20190124_001_thresh35';
    'XT_LE_Glass_nsp2_20190124_002_thresh35';
    'XT_LE_Glass_nsp2_20190124_003_thresh35';
    'XT_LE_GlassCoh_nsp2_20190324_005_thresh35';
    'XT_LE_GlassCoh_nsp2_20190325_001_thresh35';
    'XT_LE_GlassCoh_nsp2_20190325_002_thresh35';
    'XT_LE_GlassCoh_nsp2_20190325_003_thresh35';
    'XT_LE_GlassCoh_nsp2_20190325_004_thresh35';
    
    'XT_LE_GlassTRCoh_nsp2_20190325_005_thresh35';
    
    'XT_RE_GlassTRCoh_nsp1_20190322_002_thresh35';
    'XT_RE_GlassTRCoh_nsp1_20190322_003_thresh35';
    'XT_RE_GlassTRCoh_nsp1_20190322_004_thresh35';
    'XT_RE_GlassTRCoh_nsp1_20190324_001_cleaned35';
    'XT_RE_GlassTRCoh_nsp1_20190324_001_thresh35';
    'XT_RE_GlassTRCoh_nsp1_20190324_002_thresh35';
    'XT_RE_GlassTRCoh_nsp1_20190324_003_thresh35';
    'XT_RE_GlassTRCoh_nsp1_20190324_004_thresh35';
    
    'XT_LE_Glass_nsp1_20190123_001_thresh35';
    'XT_LE_Glass_nsp1_20190124_001_thresh35';
    'XT_LE_Glass_nsp1_20190124_002_thresh35';
    'XT_LE_Glass_nsp1_20190124_003_thresh35';
    'XT_LE_GlassCoh_nsp1_20190324_005_thresh35';
    'XT_LE_GlassCoh_nsp1_20190325_001_thresh35';
    'XT_LE_GlassCoh_nsp1_20190325_002_thresh35';
    'XT_LE_GlassCoh_nsp1_20190325_003_thresh35';
    'XT_LE_GlassCoh_nsp1_20190325_004_thresh35';
    
    'XT_LE_GlassTRCoh_nsp1_20190325_005_thresh35';
    
};
%%

for fi = 1:length(files)
    filename = files{fi};
    load(filename);
    

    nChan = 96;
    tmp = strsplit(filename,'_');
    
    % extract information about what was run from file name.
    if length(tmp) == 6
        [animal, eye, dataT.programID, array, date2,runNum] = deal(tmp{:});
        % get date in a format that's useable in figure titles (ex: 09/1/2019 vs 20190901)
        date = convertDate(date2);
    elseif length(tmp) == 7
        [animal, eye, dataT.programID, array, date2,runNum,reThreshold] = deal(tmp{:});
        date = convertDate(date2);
    else
        [animal, eye, dataT.programID, array, date2] = deal(tmp{:});
        date = date2;
    end
    
    if strcmp(array, 'nsp1')
        array = 'V1';
    elseif strcmp(array, 'nsp2')
        array = 'V4';
    end
    
    if contains(animal,'XX')
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
    
    %[numTypes,numDots,numDxs,numCoh,numSamp,types,dots,dxs,coherences,samples] = getGlassParameters(dataT);
    

    %%
    if sum(ismember(dataT.numDots,100)) ~=0 % if 100 and 0.01 were run, remove them.
        if ~contains(dataT.programID,'TR')
            dataT = removeTranslationalStim(dataT); % a small number of experiments were run with all 3 patterns
        end
        
        dataT = GlassRemoveLowDx(dataT);
        dataT = GlassRemoveLowDots(dataT);
    end
       % dataT.stimOrder = getStimPresentationOrder(dataT);
    % add in anything that's missing from the new dataT structure.
    if length(tmp) == 6
        [dataT.animal, dataT.eye, dataT.programID, dataT.array, dataT.date2,dataT.runNum] = deal(tmp{:});
        % get date in a format that's useable in figure titles (ex: 09/1/2019 vs 20190901)
        dataT.date = convertDate(dataT.date2);
        dataT.reThreshold = '';
    elseif length(tmp) == 7
        [dataT.animal, dataT.eye, dataT.programID, dataT.array, dataT.date2,dataT.runNum,dataT.reThreshold] = deal(tmp{:});
        dataT.date = convertDate(dataT.date2);
    else
        [dataT.animal, dataT.eye, dataT.programID, dataT.array, dataT.date2] = deal(tmp{:});
        dataT.date = dataT.date2;
        dataT.reThreshold = '';
    end
    
    if strcmp(dataT.array, 'nsp1')
        dataT.array = 'V1';
    elseif strcmp(dataT.array, 'nsp2')
        dataT.array = 'V4';
    end
    
    dataT.amap = aMap;
    
    figure;
    clf
    pos = get(gcf,'Position');
    set(gcf,'Position',[pos(1) pos(2) 1400 1200])
    set(gcf,'PaperOrientation','Landscape');
    for ch = 1:96
        
        subplot(dataT.amap,10,10,ch)
        hold on;
        
        REcoh = (dataT.coh == 1);
        REnoiseCoh = (dataT.coh == 0);
        REcohNdx = logical(REcoh + REnoiseCoh);
        
        blankResp = sum(smoothdata(dataT.bins((dataT.numDots == 0), 1:35 ,ch),'gaussian',3))./0.01;
        stimResp = sum(smoothdata(dataT.bins((REcohNdx), 1:35 ,ch),'gaussian',3))./0.01;
        plot(1:35,blankResp,'r','LineWidth',0.5);
        plot(1:35,stimResp,'r','LineWidth',2);
        title(ch)
        set(gca,'Color','none','tickdir','out','FontAngle','italic','FontSize',10,'XTick',[],'YTick',[]);
        ylim([0 inf])
    end
    
end
% cd ~/Desktop/PSTHChecks/
% 
% if isempty(dataT.reThreshold)
%     figName = [dataT.animal,'_',dataT.eye,'_',dataT.array,'_',dataT.date2,'_',dataT.runNum,'PSTH_raw.pdf'];
%     suptitle({(sprintf('%s %s %s %s run %s', dataT.animal, dataT.array, dataT.programID,dataT.date,dataT.runNum));...
%         'raw data, Python parser'})
% else
%     figName = [dataT.animal,'_',dataT.eye,'_',dataT.array,'_',dataT.date2,'_',dataT.runNum,'PSTH_cleaned.pdf'];
%     suptitle({(sprintf('%s %s %s %s run %s', dataT.animal, dataT.array, dataT.programID,dataT.date,dataT.runNum));...
%         'clean data, Matlab parser'})
% end
% print(gcf, figName,'-dpdf','-fillpage')