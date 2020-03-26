function varargout = MakeBwRcBwFilterSpec(ppd,fps,imN,tN,sfH,sfL,bwOrd,tfH,tfL,bwOrdT,oriC,oriPow)
% [H,D] = MakeBwRcBwFilterSpec(ppd,fps,imN,tN,sfH,sfL,bwOrd,tfH,tfL,bwOrdT,oriC,oriPow)
% Creates 2D or 3D filter in frequency space. Multiply H by the fft of your
% stimulus to apply filter.
% Filter is Butterworth in spatial frequency, raised cosine in orientation,
% and (optionally) Butterworth in temporal frequency.
% 2D filter is created by passing a NaN for parameter tfH (see below).
%
% Optional output structure D describes separable filters (sf,ori,tf)
% Use: plot(D.sf,D.sfFilt)
%
% Parameters:
% -----------
% ppd: pixels per degree for your display
% fps: frames per second for your display 
% imN: spatial size (x and y) in pixels, of your stimulus
% tN: temporal size of stimulus (number of frames)
%
% sfH, sfL: high and low cuttoff sf for sf filter (in cyc/deg)
% bwOrd: order of Butterworth filter applied in sf
% 
% tfH, tfL: high and low cuttoff tf for tf filter (in Hz )
% SET tfH TO NAN FOR 2D FILTER
% bwOrdT: order of Butterworth filter applied in tf
%
% oriC: center orienation (in radians) Zero=vertical
% oriPow: exponent applied to cosine (larger power -> narrower filter)
%
% shooner, 2012ish


is3d = ~isnan(tfH);

uVals = ( [0:imN/2-1 -imN/2:-1] )./imN.*ppd;
if is3d
    wVals = ( [0:tN/2-1 -tN/2:-1] )./tN.*fps;
    [u,v,tf] = meshgrid(uVals,uVals,wVals);
else
    [u,v] = meshgrid(uVals,uVals);
end
[ori,sf] = cart2pol(u,v);
 
h = ButterworthBP(sf,sfH,sfL,bwOrd).*...
             (0.5 + 0.5.*cos(2*(ori-oriC))).^oriPow;
if is3d
    h = h.*ButterworthBP(tf,tfH,tfL,bwOrdT);
end

varargout{1} = h;

% Description structure
if nargout>1
    D.sf = unique(sf(:));
    D.ori = unique(ori(:));
    D.sfFilt = ButterworthBP(D.sf,sfH,sfL,bwOrd);
    D.oriFilt = (0.5+0.5.*cos(2*(D.ori-oriC))).^oriPow;
    if is3d
        D.tf = unique(tf(tf>0));
        D.tfFilt = ButterworthBP(D.tf,tfH,tfL,bwOrdT);
    end
    varargout{2} = D;
end




