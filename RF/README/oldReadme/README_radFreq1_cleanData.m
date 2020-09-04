%{
README_radFreq1_cleanData

%%%%%% July 18, 2018 %%%%%%
Forgot to create this when I first started this program. New flow for RF 
analysis is to clean and parse out the data into responses by stimulus in 
this program, and then move on.
 
I've created a new version of the entire data strucutre that has been
cleaned. Any trial whose responses are more than 3 scaled median absolute 
deviations from the m edian of the distribution of responses of the entire
array are invalidated. To invalidate them, I've changed the value for that
trial to nan in all substructures - that way when doing analysis those
should just be ignored if using nanmean.

For some reason, when I create the stimResps matrix, most of the elements
are NaN, and those that aren't are nearly all identical values, so
something is wrong. 

Troubleshooting:
1) compare data and clean data sub elements to make sure the only
differences is the presence of nans. 

    - This checks out. Tested for the individual stimulus parameters, as
    well as for data.bins and cleanData.bins. The only difference is the
    presence of nan, and the number of nans are consistent across all of
    the substructures. (Lost 51 trials out of 4890).

2) Look at where the stimResponse matrix is being created and see what's
happening there.
    
    - The program is considering all of the nan trials as actual unique
    stimuli, which is throwing things of. Need to remove those trials
    rather than change them to nan.


Removed all nans from cleanData structures, they are all the same
dimensions, however now all the RFstimResps matrices in parseRF are empty.
Debug tomorrow.







%}