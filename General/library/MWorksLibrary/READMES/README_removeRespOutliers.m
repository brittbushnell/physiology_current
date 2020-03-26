%{
README_removeRespOutliers

%%%%%% July 9, 2018 %%%%%%
 
This function will remove any outliers in the data, and will run
recursively until there are no more outliers in the data.

matlab function isoutlier(data) will return the indices of data that 
lie more than three standard deviations away from the mean. This will allow
me to only remove extreme trials, rather than the top x% as is the case
when using prctile. 

I wrote this code to run recursively - as long as there are outliers, the
program will keep calling itself to remove outliers that it finds.

This should work with any vector of numbers, it only assumes that the input 
is a column vector.

Tested the function by plotting histograms of the mean responses at each
iteration  of the function for a few different channels, both in repsonse
to blanks and RF stimuli.

%%%%%% July 11, 2018 %%%%%%
Tested the full analysis process on the AE, and it's removing too much to
the point where the AE is nearly identical to the FE.

TO DO:
Do the histogram testing for the RE.

Removed the recursive action, problem solved.

%%%%%% July 15, 2018 %%%%%%

Test


%}