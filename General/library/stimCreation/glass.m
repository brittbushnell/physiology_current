% glass patterns
%
% usage: glass(type, n, dx, coh, bkgdcolor, dotcolor, mask)
%   type:
%     0 = linear
%     1 = concentric
%     2 = radial
%     3 = random
%   n: number of dipoles
%   dx: length of the dipoles
%   coh: coherence of the dots (0..1)
%   mask: 
%     0 = square
%     1 = circlar
%
% example: glass(1, 400, 0.01, 0.5, 1);
%   400 dipoles, concentric, circlar pattern with 
%   dipole distance of 0.01, and 50% coherence
%

%
% 2010/06/09 added coherence parameter and making 3 output plots (100%, coh%, 0%)
%
function g = glass(type, n, dx, coh, bkgdcolor, dotcolor, mask)
  n = 2 * n;
  rn = zeros(n, 8);
  rn(:,1:2) = rand(n, 2) - 0.5; % random pair ranging -.5 to +.5
    
  % handle color value
  if length(bkgdcolor) ~= 3
    bkgdcolor = [bkgdcolor bkgdcolor bkgdcolor];
  end 
  if length(dotcolor) ~= 3 
    dotcolor = [dotcolor dotcolor dotcolor];
  end
  
  % polar representation of dots
  [rn(:,3) rn(:,4)] = cart2pol(rn(:,1),rn(:,2));
  
  % a = angle using each dot as an origin
  if (type == 0) % linear
    a = zeros(n,1);
  end
  if (type == 1) % concentric
    a = rn(:,3) + pi / 2;
  end
  if (type == 2) % radial
    a = rn(:,3);
  end
  if (type == 3) % random
    a = rand(n,1) * 2 * pi;
  end
  r = ones(n,1) * dx;
  
  % 2nd set of dots
  [x y] = pol2cart(a, r);
  rn(:,5:6) = rn(:,1:2) + [x y];
  
  % "3rd" set of dots (random angle)
  a = rand(n,1) * 2 * pi;
  [x y] = pol2cart(a, r);
  rn(:,7:8) = rn(:,1:2) + [x y];
  
  % brute force filtering (taking first n dipoles within mask)
  n = n / 2;
  if (mask ~= 0)
    rn(:,4) = sqrt(rn(:,1).*rn(:,1)+rn(:,2).*rn(:,2));
    newrn = rn(find(rn(:,4)<0.5),:);
    g(1:n,:) = newrn(1:n,:);
  else
    g = rn(1:n,:);
  end

  if (coh < 1)
    ncoh = floor(n * coh + 1);
  else
    ncoh = n;
  end
  
  % 100% coherence
  figure(1)
  h = plot(g(:,1), g(:,2), '.w');
  axis([-.5 .5 -.5 .5])
  set(h, 'color', dotcolor);
  %set(gca, 'color', bkgdcolor);
  %set(gcf, 'color', bkgdcolor);
  hold on
  h = plot(g(:,5), g(:,6), '.w');
  axis([-.5 .5 -.5 .5])
  set(h, 'color', dotcolor);
  set(gca, 'color', bkgdcolor);
  set(gcf, 'color', bkgdcolor);
  set(gca,'axes','off')
  hold off

  % requested coherence
  figure(2)
  h =plot(g(:,1), g(:,2), '.w');
  axis([-.5 .5 -.5 .5])
  set(h, 'color', dotcolor);
  %set(gca, 'color', bkgdcolor);
  %set(gcf, 'color', bkgdcolor);
  hold on
  h = plot(g(1:ncoh,5), g(1:ncoh,6), '.w');
  axis([-.5 .5 -.5 .5])
  set(h, 'color', dotcolor);
  set(gca, 'color', bkgdcolor);
  set(gcf, 'color', bkgdcolor);
if (ncoh < n)
    plot(g(ncoh+1:n,7), g(ncoh+1:n,8), '.w');
  end
  hold off

  % 0% coherence
  figure(3)
  h = plot(g(:,1), g(:,2), '.w');
  axis([-.5 .5 -.5 .5])
  set(h, 'color', dotcolor);
  %set(gca, 'color', bkgdcolor);
  %set(gcf, 'color', bkgdcolor);
  hold on
  h = plot(g(:,7), g(:,8), '.w');
  axis([-.5 .5 -.5 .5])
  set(h, 'color', dotcolor);
  set(gca, 'color', bkgdcolor);
  set(gcf, 'color', bkgdcolor);
  hold off
 
 
  