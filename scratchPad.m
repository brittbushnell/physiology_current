    fname = 'XT_LE_gratings_nsp2_20181107_004_thresh30.nev';    
    data = load(fname);
        
        amap = getBlackrockArrayMap(fname);
        blank = data.spatial_frequency == 0;
        grat  = data.spatial_frequency > 0.1;
        
        fnameParts = strsplit(fname,'_');
        if contains(fnameParts{4},'nsp1')
            array = 'V1';
        else
            array = 'V4';
        end
        
        if location == 1 % laca
        if contains(fname,'thresh')
            figDir = sprintf('/users/bushnell/bushnell-local/Dropbox/Figures/%s/Gratings/%s/cleanRawPSTH/cleaned',fnameParts{1},array);
        else
            figDir = sprintf('/users/bushnell/bushnell-local/Dropbox/Figures/%s/Gratings/%s/cleanRawPSTH/raw',fnameParts{1},array);
        end
        end
        
        if ~exist(figDir,'dir')
            mkdir(figDir)
        end
        cd(figDir)
        
        figure(1)
        clf
        pos = get(gcf,'Position');
        set(gcf,'Position',[pos(1) pos(2) 1200 900])
        set(gcf,'PaperOrientation','Landscape');
        
        for ch = 1:96
            subplot(amap,10,10,ch)
            hold on
            
            blankResp = mean(smoothdata(data.bins((data.spatial_frequency == 0), 1:35 ,ch),'gaussian',3))./0.01;
            stimResp = mean(smoothdata(data.bins((data.spatial_frequency > 0.1), 1:35 ,ch),'gaussian',3))./0.01;
            plot(1:35,blankResp,'k','LineWidth',0.5);
            plot(1:35,stimResp,'k','LineWidth',2);
        end
        s = suptitle(sprintf('%s',fname));
        s.Position(2) = s.Position(2) +0.02;
        s.Interpreter = 'none';
        fname = strrep(fname,'.mat',[]);
        figName = [fname,'_','PSTH','.pdf'];
        print(gcf, figName,'-dpdf','-bestfit')
        %%
        data = XTV4LE;
        ch = 50;
        endBin = 90;
        
        figure(2)
        clf
        set(gcf,'PaperSize',[5 5])
        
        hold on
        
        blankNdx = data.rf > 40;
        stimNdx = data.rf < 35;
        blankResp = mean(smoothdata(data.bins(blankNdx, 1:endBin ,ch),'gaussian',3))./0.01;
        stimResp = mean(smoothdata(data.bins(stimNdx, 1:endBin ,ch),'gaussian',3))./0.01;
        plot(1:endBin,blankResp,'k','LineWidth',0.5);
        plot(1:endBin,stimResp,'k','LineWidth',2);
