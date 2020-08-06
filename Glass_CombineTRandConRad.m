clear all
close all
clc
%%
td = load('');
if isempty(data.RE)
    trData = data.LE;
else
    trData = data.RE;
end

sd = load('');
if isempty(data.RE)
    conRadData = data.LE;
else
    conRadData = data.RE;
end
%%
[rfQuadrant, quadOris] = getOrisInRFs(glassData,rfData);

%% compute area of an ellipse

xs = sort(A(:,1));
ys = sort(A(:,2));
area = pi*xsLength/2*ysLength/2;  % I think this should be the area of the ellipse, but not 100% sure




