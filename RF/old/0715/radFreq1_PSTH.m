% radFreq1_PSTH
%
%
clc
clear all
close all

files = 'WU_LE_RadFreqLoc2_nsp2_20170707_002.mat';
newName = 'WU_LE_RadFreqLoc2_nsp2_20170707_002_goodCh';

% files = 'WU_RE_RadialFrequency_V4_3day';
% newName = 'WU_RE_RadialFrequency_V4_3day_goodCh';

location = 1;
saveData = 1;
%%
data = load(files);
textName = figTitleName(files);
disp(sprintf('\n analyzing file: %s',textName))

% Find unique x and y locations used
xloc  = unique(data.pos_x);
yloc  = unique(data.pos_y);

for y = 1:length(yloc)
    for x = 1:length(xloc)
        posX(x,y) = xloc(x);
        posY(x,y) = yloc(y);
    end
end

% all of the other unique parameters are stored in the file name and need
% to be parsed out.
for i = 1:length(data.filename)
    [name, rf, rad, mod, ori, sf] = parseRFName(data.filename(i,:));
    
    data.rf(i,1)  = rf;
    data.amplitude(i,1) = mod;
    data.orientation(i,1) = ori;
    data.spatialFrequency(i,1) = sf;
    data.radius(i,1) = rad; %remember, size of RF stimuli is in mean radius
    name  = char(name);
    data.name(i,:) = name;
end

%% Check file, get array map
if location == 1
    % Amfortas
    cd  ~/bushnell-local/Dropbox/ArrayData/WU_ArrayMaps;
elseif location == 0
    % laptop
    cd ~/Dropbox/ArrayData/WU_ArrayMaps
elseif location == 2
    % Zemina
    cd /home/bushnell/ArrayAnalysis/ArrayMaps
end
if ~isempty(strfind(files(1,:),'V4')) || ~isempty(strfind(files(1,:),'nsp2'))
    disp 'data recorded from nsp2, V4 array'
    aMap = arraymap('SN 1024-001795.cmp');
    
elseif ~isempty(strfind(files(1,:),'V1')) || ~isempty(strfind(files(1,:),'nsp1'))
    disp 'data recorded from nsp1, V1/V2 array'
    aMap = arraymap('SN 1024-001790.cmp');
    
else
    error('Error: array ID missing or wrong')
end

data.amap = aMap;
%% PSTHs
figure;
for ch = 1:96
    subplot(10,10,ch);
    hold on;
    plot((mean(squeeze(data.bins((data.radius==100),1:35,ch)),1)./.010),'k','LineWidth',2);
    plot((mean(squeeze(data.bins((data.radius~=100),1:35,ch)),1)./.010),'b','LineWidth',2);
    
    title(ch)
    set(gca,'Color','none','XColor','none')
    ylim([0 inf])
    if ch == 1
    annotation('textbox',...
        [0.37 0.94 0.4 0.038],...
        'String',{'LE PSTH 3 days'},...
        'FontWeight','bold',...
        'FontSize',16,...
        'FontAngle','italic',...
        'EdgeColor','none');
    end

end

%% define good channels

goodCh = [1,0,1,1,1,1,1,1,1,1,1,1,1,0,1,1,1,1,0,1,1,1,1,1,1,0,1,1,1,1,1,1,1,1,1,1,1,1,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,1,1,1,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,1,1,1,1,1,1,0,1,1,1,1,1,1,1,1,0,1,0,0,1];
%goodCh = [1 0 0 1 1 0 1 0 0 0 0 1 0 0 1 1 1 1 0 1 1 1 0 0 0 0 0 0 1 0 1 0 1 1 0 0 0 1 0 0 0 1 1 1 0 1 0 1 1 1 1 1 1 1 0 1 1 1 1 0 1 1 1 1 1 1 1 1 0 0 0 1 0 0 1 0 0 0 0 1 0 1 0 1 0 1 1 1 0 0 0 0 0 0 0 0];

data.goodChannels = goodCh;
%% Save data
if saveData == 1
    if strfind(files,'nsp1')
        if location == 2
            cd /home/bushnell/matFiles/V1/RadialFrequency/goodCh
        elseif location == 1
            cd ~/bushnell-local/Dropbox/ArrayData/matFiles/V1/RadialFrequency/goodCh
        elseif location  == 0
            cd ~/Dropbox/ArrayData/matFiles/V1/RadialFrequency/goodCh
        end
    else
        if location == 2
            cd  /home/bushnell/matFiles/V4/RadialFrequency/goodCh
        elseif location  == 1
            cd ~/bushnell-local/Dropbox/ArrayData/matFiles/V4/RadialFrequency/goodCh
        elseif location  == 0
            cd ~/Dropbox/ArrayData/matFiles/V4/RadialFrequency/goodCh
        end
    end
    
    
    save(newName,'data');
    fprintf('File saved as: %s',newName)
else
    fprintf('FILE NOT SAVED!!')
end