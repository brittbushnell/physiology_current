clc
clear all
%%
tic

cd ('/Users/bbushnell/Dropbox/MWorks/RFStim_bmp/rad1and2/RF4_2Deg/sf1/');
rad = 2;

outPath = '~/Dropbox/MWorks/RFStim_png/';

a = dir;
for i = 1:length(dir)
    b{i} = a(i).name;
end
b = b';
b(1:2) = [];
foo = strcmp(b{1},'.DS_Store');
foo2 = strfind(b{1},'._');

if foo == 1
    b(1,:) = [];
end

for t = 1:length(b)
    % Get file
    filename = b{t};
    l = imread(filename);
    
    % parse file name
    % Radial1000_TYP1_WPL4_MOD0.756_PHS0_PKF1.bmp
%     pathChunks = split(path, '/');
%     filename = pathChunks(3);
    
    chunks = sscanf(filename, 'Radial1000_TYP1_WPL%d_MOD%f_PHS%f_PKF%d.bmp');

    rf  = chunks(1);
    mod = chunks(2);
    ori = chunks(3);
    sf  = chunks(4);

    % Write output file
    if mod == 0 %if circle
        if rad == 0.75
            newName = sprintf('Circle_RAD%.2f_SF%d',rad,sf);
        else
            newName = sprintf('Circle_RAD%.1f_SF%d',rad,sf);
        end
    else
       if rad == 0.75
           if ori == 0 || ori == 45
               newName = sprintf('RF%d_RAD%.2f_MOD%.2f_ORI%d_SF%d',rf,rad,mod,ori,sf);
           else
               newName = sprintf('RF%d_RAD%.2f_MOD%.2f_ORI%.2f_SF%d',rf,rad,mod,ori,sf);
           end
       else
            if ori == 0 || ori == 45
               newName = sprintf('RF%d_RAD%.1f_MOD%.2f_ORI%d_SF%d',rf,rad,mod,ori,sf);
           else
               newName = sprintf('RF%d_RAD%.1f_MOD%.2f_ORI%.2f_SF%d',rf,rad,mod,ori,sf);
           end
        
       end
    end
    
    outfilename = [outPath,newName,'.png'];
    imwrite(l,outfilename,'png')
end

disp ('Files Made')

toc