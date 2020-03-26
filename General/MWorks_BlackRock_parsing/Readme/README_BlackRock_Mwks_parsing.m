%{ 
README_BlackRock_Mwks_parsing

This will follow the proccess of doing parsing of Blackrock and Mworks data
in Matlab.  Manu and Mariana have done most of the legwork already in
re-creating Darren's Python parser as well as a new version that will allow
for more flexibility and return more information. 

GOALS FOR THIS PROGRAM:
XX take in variables to allow us to change the bin size and number of bins
without having to alter a ton of things in the code

XX Automatically determine what array is used and choose paths accordingly

- Be robust enough to run for any program, no longer require different
parsers depending on the stimulus type

- Integrate Darren's fix for when the Blackrock clock resets

%%%%%% June 28, 2018 %%%%%%

Working on bin_spike_bushnell10_MatLab_bnb - changing variable names to
logical names, and setting some up as pass-in variables to make running the
script much more simple. 

1) using varargin to pass in various numbers of arguments to change the
number and size of bins, and output file names and locations.

possible argument               Default value

Blackrock file name              no default, must be passed
bin size                         10ms
number of bins                   100 (1 sec of data)
output filename                  same as input
output location                  bushnell/binned_dir on Zemina 

The program is now set up to take in a variable number of inputs, and run
the parser. It can also automatically determine if the data is recorded
from V1 or V4 and point to the correct directories - no more going in and
changing it for each data set. This should also help make it so the data
can be batch processed rather than one at a time. 

%%%%%% June 29, 2018 %%%%%%
First task of the day is to debug Manu and Mariana's code/ 



%}