function map = DDReadArrayMap(file_name, show_map)
% 
% function map = readArrayMap(file_name, show_map)
% 
% Input
%   file_name   map file. supported formats are: 
%                                   .cmp (Blackrock)
%   show_map
% 
% Output
%   map         the structure depends on the array type
% 
% Example:
% read a Blackrock .cmp file:
%   map = readArrayMap('SN1024-001032.cmp', true);
% 

% 
% RK, 10/27/2013
% 

    if nargin<2 || isempty(show_map)
        show_map = false;
    end
    
        %call the appropriate reader for the specified file format
    [~,~,ext] = fileparts(file_name);
    if strcmpi(ext,'.cmp')
        map = readCMP(file_name, show_map);
    else
        error('Unsupported file format');
    end
    
end


%% Blackrock's .cmp
function map = readCMP(file_name, show_map)
    
    map = struct('id', [], ...          %Map file description. includes array's serial number.
                 'loc', [], ...         %physical location of the channel on the array: [row col]
                 ...                    %   row is counted from bottom to top 
                 ...                    %   column is counted from left to right
                 ...                    %   ** the wire bundle is always on the left
                 'bank', [], ...        %the electrode bank that the channel belongs to. can be A, B, C, or D.
                 'bank_elec', [], ...   %the electrode number within the bank
                 'channel', [], ...     %channel number in the .nev files
                 'ground',  []);        %location of the ground electrodes
    
        %read the file
    fh = fopen(file_name, 'r');
    if fh<0
        error('cannot open %s', file_name);
    end
    try
        while 1
            line = fgetl(fh);
            if ~ischar(line)
                break;
            end
            line = strtrim(line);
            if isempty(line) || line(1)=='/'
                continue;
            end
            L = textscan(line, '%f%f%c%f%s');
            if isempty(L{1})
                map.id = line;
            else
                map.loc = [map.loc
                           L{2}+1,    L{1}+1];
                map.bank = [map.bank; L{3}];
                map.bank_elec = [map.bank_elec; L{4}];
                map.channel = [map.channel
                               (map.bank(end)-'A')*32+map.bank_elec(end)];
            end
            %disp(line);    %debug
        end
        fclose(fh);
    catch err
        fclose(fh);
        rethrow(err);
    end
    
        %find the ground electrodes
    pin = (map.loc(:,1)-1)*10+map.loc(:,2);
    ground_pin = setdiff((1:100)', pin);
    map.ground = [floor((ground_pin-1)/10)+1 mod(ground_pin-1,10)+1];
    
    
        %show the map
    if show_map
        [~,file_name] = fileparts(file_name);
        G = zeros(100,3);
        pin = map.loc(:,1)+(map.loc(:,2)-1)*10;
        ground_pin = map.ground(:,1)+(map.ground(:,2)-1)*10;
        G(pin(ismember(map.bank,'A')),1) = 1;       %bank A
        G(pin(ismember(map.bank,'B')),2) = 1;       %bank B
        G(pin(ismember(map.bank,'C')),3) = 1;       %bank C
        G(ground_pin,:) = 1;                        %grounds
        G = reshape(G,[10 10 3]);
        figure('Color', 'w', 'Position', [100 100 270 250], 'PaperPositionMode', 'auto');
        subplot('Position',[0.1 0.1 0.8 0.8]);
        hold on;
        imagesc(G);
        for i = 1 : length(pin)
            text(map.loc(i,2), map.loc(i,1), num2str(map.channel(i)), 'HorizontalAlignment', 'Center','FontWeight', 'bold');
        end
        for i = 1 : length(ground_pin)
            text(map.ground(i,2), map.ground(i,1), 'G', 'HorizontalAlignment', 'Center','FontWeight', 'bold');
        end
        text(11, 5, 'Array    Wire', 'FontSize', 14, 'FontWeight', 'bold', 'HorizontalAlignment', 'Center', 'Rotation', 90);
        plot(repmat([0.5;10.5],[1 11]), repmat(0.5:10.5,[2 1]), 'k');
        plot(repmat(0.5:10.5,[2 1]), repmat([0.5;10.5],[1 11]), 'k');
        set(gca, 'XLim', [0.5 11], 'XTick', 1:10, ...
                 'YLim', [0.5 11], 'YTick', 1:10, ...
                 'YDir', 'normal', 'TickDir', 'out');
        title({'','',file_name,'Banks: \color[rgb]{1 0 0}A \color[rgb]{0 1 0}B \color[rgb]{0 0 1}C'});
    end
end


