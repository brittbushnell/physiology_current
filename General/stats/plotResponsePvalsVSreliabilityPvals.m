function plotResponsePvalsVSreliabilityPvals(responsePvals,reliabilityPvals)
%
% This function will plot the pvalues from the responsivity permutation
% test on the x axis, and the split half correlation on the y axis.
% Channels that fall within the gray zone are not significant for either
% metric and should be excluded for all subsequent analyses. Numbers at the
% bottom left of each section indicates the number of data points that lie
% within that square. 
%
% Brittany Bushnell 9/24/2020
%% determine how many channels fall within each subsection of the figure
%    1 | 2 | 3
%   ----------- 
%    4 | 5 | 6
%   -----------
%    7 | 8 | 9


n1 = sum((responsePvals<=0.05 & reliabilityPvals>=0.95));
n2 = sum((responsePvals>0.05 & responsePvals<0.95 & reliabilityPvals>=0.95));
n3 = sum((responsePvals>=0.95 & reliabilityPvals>=0.95));

n4 = sum((responsePvals<=0.05 & reliabilityPvals>0.05 & reliabilityPvals<0.95));
n5 = sum((responsePvals>0.05 & responsePvals<0.95 &  reliabilityPvals>0.05 & reliabilityPvals<0.95));
n6 = sum((responsePvals>=0.95 &  reliabilityPvals>0.05 & reliabilityPvals<0.95));

n7 = sum((responsePvals<=0.05 & reliabilityPvals<=0.05));
n8 = sum((responsePvals>0.05 & responsePvals<0.95 & reliabilityPvals<=0.05));
n9 = sum((responsePvals>=0.95 & reliabilityPvals<=0.05));
%%
figure(2)
clf
hold on
rectangle('Position',[0.05 0.05 0.9 1.3],'FaceColor',[0.8 0.8 0.8],'EdgeColor',[0.8 0.8 0.8])

plot([-0.1 1.1], [0.05 0.05], '--b')
plot([-0.1 1.1], [0.95 0.95], '--b')
plot([0.05 0.05], [-0.1 1.1], '--b')
plot([0.95 0.95], [-0.1 1.1], '--b')

plot(responsePvals,reliabilityPvals,'o','MarkerFaceColor',[0.2 0.2 0.2],'MarkerEdgeColor',[0.2 0.2 0.2])
ylim([-0.05 1.05])
xlim([-0.05 1.05])

text(-0.03, 0.97, sprintf('n = %d',n1))
text(0.07, 0.97, sprintf('n = %d',n2))
text(0.97, 0.97, sprintf('n = %d',n3))

text(-0.03, 0.07, sprintf('n = %d',n4))
text(0.07, 0.07, sprintf('n = %d',n5))
text(0.97, 0.07, sprintf('n = %d',n6))

text(-0.03, -0.03, sprintf('n = %d',n7))
text(0.07, -0.03, sprintf('n = %d',n8))
text(0.97, -0.03, sprintf('n = %d',n9))


set(gca,'tickdir','out','Layer','top','YTick',0:0.25:1,'XTick',0:0.2:1)

xlabel('Visual response permutation p-value','FontAngle','italic','FontSize',12)
ylabel('Half-Split permutation p-value','FontAngle','italic','FontSize',12)

title({'Half-split p-value vs visual response p-value';...
       'data in gray areas are excluded'},'FontAngle','italic','FontSize',14)
