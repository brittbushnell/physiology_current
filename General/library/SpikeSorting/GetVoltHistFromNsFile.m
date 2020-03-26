function H = GetVoltHistFromNsFile(nsFileName,chunkDurMinutes)
nBins = 100;

flag = false;
iC = 0;
N = 0;
sumSq = zeros(96,1);
while ~flag
    iC = iC+1;
    tStart = (iC-1)*chunkDurMinutes;
    tEnd = tStart + chunkDurMinutes;
    timeStr = ['t:',num2str(tStart),':',num2str(tEnd)];
    S = openNSx('read',nsFileName,timeStr,'min','p:double');
    if isempty(S)
        flag = 1;
    else
        N = N + size(S.Data,2);
        sumSq = sumSq + sum(S.Data(1:96,:).^2,2);
        if iC==1
            [h,x] = hist(S.Data(1:96,:)',nBins);
        else
            h = h + hist(S.Data(1:96,:)',x);
        end
    end
    clc, iC
end

H.N = N;
H.sigma = sumSq./(N-1);
H.x = x;
H.h = h;6,:)',x);
        end
    end
    clc, iC
end

sigma = sumSq./(N-1);