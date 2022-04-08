%CSF_AMBLYOPES fits contrast sensitivity
%
%   This function fit a contrast sensitivity function based on
%   psychophysical performance. See [1].
%
%   [1] Kiorpes, L. et al. (1998) Neuronal correlates of amblyopia in the
%   visual cortex of macaque monkeys with experimental strabismus and
%   anisometropia, The Journal of neuroscience: the official journal of the
%   Society for Neuroscience, 18(16), pp. 6411-6424
%
%   Input:
%   csf_amblyopes(SF,FileNames)
%       SF : cell array with spatial frequency and distance. Cells are
%           formatted as: SF(i) = {'0.5@1'); indicating that i-th condition
%           was a SF of 0.5 c/d run at 1 m.
%       FileNames: n x m sized cell array with session filenames 
%           Rows (n): eye (1st FE, 2nd FE,...).
%           Columns (m): stimulus condition
%           e.g. Sessions(i,j) = {
%               ['peripho_aa.001' 'peripho_aa.003' 'peripho_aa.005']
%           }; indicates j-th condition was run in sessions 1,3, and 5 for
%           the i-th eye.
%
%   Output:
%   [h,Beta,Chisq,Resolution,ai] = csf_amblyopes(..);
%       h :             Figure handles
%       Beta :          Fitted parameters of expexpfit
%       Chisq :         Goodness of fit at end of fit
%       Resolution :    SF at intercept with Sensitivity = 1;
%       ai :            Amblyopia index.
%       pkCSF:          peak contrast sensitivity (1), and spatial
%       frequency (2)
%   Example:
%       SF = {'0.5@1' '1@1' '2@1' '4@1' '6@1' '8@1' '8@2' '12@2'};
%
%       FEfiles = {{[]} {'peripho_aa.001' 'peripho_aa.003' 'peripho_aa.005'} {'peripho_aa.011' 'peripho_aa.013' 'peripho_aa.015'} .. };
%       % note that 0.5 c/d at 1 meter was not run for FE
%
%       AEfiles = {{..} {..} ... };  
%
%       FileNames = {
%           FEfiles;
%           AEfiles
%           }
%
%       csf_amblyopes(SF,FileNames);
%
% v0: TvG Aug 2017, NYU: guided by TMs csf.c and stepit.c


function [hf,Beta,Chisq,Resolution,ai,pkCSF] = csf_amblyopesM(SF,FileNames)

%%
% number of ..
nEye = size(FileNames,1);
nCond = size(SF,2);

% color map for eyes (AE:red, FE: blue)
cmEye   = [15 116 186;239 28 35;0 0 0]/256;

%% read contrast and performance

% empty mtx
Cond = cell(nEye,nCond);
Perf = Cond;
for iEye = 1:nEye % do per eye
    for iCond = 1:nCond % do per SF
        fns = FileNames{iEye,iCond};
        
%         aux = FileNames{iEye};
%         fns = aux(iCond,:);
        
        fns = fns(cellfun(@(x) ~isempty(x(:)), fns));

        nFN = numel(fns);
        % empty mtx
        cont = []; % contrast
        ntrl = []; % number of trials
        nhit = []; % number correct
        for iFN = 1:nFN % do for every file
            fn = fns{iFN};
            % read file
            S=read_behavraw(fn);
 
            % concat. matrices per file
            [~,~,e] = fileparts(fn);
            if strcmpi(e,'.psy') % windows
                cont = [cont;1000*str2num(S.StimSet.Target_contrast__0_0__1_0_)'];
                ntrl = [ntrl;S.PerfSumm.mtx(:,strcmp(S.PerfSumm.ColInfo,'SUM'))];
                nhit = [nhit;S.PerfSumm.mtx(:,strcmp(S.PerfSumm.ColInfo,'HIT'))];
            else
                cont = [cont;S.Summary(:,strcmp(S.SummHead,'Sti.'))];
                ntrl = [ntrl;S.Summary(:,strcmp(S.SummHead,'Sum'))];
                nhit = [nhit;S.Summary(:,strcmp(S.SummHead,'Hit'))];
            end
        end
        [Cond{iEye,iCond},~,ixCont] = unique(cont);

        % calculate performance
        %   Note that here we calculate performance as Hit/Total.
        %   Alternatively the performance can be calculated by number of
        %   Rightward responses as function of contrast (Left stimulus
        %   having a negative contrast).
        nses = nan(max(ixCont),1); % number of sessions used for this contrast
        for iCont = 1:max(ixCont)
            sel = ixCont == iCont;
            nses(iCont) = sum(sel);
            Perf{iEye,iCond}(iCont) = sum(nhit(sel))./sum(ntrl(sel));
        end
        if ~isempty(nses) && (any(nses==1) || any(nses~=mode(nses)))
            warning('csf:nses','In condition %g for eye %g contrast conditions mismatch per run.',iCond,iEye)
            disp([cont ntrl nhit])
        end
    end
end

% contrast is in 0.1% units. Convert to 1%
Cond = cellfun(@(x) x/10,Cond,'UniformOutput',false);

%% plot performance
close all
hf1 = figure; % handle to figure 1
hf1.Position(3) = 1800;
hf1.Position(4) = 300;

for iEye = 1:nEye
    for iCond = 1:nCond
        ax=subplot(1,nCond,iCond);
        hold on
        % plot data
        if ~isempty(Cond{iEye,iCond}) % only when data exist
            h=plot(Cond{iEye,iCond},Perf{iEye,iCond},'o-');
            h.Color = cmEye(iEye,:);
            h.LineWidth = 1;
            h.MarkerFaceColor = cmEye(iEye,:);
            h.MarkerEdgeColor = 'w';
            h.MarkerSize = 10;
            h.Clipping = 'off';
        end
        % plot threshold
        plot([0.1 100],[0.75 0.75],'--k');
        
        % prettify
        if iCond == nCond % last axes
            ax.XLabel.String = 'Contrast (%)';
            text(100,0.50,'chance','horizontalalign','right','verticalalign','bottom')
            text(100,0.75,'threshold','horizontalalign','right','verticalalign','bottom')
        elseif iCond == 1
            ax.YLabel.String = 'Prop. correct';
        end
        ax.Title.String = SF{iCond};
        ax.XLim = [0.1 100];
        ax.YLim = [0.5 1];
        ax.XScale = 'log';
        ax.YTick = [0.5 0.75 1];
    end
end
% movshonize all subplots
hs=hf1.Children;
isax=arrayfun(@(h) strcmp(h.Type,'axes'),hs);
%arrayfun(@movshonize_plots,hs(isax))
%% do performance fits per SF
%   with 'response correct' not 'response rightward'
%   Fit parameters ("Betas") are return as well as the fit function

% here we can change the fitmethod
fitmethod = 'probit';

switch fitmethod
    case 'cumgamma'

        % fit boudaries
        LBgamma = [0.5 0.5  1    0]; % lb3 to avoid peak slopes at x<0 see function M
        UBgamma = [0.5 0.5 50 2000]; % ub3,4 in order to get peaks < 100
        IGgamma = [0.5 0.5 1 50];
        
        Betas   = cell(nEye,nCond);
        R2stat  = nan(nEye,nCond);
        for iEye = 1:nEye
            for iCond = 1:nCond
                if ~isempty(Cond{iEye,iCond})
                    
                    % data
                    x = Cond{iEye,iCond};
                    y = Perf{iEye,iCond};
                    % fit
                    [
                        Betas{iEye,iCond},...
                        bint,...
                        fun,...
                        R2stat(iEye,iCond),...
                        ]   = cumgammafit(x,y,...
                        'lb',LBgamma,...
                        'ub',UBgamma,...
                        'ig',IGgamma,...
                        'silent',true);
                    
                end
            end
        end
        
    case 'probit'
        % or cum. log gauss
        
        % fit boundaries
        % col1: lower lapse
        % col2: upper lapse
        LBgauss = [0.5 0 -1 0];
        UBgauss = [0.5 0 3 +inf];
        IGgauss = [0.5 0 1 0.1]; % ig(3) start at 10% (log(100)=2) ig(4) based on data
        
        Betas   = cell(nEye,nCond);
        R2stat  = nan(nEye,nCond);
        for iEye = 1:nEye
            for iCond = 1:nCond
                if ~isempty(Cond{iEye,iCond})
                    
                    % data
                    x = log10(Cond{iEye,iCond});
                    y = Perf{iEye,iCond};
                    % fit
                    IGgauss(3) = mean(x); % 10% is not a good choice after all. Use stimulus mean.
                    [
                        Betas{iEye,iCond},...
                        bint,...
                        fun,...
                        R2stat(iEye,iCond),...
                        ]   = cumgaussfit(x',y',...
                        'lb',LBgauss,...
                        'ub',UBgauss,...
                        'ig',IGgauss,...
                        'lapse','asymmetric',...
                        'silent',true);
                end
            end
        end
end

%% plot fits
figure(hf1)

XX = 10.^linspace(-1,2,30); % resolution of contrast to be plotted for fit
for iEye = 1:nEye
    for iCond = 1:nCond
        if ~isempty(Cond{iEye,iCond})
            ax=subplot(1,nCond,iCond);
            
            % fitted performance
            if strcmp(fitmethod,'probit')
                YY = fun(Betas{iEye,iCond},log10(XX)); % input log transformed data
            else
                YY = fun(Betas{iEye,iCond},XX);
            end
            
            % plot fit
            h=plot(XX,YY,'--');
            h.Color = cmEye(iEye,:);
            h.LineWidth = 3;
            h.Clipping = 'off';
            
            % fit statistics
            h=text(0.1,1,[sprintf(repmat('\n',1,iEye-1)) sprintf(' R^2 = %.2f %s ',R2stat(iEye,iCond),fitmethod)]);
            h.Color = cmEye(iEye,:);
            h.FontName = 'Helvetica';
            h.FontSize = 12;
            h.FontAngle = 'oblique';
            h.VerticalAlignment = 'top';
            h.HorizontalAlignment = 'left';
            
        end
    end
end

%% find thresholds
% Thresholds = nan(nEye,nCond);
% for iEye = 1:nEye
%     for iCond = 1:nCond
%         if ~isempty(Cond{iEye,iCond})
%             
%             % minimization function: squared error
%             %   Note that this happens either in log- or lin-space
%             %   depending on what function is used.
%             minfun = @(x) (fun(Betas{iEye,iCond},x) - 0.75)^2;
%             % start at average stimulus value
%             if strcmp(fitmethod,'probit')
%                 X0 = mean(log10(Cond{iEye,iCond}));
%             else
%                 X0 = mean(Cond{iEye,iCond});
%             end
%             Thresholds(iEye,iCond) = fminsearch(minfun,X0);
%             
%         end
%     end
% end

sel = ~cellfun(@isempty,Cond);
Thresholds      = nan(nEye,nCond);
SD              = nan(nEye,nCond);
Thresholds(sel) = cellfun(@(b) b(3),Betas(sel));
SD(sel)         = cellfun(@(b) b(4),Betas(sel));


% variance
%   LB: lower bound
%   UB: upper bound

VarianceLB = Thresholds - SD;
VarianceUB = Thresholds + SD;


if strcmp(fitmethod,'probit')
    % convert back from log transformed
    Thresholds = 10.^Thresholds; 
    VarianceLB = 10.^VarianceLB;
    VarianceUB = 10.^VarianceUB;
end

% sens is 1/thres
Sensitivity = 1./(Thresholds/100);
SensLB = 1./(VarianceUB/100);
SensUB = 1./(VarianceLB/100);

%% plot thresholds
figure(hf1)
for iEye = 1:nEye
    for iCond = 1:nCond
        if ~isempty(Cond{iEye,iCond})
            ax=subplot(1,nCond,iCond);
            
            h=plot(Thresholds(iEye,iCond),0.75,'x');
            h.LineWidth = 4;
            h.MarkerSize = 16;
            h.MarkerEdgeColor = cmEye(iEye,:);
            
            h=plot([VarianceLB(iEye,iCond) VarianceUB(iEye,iCond)],[0.75 0.75],'-');
            h.LineWidth = 4;
            h.Color = cmEye(iEye,:);
            h.Clipping = 'off';
        end
    end
end
%% plot thresholds as function of SF

% get value from string.
%   everything before and after '@'
string = regexp(SF,'(.+)@([1,2])','tokens');
string = [string{:}];
string = [string{:}];
string = reshape(string,2,[]);
SFvalue = str2double(string);


hf2=figure;
hf2.Position(3) = 500;
hf2.Position(4) = 500;

ax=gca;
ax.NextPlot = 'add';
ax.XScale = 'log';
ax.YScale = 'log';
ax.XLim = [0.3 30];
ax.YLim = [1 300];
ax.PlotBoxAspectRatio = [diff(log10(ax.XLim)) diff(log10(ax.YLim)) 1]; % axis square (equal log steps)
ax.XLabel.String = 'Spatial Frequency (c/deg)';
ax.YLabel.String = 'Contrast sensitivity';
ax.Title.String = 'Static contrast';

%movshonize_plots(ax)
%%
% for iEye = 1:nEye
%     for Dist = unique(SFvalue(2,:)) % distance 1 or 2 meter
% 
%         sel = SFvalue(2,:) == Dist;
%         h=plot(SFvalue(1,sel),Sensitivity(iEye,sel),'o');
%         h.MarkerEdgeColor = cmEye(iEye,:);
%         h.MarkerFaceColor = 'w';
%         h.MarkerSize = 12;
%         
%         for iCond = find(sel)
%             h=plot([1 1]*SFvalue(1,iCond),[SensLB(iEye,iCond) SensUB(iEye,iCond)],'-');
%             h.LineWidth = 4;
%             h.Color = cmEye(iEye,:);
% %             h.Clipping = 'off';
%         end
%         
%     end
% end
%% fit curve
% see Kiorpes et al. 1998

% use only ONE viewing distance per SF.
%   select 2 meter over 1 meter
%   (viewing distance are in SFvalue(2,:) )

%   unique SFs
uSF = unique(SFvalue(1,:));

x = repmat(uSF,nEye*3,1);
y = nan(nEye*3,numel(uSF));
for iEye = 1:nEye
    for iCond = 1:numel(uSF)
        cSF = uSF(iCond); % current SF in loop
        % select SF, but data must exist
        sel = SFvalue(1,:) == cSF & ~isnan(Sensitivity(iEye,:));
        % choose 2 over 1
        maxView = max(SFvalue(2,sel));
        if isempty(maxView)
            maxView = nan;
        end
        % select sensitivity of max. viewing distance and current SF in
        % loop
        sel = SFvalue(1,:) == cSF & SFvalue(2,:) == maxView;
        if any(sel)
            y(1+(iEye-1)*3,iCond) = Sensitivity(iEye,sel);
            y(2+(iEye-1)*3,iCond) = SensLB(iEye,sel);
            y(3+(iEye-1)*3,iCond) = SensUB(iEye,sel);
        end
    end
end

% Do fit
%   This is where the magic happens. By default expexpfit uses a
%   minimization function that minimizes in log space. For details see
%   expexpfit
[bAll,bint,fun,stat] = expexpfit(x',y',...
    'silent',true);

% Mean and bounds are fitted. Disentangle these here for plotting below
b  = bAll(1:3:end,:);
bL = bAll(2:3:end,:);
bU = bAll(3:3:end,:);

%% plot fitted curve
XX = 10.^linspace(-1,2,61); % resolution of SF to be plotted for fit

figure(hf2)
for iEye = 1:nEye
    % these are the included data points
    h=plot(uSF,y(1+(iEye-1)*3,:),'o');
    h.MarkerFaceColor = cmEye(iEye,:);
    h.MarkerEdgeColor = 'w';
    h.MarkerSize = 14;

    % fit
    hm=plot(XX,fun(b(iEye,:),XX),'-');
    hL=plot(XX,fun(bL(iEye,:),XX),':');
    hU=plot(XX,fun(bU(iEye,:),XX),':');
    
    for h = [hm hL hU]
    h.Color = cmEye(iEye,:);
    h.LineWidth = 1;
    h.Color = cmEye(iEye,:);
%     h.Clipping = 'off';
    end
    pkSF(iEye,:) = hm;
end
%% some statistics
% Resolution: intercept with Sens. = 1;

Resolution = nan(nEye,1);
for iEye = 1:nEye %find(any(~isnan(y),2))'
    
    % minimization function: squared error
    minfun = @(x) (fun(b(iEye,:),x) - 1).^2;
    % start at largest SF. From there it should slope down to sens=1
    ix = find(~isnan(y(iEye,:)),1,'last');
    X0 = x(iEye,ix);
    Resolution(iEye) = fminsearch(minfun,X0);

end

%% plot resolution
h=plot(Resolution,1,'^','clipping','on');
% h=plot(Resolution,3,'^','clipping','on');
for iEye = 1:nEye
h(iEye).MarkerFaceColor = cmEye(iEye,:);
h(iEye).MarkerFaceColor = cmEye(iEye,:);
end
for ch = h'
    ch.MarkerEdgeColor = 'w';
    ch.MarkerSize = 10;
end

%% integral
% area between 2 fitted functions
%   linear freq., logarithmic sensitiviy.
%fun_loglog = @(b,x) log10(b(1).*(10.^x.^b(2)).*exp(-b(3).*10.^x));
%fun_logsf = @(b,x) b(1).*(10.^x.^b(2)).*exp(-b(3).*10.^x);
fun_logsens = @(b,x) log10(b(1).*(x.^b(2)).*exp(-b(3).*x));

% start at 0 c/d end at intercept with sens=1
%   SF = 0 sometimes has sens < 1. Could do fminsearch as is done with
%   Resolution. For now use what is in Kiorpes et al. 1998.
start = 0;
sumfe = integral(@(x) (fun_logsens(b(1,:),x)),start,Resolution(1));
sumae = integral(@(x) (fun_logsens(b(2,:),x)),start,Resolution(2));

% amblyopia index 
ai = (sumfe - sumae)/sumfe;

% if ai <0
%     keyboard
% end
%% show A.I. in figure

figure(hf2);
ax = hf2.Children(end);
h=text(ax.XLim(1),ax.YLim(1),sprintf(' A.I. = %.2f',ai));
h.FontName = 'helvetica';
h.FontAngle = 'oblique';
h.FontSize = 24;
h.VerticalAlignment = 'bottom';
h.HorizontalAlignment = 'left';

%% output
hf = [hf1 hf2];

% parameters (=beta's) from expexp fit
Beta = b; 
% GOF at end
Chisq = nan(nEye,1);
for iEye = 1:nEye
    Chisq(iEye) = nansum((log10(fun(b(iEye,:),uSF))-log10(y(iEye,:))).^2); 
end
% peak spatial frequency
for i = 1:2
[pkCSF(i,1),pkNdx] = max(pkSF(i).YData);
pkCSF(i,2) = pkSF(i).XData(pkNdx);
end
