function [conLE,conRE,radLE,radRE,trLE,trRE] = getBinocGlassdPrimeDipoleMats(data,binocOnly)
% binoc only: set to 1 if you only want to get data from binocular
% channels, 0 if you want to include monocular channels with the
% non-responsive channel set to 0 d'
%%
conRE = nan(2,2,96);
radRE = nan(2,2,96);

conLE = nan(2,2,96);
radLE = nan(2,2,96);

% identify channels that are responsive  and in stimuli with both eyes
binocCh = data.conRadRE.inStim & data.conRadRE.goodCh & data.conRadLE.inStim & data.conRadLE.goodCh;
LEchs = data.conRadLE.inStim & data.conRadLE.goodCh;
REchs = data.conRadRE.inStim & data.conRadRE.goodCh;

for ch = 1:96
    if binocCh(ch) == 1
        conLE(:,:,ch) = squeeze(data.conRadLE.conNoiseDprime(end,:,:,ch));
        conRE(:,:,ch) = squeeze(data.conRadRE.conNoiseDprime(end,:,:,ch));
        
        radLE(:,:,ch) = squeeze(data.conRadLE.radNoiseDprime(end,:,:,ch));
        radRE(:,:,ch) = squeeze(data.conRadRE.radNoiseDprime(end,:,:,ch));
    end
    if binocOnly == 0
        if LEchs(ch) == 1 && REchs(ch) == 0
            conLE(:,:,ch) = squeeze(data.conRadLE.conNoiseDprime(end,:,:,ch));
            conRE(:,:,ch) = zeros(2,2,1);
            
            radLE(:,:,ch) = squeeze(data.conRadRE.radNoiseDprime(end,:,:,ch));
            radRE(:,:,ch) = zeros(2,2,1);
            
        elseif LEchs(ch) == 0 && REchs(ch) == 1
            conLE(:,:,ch) = zeros(2,2,1);
            conRE(:,:,ch) = squeeze(data.conRadRE.conNoiseDprime(end,:,:,ch));
            
            radLE(:,:,ch) = zeros(2,2,1);
            radRE(:,:,ch) = squeeze(data.conRadRE.radNoiseDprime(end,:,:,ch));
        end
    end
end


trLE = nan(2,2,96);
trRE = nan(2,2,96);

% identify channels that are responsive  and in stimuli with both eyes
binocCh = data.trRE.inStim & data.trRE.goodCh & data.trLE.inStim & data.trLE.goodCh;
LEchs = data.trLE.inStim & data.trLE.goodCh;
REchs = data.trRE.inStim & data.trRE.goodCh;

for ch = 1:96
    % get the max orientation
    chDps = squeeze(data.trLE.linNoiseDprime(:,end,:,:,ch));
    [~,maxNdx] = max(chDps,[],'all','linear');
    [maxOri,~] = ind2sub(size(chDps),maxNdx);
    
    maxOriMatLE = squeeze(chDps(maxOri,:,:));
    
    chDps = squeeze(data.trRE.linNoiseDprime(:,end,:,:,ch));
    [~,maxNdx] = max(chDps,[],'all','linear');
    [maxOri,~] = ind2sub(size(chDps),maxNdx);
    
    maxOriMatRE = squeeze(chDps(maxOri,:,:));
    
    if binocCh(ch) == 1
        trLE(:,:,ch) = maxOriMatLE;
        trRE(:,:,ch) = maxOriMatRE;
    end
    if binocOnly == 0
        if LEchs(ch) == 1 && REchs(ch) == 0
            trLE(:,:,ch) = maxOriMatLE;
            trRE(:,:,ch) = zeros(2,2,1);
            
        elseif LEchs(ch) == 0 && REchs(ch) == 1
            trLE(:,:,ch) = zeros(2,2,1);
            trRE(:,:,ch) = maxOriMatRE;
        end
    end
end
