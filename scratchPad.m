fname = 'XT_LE_gratings_nsp1_20181107_004_thresh35_ogcorrupt';
data = load(fname);
location = determineComputer;
amap = getBlackrockArrayMap(fname);
blank = data.spatial_frequency == 0;
grat  = data.spatial_frequency > 0.1;

fnameParts = strsplit(fname,'_');
if contains(fnameParts{4},'nsp1')
    array = 'V1';
else
    array = 'V4';
end

if location == 1 % laca
    if contains(fname,'thresh')
        figDir = sprintf('/users/bushnell/bushnell-local/Dropbox/Figures/%s/Gratings/%s/cleanRawPSTH/cleaned',fnameParts{1},array);
    else
        figDir = sprintf('/users/bushnell/bushnell-local/Dropbox/Figures/%s/Gratings/%s/cleanRawPSTH/raw',fnameParts{1},array);
    end
end

if ~exist(figDir,'dir')
    mkdir(figDir)
end
cd(figDir)

figure(1)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 1200 900])
set(gcf,'PaperOrientation','Landscape');

for ch = 1:96
    subplot(amap,10,10,ch)
    hold on
    
    blankResp = mean(smoothdata(data.bins((data.spatial_frequency == 0), 1:35 ,ch),'gaussian',3))./0.01;
    stimResp = mean(smoothdata(data.bins((data.spatial_frequency > 0.1), 1:35 ,ch),'gaussian',3))./0.01;
    plot(1:35,blankResp,'k','LineWidth',0.5);
    plot(1:35,stimResp,'k','LineWidth',2);
end
s = suptitle(sprintf('%s',fname));
s.Position(2) = s.Position(2) +0.02;
s.Interpreter = 'none';
fname = strrep(fname,'.mat',[]);
figName = [fname,'_','PSTH','.pdf'];
print(gcf, figName,'-dpdf','-bestfit')