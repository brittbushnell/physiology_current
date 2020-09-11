function plotGlassPSTH_rawVsClean (cleanData,filename)
%%
location = determineComputer;

%% now do the same for the raw data
rawName = strrep(filename,'_thresh35','');
rawData = load(rawName);
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
%% plot PSTH
figure(200);
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 1200 900])
set(gcf,'PaperOrientation','Landscape');
for ch = 1:96
    
    subplot(cleanData.amap,10,10,ch)
    hold on;
    
    blankResp = mean(smoothdata(cleanData.bins((cleanData.numDots == 0), 1:35 ,ch),'gaussian',3))./0.01;
    stimResp = mean(smoothdata(cleanData.bins((cleanData.numDots > 0), 1:35 ,ch),'gaussian',3))./0.01;
    plot(1:35,blankResp,'b','LineWidth',0.5);
    plot(1:35,stimResp,'b','LineWidth',2);
    
    
    blankResp = mean(smoothdata(rawData.bins((rawData.numDots == 0), 1:35 ,ch),'gaussian',3))./0.01;
    stimResp = mean(smoothdata(rawData.bins((rawData.numDots > 0), 1:35 ,ch),'gaussian',3))./0.01;
    plot(1:35,blankResp,'r','LineWidth',0.5);
    plot(1:35,stimResp,'r','LineWidth',2);
    
    title(ch)
    set(gca,'Color','none','tickdir','out','FontAngle','italic','FontSize',10,'XTick',[]);
    
end
suptitle({(sprintf('%s %s %s %s %s run %s', cleanData.animal, cleanData.eye,cleanData.array,cleanData.programID,cleanData.date,cleanData.runNum));...
    'blue: cleaned  red: raw'})

figName = [cleanData.animal,'_',cleanData.eye,'_',cleanData.array,'_',cleanData.programID,'_PSTH_',cleanData.date2,'_',cleanData.runNum,'.pdf'];
print(gcf, figName,'-dpdf','-bestfit')


%% old code
% for fi = 1:length(files)
%     %% Get basic information about experiments from clean data
%         aMap = getBlackrockArrayMap(files{1});
%
%         filename = files{fi};
%         cleanData = load(filename);
%
%         fprintf('*** file %d/%d *** \n',fi,length(files))
%
%         nChan = 96;
%         tmp = strsplit(filename,'_');
%
%         % extract information about what was run from file name.
%         if length(tmp) == 6
%             [animal, eye, cleanData.programID, array, date2,runNum] = deal(tmp{:});
%             % get date in a format that's useable in figure titles (ex: 09/1/2019 vs 20190901)
%             date = convertDate(date2);
%         elseif length(tmp) == 7
%             [animal, eye, cleanData.programID, array, date2,runNum,reThreshold] = deal(tmp{:});
%             date = convertDate(date2);
%         else
%             [animal, eye, cleanData.programID, array, date2] = deal(tmp{:});
%             date = date2;
%         end
%
%         if strcmp(array, 'nsp1')
%             array = 'V1';
%         elseif strcmp(array, 'nsp2')
%             array = 'V4';
%         end
%
%         if contains(animal,'XX')
%             cleanData.filename = reshape(cleanData.filename,[numel(cleanData.filename),1]);
%             cleanData.filename = char(cleanData.filename);
%         end
%
%         ndx = 1;
%         for i = 1:size(cleanData.filename,1)
%             [type, numDots, dx, coh, sample] = parseGlassName(cleanData.filename(i,:));
%
%             %  type: numeric versions of the first letter of the pattern type
%             %     0:  noise
%             %     1: concentric
%             %     2: radial
%             %     3: translational
%             %     100:blank
%             cleanData.type(1,ndx)    = type;
%             cleanData.numDots(1,ndx) = numDots;
%             cleanData.dx(1,ndx)      = dx;
%             cleanData.coh(1,ndx)     = coh;
%             cleanData.sample(1,ndx)  = sample;
%             ndx = ndx+1;
%         end
%
%         %[numTypes,numDots,numDxs,numCoh,numSamp,types,dots,dxs,coherences,samples] = getGlassParameters(cleanData);
%         %%
%         if sum(ismember(cleanData.numDots,100)) ~=0 % if 100 and 0.01 were run, remove them.
%             if ~contains(cleanData.programID,'TR')
%                 cleanData = removeTranslationalStim(cleanData); % a small number of experiments were run with all 3 patterns
%             end
%
%             cleanData = GlassRemoveLowDx(cleanData);
%             cleanData = GlassRemoveLowDots(cleanData);
%         end
%         % cleanData.stimOrder = getStimPresentationOrder(cleanData);
%         % add in anything that's missing from the new cleanData structure.
%         if length(tmp) == 6
%             [cleanData.animal, cleanData.eye, cleanData.programID, cleanData.array, cleanData.date2,cleanData.runNum] = deal(tmp{:});
%             % get date in a format that's useable in figure titles (ex: 09/1/2019 vs 20190901)
%             cleanData.date = convertDate(cleanData.date2);
%             cleanData.reThreshold = '';
%         elseif length(tmp) == 7
%             [cleanData.animal, cleanData.eye, cleanData.programID, cleanData.array, cleanData.date2,cleanData.runNum,cleanData.reThreshold] = deal(tmp{:});
%             cleanData.date = convertDate(cleanData.date2);
%         else
%             [cleanData.animal, cleanData.eye, cleanData.programID, cleanData.array, cleanData.date2] = deal(tmp{:});
%             cleanData.date = cleanData.date2;
%             cleanData.reThreshold = '';
%         end
%
%         if strcmp(cleanData.array, 'nsp1')
%             cleanData.array = 'V1';
%         elseif strcmp(cleanData.array, 'nsp2')
%             cleanData.array = 'V4';
%         end
%
%         cleanData.amap = aMap;
%         %% now do the same for the raw data
%         rawName = strrep(filename,'_thresh35','');
%         rawData = load(rawName);
%                 nChan = 96;
%         tmp = strsplit(filename,'_');
%
%         % extract information about what was run from file name.
%         if length(tmp) == 6
%             [animal, eye, rawData.programID, array, date2,runNum] = deal(tmp{:});
%             % get date in a format that's useable in figure titles (ex: 09/1/2019 vs 20190901)
%             date = convertDate(date2);
%         elseif length(tmp) == 7
%             [animal, eye, rawData.programID, array, date2,runNum,reThreshold] = deal(tmp{:});
%             date = convertDate(date2);
%         else
%             [animal, eye, rawData.programID, array, date2] = deal(tmp{:});
%             date = date2;
%         end
%
%         if strcmp(array, 'nsp1')
%             array = 'V1';
%         elseif strcmp(array, 'nsp2')
%             array = 'V4';
%         end
%
%         if contains(animal,'XX')
%             rawData.filename = reshape(rawData.filename,[numel(rawData.filename),1]);
%             rawData.filename = char(rawData.filename);
%         end
%
%         ndx = 1;
%         for i = 1:size(rawData.filename,1)
%             [type, numDots, dx, coh, sample] = parseGlassName(rawData.filename(i,:));
%
%             %  type: numeric versions of the first letter of the pattern type
%             %     0:  noise
%             %     1: concentric
%             %     2: radial
%             %     3: translational
%             %     100:blank
%             rawData.type(1,ndx)    = type;
%             rawData.numDots(1,ndx) = numDots;
%             rawData.dx(1,ndx)      = dx;
%             rawData.coh(1,ndx)     = coh;
%             rawData.sample(1,ndx)  = sample;
%             ndx = ndx+1;
%         end
%
%         %[numTypes,numDots,numDxs,numCoh,numSamp,types,dots,dxs,coherences,samples] = getGlassParameters(rawData);
%         %%
%         if sum(ismember(rawData.numDots,100)) ~=0 % if 100 and 0.01 were run, remove them.
%             if ~contains(rawData.programID,'TR')
%                 rawData = removeTranslationalStim(rawData); % a small number of experiments were run with all 3 patterns
%             end
%
%             rawData = GlassRemoveLowDx(rawData);
%             rawData = GlassRemoveLowDots(rawData);
%         end
%         % rawData.stimOrder = getStimPresentationOrder(rawData);
%         % add in anything that's missing from the new rawData structure.
%         if length(tmp) == 6
%             [rawData.animal, rawData.eye, rawData.programID, rawData.array, rawData.date2,rawData.runNum] = deal(tmp{:});
%             % get date in a format that's useable in figure titles (ex: 09/1/2019 vs 20190901)
%             rawData.date = convertDate(rawData.date2);
%             rawData.reThreshold = '';
%         elseif length(tmp) == 7
%             [rawData.animal, rawData.eye, rawData.programID, rawData.array, rawData.date2,rawData.runNum,rawData.reThreshold] = deal(tmp{:});
%             rawData.date = convertDate(rawData.date2);
%         else
%             [rawData.animal, rawData.eye, rawData.programID, rawData.array, rawData.date2] = deal(tmp{:});
%             rawData.date = rawData.date2;
%             rawData.reThreshold = '';
%         end
%
%         if strcmp(rawData.array, 'nsp1')
%             rawData.array = 'V1';
%         elseif strcmp(rawData.array, 'nsp2')
%             rawData.array = 'V4';
%         end
%
%         rawData.amap = aMap;
%         %% plot stim vs blank PSTH to look for timing funkiness
%         if location == 0
%             figDir =  sprintf( '/Users/brittany/Dropbox/Figures/%s/%s/%s/PSTH/%s/stimVblank',cleanData.animal, cleanData.programID, cleanData.array,eye);
%
%             if ~exist(figDir,'dir')
%                 mkdir(figDir)
%             end
%         else
%             figDir =  sprintf( '/Local/Users/bushnell/Dropbox/Figures/%s/%s/%s/PSTH/%s/stimVblank',cleanData.animal, cleanData.programID, cleanData.array,eye);
%             if ~exist(figDir,'dir')
%                 mkdir(figDir)
%             end
%         end
%         cd(figDir)
%
%         figure(200);
%         clf
%         pos = get(gcf,'Position');
%         set(gcf,'Position',[pos(1) pos(2) 1200 900])
%         set(gcf,'PaperOrientation','Landscape');
%         for ch = 1:96
%
%             subplot(cleanData.amap,10,10,ch)
%             hold on;
%
%             REcoh = (cleanData.coh == 1);
%             REnoiseCoh = (cleanData.coh == 0);
%             REcohNdx = logical(REcoh + REnoiseCoh);
%
%             blankResp = mean(smoothdata(cleanData.bins((cleanData.numDots == 0), 1:35 ,ch),'gaussian',3))//0.01;
%             stimResp = mean(smoothdata(cleanData.bins((REcohNdx), 1:35 ,ch),'gaussian',3))./0.01;
%             plot(1:35,blankResp,'b','LineWidth',0.5);
%             plot(1:35,stimResp,'b','LineWidth',2);
%
%             REcoh = (rawData.coh == 1);
%             REnoiseCoh = (rawData.coh == 0);
%             REcohNdx = logical(REcoh + REnoiseCoh);
%
%             blankResp = mean(smoothdata(rawData.bins((rawData.numDots == 0), 1:35 ,ch),'gaussian',3))./0.01;
%             stimResp = mean(smoothdata(rawData.bins((REcohNdx), 1:35 ,ch),'gaussian',3))./0.01;
%             plot(1:35,blankResp,'r','LineWidth',0.5);
%             plot(1:35,stimResp,'r','LineWidth',2);
%
%             title(ch)
%             set(gca,'Color','none','tickdir','out','FontAngle','italic','FontSize',10,'XTick',[]);
%
%         end
%         suptitle({(sprintf('%s %s %s %s %s run %s', cleanData.animal, cleanData.eye,cleanData.array, cleanData.programID,cleanData.date,cleanData.runNum));...
%             'blue: cleaned  red: raw'})
%
%         figName = [cleanData.animal,'_',cleanData.eye,'_',cleanData.array,'_',cleanData.programID,'_PSTH_',cleanData.date2,'_',cleanData.runNum,'.pdf'];
%         print(gcf, figName,'-dpdf','-bestfit')
% end