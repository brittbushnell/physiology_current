function [conLE,conRE,radLE,radRE,nozLE,nozRE,trLE,trRE,trLEnoz,trREnoz] = getBinocGlassdPrimeBlankMats(data)


conRE = nan(2,2,96);
radRE = nan(2,2,96);
nozRE = nan(2,2,96);

conLE = nan(2,2,96);
radLE = nan(2,2,96);
nozLE = nan(2,2,96);

% identify channels that are responsive  and in stimuli with both eyes
binocCh = data.conRadRE.inStim & data.conRadRE.goodCh & data.conRadLE.inStim & data.conRadLE.goodCh;
LEchs = data.conRadLE.inStim & data.conRadLE.goodCh;
REchs = data.conRadRE.inStim & data.conRadRE.goodCh;

for ch = 1:96
    if binocCh(ch) == 1
        conLE(:,:,ch) = squeeze(data.conRadLE.conBlankDprime(end,:,:,ch));
        conRE(:,:,ch) = squeeze(data.conRadRE.conBlankDprime(end,:,:,ch));
        
        radLE(:,:,ch) = squeeze(data.conRadLE.radBlankDprime(end,:,:,ch));
        radRE(:,:,ch) = squeeze(data.conRadRE.radBlankDprime(end,:,:,ch));
        
        nozLE(:,:,ch) = squeeze(data.conRadLE.noiseBlankDprime(1,:,:,ch));
        nozRE(:,:,ch) = squeeze(data.conRadRE.noiseBlankDprime(1,:,:,ch));
    elseif LEchs(ch) == 1 && REchs(ch) == 0
        conLE(:,:,ch) = squeeze(data.conRadLE.conBlankDprime(end,:,:,ch));
        conRE(:,:,ch) = zeros(2,2,1);
        
        radLE(:,:,ch) = squeeze(data.conRadRE.radBlankDprime(end,:,:,ch));
        radRE(:,:,ch) = zeros(2,2,1);
        
        nozLE(:,:,ch) = squeeze(data.conRadLE.noiseBlankDprime(1,:,:,ch));
        nozRE(:,:,ch) =  zeros(2,2,1);
    elseif LEchs(ch) == 0 && REchs(ch) == 1
        conLE(:,:,ch) = zeros(2,2,1);
        conRE(:,:,ch) = squeeze(data.conRadRE.conBlankDprime(end,:,:,ch));
        
        radLE(:,:,ch) = zeros(2,2,1);
        radRE(:,:,ch) = squeeze(data.conRadRE.radBlankDprime(end,:,:,ch));
        
        nozLE(:,:,ch) =  zeros(2,2,1);
        nozRE(:,:,ch) = squeeze(data.conRadRE.noiseBlankDprime(1,:,:,ch));
    end
end

trLE = nan(2,2,96);
trRE = nan(2,2,96);

Add noise from translational 
trLEnoz = nan(2,2,96);
trREnoz = nan(2,2,96);
% identify channels that are responsive  and in stimuli with both eyes
binocCh = data.trRE.inStim & data.trRE.goodCh & data.trLE.inStim & data.trLE.goodCh;
LEchs = data.trLE.inStim & data.trLE.goodCh;
REchs = data.trRE.inStim & data.trRE.goodCh;

for ch = 1:96
    % get the max orientation
    chDps = squeeze(data.trLE.linBlankDprime(:,end,:,:,ch));
    [~,maxNdx] = max(chDps,[],'all','linear');
    [maxOri,~] = ind2sub(size(chDps),maxNdx);
    
    maxOriMatLE = squeeze(chDps(maxOri,:,:));
    
    chDps = squeeze(data.trRE.linBlankDprime(:,end,:,:,ch));
    [~,maxNdx] = max(chDps,[],'all','linear');
    [maxOri,~] = ind2sub(size(chDps),maxNdx);
    
    maxOriMatRE = squeeze(chDps(maxOri,:,:));
    
    if binocCh(ch) == 1
        trLE(:,:,ch) = maxOriMatLE;
        trRE(:,:,ch) = maxOriMatRE;
        
        trLEnoz(:,:,ch) = squeeze(data.trLE.noiseBlankDprime(1,1,:,:,ch));
        trREnoz(:,:,ch) = squeeze(data.trRE.noiseBlankDprime(1,1,:,:,ch));
    elseif LEchs(ch) == 1 && REchs(ch) == 0
        trLE(:,:,ch) = maxOriMatLE;
        trRE(:,:,ch) = zeros(2,2,1);
        
        trLEnoz(:,:,ch) = squeeze(data.trLE.noiseBlankDprime(1,1,:,:,ch));
        trREnoz(:,:,ch) = zeros(2,2,1);
    elseif LEchs(ch) == 0 && REchs(ch) == 1
        trLE(:,:,ch) = zeros(2,2,1);
        trRE(:,:,ch) = maxOriMatRE;
        
        
        trLEnoz(:,:,ch) = zeros(2,2,1);
        trREnoz(:,:,ch) = squeeze(data.trRE.noiseBlankDprime(1,1,:,:,ch)); 
    end
end