clc
clear
close all
tic;
%%
%%
% figure out what you're running
monks = {
    %'WU';
    %'WV';
    'XT';
    };
brArray = {
    'nsp2';
    'nsp1';
    };
ez = {
    'LE';
    'RE';
    };

%stimType = 'png';
stimType = 'gratings';
%%

failNdx = 0;

ndx = 1;
files = {};
for an = 1:length(monks)
    animal = monks{an};
    for ar = 1:length(brArray)
        array = brArray{ar};
        %%
        inputDir = sprintf('/v/awake/%s/recordings/%sRaw/',animal, array);
        cd(inputDir);
        tmp = dir;
        %%
        for t = 1:size(tmp,1)
            if contains(stimType,'gratings')
                if contains(tmp(t).name,'gratings','IgnoreCase',true)
                    files{ndx} = tmp(t).name;
                    ndx = ndx+1;
                end
            end
        end
    end
end
files = files'; % this just makes it easier to  look at the file names to make sure it's pulling the correct ones
%%
if contains(stimType,'grat','IgnoreCase',true)
    files(contains(files,'Contour','IgnoreCase',true)) = [];
end
%%
for fi = 1:length(files)
    try
        filename = string(files{fi});
%         if contains(stimType,'png')
%             if contains(filename,'map','IgnoreCase',true)
%                 outputDir = sprintf('/users/bushnell/Desktop/my_zemina/vnlstorage3/bushnell_arrays/%s/reThreshold/%s/%s/parsed/Mapping/%s/',array,stimType,animal,eye);
%             elseif contains(filename,'glass','IgnoreCase',true)
%                 outputDir = sprintf('/users/bushnell/Desktop/my_zemina/vnlstorage3/bushnell_arrays/%s/reThreshold/%s/%s/parsed/Glass/%s/',array,stimType,animal,eye);
%             elseif contains(filename,'freq','IgnoreCase',true)
%                 outputDir = sprintf('/users/bushnell/Desktop/my_zemina/vnlstorage3/bushnell_arrays/%s/reThreshold/%s/%s/parsed/RadialFrequency/%s/',array,stimType,animal,eye);
%             elseif contains(filename,'tex','IgnoreCase',true)
%                 outputDir = sprintf('/users/bushnell/Desktop/my_zemina/vnlstorage3/bushnell_arrays/%s/reThreshold/%s/%s/parsed/Textures/%s/',array,stimType,animal,eye);
%             elseif contains(filename,'Pasupathy','IgnoreCase',true)
%                 outputDir = sprintf('/users/bushnell/Desktop/my_zemina/vnlstorage3/bushnell_arrays/%s/reThreshold/%s/%s/parsed/Pasupathy/%s/',array,stimType,animal,eye);
%             elseif contains(filename,'edge','IgnoreCase',true)
%                 outputDir = sprintf('/users/bushnell/Desktop/my_zemina/vnlstorage3/bushnell_arrays/%s/reThreshold/%s/%s/parsed/Edge/%s/',array,stimType,animal,eye);
%             else
%                 outputDir = sprintf('/users/bushnell/Desktop/my_zemina/vnlstorage3/bushnell_arrays/%s/reThreshold/%s/%s/parsed/%s/',array,stimType,animal,eye);
%             end
%         else
            if contains (filename,'map','IgnoreCase',true)
                outputDir = sprintf('/users/bushnell/Desktop/my_zemina/vnlstorage3/bushnell_arrays/%s/reThreshold/%s/%s/parsed/Mapping/%s/',array,stimType,animal,eye);
                outputDir = sprintf('/v/awake/%s/recordings/%sReThreshold/gratingsAndEdges/%s', animal, array, eye);
            else
                outputDir = sprintf('/v/awake/%s/recordings/%sReThreshold/gratingsAndEdges/%s', animal, array, eye);
                outputDir = sprintf('/users/bushnell/Desktop/my_zemina/vnlstorage3/bushnell_arrays/%s/reThreshold/%s/%s/parsed/Gratings/%s/',array,stimType,animal,eye);
            end
%         end
        
        fprintf('\n*** analyzing %s file %d/%d ****\n',filename,fi,length(files));
        if contains(filename,'__')
            continue
        else
            MworksNevParserGroma(filename,10,100,outputDir);
        end
        fprintf('File done with parser at %d\n', toc/3600);
        
    catch ME
        failNdx = failNdx+1;
        fprintf('\n\n****** %s failed %s ******\n\n',filename,ME.message);
        failedFiles{failNdx,1} = filename;
        failedFiles{failNdx,2} = ME.message;     
    end
end
%         end
%     end
% end
%end
fprintf('\n\n ***** %d FILES FAILED AT SOME POINT *****\n\n',failNdx)