if contains(dataT.animal,'WU')
    %sf1 rad1
    if lo == 1 && rd == 1 && sp == 1
        rfSpikes = loc1Spikes{ch}.sf1Rad1(:,1:end-1);
        cSpike   = loc1Spikes{ch}.sf1Rad1(:,end);
    elseif lo == 2 && rd == 1 && sp == 1
        rfSpikes = loc2Spikes{ch}.sf1Rad1(:,1:end-1);
        cSpike   = loc2Spikes{ch}.sf1Rad1(:,end);
    elseif lo == 3 && rd == 1 && sp == 1
        cSpike   = loc3Spikes{ch}.sf1Rad1(:,end);
        rfSpikes = loc3Spikes{ch}.sf1Rad1(:,1:end-1);
        
        %sf1 rad2
    elseif lo == 1 && rd == 2 && sp == 1
        rfSpikes = loc1Spikes{ch}.sf1Rad2(:,1:end-1);
        cSpike   = loc1Spikes{ch}.sf1Rad2(:,end);
    elseif lo == 2 && rd == 2 && sp == 1
        rfSpikes = loc2Spikes{ch}.sf1Rad2(:,1:end-1);
        cSpike   = loc2Spikes{ch}.sf1Rad2(:,end);
    elseif lo == 3 && rd == 2 && sp == 1
        cSpike   = loc3Spikes{ch}.sf1Rad2(:,end);
        rfSpikes = loc3Spikes{ch}.sf1Rad2(:,1:end-1);
        
        %sf2 rad1
    elseif lo == 1 && rd == 1 && sp == 2
        rfSpikes = loc1Spikes{ch}.sf2Rad1(:,1:end-1);
        cSpike   = loc1Spikes{ch}.sf2Rad1(:,end);
    elseif lo == 2 && rd == 1 && sp == 2
        rfSpikes = loc2Spikes{ch}.sf2Rad1(:,1:end-1);
        cSpike   = loc2Spikes{ch}.sf2Rad1(:,end);
    elseif lo == 3 && rd == 1 && sp == 2
        cSpike   = loc3Spikes{ch}.sf2Rad1(:,end);
        rfSpikes = loc3Spikes{ch}.sf2Rad1(:,1:end-1);
        
        %sf2 rad2
    elseif lo == 1 && rd == 2 && sp == 2
        rfSpikes = loc1Spikes{ch}.sf2Rad2(:,1:end-1);
        cSpike   = loc1Spikes{ch}.sf2Rad2(:,end);
    elseif lo == 2 && rd == 2 && sp == 2
        rfSpikes = loc2Spikes{ch}.sf2Rad2(:,1:end-1);
        cSpike   = loc2Spikes{ch}.sf2Rad2(:,end);
    elseif lo == 3 && rd == 2 && sp == 2
        cSpike   = loc3Spikes{ch}.sf2Rad2(:,end);
        rfSpikes = loc3Spikes{ch}.sf2Rad2(:,1:end-1);
    end
    
elseif contains(dataT.programID,'High')
    %sf2 rad1
    if lo == 1 && rd == 1
        rfSpikes = loc1Spikes{ch}.sf2Rad1(:,1:end-1);
        cSpike   = loc1Spikes{ch}.sf2Rad1(:,end);
    elseif lo == 2 && rd == 1
        rfSpikes = loc2Spikes{ch}.sf2Rad1(:,1:end-1);
        cSpike   = loc2Spikes{ch}.sf2Rad1(:,end);
    elseif lo == 3 && rd == 1
        cSpike   = loc3Spikes{ch}.sf2Rad1(:,end);
        rfSpikes = loc3Spikes{ch}.sf2Rad1(:,1:end-1);
        
        %sf2 rad2
    elseif lo == 1 && rd == 2
        rfSpikes = loc1Spikes{ch}.sf2Rad2(:,1:end-1);
        cSpike   = loc1Spikes{ch}.sf2Rad2(:,end);
    elseif lo == 2 && rd == 2 && sp == 2
        rfSpikes = loc2Spikes{ch}.sf2Rad2(:,1:end-1);
        cSpike   = loc2Spikes{ch}.sf2Rad2(:,end);
    elseif lo == 3 && rd == 2
        cSpike   = loc3Spikes{ch}.sf2Rad2(:,end);
        rfSpikes = loc3Spikes{ch}.sf2Rad2(:,1:end-1);
    end
else
    %sf1 rad1
    if lo == 1 && rd == 1
        rfSpikes = loc1Spikes{ch}.sf1Rad1(:,1:end-1);
        cSpike   = loc1Spikes{ch}.sf1Rad1(:,end);
    elseif lo == 2 && rd == 1
        rfSpikes = loc2Spikes{ch}.sf1Rad1(:,1:end-1);
        cSpike   = loc2Spikes{ch}.sf1Rad1(:,end);
    elseif lo == 3 && rd == 1
        cSpike   = loc3Spikes{ch}.sf1Rad1(:,end);
        rfSpikes = loc3Spikes{ch}.sf1Rad1(:,1:end-1);
        
        %sf1 rad2
    elseif lo == 1 && rd == 2
        rfSpikes = loc1Spikes{ch}.sf1Rad2(:,1:end-1);
        cSpike   = loc1Spikes{ch}.sf1Rad2(:,end);
    elseif lo == 2 && rd == 2
        rfSpikes = loc2Spikes{ch}.sf1Rad2(:,1:end-1);
        cSpike   = loc2Spikes{ch}.sf1Rad2(:,end);
    elseif lo == 3 && rd == 2
        cSpike   = loc3Spikes{ch}.sf1Rad2(:,end);
        rfSpikes = loc3Spikes{ch}.sf1Rad2(:,1:end-1);
    end
end