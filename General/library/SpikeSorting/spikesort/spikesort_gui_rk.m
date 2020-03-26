function spikesort_gui_rk(operation)

global Handles;
global FileInfo;
global WaveformInfo;

if (strcmp(operation,'load') == 0)
    if WaveformInfo.ChannelNumber == 0
        return
    end
end

%For keyboard support... -03Apr2013 Adam C. Snyder
key = get(Handles.mainFigure,'currentcharacter');
charNum = double(key);
        
if ~(strcmp(operation,'changeHistory')||strcmp(operation,'keyfcn')&&isempty(charNum)||strcmp(operation,'keyfcn')&&charNum==8) %changed to support backspace to step back through history -03Apr2013 Adam C. Snyder
    checkHistoryChange();
end

set(Handles.mainFigure,'Pointer','watch');

switch(operation)
    case 'keyfcn'        
        if ~isempty(charNum)
            switch charNum
                case 8 %the backspace key
                    %We inactivated this function 05AUG2013 -ACS
%                     %step back through history
%                     if numel(get(Handles.history,'string'))>1
%                         set(Handles.history,'Value',get(Handles.history,'Value')-1);
%                         set(gcf,'selectiontype','open'); %needed to get the callback to evaluate
%                         spikesort_gui_rk('changeHistory');
%                     elseif numel(get(Handles.history,'string'))==1
%                         spikesort_gui_rk('clear_history');
%                     end;
                case num2cell([28,29]) %left or right arrows
                    %move sort code
                    currentCode = get(Handles.sortCodes,'value');
                    if charNum==28,
                        moveCode = min(currentCode)-1;
                        if moveCode<1, moveCode = 1; end;
                    else
                        moveCode = max(currentCode)+1;
                        if moveCode > numel(get(Handles.sortCodes,'string')); end;
                    end;
                    set(Handles.sortCodes,'value',moveCode);
                    spikesort_gui_rk('update');
                case num2cell([30,31]) %up or down arrows
                    %move channel
                    currentCode = get(Handles.channel,'value');
                    if charNum==30,
                        moveCode = min(currentCode)-1;
                        if moveCode<1, moveCode = 1; end;
                    else
                        moveCode = max(currentCode)+1;
                        if moveCode > numel(get(Handles.channel,'string')); end;
                    end;
                    set(Handles.channel,'value',moveCode);
                    spikesort_gui_rk('load');
                case 32 %spacebar
                    %Resample waveforms:
                    spikesort_gui_rk('sample');
                case num2cell([48:57,127]) %the number keys (0-9) or the delete key
                    %Move the spikes to the indicated sort code:
                    if charNum==127, %i.e., the delete key
                        set(Handles.toMove,'value',1); %i.e., move to sort code 255                        
                    else
                        match = find(ismember(get(Handles.toMove,'string'),key));
                        if isempty(match)
                            set(Handles.toMove,'value',numel(get(Handles.toMove,'string')));
                        else
                            set(Handles.toMove,'value',match);
                        end;
                    end;
                    spikesort_gui_rk('moveSelected'); %move the selected spikes to the sort code indicated
                    selectSpikes([1.5 -1000],[1.51 -1001],'normal');
                    drawSpikes;                    
                case 97 %'a'
                    %do nothing for now --will make 'select all' option
                    %later. Need to work into the perform history function
                    %as well... -ACS
                case 105 %'i'
                    invertSpikeSelection;
                    set(Handles.history,'String',[get(Handles.history,'String'); {'Invert selection'}]);
                    set(Handles.history,'Value',length(get(Handles.history,'String')));
                    set(Handles.history,'UserData',[get(Handles.history,'UserData'); {'invert',{}}]);
                    drawSpikes;                    
                otherwise
                    display(charNum);
            end;
        end;
    case 'load'
        if (WaveformInfo.ChannelNumber ~= 0)
            UserData = get(Handles.history,'UserData');
            Value = get(Handles.history,'Value');
            String = get(Handles.history,'String');
            
            save(sprintf('spikesortunits/hist%i',WaveformInfo.ChannelNumber),'UserData','Value','String');
            
            loc = find(WaveformInfo.ChannelNumber == get(Handles.channel,'UserData'));
            
            s_all = get(Handles.channel,'String');
            s = s_all{loc};
            s = s(1:strfind(s,')'));
            
            if size(UserData,1) > 0
                s_all{loc} = [s ' *'];
            else
                s_all{loc} = s;
            end
            set(Handles.channel,'String',s_all);
        end
        
        channelIndex = get(Handles.channel,'Value');
        
        ChannelInfo= get(Handles.channel,'UserData');
        ChannelNumber=ChannelInfo(channelIndex);
        
        %        possibleUnits = zeros(256,1);
        
        %        for h=1:length(FileInfo)
        %            load(['spikesortunits/' FileInfo(h).filename '.mat']);
        %            possibleUnits = possibleUnits + units{ChannelNumber}; %#ok<USENS>
        %        end
        
        possibleUnits = [];
        for i = find(cellfun(@ismember,repmat({ChannelNumber},size(FileInfo)),{FileInfo.ActiveChannels})), %changed from "i=1:length(FileInfo)" so that now it only checks files that contain the current channel -21Mar2013 -Adam C. Snyder
            possibleUnits = unique([possibleUnits(:); ...
                find(FileInfo(i).units{ChannelNumber})-1]);
        end
        
        WaveformInfo.possibleUnits = [{255} {0} reshape(num2cell(setdiff(possibleUnits,[0 255])),1,[])];
        
        loadWaveforms(ChannelNumber);
        unitmap = WaveformInfo.possibleUnits;
        
        set(Handles.sortCodes,'String',unitmap,'Value',2:length(unitmap));
        unitmap{end+1} = 'new';
        set(Handles.toMove,'String',unitmap);
        
        WaveformInfo.sortCodes = get(Handles.sortCodes,'Value');
        
        if exist(sprintf('spikesortunits/hist%i.mat',WaveformInfo.ChannelNumber),'file') == 2
            load (sprintf('spikesortunits/hist%i',WaveformInfo.ChannelNumber));
            
            set(Handles.history,'Value',Value);
            set(Handles.history,'UserData',UserData);
            set(Handles.history,'String',String);
            
            performHistory(UserData);
        else
            set(Handles.history,'Value',0);
            set(Handles.history,'UserData',[]);
            set(Handles.history,'String',[]);
        end
        
        WaveformInfo.historyValue = -1;
        
        drawHists();
        drawSpikes();
        drawRasters();
    case 'clear_history'
        set(Handles.history,'Value',0);
        set(Handles.history,'UserData',[]);
        set(Handles.history,'String',[]);
        
        spikesort_gui_rk load
        %    case 'redraw'
        %        drawSpikes();
    case 'sample'
        WaveformInfo.display = [];
        drawSpikes();
    case 'update'
        WaveformInfo.sortCodes = get(Handles.sortCodes,'Value');
        drawSpikes();
        
        chanStrings = get(Handles.sortCodes,'String');
        chanString = '';
        for i = 1:length(WaveformInfo.sortCodes)
            chanString = [chanString num2str(str2doubleParen(chanStrings{WaveformInfo.sortCodes(i)})) ', ']; %#ok<AGROW>
        end
        set(Handles.history,'String',[get(Handles.history,'String'); {['Selected channels: ' chanString]}]);
        set(Handles.history,'Value',length(get(Handles.history,'String')));
        set(Handles.history,'UserData',[get(Handles.history,'UserData'); {'channels',WaveformInfo.sortCodes}]);
    case 'moveSelected'
        code = get(Handles.toMove,'Value');
        
        moveSpikes(code);
        
        set(Handles.history,'UserData',[get(Handles.history,'UserData'); {'move',code}]);
        
        %        if (code ~= 'new')
        %            codeStr = num2str(code);
        %        end
        
        drawSpikes();
        
        chanStrings = get(Handles.toMove,'String');
        set(Handles.history,'String',[get(Handles.history,'String'); {['Move selected spikes to ' chanStrings{code}]}]);
        set(Handles.history,'Value',length(get(Handles.history,'String')));
        
        drawHists();
        drawRasters();
        
    case 'box'
        [point1 point2 status] = rubberbandbox3(Handles.plotHandle);
        
        %         if ~all(point1==point2), %i.e., selection box has non-trivial area
        selectSpikes(point1,point2,status);
                
        set(Handles.history,'String',[get(Handles.history,'String'); {['Select spikes for ' status ' between ' num2str(point1) ' and ' num2str(point2)]}]);
        set(Handles.history,'Value',length(get(Handles.history,'String')));
        set(Handles.history,'UserData',[get(Handles.history,'UserData'); {'box',{point1,point2,status}}]);
        
        drawSpikes();
        drawRasters();
        %         end;
    case 'rasterLim'
        [x, y, button] = ginput(1);
        changed = 1;
        
        if button == 1
            restrictToSpikes(x,WaveformInfo.right);
        elseif button == 3
            restrictToSpikes(WaveformInfo.left,x);
        elseif button == 8
            resetWaveformBounds();
        else
            changed = 0;
        end
        
        if changed
            drawSpikes();
            drawHists();
            drawRasters();
            
            set(Handles.history,'String',[get(Handles.history,'String'); {['Restrict to between ' num2str(WaveformInfo.left) ' and ' num2str(WaveformInfo.right)]}]);
            set(Handles.history,'Value',length(get(Handles.history,'String')));
            set(Handles.history,'UserData',[get(Handles.history,'UserData'); {'restrict',{WaveformInfo.left,WaveformInfo.right}}]);
        end
    case 'threshold'
        [x,y]=ginput(1);
        
        setThreshold(x,y);
        
        drawSpikes();
        
        set(Handles.history,'String',[get(Handles.history,'String'); {['Set threshold to ' num2str(x) ', ' num2str(y)]}]);
        set(Handles.history,'Value',length(get(Handles.history,'String')));
        set(Handles.history,'UserData',[get(Handles.history,'UserData'); {'set',{x,y}}]);
    case 'set_scalefactor'
        drawSpikes();
    case 'clear_threshold'
        clearThresholds();
        
        drawSpikes();
        
        set(Handles.history,'String',[get(Handles.history,'String'); {'Clear thresholds'}]);
        set(Handles.history,'Value',length(get(Handles.history,'String')));
        set(Handles.history,'UserData',[get(Handles.history,'UserData'); {'clear',{}}]);
    case 'changeHistory'
        if strcmp(get(gcf,'SelectionType'),'open')
            WaveformInfo.historyValue = get(Handles.history,'Value');
            UserData = get(Handles.history,'UserData');
            
            loadWaveforms(WaveformInfo.ChannelNumber);
            performHistory(UserData(1:WaveformInfo.historyValue,:));
            
            drawSpikes();
            drawHists();
            drawRasters();
        end
    case 'write'
        button = questdlg('Are you totally fucking sure?',...
            'Write all files?','Yes','No','No');
        
        if strcmp(button,'Yes')
            spikesort_gui_rk load
            
            %Hide figures while writing files: -Adam C. Snyder 15Apr2013
            set(Handles.historyFigure,'visible','off');
            set(Handles.mainFigure,'visible','off');
            
            ud = get(Handles.channel,'UserData');
            
            changedChannels = [];
            for i = 1:length(ud)
                if exist(sprintf('spikesortunits/hist%i.mat',ud(i)),'file') == 2
                    load (sprintf('spikesortunits/hist%i',ud(i)));
                    
                    if size(UserData,1) > 0 %#ok<NODEF>
                        changedChannels = [changedChannels ud(i)]; %#ok<AGROW>
                    end
                end
            end
            
            warning('off','MATLAB:hg:uicontrol:ListboxTopMustBeWithinStringRange'); %turn off this warning so that it doesn't blow up the command window -ACS 05Apr2013
            h = waitbar(0,'Writing files...');
            for i = 1:length(changedChannels)
                %          possibleUnits = zeros(256,1);
                %          for k = 1:length(FileInfo)
                %            load(['spikesortunits/' FileInfo(k).filename '.mat']);
                %            possibleUnits = possibleUnits + units{changedChannels(i)};
                %          end
                
                possibleUnits = [];
                for j = find(cellfun(@ismember,repmat({changedChannels(i)},size(FileInfo)),{FileInfo.ActiveChannels})), %changed from "=1:length(FileInfo)" so that now it only checks files that contain the current channel -21Mar2013 -Adam C. Snyder
                    possibleUnits = unique([possibleUnits(:); ...
                        find(FileInfo(j).units{changedChannels(i)})-1]);
                end
                
                
                WaveformInfo.possibleUnits = [{255} {0} reshape(num2cell(setdiff(possibleUnits,[0 255])),1,[])];
                
                histFile = sprintf('spikesortunits/hist%i.mat',changedChannels(i)); %moved out of for loop below -ACS 05Aug2013
                load(histFile); %moved out of for loop below -ACS 05Aug2013
                for k = find(cellfun(@ismember,repmat({changedChannels(i)},size(FileInfo)),{FileInfo.ActiveChannels})), %changed from "=1:length(FileInfo)" so that now it only checks files that contain the current channel -21Mar2013 -Adam C. Snyder
                                        
                    getWaveforms(changedChannels(i),k);
                    
                    unitmap = WaveformInfo.possibleUnits;
                    
                    set(Handles.sortCodes,'String',unitmap,'Value',2:length(unitmap));
                    unitmap{end+1} = 'new'; %#ok<AGROW>
                    set(Handles.toMove,'String',unitmap);
                    
                    WaveformInfo.sortCodes = get(Handles.sortCodes,'Value');
                    
                    set(Handles.history,'Value',0);
                    set(Handles.history,'UserData',UserData);
                    set(Handles.history,'String',String);               %#ok<NODEF>
                    
                    performHistory(UserData);
                    spikesort_write2(k);
                    
                    waitbar(((i-1)*length(FileInfo)+k)/(length(FileInfo)*length(changedChannels)),...
                        h,...
                        sprintf('Writing files. Channel %d.',changedChannels(i))); %changed to give more feedback -Adam C. Snyder, 15Apr2013
                end
                
                loc = find(WaveformInfo.ChannelNumber == get(Handles.channel,'UserData'));
                
                s_all = get(Handles.channel,'String');
                s = s_all{loc};
                s = s(1:strfind(s,')'));
                
                s_all{loc} = s;
                set(Handles.channel,'String',s_all);
                
                delete(histFile);
            end
            close(h);
            
            readSampleWaveforms(changedChannels);
            
            %       h = waitbar(0,'Reading new waveforms');
            %       for i = 1:length(changedChannels)
            %         readSampleWaveforms(changedChannels(i));
            %         waitbar(i/length(changedChannels));
            %       end
            %       close(h);
            
            set(Handles.history,'Value',0);
            set(Handles.history,'UserData',[]);
            set(Handles.history,'String',[]);
            
            set(Handles.channel,'Value',1);
            
            %Show figures after writing files: -Adam C. Snyder 15Apr2013
            set(Handles.historyFigure,'visible','on');
            set(Handles.mainFigure,'visible','on');        
            
            spikesort_gui_rk load
        end
end
set(Handles.mainFigure,'Pointer','arrow');

function selectSpikes(point1, point2, status)
global Handles;
global WaveformInfo;

leftSide = max(0,min(point1(1),point2(1)));
rightSide = min(WaveformInfo.x2-.001,max(point1(1),point2(1)));
topSide = max(point1(2),point2(2));
bottomSide = min(point1(2),point2(2));

leftSide = leftSide*WaveformInfo.NumSamples/WaveformInfo.x2+1;
rightSide = rightSide*WaveformInfo.NumSamples/WaveformInfo.x2+1;

sortCodeArray = cellfun(@str2doubleParen,get(Handles.sortCodes,'String'));

p = find(ismember(WaveformInfo.Unit,sortCodeArray(WaveformInfo.sortCodes)));

within = zeros(size(WaveformInfo.Waveforms,1),floor(rightSide)-ceil(leftSide)+1);
within(p,:) = WaveformInfo.WaveformsAsShown(p,ceil(leftSide):floor(rightSide)) < topSide & WaveformInfo.WaveformsAsShown(p,ceil(leftSide):floor(rightSide)) > bottomSide;

within = sum(within,2)';

switch (status)
    case 'normal'
        within = intersect(p,find(within));
        WaveformInfo.selected = within;
        WaveformInfo.selected = intersect(WaveformInfo.selected,find(WaveformInfo.restrictedSet));
    case 'extend'
        within = intersect(p,find(within));
        within = intersect(within,find(WaveformInfo.restrictedSet));
        WaveformInfo.selected = union(WaveformInfo.selected,within);
    case 'alt'
        oldSelected = WaveformInfo.selected;
        
        if isempty(oldSelected)
            within = intersect(p,find(within==0));
            WaveformInfo.selected = within;
            WaveformInfo.selected = intersect(WaveformInfo.selected,find(WaveformInfo.restrictedSet));
        else
            within = intersect(p,find(within));
            within = intersect(within,find(WaveformInfo.restrictedSet));
            WaveformInfo.selected = setdiff(WaveformInfo.selected,within);
        end
end

function invertSpikeSelection
global Handles;
global WaveformInfo;

sortCodeArray = cellfun(@str2doubleParen,get(Handles.sortCodes,'String'));

p = find(ismember(WaveformInfo.Unit,sortCodeArray(WaveformInfo.sortCodes)));

WaveformInfo.selected = setdiff(p,WaveformInfo.selected);


function moveSpikes(code)
global Handles;
global WaveformInfo;

moveStrings = get(Handles.toMove,'String');
newCode = moveStrings{code};

if strcmp(newCode,'new')
    moveInts = cellfun(@str2double,moveStrings(1:end-1));
    
    possibilities = setdiff(0:255, moveInts);
    
    moveStrings{end} = num2str(possibilities(1));
    set(Handles.sortCodes,'String',moveStrings);
    set(Handles.sortCodes,'Value',[get(Handles.sortCodes,'Value') length(moveStrings)]);
    WaveformInfo.sortCodes = [WaveformInfo.sortCodes length(moveStrings)];
    
    moveStrings{end+1} = 'new';
    
    set(Handles.toMove,'String',moveStrings);
    newCode = possibilities(1);
else
    newCode = str2double(newCode);
end

%    newColor = colors(code,:);

WaveformInfo.Unit(WaveformInfo.selected) = newCode;
%    set(Handles.plot(WaveformInfo.selected),'Color',newColor);

%    keep = 0;

%    overlap = intersect(code,get(Handles.sortCodes,'Value'));

%    if overlap
%      set(Handles.plot(WaveformInfo.selected),'Visible','on');
% else
%    set(Handles.plot(WaveformInfo.selected),'Visible','off');
%end

function performHistory(history)
global Handles;
global WaveformInfo;

for i = 1:size(history,1)
    set(Handles.history,'Value',i);
    switch(history{i,1})
        case 'move'
            moveSpikes(history{i,2});
        case 'box'
            selectSpikes(history{i,2}{1},history{i,2}{2},history{i,2}{3});
        case 'set'
            setThreshold(history{i,2}{1},history{i,2}{2});
        case 'clear'
            clearThresholds();
        case 'channels'
            set(Handles.sortCodes,'Value',history{i,2});
            WaveformInfo.sortCodes = history{i,2};
        case 'restrict'
            restrictToSpikes(history{i,2}{1},history{i,2}{2});
        case 'invert'
            invertSpikeSelection;
    end
end


function clearThresholds()
global Handles;
global WaveformInfo;

sortCodeArray = cellfun(@str2doubleParen,get(Handles.sortCodes,'String'));

p = find(WaveformInfo.restrictedSet & ismember(WaveformInfo.Unit, ...
    sortCodeArray(WaveformInfo.sortCodes)));

WaveformInfo.Align(p) = 0;
WaveformInfo.WaveformsAsShown(p,:) = WaveformInfo.Waveforms(p,:);

function setThreshold(x,y)
global Handles;
global WaveformInfo;

x = ceil((x + .3333)*(WaveformInfo.NumSamples-1)/1.6+1);

sortCodeArray = cellfun(@str2doubleParen,get(Handles.sortCodes,'String'));

p = find(WaveformInfo.restrictedSet & ismember(WaveformInfo.Unit,sortCodeArray(WaveformInfo.sortCodes)));
if (y < 0)
    temp = y > WaveformInfo.Waveforms(p,:);
else
    temp = y < WaveformInfo.Waveforms(p,:);
end

for i=1:length(p)
    newAlign = find(temp(i,min(1,WaveformInfo.Align(p(i))+x):end));
    
    if ~isempty(newAlign)
        WaveformInfo.Align(p(i)) = newAlign(1)-10;
        
        WaveformInfo.WaveformsAsShown(p(i),:) = zeros(1,WaveformInfo.NumSamples);
        if WaveformInfo.Align(p(i)) < 0
            WaveformInfo.WaveformsAsShown(p(i),-WaveformInfo.Align(p(i))+1:end) = WaveformInfo.Waveforms(p(i),1:WaveformInfo.Align(p(i))+end);
        else
            WaveformInfo.WaveformsAsShown(p(i),1:end-WaveformInfo.Align(p(i))) = WaveformInfo.Waveforms(p(i),WaveformInfo.Align(p(i))+1:end);
        end
    end
end

function getWaveforms(ChannelNumber, fileIndex)
global Handles;
global WaveformInfo;
global FileInfo;

set(Handles.toMove,'Value',1);
WaveformInfo.ChannelNumber = ChannelNumber;

PacketNumbers = FileInfo(fileIndex).PacketOrder == ChannelNumber;

WaveformInfo.Waveforms = [];
WaveformInfo.Unit = [];
WaveformInfo.Times = [];

load(sprintf('spikesortunits/ch%i',ChannelNumber),'Breaks');
WaveformInfo.Breaks = Breaks;

loc = FileInfo(fileIndex).HeaderSize + FileInfo(fileIndex).Locations(PacketNumbers);
[wav,tim,uni] = readWaveforms(loc,WaveformInfo.NumSamples, ...
    FileInfo(fileIndex).filename);

wav = int16(double(wav) / 1000 * FileInfo(fileIndex).nVperBit(ChannelNumber));
WaveformInfo.Waveforms = wav';
WaveformInfo.Times = WaveformInfo.Breaks(fileIndex)+double(tim)/FileInfo(fileIndex).TimeResolutionTimeStamps*1000;
WaveformInfo.Unit = uni;

WaveformInfo.WaveformsAsShown = WaveformInfo.Waveforms;
WaveformInfo.Align = zeros(size(WaveformInfo.Waveforms,1),1);
WaveformInfo.selected = [];

resetWaveformBounds();

function loadWaveforms(ChannelNumber)
global Handles;
global WaveformInfo;

set(Handles.toMove,'Value',1);
WaveformInfo.ChannelNumber = ChannelNumber;

load(sprintf('spikesortunits/ch%i',ChannelNumber));

WaveformInfo.Waveforms = Waveforms;
WaveformInfo.Unit = Unit;
WaveformInfo.Times = Times;
WaveformInfo.Breaks = Breaks;

WaveformInfo.WaveformsAsShown = WaveformInfo.Waveforms;
WaveformInfo.Align = zeros(size(WaveformInfo.Waveforms,1),1);
WaveformInfo.selected = [];

resetWaveformBounds();

function drawSpikes()
global Handles;
global WaveformInfo;
global colors;

sortCodeArray = cellfun(@str2doubleParen,get(Handles.sortCodes,'String'));

sortCodes = get(Handles.sortCodes,'Value');
p = find(ismember(WaveformInfo.Unit,sortCodeArray(sortCodes)) & WaveformInfo.restrictedSet);

blockSize = str2double(get(Handles.blockSize,'String'));
if blockSize ~= length(WaveformInfo.display)
    s = sum(WaveformInfo.restrictedSet);
    
    r = randperm(s);
    restrictedIndices = find(WaveformInfo.restrictedSet);
    WaveformInfo.display = restrictedIndices(r(1:min(blockSize,s)));
end

axes(Handles.plotHandle);
%    cla;
%    axis tight
set(gca,'Nextplot','replaceChildren','FontSize',10);
%    xlabel('Time (ms)')
%    ylabel('microVolts')
Handles.plot = [];

if (get(Handles.holdTheLine,'Value') == 0)
    y1 = double(min(min(WaveformInfo.Waveforms(p,:))));
    y2 = double(max(max(WaveformInfo.Waveforms(p,:))));
else
    y1 = double(min(min(WaveformInfo.Waveforms)));
    y2 = double(max(max(WaveformInfo.Waveforms)));
end

maxMV = str2num(get(Handles.maxMV,'String'));

if length(maxMV) > 0
    y2 = min(y2,maxMV);
    y1 = max(y1,-maxMV);
end

tmprez1=800;
tmprez2=800;

sf = get(Handles.scalefactor,'value');

if ~isempty(WaveformInfo.selected)    
    sel = intersect(WaveformInfo.display,intersect(p,WaveformInfo.selected));
    unsel=intersect(WaveformInfo.display,setdiff(p,sel));
    
    if ~isempty(sel)
        if sf==10
            im = genSpikeMapColor(WaveformInfo.WaveformsAsShown(sel,:), ...
                WaveformInfo.Unit(sel),tmprez1,tmprez1,y1,y2,colors,max(1,round(log10(length(sel)/10))));
        else
            im = genSpikeMapColor_rk(WaveformInfo.WaveformsAsShown(sel,:), ...
                WaveformInfo.Unit(sel),tmprez1,tmprez1,y1,y2,colors,max(1,round(log10(length(sel)/10))));
            im = (im./max(im(:))).^(1/sf);
        end
    else
        im = zeros(tmprez1,tmprez1,3);
    end
    if ~isempty(unsel)
        if sf==10
            im2 = genSpikeMapColor(WaveformInfo.WaveformsAsShown(unsel,:), WaveformInfo.Unit(unsel),tmprez1,tmprez1,y1,y2,colors,max(1,round(log10(length(unsel)/10))))/3;
        else
            im2 = genSpikeMapColor_rk(WaveformInfo.WaveformsAsShown(unsel,:), WaveformInfo.Unit(unsel),tmprez1,tmprez1,y1,y2,colors,max(1,round(log10(length(unsel)/10))));
            im2 = ((im2./max(im2(:))).^(1/sf))/3;
        end
    else
        im2 = zeros(tmprez1,tmprez1,3);
    end
    
    im(im==0) = im2(im==0);
else
    p = intersect(WaveformInfo.display,p);
    if ~isempty(p)
        if sf==10
            im = genSpikeMapColor(WaveformInfo.WaveformsAsShown(p,:), ...
                WaveformInfo.Unit(p),tmprez2,tmprez2,y1,y2,colors,max(1,round(log10(length(p)/10))));
        else
            im = genSpikeMapColor_rk(WaveformInfo.WaveformsAsShown(p,:), ...
                WaveformInfo.Unit(p),tmprez2,tmprez2,y1,y2,colors,max(1,round(log10(length(p)/10))));
            im = (im./max(im(:))).^(1/sf);
        end
    else
        im = zeros(tmprez2,tmprez2,3);
    end
end

if sum(sum(sum(abs(im)))) == 0
    y1 = -1;
    y2 = 1;
end

%    axes(Handles.plotHandle);
i = imagesc([WaveformInfo.x1 WaveformInfo.x2],[y1 y2],1-im);
set(i,'ButtonDownFcn','spikesort_gui_rk box');
set(gcf,'WindowButtonUpFcn','uiresume(gcf)');

text((WaveformInfo.x2-WaveformInfo.x1)*.85+WaveformInfo.x1,(y2-y1)*.95+y1,num2str(length(WaveformInfo.selected)));

xlim([WaveformInfo.x1 WaveformInfo.x2]);
ylim([y1 y2]);


function drawHists()
global Handles;
global WaveformInfo;
global colors;

histLength = 50;

isiHandles = [Handles.ISINoise Handles.ISI1 Handles.ISI2 Handles.ISI3 Handles.ISI4];

snr = zeros(256,1);
for i = 1:length(WaveformInfo.possibleUnits)
    snr(WaveformInfo.possibleUnits{i}+1) = getSNR(WaveformInfo.Waveforms(WaveformInfo.Unit == WaveformInfo.possibleUnits{i}));
end

% waves{1} = WaveformInfo.Unit == 0 | WaveformInfo.Unit==255;
% waves{2} = WaveformInfo.Unit == 1;
% waves{3} = WaveformInfo.Unit == 2;
% waves{4} = WaveformInfo.Unit == 3;
% waves{5} = WaveformInfo.Unit == 4;

waves{1} = WaveformInfo.Unit == 0;
waves{2} = WaveformInfo.Unit == 1;
waves{3} = WaveformInfo.Unit == 2;
waves{4} = WaveformInfo.Unit == 3;
waves{5} = WaveformInfo.Unit == 4;

col = [256 2 3 4 5];

for i = 1:5
    waves{i} = waves{i} & WaveformInfo.restrictedSet;
    
    d = diff(WaveformInfo.Times(waves{i}));
    snr = length(find(waves{i}));
    %getSNR(WaveformInfo.Waveforms(waves{i},:));
    
    axes(isiHandles(i));
    cla;
    hist(d(d<histLength),(1:histLength)-.5);
    set(get(isiHandles(i),'Children'),'FaceColor',1-colors(col(i),:));
    axis tight
    xlim([0 histLength]);
    
    x = get(gca,'xlim');
    x = (x(2)-x(1))*.75+x(1);
    y = get(gca,'ylim');
    y = (y(2)-y(1))*.88+y(1);
    
    text(x,y,num2str(snr));
end

addSNRValues();

function addSNRValues()
global Handles;
global WaveformInfo;

codes = get(Handles.sortCodes,'String');

for i = 1:length(codes)
    code = str2doubleParen(codes{i});
    
    snr = getSNR(WaveformInfo.Waveforms(WaveformInfo.Unit == code,:));
    
    codes{i} = [num2str(code) ' (' num2str(snr,'%0.02f') ')'];
end

set(Handles.sortCodes,'String',codes);

function drawRasters()
global Handles;
global WaveformInfo;
global colors;

possible = cellfun(@str2doubleParen,get(Handles.sortCodes,'String'));
im = makeRasterImage();
maxTime = max(WaveformInfo.Times);

if ~isempty(WaveformInfo.selected)
    imSel = makeRasterImage(WaveformInfo.selected);
    
    im2 = zeros(size(im,1)*3,size(im,2),3);
    
    for i = 1:3;
        im2(1:3:end,:,i) = imSel(:,:,i);
        im2(2:3:end,:,i) = im(:,:,i);
        im2(3:3:end,:,i) = imSel(:,:,i);
    end
    im = im2;
    
    axes(Handles.rasterHandle);
    cla;
    
    i = imagesc([0 maxTime/1000],1:3*length(possible),flipdim(1-im,1));
    set(gca,'YTick',[2:3:3*length(possible)]);
    
    pos = 3*length(possible);
else
    axes(Handles.rasterHandle);
    cla;
    
    i = imagesc([0 maxTime/1000],1:length(possible),flipdim(1-im,1));
    
    set(gca,'YTick',[1:length(possible)]);
    
    pos = length(possible);
end

set(i,'ButtonDownFcn','spikesort_gui_rk rasterLim');

line([WaveformInfo.left WaveformInfo.left],[.5 pos+.5]);
line([WaveformInfo.right WaveformInfo.right],[.5 pos+.5]);

for i = 2:length(WaveformInfo.Breaks)
    l = line([WaveformInfo.Breaks(i) WaveformInfo.Breaks(i)]/1000,[.5 length(possible)+.5]);
    set(l,'Color','k');
end

axis tight

function im = makeRasterImage(spikeSubset)
global WaveformInfo;
global Handles;
global colors;

possible = cellfun(@str2doubleParen,get(Handles.sortCodes,'String'));

times = cell(1,length(possible));
for i = 1:length(possible)
    if nargin == 0;
        t = WaveformInfo.Unit==possible(i);
    else
        t = intersect(spikeSubset,find(WaveformInfo.Unit==possible(i)));
    end
    times{i} = WaveformInfo.Times(t);
end

maxTime = max(WaveformInfo.Times);

rows = zeros(length(times),WaveformInfo.rasterRes);
for i = 1:length(times)
    rows(i,:) = hist(round(times{i}/(maxTime/WaveformInfo.rasterRes)),(1:WaveformInfo.rasterRes)-.5);
end

im = zeros(size(rows,1),size(rows,2),3);
for i = 1:size(rows,1)
    im(i,:,:) = permute(colors(possible(i)+1,:)'*rows(i,:),[3 2 1]);
end

im = (im ./ max(rows(:))).^.25;

function restrictToSpikes(x1, x2)
global WaveformInfo;

if (x1 < x2)
    WaveformInfo.left = x1;
    WaveformInfo.right = x2;
end

%if type == 'l'
%    if WaveformInfo.right >= x
%        WaveformInfo.left = x;%(x/WaveformInfo.rasterRes)*maxTime/1000;
%    end
%elseif type =='r'
%    if WaveformInfo.left <= x
%        WaveformInfo.right = x;%/WaveformInfo.rasterRes)*maxTime/1000;
%    end
%end

WaveformInfo.restrictedSet = WaveformInfo.Times <= WaveformInfo.right*1000 & WaveformInfo.Times >= WaveformInfo.left*1000;
WaveformInfo.display = [];

function resetWaveformBounds()
global WaveformInfo;

restrictToSpikes(0,max(WaveformInfo.Times)/1000);

function checkHistoryChange()
global WaveformInfo;
global Handles;

if WaveformInfo.historyValue ~= -1
    UserData = get(Handles.history,'UserData');
    String = get(Handles.history,'String');
    set(Handles.history,'UserData',UserData(1:WaveformInfo.historyValue,:));
    set(Handles.history,'String',String(1:WaveformInfo.historyValue));
    
    WaveformInfo.historyValue = -1;
end

function s = str2doubleParen(s)
index = strfind(s,' (');

if isempty(index)
    s = str2double(s);
else
    s = str2double(s(1:index));
end