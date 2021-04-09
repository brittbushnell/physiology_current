
s = subplot(6,2,1);
hold on
rct = XTv1LEsort(:,1:3);
cmp = XTv1LEsort(:,6:8);
[~,V1LEmax] = max(rct,[],2);
triplotter_GlassWithTr_noCBar(rct,cmp);
triplotter_centerMass(rct,XTv1LEsort(:,4),[1 0 0]);

t = title(sprintf('LE n: %d',sum(XTV1.conRadLE.goodCh & XTV1.conRadLE.inStim & XTV1.trLE.goodCh & XTV1.trLE.inStim)));
t.Position(2) = t.Position(2) +0.07;

clear dps;
% s.Position(1) = s.Position(1) - 0.12;
% s.Position(2) = s.Position(2) - 0.05;
% s.Position(3) = s.Position(3) + 0.06;
% s.Position(4) = s.Position(4) + 0.06;

text(-1.5,0.1,'V1','FontSize',18,'FontWeight','bold')
text(-1.9,1.3,'XT','FontSize',18,'FontWeight','bold')

s = subplot(6,2,2);
hold on
rct = XTv1REsort(:,1:3);
cmp = XTv1REsort(:,6:8);
[~,V1LEmax] = max(rct,[],2);
triplotter_GlassWithTr_noCBar(rct,cmp);
triplotter_centerMass(rct,XTv1LEsort(:,4),[1 0 0]);

t = title(sprintf('RE n: %d',sum(XTV1.conRadRE.goodCh & XTV1.conRadRE.inStim & XTV1.trRE.goodCh & XTV1.trRE.inStim)));
t.Position(2) = t.Position(2) +0.07;

clear dps;
% s.Position(1) = s.Position(1) - 0.25;
% s.Position(2) = s.Position(2) - 0.05;
% s.Position(3) = s.Position(3) + 0.06;
% s.Position(4) = s.Position(4) + 0.06;

s = subplot(6,2,3);
hold on
rct = XTv4LEsort(:,1:3);
cmp = XTv4LEsort(:,6:8);
[~,V1LEmax] = max(rct,[],2);
triplotter_GlassWithTr_noCBar(rct,cmp);
triplotter_centerMass(rct,XTv4LEsort(:,4),[1 0 0]);

t = title(sprintf('LE n: %d',sum(XTV4.conRadLE.goodCh & XTV4.conRadLE.inStim & XTV4.trLE.goodCh & XTV4.trLE.inStim)));
t.Position(2) = t.Position(2) +0.07;

clear dps;
% s.Position(1) = s.Position(1) - 0.12;
% s.Position(2) = s.Position(2) - 0.15;
% s.Position(3) = s.Position(3) + 0.06;
% s.Position(4) = s.Position(4) + 0.06;

text(-1.5,0.1,'V4','FontSize',18,'FontWeight','bold')

s = subplot(6,2,4);
hold on
rct = XTv4REsort(:,1:3);
cmp = XTv4REsort(:,6:8);
[~,V1LEmax] = max(rct,[],2);
triplotter_GlassWithTr_noCBar(rct,cmp);
triplotter_centerMass(rct,XTv4REsort(:,4),[1 0 0]);

t = title(sprintf('RE n: %d',sum(XTV4.conRadRE.goodCh & XTV4.conRadRE.inStim & XTV4.trRE.goodCh & XTV4.trRE.inStim)));
t.Position(2) = t.Position(2) +0.07;

clear dps;
% s.Position(1) = s.Position(1) - 0.25;
% s.Position(2) = s.Position(2) - 0.15;
% s.Position(3) = s.Position(3) + 0.06;
% s.Position(4) = s.Position(4) + 0.06;
%%
s = subplot(6,2,5);
hold on
rct = WUv1LEsort(:,1:3);
cmp = WUv1LEsort(:,6:8);
[~,V1LEmax] = max(rct,[],2);
triplotter_GlassWithTr_noCBar(rct,cmp);
triplotter_centerMass(rct,WUv1LEsort(:,4),[1 0 0]);

t = title(sprintf('LE n: %d',sum(WUV1.conRadLE.goodCh & WUV1.conRadLE.inStim & WUV1.trLE.goodCh & WUV1.trLE.inStim)));
t.Position(2) = t.Position(2) +0.07;

clear dps;
% s.Position(1) = s.Position(1) - 0.12;
% s.Position(2) = s.Position(2) - 0.05;
% s.Position(3) = s.Position(3) + 0.06;
% s.Position(4) = s.Position(4) + 0.06;

text(-1.5,0.1,'V1','FontSize',18,'FontWeight','bold')
text(-1.9,1.3,'WU','FontSize',18,'FontWeight','bold')

s = subplot(6,2,6);
hold on
rct = WUv1REsort(:,1:3);
cmp = WUv1REsort(:,6:8);
[~,V1LEmax] = max(rct,[],2);
triplotter_GlassWithTr_noCBar(rct,cmp);
triplotter_centerMass(rct,WUv1REsort(:,4),[1 0 0]);

t = title(sprintf('RE n: %d',sum(WUV1.conRadRE.goodCh & WUV1.conRadRE.inStim & WUV1.trRE.goodCh & WUV1.trRE.inStim)));
t.Position(2) = t.Position(2) +0.07;

clear dps;
% s.Position(1) = s.Position(1) - 0.25;
% s.Position(2) = s.Position(2) - 0.05;
% s.Position(3) = s.Position(3) + 0.06;
% s.Position(4) = s.Position(4) + 0.06;

s = subplot(6,2,7);
hold on
rct = WUv4LEsort(:,1:3);
cmp = WUv4LEsort(:,6:8);
[~,V1LEmax] = max(rct,[],2);
triplotter_GlassWithTr_noCBar(rct,cmp);
triplotter_centerMass(rct,WUv4LEsort(:,4),[1 0 0]);

t = title(sprintf('LE n: %d',sum(WUV4.conRadLE.goodCh & WUV4.conRadLE.inStim & WUV4.trLE.goodCh & WUV4.trLE.inStim)));
t.Position(2) = t.Position(2) +0.07;

clear dps;
% s.Position(1) = s.Position(1) - 0.12;
% s.Position(2) = s.Position(2) - 0.15;
% s.Position(3) = s.Position(3) + 0.06;
% s.Position(4) = s.Position(4) + 0.06;

text(-1.5,0.1,'V4','FontSize',18,'FontWeight','bold')

s = subplot(6,2,8);
hold on
rct = WUv4REsort(:,1:3);
cmp = WUv4REsort(:,6:8);
[~,V1LEmax] = max(rct,[],2);
triplotter_GlassWithTr_noCBar(rct,cmp);
triplotter_centerMass(rct,WUv4REsort(:,4),[1 0 0]);

t = title(sprintf('RE n: %d',sum(WUV4.conRadRE.goodCh & WUV4.conRadRE.inStim & WUV4.trRE.goodCh & WUV4.trRE.inStim)));
t.Position(2) = t.Position(2) +0.07;

clear dps;
% s.Position(1) = s.Position(1) - 0.25;
% s.Position(2) = s.Position(2) - 0.15;
% s.Position(3) = s.Position(3) + 0.06;
% s.Position(4) = s.Position(4) + 0.06;

s = subplot(6,2,9);
hold on
rct = WVv1LEsort(:,1:3);
cmp = WVv1LEsort(:,6:8);
[~,V1LEmax] = max(rct,[],2);
triplotter_GlassWithTr_noCBar(rct,cmp);
triplotter_centerMass(rct,WVv1LEsort(:,4),[1 0 0]);

t = title(sprintf('LE n: %d',sum(WVV1.conRadLE.goodCh & WVV1.conRadLE.inStim & WVV1.trLE.goodCh & WVV1.trLE.inStim)));
t.Position(2) = t.Position(2) +0.07;

clear dps;
% s.Position(1) = s.Position(1) - 0.12;
% s.Position(2) = s.Position(2) - 0.05;
% s.Position(3) = s.Position(3) + 0.06;
% s.Position(4) = s.Position(4) + 0.06;

text(-1.5,0.1,'V1','FontSize',18,'FontWeight','bold')
text(-1.9,1.3,'WV','FontSize',18,'FontWeight','bold')

s = subplot(6,2,10);
hold on
rct = WVv1REsort(:,1:3);
cmp = WVv1REsort(:,6:8);
[~,V1LEmax] = max(rct,[],2);
triplotter_GlassWithTr_noCBar(rct,cmp);
triplotter_centerMass(rct,WVv1REsort(:,4),[1 0 0]);

t = title(sprintf('RE n: %d',sum(WVV1.conRadRE.goodCh & WVV1.conRadRE.inStim & WVV1.trRE.goodCh & WVV1.trRE.inStim)));
t.Position(2) = t.Position(2) +0.07;

clear dps;
% s.Position(1) = s.Position(1) - 0.25;
% s.Position(2) = s.Position(2) - 0.05;
% s.Position(3) = s.Position(3) + 0.06;
% s.Position(4) = s.Position(4) + 0.06;

s = subplot(6,2,11);
hold on
rct = WVv4LEsort(:,1:3);
cmp = WVv4LEsort(:,6:8);
[~,V1LEmax] = max(rct,[],2);
triplotter_GlassWithTr_noCBar(rct,cmp);
triplotter_centerMass(rct,WVv4LEsort(:,4),[1 0 0]);

t = title(sprintf('LE n: %d',sum(WVV4.conRadLE.goodCh & WVV4.conRadLE.inStim & WVV4.trLE.goodCh & WVV4.trLE.inStim)));
t.Position(2) = t.Position(2) +0.07;

clear dps;
% s.Position(1) = s.Position(1) - 0.12;
% s.Position(2) = s.Position(2) - 0.15;
% s.Position(3) = s.Position(3) + 0.06;
% s.Position(4) = s.Position(4) + 0.06;

text(-1.5,0.1,'V4','FontSize',18,'FontWeight','bold')

s = subplot(6,2,12);
hold on
rct = WVv4REsort(:,1:3);
cmp = WVv4REsort(:,6:8);
[~,V1LEmax] = max(rct,[],2);
triplotter_GlassWithTr_noCBar(rct,cmp);
triplotter_centerMass(rct,WVv4REsort(:,4),[1 0 0]);

t = title(sprintf('RE n: %d',sum(WVV4.conRadRE.goodCh & WVV4.conRadRE.inStim & WVV4.trRE.goodCh & WVV4.trRE.inStim)));
t.Position(2) = t.Position(2) +0.07;

clear dps;
% s.Position(1) = s.Position(1) - 0.25;
% s.Position(2) = s.Position(2) - 0.15;
% s.Position(3) = s.Position(3) + 0.06;
% s.Position(4) = s.Position(4) + 0.06;