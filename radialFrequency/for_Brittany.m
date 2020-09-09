load WU_RadFreqLoc2_V4_20170706_cleaned_goodCh

clean = 1; % set to 1 if running on a data set that has been cleaned
if clean == 1
    figure
    RE_stimresps = REcleanData.stimResps;
    RE_SR_GC = RE_stimresps{5};%(boolean(LEcleanData.goodCh));
    RE_SR_GC_mtrx = cat(3,RE_SR_GC);
    %RE_SR_GC_mtrx = cat(3,RE_SR_GC{:});
    RE_SR_GC_mu = nanmean(RE_SR_GC_mtrx,3);
    
    sf2_sz1_ind          = find(RE_SR_GC_mu(4,:) == 2 & RE_SR_GC_mu(5,:) == 1);
    RE_CD_GC_sf2_sz1     = RE_SR_GC_mtrx(:,sf2_sz1_ind,:);
    RE_CD_GC_sf2_sz1_mu = RE_SR_GC_mu(:,sf2_sz1_ind);
    
    circ_resp_mu = mean(RE_CD_GC_sf2_sz1_mu(:,109:111),2);
    rf4_resp_mu = RE_CD_GC_sf2_sz1_mu(:,1:36);
    rf4_resp_mu = reshape(rf4_resp_mu,18,6,6);
    rf4_resp_mu = squeeze(mean(rf4_resp_mu,2));
    rf4_resp_mu = [circ_resp_mu,rf4_resp_mu];
    
    rf8_resp_mu = RE_CD_GC_sf2_sz1_mu(:,37:72);
    rf8_resp_mu = reshape(rf8_resp_mu,18,6,6);
    rf8_resp_mu = squeeze(mean(rf8_resp_mu,2));
    rf8_resp_mu = [circ_resp_mu,rf8_resp_mu];

    rf16_resp_mu = RE_CD_GC_sf2_sz1_mu(:,73:108);
    rf16_resp_mu = reshape(rf16_resp_mu,18,6,6);
    rf16_resp_mu = squeeze(mean(rf16_resp_mu,2));
    rf16_resp_mu = [circ_resp_mu,rf16_resp_mu];
    
    subplot(1,2,1);
    cla
    hold on;
    plot(rf4_resp_mu(15,:),'ko-');
    plot(rf4_resp_mu(16,:),'ro-');
    
    plot(rf8_resp_mu(15,:),'ks-');
    plot(rf8_resp_mu(16,:),'rs-');
    
    plot(rf16_resp_mu(15,:),'kd-');
    plot(rf16_resp_mu(16,:),'kd-');
    title('ch5 0707')
    
    
    
    LE_stimresps = LEcleanData.stimResps;
    LE_SR_GC = LE_stimresps{5};%(boolean(LEcleanData.goodCh));
    LE_SR_GC_mtrx = cat(3,LE_SR_GC);
    %LE_SR_GC_mtrx = cat(3,LE_SR_GC{:});
    LE_SR_GC_mu = nanmean(LE_SR_GC_mtrx,3);
    LE_CD_GC_sf2_sz1     = LE_SR_GC_mtrx(:,sf2_sz1_ind,:);
    LE_CD_GC_sf2_sz1_mu = LE_SR_GC_mu(:,sf2_sz1_ind);
    
    circ_resp_mu = mean(LE_CD_GC_sf2_sz1_mu(:,109:111),2);
    rf4_resp_mu = LE_CD_GC_sf2_sz1_mu(:,1:36);
    rf4_resp_mu = reshape(rf4_resp_mu,15,6,6);
    %rf4_resp_mu = reshape(rf4_resp_mu,21,6,6);
    rf4_resp_mu = squeeze(mean(rf4_resp_mu,2));
    rf4_resp_mu = [circ_resp_mu,rf4_resp_mu];
    
    rf8_resp_mu = LE_CD_GC_sf2_sz1_mu(:,37:72);
    rf8_resp_mu = reshape(rf8_resp_mu,15,6,6);
    %rf8_resp_mu = reshape(rf8_resp_mu,21,6,6);
    rf8_resp_mu = squeeze(mean(rf8_resp_mu,2));
    rf8_resp_mu = [circ_resp_mu,rf8_resp_mu];

    rf16_resp_mu = LE_CD_GC_sf2_sz1_mu(:,73:108);
    rf16_resp_mu = reshape(rf16_resp_mu,15,6,6);
    %rf16_resp_mu = reshape(rf16_resp_mu,21,6,6);
    rf16_resp_mu = squeeze(mean(rf16_resp_mu,2));
    rf16_resp_mu = [circ_resp_mu,rf16_resp_mu];
    
    subplot(1,2,2);
    cla
    hold on;
    plot(rf4_resp_mu(end-3,:),'ko-');
    plot(rf4_resp_mu(end-2,:),'ro-');
    
    plot(rf8_resp_mu(end-3,:),'ks-');
    plot(rf8_resp_mu(end-2,:),'rs-');
    
    plot(rf16_resp_mu(end-3,:),'kd-');
    plot(rf16_resp_mu(end-2,:),'rd-'); 
    
%     plot(rf4_resp_mu(18,:),'ko-');
%     plot(rf4_resp_mu(19,:),'bo-');
%     
%     plot(rf8_resp_mu(18,:),'ks-');
%     plot(rf8_resp_mu(19,:),'bs-');
%     
%     plot(rf16_resp_mu(18,:),'kd-');
%     plot(rf16_resp_mu(19,:),'bd-');
    
    
    
else    
    RE_stimresps = REdata.stimResps;
    RE_SR_GC = RE_stimresps(boolean(LEdata.goodCh));
    RE_SR_GC_mtrx = cat(3,RE_SR_GC{:});
    RE_SR_GC_mu = nanmean(RE_SR_GC_mtrx,3);
    
    sf2_sz1_ind          = find(RE_SR_GC_mu(4,:) == 2 & RE_SR_GC_mu(5,:) == 1);
    RE_CD_GC_sf2_sz1     = RE_SR_GC_mtrx(:,sf2_sz1_ind,:);
    RE_CD_GC_sf2_sz1_mu = RE_SR_GC_mu(:,sf2_sz1_ind);
    
    circ_resp_mu = mean(RE_CD_GC_sf2_sz1_mu(:,109:111),2);
    rf4_resp_mu = RE_CD_GC_sf2_sz1_mu(:,1:36);
    rf4_resp_mu = reshape(rf4_resp_mu,18,6,6);
    rf4_resp_mu = squeeze(mean(rf4_resp_mu,2));
    rf4_resp_mu = [circ_resp_mu,rf4_resp_mu];
    
    rf8_resp_mu = RE_CD_GC_sf2_sz1_mu(:,37:72);
    rf8_resp_mu = reshape(rf8_resp_mu,18,6,6);
    rf8_resp_mu = squeeze(mean(rf8_resp_mu,2));
    rf8_resp_mu = [circ_resp_mu,rf8_resp_mu];
    
    rf16_resp_mu = RE_CD_GC_sf2_sz1_mu(:,73:108);
    rf16_resp_mu = reshape(rf16_resp_mu,18,6,6);
    rf16_resp_mu = squeeze(mean(rf16_resp_mu,2));
    rf16_resp_mu = [circ_resp_mu,rf16_resp_mu];
    
    subplot(1,2,1);
    cla
    hold on;
    plot(rf4_resp_mu(15,:),'ko-');
    plot(rf4_resp_mu(16,:),'ro-');
    
    plot(rf8_resp_mu(15,:),'ks-');
    plot(rf8_resp_mu(16,:),'rs-');
    
    plot(rf16_resp_mu(15,:),'kd-');
    plot(rf16_resp_mu(16,:),'kd-');
    
    
    LE_stimresps = LEdata.stimResps;
    LE_SR_GC = LE_stimresps(boolean(LEdata.goodCh));
    LE_SR_GC_mtrx = cat(3,LE_SR_GC{:});
    LE_SR_GC_mu = nanmean(LE_SR_GC_mtrx,3);
    LE_CD_GC_sf2_sz1     = LE_SR_GC_mtrx(:,sf2_sz1_ind,:);
    LE_CD_GC_sf2_sz1_mu = LE_SR_GC_mu(:,sf2_sz1_ind);
    
    circ_resp_mu = mean(LE_CD_GC_sf2_sz1_mu(:,109:111),2);
    rf4_resp_mu = LE_CD_GC_sf2_sz1_mu(:,1:36);
    rf4_resp_mu = reshape(rf4_resp_mu,21,6,6);
    rf4_resp_mu = squeeze(mean(rf4_resp_mu,2));
    rf4_resp_mu = [circ_resp_mu,rf4_resp_mu];
    
    rf8_resp_mu = LE_CD_GC_sf2_sz1_mu(:,37:72);
    rf8_resp_mu = reshape(rf8_resp_mu,21,6,6);
    rf8_resp_mu = squeeze(mean(rf8_resp_mu,2));
    rf8_resp_mu = [circ_resp_mu,rf8_resp_mu];
    
    rf16_resp_mu = LE_CD_GC_sf2_sz1_mu(:,73:108);
    rf16_resp_mu = reshape(rf16_resp_mu,21,6,6);
    rf16_resp_mu = squeeze(mean(rf16_resp_mu,2));
    rf16_resp_mu = [circ_resp_mu,rf16_resp_mu];
    
    subplot(1,2,2);
    cla
    hold on;
    plot(rf4_resp_mu(18,:),'ko-');
    plot(rf4_resp_mu(19,:),'ro-');
    
    plot(rf8_resp_mu(18,:),'ks-');
    plot(rf8_resp_mu(19,:),'rs-');
    
    plot(rf16_resp_mu(18,:),'kd-');
    plot(rf16_resp_mu(19,:),'rd-');  
end


