cd '/Users/brittany/Dropbox/behavior/Peripho/Controls/XT/fitFiles'

tmp = dir;
for i = 3:length(tmp)
    fitFiles{i-2} = tmp(i).name;
end

% for f = 1:length(fitFiles)
    fn = fitFiles{1};
    fid = fopen(fn);
% end

OK = true;

while OK
    L = fgetl(fid)



end
%%
c = Betas{1};

(1-c(1) - c(2)) / (c(4)*(sqrt(2*pi)))