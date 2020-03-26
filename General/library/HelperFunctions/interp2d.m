function z2 = interp2d(z,n)
%function z2 = interp2d(z,n)
%%
[x,y] = size(z);
z2 = nan(x,(y-1)*n+1);

for j=1:x %row
    for i=1:y-1; %col
        if isnan(z(j,i+1))
             z2(j,(i*n-n+1):(i*n)) = repmat(z(j,i),1,n);
             z2(j,i*n+1) = nan;
        else
            if abs(z(j,i+1)-z(j,i))>180
                if (z(j,i+1)-z(j,i))>180
                    z2(j,(i*n-n+1):(i*n)+1) = linspace(z(j,i),z(j,i+1)-360,n+1);
                else
                    z2(j,(i*n-n+1):(i*n)+1) = linspace(z(j,i),z(j,i+1)+360,n+1);
                end
            else
                z2(j,(i*n-n+1):(i*n)+1) = linspace(z(j,i),z(j,i+1),n+1);
            end
        end
    end
end
z2=mod(z2+180,360)-180;
