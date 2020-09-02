




% resps = [69.4792   91.2500  128.4375  110.3125   83.3333   74.4792]; %V4
% % blank = mean(LEdata.oriXsf{ch}(:,1));
% %resps = [39.5312   38.4375   27.5000   20.6250   32.5000   32.5000]; %V1
%
% fake2 = [0.0 0.0 0.1 0.3 0.5 0.5 0.3 0.1 0.0 0.0];
% oris = linspace(0,150,length(fake2));
% or = oris/180 * pi;
%
% % oris = [0:5:150];
% % ors = [0 30 60 90 120 150];
% % or = ors/180 * pi;
%
% sfs = log10([0.325 0.65 1.25 2.5 5 10]);
% nStart = 200;
% %%
% amp =2;
% mu_or = mean(or);
% kappa_or = 2;
% %
% % %
% % % amp = LEdata.surfParams{ch}(1);
% % % kappa_or = LEdata.surfParams{ch}(4);
% % % mu_or = LEdata.surfParams{ch}(2);
% % % amp = LEdata.surfParams{ch}(1);
% %
% % figure(1)
% % clf
% %for i = 1:3
% %     subplot(1,3,1)
% %    kappa_or = kappa_or+1;
% % exp(kappa*cos(xx-mux))
% figure
% vonMis = (amp).*(exp(kappa_or*cos(fake2-mu_or)));
% %if i == 1
% plot(or,fake2,'ok')
% %end
% hold on
% plot(or,vonMis,'-')
% ylim([0 0.7])
% set(gca,'box', 'off','color', 'none', 'tickdir','out')
% title('fitting fake data w/ random VM values')
%%
%     subplot(1,3,2)
% %    kappa_or = kappa_or+1;
%     vonMis = blank+amp.*exp(-kappa_or + cos(resps - mu_or)) / (pi)% * besseli(0,kappa_or));
%       %  if i == 1
%             plot(ors,resps,'ok')
%        % end
%     hold on
%     plot(ors,vonMis,'-')
%     title('TVG VonMises varying K')
%
%     subplot(1,3,3)
% %    kappa_or = kappa_or+1;
%     vonMis = blank+amp* exp(-kappa_or.*(cos(resps - mu_or)) -1);
%        % if i == 1
%             plot(ors,resps,'ok')
%        % end
%     hold on
%     plot(ors,vonMis,'-')
%     title('NJM VonMises varying K')

%     subplot(2,3,4)
% %    amp = amp+2;
%     vonMis = amp*(exp(kappa_or*cos(resps-mu_or)));
%         if i == 1
%             plot(ors,resps,'ok')
%         end
%     hold on
%     plot(ors,vonMis,'-')
%     title('varying amp')
%
%     subplot(2,3,5)
% %    amp = amp+2;
%     vonMis = 30+amp.* exp(kappa_or + cos(resps - mu_or)) / (pi * besseli(0,kappa_or));
%         if i == 1
%             plot(ors,resps,'ok')
%         end
%     hold on
%     plot(ors,vonMis,'-')
%     title('varying amp')
%
%     subplot(2,3,6)
% %    amp = amp+2;
%     vonMis = amp* exp(kappa_or.*(cos(resps - mu_or)) -1);
%         if i == 1
%             plot(ors,resps,'ok')
%         end
%     hold on
%     plot(ors,vonMis,'-')
%     title('varying amp')
%end

% figure
% for i = 1:10
%     amp = amp*2;
%     vonMis3 = 30+amp.* exp(kappa_or.*(cos(resps - mu_or)) -1);
% %     if i == 1
% %         plot(ors,resps,'ok')
% %     end
%     hold on
%     plot(ors,vonMis3,'-')
% end

% figure
% for i = 1:10
%     mu_or = 100*pi/180;
%     vonMis3 = 30+amp.* exp(kappa_or.*(cos(resps - mu_or)) -1);
%     if i == 1
%         plot(ors,resps,'ok')
%     end
%     hold on
%     plot(ors,vonMis3,'-')
% end
%% sf
% mu_sf = 2;
% kappa_sf = 1;
% gaus = amp .*(exp((-(sfs-mu_sf).^2)/(2*kappa_sf^2)));  %This should be SF
% % gaus2 = amp
%
% vonMis = amp.*(exp(kappa_or*cos(or-mu_or)));   % This should be ori
% vonMis2 = amp.* exp(kappa_or + cos(oris - mu_or)) / (pi * besseli(0,kappa_or));

%figure
%semilogx(sfs,gaus,'r-');
%%
close all

cmap = [1 0 0;
    1 0.5 0;
    0 0.7 0;
    0 0 1;
    0 1 1;
    0.5 0 1];

fake = [0.0 0.0 0.0 0.0 0.0 0.0;
    0.0 0.2 0.2 0.2 0.2 0.0;
    0.1 0.3 0.5 0.5 0.3 0.1;
    0.1 0.3 0.5 0.5 0.3 0.1;
    0.0 0.2 0.2 0.2 0.2 0.0;
    0.0 0.0 0.0 0.0 0.0 0.0];

% fake = [0 0.1 0.3 0.5 0.7 0.8];
% fake = repmat(fake,[6,1]);

fake2 = [5 6 5 8 13 19
    4 5 4 5 8 12
    1 1 2 4 12 16
    1 1 2 4 14 18
    4 5 4 5 12 16
    6 5 6 8 13 19];

oris = linspace(0,360,length(fake));
sfs = ([0.325 0.65 1.25 2.5 5 10]);
nStart = 200;
fake2S = zeros(size(fake2));
fakeS = zeros(size(fake));

%for i = 1:5
    for l = 1:numel(fake)
        fake2S(l) = fake2(l) + rand(1);
        fakeS(l) = fake(l) + (randi(2,1)+rand(1));
    end
    
    [P,Fhat,Fun] = FitVMBlob_Mwks_T(oris,sfs,fake,nStart);

    
    [PS,FhatS,FunS] = FitVMBlob_Mwks_T(oris,sfs,fakeS,nStart);

    
    [P2,Fhat2,Fun2] = FitVMBlob_Mwks_T(oris,sfs,fake2,nStart);

    
    [P2S,Fhat2S,Fun2S] = FitVMBlob_Mwks_T(oris,sfs,fake2S,nStart);
    
    
    
    
    [X,Y] = meshgrid([0.3125 0.625 1.25 2.5 5 10], [0 30 60 90 120 150]);
    %[X,Y] = meshgrid([1 2 3 4 5 6], [1 2 3 4 5 6]);
    
    figure
    
    subplot(2,2,1)
    set(gca,'box', 'off','color', 'none', 'tickdir','out','XScale','log','ColorOrder',cmap,'NextPlot','replacechildren')
    hold on
    plot3(X,Y,fake,'.','MarkerSize',20)
    plot3(X,Y,Fhat,'-','LineWidth',3)
    colormap(cmap)
    surface(X,Y,Fhat,'FaceColor','none')
    grid on
    title('fake data')  
    view(3)
    
    subplot(2,2,2)
    set(gca,'box', 'off','color', 'none', 'tickdir','out','XScale','log','ColorOrder',cmap,'NextPlot','replacechildren')
    hold on
    plot3(X,Y,fakeS,'.','MarkerSize',20)
    plot3(X,Y,FhatS,'-','LineWidth',3)
    colormap(cmap)
    surface(X,Y,FhatS,'FaceColor','none')
    grid on
    title('fake data + noise')  
    view(3)
    
    subplot(2,2,3)
    set(gca,'box', 'off','color', 'none', 'tickdir','out','XScale','log','ColorOrder',cmap,'NextPlot','replacechildren')
    hold on
    plot3(X,Y,fake2,'.','MarkerSize',20)
    plot3(X,Y,Fhat2,'-','LineWidth',3)
    colormap(cmap)
    surface(X,Y,Fhat2,'FaceColor','none')
    grid on
    title('fake data')  
    view(3)
    
    subplot(2,2,4)
    set(gca,'box', 'off','color', 'none', 'tickdir','out','XScale','log','ColorOrder',cmap,'NextPlot','replacechildren')
    hold on
    plot3(X,Y,fake2S,'.','MarkerSize',20)
    plot3(X,Y,Fhat2S,'-','LineWidth',3)
    colormap(cmap)
    surface(X,Y,Fhat2S,'FaceColor','none')
    grid on
    title('fake data + noise')  
    view(3)
    
    
    
%     pause(0.15)
% end