%ANYFIT fits any function
%
%   This function is a wrapper for fitting any function. 
%
%   Input:
%   anyfit(fun,x,y) 
%       fun :   fit function
%       x :     independent variable 
%       y :     dependent variable.
%
%       Dependent variable is a single column. This can be seen as an array
%       of measured values in nDat rows (trials)
%           size(y) == [1 , nDat]
%       
%       Independent variable requires to have the same number of rows. The
%       Columns represent different fits. The third dimension can be used
%       to increase the number of inputs if the fit function needs more
%       than 1 independent variable.
%       E.g. fun = @(b,x1,x2) fun(b,x1)+fun(b,x2)
%           size(x) == [nFit nDat nVarIn]
%       Summarized:
%           nFit: Number of experiments
%           nDat: Number of trials
%           nVarIn: Number of independent variables
%
%       Optional input arguments :  These arguments come in pairs
%           'fitmethod': Fit method
%               'fmincon'
%               'nlinfit'
%               Default 'lsqcurvefit'
%           'restrict': restrict fit parameters
%               Default true
%           'iniguess','lowerbound','upperbound': Other fit
%               restrictions. 
%               NaN - standard restrictions are used.
%               a function handle - iniguess will computed by calling this
%               function
%                   e.g. ... , 'iniguess' , @(x,y) initialguess_gauss(x,y) , ...
%               Default empty and standard restrictions are used.
%           'silent': Do not output to screen.
%               Default false
%           'plot': display intermediate results
%               Default false
%           'maxiter': max nr of iteration for fmincon per data point.
%               Default 10000
%           'maxeval': max nr of iteration for fmincon for all function evals.
%               Default 20000
%           'logtransf': Log transform x values before fitting.
%               Default false
%
%   Output:
%   [beta, betavar, function, stat, betacon] = anyfit(..)
%       beta :      fitted parameters
%       betavar :   variance of betas
%       function :  Function handle
%       stat :      Statistical information (Rsqr)
%       betacon :   As beta, but with constrained (fixed) betas excluded.
%       
%
% V0: MMFIT TvG, Aug 2014, NYU
% V1: TvG, Jun 2015, NYU
% V2: TvG, July 2015, NYU: improved help layout and included output
%   TvG, Nov 2016, NYU: extend IG, LB and UB if it is fixed for all fits
% V3: TvG Mar 2017, NYU: multi dimensional input

function [varargout]=anyfit(FitFun,Xdata,Ydata,varargin)

%% Parse optional arguments

% Default values
Default = [
    {1,'fitmethod','lsqcurvefit'}   % toggle constr./non-constr. fit
    {2,'restrict',false}            % restrict fit parameters
    {3,'iniguess',[]}
    {3,'initialguess',[]}
    {3,'ig',[]}
    {4,'lowerbound',[]}
    {4,'lb',[]}
    {5,'upperbound',[]}
    {5,'ub',[]}
    {6,'silent',false}
    {7,'plot',true}
    ];
[   FitMethod,...
    flRestrict,...
    SetIG,...
    SetLB,...
    SetUB,...
    flSilent,...
    flPlot,...
    ] = parse_optional_arg(Default,varargin{:});

%% input
if nargin(FitFun) ~= 2
    error([mfilename ':input:fittingfunction'],'\nFit function has %.0f variable(s). This should be 2. e.g.\n\tfun = @(b,t) b(1)+b(2)*t\n',nargin(FitFun))
end
%%
% number of fits, trials and input variables based on size
nInd    = size(Xdata,3);
nFit    = size(Xdata,2);
nDat    = size(Xdata,1);
nParIn  = get_nparin(FitFun,nInd); % nr of betas

%% prepare intial guesses and bounds

% if initialguess input is a function call that function with the inputs
if isa(SetIG,'function_handle')
    SetIG = SetIG(Xdata,Ydata);
end

% Bound is set, but has the wrong size
if (~isempty(SetLB) && size(SetLB,2)~=nParIn) ...
        || (~isempty(SetUB) && size(SetUB,2)~=nParIn)  ...
        || (~isempty(SetIG) && size(SetIG,2)~=nParIn) 
    error([mfilename ':input:inputbounds'],'\nFit function has %.0f parameter(s). But the bounds (Upper, Lower or Initial guess) do not have the equal amount of parameters. e.g.\n\tfun = @(b,t) b(1)+b(2)*t\n\tIG = [1 2]\n',nParIn)
end

% Extend user supplied boundaries for all fits
% Should be nFit x nParIn in size.
if size(SetLB,1)==1
    SetLB = repmat(SetLB,nFit,1);
end
if size(SetUB,1)==1
    SetUB = repmat(SetUB,nFit,1);
end
if size(SetIG,1)==1
    SetIG = repmat(SetIG,nFit,1);
end

% Default bounds based on nParIn. 
LB = -inf(nFit,nParIn);
UB = +inf(nFit,nParIn);
IG = zeros(nFit,nParIn);

% check where user supplied boundaries and guesses
selIGSet    = ~isnan(SetIG);
selLBSet    = ~isnan(SetLB);
selUBSet    = ~isnan(SetUB);

% overwrite with values set
IG(selIGSet) = SetIG(selIGSet);
LB(selLBSet) = SetLB(selLBSet);
UB(selUBSet) = SetUB(selUBSet);

% if boundaries are the same restrictions will be applied 
selRestrict = LB == UB;
if any(all(selRestrict,1))
    flRestrict = true;
end

if ~flRestrict
    % if no restrictions prepare this for the fitting routines
    funVarPar       = @(b,x) FitFun(b,x);
    initialguess    = IG;
    lowerbound      = LB;
    upperbound      = UB;
else
    % restricting fit function 

    % See which are the free parameters 
    freeparam = cell(nParIn,1);
    % Make the restricted a text version
    for iR = find(all(selRestrict,1)) % all fits
        freeparam{iR} = num2str(SetLB(1,iR)); % use bound of first fit
    end
    % Replace free with 'b(i)'
    c=0;
    for iR = find(all(~selRestrict,1))
        c=c+1;
        freeparam{iR} = sprintf('b(%g)',c);
    end
    
    % combine in new function call
    str = sprintf('%s,',freeparam{:});
    funstr = [sprintf('@(b,x) FitFun([') str(1:end-1) sprintf('],x);')];
    clear freeparam
    
    funVarPar       = eval(funstr); % needs to be evil eval, str2func will not include 'FitFun'
    initialguess    = IG(:,all(~selRestrict,1));
    lowerbound      = LB(:,all(~selRestrict,1));
    upperbound      = UB(:,all(~selRestrict,1));
end

% see how many free parameters we have after applying restrictions
nPar = size(initialguess,2);

%% report
if ~flSilent
    Bnds = @(n,i,b) sprintf('%s fit %g | %s',n,i,sprintf('%g ',b));
    ixI=mat2cell(reshape(reshape(1:nFit*nParIn,nFit,nParIn)',1,[]),1,repmat(nParIn,1,nFit));
    ixR=mat2cell(reshape(reshape(1:nFit*nPar,nFit,nPar)',1,[]),1,repmat(nPar,1,nFit));
    md2table([
        {'--:|:--'}
        {sprintf('%s|%s','Function',func2str(FitFun))}
        cellfun(@(iF,iB) Bnds('initialguess',iF,IG(iB)),num2cell(1:nFit),ixI,'uniformoutput',false)';
        cellfun(@(iF,iB) Bnds('lowerbound',iF,LB(iB)),num2cell(1:nFit),ixI,'uniformoutput',false)';
        cellfun(@(iF,iB) Bnds('upperbound',iF,UB(iB)),num2cell(1:nFit),ixI,'uniformoutput',false)';
        %{[sprintf('%s| ','initialguess') sprintf('%g ',IG)]}
        %{[sprintf('%s|','lowerbound') sprintf('%g ',LB)]}
        %{[sprintf('%s|','upperbound') sprintf('%g ',UB)]}
        {sprintf('%s|%g','''Restriction applied''',flRestrict)}
        {sprintf('%s|%s','Function',func2str(funVarPar))}
        cellfun(@(iF,iB) Bnds('initialguess',iF,initialguess(iB)),num2cell(1:nFit),ixR,'uniformoutput',false)';
        cellfun(@(iF,iB) Bnds('lowerbound',iF,lowerbound(iB)),num2cell(1:nFit),ixR,'uniformoutput',false)';
        cellfun(@(iF,iB) Bnds('upperbound',iF,upperbound(iB)),num2cell(1:nFit),ixR,'uniformoutput',false)';
        %{[sprintf('%s|','initialguess') sprintf('%g ',initialguess)]}
        %{[sprintf('%s|','lowerbound') sprintf('%g ',lowerbound)]}
        %{[sprintf('%s|','upperbound') sprintf('%g ',upperbound)]}
        {sprintf('--:|:--')}
        {sprintf('%s|%g','nPar',nPar)}
        {sprintf('%s|%g','nDat',nDat)}
        {sprintf('%s|%g','nFit',nFit)}
        {sprintf('%s|%g','nInd',nInd)}
        {sprintf('%s|%s','FitMethod',FitMethod)}
        {'--:|:--'}
        ])
    
end
%%
switch FitMethod
    case 'lsqcurvefit'
        %% least-square curve fit
        % starts at IG and minimizes least square error

        % lsqcurvefit options
        options             = optimoptions(@lsqcurvefit); % standard
        options.PlotFcns    = [];
        options.Display     = 'none';

        % input
        fun         = funVarPar;
        
        % prepare output
        beta        = nan(nFit,nPar);
        resnorm     = nan(nFit,1);
        Res           = nan(nFit,nDat);
        exitflag    = nan(nFit,1);
        output      = cell(nFit,1); % container for string
        lambda      = cell(nFit,1);
        J           = nan(nFit,nDat,nPar);
        
        
        if nFit > 100
            % open parallel pool if large number of fits
            hWB = [];
            PP = gcp('nocreate');
            if isempty(PP)
                PP = parpool(4);
            end
        elseif nFit > 1
            % show waitbar
            hWB = waitbar(0,'doing lsqcurvefit');
            PP = [];
        else
            hWB = [];
            PP = [];
        end
        
        
        if isempty(PP)
            for iF = 1:nFit
                if ~isempty(hWB);waitbar(iF/nFit,hWB);end
                
                [
                    beta(iF,:),...
                    resnorm(iF),...
                    Res(iF,:),...
                    exitflag(iF),...
                    output{iF},...
                    lambda{iF},...
                    J(iF,:,:),...
                    ] = lsq_slicedata(fun,squeeze(Xdata(:,iF,:)),Ydata(:,iF),initialguess(iF,:),lowerbound(iF,:),upperbound(iF,:),options);
                
            end
            if ~isempty(hWB);close(hWB);end
            
        else
            parfor iF = 1:nFit
                 [
                    beta(iF,:),...
                    resnorm(iF),...
                    Res(iF,:),...
                    exitflag(iF),...
                    output{iF},...
                    lambda{iF},...
                    J(iF,:,:),...
                    ] = lsq_slicedata(fun,squeeze(Xdata(:,iF,:)),Ydata(:,iF),initialguess(iF,:),lowerbound(iF,:),upperbound(iF,:),options)
                
                if mod(iF,nFit/100) == 0
                    fprintf(1,'%3.0f%%\n',iF/nFit*100);
                    %disp(sprintf('%3.0f%%\n',iF/nFit*100));
                end
            end
            
        end
        % make everything real. Otherwise it will crash at c.i.
        % determination
        beta = real(beta);
        J = real(J);
        Res = real(Res);
        
        if ~flSilent
            out = [];
            for iF = 1:nFit
                o = output{iF};
                Flds = fieldnames(o);
                out = [];
                for cF = Flds'
                    cVal = getfield(o,cF{:});
                    if ischar(cVal)
                        pat = '%s|%s';
                        cVal = str2cell(cVal);
                    elseif isnumeric(cVal)
                        pat = '%s|%g';
                        cVal = num2cell(cVal);
                    end
                    for cV = cVal(:)'
                        out = [out;{sprintf(pat,cF{:},cV{:})}];
                    end
                end
                out = [{'--:|:--'};{sprintf('fit | %g',iF)};{'--:|:--'};out];
            end
            out = [out;{'--:|:--'}];
            md2table(out)
        end
    case 'fmincon'
        
        % fmincon options
        options                         = optimoptions(@fmincon); % standard
        options.Display                 = 'off';
        options.MaxIterations           = 10000; % default
        options.MaxFunctionEvaluations  = 20000;
        
        % fit properties
        fun = funVarPar;
        ntrl = size(Xdata,1);
        
        % minimization function
        
        % fit
        for iF = 1:nFit
            rm = (isnan(Xdata(:,iF)) | isnan(Ydata(:,iF)));
            errfun = @(freepars) minimizationfun(fun,Xdata(~rm,iF),Ydata(~rm,iF),freepars,ntrl,flPlot);
            [beta(iF,:),fval,exitflag,output,lambda,grad,hessian] = fmincon(errfun,initialguess(iF,:),[],[],[],[],lowerbound(iF,:),upperbound(iF,:),[],options);
        end
        %fprintf(1,'.\n');
        % residuals
        Res = (Ydata-fun(beta,Xdata))';
        
        
    case 'nlinfit'
        %% Calculate unknown coefficients in the model using nlinfit
        % output:
        %   beta    Vector of fit coefficients.
        %   Vector of the calculated coe?cients in the equation you are ?tting the
        %   data to. Each value corresponds to the value of the speci?ed parameters
        %   in the model function in the order in which they are speci?ed.
        %
        %   R       Vector of the residuals.
        %   Vector of the residuals between your ?t and the data points. Each value
        %   of the vector refers to the numerical di?erence between the data point
        %   and the value of the ?t equation for a given value of the independent
        %   variable.
        %
        %   J       Jacobian matrix
        %   The Jacobian matrix of your model function. It is analogous to the
        %   model matrix X in linear regression, which has a column of 1-s
        %   representing the constants and a second column representing the
        %   predictors (y=Xb+e). It is useful for determining 95% confidence
        %   intervals for the calculated parameters.
        %
        %   CovB    Variance-covariance matrix
        %   The variance-covariance matrix for the coe?cients. The diagonal values
        %   (upper left to lower right) are the parameter variances, while the
        %   other locations are the parameter covariances. The matrix is used to
        %   evaluate parameter uncertainty and parameter correlation.
        %
        %   MSE     Estimate of variance of the error
        %   An estimate of the variance of the error. It is equal to the residual
        %   sum of squares divided by the number of degrees of freedom.
        %
        % input:
        %   Xdata   Independent variable
        %   Ydata   Dependent variable
        %   mmfun   Function to fit
        %   initialguess : Vector of initial guesses for the fit coefficients
        try
        [beta,Res,J,CovB,MSE] = nlinfit(Xdata,Ydata,funVarPar, initialguess);
        catch
            disp(lasterr)
            keyboard
        end
    otherwise
        error('fit:input','[%s] as fit method is not defined.',FitMethod)
end
%% statistics for non linear fit
% 95% conf. interval. of coefficients
% rows: coefficients
% left col: lower bound
% right col: upper bound
betaci = nan(nFit,nPar,2);
if ismember(FitMethod,[{'nlinfit'},{'lsqcurvefit'}])
    for iF = 1:nFit
        selNan = isnan(Res(iF,:));
        betaci(iF,:,:) = nlparci(beta(iF,:),Res(iF,:),'Jacobian',squeeze(J(iF,:,:)),'alpha',0.05);
    end
else
    % no info to do c.i., maybe do a boostrap here
end

% Compute the r^2 value
Rsqr = get_rsq_from_fit(Xdata,Ydata,Res');
%% output
ci      = [betaci(:,:,2) ; betaci(:,:,1)];
stat    = Rsqr';

% return full fit parameters (all 4), but flag restricted params with
% var=NaN;
if ~flRestrict
    out     = beta;
    outvar  = ci;
else
    % restrictions (e.g.):
    %   bias = 0 b(1)
    %   n = 1 (M.M. fit) b(4)
    
    out     = nan(nFit,nParIn);
    outvar  = nan(nFit*2,nParIn);
    for iF = 1:nFit
        % append restricted parameter to row
        for iP = find(selRestrict(iF,:))
            out(iF,iP)              = LB(iF,iP);
            outvar(2*iF+[-1 0],iP)  = NaN;
        end
        % fill in parameters
        c=0;
        for iP = find(~selRestrict(iF,:))
            c=c+1;
            out(iF,iP)              = beta(iF,c);
            outvar(2*iF+[-1 0],iP)  = ci(2*iF+[-1 0],c);
        end
    end
end
outb = beta;

%% output
c=0;
if nargout > c
    c=c+1;
    varargout{c} = out;
end
if nargout > c
    c=c+1;
    varargout{c} = outvar;
end
if nargout > c
    c=c+1;
    varargout{c} = FitFun;
end
if nargout > c
    c=c+1;
    varargout{c} = stat;
end
if nargout > c
    c=c+1;
    varargout{c} = outb;
end
%%
outstr = cell(1,nFit);
for iF = 1:nFit
strFun = [];
for iP = 1:nParIn
    strFun = [strFun sprintf('Beta%1.0f = %+g (+- %g);\n',iP,out(iF,iP),diff(outvar([-1 0]+iF*2,iP)))];
end
outstr{iF} = sprintf('%sr^2 = %.3f',...
    strFun,...
    Rsqr(iF));
end
if flPlot && nFit < 20
    %% Plot the nonlinear fit with the raw data
    for iF = 1:nFit
        h=figure;
        subplot(211)
        hold on
        % plot data
        plot(Xdata(:,iF),Ydata(:,iF),'o')
        xlabel('x-data','FontSize',14)
        ylabel('y-data','FontSize',14)
        title('stimulus - response','FontSize',16)
        
        % plot fit
        if nInd > 1
            % use stimulated
            x=squeeze(Xdata(:,iF,:));
        else
            % smooth curve over one dimension
            x=linspace(min(Xdata(:,iF)),max(Xdata(:,iF)),100);
        end
        f=funVarPar(initialguess(iF,:),x);
        plot(x,f,':k')
        f=funVarPar(beta(iF,:),x);
        plot(x,f,'-r')
        hI=plot(squeeze(Xdata(:,iF,:)),funVarPar(beta(iF,:),Xdata(:,iF,:)),'xr');
        if nInd>1
            cm = lines_distinguishable(nInd);
            for iI = 1:nInd
                hI(iI).Color = cm(iI,:);
            end
        end
        text(max(xlim),max(ylim),outstr{iF},'verticalalign','top','horizontalalign','right')
        legend('Data Points','Initial guess','Nonlinear Fit','location','best') % why is this taking so much time
        
        
        % Make a residual plot
        subplot(212)
        hR=plot(squeeze(Xdata(:,iF,:)),Res(iF,:),'rx');
        if nInd>1
            cm = lines_distinguishable(nInd);
            for iI = 1:nInd
                hR(iI).Color = cm(iI,:);
            end
        end
        xlabel('x-data','FontSize',14)
        ylabel('y-data','FontSize',14)
        title('Residual Plot','FontSize',16)
        
        % reposition figure
        if nFit > 1
            if iF == 1
                % find current monitor
                RelPos = h.Position - h.Parent.MonitorPositions;
                [~,iMon] = min(hypot(RelPos(:,1),RelPos(:,2)));
                PosRng = [1 1]*h.Parent.MonitorPositions(iMon,1) + [0 h.Parent.MonitorPositions(iMon,3)];
                % new positions
                NewX = linspace(PosRng(1),PosRng(2),nFit+1);
                NewW = min([h.Position(3) diff(PosRng)/nFit]);
            end
            % set position
            h.Position(1) = NewX(iF);
            h.Position(3) = NewW;
        end
        drawnow

    end
    
end
if ~flSilent
    fstr = cellfun(@(s) str2cell(regexprep(regexprep(s,' = ','|'),';\n','\n')),outstr,'uniformoutput',false);
    fstr = cellfun(@(s) [{'--:|:--'};s],fstr,'uniformoutput',false);
    fstr = [reshape([fstr{:}],[],1); {'--:|:--'}];
    md2table(fstr)
end


end

%%
function nParIn = get_nparin(FitFun,nInd)
% dirty way to determine function order. 
% i.e. how many fit parameters there are

MockX = NaN(1,nInd); % fake input

notOK = true;
nParIn = 0;
while notOK
    try
        % try fitting a [1 x nInd] sized x-data with [nParIn] parameters
        FitFun(nan(nParIn,1),MockX);
        notOK = false; % if no error is returned
    catch ME
        % if FitFun fails with these nParIn
        
        if strcmpi(ME.identifier,'MATLAB:badsubscript')
            % nr of b is too small increase nPar
            nParIn = nParIn + 1;
        else
            % There was a different error
            throw(ME)
        end
    end
end

end
%%
function [beta, resnorm, R, exitflag, output, lambda, fullj ] = lsq_slicedata(fun,Xdata,Ydata,initialguess,lowerbound,upperbound,options)

nPar = numel(initialguess);
nDat = numel(Ydata);

R = nan(1,nDat);
fullj = nan(nDat,nPar);

selNan  = any(isnan([Xdata Ydata]),2); % trail where there is a NaN
if all(selNan)
    selNan = ~selNan;
    Ydata = zeros(size(Ydata));
    warning([mfilename ':nospikes'],'Data does not contain any spikes, will fit matrix with zeros.')
end
[
    beta,...
    resnorm,...
    R(~selNan)...
    exitflag,...
    output,...
    lambda,...
    j,...
    ] = lsqcurvefit(fun,initialguess,Xdata(~selNan,:),Ydata(~selNan),lowerbound,upperbound,options);

fullj(~selNan,:) = reshape(full(j),[sum(~selNan) nPar]);
                
                
end
%%
function out = minimizationfun(FF,x,y,b,ntrl,F_plot)
% FF: fit function
if nargin == 7
    F_plot = false;
end

err_method = 3;
switch err_method
    case 1
        % error: Negative log-likelihood (AZ)
        keyboard
        out = -sum( ...
            ( ...
            y     .* log(  FF(b,x)) + ...
            (1-y) .* log(1-FF(b,x)) ...
            ) ./ ntrl );
    case 2
        % error: least squared errors
        out = mean( (y - FF(b,x)).^2 );
    case 3
        % error: squared errors in log space
        %   according to tony's csf.c
        out = sum((log(FF(b,x))-log(y)).^2);
end

if F_plot
    cy = FF(b,x);
    plot_conversion(x,y,cy,out)
    drawnow
else
    %fprintf(1,'.');
end
end

%%
function plot_conversion(x,y,cy,out)
TAG0 = 'CurrentData';
TAG1 = 'CurrentFit';
TAG2 = 'Conversion';
h0=findobj('tag',TAG0);
h1=findobj('tag',TAG1);
h2=findobj('tag',TAG2);
x = squeeze(x);
if isempty(h0) || isempty(h1) || isempty(h2);
    figure
    subplot(121)
    hold on
    xlabel(sprintf('independent variable\n(stimulated)'))
    ylabel(sprintf('dependent variable\n(measured)'))
    title('function fitting')
    h0=plot(x,y,'x','tag',TAG0);
    [~,ix]=sort(x);
    h1=plot(x(ix),cy(ix),'r--','tag',TAG1);
    movshonize_plots
    
    subplot(122)
    h2 = plot(1,out,'xk','tag',TAG2);
    xlabel('iteration')
    ylabel('error')
    title('conversion')
    set(gca,'yscale','log')
    movshonize_plots
 
else
    [~,ix]=sort(x);
    %axes(get(h0,'parent'))
    set(h0,'xdata',x,'ydata',y)
    set(h1,'ydata',real(cy(ix)))
    count = get(h2,'xdata');
    set(h2,'ydata',[get(h2,'ydata') real(out)])
    set(h2,'xdata',[count count(end)+1])
end
drawnow
end


