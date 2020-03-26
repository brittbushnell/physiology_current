function fixNEV(filenames)
  
  for i = 1:length(filenames)
    filenames{i}
    nevEdit(filenames{i},'m',255,0);
	nevEdit(filenames{i},'n',3,8);
    nevEdit(filenames{i},'t',250,255);
  end