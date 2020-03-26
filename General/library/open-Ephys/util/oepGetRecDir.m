function recDir = oepGetRecDir(oepDir,unitLabel,runNum)

runStr = [unitLabel,'#',num2str(runNum)];

D = dir(oepDir);
indStr = find(cellfun(@(c) strncmp(c,runStr,numel(runStr)),{D.name}));
if isempty(indStr)
    error('OpenEphys recording directory not found:\n%s',runStr)
end
for i = indStr
    if D(i).isdir
        recDir = [oepDir,'/',D(i).name];
    end
end



