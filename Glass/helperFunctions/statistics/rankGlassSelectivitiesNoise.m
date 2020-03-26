function [dataT] = rankGlassSelectivitiesNoise(dataT)
%%
[~,numDots,numDxs] = getGlassParameters(dataT);

%%
% row1 = concentric
% row2 = radial
% row3 = noise
dPrimeRank{2,2} = [];
for dt = 1:numDots
    for dx = 1:numDxs
        rankOrder = nan(3,96);
        for ch = 1:96
            if dataT.goodCh(ch) == 1
                conSelective = dataT.conNoiseSig(end,dt,dx,ch);
                radSelective = dataT.radNoiseSig(end,dt,dx,ch);
                
                if conSelective == 1 && radSelective == 1
                    rankOrder(:,ch) = rankOrderBothCompsSignificant(dataT,dt,dx,ch);
                elseif conSelective == 1 && radSelective == 0
                    rankOrder(:,ch) = rankOrderConSignificant(dataT,dt,dx,ch);
                elseif conSelective == 0 && radSelective == 1
                    rankOrder(:,ch) = rankOrderRadSignificant(dataT,dt,dx,ch);
                end
                
            end
            dPrimeRank{dt,dx} = rankOrder;
        end
    end
end
dataT.dPrimeRank = dPrimeRank;
end
%% if both stimuli are significant
function [rO] = rankOrderBothCompsSignificant(dataT,dt,dx,ch)
radNoise = dataT.radNoiseDprime(end,dt,dx,ch);
conNoise = dataT.conNoiseDprime(end,dt,dx,ch);


if conNoise > 0 && radNoise > 0
    % if both d' are positive, then both Glass patterns elicit higher responses than noise, so rank between radial and concentric
    rO(3,1) = 3;
    others = [conNoise; radNoise];
    [~,rO(1:2,1)] = sort(others,'descend');
    
elseif conNoise < 0 && radNoise < 0
    % if both d' are negative, then noise is highest, so
    % rank between radial and concentric for 2 and 3rd
    % place
    
    rO(3,1) = 1;
    others = [conNoise; radNoise];
    [~,other] = sort(others,'descend');
    rO(1:2,1) = other+1;
    
elseif conNoise > 0 && radNoise < 0
    % in this case, concentric is greater than noise,  but
    % noise is greater than radial
    
    rO(1,1) = 1;
    rO(2,1) = 3;
    rO(3,1) = 2;
    
elseif conNoise < 0 && radNoise > 0
    % in this case, radial is greater than noise,  but
    % noise is greater than concentric
    
    rO(1,1) = 1;
    rO(2,1) = 3;
    rO(3,1) = 2;
elseif conNoise == 0 && radNoise > 0
    % concentric vs noise is zero, but radial is greater
    % than noise
    rO(1,1) = 3;
    rO(2,1) = 1;
    rO(3,1) = 2;
elseif conNoise == 0 && radNoise < 0
    % concentric vs noise is zero, and radial is less
    % than noise
    rO(1,1) = 3;
    rO(2,1) = 2;
    rO(3,1) = 1;
elseif conNoise > 0 && radNoise == 0
    % concentric is greater than noise, and radial vs noise
    % is zero
    
    rO(1,1) = 1;
    rO(2,1) = 3;
    rO(3,1) = 2;
elseif conNoise < 0 && radNoise == 0
    % concentric is less than noise, and radial vs noise
    % is zero
    rO(1,1) = 2;
    rO(2,1) = 3;
    rO(3,1) = 1;
    
else
    error(fprintf('unknown rank order for ch %d %d dots %.2f dx',ch,dots(dt),dx(dxs)))
end
end
%% if only concentric is significant
function [rO] = rankOrderConSignificant(dataT,dt,dx,ch)
conNoise = dataT.conNoiseDprime(end,dt,dx,ch);
if conNoise > 0
    % if both d' are positive, then both Glass patterns elicit higher responses than noise, so rank between radial and concentric
    rO(1,1) = 1;
    rO(2,1) = nan;
    rO(3,1) = 2;
    
elseif conNoise < 0
    rO(1,1) = 2;
    rO(2,1) = nan;
    rO(3,1) = 1;
    
else
    error(fprintf('unknown rank order for ch %d %d dots %.2f dx',ch,dots(dt),dx(dxs)))
end
end
%% if only radial is significant
function [rO] = rankOrderRadSignificant(dataT,dt,dx,ch)
radNoise = dataT.radNoiseDprime(end,dt,dx,ch);
if radNoise > 0
    % if both d' are positive, then both Glass patterns elicit higher responses than noise, so rank between radial and concentric
    rO(1,1) = nan;
    rO(2,1) = 1;
    rO(3,1) = 2;
    
elseif radNoise < 0
    rO(1,1) = nan;
    rO(2,1) = 2;
    rO(3,1) = 1;
    
else
    error(fprintf('unknown rank order for ch %d %d dots %.2f dx',ch,dots(dt),dx(dxs)))
end
end