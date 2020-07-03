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

for fi = 1:size(files,1)
%    try
        filename = files{fi};
        fprintf('*** running file %s ***\n %d/%d\n ',filename,fi,size(files,1))
        tmp = strsplit(filename,'_');
        [animal,eye,programID,array,~,~] = deal(tmp{:});
        
        ns6 = sprintf('/km/vs/array/bushnell_arrays/%s/%s_blackrock/WU/%s/.ns6',array,array,filename);
        nev = sprintf('/km/vs/array/bushnell_arrays/%s/%s_blackrock/WU/%s/.nev',array,array,filename);
        
        newName = [filename, sprintf('_thresh%d',threshold*10)];
        
        if contains(programID,'grat','IgnoreCase',true)
            output = sprintf('/mnt/vnlstorage3/bushnell_arrays/%s/reThreshold/gratings/%s/%s/',array,filename,newName,animal,eye);
        else
            output = sprintf('/mnt/vnlstorage3/bushnell_arrays/%s/reThreshold/png/%s/%s/',array,filename,newName,animal,eye);
        end
        
        if ~exist(fullfile(output,newName),'file')
            car_nsx(nev,ns6,output,threshold);
            fprintf('done cleaning and thresholding after %.2f hours\n',toc/3600)
        else
            fprintf('%s  already exists, moving to next file\n',newName)
        end       
        
%     catch ME
%         failedNdx = failedNdx+1;
%         failedFiles{failedNdx} = ME;
%     end
end