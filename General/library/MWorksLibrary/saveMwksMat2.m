function [] = saveMwksMat2(filename)

cd step2mats

if strfind(filename, '/')
    filename = strsplit(filename,'/');
end

filename = regexprep(filename,'.mat','');
newName  = strcat(filename, 'second');

save(newName)
