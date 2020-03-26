function varargout = squeezesubplots(Hfig,Margin)

%SQUEEZESUBPLOTS Squeeze subplots together
%
%   This function squeezes subplots closer together
%
%   Input:
%   squeezesubplots(H,Margin)
%       H :     Figure handle.
%               Squeezes all in figure with H (default = current figure)
%   or
%       H :     Array with handles to axes. 
%               Squeezes subplots within H
%       Margin :    Margin between subplots. Default Margin = 0.
%                   Margin is a ratio of the full subplot. Margin can be
%                   one or two values, for same or different margins for
%                   resp. horizontal and vertical.
%
%   Output:
%   Rect = squeezesubplots(..)
%       Rect :  rectangle matrix
%
%
% Tomg April 2008
% TvG Aug 2017: improved help

%% input
if nargin <1
    Hfig = gcf;
end
if nargin <2
    Margin = 0;
end

if numel(Hfig) == 1
    AXsps = get(Hfig,'children');
else
    AXsps = Hfig;
    Hfig = get(AXsps(1),'parent');
end
    
%% debug / test stuff
% Hs = round(rand*5);
% Vs = round(rand*5);
% N = Hs*Vs;
% figure;
% for I = 1:N
%     subplot(Hs,Vs,I)
% end
%% get rect mtx
Nsp = numel(AXsps);
Pos = ones(Nsp,4);
for I_sp = 1: Nsp
    Pos(I_sp,:)=get(AXsps(I_sp),'position');
end

%% calculate X Y W H
if numel(Margin) == 2
    MarginH = Margin(1);
    MarginV = Margin(1);
elseif numel(Margin) == 1
    MarginH = Margin;
    MarginV = Margin;
end
UqH = unique(Pos(:,1));
UqV = unique(Pos(:,2));
Nhor = numel(UqH);
Nver = numel(UqV);

[MaxH,ImaxH]=max(Pos(:,1));
[MinH,IminH]=min(Pos(:,1));
wd = (Pos(ImaxH,3)+MaxH-MinH)/Nhor;
GapH = wd*MarginH;
wd = wd - ((Nhor-1)*GapH/Nhor);

[MaxV,ImaxV]=max(Pos(:,2));
[MinV,IminV]=min(Pos(:,2));
ht = (Pos(ImaxV,4)+MaxV-MinV)/Nver;
GapV = ht*MarginV;
ht = ht - ((Nver-1)*GapV/Nver);


%% make new rect mtx
PosNEW = Pos;
PosNEW(:,3) = wd;
PosNEW(:,4) = ht;
for I_hor = 1:Nhor
    sel = Pos(:,1)==UqH(I_hor);
	CUR_H = MinH+(wd+GapH)*(I_hor-1);
    PosNEW(sel,1) = CUR_H;
%     if I_hor == 1
%         PosNEW(sel,3) = PosNEW(sel,3) * (1-MARG/Nhor);
%     else
%         PosNEW(sel,1) = PosNEW(sel,1) - MARG/(Nhor-1);
%         PosNEW(sel,3) = PosNEW(sel,3) * (1-MARG/Nhor);
%     end
end
for I_ver = 1:Nver
    sel = Pos(:,2)==UqV(I_ver);
	CUR_V = MinV+(ht+GapV)*(I_ver-1);
    PosNEW(sel,2) = CUR_V;
end

OuterRect = [MinH MinV wd*Nhor+GapH ht*Nver+GapV];

%% set axis
for I_sp = 1: Nsp
    set(AXsps(I_sp),'position',PosNEW(I_sp,:));
end
%%
if nargout > 0
    varargout(1) = {OuterRect};
end