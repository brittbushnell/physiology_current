

clc
figure(2)
clf
pause(0.05)
h = histogram(spikeCountPerTrial(2,2,3,1,:),'binWidth',1,'FaceColor','k','EdgeColor','w');
xlim([-1 maxSpikesCh])
histBins = [h.Values;h.BinEdges(2:end)];
a = find(histBins(1,:) == 0); % find the number of bins in the histogram that = 0

if length(a)>5 % if there are more than 5 channels with bins that equal zero, then break the x axis
    breakStart = a(2);
    breakEnd = a(end-1);
   bax = breakxaxis2([breakStart breakEnd]);
end
xlim([-1 maxSpikesCh])
set(gca, 'box','off','tickdir','out')
%Un-Break The X Axes