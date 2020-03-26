clear all
clc
cd '~/Dropbox/v4Data/TestData/'
%filename = '/volumes/BBArrayData/TestData/WU_gratmap_test_20170110_003.mwk';
filename = 'WU_gratmap_test_20170110_003.mwk';
%%
tic;
if ~exist(filename, 'file')
    error ('MwksMergeMWKandNEV:MWKfile', 'File: %s was not found.\n', filename)
else
    
    [pm,nm,em] = fileparts(filename);
    if ~strcmpi(em, '.mwk')
        error ('MwksMergeMWKandNEV:MWKfile','File: %s is not an MWK file.\n', filename)
    end
end

%%

disp ('Getting information from MWorks File')
% Create cell of codes for all tags
timeCodecs = getCodecs(filename);
codecs     = struct2cell(timeCodecs.codec);

% pull out the codes that correspond to the desired tag
windx   = 1;
dispndx = 1;
for i = 1:length(codecs)
    if strcmp('wordout_var',codecs(11,:,i))
        wordCode(windx,1)  = codecs(1,:,i);
        windx = windx+1;
    end
end
wordCode = cell2mat(wordCode);

% NOTE: ALL TIMESTAMPS ARE IN MICROSECONDS (us)

% get the information on when the event occurred. Returs a structure with
% the code, time stamps, and relevent data.
wordEvents = getEvents(filename,wordCode);
wordTime   = {wordEvents.time_us};
wordTime   = cell2mat(wordTime);

% get stimulus information

stimInfo = getStimInfo(filename, );

%% Plot
a = ones(size(wordTime));
for t = 1:length(a)
    a(t) = a(t)*rand;
end

figure
plot(wordTime(1:100),a(1:100),'x')
set(gca,'Color','none','FontAngle','italic','FontSize',12,'FontWeight',...
            'bold','MinorGridLineStyle','-','TickDir','out','TickLength',[0.015 0.03],...
            'XMinorTick','on', 'box','off')
xlabel('timestamp (us)')





toc;