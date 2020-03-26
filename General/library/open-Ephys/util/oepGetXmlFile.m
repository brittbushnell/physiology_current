function xmlFile = oepGetXmlFile(xmlDir,unitLabel,runNum)

runStr = [unitLabel,'#',num2str(runNum)];

D = dir(xmlDir);
indStr = find(cellfun(@(c) strncmp(c,runStr,numel(runStr)),{D.name}));
if isempty(indStr)
    error(['XML file (',runStr,') not found'])
end
for i = indStr
    if ~isempty(strfind(D(i).name,'xml'))
        xmlFile = [xmlDir,'/',D(i).name];
    end
end




