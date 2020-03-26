classdef arraymap
    
    properties
        id           = 'ID Not specified';
        filename     = '';
        nChannels;
        col          = zeros(96,1);
        row          = zeros(96,1);
        bank         = char( 96,1);
        elect        = zeros(96,1);
        label        = cell( 96,1);
        channel      = zeros(96,1);
        channelndx   = zeros(96,1);
    end
    
    properties (SetAccess = private, Hidden = true)
        corticalarea = zeros(96,1);
    end
    
    methods
        % constructor
        function obj = arraymap(filename)
            % creates an arraymap object from a filename
            % function obj = arraymap(filename)
            %
            % If the filename is not in the path, it needs to be full
            % qualified (full path).
            %
            % log:
            % 2014-10-14 - Updated to support black's arrays. - rdk
            %
            % Valid Methods:
            % see also arraymap.subplot, arraymap.imagesc, arraymap.showmap
            try
                [p,f,e] = fileparts(filename);
                if isempty(p)
                    tmp = regexp(filename,'m(\d{3})\w','tokens');
                    if ~isempty(tmp)
                        p = sprintf('/experiments/m%s_array/mapping/',tmp{1}{1});
                        filename = [p f e];
                    end
                end
                obj.filename = filename;
                if ~exist(filename,'file')
                    error('File %s does not exist.\n', filename);
                end
                fid = fopen(filename, 'r');
                if fid<0
                    error('Cannot open: %s\n', filename);
                end
                cnt = 0;
                try
                    while true
                        line = fgetl(fid);
                        % check for EOF (line == -1)
                        if ~ischar(line)
                            break;
                        end
                        % remove extra whitespace
                        line = strtrim(line);
                        % is it blank line or a comment line?
                        if isempty(line) || line(1)=='/'
                            continue;
                        end
                        % scan the line in
                        L = textscan(line, '%f%f%c%f%s');
                        % if the first element is empty, then it's a Map ID
                        % line. Otherwise, it's a data line
                        if isempty(L{1})
                            obj.id = line;
                        else
                            cnt = cnt + 1;
                            [obj.col(cnt,1), obj.row(cnt,1), obj.bank(cnt,1), obj.elect(cnt,1), obj.label{cnt,1}] = deal(L{:});
                            
                        end
                    end
                    fclose(fid);
                catch err
                    fclose(fid);
                    rethrow(err);
                end
                % calculate blackrock channel
                obj.nChannels = cnt;
                if cnt > 0
                    obj.channel = (obj.bank-'A')*32+obj.elect;
                    [~,obj.channelndx] = sort(obj.channel);
                end
                
                tmp             = regexp(filename,'m(\d{3})(\w\d)\.cmp','tokens');
                if isempty(tmp)
                    tmp            = regexp(filename,'(black_\w+).cmp','tokens');
                end
                
                if ~isempty(tmp)
                    monkey      = [];
                    switch tmp{1}{1}
                        case 'black_analog'
                            hemisphere  = 'black_analog';
                        case 'black_digital'
                            hemisphere  = 'black_digital';
                        case 'black_analog2'
                            hemisphere  = 'black_analog';
                        case 'black_digital2'
                            hemisphere  = 'black_digital';
                        otherwise
                            monkey      = str2double(tmp{1}{1});
                            hemisphere  = tmp{1}{2};
                    end
                    
                    try
                        fid     = fopen('/experiments/maps/corticalassignments.csv');
                        ca      = textscan(fid,'%s',1,'delimiter','\n');
                        fclose(fid);
                        %tmp     = regexp(ca{1},'\d{3}[lr]\d','match');
                        tmp     = regexp(ca{1},'(\d{3}[lr]\d)|(\w+)','match');
                        labels  = tmp{1}(2:end);
                        % GET ASSIGNMENTS
                        matrix = csvread('/experiments/maps/corticalassignments.csv',1,1); % ignore header, ignore channel number
                        tmp = matrix(:,strcmp(labels,sprintf('%d%s',monkey,hemisphere)));
                        obj.corticalarea = tmp(obj.channel);
                    catch err
                        rethrow(err);
                    end
                    
                end
                
            catch me
                help arraymap;
                rethrow(me);
            end
        end
        
        function varargout = subplot(obj,varargin)
            % subplot(obj,nRows,nCols,channel)
            % subplot(obj,channel) % assumes 10x10
            switch nargin
                case 2
                    a = 10;
                    b = 10;
                    ch = varargin{1};
                case 4
                    a = varargin{1};
                    b = varargin{2};
                    ch = varargin{3};
                otherwise
                    help arraymap/subplot;
                    error('arraymap:inputerror','Incorrect number of parameters given.');
            end
            % subplot(arraymap object, number of rows, number of columns, channel number)
            try
                maxrow = max(obj.row);
                maxcol = max(obj.col);
                ndx = (maxrow-obj.row(obj.channelndx(ch)))*(maxcol+1) + obj.col(obj.channelndx(ch)) + 1;
                if nargout == 1
                    varargout{1} = subplot(a,b,ndx);
                else
                    subplot(a,b,ndx);
                end
            catch me
                help arraymap.subplot;
                rethrow(me);
            end
        end
        
        function varargout = imagesc(obj,data,varargin)
            % imagesc(arraymap,data,...)
            % where arraymap is the arraymap object
            %       data     is a 1D vector organized by blackrock channel number.
            % additional imagesc parameters can be passed.
            % An optional output can be assigned to retrieve the image handle
            % Should always be displayed in axis IJ. for XY, use imagescXY;
            % See also arraymap arraymap.imagescIJ arraymap.imagescXY
            try
                img = nan(max(obj.row)+1,max(obj.col)+1);
                nDims = numel(size(data));
                if ~((nDims == 2)&&((size(data,1)==1)||(size(data,2)==1)))
                    error('Only 1D vector is allowed as input');
                end
                % make image
                img((obj.col(obj.channelndx))*max(obj.row+1)+(max(obj.row+1)-obj.row(obj.channelndx))) = reshape(data,numel(data),1);
                if nargout == 1
                    varargout{1}=imagesc(img,varargin{:});
                else
                    imagesc(img,varargin{:});
                end
            catch me
                help arraymap.imagesc;
                rethrow(me);
            end
        end
        
        function varargout = imagescIJ(varargin)
            % see also arraymap.imagesc
            if nargout == 1
                varargout{1}=imagesc(varargin{:});
            else
                imagesc(varargin{:});
            end
        end
        
        function varargout = imagescXY(obj,data,varargin)
            % imagesc(arraymap,data,...)
            % where arraymap is the arraymap object
            %       data     is a 1D vector organized by blackrock channel number.
            % additional imagesc parameters can be passed.
            % An optional output can be assigned to retrieve the image handle
            % Should always be displayed in axis XY.
            % See also arraymap
            try
                img = nan(max(obj.row)+1,max(obj.col)+1);
                nDims = numel(size(data));
                if ~((nDims == 2)&&((size(data,1)==1)||(size(data,2)==1)))
                    error('Only 1D vector is allowed as input');
                end
                % make image
                img((obj.col(obj.channelndx))*max(obj.row+1)+(1+obj.row(obj.channelndx))) = reshape(data,numel(data),1);
                if nargout == 1
                    varargout{1}=imagesc(img,varargin{:});
                    axis xy;
                else
                    imagesc(img,varargin{:});
                    axis xy;
                end
            catch me
                help arraymap.imagesc;
                rethrow(me);
            end
        end
        
        function varargout = dist(obj,channels)
            % dist(arraymap,channels)
            % returns the euclidean distance in um between electrodes with
            % channel numbers provided in the vector "channels". arraymap
            % is an arraymap object.
            %
            % see also arraymap
            if ~exist('channels','var')
                return;
            end
            switch numel(channels)
                case 0
                    varargout{1} = [];
                case 1
                    varargout{1} = 0;
                case 2
                    varargout{1} = pdist(0.400.*[obj.col(obj.channelndx(channels)) obj.row(obj.channelndx(channels))],'euclidean');
                otherwise
                    varargout{1} = squareform(pdist(0.400.*[obj.col(obj.channelndx(channels)) obj.row(obj.channelndx(channels))],'euclidean'));
            end
        end
        
        function showmap(obj,opt)
            % showmap(arraymap,['area'])
            % where arraymap is the arraymap object
            %       'area' is an optional flag used to display cortical area assignments.
            % See also arraymap
            opton = 0;
            if exist('opt','var')
                if ischar(opt)
                    if strcmpi(opt,'area')
                        opton = 1;
                    end
                end
            end
            try
                figure(999);
                clf;
                set(gcf,'color','w','position',[10 500 500 500],'toolbar','none','resize','off');
                maxsize = 0.85;
                subplot('position',[(1-maxsize*.9)/2 (1-maxsize)/2 maxsize maxsize]);
                maxX = max(obj.col);
                maxY = max(obj.row);
                axis([0 maxX+2 -.5 maxY+1.5]);
                axis off xy square;
                patch([0 0 maxX+1 maxX+1],[0 maxY+1 maxY+1 0],'k');
                for ii=1:obj.nChannels
                    if opton
                        switch obj.corticalarea(ii)
                            case 0
                                patch(obj.col(ii)+[0 0 1 1],obj.row(ii)+[0 1 1 0],[.5 .5 .5]);
                            case 1
                                patch(obj.col(ii)+[0 0 1 1],obj.row(ii)+[0 1 1 0],[1 .25 .25]);
                            case 1.5
                                patch(obj.col(ii)+[0 0 1 1],obj.row(ii)+[0 1 1 0],[1 .5 .25]);
                            case 2
                                patch(obj.col(ii)+[0 0 1 1],obj.row(ii)+[0 1 1 0],[.25 1 .25]);
                            case 4
                                patch(obj.col(ii)+[0 0 1 1],obj.row(ii)+[0 1 1 0],[.25 .25 1]);
                        end
                        ylabel({'Areas: \color[rgb]{1 .25 .25}V1 \color[rgb]{0 0 0}| \color[rgb]{1 .5 .25}V1/V2 \color[rgb]{0 0 0}| \color[rgb]{.25 1 .25}V2 \color[rgb]{0 0 0}| \color[rgb]{.25 .25 1}V4 \color[rgb]{0 0 0}| \color[rgb]{.5 .5 .5}Missing','\color[rgb]{0 0 0}Numbers are blackrock channel numbers'},'FontWeight','bold','visible','on');
                    else
                        switch obj.bank(ii)
                            case 'A'
                                patch(obj.col(ii)+[0 0 1 1],obj.row(ii)+[0 1 1 0],[1 .25 .25]);
                            case 'B'
                                patch(obj.col(ii)+[0 0 1 1],obj.row(ii)+[0 1 1 0],[.25 1 .25]);
                            case 'C'
                                patch(obj.col(ii)+[0 0 1 1],obj.row(ii)+[0 1 1 0],[.25 .25 1]);
                        end
                        ylabel({'Banks: \color[rgb]{1 .25 .25}A \color[rgb]{.25 1 .25}B \color[rgb]{.25 .25 1}C','\color[rgb]{0 0 0}Numbers are blackrock channel numbers'},'FontWeight','bold','visible','on');
                    end
                    text(obj.col(ii)+0.5,obj.row(ii)+0.45,sprintf('%02d',obj.channel(ii)),...
                        'HorizontalAlignment','center',...
                        'VerticalAlignment','middle',...
                        'FontSize',12,...
                        'FontName','Helvetica',...
                        'FontAngle','Oblique',...
                        'FontWeight','Bold');
                    
                end
                title(strrep(obj.filename,'_','\_'),'FontWeight','bold','visible','on');
                xlabel(obj.id,'FontWeight','bold','visible','on');
                for ii=-.8:.4:.8
                    line(maxX+1+[0 .5],((maxY+1)/2 + ii).*[1 1],'color','k','linewidth',5);
                end
                text(maxX+2,(maxY+1)/2,'Wire','Rotation',90,...
                    'HorizontalAlignment','center',...
                    'VerticalAlignment','bottom',...
                    'FontSize',12,...
                    'FontName','Helvetica',...
                    'FontWeight','Bold');
            catch me
                rethrow(me);
            end
        end
        
        function out = area(obj,ch)
            if ~exist('ch','var')
                ch = 1:obj.nChannels;
            end
            out = obj.corticalarea(obj.channelndx(ch));
        end
        
        function out = arealabels(obj,ch)
            if ~exist('ch','var')
                ch = 1:obj.nChannels;
            end
            out = cell(length(ch),1);
            for ii=1:length(ch)
                switch obj.corticalarea(obj.channelndx(ch(ii)))
                    case 0
                        out{ii} = 'Missing';
                    case 1
                        out{ii} = 'V1';
                    case 1.5
                        out{ii} = 'V1/V2 Border';
                    case 2
                        out{ii} = 'V2';
                    case 4
                        out{ii} = 'V4';
                end
            end
        end
    end
end