% nevEdit.c, simple command line nev sort code editor
% Usage:
% nevEdit(filename,operationType,args...)
% e.g.
% 1) move all sort codes 4 to sort code 7
%    nevEdit('foo.nev','m',4, 7)
% 2) move all waveforms with extent exceeding +-300 mV to sort code 9
%    nevEdit('foo.nev', 't', 300, 9)
% 3) move all waveforms that don't exceed +/- 25 mV to sort code 0
%    nevEdit('foo.nev', 'h', 20, 0)
% 4) for all timestamps which have spikes on more than 3 channels (4 or more),
%    move all to sort code 9 (noise removal)
%    nevEdit('foo.nev','n', 3, 9)
