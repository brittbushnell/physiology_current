function [stim_info,fix_times] = getStimInfoMWK(filename,dispCode)

% information contained in a display event is more detailed, and contains
% the information about what stimulus is updated and what the values are.
% This is where you'll find the information about what stimulus is shown at
% what time, but the information is nested, so it takes some Matlab-fu to
% extract the meaningful information

dispEvents = getEvents(filename,dispCode);

stim_info = [];
stmndx    = 1;
fix_times = [];
fixndx    = 1;


if strfind (filename,'grat')
    for i = 1:length(dispEvents)
        if length(dispEvents(i).data) > 1
            for s = 1:length(dispEvents(i).data)
                % find when fixation dot is turned on
                if strcmp('fixation_dot',dispEvents(i).data{s}.name)
                    fix_times(fixndx,1) = dispEvents(i).time_us;
                    fixndx = fixndx+1;
                end
                % Get all information about the stimulus, and create a matrix
                % with columns: time, sf, ori, phase, xposition, yposition,size
                if strcmp('grating',dispEvents(i).data{s}.name)
                    stim_info(stmndx,1) = dispEvents(i).time_us;
                    stim_info(stmndx,2) = dispEvents(i).data{s}.spatial_frequency;
                    stim_info(stmndx,3) = dispEvents(i).data{s}.rotation;
                    stim_info(stmndx,4) = dispEvents(i).data{s}.starting_phase;
                    stim_info(stmndx,5) = dispEvents(i).data{s}.xoffset;
                    stim_info(stmndx,6) = dispEvents(i).data{s}.yoffset;
                    stim_info(stmndx,7) = dispEvents(i).data{s}.width;
                    stmndx = stmndx+1;
                end
            end
        end
    end
    
elseif strfind(filename,'RadFreq')
    for i = 1:length(dispEvents)
        %i
        if length(dispEvents(i).data) > 1
            for s = 1:length(dispEvents(i).data)
                %s
                % find when fixation dot is turned on
                if strcmp('fixation_dot',dispEvents(i).data{s}.name)
                    fix_times(fixndx,1) = dispEvents(i).time_us;
                    fixndx = fixndx+1;
                end
                % Get all information about the stimulus, and create a matrix
                % with columns: time, sf, ori, phase, xposition, yposition,size
                if strfind(dispEvents(i).data{s}.name,'RFStimuli')
                    stim_info(stmndx,1) = dispEvents(i).time_us;
                    stim_info(stmndx,2) = dispEvents(i).data{s}.pos_x;
                    stim_info(stmndx,3) = dispEvents(i).data{s}.pos_y;
                    stim_info(stmndx,4) = dispEvents(i).data{s}.size_x; %sizes are equal, so only need to pull out one
                    % extract stimulus parameters from the file name
                    [rf,mod,ori,sf] = parseRFName(dispEvents(i).data{s}.name);
                    % everything set to 0 if stimulus was a blank
                    stim_info(stmndx,5) = rf;
                    stim_info(stmndx,6) = mod;
                    stim_info(stmndx,7) = ori;
                    stim_info(stmndx,8) = sf;
                    stmndx = stmndx+1;
                end
            end
        end
    end    
elseif strfind(filename,'texture')
    for i = 1:length(dispEvents)
        if length(dispEvents(i).data) > 1
            for s = 1:length(dispEvents(i).data)
                % find when fixation dot is turned on
                if strcmp('fixation_dot',dispEvents(i).data{s}.name)
                    fix_times(fixndx,1) = dispEvents(i).time_us;
                    fixndx = fixndx+1;
                end
                % Get all information about the stimulus, and create a matrix
                % with columns: time, sf, ori, phase, xposition, yposition,size
                if strfind(dispEvents(i).data{s}.name,'Texture')
                    stim_info(stmndx,1) = dispEvents(i).time_us;
                    stim_info(stmndx,2) = dispEvents(i).data{s}.name;
                    stim_info(stmndx,3) = dispEvents(i).data{s}.pos_x;
                    stim_info(stmndx,4) = dispEvents(i).data{s}.pos_y;
                    stim_info(stmndx,5) = dispEvents(i).data{s}.size_x; %sizes are equal, so only need to pull out one
                    stmndx = stmndx+1;
                end
            end
        end
    end    
end

    
