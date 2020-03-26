function [data] = getAmblyInd(data)
%% Run with my AI function
if contains(data.RE.animal,'XT')
    REfile = 'peripho_xt_RE1019.csf';
    LEfile = 'peripho_xt_LE1019.csf';
    data.amblyIndx = AmblyIndx(REfile,LEfile);
elseif contains(data.RE.animal,'WV')
    AEfile = 'perip_wv_RE+5.0D0617.csf';
    FEfile = 'perip_wv_LE+1.750517.csf';
    data.amblyIndx = AmblyIndx(AEfile,FEfile);
elseif contains(data.RE.animal,'WU')
    AEfile = 'wu_RE1118_peripho.csf';
    FEfile = 'wu_LE1118_peripho.csf';
    data.amblyIndx = AmblyIndx(AEfile,FEfile);
else
    error('cannot identify animal')
end
%% run with Tom's function

% SF = {'0.5@1' '1@1' '2@1' '4@1' '6@1' '8@1' '8@2' '12@2'};
% 
% %if contains(data.RE.animal,'WU')
% 
%     LEfiles = {'peripho_wu.0255.psy' 'peripho_wu.0250.psy' 'peripho_wu.0383.psy';...
%                'peripho_wu.0257.psy' 'peripho_wu.0258.psy' 'peripho_wu.0381.psy';...
%                'peripho_wu.0341.psy' 'peripho_wu.0343.psy' 'peripho_wu.0379.psy';...
%                'peripho_wu.0344.psy' 'peripho_wu.0345.psy' 'peripho_wu.0378.psy';...
%                'peripho_wu.0361.psy' 'peripho_wu.0362.psy' 'peripho_wu.0375.psy';...
%                'peripho_wu.0372.psy' 'peripho_wu.0373.psy' 'peripho_wu.0374.psy'};
%            
%     REfiles = {'peripho_wu.0392.psy' 'peripho_wu.0394.psy' 'peripho_wu.0464.psy';...
%                'peripho_wu.0404.psy' 'peripho_wu.0406.psy' 'peripho_wu.0462.psy';...
%                'peripho_wu.0407.psy' 'peripho_wu.0409.psy' 'peripho_wu.0460.psy';...
%                'peripho_wu.0420.psy' 'peripho_wu.0421.psy' 'peripho_wu.0458.psy';...
%                'peripho_wu.0443.psy' 'peripho_wu.0444.psy' 'peripho_wu.0455.psy';...
%                'peripho_wu.0448.psy' 'peripho_wu.0449.psy' 'peripho_wu.0450.psy'};
% %end
% 
% fileNames = {LEfiles; REfiles};
% 
% data.amblyIndxTVG = csf_amblyopes(SF,fileNames)