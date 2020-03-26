function quickspikesort(filename)
%%
filename_sort = [filename(1:end-3) 'sort.nev'];
nev = openNEV_rk(filename,'read','nosave','nomat');
if ~exist(filename_sort,'file')
   copyfile(filename,filename_sort);
end
fid=fopen([filename(1:end-3) 'sort.nev'],'r+');

for pass = 1
    fprintf('\n');
    for channum = 1:96
        if pass==1
            AllSpikesOnElectrode = find((nev.Data.Spikes.Electrode==channum));
        else
            AllSpikesOnElectrode = find((nev.Data.Spikes.Electrode==channum)&(nev.Data.Spikes.Unit==0));
        end
        traces = double(nev.Data.Spikes.Waveform(:,AllSpikesOnElectrode));
        if size(traces,2)>100
            rng = 1:30;
            %pc=pca(traces');
            %reference = pc(rng,1);
            %val = corr(reference,traces(rng,:));
            %if pass == 1
                [~,b]=sort(traces(10,:));
                reference = median(traces(:,b(1:100)),2);
                %reference = median(traces(:,abs(traces(10,:))>10*std(traces(1,:))),2);
            %else
            %    reference = median(traces(:,abs(traces(18,:))>5*std(traces(1,:))),2);
            %end
            %val = corr(sign(reference(rng,:)).*(abs(reference(rng,:)).^.5),sign(traces(rng,:)).*(abs(traces(rng,:)).^.5));
            val = corr(reference(rng,:),traces(rng,:));
            val = (0.5.*log((1+val)./(1-val)));%./sqrt(1/(length(rng)-3));
            valndx = logical(abs(val)>-norminv(0.05/2,0,1));
            nev.Data.Spikes.Unit(AllSpikesOnElectrode(~valndx)) = 0;
            nev.Data.Spikes.Unit(AllSpikesOnElectrode( valndx)) = pass;
            
            for ii=(nev.Data.Spikes.FileOffset(AllSpikesOnElectrode(valndx))+6)
                fseek(fid,ii,'bof');
                fwrite(fid,pass,'uint8');                
            end
            if pass==1
                for ii=(nev.Data.Spikes.FileOffset(AllSpikesOnElectrode(~valndx))+6)
                    fseek(fid,ii,'bof');
                    fwrite(fid,0,'uint8');
                end
            end
            fprintf('%02d: %06d/%06d (%5.1f%%) |',channum,sum(valndx(1,:)),size(traces,2),100.*sum(valndx(1,:))./size(traces,2))
        else
            fprintf('                           |');
        end
        if ~mod(channum,4)
            fprintf('\n');
        end
    end
end
fclose(fid);


% %%
% 
% for e=74;
%     figure(1);
%     clf;
%     set(gcf,'color','w');
%     RANGE = 0:10:1000;
%     if sum(nev.Data.Spikes.Electrode==e) < 10
%         continue;
%     end
%     subplot(1,2,1);
%     d = nev.Data.Spikes.Waveform(:,(nev.Data.Spikes.Electrode==e));
%     plot((-9:38)/30,d(:,1:20:end),'k');
%     %title('All Units');
%     maxy = ceil(double(max(abs(d(:))))/250)*250;
%     axis([-9/30 38/30 maxy.*[-1 1]]);
%     box off;set(gca,'tickdir','out');
%     
%     subplot(1,2,2);
%     d = nev.Data.Spikes.TimeStamp(:,(nev.Data.Spikes.Electrode==e));
%     h=bar(RANGE/10,histc(diff(d),RANGE),'histc');
%     set(h,'edgecolor','none');
%     xlim([min(RANGE) max(RANGE)]/10);
%     box off;set(gca,'tickdir','out');
%     
%     subplot(1,2,1);
%     hold on;
%     d = nev.Data.Spikes.Waveform(:,(nev.Data.Spikes.Electrode==e)&(nev.Data.Spikes.Unit==1));
%     if size(d,2)<10
%         continue;
%     end
%     plot((-9:38)/30,d(:,1:20:end),'r');
%     title(sprintf('Electrode: %02d, Unit 1 | %d spks',e,size(d,2)));
%     axis([-9/30 38/30 maxy.*[-1 1]]);
%     box off;set(gca,'tickdir','out');
%     hold off;
%     
%     subplot(1,2,2);
%     hold on;
%     d = nev.Data.Spikes.TimeStamp(:,(nev.Data.Spikes.Electrode==e)&(nev.Data.Spikes.Unit==1));
%     h=bar(RANGE/10,histc(diff(d),RANGE),'histc');
%     set(h,'edgecolor','none','facealpha',1,'facecolor','r');
%     xlim([min(RANGE) max(RANGE)]/10);
%     box off;set(gca,'tickdir','out');
%     hold off;
% 
%     subplot(1,2,1);
%     hold on;
%     d = nev.Data.Spikes.Waveform(:,(nev.Data.Spikes.Electrode==e)&(nev.Data.Spikes.Unit==2));
%     if size(d,2)<10
%         continue;
%     end
%     plot((-9:38)/30,d(:,1:20:end),'g');
%     title(sprintf('Electrode: %02d, Unit 2 | %d spks',e,size(d,2)));
%     axis([-9/30 38/30 maxy.*[-1 1]]);
%     box off;set(gca,'tickdir','out');
%     hold off;
%     
%     subplot(1,2,2);
%     hold on;
%     d = nev.Data.Spikes.TimeStamp(:,(nev.Data.Spikes.Electrode==e)&(nev.Data.Spikes.Unit==2));
%     h=bar(RANGE/10,histc(diff(d),RANGE),'histc');
%     set(h,'edgecolor','none','facealpha',.5,'facecolor','g');
%     xlim([min(RANGE) max(RANGE)]/10);
%     box off;set(gca,'tickdir','out');
%     hold off;
% 
%     drawnow;
% end