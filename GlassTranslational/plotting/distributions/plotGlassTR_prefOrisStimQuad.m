
location = determineComputer;
if location == 1
    figDir =  sprintf('~/bushnell-local/Dropbox/Figures/%s/GlassTR/%s/tuningCurves/%s/polar/',dataT.animal, dataT.array,dataT.eye);
elseif location == 0
    figDir =  sprintf('~/Dropbox/Figures/%s/GlassTR/%s/tuningCurves/%s/polar/',dataT.animal, dataT.array,dataT.eye);
end

cd(figDir)
% go to date specific folder, if it doesn't exist, make it
folder = dataT.date2;
mkdir(folder)
cd(sprintf('%s',folder))

folder = 'quadrant';
mkdir(folder)
cd(sprintf('%s',folder))
%%

figure
subplot(2,2,1)