                rf4Ndx0Sc  = (spikeCh(1,:) == 4) & (spikeCh(3,:) == 0); % index of all RF4 stimuli with 0 phase
                rf4Ndx2Sc  = (spikeCh(1,:) == 4) & (spikeCh(3,:) == 45);
                rf8Ndx0Sc  = (spikeCh(1,:) == 8) & (spikeCh(3,:) == 0); % index of all RF4 stimuli with 0 phase
                rf8Ndx2Sc  = (spikeCh(1,:) == 8) & (spikeCh(3,:) == 22.5);
                rf16Ndx0Sc  = (spikeCh(1,:) == 16) & (spikeCh(3,:) == 0); % index of all RF4 stimuli with 0 phase
                rf16Ndx2Sc  = (spikeCh(1,:) == 16) & (spikeCh(3,:) == 11.25);
                
                rf4rot0Sc = spikeCh(8:end,rf4Ndx0Sc & sfNdx & radNdx & locNdx);
                rf4rot2Sc = spikeCh(8:end,rf4Ndx2Sc & sfNdx & radNdx & locNdx);
                rf8rot0Sc = spikeCh(8:end,rf8Ndx0Sc & sfNdx & radNdx & locNdx);
                rf8rot2Sc = spikeCh(8:end,rf8Ndx2Sc & sfNdx & radNdx & locNdx);
                rf16rot0Sc = spikeCh(8:end,rf16Ndx0Sc & sfNdx & radNdx & locNdx);
                rf16rot2Sc = spikeCh(8:end,rf16Ndx2Sc & sfNdx & radNdx & locNdx);
                
                circSCs = spikeCh(8:end,circNdx & sfNdx & radNdx & locNdx);
                
                rfMuSC(1,1,:,sf,rad,loc,ch) = mean(rf4rot0Sc);
                rfMuSC(1,2,:,sf,rad,loc,ch) = mean(rf4rot2Sc);
                rfMuSC(2,1,:,sf,rad,loc,ch) = mean(rf8rot0Sc);
                rfMuSC(2,2,:,sf,rad,loc,ch) = mean(rf8rot2Sc);
                rfMuSC(3,1,:,sf,rad,loc,ch) = mean(rf16rot0Sc);
                rfMuSC(3,2,:,sf,rad,loc,ch) = mean(rf16rot2Sc);
                
                rfStErSC(1,1,:,sf,rad,loc,ch) = std(rf4rot0Sc)/sqrt(length(rf4rot0Sc));
                rfStErSC(1,2,:,sf,rad,loc,ch) = std(rf4rot0Sc)/sqrt(length(rf4rot2Sc));
                rfStErSC(2,1,:,sf,rad,loc,ch) = std(rf8rot0Sc)/sqrt(length(rf8rot0Sc));
                rfStErSC(2,2,:,sf,rad,loc,ch) = std(rf8rot0Sc)/sqrt(length(rf8rot2Sc));
                rfStErSC(3,1,:,sf,rad,loc,ch) = std(rf16rot0Sc)/sqrt(length(rf16rot0Sc));
                rfStErSC(3,2,:,sf,rad,loc,ch) = std(rf16rot0Sc)/sqrt(length(rf16rot2Sc));
                
                circMuSC(sf,rad,loc,ch) = mean(circSCs);
                circStErSC(sf,rad,loc,ch) = std(circSCs)/sqrt(length(circSCs));