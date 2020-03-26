function varargout = subplot2(M,N,i0,j0,m,n)

if nargin < 6
    m=1;
    n=1;
end

ind = [];

for i = i0:i0+m-1
    for j = j0:j0+n-1
        ind = [ind,sub2ind(M,N,i,j)];
    end
end

h = subplot(M,N,ind);
if nargout > 0
    varargout{1} = h;
end

function n = sub2ind(M,N,i,j)

n = (i-1)*N + j;
