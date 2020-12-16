% This is just to be used for debugging and fucking around with things.
% Creating a saved script for it after losing info due to crashes.
%%
xVals = 1:5;
yVals = [50 52 81 98 100];
yVals2 = [50 50.5 51 53   98 99 100.2 100];

ySmooth = smoothdata(yVals2,'gaussian',5);
% ySmooth = wblcdf(yVals,0.15,0.5);

figure(1)
clf
hold on
plot(xVals,yVals,'ok','MarkerFaceColor','k')
plot(1:length(ySmooth),ySmooth,'-k')
% wblplot(yVals)
ylim([45,105])
xlim([0 6])
ylabel('Percent correct')
xlabel('Coherence')
set(gca,'tickdir','out','XTick',1:5,'XTickLabel',{'0','25','50','75','100'})