% LE = AE
% peripho
amblySubs.KI.Peripho.age = 846;
amblySubs.KI.Peripho.LElens = +1.75;
amblySubs.KI.Peripho.RElens = 0;
amblySubs.KI.Peripho.sfDistFE = {'0.5@1','1@1','2@1','4@2','8@2','12@2'};
amblySubs.KI.Peripho.sfDistAE = {'0.5@1','1@1','2@1','4@2'};

amblySubs.KI.Peripho.LE = [
0.5	2.06563	0.05474
1	1.85416	0.06009
2	1.34945	0.05595
4	0.81383	0.06164];
amblySubs.KI.Peripho.RE = [
0.5	1.50418	 0.08597
1	1.49922	 0.04642
2	1.94047	 0.06942
4	1.57077	 0.07146
8	1.37816	 0.05742
12	0.881841 0.05162];

amblySubs.KI.Peripho.FEfiles = {
    {'' '' ''};... %0.5
    {'' '' ''};... %1
    {'' '' ''};... %2
    {'' '' ''};... %4
    {'' '' ''};... %8
    {'' '' ''}}; %12
amblySubs.KI.Peripho.AEfiles = {
    {'' '' ''};... %0.5
    {'' '' ''};... %1
    {'' '' ''};... %2
    {'' '' ''}};... %4


% radial
amblySubs.KI.Radial.age = ;
amblySubs.KI.Radial.LE = +1.75;
amblySubs.KI.Radial.RE = 0;
amblySubs.KI.Radial.distanceComp = 100;
amblySubs.KI.Radial.distancePhys = 100;
amblySubs.KI.Radial.radius = 1.5;
amblySubs.KI.Radial.sf = 2;

amblySubs.KI.Radial.LE = [
];

amblySubs.KI.Radial.RE = [
];


amblySubs.KI.Verno.age = ;
amblySubs.KI.Verno.RElens = 0;
amblySubs.KI.Verno.LElens = +1.75;

amblySubs.KI.Verno.RE = [
];

amblySubs.KI.Verno.LE = [
];