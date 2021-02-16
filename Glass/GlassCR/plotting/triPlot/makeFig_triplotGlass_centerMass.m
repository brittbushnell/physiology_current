function makeFig_triplotGlass_centerMass(WUsortDps, WVsortDps, XTsortDps, all3)

cmapWU =  flipud(brewermap(length(WUsortDps),'Blues'));
WUsortDps(:,6:8) = cmapWU; 

cmapWV =  flipud(brewermap(length(WVsortDps),'Reds'));
WVsortDps(:,6:8) = cmapWV; 
%%
WUv1LEsort = WUsortDps(WUsortDps(:,5) == 1,:);
WUv1REsort = WUsortDps(WUsortDps(:,5) == 2,:);
WUv4LEsort = WUsortDps(WUsortDps(:,5) == 3,:);
WUv4REsort = WUsortDps(WUsortDps(:,5) == 4,:);

WVv1LEsort = WVsortDps(WVsortDps(:,5) == 1,:);
WVv1REsort = WVsortDps(WVsortDps(:,5) == 2,:);
WVv4LEsort = WVsortDps(WVsortDps(:,5) == 3,:);
WVv4REsort = WVsortDps(WVsortDps(:,5) == 4,:);

XTv1LEsort = XTsortDps(XTsortDps(:,5) == 1,:);
XTv1REsort = XTsortDps(XTsortDps(:,5) == 2,:);
XTv4LEsort = XTsortDps(XTsortDps(:,5) == 3,:);
XTv4REsort = XTsortDps(XTsortDps(:,5) == 4,:);
%% plot center of mass
% figure(6)
% clf

s = subplot(2,2,1);
hold on

rcdWU = WUv1LEsort(:,1:3);
triplotter_centerMass(rcdWU,WUv1LEsort(:,4),[0 0.02 0.85])

rcdWV = WVv1LEsort(:,1:3);
triplotter_centerMass(rcdWV,WVv1LEsort(:,4),[0.7, 0.02, 0.07])

if all3 == 1
rcdXT = XTv1LEsort(:,1:3); 
triplotter_centerMass(rcdXT,XTv1LEsort(:,4),[0 0 0])
text(-1.39,1.15,'XT','FontSize',20,'FontWeight','bold')
end

t = title('FE','FontSize',20,'FontAngle','italic');
t.Position(2) = t.Position(2) +0.023;
text(-1.4,0.2,'V1','FontSize',20,'FontWeight','bold')

text(-1.4,1,'WU','FontSize',20,'FontWeight','bold','color',[0 0.02 0.85])
text(-1.4,0.85,'WV','FontSize',20,'FontWeight','bold','color',[0.7, 0.02, 0.07])

s.Position(1) = s.Position(1) - 0.078;
s.Position(2) = s.Position(2) - 0.078;
s.Position(3) = s.Position(3)+ 0.085;
s.Position(4) = s.Position(4)+ 0.085;

text(-1,-0.83,'Radial','FontSize',13)
text(0.6,-0.83,'Concentric','FontSize',13)
text(-0.12,0.9,'Dipole','FontSize',13)

s = subplot(2,2,3);
hold on

rcdWU = WUv4LEsort(:,1:3);
triplotter_centerMass(rcdWU,WUv4LEsort(:,4),[0 0.02 0.85])

rcdWV = WVv4LEsort(:,1:3);
triplotter_centerMass(rcdWV,WVv4LEsort(:,4),[0.7, 0.02, 0.07])

if all3 == 1
rcdXT = XTv4LEsort(:,1:3);
triplotter_centerMass(rcdXT,XTv4LEsort(:,4),[0 0 0])
end

text(-1.4,0.2,'V4','FontSize',20,'FontWeight','bold')
s.Position(1) = s.Position(1) - 0.078;
s.Position(2) = s.Position(2) - 0.078;
s.Position(3) = s.Position(3)+ 0.085;
s.Position(4) = s.Position(4)+ 0.085;

text(-1,-0.83,'Radial','FontSize',13)
text(0.6,-0.83,'Concentric','FontSize',13)
text(-0.12,0.9,'Dipole','FontSize',13)
%
s = subplot(2,2,2);
hold on

rcdWU = WUv1REsort(:,1:3);
triplotter_centerMass(rcdWU,WUv1REsort(:,4),[0 0.02 0.85])

rcdWV = WVv1REsort(:,1:3);
triplotter_centerMass(rcdWV,WVv1REsort(:,4),[0.7, 0.02, 0.07])

if all3 == 1
rcdXT = XTv1REsort(:,1:3);
triplotter_centerMass(rcdXT,XTv1REsort(:,4),[0 0 0])
end

t = title('AE','FontSize',20,'FontAngle','italic');
s.Position(2) = s.Position(2) - 0.078;
s.Position(3) = s.Position(3)+ 0.085;
s.Position(4) = s.Position(4)+ 0.085;

text(-1,-0.83,'Radial','FontSize',13)
text(0.6,-0.83,'Concentric','FontSize',13)
text(-0.12,0.9,'Dipole','FontSize',13)

s = subplot(2,2,4);
hold on

rcdWU = WUv4REsort(:,1:3);
triplotter_centerMass(rcdWU,WUv4REsort(:,4),[0 0.02 0.85])

rcdWV = WVv4REsort(:,1:3);
triplotter_centerMass(rcdWV,WVv4REsort(:,4),[0.7, 0.02, 0.07])

if all3 == 1
rcdXT = XTv4REsort(:,1:3);
triplotter_centerMass(rcdXT,XTv4REsort(:,4),[0 0 0])
end

s.Position(2) = s.Position(2) - 0.078;
s.Position(3) = s.Position(3)+ 0.085;
s.Position(4) = s.Position(4)+ 0.085;

text(-1,-0.83,'Radial','FontSize',13)
text(0.6,-0.83,'Concentric','FontSize',13)
text(-0.12,0.9,'Dipole','FontSize',13)