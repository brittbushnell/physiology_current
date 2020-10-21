function result=iscircle(circleX,circleY,pointx,pointy)
%ISCIRCLE    This program checks whether a point (x,y) lies inside,outside
%            or on a circle defined by 3 other points.
% 
%   Syntax: iscircle(X,Y,x,y), where X=[x1 x2 x3] and Y=[y1 y2 y3].
%           Thus, a circle can be made out of these 3 points-->(x1,y1),(x2,y2)&(x3,y3).
%           Program checks whether point (x,y) lies inside,outside or on the circle.
%           ans=0  ==> lie on the circle.
%           ans=1  ==> lie outside the circle.
%           ans=-1 ==> lie inside the circle.
%%
cX1 = circleX(1); cY1 = circleY(1);
cX2 = circleX(2); cY2 = circleY(2);
cX3 = circleX(3); cY3 = circleY(3);

k=((cX1-cX2) * ((cX2*cX2)-(cX3*cX3)+(cY2*cY2)-(cY3*cY3)) - (cX2-cX3) * ((cX1*cX1)-(cX2*cX2)+(cY1*cY1)-(cY2*cY2)))/...
    ((2)*((cY2-cY3)*(cX1-cX2)-(cY1-cY2)*(cX2-cX3)));

h=((cY1-cY2)*(cY1+cY2-2*k))/((2)*(cX1-cX2))+(cX1+cX2)/2;

r=sqrt((cX3-h)*(cX3-h)+(cY3-k)*(cY3-k));

val=(pointx-h)*(pointx-h)+(pointy-k)*(pointy-k)-r*r;

result=sign(val);