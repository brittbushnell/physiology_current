function [XTBlankV1monoc,XTBlankV4monoc,XTdipoleV1monoc,XTdipoleV4monoc,...
          XTBlankV1binoc,XTBlankV4binoc,XTdipoleV1binoc,XTdipoleV4binoc,...
          WUBlankV1monoc,WUBlankV4monoc,WUdipoleV1monoc,WUdipoleV4monoc,...
          WUBlankV1binoc,WUBlankV4binoc,WUdipoleV1binoc,WUdipoleV4binoc,...
          WVBlankV1monoc,WVBlankV4monoc,WVdipoleV1monoc,WVdipoleV4monoc,...
          WVBlankV1binoc,WVBlankV4binoc,WVdipoleV1binoc,WVdipoleV4binoc]= getGlassRegStats(XTdata,WUdata,WVdata)
%% XT
XTBlankV1monoc(1) = XTdata.stimBlankR2.monoc.conRegV1(1);
XTBlankV1monoc(2) = XTdata.stimBlankR2.monoc.radRegV1(1);
XTBlankV1monoc(3) = XTdata.stimBlankR2.monoc.nozRegV1(1);
XTBlankV1monoc(4) = XTdata.stimBlankR2.monoc.trRegV1(1);

XTBlankV4monoc(1) = XTdata.stimBlankR2.monoc.conRegV4(1);
XTBlankV4monoc(2) = XTdata.stimBlankR2.monoc.radRegV4(1);
XTBlankV4monoc(3) = XTdata.stimBlankR2.monoc.nozRegV4(1);
XTBlankV4monoc(4) = XTdata.stimBlankR2.monoc.trRegV4(1);

XTdipoleV1monoc(1) = XTdata.stimNoiseR2.monoc.conRegV1(1);
XTdipoleV1monoc(2) = XTdata.stimNoiseR2.monoc.radRegV1(1);
XTdipoleV1monoc(3) = XTdata.stimNoiseR2.monoc.trRegV1(1);

XTdipoleV4monoc(1) = XTdata.stimNoiseR2.monoc.conRegV4(1);
XTdipoleV4monoc(2) = XTdata.stimNoiseR2.monoc.radRegV4(1);
XTdipoleV4monoc(3) = XTdata.stimNoiseR2.monoc.trRegV4(1);

%% WU 
WUBlankV1monoc(1) = WUdata.stimBlankR2.monoc.conRegV1(1);
WUBlankV1monoc(2) = WUdata.stimBlankR2.monoc.radRegV1(1);
WUBlankV1monoc(3) = WUdata.stimBlankR2.monoc.nozRegV1(1);
WUBlankV1monoc(4) = WUdata.stimBlankR2.monoc.trRegV1(1);

WUBlankV4monoc(1) = WUdata.stimBlankR2.monoc.conRegV4(1);
WUBlankV4monoc(2) = WUdata.stimBlankR2.monoc.radRegV4(1);
WUBlankV4monoc(3) = WUdata.stimBlankR2.monoc.nozRegV4(1);
WUBlankV4monoc(4) = WUdata.stimBlankR2.monoc.trRegV4(1);

WUdipoleV1monoc(1) = WUdata.stimNoiseR2.monoc.conRegV1(1);
WUdipoleV1monoc(2) = WUdata.stimNoiseR2.monoc.radRegV1(1);
WUdipoleV1monoc(3) = WUdata.stimNoiseR2.monoc.trRegV1(1);

WUdipoleV4monoc(1) = WUdata.stimNoiseR2.monoc.conRegV4(1);
WUdipoleV4monoc(2) = WUdata.stimNoiseR2.monoc.radRegV4(1);
WUdipoleV4monoc(3) = WUdata.stimNoiseR2.monoc.trRegV4(1);

%% WV 
WVBlankV1monoc(1) = WVdata.stimBlankR2.monoc.conRegV1(1);
WVBlankV1monoc(2) = WVdata.stimBlankR2.monoc.radRegV1(1);
WVBlankV1monoc(3) = WVdata.stimBlankR2.monoc.nozRegV1(1);
WVBlankV1monoc(4) = WVdata.stimBlankR2.monoc.trRegV1(1);

WVBlankV4monoc(1) = WVdata.stimBlankR2.monoc.conRegV4(1);
WVBlankV4monoc(2) = WVdata.stimBlankR2.monoc.radRegV4(1);
WVBlankV4monoc(3) = WVdata.stimBlankR2.monoc.nozRegV4(1);
WVBlankV4monoc(4) = WVdata.stimBlankR2.monoc.trRegV4(1);

WVdipoleV1monoc(1) = WVdata.stimNoiseR2.monoc.conRegV1(1);
WVdipoleV1monoc(2) = WVdata.stimNoiseR2.monoc.radRegV1(1);
WVdipoleV1monoc(3) = WVdata.stimNoiseR2.monoc.trRegV1(1);

WVdipoleV4monoc(1) = WVdata.stimNoiseR2.monoc.conRegV4(1);
WVdipoleV4monoc(2) = WVdata.stimNoiseR2.monoc.radRegV4(1);
WVdipoleV4monoc(3) = WVdata.stimNoiseR2.monoc.trRegV4(1);

%% WU 
WUBlankV1binoc(1) = WUdata.stimBlankR2.binoc.conRegV1(1);
WUBlankV1binoc(2) = WUdata.stimBlankR2.binoc.radRegV1(1);
WUBlankV1binoc(3) = WUdata.stimBlankR2.binoc.nozRegV1(1);
WUBlankV1binoc(4) = WUdata.stimBlankR2.binoc.trRegV1(1);

WUBlankV4binoc(1) = WUdata.stimBlankR2.binoc.conRegV4(1);
WUBlankV4binoc(2) = WUdata.stimBlankR2.binoc.radRegV4(1);
WUBlankV4binoc(3) = WUdata.stimBlankR2.binoc.nozRegV4(1);
WUBlankV4binoc(4) = WUdata.stimBlankR2.binoc.trRegV4(1);

WUdipoleV1binoc(1) = WUdata.stimNoiseR2.binoc.conRegV1(1);
WUdipoleV1binoc(2) = WUdata.stimNoiseR2.binoc.radRegV1(1);
WUdipoleV1binoc(3) = WUdata.stimNoiseR2.binoc.trRegV1(1);

WUdipoleV4binoc(1) = WUdata.stimNoiseR2.binoc.conRegV4(1);
WUdipoleV4binoc(2) = WUdata.stimNoiseR2.binoc.radRegV4(1);
WUdipoleV4binoc(3) = WUdata.stimNoiseR2.binoc.trRegV4(1);

%% WV 
WVBlankV1binoc(1) = WVdata.stimBlankR2.binoc.conRegV1(1);
WVBlankV1binoc(2) = WVdata.stimBlankR2.binoc.radRegV1(1);
WVBlankV1binoc(3) = WVdata.stimBlankR2.binoc.nozRegV1(1);
WVBlankV1binoc(4) = WVdata.stimBlankR2.binoc.trRegV1(1);

WVBlankV4binoc(1) = WVdata.stimBlankR2.binoc.conRegV4(1);
WVBlankV4binoc(2) = WVdata.stimBlankR2.binoc.radRegV4(1);
WVBlankV4binoc(3) = WVdata.stimBlankR2.binoc.nozRegV4(1);
WVBlankV4binoc(4) = WVdata.stimBlankR2.binoc.trRegV4(1);

WVdipoleV1binoc(1) = WVdata.stimNoiseR2.binoc.conRegV1(1);
WVdipoleV1binoc(2) = WVdata.stimNoiseR2.binoc.radRegV1(1);
WVdipoleV1binoc(3) = WVdata.stimNoiseR2.binoc.trRegV1(1);

WVdipoleV4binoc(1) = WVdata.stimNoiseR2.binoc.conRegV4(1);
WVdipoleV4binoc(2) = WVdata.stimNoiseR2.binoc.radRegV4(1);
WVdipoleV4binoc(3) = WVdata.stimNoiseR2.binoc.trRegV4(1);

%% XT
XTBlankV1binoc(1) = XTdata.stimBlankR2.binoc.conRegV1(1);
XTBlankV1binoc(2) = XTdata.stimBlankR2.binoc.radRegV1(1);
XTBlankV1binoc(3) = XTdata.stimBlankR2.binoc.nozRegV1(1);
XTBlankV1binoc(4) = XTdata.stimBlankR2.binoc.trRegV1(1);

XTBlankV4binoc(1) = XTdata.stimBlankR2.binoc.conRegV4(1);
XTBlankV4binoc(2) = XTdata.stimBlankR2.binoc.radRegV4(1);
XTBlankV4binoc(3) = XTdata.stimBlankR2.binoc.nozRegV4(1);
XTBlankV4binoc(4) = XTdata.stimBlankR2.binoc.trRegV4(1);

XTdipoleV1binoc(1) = XTdata.stimNoiseR2.binoc.conRegV1(1);
XTdipoleV1binoc(2) = XTdata.stimNoiseR2.binoc.radRegV1(1);
XTdipoleV1binoc(3) = XTdata.stimNoiseR2.binoc.trRegV1(1);

XTdipoleV4binoc(1) = XTdata.stimNoiseR2.binoc.conRegV4(1);
XTdipoleV4binoc(2) = XTdata.stimNoiseR2.binoc.radRegV4(1);
XTdipoleV4binoc(3) = XTdata.stimNoiseR2.binoc.trRegV4(1);