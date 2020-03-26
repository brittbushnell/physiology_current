function varargout = exporand(varargin)

% EXPORAND Generate random numbers using the same algorithm as EXPO
%    R = EXPORAND(N) returns R, an Nx1 vector of random numbers. The
%    initial seed is 1 by default. All random numbers are unsigned 32 bit
%    integers. EXPORAND(M,N) or EXPORAND([M,N]) returns an M-by-N
%    matrix. EXPORAND(M,N,P,...) or EXPORAND([M,N,P,...]) returns an
%    M-by-N-by-P-by-... matrix.
%
%    EXPORAND returns the default seed, 1. EXPORAND(...,'seed',SEED) is
%    used to set the default seed to SEED. The parameter name is not case
%    sensitive.
% 
%    Additional parameters as follows:
%    EXPORAND(...,'type',TYPE) - Sets the output type as TYPE. Valid types
%    are '(u)int8','(u)int16','(u)int32','single','double','binary','ternary'
%
%    [R,S] = EXPORAND(...) is used to return the resultant matrix of random
%    numbers R, as well as the last seed, S.
%
%    Note: This code is based on the Pelli adaptation of standard generator
%    in Numerical Recipes in C (http://www.fizyka.umk.pl/nrbook/bookcpdf.html)
%
%    2010-Sept-13 - romesh.kumbhani@nyu.edu (Romesh Kumbhani)

SEED = 1;
DATATYPE = 'double';
Rsize = [];
STOP = 0;
i=1;
while (i <= nargin)
    if ~ischar(varargin{i})&&~STOP;
        Rsize = cat(2,Rsize,varargin{i});
    else
        if ~ischar(varargin{i})
            error('ExpoMatlab:exporand','Parameter #%d is not supported. Please remove.',i);
        end
        switch lower(varargin{i})
            case 'seed'
                i = i + 1;
                if (i > nargin)
                    error('ExpoMatlab:exporand','Seed parameter not given.');
                end
                SEED = varargin{i};
                if ~isnumeric(SEED)
                    error('ExpoMatlab:exporand','Seed parameter must be a number.');
                end
            case 'type'
                i = i + 1;
                if (i > nargin)
                    error('ExpoMatlab:exporand','Type parameter not given.');
                end
                DATATYPE = varargin{i};
                if isnumeric(DATATYPE)
                    error('ExpoMatlab:exporand','Type parameter must be a string (e.g. ''double'').');
                end
        end
        STOP=1;
    end
    i = i + 1;
end
Nvalues = prod(Rsize);
[R,S] = erng(SEED,Nvalues);

if (length(Rsize) > 1)
    R = reshape(R,Rsize);
end

R = double(R); % default to double
%maxinteger = double(intmax('uint16'));
maxinteger = 2^16;
switch DATATYPE
    case 'int8'
        R = int8(R);
    case 'int16'
        R = int16(R);
    case 'int32'
        R = int32(R);
    case 'uint8'
        R = uint8(R);
    case 'uint16'
        R = uint16(R);
    case 'uint32'
        R = uint32(R);
    case 'single'
        R = single(R);
    case 'binary'
        R = 2.0.*(floor(2.0*R/maxinteger)-0.5);
    case 'ternary'
        R = (floor(3.0*R/maxinteger)-1.0);
    case 'uniform'
        R = (2.0*R/maxinteger)-1.0;
end

switch nargout
    case {0, 1}
        varargout{1} = R;
    case 2
        varargout{1} = R;
        varargout{2} = S;
end

