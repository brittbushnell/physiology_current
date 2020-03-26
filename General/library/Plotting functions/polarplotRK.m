function [varargout]=polarplot(theta,rho,varargin)
%[h, MaxRho] = polarerror(theta,rho,[OPTIONAL ARGUMENTS])
%
% INPUT ---------------------------------------
% theta  = matrix of orientations in degrees
%          each row represents a different plot
% rho    = amplitude of the response
%          each row represents a different plot
% OUTPUT --------------------------------------
% h      = handle to all the lines
% MaxRho = MaxRho used
%
% OPTIONAL ARGUMENTS --------------------------
% polarplot(...,'MaxRho',VALUE)
%  VALUE = maximum Rho overide (default = is 20% larger than max)
%
% polarplot(...,'ShowMaxRho',[on|off])
%  if "off", then MaxRho label will not be shown
%  default: "on"
%
% polarplot(...,'MinorTheta',[on|off])
%  if "on", then MinorTheta axes will be shown (@ 30 degree steps)
%  default: "off"
%
% polarplot(...,'MinorRho',[on|off])
%  if "on", then MinorRho rings will be shown (@ 3 divisions)
%  default: "off"
%
% polarplot(...,'ShowThetas',[on|off])
%  if "on", then theta labels will be shown (@ [0 90 180 270] degrees)
%  default: "off"
%
% polarplot(...,'FontSize',VALUE)
%  VALUE = font size for all text in points.
%  default: 10
%
% polarplot(...,'Color',VALUE)
%  VALUE = linespecs for plotting each row of Rho
%          values are comma or semicolon deliminated
%          format:
%
%           'color[markerstyle][linestyle][linewidth]'
%
%          See also plot. Examples to plot 3 values:
%           'r;g;b'  'ro-;g.-;bs-'  'r:1;g:1;b3'
%
% polarplot(...,'Wrap',[on|off])
% if on, then theta will wrap so that the first and last points 
% connect. default: on
%
% polarplot(...,'Expo',[on|off])
% if on, then it will rotate the coordinate system to be inline 
% with Expo (i.e. a surface drifting at 0 degrees is downwards, not rightwards).
% default: off
%
% polarplot(...,'Mirror',[on|off])
% if on, then it will mirror the coordinate system. Useful if a mirror was
% used between the subject and the display monitor. Default: off
%

% romesh.kumbhani@nyu.edu - 2011-10-20 [VERSION 2.1]
%

%% Default values
MinorTheta = 0;
MinorRho   = 0;
ShowThetas = 0;
FontSize   = 12;
LineSize   = 1;
ShowMaxRho = 1;
Wrap       = 1;
ExpoRot    = 0;
ExpoFlip   = 0;

%% Parse optional arguments

% find number of optional arguments
nvarargin = size(varargin,2);

% If there are optional arguments, let's parse them
if (nvarargin>0)
    if ~mod(nvarargin,2) % number of arguments have to be in pairs!
        for i=1:2:nvarargin % for each pair
            switch lower(varargin{i}) % does the first pair equal one of the following:
                case 'maxrho' % matches MaxRho
                    MaxRho = varargin{i+1}; % set MaxRho to the paired value
                case 'showmaxrho' % matches color
                    if strcmpi(varargin{i+1},'off') % if ShowMaxRho was "off"
                        ShowMaxRho = 0;
                    end
                case 'minortheta' % matches MinorTheta
                    if strcmpi(varargin{i+1},'on') % if MinorTheta was "on"
                        MinorTheta = 1; % set to 1;
                    end
                case 'minorrho' % matches MinorTheta
                    if strcmpi(varargin{i+1},'on') % if MinorTheta was "on"
                        MinorRho = 1; % set to 1;
                    end
                case 'showthetas' % matches ShowThetas
                    if strcmpi(varargin{i+1},'on') % if ShowTethas was "on"
                        ShowThetas = 1;
                    end
                case 'fontsize' % matches FontSize
                    FontSize = varargin{i+1}; % set FontSize to the paired value
                case 'color' % matches color
                    linecolor = varargin{i+1}; % set linecolor to the paired value
                case 'wrap' % wrap thetas
                    if strcmpi(varargin{i+1},'off') % if wrap was "off"
                        Wrap = 0;
                    end
                case 'expo' % rotate thetas
                    if strcmpi(varargin{i+1},'on') % if expo was "on"
                        ExpoRot = 1;
                    end
                case 'mirror' % flip thetas
                    if strcmpi(varargin{i+1},'on') % if mirror was "on"
                        ExpoFlip = 1;
                    end
            end
        end
    else
        error('ExpoMatlab:polarplot','Invalid number of arguments given.');
    end
end

[nThetaR,nThetaC] = size(theta);
[nRhoR,nRhoC] = size(rho);

if (nThetaC ~= nRhoC)
    error('ExpoMatlab:polarplot','Number of Theta columns does not equal the number of Rho columns!');
end

if (nThetaR>1)&&(nRhoR>1)&&(nThetaR ~= nRhoR)
    error('ExpoMatlab:polarplot','Number of Theta rows does not equal the number of Rho rows!');
end

if (nThetaR == 1)&&(nRhoR > 1)
    theta = repmat(theta,nRhoR,1);
elseif (nThetaR > 1)&&(nRhoR == 1)
    rho = repmat(rho,nThetaR,1);
end

if exist('linecolor','var')
    if ischar(linecolor)
        if isempty(strfind(linecolor,';'))
            linecolor = repmat({linecolor},nRhoR,1);
        else
            %linecolor = regexp(linecolor,'([bgrcmykw\.ox\+\*sdv\^\<\>ph\-\:]+\d*)','match');
            linecolor = regexp(linecolor,'(((\[(\d?(\.\d+)?\s?){3}\]|[bgrcmykw])[\.ox\+\*sdv\^\<\>ph\-\:]+\d+)|((\[(\d?(\.\d+)?\s?){3}\]|[bgrcmykw])[\.ox\+\*sdv\^\<\>ph\-\:]+)|([\.ox\+\*sdv\^\<\>ph\-\:]+\d+)|((\[(\d?(\.\d+)?\s?){3}\]|[bgrcmykw])\d+)|((\[(\d?(\.\d+)?\s?){3}\]|[bgrcmykw]))|([\.ox\+\*sdv\^\<\>ph\-\:]+)|(\d+))(;|$)','tokens');
        end
    end
    
    LineSize = repmat(LineSize,size(linecolor,1),size(linecolor,2));
    for i=1:length(linecolor)
        temp = linecolor{i}(1);
        temp = temp{1};
        sizeNDX = regexp(temp,'\d');
        if ~isempty(sizeNDX)            
            LineSize(i) = str2double(temp(sizeNDX));
            linecolor{i} = temp(1:sizeNDX-1);
        end
    end
    if (length(linecolor) < nRhoR)
        error('ExpoMatlab:polarplot','You did not specify enough colors!');
    elseif (length(linecolor) > nRhoR)
        error('ExpoMatlab:polarplot','You specified too many colors!');
    end
end

%% plot figure

% if rotate
if ExpoRot
    theta = mod(theta - 90,360);
end

% if flip
if ExpoFlip
    theta = mod(180 - theta,360);
end

% if wrap
if Wrap
    theta = [theta theta(:,1)];
    rho   = [rho rho(:,1)];
end

% convert theta/rho into cartesian values
[x,y]=pol2cart(theta*pi/180,rho);

% calculate maximum Rho incase it was not given
if ~exist('MaxRho','var')
    MaxRho = ceil(max(abs(rho(:)))*1.2/5)*5;
end

% check is hold is on or off
isHoldOFF = strcmp(get(gca,'NextPlot'),'replace');

if (isHoldOFF) % hold is OFF!
    % clear plot
    cla;
    % set hold on while we draw crap.
    hold on;
    % set the axes and make them square
    axis([-MaxRho +MaxRho -MaxRho +MaxRho]);
%    axis square;
    % create the outer circle and fill with white interior
    [outerX,outerY]=pol2cart(linspace(0,2*pi,240),MaxRho);
    fill(outerX,outerY,[1 1 1]);
    % create the 0->180 and 90->270 lines
    axislines(1,1) = line([-MaxRho MaxRho],[0 0],'Color',[.5 .5 .5],'LineStyle',':');
    axislines(2,1) = line([0 0],[-MaxRho MaxRho],'Color',[.5 .5 .5],'LineStyle',':');
    % create thetalabels
    if (ShowThetas)
        [textX,textY]=pol2cart(0*pi/180,MaxRho*1.1);
        text(textX,textY,sprintf('%d',0),'FontName','Helvetica','FontSize',FontSize,'HorizontalAlignment','left','FontAngle','Oblique');
        [textX,textY]=pol2cart(90*pi/180,MaxRho*1.1);
        text(textX,textY,sprintf('%d',90),'FontName','Helvetica','FontSize',FontSize,'HorizontalAlignment','center','FontAngle','Oblique');
        [textX,textY]=pol2cart(180*pi/180,MaxRho*1.1);
        text(textX,textY,sprintf('%d',180),'FontName','Helvetica','FontSize',FontSize,'HorizontalAlignment','right','FontAngle','Oblique');
        [textX,textY]=pol2cart(270*pi/180,MaxRho*1.1);
        text(textX,textY,sprintf('%d',270),'FontName','Helvetica','FontSize',FontSize,'HorizontalAlignment','center','FontAngle','Oblique');
    end
    % create the circular rings
    if (MinorRho)
        [outerX,outerY]=pol2cart(linspace(0,2*pi,240),MaxRho*.75);line(outerX,outerY,'Color',[.5 .5 .5],'LineStyle',':');
        [outerX,outerY]=pol2cart(linspace(0,2*pi,240),MaxRho*.50);line(outerX,outerY,'Color',[.5 .5 .5],'LineStyle',':');
        [outerX,outerY]=pol2cart(linspace(0,2*pi,240),MaxRho*.25);line(outerX,outerY,'Color',[.5 .5 .5],'LineStyle',':');
    end
    % create the diagonal lines
    if (MinorTheta)
        axislines(3,1) = line([-MaxRho*cos(30*pi/180) MaxRho*cos(30*pi/180)],[MaxRho*sin(30*pi/180) -MaxRho*sin(30*pi/180)],'Color',[.5 .5 .5],'LineStyle',':');
        axislines(4,1) = line([-MaxRho*cos(60*pi/180) MaxRho*cos(60*pi/180)],[MaxRho*sin(60*pi/180) -MaxRho*sin(60*pi/180)],'Color',[.5 .5 .5],'LineStyle',':');
        axislines(5,1) = line([MaxRho*cos(30*pi/180) -MaxRho*cos(30*pi/180)],[MaxRho*sin(30*pi/180) -MaxRho*sin(30*pi/180)],'Color',[.5 .5 .5],'LineStyle',':');
        axislines(6,1) = line([MaxRho*cos(60*pi/180) -MaxRho*cos(60*pi/180)],[MaxRho*sin(60*pi/180) -MaxRho*sin(60*pi/180)],'Color',[.5 .5 .5],'LineStyle',':');
    end
    %put MaxRho at 315 degrees
    if ShowMaxRho
        [textX,textY]=pol2cart(315*pi/180,MaxRho*1.00);
        %         h=text(textX,textY,[num2str(MaxRho) ' ips'],'FontName','Helvetica','FontSize',FontSize,'FontAngle','Oblique','HorizontalAlignment','center');
        %         boxdims = get(h,'extent');
        %         delete(h);
        %         patch([boxdims(1)-boxdims(3)*.1 boxdims(1)-boxdims(3)*.1 boxdims(1)+1.1*boxdims(3) boxdims(1)+1.1*boxdims(3)],...
        %               [boxdims(2)-boxdims(4)*.1 boxdims(2)+1.1*boxdims(4) boxdims(2)+1.1*boxdims(4) boxdims(2)-boxdims(4)*.1],...
        %               'w','EdgeColor',[1 1 1],'FaceColor',[1 1 1]);
        
        % TvG:  removed the above and added "... 'BackgroundColor','w' ..."
        %       also added handle for output argument.
        
        hRho = text(textX,textY,[num2str(MaxRho) ' ips'],'FontName','Helvetica','FontSize',FontSize,'FontAngle','Oblique','HorizontalAlignment','center','BackgroundColor','w');
    end
    axis off;
    if exist('linecolor','var')
        axisplot = zeros(size(x,1),1);
        for i=1:size(x,1)            
            axisplot(i)=plot(x(i,:),y(i,:),linecolor{i},'linewidth',LineSize(i));
        end
    else
        axisplot=plot(x',y','linewidth',LineSize);
    end
    hold off;
    h=[axislines;axisplot];
    set(gca,'UserData',struct('MaxRho',MaxRho,'Data',axisplot));
else % Hold on is in effect!    
    % is new axis bigger than before?
    if isempty(get(gca,'UserData'))
        error('helperfunction:polarplot','You are attempting to add a polar plot to a non-polar plot figure');
    else %UserData is defined.
        UserData = get(gca,'UserData');
        if MaxRho > UserData.MaxRho
            all_handles     = get(gca,'Children');
            data_handles    = UserData.Data;
            nondata_handles = setdiff(all_handles,data_handles);
            % set new axis
            axis([-MaxRho +MaxRho -MaxRho +MaxRho]);
            axis square;
            %enlarge circle & axes & white box
            for ii=1:size(nondata_handles,1)-1
                set(nondata_handles(ii),'Xdata',get(nondata_handles(ii),'Xdata').*MaxRho./UserData.MaxRho);
                set(nondata_handles(ii),'Ydata',get(nondata_handles(ii),'Ydata').*MaxRho./UserData.MaxRho);
            end
            % move label
            set(nondata_handles(end),'Position',get(nondata_handles(end),'Position').*MaxRho./UserData.MaxRho);
            set(nondata_handles(end),'string',sprintf('%d ips',MaxRho));
        end
        % old maxRho is still the best
        h_old = get(gca,'Children');
        if exist('linecolor','var')
            axisplot = zeros(size(x,1),1);
            for i=1:size(x,1)
                axisplot(i)=plot(x(i,:),y(i,:),linecolor{i},'linewidth',LineSize(i));
            end
        else
            axisplot=plot(x',y','linewidth',LineSize);
        end
        h=[h_old(end:-1:1);axisplot];
        set(gca,'UserData',struct('MaxRho',UserData.MaxRho,'Data',[UserData.Data;axisplot]));
        
    end
end
%%
 
% switch nargout
%     case 1
%         varargout{1} = h;
%     case 2
%         varargout{1} = h;
%         varargout{2} = MaxRho;
% end

% TvG: changed the above to what is below

c=0;
if nargout > c
    c=c+1;
    varargout{c} = h;
end
if nargout > c
    c=c+1;
    varargout{c} = MaxRho;
end
if nargout > c
    c=c+1;
    varargout{c} = hRho;
end
