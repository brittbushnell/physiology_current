% plotting OSI vs CRI - hypothetically channels should be really strongly
% tuned for only one of these two metrics
This is still an interesting question, but need to either compute the CRI on all channels or just do OSI for the data points used in triplot
%%
XTOSIv1RE = XTV1.trRE.OSI;
XTOSIv1LE = XTV1.trLE.OSI;

XTOSIv4RE = XTV4.trRE.OSI;
XTOSIv4LE = XTV4.trLE.OSI;

WUOSIv1RE = WUV1.trRE.OSI;
WUOSIv1LE = WUV1.trLE.OSI;

WUOSIv4RE = WUV4.trRE.OSI;
WUOSIv4LE = WUV4.trLE.OSI;

WVOSIv1RE = WVV1.trRE.OSI;
WVOSIv1LE = WVV1.trLE.OSI;

WVOSIv4RE = WVV4.trRE.OSI;
WVOSIv4LE = WVV4.trLE.OSI;

XTCRIv1RE = XTV1.conRadRE.CRI;
XTCRIv1LE = XTV1.conRadLE.CRI;

XTCRIv4RE = XTV4.conRadRE.CRI;
XTCRIv4LE = XTV4.conRadLE.CRI;

WUCRIv1RE = WUV1.conRadRE.CRI;
WUCRIv1LE = WUV1.conRadLE.CRI;

WUCRIv4RE = WUV4.conRadRE.CRI;
WUCRIv4LE = WUV4.conRadLE.CRI;

WVCRIv1RE = WVV1.conRadRE.CRI;
WVCRIv1LE = WVV1.conRadLE.CRI;

WVCRIv4RE = WVV4.conRadRE.CRI;
WVCRIv4LE = WVV4.conRadLE.CRI;
%%
figure(1)
clf
pos = get(gcf,'Position');
% set(gcf,'Position',[pos(1),pos(2),600,400],'InvertHardcopy','off','PaperSize',[7.5,6.5])

subplot(2,2,1)
hold on
scatter(XTOSIv1LE,XTCRIv1LE,'ok')






