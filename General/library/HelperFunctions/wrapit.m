function y=wrapit(x,dim)

if ~exist('dim','var')
    [rows,cols]=size(x);
    
    if ndims(x) <=2
        if rows == 1
            % x is column formatted
            y = [x x(1)];
        elseif cols == 1
            % x is row formatted
            y = [x;x(1)];
        else
            % x is two dimensional
            y = [x x(:,1);x(1,:) x(1,1)];
        end
    end
else
    switch dim
        case 1
            y = [x;x(1,:)];
        case 2
            y = [x x(:,1)];
        otherwise
            y = [];
    end
end