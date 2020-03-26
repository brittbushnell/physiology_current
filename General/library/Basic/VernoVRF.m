clear all
%close all

%%
unit = 2; % if 1 leave in arcsec. if 2, convert to deg
radius = 0.75;

LEVerno = dlmread('wu_LE+1.0D0115_verno.all');
REVerno = dlmread('wu_RE+1.0D0115_verno.all');
% Rad 1.5
% RERadial = dlmread('SF3/Rad_1.5/WU/wu_RE+1.0D1214_radial.all');
% LERadial = dlmread('SF3/Rad_1.5/WU/wu_LE+1.0D1214_radial.all');
% Rad 0.75
 RERadial = dlmread('SF3/Rad_0.75/WU/wu_RE+1.0D0115_radial.all');
 LERadial = dlmread('SF3/Rad_0.75/WU/wu_LE+1.0D0115_radial.all');
% Rad 0.375
% RERadial = dlmread('SF3/Rad_0.375/WU/wu_RE+1.0D0215r375_radial.all');%
% LERadial = dlmread('SF3/Rad_0.375/WU/wu_LE+1.0D0215r375_radial.all');

% LEVerno = dlmread('wv_LE0712_verno.all');
% REVerno = dlmread('wv_RE0712_verno.all');
% RERadial = dlmread('wv_RE+4.5D0714_radial.all');
% LERadial = dlmread('wv_LE+1.25D0714_radial.all');

% LEVerno = dlmread('pd_LE0911_verno.all');
% REVerno = dlmread('pd_RE0911_verno.all');
% RERadial = dlmread('pd_RE+4.5D0215_radial.all');
% LERadial = dlmread('pd_LE+5.0D0215_radial.all');

% BEVerno = dlmread('lw_BE0807_verno.all');
% BERadial = dlmread('lw_BE0315_radial.all');
%% Convert units
if unit  == 2
    LEVerno(1,(2:3)) = LEVerno(1,(2:3))./3600;
    REVerno(1,(2:3)) = REVerno(1,(2:3))./3600;
    LERadial(1,(2:3)) = LERadial(1,(2:3)).*radius;
    RERadial(1,(2:3)) = RERadial(1,(2:3)).*radius;
end
%%

VernoDiff = LogDifference(REVerno(1,2), LEVerno(1,2));
%VernoDiff = BEVerno(1,2)

RadialDiff = nan(4,1);
%RadialDiff = BERadial(:,2)

for i = 1:length(RERadial)
    RadialDiff(i) = LogDifference(RERadial(i,2), LERadial(i,2));   
end
% 
figure
plot(LEVerno(1),LEVerno(2),'ok')
hold on
plot(REVerno(1),REVerno(2),'or')
axis square
box off
set(gca,'yscale','log')
set(gca,'color','none','tickdir','out')
ylim([0.0001 0.1])
ylabel ('Threshold (degrees)')
xlabel ('Spatial Frequency (cpd)')
title ('WU Verno')
legend ('Fellow Eye','Amblyopic eye')


figure
plot(VernoDiff,'ok')
hold on
plot(RadialDiff(1,1),'^r')
plot(RadialDiff(2,1),'*r')
plot(RadialDiff(3,1),'or')
plot(RadialDiff(4,1),'dr')
box off
axis square
set(gca,'color','none','tickdir','out')
ylim ([-1 2.5])
ylabel('log difference(deg)')
legend ('Verno','RF2','RF4','RF8','RF16')
%title('WV RF (188wks) and Verno (76wks) threshold log differences')
%title('WU RF (206wks) and Verno (214wks) threshold log differences')
%title('PD RF (206wks) and Verno (199wks) threshold log differences')
%title('LW RF (206wks) and Verno (199wks) threshold log differences')
%title('WU RF rad 1.5deg and Verno threshold log differences')
title('WU RF rad 0.75deg and Verno threshold log differences')
%title('WU RF rad 0.375deg and Verno threshold log differences')

