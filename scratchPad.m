%%
close all

% load('WU_LE_Glass_nsp1_Aug2017_all_thresh35_info3_goodRuns_dPrime');
% V1data = data;

%%
V1rcdLE = getGlassDprimeVectTriplots(V1data.conRadLE.radBlankDprime,V1data.conRadLE.conBlankDprime,V1data.conRadLE.noiseBlankDprime, V1data.conRadLE.goodCh, V1data.conRadLE.inStim);
V1vSumLE = sqrt(V1rcdLE(:,1).^2 + V1rcdLE(:,2).^2 + V1rcdLE(:,3).^2);

V1rcdRE = getGlassDprimeVectTriplots(V1data.conRadRE.radBlankDprime,V1data.conRadRE.conBlankDprime,V1data.conRadRE.noiseBlankDprime, V1data.conRadRE.goodCh, V1data.conRadRE.inStim);
V1vSumRE = sqrt(V1rcdRE(:,1).^2 + V1rcdRE(:,2).^2 + V1rcdRE(:,3).^2);
%%
useCh = V1data.conRadLE.goodCh & V1data.conRadLE.inStim;
V1radLE = squeeze(V1data.conRadLE.radBlankDprime(end,:,:,useCh));
V1conLE = squeeze(V1data.conRadLE.conBlankDprime(end,:,:,useCh));
V1nozLE = squeeze(V1data.conRadLE.noiseBlankDprime(1,:,:,useCh));
clear useCh;

useCh = V1data.conRadRE.goodCh & V1data.conRadRE.inStim;
V1radRE = squeeze(V1data.conRadRE.radBlankDprime(end,:,:,useCh));
V1conRE = squeeze(V1data.conRadRE.conBlankDprime(end,:,:,useCh));
V1nozRE = squeeze(V1data.conRadRE.noiseBlankDprime(1,:,:,useCh));
clear useCh;
for i = 1%:10
    %%
V1comPermLE = GlassCenterOfTriplotMass_permutations(V1radLE,V1conLE,V1nozLE);
V1vSumPermLE = sqrt(V1comPermLE(:,1).^2 + V1comPermLE(:,2).^2 + V1comPermLE(:,3).^2);

V1comPermRE = GlassCenterOfTriplotMass_permutations(V1radRE,V1conRE,V1nozRE);
V1vSumPermRE = sqrt(V1comPermRE(:,1).^2 + V1comPermRE(:,2).^2 + V1comPermRE(:,3).^2);
%%
figure%(1) 
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 600 1100]);

subplot(4,2,1)
hold on

cmap = zeros(size(V1comPermLE,1),3)+0.5;
triplotter_Glass_noCBar(V1comPermLE,cmap);
triplotter_centerMass(V1comPermLE,V1vSumPermLE,[1 0 0]);
title('Permuted CoM')
text(-1.5,0.3,'V1 LE','FontSize',18,'FontWeight','bold')


subplot(4,2,2)

hold on
cmap = zeros(size(V1rcdLE,1),3)+0.5;
triplotter_Glass_noCBar(V1rcdLE,cmap);
triplotter_centerMass(V1rcdLE,V1vSumLE,[1 0 0]);
title('Measured d'' and CoM')

subplot(4,2,3)
hold on
cmap = zeros(size(V1comPermRE,1),3)+0.5;
triplotter_Glass_noCBar(V1comPermRE,cmap);
triplotter_centerMass(V1comPermRE,V1vSumPermRE,[1 0 0]);
text(-1.5,0.3,'V1 RE','FontSize',18,'FontWeight','bold')


subplot(4,2,4)
hold on
cmap = zeros(size(V1rcdRE,1),3)+0.5;
triplotter_Glass_noCBar(V1rcdRE,cmap);
triplotter_centerMass(V1rcdRE,V1vSumRE,[1 0 0]);
%% 
end
%% 
% figure(2)
% clf
% 
% subplot(3,2,1)
% title('permuted d'' values')
% hold on
% histogram(V1comPermLE(:,1),'Normalization','probability',...
%     'FaceColor',[0.5 0.5 0.5],'EdgeColor','w')
% % xlim([-0.25 0.25])
% ylim([0 0.5])
% set(gca,'layer','top','tickdir','out')
% 
% subplot(3,2,3)
% hold on
% histogram(V1comPermLE(:,2),'Normalization','probability',...
%     'FaceColor',[0.5 0.5 0.5],'EdgeColor','w')
% % xlim([-0.25 0.25])
% ylim([0 0.5])
% set(gca,'layer','top','tickdir','out')
% 
% subplot(3,2,5)
% hold on
% histogram(V1comPermLE(:,3),'Normalization','probability',...
%     'FaceColor',[0.5 0.5 0.5],'EdgeColor','w')
% % xlim([-0.25 0.25])
% ylim([0 0.5])
% set(gca,'layer','top','tickdir','out')
% %%
% 
% subplot(3,2,2)
% title('measured d'' values')
% hold on
% histogram(V1dataLE(:,1),'Normalization','probability',...
%     'FaceColor',[0.5 0.5 0.5],'EdgeColor','w')
% % xlim([-0.25 0.25])
% ylim([0 0.5])
% set(gca,'layer','top','tickdir','out')
% 
% subplot(3,2,4)
% hold on
% histogram(V1dataLE(:,2),'Normalization','probability',...
%     'FaceColor',[0.5 0.5 0.5],'EdgeColor','w')
% % xlim([-0.25 0.25])
% ylim([0 0.5])
% set(gca,'layer','top','tickdir','out')
% 
% subplot(3,2,6)
% hold on
% histogram(V1dataLE(:,3),'Normalization','probability',...
%     'FaceColor',[0.5 0.5 0.5],'EdgeColor','w')
% % xlim([-0.25 0.25])
% ylim([0 0.5])
% set(gca,'layer','top','tickdir','out')
% 
