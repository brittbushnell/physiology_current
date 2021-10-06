%%
%{
    Script Name: get_mworks_info.m
    Script Description: The purpose of this script is to get the basic data from
                        mworks files that will be eventually married to 
krock
                        array data in a sensible structure. There are many potential ways
                        in which this code could evolve. For example it would be
                        nice to get the data into a common NWB format eventually
                        so that it could be utilized by multiple others. This code
                        is based on code written by Darren Seibert to perform the same
                        goals in python. As an executive decision I have chosen to split
                        things up into modules.

    This code is written using Matlab 2016b

    Prerequisites:

                 1. You need to have mworks installed, and add the path of the
                 location of the mworks matlab application support to your
                 matlab path.

    Input:
                mworks_filename: filename (including path) of .mwk file for a given mworks task
                force_process : flag to reprocess code which has already been processed by get_mworks_info.m
                                0 = do not process again if you do not want to
                                1 = process again

    Output:     stimDisplayUpdateEvents: structure that holds every state mworks moves throgh
                numStimShownEvents: structure that lets you know how many stimuli were on a screen at a particular time
                wordOut: structure of words that were sent out from mworks, this is CRITICAL to alignment of spiketimes
                codecs_all: the codecs associated with a given mworks file, if you want to add to things below, you can look at this codecs file
                            and adjust code accordingly

    Author: Ramanujan Raghavan
    Date: 06-13-2017
    Version: 1.0

    Author: Ramanujan Raghavan
    Date: 09-18-2017
    Version: 1.1

%}
%%
function [outputFileFullPath] = get_all_mworks_info_forBrittany(mworks_filename, force_process, varargin)

% filePath = mworks_filename(1);
% fileName = mworks_filename(2);
% ext = mworks_filename(3);
[filePath, fileName, ~] = fileparts(mworks_filename);

finalSaveFilePath = filePath;

if ~isempty(varargin)
    switch varargin{1}
        case 'SaveFilePath'
            finalSaveFilePath = varargin{2};
    end
end

%make sure you put something sensible for the inputs
assert(force_process==0 | force_process==1,'inappropriate entry for force_process')
assert(exist(mworks_filename)==2 | exist(mworks_filename)==7,'could not locate that given mworks file')

%also make sure that mworks code is accessible, if it isn't you're gonna be in trouble
assert(exist('getEvents.m','file')==2,['Could not find a basic script provided by mWorks. '...,
    'Did you forget to add the mworks matlab support folder to your path?'])

%at the end of each run of get_mworks_info.m, a file is written of the
% convention mworks_filename_mworks_all_output.mat that contains the
% variables above check to make sure it exists and if so load that data unless explicitly told not too by the force_process flag above
nameTermination = '_mworks_output.mat';
outputFile = [fileName, nameTermination];
outputFileFullPath = [finalSaveFilePath, outputFile];

if exist(outputFileFullPath,'file') == 2 && force_process == 0 %load the  mat file
    disp('You already processed this file.');
    % load(outputFileFullPath);
else %process the file
    
    %first get codecs associated with your mworks file, this should output a rather large structure
    getCodecs_output = getCodecs(mworks_filename);
    codecs_all = getCodecs_output.codec; % this is a place where mworks files can confuse you, the output of get_Codecs is a structure containing a variable called codec.
    
    
    % Note to self, and likely others:
    % mworks codecs contain a ton of information associated with every conceivable
    % variable and state associated with this file. So you need to search for
    % relevant information and get more specific data. For present purposes the most
    % important information are #stimDisplayUpdate, number_of_stm_shown, wordout_var.
    % These are code names that define what information is spit out by MWorks when the display is
    % updated, when an event is successful, and words sent from mworks to the blackrock system
    %
    % The lines below locates these events. I have made some variable name changes from the
    % bin_spike_bushnell10.py file on which this is based because they were opaque.
    %
    % Three variables are defined below.
    % code_stimDisplayUpdate = "stim_display_update_events" in darren's code
    % code_numStimShown = "success_events" in darren's code
    % code_wordOut = "sent" in darren's code.
    %
    % these codes are integers, they help point the mworks code getEvents to what data to extract
    
    % aux = {codecs_all.tagname};
    aux = [{'wordout_var'}, {'#stimDisplayUpdate'}, {'number_of_stm_shown'},{'stimon_time'}, {'stimoff_time'}];
    listPossibleEvents = [];
    for nn = 1:length(aux)
        code_auxUpdate_index = cellfun(@(x) strcmp(x, aux{nn}), {codecs_all.tagname});
        code_auxUpdate = codecs_all(code_auxUpdate_index).code;
        
        aux1 = strfind(aux{nn}, '#');
        if ~isempty(aux1)
            nameLocal = aux{nn}(aux1+1:end);
        else
            nameLocal = aux{nn};
        end
        
        eval([nameLocal, 'Events = getEvents(mworks_filename, code_auxUpdate);']);
        
        listPossibleEvents = [listPossibleEvents, '''', nameLocal, 'Events', ''', '];
    end
    
    listPossibleEventsAux = listPossibleEvents(1:end-2);
    
    eval(['save(outputFileFullPath, ' listPossibleEventsAux, ');'])
end
