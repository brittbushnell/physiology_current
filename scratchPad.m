blankResp = nan(96, 2000);
stimResp  = nan(96,2000);


for ch = 1:96
    blankT  = mean(smoothdata(data.bins((data.spatial_frequency == 0), 1:35 ,ch),'gaussian',3))./0.01;
    stimT = mean(smoothdata(data.bins((data.spatial_frequency > 0.1), 1:35 ,ch),'gaussian',3))./0.01;
    
    blankResp(ch,1:length(blankT)) = blankT;
    stimResp(ch,1:length(stimT)) = stimT;
end


%%
sfs = unique(data.spatial_frequency);
sfsReal = sfs > 0.1;
oris = unique(data.rotation);

stimCon = nan(length(sfsReal)+length(oris),96,2000);

ndx = 1;
blankNdx = data.spatial_frequency == 0;
for s = 1:length(sfsReal)
    sfNdx = data.spatial_frequency == sfsReal(s);
    for or = 1:length(oris)
        orNdx = data.rotation == oris(or);
        
        for ch = 1:96
            stimConT = mean(smoothdata(data.bins((sfNdx & orNdx), 1:35 ,ch),'gaussian',3))./0.01; 
            stimCon(ndx,ch,1:length(stimConT)) = stimConT;    
        end        
        ndx = ndx+1;
    end
end