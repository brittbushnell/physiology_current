%{
README_RadialFrequencyPhysiology

Notes about the status of the physiology analysis of RF data overall.


%%%%%% April 5, 2019 %%%%%%
Data collection is complete from WU, XT, and WV, so recommencing with data
analysis - particularly cleaning up the code and setting things up for
comparisons across animals.  As part of this, making new versions of all of
the 




%%%%%% July 12, 2018 %%%%%%
After VSS, I broke the analyses down by step 1, step 2, step 3 etc. Step 1,
looks at the PSTHs and manually decide what is a visually responsive
channel and what is not. Step 2 creates the stimulus response matrix. 
Step 3 analyzes the responses for the different stimulus types.

Made histograms of the responses of three channels before and after they
went through the cleaner. 

Changes to do now:
1) rearrange step 1 and step 2 so make stimulus response matrix and remove
artifacts first, then determine what channels are good.

Changes to do later:
2) rename and clean step 3, move plotting to a different script to keep the
actual analysis stuff clean.

3) automate how good channels are defined.

%%%%%% July 13, 2018 %%%%%%

Ran the last step of the analysis on the auotcleaned data using means
everywhere instead of the medians. Unfortunately, there are two problems.
1) There is still a problem with some of the circles where their responses
are illogicaly high. 
2) Something I did while cleaning up the analysis has changed things so I
cannot immediately re-create the figures from VSS.  Most likely it's just
when I'm using mean instead of median now.

TO DO:
1) Use git history to find the old version of RFxAmp and recreate the
figures from VSS.  
    a) test that version on the new data
    b) change to mean instead of median and run again.

2) run the cleaner on data.bins instead of inside parseRF when making the
stimulus response matrix. 
    a) create a clean version of data structure that removes the
    invalidated trials from all relevant substructures
        - bins
        - rf
        - sf
        - radius
        - pos_x
        - pos_y
        - t_stim
        - orientation
        - amplitude
        - name
        

3) re-analyze the data with this new version and see if that solves the
circle problem.


%%%%%% July 15, 2018 %%%%%%
1) Recreated the original working RFxAmp code and recreated the figures
from the VSS poster.
    - Good news is, the data from the cleaned files plots well. The only
    difference I'm seeing between the mean and median figures are the
    response to the circle that's messed up in the mean version. 

%%%%%% July 20, 2018 %%%%%%

Still having a problem with the circles. Confusingly, when we calculate
mean and median responses in the Matlab GUI, we are getting different
numbers than what we get from the RF3 script.  

This weekend:
- go through the script and through the data and see what's causing the
difference. 

 







%}