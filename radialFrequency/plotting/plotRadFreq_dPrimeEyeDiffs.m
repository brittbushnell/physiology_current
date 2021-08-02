function plotRadFreq_dPrimeEyeDiffs(LEdata,REdata)
LEdPrimes = LEdata.stimCircDprime;
REdPrimes = REdata.stimCircDprime;

LEdPperm = LEdata.stimCircDprimeBootPerm;
REdPperm = REdata.stimCircDprimeBootPerm;
%%
% for ch = 1:96
%     
%     LEdpCh = squeeze(LEdPrimes(:,:,ch));
%     REdpCh = squeeze(REdPrimes(:,:,ch));
%     
%     LEchPerm = squeeze(LEdPperm(:,:,ch,:));
%     REchPerm = squeeze(REdPperm(:,:,ch,:));
%     for rf = 1:3
%         [y, maxAmp] = max(abs(LEdpCh(rf,:)));
%         
%         dPrimelogDiff(rf,ch) = LogDifference(REmaxDp, LEmaxDp);
%     end
% end
%%
LEdp = nan(3,96);
REdp = nan(3,96);

LEmaxAmp = nan(3,96);
REmaxAmp = nan(3,96);

for ch = 1:96
    if LEdata.goodCh(ch) && REdata.goodCh(ch)
        [LEdp(1,ch), LEmaxAmp(1,ch)] = max(abs(LEdpCh(1,:)));
        [REdp(1,ch), REmaxAmp(1,ch)] = max(abs(REdpCh(1,:)));
        
        [LEdp(2,ch), LEmaxAmp(2,ch)] = max(abs(LEdpCh(2,:)));
        [REdp(2,ch), REmaxAmp(2,ch)] = max(abs(REdpCh(2,:)));
        
        [LEdp(3,ch), LEmaxAmp(3,ch)] = max(abs(LEdpCh(3,:)));
        [REdp(3,ch), REmaxAmp(3,ch)] = max(abs(REdpCh(3,:)));
        
    elseif LEdata.goodCh(ch) && ~REdata.goodCh(ch)
        [LEdp(1,ch), LEmaxAmp(1,ch)] = max(abs(LEdpCh(1,:)));
        [LEdp(2,ch), LEmaxAmp(2,ch)] = max(abs(LEdpCh(2,:)));
        [LEdp(3,ch), LEmaxAmp(3,ch)] = max(abs(LEdpCh(3,:)));
        
        REdp(:,ch) = 0;
        REmaxAmp(:,ch) = 0;
    elseif ~LEdata.goodCh(ch) && REdata.goodCh(ch)
        LEdp(:,ch) = 0;
        LEmaxAmp(:,ch) = 0;
        
        [REdp(1,ch), REmaxAmp(1,ch)] = max(abs(REdpCh(1,:)));
        [REdp(2,ch), REmaxAmp(2,ch)] = max(abs(REdpCh(2,:)));
        [REdp(3,ch), REmaxAmp(3,ch)] = max(abs(REdpCh(3,:)));
    end
end
%%
% figure(4)
% clf
% 
% subplot(3,1,1)
% hold on
% axis square
% 
% for ch = 1:96
%     if LEdata.goodCh(ch) || REdata.goodCh(ch)
%         LE = LEdp(1,ch);
%         LEamp = LEmaxAmp(1,ch);
%         
%         RE = REdp(1,ch);
%         REamp = REmaxAmp(1,ch);
%         
%         if LEamp~= 0
%             LEdPrimeSig = squeeze(LEdata.stimCircDprimeSig(1,LEamp,ch));
%             LEcorrSig   = squeeze(LEdata.stimCorrSig(1,ch));
%         else
%             LEdprimeSig = 0;
%             LEcorrSig = 0;
%         end
%         
%         if REamp ~=0
%             REdPrimeSig = squeeze(REdata.stimCircDprimeSig(1,REamp,ch));
%             REcorrSig   = squeeze(REdata.stimCorrSig(1,ch));
%         else
%             REdPrimeSig = 0;
%             REcorrSig = 0;
%         end
%   
%         if LEdPrimeSig || LEcorrSig || REdPrimeSig || REcorrSig
%             scatter(LE,RE,'MarkerFaceColor',[0.7 0 0.7], 'MarkerEdgeColor','w','MarkerFaceAlpha',0.7, 'MarkerEdgeAlpha',0.7)
%         else
%             scatter(LE,RE,'MarkerFaceColor','none', 'MarkerEdgeColor',[0.7 0 0.7],'MarkerFaceAlpha',0.7, 'MarkerEdgeAlpha',0.7)
%         end
%     end
% end
%%
figure(5)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1), pos(2), 1000, 900])%,'PaperOrientation','landscape')

s = suptitle(sprintf('%s %s amplitude with largest d'' for each eye',LEdata.animal, LEdata.array));
s.Position(2) = s.Position(2) +0.025;

subplot(3,1,1)
hold on

xlim([0 97])
ylim([1 6.2])
% axis square

scatter(1:96,LEmaxAmp(1,:)-0.05,50,'o','MarkerFaceColor',[0.2 0.4 1],...
    'MarkerEdgeColor','w','MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.7)

scatter(1:96,REmaxAmp(1,:)+0.05,50,'o','MarkerFaceColor','r',...
    'MarkerEdgeColor','w','MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.7)

ylabel('Amplitude with max d''')
% xlabel('Channel')
title('RF 4')
set(gca,'tickdir','out','FontAngle','italic','FontSize',10)

subplot(3,1,2)
hold on

xlim([0 97])
ylim([1 6.2])
% axis square

scatter(1:96,LEmaxAmp(2,:)-0.05,50,'o','MarkerFaceColor',[0.2 0.4 1],...
    'MarkerEdgeColor','w','MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.7)

scatter(1:96,REmaxAmp(2,:)+0.05,50,'o','MarkerFaceColor','r',...
    'MarkerEdgeColor','w','MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.7)

% xlabel('Channel')
ylabel('Amplitude with max d''')
title('RF 8')
set(gca,'tickdir','out','FontAngle','italic','FontSize',10)

text(90, 1.2,'LE/FE','FontSize',10,'FontWeight','bold','Color','r')
text(90, 1.55,'RE/AE','FontSize',10,'FontWeight','bold','Color',[0.2 0.4 1])

subplot(3,1,3)
hold on

xlim([0 97])
ylim([1 6.2])
% axis square

scatter(1:96,LEmaxAmp(3,:)-0.05,50,'o','MarkerFaceColor',[0.2 0.4 1],...
    'MarkerEdgeColor','w','MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.7)

scatter(1:96,REmaxAmp(3,:)+0.05,50,'o','MarkerFaceColor','r',...
    'MarkerEdgeColor','w','MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.7)

xlabel('Channel')
ylabel('Amplitude with max d''')
title('RF 16')
set(gca,'tickdir','out','FontAngle','italic','FontSize',10)

set(gcf,'InvertHardcopy','off','Color','w')
figName = [LEdata.animal,'_BE_',LEdata.array,'_',LEdata.programID,'_ampMaxDprime','.pdf'];
print(gcf, figName,'-dpdf','-bestfit')