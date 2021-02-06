function plotGlass_triplot_allMonk(WUV1, WUV4, WVV1, WVV4, XTV1, XTV4)

%%
WUV1dPRE = getGlassDprimeVectTriplots(WUV1.conRadRE.radBlankDprime,WUV1.conRadRE.conBlankDprime,WUV1.conRadRE.noiseBlankDprime, WUV1.conRadRE.goodCh, WUV1.conRadRE.inStim);
WVV1dPRE = getGlassDprimeVectTriplots(WVV1.conRadRE.radBlankDprime,WVV1.conRadRE.conBlankDprime,WVV1.conRadRE.noiseBlankDprime, WVV1.conRadRE.goodCh, WVV1.conRadRE.inStim);
XTV1dPRE = getGlassDprimeVectTriplots(XTV1.conRadRE.radBlankDprime,XTV1.conRadRE.conBlankDprime,XTV1.conRadRE.noiseBlankDprime, XTV1.conRadRE.goodCh, XTV1.conRadRE.inStim);
v1dRE = cat(1,WUV1dPRE,WVV1dPRE);%,XTV1dPLE);
    
WUV1dPLE = getGlassDprimeVectTriplots(WUV1.conRadLE.radBlankDprime,WUV1.conRadLE.conBlankDprime,WUV1.conRadLE.noiseBlankDprime, WUV1.conRadLE.goodCh, WUV1.conRadLE.inStim);
WVV1dPLE = getGlassDprimeVectTriplots(WVV1.conRadLE.radBlankDprime,WVV1.conRadLE.conBlankDprime,WVV1.conRadLE.noiseBlankDprime, WVV1.conRadLE.goodCh, WVV1.conRadLE.inStim);
XTV1dPLE = getGlassDprimeVectTriplots(XTV1.conRadLE.radBlankDprime,XTV1.conRadLE.conBlankDprime,XTV1.conRadLE.noiseBlankDprime, XTV1.conRadLE.goodCh, XTV1.conRadLE.inStim);
v1dLE = cat(1,WUV1dPLE,WVV1dPLE);%,XTV1dPLE);

WUV4dPRE = getGlassDprimeVectTriplots(WUV4.conRadRE.radBlankDprime,WUV4.conRadRE.conBlankDprime,WUV4.conRadRE.noiseBlankDprime, WUV4.conRadRE.goodCh, WUV4.conRadRE.inStim);
WVV4dPRE = getGlassDprimeVectTriplots(WVV4.conRadRE.radBlankDprime,WVV4.conRadRE.conBlankDprime,WVV4.conRadRE.noiseBlankDprime, WVV4.conRadRE.goodCh, WVV4.conRadRE.inStim);
XTV4dPRE = getGlassDprimeVectTriplots(XTV4.conRadRE.radBlankDprime,XTV4.conRadRE.conBlankDprime,XTV4.conRadRE.noiseBlankDprime, XTV4.conRadRE.goodCh, XTV4.conRadRE.inStim);
v4dRE = cat(1,WUV4dPRE,WVV4dPRE);%,XTV1dPLE);

WUV4dPLE = getGlassDprimeVectTriplots(WUV4.conRadLE.radBlankDprime,WUV4.conRadLE.conBlankDprime,WUV4.conRadLE.noiseBlankDprime, WUV4.conRadLE.goodCh, WUV4.conRadLE.inStim);
WVV4dPLE = getGlassDprimeVectTriplots(WVV4.conRadLE.radBlankDprime,WVV4.conRadLE.conBlankDprime,WVV4.conRadLE.noiseBlankDprime, WVV4.conRadLE.goodCh, WVV4.conRadLE.inStim);
XTV4dPLE = getGlassDprimeVectTriplots(XTV4.conRadLE.radBlankDprime,XTV4.conRadLE.conBlankDprime,XTV4.conRadLE.noiseBlankDprime, XTV4.conRadLE.goodCh, XTV4.conRadLE.inStim);
v4dLE = cat(1,WUV4dPLE,WVV4dPLE);%,XTV1dPLE);
%%
%{
1) set up to get vector sum here
2) make master matrix of all eyes/arrays
3) sort said master matrix by greatest vector sum - make sure to keep the
indices
4) match the vector sum with the color 

If done right, this will give a color gradient that exists across all of
the subplots - not just within the single one.  That will allow us to
specifically compare across them.

%}

allDps = cat(1,v1dLE, v1dRE, v4dLE, v4dRE); 
allDps(:,4) = sqrt(allDps(:,1).^2 + allDps(:,2).^2 + allDps(:,3).^2);
%%
% WUREa = reshape(WUV1dPRE,[1,numel(WUV1dPRE)]);
% WVREa = reshape(WVV1dPRE,[1,numel(WVV1dPRE)]);
% XTREa = reshape(XTV1dPRE,[1,numel(XTV1dPRE)]);
% v1RE = [WUREa, WVREa];%, XTREa];
% 
% WULEa = reshape(WUV1dPLE,[1,numel(WUV1dPLE)]);
% WVLEa = reshape(WVV1dPLE,[1,numel(WVV1dPLE)]);
% XTLEa = reshape(XTV1dPLE,[1,numel(XTV1dPLE)]);
% v1LE = [WULEa, WVLEa];%, XTLEa];
% 
% WUREa = reshape(WUV4dPRE,[1,numel(WUV4dPRE)]);
% WVREa = reshape(WVV4dPRE,[1,numel(WVV4dPRE)]);
% XTREa = reshape(XTV4dPRE,[1,numel(XTV4dPRE)]);
% v4RE = [WUREa, WVREa];%, XTREa];
% 
% WULEa = reshape(WUV4dPLE,[1,numel(WUV4dPLE)]);
% WVLEa = reshape(WVV4dPLE,[1,numel(WVV4dPLE)]);
% XTLEa = reshape(XTV4dPLE,[1,numel(XTV4dPLE)]);
% v4LE = [WULEa, WVLEa];%, XTLEa];
% 
% allDp = [v1RE,v1LE,v4RE,v4LE];
% [allDp,dpNdx] = sort(allDp,'descend');
% dpMax = allDp(1);
% dpMin = allDp(end);
% 

%% setup colorlims
cmap = gray(length(allDp)); 
cmap = flipud(cmap); % make black be highest, white lowest
colormap(cmap)

%%
figure(1)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 900 600]);
set(gcf,'PaperOrientation','landscape')

t = suptitle('Amblyopic dPrimes for each pattern in V1 and V4');
t.Position(2) = t.Position(2) +0.025;
t.FontWeight = 'bold';
t.FontSize = 18;

s = subplot(2,2,1);
hold on
triplotter_stereo_Glass(v1dLE,dpMax)
title(sprintf('FE n: %d',length(v1dLE)))

s.Position(1) = s.Position(1) - 0.05;
s.Position(2) = s.Position(2) - 0.05;
s.Position(3) = s.Position(3) + 0.05;
s.Position(4) = s.Position(4) + 0.05;

s = subplot(2,2,2);
hold on
triplotter_stereo_Glass(v1dRE,dpMax)
title(sprintf('AE n: %d',length(v1dRE)))
s.Position(1) = s.Position(1) - 0.05;
s.Position(2) = s.Position(2) - 0.05;
s.Position(3) = s.Position(3) + 0.05;
s.Position(4) = s.Position(4) + 0.05;

s = subplot(2,2,3);
hold on
triplotter_stereo_Glass(v4dLE,dpMax)
title(sprintf('n: %d',length(v4dLE)))
s.Position(1) = s.Position(1) - 0.05;
s.Position(2) = s.Position(2) - 0.05;
s.Position(3) = s.Position(3) + 0.05;
s.Position(4) = s.Position(4) + 0.05;

s = subplot(2,2,4);
hold on
triplotter_stereo_Glass(v4dRE,dpMax)
title(sprintf('n: %d',length(v4dRE)))
s.Position(1) = s.Position(1) - 0.05;
s.Position(2) = s.Position(2) - 0.05;
s.Position(3) = s.Position(3) + 0.05;
s.Position(4) = s.Position(4) + 0.05;




