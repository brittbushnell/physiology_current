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
%       stat :      Statistical information
%       betacon :   As beta, but with constrained (fixed) betas excluded.
%       
%
% V0: MMFIT TvG, Aug 2014, NYU
% V1: TvG, Jun 2015, NYU
% V2: TvG, July 2015, NYU: improved help layout and included output

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
    {8,'maxiter',10000}             % max nr of iteration for fmincon per data point
    {9,'maxeval',20000}             % max nr of iteration for fmincon for all function evals
    ];
[   FitMethod,...
    flRestrict,...
    SetIG,...
    SetLB,...
    SetUB,...
    flSilent,...
    flPlot,...
    MI, ...
    ME, ...
    ] = parse_optional_arg(Default,varargin{:});

%% input
if nargin(FitFun) ~= 2
    error([mfilename ':input:fittingfunction'],'\nFit function has %.0f variable(s). This should be 2. e.g.\n\tfun = @(b,t) b(1)+b(2)*t\n',nargin(FitFun))
end

if iscell(Xdata); % used for multi dimensional x data
    nDim    = numel(Xdata);
elseif isvector(Xdata)
    Xdata   = Xdata(:);
    Ydata   = Ydata(:);
    nDim    = 1;
else
    nDim    = 1; % but multiple fits (spike templates or bootstraps)
end

% if initialguess input is a function
if isa(SetIG,'function_handle')
    IG      = SetIG(Xdata,Ydata);
    SetIG   = [];
end

% get some size information
if nDim > 1
    Sz      = size(Xdata{1});
    nFit    = Sz(1);
    nDat    = Sz(2:end);
else
    [nDat,nFit] = size(Xdata);
end

% dirty way to determine function order
if nDim == 1
    MockX = NaN;
else
    MockX = cell(1,nDim);
end
notOK = true;
nParIn = 0;
while notOK
    try
        FitFun(nan(nParIn,1),MockX);
        notOK = false; % if no error is returned
    catch
        [E,Eid] = lasterr;
        MEx = MException(Eid,E);
        % if error tells nr of b is too small increase nPar
        if ~strcmpi(Eid,'MATLAB:badsubscript')
            throw(MEx)
        else
            nParIn = nParIn + 1;
        end
    end
end



%% prepare intial guesses and bounds
LB = -inf(nFit,nParIn);
UB = +inf(nFit,nParIn);
IG = zeros(nFit,nParIn);

% check if user supplied boundaries and guesses
selIGSet    = ~isnan(SetIG);
selLBSet    = ~isnan(SetLB);
selUBSet    = ~isnan(SetUB);

% overwrite with values set
IG(selIGSet) = SetIG(selIGSet);
LB(selLBSet) = SetLB(selLBSet);
UB(selUBSet) = SetUB(selUBSet);

% if boundaries are the same, restrictions have to be applied despite
% input.
selRestrict = LB == UB;
if any(all(selRestrict,1))
    flRestrict = true;
end

if ~flRestrict
    funVarPar       = @(b,x) FitFun(b,x);
    initialguess    = IG;
    lowerbound      = LB;
    upperbound      = UB;
else
    % restricting fit function with evil eval. mainly to reduce free
    % parameters
    freeparam = cell(nParIn,1);
    for iR = find(all(selRestrict,1))
        freeparam{iR} = num2str(mean(SetLB(:,iR)));
    end
    c=0;
    for iR = find(all(~selRestrict,1))
        c=c+1;
        freeparam{iR} = sprintf('b(%g)',c);
    end
    str = sprintf('%s,',freeparam{:});
    funstr = [sprintf('@(b,x) FitFun([') str(1:end-1) sprintf('],x);')];
    clear freeparam
    
    funVarPar       = eval(funstr);
    initialguess    = IG(:,all(~selRestrict,1));
    lowerbound      = LB(:,all(~selRestrict,1));
    upperbound      = UB(:,all(~selRestrict,1));
end

% see how many free parameters we have after applying restrictions
nPar = size(initialguess,2);

%%
switch FitMethod
    case 'lsqcurvefit'
        %% Calculate unknown coefficients in the model using fmincon
        % X = lsqcurvefit(fun,x0,xdata,ydata,lb,ub,options)
        %
        % FUN,X0,xdata,ydata
        %     starts at x0 and finds coefficients x to best fit the
        %     nonlinear function fun(x,xdata) to the data ydata (in the
        %     least-squares sense). ydata must be the same size as the
        %     vector (or matrix) F returned by fun.
        % ... LB,UB
        %     defines a set of lower and upper bounds on the design
        %     variables in x so that the solution is always in the range lb
        %     ? x ? ub.
        %     Pass empty matrices for lb and ub if no bounds exist.
        % ... OPTIONS
        %     minimizes with the optimization options specified in options.
        %     Use optimoptions to set these options.
        %
        % [x,resnorm,R,exitflag,output,lambda,J] = lsqcurvefit(...)
        %
        %   x
        %     parameters found after minimizing
        %
        %   resnorm
        %     squared 2-norm of the residual at x: sum((fun(x,xdata)-ydata).^2).
        %
        %   R       Vector of the residuals.
        %   Vector of the residuals between your ?t and the data points. Each value
        %   of the vector refers to the numerical di?erence between the data point
        %   and the value of the ?t equation for a given value of the independent
        %   variable.
        %
        % ... exitflag
        %     describes the exit condition of fmincon. 0: max. iterations
        %     reached 1: solution found. 
        %
        % ... output
        %     structure with information about the optimization. The fields
        %     of the structure are:
        %     .iterations: Number of iterations taken
        %     .funcCount: Number of function evaluations
        %     .lssteplength: Size of line search step relative to search
        %       direction (active-set algorithm only)
        %     .constrviolation: Maximum of constraint functions
        %     .stepsize: Length of last displacement in x (active-set and
        %       interior-point algorithms)
        %     .algorithm: Optimization algorithm used
        %     .cgiterations: Total number of PCG iterations
        %       (trust-region-reflective and interior-point algorithms)
        %     .firstorderopt: Measure of first-order optimality
        %     .message: Exit message
        %
        % ... lambda
        %     structure whose fields contain the Lagrange multipliers at
        %     the solution x (separated by constraint type). The fields of
        %     the structure are:
        %     .lower: Lower bounds lb
        %     .upper: Upper bounds ub
        %     .ineqlin: Linear inequalities
        %     .eqlin: Linear equalities
        %     .ineqnonlin: Nonlinear inequalities
        %     .eqnonlin: Nonlinear equalities
        %
        %   J       Jacobian matrix
        %   The Jacobian matrix of your model function. It is analogous to the
        %   model matrix X in linear regression, which has a column of 1-s
        %   representing the constants and a second column representing the
        %   predictors (y=Xb+e). It is useful for determining 95% confidence
        %   intervals for the calculated parameters.

        % lsqcurvefit options
        options             = optimoptions(@lsqcurvefit);
        options.PlotFcns    = [];
        options.Display     = 'none';

        fun = funVarPar;
        beta        = nan(nFit,nPar);
        resnorm     = nan(nFit,1);
        R           = nan([nFit nDat]);
        exitflag    = nan(nFit,1);
        output      = cell(nFit,1);
        lambda      = cell(nFit,1);
        J           = nan([nFit,nDat,nPar]);
        if nFit > 100;
            hWB = [];
            PP = gcp('nocreate');
            if isempty(PP)
                PP = parpool(4);
            end
        elseif nFit > 1;
            hWB = waitbar(0,'doing lsqcurvefit');
            PP = [];
        else
            hWB = [];
            PP = [];
        end
        if isempty(PP)
            for iF = 1:nFit
                if ~isempty(hWB);waitbar(iF/nFit,hWB);end
                if nDim == 1
                    cX      = Xdata(:,iF);
                    cY      = Ydata(:,iF);
                    selNan  = isnan(cY) | isnan(cX);
                else
                    cX      = Xdata(iF,:,:);
                    cY      = Ydata(iF,:,:);
                    selNanX = false([nFit nDat]);
                    for iD = 1:nDim
                        selNanX = selNanX | isnan(cX{iD});
                    end
                    selNan  = isnan(cY) | selNanX;
                end
                [
                    beta(iF,:),...
                    resnorm(iF),...
                    R(iF,~selNan),...
                    exitflag(iF),...
                    output{iF},...
                    lambda{iF},...
                    j,...
                    ] = lsqcurvefit(fun,initialguess(iF,:),cX,cY,lowerbound(iF,:),upperbound(iF,:),options);
                fullj = reshape(full(j),[nDat nPar]);
                % ooo! this is dirty
                switch nDim
                    case 1
                        J(iF,:,:) = fullj;
                    case 2
                        J(iF,:,:,:) = fullj;
                    case 3
                        J(iF,:,:,:,:) = fullj;
                    otherwise
                        disp('that''s a lot of dimensions')
                        edit(mfilename)
                        keyboard
                end
            end
            if ~isempty(hWB);close(hWB);end
            
        else
            % prepare parallel specific variables
            parR        = cell(nFit,1);
            parselNan   = cell(nFit,1);
            parfor iF = 1:nFit
                cX              = Xdata(:,iF);
                cY              = Ydata(:,iF);
                parselNan{iF}   = isnan(cY) | isnan(cX);
                [
                    beta(iF,:),...
                    resnorm(iF),...
                    parR{iF},...
                    exitflag(iF),...
                    output{iF},...
                    lambda{iF},...
                    j,...
                    ] = lsqcurvefit(fun,initialguess(iF,:),cX,cY,lowerbound(iF,:),upperbound(iF,:),options);
                % this sometimes crashes
                
                J(iF,:,:) = full(j);
                
                if mod(iF,nFit/100) == 0
                    fprintf(1,'%3.0f%%\n',iF/nFit*100);
                    %disp(sprintf('%3.0f%%\n',iF/nFit*100));
                end
            end
            for iF = 1:nFit
                R(iF,~parselNan{iF}) = parR{iF};
            end
            
        end
        % make everything real. Otherwise it will crash at c.i.
        % determination
        beta = real(beta);
        J = real(J);
        R = real(R);
        
        if ~flSilent
            cellfun(@(o) disp(o.message),output)
        end
    case 'fmincon'
        
        %% Calculate unknown coefficients in the model using fmincon
        % X = fmincon(FUN,X0,A,B,Aeq,Beq,LB,UB,NONLCON,OPTIONS)
        %
        % FUN,X0,A,B
        %     starts at X0 and finds a minimum X to the function FUN, subject to
        %     the linear inequalities A*X <= B. FUN accepts input X and returns a
        %     scalar function value F evaluated at X. X0 may be a scalar, vector,
        %     or matrix.
        %
        % ... Aeq,Beq
        %     minimizes FUN subject to the linear equalities Aeq*X = Beq as well as
        %     A*X <= B. (Set A=[] and B=[] if no inequalities exist.)
        %
        % ... LB,UB
        %     defines a set of lower and upper bounds on the design variables, X,
        %     so that a solution is found in the range LB <= X <= UB. Use empty
        %     matrices for LB and UB if no bounds exist. Set LB(i) = -Inf if X(i)
        %     is unbounded below; set UB(i) = Inf if X(i) is unbounded above.
        %
        % ... NONLCON
        %     subjects the minimization to the constraints defined in NONLCON. The
        %     function NONLCON accepts X and returns the vectors C and Ceq,
        %     representing the nonlinear inequalities and equalities respectively.
        %     fmincon minimizes FUN such that C(X) <= 0 and Ceq(X) = 0. (Set LB =
        %     [] and/or UB = [] if no bounds exist.)
        %
        % ... OPTIONS
        %     minimizes with the default optimization parameters replaced by values
        %     in the structure OPTIONS, an argument created with the OPTIMSET
        %     function. See OPTIMSET for details. For a list of options accepted by
        %     fmincon refer to the documentation.
        %
        % [x,fval,exitflag,output,lambda,grad,hessian] = fmincon(...)
        %
        % x
        %     parameters found after minimizing
        %
        % ... fval
        %     the value of the objective function fun at the solution x.
        %
        % ... exitflag
        %     describes the exit condition of fmincon. 0: max. iterations
        %     reached 1: solution found. 
        %
        % ... output
        %     structure with information about the optimization. The fields
        %     of the structure are:
        %     .iterations: Number of iterations taken
        %     .funcCount: Number of function evaluations
        %     .lssteplength: Size of line search step relative to search
        %       direction (active-set algorithm only)
        %     .constrviolation: Maximum of constraint functions
        %     .stepsize: Length of last displacement in x (active-set and
        %       interior-point algorithms)
        %     .algorithm: Optimization algorithm used
        %     .cgiterations: Total number of PCG iterations
        %       (trust-region-reflective and interior-point algorithms)
        %     .firstorderopt: Measure of first-order optimality
        %     .message: Exit message
        %
        % ... lambda
        %     structure whose fields contain the Lagrange multipliers at
        %     the solution x (separated by constraint type). The fields of
        %     the structure are:
        %     .lower: Lower bounds lb
        %     .upper: Upper bounds ub
        %     .ineqlin: Linear inequalities
        %     .eqlin: Linear equalities
        %     .ineqnonlin: Nonlinear inequalities
        %     .eqnonlin: Nonlinear equalities
        %
        % ... grad
        %     the gradient of fun at the solution x.
        %
        % ... hessian
        %     the Hessian at the solution x.
        
        % fmincon options
        %tol = 1e-10;
        %options = optimset('TolCon',tol,'TolFun',tol,'TolX',tol,'MaxIter',10000,'MaxFunEvals',10000,'Algorithm'           ,'sqp','Display','off');
        options  = optimset(                                     'Maxiter',MI,'MaxFuneval',ME,'Algorithm','interior-point','Display','off');
        
        % shape function and minimization function
        %shapefun =  @(x,mu,sigma) (2*normcdf(x,mu,sigma))-1;
        fun = funVarPar;
        ntrl = numel(Xdata);
        errfun = @(freepars) minimizationfun(fun,Xdata,Ydata,freepars,ntrl,flPlot);
        [beta,fval,exitflag,output,lambda,grad,hessian] = fmincon(errfun,initialguess,[],[],[],[],lowerbound,upperbound,[],options);
        fprintf(1,'.\n');
        R = (Ydata-fun(beta,Xdata))';
        
        
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
        [beta,R,J,CovB,MSE] = nlinfit(Xdata,Ydata,funVarPar, initialguess);
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
        selNan = isnan(R(iF,:));
        betaci(iF,:,:) = nlparci(beta(iF,:),R(iF,~selNan),'Jacobian',reshape(J(iF,:),prod(nDat),nPar),'alpha',0.05);
    end
else
    % no info to do c.i., maybe do a boostrap here
end

% Compute the r^2 value
Rsqr = get_rsq_from_fit(Xdata,Ydata,R');
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
    
    out     = nan(nFit,nPar);
    outvar  = nan(nFit*2,nPar);
    for iF = 1:nFit;
        for iR = find(selRestrict(iF,:))
            out(iF,iR)              = LB(iF,iR);
            outvar(2*iF+[-1 0],iR)  = NaN;
        end
        c=0;
        for iR = find(~selRestrict(iF,:))
            c=c+1;
            out(iF,iR)              = beta(iF,c);
            outvar(2*iF+[-1 0],iR)  = ci(2*iF+[-1 0],c);
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
strFun = [];
for iP = 1:nParIn
    strFun = [strFun sprintf('Beta%1.0f = %+f (+- %f);\n',iP,out(iP),outvar(iP))];
end
outstr = sprintf('%s r^2 = %.3f',...
    strFun,...
    Rsqr);
if flPlot
    %% Plot the nonlinear fit with the raw data
    for iF = 1:nFit
        figure
        subplot(211)
        hold on
        % plot data
        plot(Xdata(:,iF),Ydata(:,iF),'o')
        xlabel('x-data','FontSize',14)
        ylabel('y-data','FontSize',14)
        title('stimulus - response','FontSize',16)
        
        % plot fit
        x=linspace(min(Xdata(:,iF)),max(Xdata(:,iF)),1000);
        f=funVarPar(initialguess(iF,:),x);
        plot(x,f,':k')
        f=funVarPar(beta(iF,:),x);
        plot(x,f,'-r')
        plot(Xdata(:,iF),funVarPar(beta(iF,:),Xdata(:,iF)),'xr')
        legend('Data Points','Initial guess','Nonlinear Fit',0,'location','northwest')
        text(max(xlim),max(ylim),outstr,'verticalalign','top','horizontalalign','right')
        
        
        % Make a residual plot
        subplot(212)
        plot(x,0,'-',Xdata(:,iF),R(iF,:),'rx')
        xlabel('x-data','FontSize',14)
        ylabel('y-data','FontSize',14)
        title('Residual Plot','FontSize',16)
        if iF > 1
            pos = get(gcf,'position');
            pos(1) = pos(1) - pos(3) * (iF-1);
            set(gcf,'position',pos)
        end
    end
    
else
    if ~flSilent
        disp(outstr)
    end
end



function out = minimizationfun(FF,x,y,b,ntrl,F_plot)
if nargin == 7
    F_plot = false;
end

err_method = 2;
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
end

if F_plot
    cy = FF(b,x);
    plot_conversion(x,y,cy,out)
    drawnow
else
    fprintf(1,'.');
end

function plot_conversion(x,y,cy,out)
TAG0 = 'CurrentData';
TAG1 = 'CurrentFit';
TAG2 = 'Conversion';
h0=findobj('tag',TAG0);
h1=findobj('tag',TAG1);
h2=findobj('tag',TAG2);
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
