
for ch = 5 %1:numCh
     if LEdata.goodChannels(ch) == 1
%         LEmedT = nan(4,6);
%         LEmuTS = nan(4,6);
%         LEsteT = nan(4,6);
        for rd = 1%:length(rads) - 1 % want to ignore the dummy numbers used for blanks
            for sf = 1%:length(SFs) - 1
                for r = 1:length(RFs)
                    ndx = 1;
                    for a = 1:length(amps)
                        %find the trials with the given rf x amp x size x sf
                        %combo
                        
                        LEndx = find((LEdata.stimResps{ch}(1,:) == RFs(r)) & ...
                            (LEdata.stimResps{ch}(2,:) == amps(a)) & ...
                            (LEdata.stimResps{ch}(5,:) == rd) & ...
                            (LEdata.stimResps{ch}(4,:) == sf));
                        
                        if ~isempty(LEndx)  
                            % different RFs use different amplitudes, so this should skip any amplitudes that weren't run for that RF
                            for i = 1:length(LEndx)
                                LEndxMean(i) = (LEdata.stimResps{ch}(end-3,LEndx(i)));
                                LEndxMed(i) = (LEdata.stimResps{ch}(end-2,LEndx(i)));
                                LEste1(i) = LEdata.stimResps{ch}(end-1,LEndx(i));
                            end
                            LEmuTS(r,ndx) = mean(LEndxMean);
                            LEmedT(r,ndx) = mean(LEndxMed);
                            LEsteT(r,ndx) = 0.01; %mean(LEste1);
                            
                            ndx = ndx+1;
                        end
                    end
                end
                
                LEmedian{rd}{sf} = LEmedT;
                LEste{rd}{sf}    = LEsteT;
                LEmuBS{rd}{sf}   = LEmuTS-LEdata.blankResps{ch}(end-2);
                
                clear LEmuTS
                clear LEmedT
                clear LEsteT
                
            end
        end
    end
    LEdata.LERFxAmp_muBS{ch} = LEmuBS;
    LEdata.LERFxAmp_ste{ch}  = LEste;
    LEdata.LERFxAmp_median{ch} = LEmedian;
    
    clear LEmedian
    clear LEste
    clear LEmuBS
end

% LEdata.all_LE = all_LE;
% LEdata.medianResps = LEmedian;