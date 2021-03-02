function plotPrefDomOriDiffVsOSI_allQuad(WUV1, WUV4, WVV1, WVV4, XTV1, XTV4) 
%% LE
tempRad = struct2cell(WUV1.trLE.radDiff);
wuV1LEradDiff = cell2mat(tempRad);

tempRad = struct2cell(WVV1.trLE.radDiff);
wvV1LEradDiff = cell2mat(tempRad);

tempRad = struct2cell(XTV1.trLE.radDiff);
xtV1LEradDiff = cell2mat(tempRad);

tempRad = struct2cell(WUV4.trLE.radDiff);
wuV4LEradDiff = cell2mat(tempRad);

tempRad = struct2cell(WVV4.trLE.radDiff);
wvV4LEradDiff = cell2mat(tempRad);

tempRad = struct2cell(XTV4.trLE.radDiff);
xtV4LEradDiff = cell2mat(tempRad);

%
tempCon = struct2cell(WUV1.trLE.conDiff);
wuV1LEconDiff = cell2mat(tempCon);

tempCon = struct2cell(WVV1.trLE.conDiff);
wvV1LEconDiff = cell2mat(tempCon);

tempCon = struct2cell(XTV1.trLE.conDiff);
xtV1LEconDiff = cell2mat(tempCon);

tempCon = struct2cell(WUV4.trLE.conDiff);
wuV4LEconDiff = cell2mat(tempCon);

tempCon = struct2cell(WVV4.trLE.conDiff);
wvV4LEconDiff = cell2mat(tempCon);

tempCon = struct2cell(XTV4.trLE.conDiff);
xtV4LEconDiff = cell2mat(tempCon);

%% RE

tempRad = struct2cell(WUV1.trRE.radDiff);
wuV1REradDiff = cell2mat(tempRad);

tempRad = struct2cell(WVV1.trRE.radDiff);
wvV1REradDiff = cell2mat(tempRad);

tempRad = struct2cell(XTV1.trRE.radDiff);
xtV1REradDiff = cell2mat(tempRad);

tempRad = struct2cell(WUV4.trRE.radDiff);
wuV4REradDiff = cell2mat(tempRad);

tempRad = struct2cell(WVV4.trRE.radDiff);
wvV4REradDiff = cell2mat(tempRad);

tempRad = struct2cell(XTV4.trRE.radDiff);
xtV4REradDiff = cell2mat(tempRad);

%
tempCon = struct2cell(WUV1.trRE.conDiff);
wuV1REconDiff = cell2mat(tempCon);

tempCon = struct2cell(WVV1.trRE.conDiff);
wvV1REconDiff = cell2mat(tempCon);

tempCon = struct2cell(XTV1.trRE.conDiff);
xtV1REconDiff = cell2mat(tempCon);

tempCon = struct2cell(WUV4.trRE.conDiff);
wuV4REconDiff = cell2mat(tempCon);

tempCon = struct2cell(WVV4.trRE.conDiff);
wvV4REconDiff = cell2mat(tempCon);

tempCon = struct2cell(XTV4.trRE.conDiff);
xtV4REconDiff = cell2mat(tempCon);
%% OSIs
% WUV1.trLE.prefParamSI(WUV1.trLE.
%%
figure(4)
clf

subplot(2,2,1)
hold on

