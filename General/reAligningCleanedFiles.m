% this function will go through the files that are misaligned, and run step
% 2 of Manu's cleaning pipeline on them.  The list of files that needs to
% be run is kept up to date in the function badFilesLookup. This function
% will also look through the cleaned files directory and check to see if it
% has already been aligned. If it has, the file is skipped and it will move
% on to the next one.
%%
clear
close all
tic
%%
files = badFilesLookup;
failNdx = 0;

for fi = 1:length(files)
     try
        nev = string(files{fi});
        fprintf('\n***Running %s file %d/%d***\n', nev,fi,length(files))
        
        short_name = strrep(nev,'_thresh35','');
        file_info = strsplit(short_name,'_');
        short_name = char(short_name);
        cleanDir = sprintf('/v/awake/%s/recordings/%sReThreshold/gratingsAndEdges/%s', file_info(1), file_info(4), file_info(2));
        %         cleanDir = sprintf('/mnt/vnlstorage3/bushnell_arrays/%s/reThreshold/png/%s/%s/',file_info(4),file_info(1),file_info(2));
        cd(cleanDir)
        newEnd = '_ogcorrupt.nev';
        checkName = strcat(nev,newEnd);
        %%
        %         if ~exist(checkName,'file')
        %             date = str2double(file_info(5));
        %             if contains(file_info(1),'WU')
        %                 blackrockDir = sprintf('/mnt/vnlstorage/bushnell_arrays/%s/%s_blackrock/%s/',file_info(4),file_info(4),file_info(1));
        %             elseif contains(file_info(1),'XT')
        %                 if date <= 20190131
        %                     blackrockDir = sprintf('/mnt/vnlstorage/bushnell_arrays/%s/%s_blackrock/%s/',file_info(4),file_info(4),file_info(1));
        %                 else
        %                     blackrockDir = sprintf('/mnt/vnlstorage2/bushnell_arrays/%s/%s_blackrock/%s/',file_info(4),file_info(4),file_info(1));
        %                 end
        %             elseif contains(file_info(1),'WV')
        %                 if date <= 20190130
        %                     blackrockDir = sprintf('/mnt/vnlstorage/bushnell_arrays/%s/%s_blackrock/%s/',file_info(4),file_info(4),file_info(1));
        %                 elseif date > 20190130 && date <= 20191603
        %                     blackrockDir = sprintf('/mnt/vnlstorage2/bushnell_arrays/%s/%s_blackrock/%s/',file_info(4),file_info(4),file_info(1));
        %                 else
        %                     blackrockDir = sprintf('/mnt/vnlstorage3/bushnell_arrays/%s/%s_blackrock/%s/',file_info(4),file_info(4),file_info(1));
        %                 end
        %             end
        %%
        blackrockDir = sprintf('/v/awake/%s/recordings/%sRaw/',file_info(1), file_info(4));
        cleaned_nev = fullfile(cleanDir,char(nev));
        cleaned_nev = [cleaned_nev,'.nev'];
        nsx_filename = fullfile(blackrockDir,short_name);
        nsx_filename = [nsx_filename,'.ns6'];
        
        nev_filename = fullfile(blackrockDir,short_name);
        nev_filename = [nev_filename,'.nev'];
        
        corruptednsx_cleanup(nev_filename,nsx_filename,cleaned_nev)
        
        fprintf('aligned %d/%d files\n',fi,length(files))
        clear nev_filename
        clear nsx_filename
        fprintf('File aligned after %.2f min\n',toc/60)
        %         else
        %             fprintf('%s was already realigned, moving on to the next one',nev)
        %     end
        
     catch ME
        failNdx = failNdx+1;
        failFile{failNdx,1} = nev;
        failInfo{failNdx,1} = ME.message;
    end
end
% toc/60


%%








