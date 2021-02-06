function [] = triplotter_Glass_BExArrays_optimalForPattern(V1data,V4data)
location = determineComputer;

if location == 1
    figDir =  sprintf('~/bushnell-local/Dropbox/Figures/%s/%s/',V1data.conRadRE.animal, V1data.conRadRE.programID);
elseif location == 0
    figDir =  sprintf('~/Dropbox/Figures/%s/%s/',V1data.conRadRE.animal, V1data.conRadRE.programID);
end

if ~exist(figDir,'dir')
    mkdir(figDir)
end
cd(figDir)
%% to do in this version:
%{
DONE:
1) V1 and V4  
2) limit everything to good ch and in stim 
3) plot the dashed lines for each subsection

NOT DONE: too difficult
4) use inpolygon to determine how many points fall within the different sections
    - make 4 sections: one at/around the center then the others at the three subareas for the different stimuli.
%}
%% 
LEv1 = V1data.conRadLE;
REv1 = V1data.conRadRE;
LEv4 = V4data.conRadLE;
REv4 = V4data.conRadRE;

radDps1L = abs(squeeze(LEv1.radBlankDprime(end,:,:,:)));
conDps1L = abs(squeeze(LEv1.conBlankDprime(end,:,:,:)));
nosDps1L = abs(squeeze(LEv1.noiseBlankDprime(1,:,:,:)));

radDps1R = abs(squeeze(REv1.radBlankDprime(end,:,:,:)));
conDps1R = abs(squeeze(REv1.conBlankDprime(end,:,:,:)));
nosDps1R = abs(squeeze(REv1.noiseBlankDprime(1,:,:,:)));

radDps4L = abs(squeeze(LEv4.radBlankDprime(end,:,:,:)));
conDps4L = abs(squeeze(LEv4.conBlankDprime(end,:,:,:)));
nosDps4L = abs(squeeze(LEv4.noiseBlankDprime(1,:,:,:)));

radDps4R = abs(squeeze(REv4.radBlankDprime(end,:,:,:)));
conDps4R = abs(squeeze(REv4.conBlankDprime(end,:,:,:)));
nosDps4R = abs(squeeze(REv4.noiseBlankDprime(1,:,:,:)));
%%
% rDp 96x4 - each column is a dt,dx. 
% For each pattern we find the dt,dx that gives the highest d' and use that
% stimulus in the triplot - that means we're choosing the best for each
% pattern and channel to compare against. 
rDp1L = squeeze([squeeze(radDps1L(1,1,:)),squeeze(radDps1L(1,2,:)),squeeze(radDps1L(2,1,:)),squeeze(radDps1L(2,2,:))]); 
rDp1L = max(rDp1L');
rDp1L = rDp1L(LEv1.goodCh == 1 & LEv1.inStim == 1);
rDp1L = rDp1L';

cDp1L = squeeze([squeeze(conDps1L(1,1,:)),squeeze(conDps1L(1,2,:)),squeeze(conDps1L(2,1,:)),squeeze(conDps1L(2,2,:))]);
cDp1L = max(cDp1L');
cDp1L = cDp1L(LEv1.goodCh == 1 & LEv1.inStim == 1);
cDp1L = cDp1L';

nDp1L = squeeze([squeeze(nosDps1L(1,1,:)),squeeze(nosDps1L(1,2,:)),squeeze(nosDps1L(2,1,:)),squeeze(nosDps1L(2,2,:))]);
nDp1L = max(nDp1L');
nDp1L = nDp1L(LEv1.goodCh == 1 & LEv1.inStim == 1);
nDp1L = nDp1L';

rDp1R = squeeze([squeeze(radDps1R(1,1,:)),squeeze(radDps1R(1,2,:)),squeeze(radDps1R(2,1,:)),squeeze(radDps1R(2,2,:))]); 
rDp1R = max(rDp1R');
rDp1R = rDp1R(REv1.goodCh == 1 & REv1.inStim == 1);
rDp1R = rDp1R';

cDp1R = squeeze([squeeze(conDps1R(1,1,:)),squeeze(conDps1R(1,2,:)),squeeze(conDps1R(2,1,:)),squeeze(conDps1R(2,2,:))]);
cDp1R = max(cDp1R');
cDp1R = cDp1R(REv1.goodCh == 1 & REv1.inStim == 1);
cDp1R = cDp1R';

nDp1R = squeeze([squeeze(nosDps1R(1,1,:)),squeeze(nosDps1R(1,2,:)),squeeze(nosDps1R(2,1,:)),squeeze(nosDps1R(2,2,:))]);
nDp1R = max(nDp1R');
nDp1R = nDp1R(REv1.goodCh == 1 & REv1.inStim == 1);
nDp1R = nDp1R';

rDp4L = squeeze([squeeze(radDps4L(1,1,:)),squeeze(radDps4L(1,2,:)),squeeze(radDps4L(2,1,:)),squeeze(radDps4L(2,2,:))]); 
rDp4L = max(rDp4L');
rDp4L = rDp4L(LEv4.goodCh == 1 & LEv4.inStim == 1);
rDp4L = rDp4L';

cDp4L = squeeze([squeeze(conDps4L(1,1,:)),squeeze(conDps4L(1,2,:)),squeeze(conDps4L(2,1,:)),squeeze(conDps4L(2,2,:))]);
cDp4L = max(cDp4L');
cDp4L = cDp4L(LEv4.goodCh == 1 & LEv4.inStim == 1);
cDp4L = cDp4L';

nDp4L = squeeze([squeeze(nosDps4L(1,1,:)),squeeze(nosDps4L(1,2,:)),squeeze(nosDps4L(2,1,:)),squeeze(nosDps4L(2,2,:))]);
nDp4L = max(nDp4L');
nDp4L = nDp4L(LEv4.goodCh == 1 & LEv4.inStim == 1);
nDp4L = nDp4L';

rDp4R = squeeze([squeeze(radDps4R(1,1,:)),squeeze(radDps4R(1,2,:)),squeeze(radDps4R(2,1,:)),squeeze(radDps4R(2,2,:))]); 
rDp4R = max(rDp4R');
rDp4R = rDp4R(REv4.goodCh == 1 & REv4.inStim == 1);
rDp4R = rDp4R';

cDp4R = squeeze([squeeze(conDps4R(1,1,:)),squeeze(conDps4R(1,2,:)),squeeze(conDps4R(2,1,:)),squeeze(conDps4R(2,2,:))]);
cDp4R = max(cDp4R');
cDp4R = cDp4R(REv4.goodCh == 1 & REv4.inStim == 1);
cDp4R = cDp4R';

nDp4R = squeeze([squeeze(nosDps4R(1,1,:)),squeeze(nosDps4R(1,2,:)),squeeze(nosDps4R(2,1,:)),squeeze(nosDps4R(2,2,:))]);
nDp4R = max(nDp4R');
nDp4R = nDp4R(REv4.goodCh == 1 & REv4.inStim == 1);
nDp4R = nDp4R';
%% get max d' across everything
allDp = [rDp1L; cDp1L; nDp1L;...
          rDp1R; cDp1R; nDp1R;...
          rDp4L; cDp4L; nDp4L;...
          rDp4R; cDp4R; nDp4R];

grayMax = max(allDp); 
%% 
figure%(2)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 900 700]);
set(gcf,'PaperOrientation','landscape')

s = suptitle(sprintf('%s stimulus vs blank dPrime at 100%% coherence best density/dx for each pattern',LEv1.animal));
s.Position(2) = s.Position(2) +0.025;
s.FontWeight = 'bold';
s.FontSize = 18;

s = subplot(2,2,1);       
dps = [rDp1L,cDp1L,nDp1L];

triplotter_stereo_Glass(dps,grayMax);

if contains(LEv1.animal,'XT')
    title(sprintf('LE n: %d',sum(LEv1.goodCh)))
else
    title(sprintf('FE n: %d',sum(LEv1.goodCh)))
end
clear dps;
s.Position(1) = s.Position(1) - 0.01;
s.Position(2) = s.Position(2) - 0.075;
s.Position(3) = s.Position(3) + 0.02;
s.Position(4) = s.Position(4) + 0.02;

text(-1.5,0.1,'V1','FontSize',22,'FontWeight','bold')

s = subplot(2,2,2);       
dps = [rDp1R,cDp1R,nDp1R];

triplotter_stereo_Glass(dps,grayMax);

if contains(REv1.animal,'XT')
    title(sprintf('RE n: %d',sum(REv1.goodCh)))
else
    title(sprintf('AE n: %d',sum(REv1.goodCh)))
end
clear dps;
s.Position(1) = s.Position(1) + 0.01;
s.Position(2) = s.Position(2) - 0.075;
s.Position(3) = s.Position(3) + 0.02;
s.Position(4) = s.Position(4) + 0.02;

s = subplot(2,2,3);       
dps = [rDp4L,cDp4L,nDp4L];

triplotter_stereo_Glass(dps,grayMax);

if contains(LEv4.animal,'XT')
    title(sprintf('LE n: %d',sum(LEv4.goodCh)))
else
    title(sprintf('FE n: %d',sum(LEv4.goodCh)))
end
clear dps;
s.Position(1) = s.Position(1) - 0.01;
s.Position(3) = s.Position(3) + 0.02;
s.Position(4) = s.Position(4) + 0.02;
text(-1.5,0.1,'V4','FontSize',22,'FontWeight','bold')

s = subplot(2,2,4);       
dps = [rDp4R,cDp4R,nDp4R];

triplotter_stereo_Glass(dps,grayMax);

if contains(REv4.animal,'XT')
    title(sprintf('RE n: %d',sum(REv4.goodCh)))
else
    title(sprintf('AE n: %d',sum(REv4.goodCh)))
end
s.Position(1) = s.Position(1) + 0.01;
s.Position(3) = s.Position(3) + 0.02;
s.Position(4) = s.Position(4) + 0.02;
%
figName = [LEv1.animal,'_BE_bothArrays_triplot_bestDtDx'];
set(gca,'color','none')
% set(gcf,'InvertHardCopy','off')
print(gcf, figName,'-dpdf','-bestfit')