function [XTBlankV1binoc,XTBlankV4binoc,XTdipoleV1binoc,XTdipoleV4binoc,...
          WUBlankV1binoc,WUBlankV4binoc,WUdipoleV1binoc,WUdipoleV4binoc,...
          WVBlankV1binoc,WVBlankV4binoc,WVdipoleV1binoc,WVdipoleV4binoc]= getGlassRegStatsBinocOnly(XTdata,WUdata,WVdata)
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