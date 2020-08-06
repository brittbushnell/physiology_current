function [] = reThreshold(varargin)
% This function takes in a list of file names and run them through the
% re-thresholding and cleaning program created by Manu. If not using 3.5 as
% the new threshold, you need to specify that as the second input. 
%
%
% All cleaned and thresholded files are saved to program, animal, and eye
% specific folders within vnlstorage3/reThresholded.  
%
% If a re-thresholded version of the file has already been created, then
% the file is skipped and the program will move onto the next one.
%
%
%%
switch nargin
    case 0 
        error('Must pass in at least one file name')
    case 1
        fprintf('\n rethresholding the files to 3.5\n')
        files = varargin{1};
        threshold = 3.5;
    case 2
        fprintf('\n rethresholding the files to %.1f\n',varargin{2})
        files = varargin{1};
        threshold = varargin{2};
end
%%
failedFiles = {};
failedNdx = 0;

for fi = 1:length(files)
    try
        filename = files{fi};
        fprintf('*** running file %s ***\n %d/%d\n ',filename,fi,length(files))
        tmp1 = strsplit(filename,'/');
        tmp = strsplit(string(tmp1(end)),'_');
        [animal,eye,programID,array,~,~] = deal(tmp{:});
        
%         ns6 = sprintf('/km/vs/array/bushnell_arrays/%s/%s_blackrock/%s/%s.ns6',array,array,animal,filename);
%         nev = sprintf('/km/vs/array/bushnell_arrays/%s/%s_blackrock/%s/%s.nev',array,array,animal,filename);

        ns6 = sprintf('%s.ns6',filename);
        nev = sprintf('%s.nev',filename);
        tname = strsplit(filename,'/');
        shortname = char(tname(end));
        newName = [shortname, sprintf('_thresh%d',threshold*10),'.nev'];
        
        if contains(programID,'grat','IgnoreCase',true)
            output = sprintf('/mnt/vnlstorage3/bushnell_arrays/%s/reThreshold/gratings/%s/%s/%s',array,animal,eye,newName);
        elseif contains(programID,'glass','IgnoreCase',true)
            output = sprintf('/mnt/vnlstorage3/bushnell_arrays/%s/reThreshold/png/glass/%s/%s/%s',array,animal,eye,newName);
        else
            output = sprintf('/mnt/vnlstorage3/bushnell_arrays/%s/reThreshold/png/%s/%s/%s',array,animal,eye,newName);
        end

        if ~exist(output,'file')
            car_nsx(nev,ns6,output,threshold);
            fprintf('done cleaning and thresholding after %.2f minutes\n',toc/60)
        else
            fprintf('%s  already exists, moving to next file\n',newName)
        end       
        
    catch ME
        failedNdx = failedNdx+1;
        failedFiles{failedNdx} = ME;
    end
end