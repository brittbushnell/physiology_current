% numRows = 7; % to account for the first 7 rows of stimulus information
% for ses = 1:length(dataComp)
% numRows =  numRows + size(dataComp{ses}.RFStimResps{1},1) - 10;
% end

RFStimResps = cell(1,96);
for i = 1:length(dataComp)
    rfResp = dataComp{i}.RFStimResps;
    
    for ch = 1:96
        if i == 1
            RFStimResps{ch}(1:7,:) = dataComp{1}.RFStimResps{1}(1:7,:);
        end
        RFStimResps{ch} =  vertcat(RFStimResps{ch},rfResp{ch}(8:end-3,:));
    end
end