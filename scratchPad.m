% This is just to be used for debugging and fucking around with things.
% Creating a saved script for it after losing info due to crashes.
%%

% clear
% close all
% clc
% location = determineComputer;
%%
figure(12)
clf
rad1 = deg2rad(135);
rad2 = rad1+pi;
polarplot([deg2rad(315) 0 deg2rad(135)],[0.4 0 0.4],'--','color',[0 0.6 0.2])
