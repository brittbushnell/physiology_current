%{
README_artifactStripNSx

%%%%%% June 13, 2018 %%%%%%
Finished manually cleaning artifacts, and spike sorting the data on the 
first 12 channels of 07/07_002 recording session. 

%%%%%% June 14, 2018 %%%%%%

Going back to the uncleaned 07/07_002 data in Boss into BOSS to play with 
filters and thresholds.  This way I can see what the different changes to 
do the data across channels and I can find something that should work decently 
for all channels.  Specifically I want to find threshold values that will 
cut off the majority of the artifacts without also catching any large, isolated units.

OBSERVATIONS:
1) the standard high-pass 4th order Butterworth filter at 250Hz should be
good.
  Note to self: learn about Butterworth filters - why these ones, and what
  is 4th order?

2) the artifacts that I saw on this day were generally timelocked across
the array. When looking at the frequencty timecourses across channels, the
artifacts were identical across channels. With this in mind, one slightly
more sophisitcated way to get rid of artifacts is to look for large signals
that happen at the same time on multiple channels and invalidate those spikes.
 
This is consistent with my observations in the V1 array during recording,
so it might be really helpful

%%%%%% June 15, 2018 %%%%%%
Not feeling well, and working from home. 

I tried to parse the cleaned and sorted 07/07 data (merging the Mworks 
stimulus file with the Blackrock data file). When I ran the parser code,  I 
got an error that one of the header values was incorrect. I did some
searching online and found that it's the "additional flags" field that says
if the waveforms are 16-bit or not. It's unclear why this field changed
after this data cleaning, when it hasn't happened in the past. Contacted
Blackrock customer support to verify that the data is fine and see if they
know why that happened. 

Greg from Blackrock emailed back pretty quickly and said that the values 
are not usually changed, but requested the .nev file so he can see what's 
happened.

%%%%%% June 17, 2018 %%%%%%

Cloned the Blackrock analysis git repository and am going through them to
learn how to manipulate the data correctly. Particularly looking at
rethresholdNSx and findSpikes since these do what I want to do.  My plan is
not to copy their code, but learn how the data is structured and write my
own code.

Doing some reading about different ways of doing artifact rejection.

Using the raw data (ns6 file) and the associated nev file. 

*** There's something missing in our data structures. In the Blackrock code,
there is a structure object called: NEV.ElectrodesInfo.DigitalFactor that
does not exist in any of my files.  I've checked several different files
from different programs and both arrays, and none of them have this
structure object.  I've emailed Blackrock about this as well ***

NOTE: In the .ns6 or .ns2 file, you can open specific channels at a time,
but not with the .nev.  In that case it's the whole file or nothing. 

%%%%%% June 18, 2018 %%%%%%
Greg from Blackrock emailed back. 

RE: changed header in 07/07_002 data file
He said the waveforms in my cleaned and sorted .nev file all look good, but 
the header value was changed and he's not sure why. He's forwarded that 
ticket to the software development team to see if they can find something 
that we've both missed. 

RE: the missing digitalFactor value in the Blackrock data structure
It should always be 250, but looks like it's associated with the function
not being able to find the appropriate .nev file. After some back and forth
and troubleshooting from both of us, it appears to be a bug with this
program in general, and he's working on debugging it. I

While frustrating, now that I know these are bugs on their end, I can
continue with writing my scripts without running it through theirs.

###
When opening the .nev and .nsx files, requesting waveforms in uV. This
triggers a warning : This conversion may lead to loss of information.

The default is raw data, but I don't know how to interpret the numbers that
yields. 


%%%%%% June 19, 2018 %%%%%%

Animals ran a bit late and spent a large chunk of time helping Gerick debug
an eyetracking problem, and taught Krysten (my SURP student) her analysis.
Unfortunately was not able to spend a lot of time on writing code.

Talked with Mariana a bit about how she's implemented these, and she
mentioned doing PCA on the waveforms, and eliminating noise by eliminating
clusters that have bizarre waveforms/firing patterns.  

After some thought decide unlikely to work because it's overly complicated,
and from looking at the PCA space in BOSS it's unlikely to be as effective
as we'd like. 

Tomorrow, talk to Manu about it a bit since he's spent a ton of time
thinking about spike sorters and such before. 

%%%%%% June 20, 2018 %%%%%%

Talked with Manu and came up with a concrete plan to create the boundaries. The
simple plan is to get the waveform amplitudes of each spike (max-min) and
plot that distribition. Look at that distribution, and define a criterion
using pctile (distribution) for cutting of the tails of the data.

Butterworth filters: 
- Filters that are flat in the passband (relative to other filters), and 
roll off towards zero at the stopband.

That means there's minimal signal loss in the parts of the frequency
spectrum of interest. 

- filter order refers to the frequency of the roll off. As you increase the
order, the the step response of the filter increases as well as the
amount of oscillation in the flat part of the filter. Therefore, you have
to play a balancing game between cutting off the unwanted frequencies and
mininmizing signal loss in the passband. 

1 order: -6dB/octave
2 order: -12dB/octave
3 order: -18dB/octave
4 order: -24dB/octave

I'll stick with using highpass 4th order butterworth filter at 250Hz. 
Broadband won't really buy much since artifacts are typically highpass, and
is certainly slower to run


%%%%%% June 21, 2018 %%%%%%

Heard back from Greg, and he has confirmed that there's something
messed up in rethresholdNSx - he can't get it to run properly either, so
they're working on debugging that from their end as well.

In the mean time, I'm continuing on getting my program to work.  Should
have something fully testable by tomorrow.

###
nsxFile.Data is a 1x2 cell array. Want to work with nsxFile.Data{2}.  It
has more data sampling points, and most importantly they lineup with the
number of samples in the nev file. It's unclear what's the difference in
them.

nsxFile.Data{2} is a 96 x 4xxxxxxxx matrix. Each 

Spent some time in the evening going through the data structure with
Mariana, and it's not entirely clear how to work with it. Blackrock doesn't
have any documentation about what's in their data structures other than the
headers. Mariana recommended using the .nev file which has the waveforms
parsed out. My Matlab was frozen, so she showed me how she was looking at
waveforms using the .nev file.  

From Mariana:

in order to know what channel a waveform is from in aux.Data.Spikes.Waveform 
you have to cross reference it with the electrode number in
aux.Data.Spikes.Electrode. This is essentially the same process we use to
pull out stimulus information from the parsed data.

Example code:
cd(?/Users/mariana/Documents/Lab/Kiorpes_Lab/Data_Brittany/Blackrock_files/?)

aux = openNEV(?WU_LE_Gratings_nsp1_20170626_001.nev?, ?uV?)

auxElectrode = find(aux.Data.Spikes.Electrode == 5);

waveformFor5 = aux.Data.Spikes.Waveform(:, auxElectrode);

figure; plot(waveformFor5)


%%%%%% June 22, 2018 %%%%%%
I did something to piss off the computer gods last night. I had to restart my
desktop when I left because after having to force quit Matlab, it would not 
re-open.  At home, my laptop crashed while I was implementing the code from
Mariana. 

NOTE:  ELECTRODE 5 IS NOT THE SAME AS CHANNEL 5!!!!!!! The code from
Mariana is using electrodes, not channels!

Need to make a script that will automatically create a channel electrode
array. This one was made manually.

Ch	Elect
1	78
2	88
3	68
4	58
5	56
6	48
7	57
8	38
9	47
10	28
11	37
12	27
13	36
14	18
15	45
16	17
17	46
18	8
19	35
20	16
21	24
22	7
23	26
24	6
25	25
26	5
27	15
28	4
29	14
30	3
31	13
32	2
33	77
34	67
35	76
36	66
37	75
38	65
39	74
40	64
41	73
42	54
43	63
44	53
45	72
46	43
47	62
48	55
49	61
50	44
51	52
52	33
53	51
54	34
55	41
56	42
57	31
58	32
59	21
60	22
61	11
62	23
63	10
64	12
65	96
66	87
67	95
68	86
69	94
70	85
71	93
72	84
73	92
74	83
75	91
76	82
77	90
78	81
79	89
80	80
81	79
82	71
83	69
84	70
85	59
86	60
87	50
88	49
89	40
90	39
91	30
92	29
93	19
94	20
95	1
96	9


%%%%%% June 23, 2018 %%%%%%
Something went totally haywire with Matlab at the end of yesterday. When 
plotting the waveforms, Matlab was using over 100% CPU. After force
quitting, the computer couldn't open again without a complete shutdown.
Marshall from the shop ended up just installing the newest version, testing
that today. 

Also, rather than test this script on the RF data, will use grating data
instead which is a much smaller file and will be faster to analyze.  Once I
have it working with gratings, I'll extend it to RF. 


Got a response from Nick @ Blackrock RE how the data structures are defined
and parsed in both the NEV and NSx files. 

NEV.Data.Spikes: the column data in all of the substructures are from one
waveform. If the data is not converted to milivolts (which is what they
recommend), each data point in the waveform (on the ordinate) is a 16 bit
digital value.  

From Nick: 
"data values are recorded as digital values. That is, there is an analog to
digital converter on the headstage that will map an analog value to a binary 
value with 16 bits, and those 16 bit values are recorded into the data file. 
Due to our analog input range over which the analog input is mapped to 
digital, each value corresponds to 0.25 microvolts. "

%%%%%% June 25 2018 %%%%%%

Trying to figure out how to remove bad waveforms on a channel by channel
basis without totally destroying the structure of the data structures. 

Considerations:
1) Don't want to change the way the data is laid out, otherwise we'll also
have to change the parser and will likely have troubles with other analysis
stuff.

2) All substructures within nevFile.Data.Spikes must retain the same column
numbers and orders, otherwise you lose the identity of what channel
everything occurred on.

Simpelest way:
- instead of doing everything channel by channel, look at the whole array,
and set a global cut off. 
    - Remove columns from all of the substructures 
    - Go back to each channel and see what their waveforms look like after.

- Unfortunately, that's not working on all channels. For example, ch 93
(electrode 19) has a really nice PSTH, but the signal looks like garbage,
but isn't picked up by this simple method. 

Electrode 79 inexplicably has a bimodal amplitude distribution...

%%%%%% June 26, 2018 %%%%%%

The simple way of doing the rejections based on amplitude is insufficient. 
There are a lot of artifacts that I can see when plotting the waveforms
that are not being captured this way.  

Today's focus:
- work on data manipulation. How to go channel by channel while maintaining
the same data structures overall


After talking to Najib, he suggests trying a totally different technique
since what we are currently doing is going to require a lot more to work
than we are willing to do to get to what we actually want. 

%%%%%% July 2nd, 2018 %%%%%%
Giving this another go to show examples of what's happening to my
committee. It's acutally looking okay now that I'm printing things
properly. Electrodes 60 and 79 both look good on 07/04. 

06/09 - V4.
That day had some nicely isolated units according to my notes. Electrodes
72, 62, and 91.

 - These three electrodes have beautifully isolated units, but the artifact
 trash stripper is  rejecting some of them..  There's no artifacts on these
 days.  

How do I distinguish?  Is it worth accidentally rejecting nice waveforms
like this to get rid of the artifacts when they occur? Essentially a type I
vs type II error rejection question. 

6/19 V1 
Has tons of artifacts. This is an example of when the artifact
rejection makes a huge difference. 


Trying to add a reverse threshold as well - where if waveforms are larger
than some number then they will be disgarded. 

Takeaway:

There won't be a one size fits all solution to this. I'll have to do each
day and base the thresholds and %ile on each data set. Going through day by
day and checking with a few channels to set these values will still be
faster than doing everything manually, and I can still work on other things
at the same time. Run artifact rejection on Zemina, where it will run
faster and leave my local computer free to do other wor
 - To speed things up, see if the same settings will work on all files
 within a day. If I can batch process by day that'll be a huge time savings. 

%%%%%% July 3, 2018 %%%%%%
Testing with several channels at different %iles. Next, test with different
programs from the same day. There seems to be a slight improvement by going
from 99 to 98%, but nothing much gained by removing more after that.

Testing on 06/09 - according to notes that had multiple channels with
clear units.

%%%%%% July 4, 2018 %%%%%%
Testing with different files on 06/09. 

%%%%%% July 5, 2018 %%%%%%
Met with Tony, and revising approach. Instead of doing amplitude cutoffs as
I have been, the plan is to use a moving window to reject everything within
the timeframe that artifacts occur. 

Doing this after parsing using mean responses in data.bins will likely be
the fastest way to do this, but doing it with the continuous data from the
nsx files will likely be the cleanest way.

%%%%%% July 6, 2018 %%%%%%
Looked through the data on the NS2 files, and it's tricky to know what 300
ms corresponds to in terms of timestamps and signal here.  The timestamps
are samples, (signal was collected at 30000 Hz). Instead, will be using
data after it's already gone through the parser. Starting a new README file
for this. 



%}