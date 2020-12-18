% This is just to be used for debugging and fucking around with things.
% Creating a saved script for it after losing info due to crashes.
%%

yVals = [50 52 81 98 100];
yVals2 = [50 50 51 53 75 98 99 100 100];
xVals = 1:length(yVals2);
yIntp = interp(yVals2,200);
yFit = wblfit(yVals2);
%ySmooth = smoothdata(yVals2,'gaussian',5);
% ySmooth = wblcdf(yVals,0.15,0.5);

figure(1)
clf
hold on
plot(xVals,yVals,'ok','MarkerFaceColor','k')
plot(yFit)
%plot(1:length(ySmooth),ySmooth,'-k')
% wblplot(yVals)
ylim([45,105])
xlim([0 6])
ylabel('Percent correct')
xlabel('Coherence')
set(gca,'tickdir','out','XTick',1:5,'XTickLabel',{'0','25','50','75','100'})