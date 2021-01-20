function [quadOris,quadRanks, quadOSI] = getGlassPrefsByQuad(prefParams,quad,chRanks, prefOSI)


%% get preferred orientations for all channel in each quadrant of the stimulus
q1 = deg2rad(prefParams(quad == 1));  
q2 = deg2rad(prefParams(quad == 2));
q3 = deg2rad(prefParams(quad == 3));
q4 = deg2rad(prefParams(quad == 4));

% remove nans
q1(isnan(q1)) = [];
q2(isnan(q2)) = [];
q3(isnan(q3)) = [];
q4(isnan(q4)) = [];
quadOris = {};
quadOris.q1 = q1;
quadOris.q2 = q2;
quadOris.q3 = q3;
quadOris.q4 = q4; % preferred orientations for channels within each quadrant
%% get OSI for channels in the quadrants
q1 = (prefOSI(quad == 1));  
q2 = (prefOSI(quad == 2));
q3 = (prefOSI(quad == 3));
q4 = (prefOSI(quad == 4));

% remove nans
q1(isnan(q1)) = [];
q2(isnan(q2)) = [];
q3(isnan(q3)) = [];
q4(isnan(q4)) = [];
quadOSI = {};
quadOSI.q1 = q1;
quadOSI.q2 = q2;
quadOSI.q3 = q3;
quadOSI.q4 = q4; % preferred orientations for channels within each quadrant
%% get preferred pattern type for each channel in each quadrant
q1Ranks = chRanks(quad == 1);
q2Ranks = chRanks(quad == 2);
q3Ranks = chRanks(quad == 3);
q4Ranks = chRanks(quad == 4);

% remove nans
q1Ranks(isnan(q1Ranks)) = [];
q2Ranks(isnan(q2Ranks)) = [];
q3Ranks(isnan(q3Ranks)) = [];
q4Ranks(isnan(q4Ranks)) = [];

% fill empty matrices
if isempty(q1Ranks)
    q1Ranks = zeros(1);
end

if isempty(q2Ranks)
    q2Ranks = zeros(1);
end

if isempty(q3Ranks)
    q3Ranks = zeros(1);
end

if isempty(q4Ranks)
    q4Ranks = zeros(1);
end
 
quadRanks.q1 = q1Ranks; % preferred orientations for channels within each quadrant
quadRanks.q2 = q2Ranks;
quadRanks.q3 = q3Ranks;
quadRanks.q4 = q4Ranks;
