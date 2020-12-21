% This is just to be used for debugging and fucking around with things.
% Creating a saved script for it after losing info due to crashes.
%%

figure(3)
clf
hold on
for ch = 1:96
    scatter(rfParamsOrig{ch}(1),rfParamsOrig{ch}(2),40,'k','filled','MarkerFaceAlpha',0.7);
    scatter(rfParamsRelGlassFix{ch}(1),rfParamsRelGlassFix{ch}(2),40,'r','filled','MarkerFaceAlpha',0.7);
    scatter(rfParamsStim0{ch}(1),rfParamsStim0{ch}(2),40,'b','filled','MarkerFaceAlpha',0.7);
end

xlim([-10,10])
ylim([-10,10])
set(gca,'YAxisLocation','origin','XAxisLocation','origin',...
    'Layer','top','FontWeight','bold','FontSize',12,'FontAngle','italic')
