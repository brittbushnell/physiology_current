function [] = psthFigMwksArray(data,topTitle, ndx1, ndx2)

% This function creates PSTH figures for data collected on an array and run
% with MWorks. Only does basic 
%
% INPUT
%  DATA is the full data structure
%
%  TOPTITLE is title you want at the top of the figure, assuming FE or AE
%  abbreviations are used.
%
%  NDX1 and NDX2 are 96xN matrices with 1 or 0 to indicate when the desire
%  stimulus type was shown. always 96 rows (one for each channel) with N
%  columns to match the number  of stimulus presentations. 
%      NDX1 will always be plotted in black
%      NDX2 will always be plotted in red
%
% Written Brittany Bushnell October 9, 2017

stimOn  = unique(data.stimOn);
stimOff = unique(data.stimOff);

binStimOn  = stimOn/10;
binStimOff = stimOff/10;
numChannels = size(data.bins,3);

figure
for ch = 1:numChannels  %length(goodChannels)

    ndx1Ref = ndx1;
    ndx2Ref = ndx2; % cannot be ~= 0 because the mask is set to -1.
    
%    ndx1Resps = data.bins(ndx1Ref,1:(binStimOn+binStimOff),ch);
    ndx1Resps = data.bins(ndx1Ref,:,ch);
    ndx1RespsMean = mean(ndx1Resps,1)./0.010;
    
%     ndx2Resps = data.bins(ndx2Ref,1:(binStimOn+binStimOff),ch);
    ndx2Resps = data.bins(ndx2Ref,:,ch);
    ndx2RespsMean = mean(ndx2Resps,1)./0.010;
    
    xaxis = 1:size(data.bins,2);
    
%     if strfind (topTitle,'FE')
%         figure (1)
%     else
%         figure(2)
%     end
    
    subplot(data.amap,10,10,ch)
    hold on
    plot(xaxis, ndx1RespsMean,'k')
    plot(xaxis, ndx2RespsMean,'r')
    title (sprintf('%d',ch))
    set(gca,'box', 'off','color', 'none', 'tickdir','out', 'XTickLabelRotation', 45,'XTick',[10 50 90],'XTickLabel',{'100','500','900'},...
        'FontSize',6)
    
    if ch == 1
        annotation('textbox',...
            [0.4 0.94 0.35 0.05],...
            'LineStyle','none',...
            'String',topTitle,...
            'Interpreter','none',...
            'FontSize',12,...
            'FontAngle','italic',...
            'FontName','Helvetica Neue');
    end
end