function [eyeLoc] = getEyeTrace(filename, codecs, fix_times, printFlag)
%
% Function to get the information about the eye traces. If you want it to
% print out the eye locations, set printFlag to 1, otherwise it will  not
% print them out. 
%
% OUTPUT
% EYELOC matrix of eye locations. Row 1 is the horizontal movement, Row 2
% is the vertical information. 


for t = 1:length(codecs)
    if strcmp('eye_h',codecs(11,:,t))
        eye_h_code = codecs(1,:,t);
    elseif strcmp('eye_v',codecs(11,:,t))
        eye_v_code = codecs(1,:,t);
    end
end
eye_h_code = cell2mat(eye_h_code);
eye_v_code = cell2mat(eye_v_code);

eye_h = getEvents(filename, eye_h_code);
eye_v = getEvents(filename, eye_v_code);

eyeLoc(1,:) = eye_h;
eyeLoc(2,:) = eye_v;

if printFlag == 1
    figure
    plot([eye_v.time_us]/1000000, [eye_v.data], 'g-');
    hold on
    plot(fix_times/1000000, zeros(size(fix_times)), 'r*');
    xlabel('seconds')
    ylabel('vertical eve movement (degrees)')
    
    figure
    plot([eye_h.data], [eye_h.time_us]/1000000, 'b-');
    hold on
    plot(zeros(size(fix_times)), fix_times/1000000, 'r*');
    ylabel('seconds')
    xlabel('horizontal eve movement (degrees)')
end