function [gratLE,gratRE] = Glass_gratOriVSglassOri_allParams(glassData)

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

LEglassOri = squeeze(glassLE.prefOri(end,:,:,LEuseCh));
LEglassOri(LEglassOri<0) = LEglassOri(LEglassOri<0)+180;
LEglassOri = reshape(LEglassOri,[1,numel(LEglassOri)]);

REglassOri = squeeze(glassRE.prefOri(end,:,:,REuseCh));
REglassOri(REglassOri<0) = REglassOri(REglassOri<0)+180;
REglassOri = reshape(REglassOri,[1,numel(REglassOri)]);
%%
% in order to plot and do correlations on the glass and gratings data, the
% vectors need to be the same length. When using all 4 parameter options,
% you end up with 4x the data points in Glass orientations as in gratings.
% If you make a matrix that repeats the preferred gratings orientations in
% 4 rows, then reshape it, you end up with a vector that is the same size
% as the Glass dat. The values for each ch are repeated 4x in a row in
% order to match up with the order of the Glass orientations.

LEgratOriRep = [LEgratOri; LEgratOri; LEgratOri; LEgratOri];
LEgratOriRep = reshape(LEgratOriRep,[1, numel(LEgratOriRep)]);  

REgratOriRep = [REgratOri; REgratOri; REgratOri; REgratOri];
REgratOriRep = reshape(REgratOriRep,[1, numel(REgratOriRep)]);  
%%
figure%(1)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1), pos(2), 500, 400],'PaperSize',[6 3.5])

hold on
s = suptitle(sprintf('%s %s preferred orientations in Glass patterns vs gratings all density dx',glassLE.animal,glassLE.array));
s.Position(2) = s.Position(2)+0.02;

subplot(1,2,1)

hold on
if contains(fname,'XT')
    title('LE')
else
    title('FE')
end

scatter(LEgratOriRep,LEglassOri,25,'MarkerFaceColor',[0.2 0.4 1],'MarkerFaceAlpha',0.75,'MarkerEdgeColor','w','MarkerEdgeAlpha',0.75)

plot([0 180],[0 180],'k:')
axis square
xlim([-10 190])
ylim([-10 190])
set(gca,'tickdir','out','XTick',0:90:180,'YTick',0:90:180,'FontAngle','italic','FontSize',10)
xlabel('preferred gratings orientation')
ylabel('preferred Glass orientation')

[rho, pval] = circ_corrcc(LEgratOriRep, LEglassOri);
if pval > 0.05
    text(1,190,sprintf('r = %.2f',rho))
else
    text(1,190,sprintf('r = %.2f*',rho),'FontWeight','bold')
end



subplot(1,2,2)
hold on
if contains(fname,'XT')
    title('RE')
else
    title('AE')
end

axis square

scatter(REgratOriRep,REglassOri,25,'MarkerFaceColor',[1 0 0],'MarkerFaceAlpha',0.75,'MarkerEdgeColor','w','MarkerEdgeAlpha',0.75)

plot([0 180],[0 180],'k:')

xlim([-10 190])
ylim([-10 190])
set(gca,'tickdir','out','XTick',0:90:180,'YTick',0:90:180,'FontAngle','italic','FontSize',10)


[rho, pval] = circ_corrcc(REgratOriRep, REglassOri);
if pval > 0.05
    text(1,190,sprintf('r = %.2f',rho))
else
    text(1,190,sprintf('r = %.2f*',rho),'FontWeight','bold')
end
%
figDir = '/Users/brittany/Dropbox/Thesis/Glass/figures/oriTuning/GlassVgrat';
if~exist(figDir,'dir')
    mkdir(figDir)
end
cd(figDir)

set(gcf,'InvertHardcopy','off','color','w')
figName = [glassRE.animal,'_',glassRE.array,'_prefOriGlassVgrat_allParams','.pdf'];
print(gcf, figName,'-dpdf','-bestfit')