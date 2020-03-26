function aMap = getBlackrockArrayMap(filename)
% Get map for the array channels.
%
% 09/06/18 -- note, this only has info so far for WU's arrays. 
% 11/08/18 -- updated with array information for XT and WV

if contains(filename,'nsp2')
    disp 'data recorded from nsp2, V4 array'
    
    if contains(filename,'WU')
        aMap = arraymap('SN 1024-001795.cmp');
    elseif contains(filename,'XT')
        aMap = arraymap('SN1024-001854.cmp');
    elseif contains(filename,'WV')
        aMap = arraymap('SN1024-001851.cmp');
    elseif contains(filename,'XX')
        aMap = arraymap('SN1024-001826.cmp');
    else
        error('Cannot determine animal identity from filename')
    end
    
elseif contains(filename,'nsp1')
    disp 'data recorded from nsp1, V1/V2 array'
    
    if contains(filename,'WU')
        aMap = arraymap('SN 1024-001795.cmp');
    elseif contains(filename,'XT')
        aMap = arraymap('SN1024-001852.cmp');
    elseif contains(filename,'WV')
        aMap = arraymap('SN1024-001848.cmp');
    elseif contains(filename,'XX')
        aMap = arraymap('SN1024-002156.cmp');
    else
        error('Cannot determine animal identity from filename')
    end
    
else
    error('Error: array ID missing or wrong')
end
