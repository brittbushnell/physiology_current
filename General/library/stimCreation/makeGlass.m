nver = 1;               % number of image versions
dsz  = 16;               % dot size (>=3 for presentation visibility)
coh  = 1;            % coherent (0..1)

bkgdcolor = 0.5;        % background color (0..1); 0.5=mid-gray
dotscolor = 1.0;        % dots color (0..1); 1=white
type = 1;         % translational, circlar, radial
nd = 400;         % dipole pairs
dx = 0.03;       % of image
sz = 32;               % 1/dsz of output images size dsz-X for smoothier dots
k = 0.8;                % 10 % margin around dipole area
inver = 0;              % inverse image color

%cd '~/Volumes/Untitled1/Glass_Small';

for ver=1:nver
for i1=1:length(type)
  i1;
  for i2=1:length(nd)
    for i3=1:length(dx)
      % get coordinates
      g=glass(type(i1), nd(i2), dx(i3), coh, bkgdcolor, dotscolor, 1);
      n = length(g);
      % restrict coh to <= 1.0 and calc n-dots
      if (coh < 1)
        ncoh = floor(n * coh + 1);
      else
        ncoh = n;
      end
      if (type(i1) == 0)
        T = 'T_';
      elseif (type(i1) == 1)
        T = 'C_';
      elseif (type(i1) == 2)
        T = 'R_';
      elseif coh == 0
        T = 'N_';
      else
        T = 'T_';  
      end

      % 100%
      d=zeros(sz);
      for i=1:n
        d(floor(g(i,1)*k*sz+sz/2),floor(g(i,2)*k*sz+sz/2))=1;
        d(floor(g(i,5)*k*sz+sz/2),floor(g(i,6)*k*sz+sz/2))=1;  
      end
      d(find(d==0)) = bkgdcolor;
      d(find(d==1)) = dotscolor;
      imwrite(imresize(d',dsz), [T 'N' num2str(nd(i2)) '_Dx' num2str(dx(i3)) '_Coh1.0_v' num2str(ver) '.png'], 'png')  
      if inver ~= 0
        d(find(d==1)) = 1 - dotscolor;
        imwrite(imresize(d',dsz), [T 'invN' num2str(nd(i2)) '_Dx' num2str(dx(i3)) '_Coh1.0_v' num2str(ver) '.png'], 'png')  
      end
      
      % coh
      d=zeros(sz);
      for i=1:n
        d(floor(g(i,1)*k*sz+sz/2),floor(g(i,2)*k*sz+sz/2))=1;
        if (i <= ncoh)
          d(floor(g(i,5)*k*sz+sz/2),floor(g(i,6)*k*sz+sz/2))=1;  
        else
          d(floor(g(i,7)*k*sz+sz/2),floor(g(i,8)*k*sz+sz/2))=1;  
        end
      end
      d(find(d==0)) = bkgdcolor;
      d(find(d==1)) = dotscolor;
      imwrite(imresize(d',dsz), [T 'N' num2str(nd(i2)) '_Dx' num2str(dx(i3)) '_Coh' num2str(coh) '_v' num2str(ver) '.png'], 'png')  
      if inver ~= 0
        d(find(d==1)) = 1 - dotscolor;
        imwrite(imresize(d',dsz), [T 'invN' num2str(nd(i2)) '_Dx' num2str(dx(i3)) '_Coh' num2str(coh) '_v' num2str(ver) '.png'], 'png')  
      end
      
      % 0%
      d=zeros(sz);
      for i=1:n
        d(floor(g(i,1)*k*sz+sz/2),floor(g(i,2)*k*sz+sz/2))=1;
        d(floor(g(i,7)*k*sz+sz/2),floor(g(i,8)*k*sz+sz/2))=1;  
      end
      d(find(d==0)) = bkgdcolor;
      d(find(d==1)) = dotscolor;
      imwrite(imresize(d',dsz), [T 'N' num2str(nd(i2)) '_Dx' num2str(dx(i3)) '_Coh0.0_v' num2str(ver) '.png'], 'png')  
      if inver ~= 0
        d(find(d==1)) = 1 - dotscolor;
        imwrite(imresize(d',dsz), [T 'invN' num2str(nd(i2)) '_Dx' num2str(dx(i3)) '_Coh0.0_v' num2str(ver) '.png'], 'png')  
      end
    end
  end
end
end