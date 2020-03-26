function [passRespFile,runStr] = oepGetPassRespFile(azDir,unitLabel,runNum,suffix)

if ~exist('suffix','var')
    suffix = '';
end

runNum = floor(runNum);
runStr = [unitLabel,'#',num2str(runNum)];
passRespFile = [azDir,'/',runStr,'_passResp',suffix,'.mat'];