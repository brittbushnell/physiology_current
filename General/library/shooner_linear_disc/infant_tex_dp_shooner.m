clear
clc, close all

monkName = {'B6','B8'};
for iMonk = 1:2
    
dataFile = {'B6_V4_Textures2_6.4deg_0x_0y_formatted_w_reps.mat',...
    'B8_V4_Textures2_6.4deg_0x_0y_formatted_w_reps.mat'};
load(dataFile{iMonk})

[nU,nT,temp,nRep] = size(bins);
nExemplar = temp/2;
N = nExemplar*nRep;
Xt = reshape(bins(:,:,1:15,:),[nU,nT,N]);
Xn = reshape(bins(:,:,16:30,:),[nU,nT,N]);

dpSing = nan(nU,nT);
dpSingSort = nan(nU,nT);
dpSingSortOrd = nan(nU,nT);
dp = nan(nU,nT);

for iT = 1:nT
    for iU = 1:nU
        X0 = reshape(Xn(iU,iT,:),[N,1]);
        X1 = reshape(Xt(iU,iT,:),[N,1]);
        dpSing(iU,iT) = discrim(X0,X1);
    end
    [~,dpSingSortOrd(:,iT)] = sort(abs(dpSing(:,iT)),'descend');
    dpSingSort(:,iT) = dpSing(dpSingSortOrd(:,iT),iT);
    
    for k = 1:nU
        X0 = reshape(Xn(dpSingSortOrd(1:k,iT),iT,:),[k,N]).';
        X1 = reshape(Xt(dpSingSortOrd(1:k,iT),iT,:),[k,N]).';
        dp(k,iT) = discrim(X0,X1);
    end
end

figure(1)
subplot(1,2,iMonk)
plot(1:nU,dp)
xlabel('# neurons'), ylabel('D prime')
title(monkName{iMonk})

end
        
