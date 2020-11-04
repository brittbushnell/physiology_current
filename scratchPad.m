% This is just to be used for debugging and fucking around with things.
% Creating a saved script for it after losing info due to crashes.
%%

% clear
% close all
% clc
% location = determineComputer;

%%
% set all LE receptive fields to (0,0);
LEv1x = zeros(1,96);
LEv1y = zeros(1,96);

LEv4x = zeros(1,96);
LEv4y = zeros(1,96);

for ch = 1:96
REv1x(ch) = V1rfParamsRE



end








%%
figure
hold on
plot(0,0,'ob')
plot([0,-3],[0 -3],'-k')

    xlim([-10,10])
    ylim([-10,10])
    grid on;
    set(gca,'YAxisLocation','origin','XAxisLocation','origin',...
        'Layer','top','FontWeight','bold','FontSize',14,'FontAngle','italic')
    axis square 