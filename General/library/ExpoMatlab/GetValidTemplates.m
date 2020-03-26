function valids = GetValidTemplates(ExpoXMLimport)

valids = zeros(128,257);

for ii=1:128
    for jj = 1:257
        valids(ii,jj) = GetSpikeNum(ExpoXMLimport,ii,jj);
    end
end

valids = ~isnan(valids);