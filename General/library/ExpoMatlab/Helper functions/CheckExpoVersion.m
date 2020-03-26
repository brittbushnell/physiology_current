function CheckExpoVersion(expoDataSet, minMatlabImportVersion, minExpoVersion)
%function CheckExpoVersion(expoDataSet [, matlabImportVersion , minExpoVersion]);
%
% An Expo helper function used in all of the main Expo Matlab utility
% functions to check version compatibilty.  The dataset object contains two
% version numbers - the Expo version that generated the XML and the version
% of the Matlab code - MatlabImportVersion - that converted the XML to a Matlab data file.
% The version numbers are compared with the locally stored ExpoVersion # and the
% MatlabImportVersion # provided as a parameter.
%
% Used in ReadExpoXML, GetEvents, GetPasses, GetEvents, GetSpikeTimes,
% GetWaveformes, GetAnalog, GetDots
%
%   Author:      Julian Brown
%	Version:     1.1
%   Last updated:  2005-03-28
%   E-mail:      julianb@stanford.edu
%
%   Author:      Romesh Kumbhani
%	Version:     1.5.14
%   Last updated:  2013-06-10
%   E-mail:      romesh.kumbhani@nyu.edu
%   Notes:       Added support for subversions
%
% See also ReadExpoXML, GetSlots, GetPasses, GetEvents, GetSpikeTimes, GetWaveformes, GetAnalog, GetDots

% if expoDataSet doesn't exist, error out!
if ~exist('expoDataSet','var')
    error('ExpoMatlab:CheckExpoVersion','An Expo data structure was not provided.');
end

% if minMatlabImportVersion doesn't exist, make it 1.5.14
if ~exist('minMatlabImportVersion','var')
    minMatlabImportVersion = '1.1';
end

% if minExpoVersion doesn't exist, make it 1.5.14 too.
if ~exist('minExpoVersion','var')
    minExpoVersion = '1.1';
end

% check to if the expoDataSet has the appropriate version numbers
if ~isfield(expoDataSet, 'ExpoVersion')
    error('ExpoMatlab:CheckExpoVersion','The expoDataSet object you provided has no ExpoVersion field and is therefore invalid.')
end

if ~isfield(expoDataSet, 'MatlabImportVersion')
    error('ExpoMatlab:CheckExpoVersion','The expoDataSet object you provided has no MatlabImportVersion field and is therefore invalid.')
end

% compare the ExpoVersion stored in the dataset with the minimum version requested.
% 
% if the dataset's was made from an expo XML prior to the one requested, 
% generate an error that the function won't work properly.

if ExpandVersion(expoDataSet.ExpoVersion) < ExpandVersion(minExpoVersion)
    error('ExpoMatlab:CheckExpoVersion','Incorrect version of expoDataSet object. It was produced using Expo v%s but this routine requires v%s and higher',expoDataSet.ExpoVersion, minExpoVersion)
end

% compare the MatlabImportVersion stored in the dataset with the minimum version requested.
% 
% if the dataset's was made using a ReadExpoXML prior to the one requested, 
% generate an error that the function won't work properly.

if ExpandVersion(expoDataSet.MatlabImportVersion) < ExpandVersion(minMatlabImportVersion)
    error('ExpoMatlab:CheckExpoVersion','Incorrect MatlabImportVersion of expoDataSet object. This expoDataSet object was made using ReadExpoXML (v%s). You must regenerate using ReadExpoXML v%s or higher.',expoDataSet.MatlabImportVersion, minMatlabImportVersion)
end
