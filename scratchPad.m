
%% GA
amblySubs.GA.Peripho.age = 280;
amblySubs.GA.Peripho.LElens = +1.5;
amblySubs.GA.Peripho.RElens = 0;
amblySubs.GA.Peripho.sfDistLE = {'0.5@1','1@1','2@1','4@2'};
amblySubs.GA.Peripho.sfDistRE = {'0.5@1','1@1','2@1','4@2','8@2','12@2'};

amblySubs.GA.Peripho.LE = [
];

amblySubs.GA.Peripho.RE = [
];

amblySubs.GA.Peripho.REfiles = {
    {'' '' ''};... %0.5
    {'' '' ''};... %1
    {'' '' ''};... %2
    {'' '' ''};... %4
    {'' '' ''};... %8
    {'' '' ''}}; %12

amblySubs.GA.Peripho.LEfiles = {
    {'' '' ''};... %0.5
    {'' '' ''};... %1
    {'' '' ''};... %2
    {'' '' ''};... %4
    {'' '' ''};... %8
    {'' '' ''}}; %12

amblySubs.GA.Peripho.PsychSlopes.LE = [];
amblySubs.GA.Peripho.PsychSlopes.RE = [];

% radial
amblySubs.GA.Radial.age = ;
amblySubs.GA.Radial.LE = ;
amblySubs.GA.Radial.RE = ;
amblySubs.GA.Radial.distanceComp = ;
amblySubs.GA.Radial.distancePhys = ;
amblySubs.GA.Radial.radius =;
amblySubs.GA.Radial.sf = ;

amblySubs.GA.Radial.LE = [
];

amblySubs.GA.Radial.RE = [

];

amblySubs.GA.Radial.PsychSlopes.LE = [];
amblySubs.GA.Radial.PsychSlopes.RE = [];

% verno
amblySubs.GA.Verno.age = ;
amblySubs.GA.Verno.RElens = ;
amblySubs.GA.Verno.LElens = ;

amblySubs.GA.Verno.RE = [];
amblySubs.GA.Verno.LE = [];

amblySubs.GA.Verno.PsychSlopes.LE = ;
amblySubs.GA.Verno.PsychSlopes.RE = ;

%%
% His RF analyses is all kinds of messed up, files of different RFs are
% analyzed together as something totally different.

controlSubs.LW.Peripho.age = 483;
controlSubs.LW.Peripho.LElens = +2.0;
controlSubs.LW.Peripho.RElens = +2.25;
controlSubs.LW.Peripho.sfDistLE = {'0.5@1','1@1','2@1','4@2','8@2','12@2'};
controlSubs.LW.Peripho.sfDistRE = {'0.5@1','1@1','2@1','4@2','8@2','12@2'};

controlSubs.LW.Peripho.LE = [
0.5	1.64849	0.06112
1	1.73322	0.06472
2	1.65827	0.06339
4	1.90171	0.05202
8	1.64791	0.05729
12	1.08404	0.05856    
];

controlSubs.LW.Peripho.RE = [
0.5	1.49662	0.06347
1	1.69671	0.06068
2	1.8486	0.06192
4	1.81187	0.06832
8	1.37568	0.07805
12	1.25965	0.06083
];

controlSubs.LW.Peripho.LEfiles = {
    {'perip_lw.269' 'perip_lw.239' ''};... %0.5
    {'perip_lw.268' 'perip_lw.241' 'perip_lw.242'};... %1
    {'perip_lw.267' 'perip_lw.245' 'perip_lw.246'};... %2
    {'perip_lw.266' 'perip_lw.250' 'perip_lw.251'};... %4
    {'perip_lw.265' 'perip_lw.254' 'perip_lw.255'};... %8
    {'perip_lw.264' 'perip_lw.262' 'perip_lw.263'}}; %12

controlSubs.LW.Peripho.REfiles = {
    {'perip_lw.270' 'perip_lw.236' 'perip_lw.199'};... %0.5
    {'perip_lw.271' 'perip_lw.235' 'perip_lw.203'};... %1
    {'perip_lw.272' 'perip_lw.234' 'perip_lw.209'};... %2
    {'perip_lw.274' 'perip_lw.233' 'perip_lw.217'};... %4
    {'perip_lw.275' 'perip_lw.232' 'perip_lw.227'};... %8
    {'perip_lw.276' 'perip_lw.231' 'perip_lw.229'}}; %12

controlSubs.LW.Peripho.PsychSlopes.LE = [3.93230 2.35936 2.44951 3.62359 2.99585 2.87574];
controlSubs.LW.Peripho.PsychSlopes.RE = [2.46026 2.69347 2.56623 2.16181 1.72402 2.67836];

% radial
controlSubs.LW.Radial.age = 492;
controlSubs.LW.Radial.LElens = +2.25;
controlSubs.LW.Radial.RElens = +2;
controlSubs.LW.Radial.distanceComp =[] ;
controlSubs.LW.Radial.distancePhys =[] ;
controlSubs.LW.Radial.radius = 1.5;
controlSubs.LW.Radial.sf = 2;

controlSubs.LW.Radial.LE = [
];

controlSubs.LW.Radial.RE = [
4         24213.4     0.04709
8         14716.5     0.04978
16        13040       0.04951
];

controlSubs.LW.Radial.PsychSlopes.LE = [];
controlSubs.LW.Radial.PsychSlopes.RE = [4.42449 3.94865 3.98420];

% verno
controlSubs.LW.Verno.age = ;
controlSubs.LW.Verno.RElens = ;
controlSubs.LW.Verno.LElens = ;

controlSubs.LW.Verno.RE = [];
controlSubs.LW.Verno.LE = [];

controlSubs.LW.Verno.PsychSlopes.LE = ;
controlSubs.LW.Verno.PsychSlopes.RE = ;