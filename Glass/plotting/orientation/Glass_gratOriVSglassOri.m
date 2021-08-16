function [gratLE,gratRE] = Glass_gratOriVSglassOri(glassData)

%% use for testing/debugging
% glassData = WUV4;

%%
glassLE = glassData.trLE;
glassRE = glassData.trRE;

%% Get gratings data
if contains(glassLE.array,'V1')
    array = 'nsp1';
else
    array = 'nsp2';
end

cd '/Users/brittany/Dropbox/ArrayData/matFiles/ori_pref';

gFiles = dir(pwd);

for i = 3:size(gFiles,1)
    fname =  gFiles(i:end,:).name;
    if contains(fname,glassLE.animal) && contains(fname, array) && contains(fname,'LE')
        LEgratFile = fname;
    elseif contains(fname,glassLE.animal) && contains(fname, array) && contains(fname,'RE')
        REgratFile = fname;
    end
end

gratRE = load(REgratFile);
gratLE = load(LEgratFile);
%%

LEuseCh = find(glassLE.goodCh & glassLE.inStim & gratLE.good_ch);
REuseCh = find(glassRE.goodCh & glassRE.inStim & gratRE.good_ch);

LEgratOri = gratLE.ori_pref(LEuseCh);
REgratOri = gratRE.ori_pref(REuseCh);

LEglassOri = glassLE.prefParamsPrefOri(LEuseCh);
LEglassOri(isnan(LEglassOri)) = [];
REglassOri = glassRE.prefParamsPrefOri(REuseCh);
REglassOri(isnan(REglassOri)) = [];

figure%(1)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1), pos(2), 500, 400],'PaperSize',[6.5 4])

hold on
s = suptitle(sprintf('%s %s preferred orientations in Glass patterns vs gratings preferred density and dx',glassLE.animal,glassLE.array));
s.Position(2) = s.Position(2)+0.02;

subplot(1,2,1)

hold on
if contains(fname,'XT')
    t = title('LE');
%     t.Position(2) = t.Position(2) +0.025;
else
    t = title('FE');
%     t.Position(2) = t.Position(2) +0.025;
end

axis square

scatter(LEgratOri,LEglassOri,60,'MarkerFaceColor',[0.2 0.4 1],'MarkerFaceAlpha',0.75,'MarkerEdgeColor','w','MarkerEdgeAlpha',0.75)
plot([0 180],[0 180],'k:')

xlim([-10 190])
ylim([-10 190])
set(gca,'tickdir','out','XTick',0:30:180,'YTick',0:30:180,'XTickLabelRotation',45)
xlabel('preferred gratings orientation')
ylabel('preferred Glass orientation')

[rho pval] = circ_corrcc(LEgratOri, LEglassOri);
if pval > 0.05
    text(1,190,sprintf('r = %.2f',rho))
else
    text(1,190,sprintf('r = %.2f*',rho),'FontWeight','bold')
end
clear pval

subplot(1,2,2)
hold on
if contains(fname,'XT')
    title('RE')
else
    title('AE')
end

axis square

scatter(REgratOri,REglassOri,60,'MarkerFaceColor',[1 0 0],'MarkerFaceAlpha',0.75,'MarkerEdgeColor','w','MarkerEdgeAlpha',0.75)
plot([0 180],[0 180],'k:')

xlim([-10 190])
ylim([-10 190])
set(gca,'tickdir','out','XTick',0:30:180,'YTick',0:30:180,'XTickLabelRotation',45)
xlabel('preferred gratings orientation')
ylabel('preferred Glass orientation')

[rho pval] = circ_corrcc(REgratOri, REglassOri)
if pval > 0.05
    text(1,190,sprintf('r = %.2f',rho))
else
    text(1,190,sprintf('r = %.2f*',rho),'FontWeight','bold')
end

figDir = '/Users/brittany/Dropbox/Thesis/Glass/figures/oriTuning/GlassVgrat';
if~exist(figDir,'dir')
    mkdir(figDir)
end
cd(figDir)

set(gcf,'InvertHardcopy','off','color','w')
figName = [glassRE.animal,'_',glassRE.array,'_prefOriGlassVgrat','.pdf'];
print(gcf, figName,'-dpdf','-bestfit')