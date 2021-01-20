

radZ = squeeze(WUV1.conRadLE.radZscore (end,:,:,:,:));
conZ = squeeze(WUV1.conRadLE.conZscore (end,:,:,:,:));
% get zscores for preferred prarameters
for ch = 1:96
    if WUV1.trLE.prefParamsIndex(ch) == 1
        prefConZs(ch,:) = squeeze(conZ(1,1,ch,:));
        prefRadZs(ch,:) = squeeze(radZ(1,1,ch,:));
    elseif WUV1.trLE.prefParamsIndex(ch) == 2
        prefConZs(ch,:) = squeeze(conZ(1,2,ch,:));
        prefRadZs(ch,:) = squeeze(radZ(1,2,ch,:));
    elseif WUV1.trLE.prefParamsIndex(ch) == 3
        prefConZs(ch,:) = squeeze(conZ(2,1,ch,:));
        prefRadZs(ch,:) = squeeze(radZ(2,1,ch,:));
    else
        prefConZs(ch,:) = squeeze(conZ(2,2,ch,:));
        prefRadZs(ch,:) = squeeze(radZ(2,2,ch,:));
    end
end

% get preferred pattern for each channel using stimuli at the center
% inStimRanks(inStimCenter == 1) - will need to combine all of the
% quadrants from inStimRanks - that's set up as a structure for now.

%%
figure (7)
clf

subplot(2,2,1) 
