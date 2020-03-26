function [names] = parseMapNoiseStim(filenames)
%
%
%%
names = nan(1,length(filenames));

for i = 1:size(filenames,1)
    if contains(filenames(i,:),'blank')
        names(1,i) = 0;
    else
        names(1,i) = 1;
    end
end
