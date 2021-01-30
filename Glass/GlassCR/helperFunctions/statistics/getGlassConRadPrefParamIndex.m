function [prefIndex] = getGlassConRadPrefParamIndex(data)
% data = V1.conRadRE;

con = squeeze(data.conBlankDprime(end,:,:,:));
rad = squeeze(data.radBlankDprime(end,:,:,:));
noz = squeeze(data.noiseBlankDprime(1,:,:,:));

%% do vector sums
vSum= nan(2,2,96);

for dt = 1:2
    for dx = 1:2
        conTmp = squeeze(con(dt,dx,:));
        radTmp = squeeze(rad(dt,dx,:));
        nozTmp = squeeze(noz(dt,dx,:));
        tmpMtx = horzcat(conTmp,radTmp,nozTmp);
        vSum(dt,dx,:) = sqrt(tmpMtx(:,1).^2 + tmpMtx(:,2).^2 + tmpMtx(:,3).^2);
        clear tmpMtx;
    end
end
%% get index of greatest d'

sumMtx = [squeeze(vSum(1,1,:)),squeeze(vSum(1,2,:)),squeeze(vSum(2,1,:)),squeeze(vSum(2,2,:))]; % rearrange the dPrimess so each row is a ch and each dt,dx is a column
[~,prefIndex] = max(sumMtx,[],2);% get the indices for the dt,dx that gives the highest summed d'
