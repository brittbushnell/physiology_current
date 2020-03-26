% Use this program to go through single sessions that threw errors in the
% big program that goes through each session.

clear all
close all
clc
tic
%%
%files = 'XT_RE_GlassCoh_nsp2_20190321_002';
%files = 'XT_LE_GlassCoh_nsp2_20190325_001';

%files = 'WU_LE_Glass_nsp2_20170817_001';
%files = 'WU_RE_Glass_nsp2_20170821_001';

%files = 'WV_LE_GlassCoh_nsp2_20190402_002';
%files = 'WV_RE_glassCoh_nsp2_20190404_003';
%files = 'WV_RE_glassCoh_nsp2_20190404_002';
%files = 'WV_RE_glassCoh_nsp2_20190405_001';

%files = 'WV_LE_glassCohSmall_nsp2_20190425_001';
%files = 'WV_RE_glassCohSmall_nsp2_20190424_001';
% %% V4
% % %WU
% % %AE
% files = {'WU_RE_Glass_nsp2_20170817_X02';...       %4 reps
%     'WU_RE_Glass_nsp2_20170818_002';...       %5 reps
%     'WU_RE_Glass_nsp2_20170818_001';...       %5 reps
%     %FE
%     'WU_LE_Glass_nsp2_20170817_001';...
%     'WU_LE_Glass_nsp2_20170822_001';...       %6 reps
%     'WU_LE_Glass_nsp2_20170821_002';...       %4 reps
%     
%     %WV
%     %AE
%     'WV_RE_glassCoh_nsp2_20190405_001';...   %10 reps
%     'WV_RE_glassCoh_nsp2_20190404_003';...   %10 reps
%     'WV_RE_glassCoh_nsp2_20190404_002';...   %10 reps
%     %FE
%     'WV_LE_GlassCoh_nsp2_20190402_002';...   %10 reps
%     'WV_LE_glassCoh_nsp2_20190403_002';...   %8 reps
%     'WV_LE_glassCoh_nsp2_20190403_001';...   %5 reps
%     'WV_LE_glassCoh_nsp2_20190402_003';...   %4 reps
%     'WV_LE_GlassCoh_nsp2_20190402_004';...   %1 reps
%     
%     %FE smaller diameter stimulus
%     'WV_LE_glassCohSmall_nsp2_20190425_001';...  %10 reps
%     'WV_LE_glassCohSmall_nsp2_20190425_002';...  %5 reps
%     'WV_LE_glassCohSmall_nsp2_20190424_002';...  %4 reps
%     'WV_LE_glassCohSmall_nsp2_20190425_003';...  %2 reps
%     %AE smaller diameter stimulus
%     'WV_RE_glassCohSmall_nsp2_20190424_001';... %10 reps
%     'WV_RE_glassCohSmall_nsp2_20190423_002';... %10 reps
%     'WV_RE_glassCohSmall_nsp2_20190423_001';... %10 reps
%     
%     %XT %%%
%     %RE
%     'XT_RE_GlassCoh_nsp2_20190321_002';...  %15 reps
%     'XT_RE_GlassCoh_nsp2_20190321_003';...  %9 reps
%     'XT_RE_GlassCoh_nsp2_20190322_001';...  %6 reps
%     %LE
%     'XT_LE_GlassCoh_nsp2_20190324_005';...  %4 reps
%     'XT_LE_GlassCoh_nsp2_20190325_001';...  %15 reps
%     'XT_LE_GlassCoh_nsp2_20190325_002';...  %9 reps
%     'XT_LE_GlassCoh_nsp2_20190325_004';...  %2 reps
%     
%     %RE high coh only
%     'XT_RE_Glass_nsp2_20190123_008';...   %17 reps
%     'XT_RE_Glass_nsp2_20190124_005';...   %15 reps
%     'XT_RE_Glass_nsp2_20190123_006';...   %14 reps
%     'XT_RE_Glass_nsp2_20190123_005';...   %8 reps
%     'XT_RE_Glass_nsp2_20190123_003';...  %4 reps
%     %LE high coh only
%     'XT_LE_Glass_nsp2_20190123_001';...   %15 reps
%     'XT_LE_Glass_nsp2_20190124_002';...   %15 reps
%     'XT_LE_Glass_nsp2_20190123_002';...   %15 reps
%     'XT_LE_Glass_nsp2_20190124_001';...   %9 reps
%     'XT_LE_Glass_nsp2_20190124_003'};   %6 reps
%% V1
% %WU
% %AE
% files = {'WU_RE_Glass_nsp1_20170817_X02';...       %4 reps
%     %'WU_RE_Glass_nsp1_20170818_002';...       %5 reps error when parsing
%     'WU_RE_Glass_nsp1_20170818_001';...       %5 reps
%     %FE
%     'WU_LE_Glass_nsp1_20170817_001';...
%     'WU_LE_Glass_nsp1_20170822_001';...       %6 reps
%     'WU_LE_Glass_nsp1_20170821_002';...       %4 reps
%     
%     %WV
%     %AE
%     'WV_RE_glassCoh_nsp1_20190405_001';...   %10 reps
%     'WV_RE_glassCoh_nsp1_20190404_003';...   %10 reps
%     'WV_RE_glassCoh_nsp1_20190404_002';...   %10 reps
%     %FE
%     'WV_LE_GlassCoh_nsp1_20190402_002';...   %10 reps
%     'WV_LE_glassCoh_nsp1_20190403_002';...   %8 reps
%     'WV_LE_glassCoh_nsp1_20190403_001';...   %5 reps
%     'WV_LE_glassCoh_nsp1_20190402_003';...   %4 reps
%     'WV_LE_GlassCoh_nsp1_20190402_004';...   %1 reps
%     
%     %FE smaller diameter stimulus
%     'WV_LE_glassCohSmall_nsp1_20190425_001';...  %10 reps
%     'WV_LE_glassCohSmall_nsp1_20190425_002';...  %5 reps
%     'WV_LE_glassCohSmall_nsp1_20190424_002';...  %4 reps
%     'WV_LE_glassCohSmall_nsp1_20190425_003';...  %2 reps
%     %AE smaller diameter stimulus
%     'WV_RE_glassCohSmall_nsp1_20190424_001';... %10 reps
%     'WV_RE_glassCohSmall_nsp1_20190423_002';... %10 reps
%     'WV_RE_glassCohSmall_nsp1_20190423_001';... %10 reps
%     
%     %XT %%%
%     %RE
%     'XT_RE_GlassCoh_nsp1_20190321_002';...  %15 reps
%     'XT_RE_GlassCoh_nsp1_20190321_003';...  %9 reps
%     'XT_RE_GlassCoh_nsp1_20190322_001';...  %6 reps
%     %LE
%     'XT_LE_GlassCoh_nsp1_20190324_005';...  %4 reps
%     'XT_LE_GlassCoh_nsp1_20190325_001';...  %15 reps
%     'XT_LE_GlassCoh_nsp1_20190325_002';...  %9 reps
%     'XT_LE_GlassCoh_nsp1_20190325_004';...  %2 reps
%     
%     %RE high coh only
%     'XT_RE_Glass_nsp1_20190123_008';...   %17 reps
%     'XT_RE_Glass_nsp1_20190124_005';...   %15 reps
%     'XT_RE_Glass_nsp1_20190123_006';...   %14 reps
%     'XT_RE_Glass_nsp1_20190123_005';...   %8 reps
%     'XT_RE_Glass_nsp1_20190123_003';...  %4 reps
%     %LE high coh only
%     'XT_LE_Glass_nsp1_20190123_001';...   %15 reps
%     'XT_LE_Glass_nsp1_20190124_002';...   %15 reps
%     'XT_LE_Glass_nsp1_20190123_002';...   %15 reps
%     'XT_LE_Glass_nsp1_20190124_001';...   %9 reps
%     'XT_LE_Glass_nsp1_20190124_003'};   %6 reps
%%
% files = {'WU_RE_Glass_nsp2_20170818_002'};...
%     'WU_LE_Glass_nsp2_20170817_001'};...
% files = {'WV_RE_glassCoh_nsp2_20190405_001';...
%          'WV_LE_GlassCoh_nsp2_20190402_002';...
%          'XT_LE_GlassCoh_nsp2_20190325_001';...
%          'XT_RE_GlassCoh_nsp2_20190322_001'};
%% merged files
files = {
%     'WU_RE_Glass_nsp2_20170818_all';...
%     'WV_RE_glassCoh_nsp2_20190404_all';...
%     'WV_LE_GlassCoh_nsp2_20190402_all';...
%     'WV_LE_glassCoh_nsp2_20190403_all';...
%     'WV_LE_glassCohSmall_nsp2_20190425_all';...
%     'WV_RE_glassCohSmall_nsp2_20190423_all';...
%     'XT_RE_GlassCoh_nsp2_20190321_all';...
%     'XT_LE_GlassCoh_nsp2_20190325_all';...
%     'XT_RE_Glass_nsp2_20190123_all';...
%     'XT_LE_Glass_nsp2_20190123_all';...
%     'XT_LE_Glass_nsp2_20190124_all';    
% 
%     % V1
%     'WV_RE_glassCoh_nsp1_20190404_all';...
%     'WV_LE_GlassCoh_nsp1_20190402_all';...
%     'WV_LE_glassCoh_nsp1_20190403_all';...
%     'WV_LE_glassCohSmall_nsp1_20190425_all';...
%     'WV_RE_glassCohSmall_nsp1_20190423_all';...
%     'XT_RE_GlassCoh_nsp1_20190321_all';...
%     'XT_LE_GlassCoh_nsp1_20190325_all';...
%     'XT_RE_Glass_nsp1_20190123_all';...
%     'XT_LE_Glass_nsp1_20190123_all';...
%     'XT_LE_Glass_nsp1_20190124_all';

% XX
'XX_LE_Glass_nsp1_20200210_all';
'XX_LE_Glass_nsp2_20200210_all';
'XX_RE_Glass_nsp1_20200211_all';
'XX_RE_Glass_nsp2_20200211_all';
};
%%
nameEnd = 'raw';
%%

startMean = 5;
endMean = 15;
startBin = 1;
endBin = 35;

numBoot = 2000;
%%
aMap = getBlackrockArrayMap(files(1,:));
location = determineComputer;
failedFiles = {};
failNdx = 1;
for fi = 1:size(files,1)
    %% Get basic information about experiments
    %try
        filename = files{fi};
        dataT = load(filename);
        
        nChan = 96;
        dataT.amap = aMap;
        tmp = strsplit(filename,'_');
        
        % extract information about what was run from file name.
        if length(tmp) == 6
            [dataT.animal, dataT.eye, dataT.programID, dataT.array, dataT.date2,dataT.runNum] = deal(tmp{:});
            % get date in a format that's useable in figure titles (ex: 09/1/2019 vs 20190901)
            dataT.date = convertDate(dataT.date2);
            oneDay = 1;
        else
            [dataT.animal, dataT.eye, dataT.programID, dataT.array, dataT.date2] = deal(tmp{:});
            dataT.date = dataT.date2;
            oneDay = 0;
        end
        
        if strcmp(dataT.array, 'nsp1')
            dataT.array = 'V1';
        elseif strcmp(dataT.array, 'nsp2')
            dataT.array = 'V4';
        end
        
        if contains(dataT.animal,'XX')
            dataT.filename = reshape(dataT.filename,[numel(dataT.filename),1]);
            dataT.filename = char(dataT.filename);
        end
        
        ndx = 1;
        for i = 1:size(dataT.filename,1)
%             if contains(filename,'WU')
%                 wflag = 1;
%             else
%                 wflag = 0;
%             end
            [type, numDots, dx, coh, sample] = parseGlassName(dataT.filename(i,:),oneDay);
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
        
        [numTypes,numDots,numDxs,numCoh,numSamp,types,dots,dxs,coherences,samples] = getGlassParameters(dataT);
        
        dataT.stimOrder = getStimPresentationOrder(dataT);
        %%
        if contains(filename,'WU') % remove all the extra parameters from WU's files.
            dataT = removeTranslationalStim(dataT);
            dataT = GlassRemoveLowDx(dataT);
            dataT = GlassRemoveLowDots(dataT);
        end
        
        % add in anything that's missing from the new cleanData structure.
        dataT.amap = aMap;
        dataT.date2 = dataT.date2;
        %%
        if location == 1
            outputDir =  sprintf('~/bushnell-local/Dropbox/ArrayData/matFiles/%s/Glass/Parsed/',dataT.array);
        elseif location == 0
            outputDir =  sprintf('~/Dropbox/ArrayData/matFiles/%s/Glass/Parsed/',dataT.array);
        end
        %% make structures for each eye and save .mat file
        
        if contains(filename,'LE')
            data.LE = dataT;
            data.RE = [];
        else
            data.RE = dataT;
            data.LE = [];
        end
        
        saveName = [outputDir filename '_' nameEnd '.mat'];
        save(saveName,'data');
        fprintf('%s saved\n', saveName)
%     catch ME
%         fprintf('%s did not work. \nError message: %s \n',filename,ME.message)
%         failedFiles{failNdx} = filename;
%         failedME{failNdx} = ME;
%         failNdx = failNdx+1;
%     end
end
failedFiles
toc