function times = GetPLXEventTimes(ExpoPLXimport,eventname)

if ~exist('ExpoPLXimport','var')
        error('ExpoPlexon:GetPLXEvent','No parameters given');
end

if ~exist('eventname','var')
    error('ExpoPlexon:GetPLXEvent','Please provide event name.');
end


times = ExpoPLXimport.Events.Times{find(~cellfun('isempty',strfind(lower(ExpoPLXimport.Events.Names),lower(eventname))),1)};

