function [ignoreFiles] = badFilesLookup()
% lookup table of recording files that have fatal flaws and should be
% ignored.  This document will be continually updated.

ignoreFiles = {
    %% glass patterns
    'WU_LE_GlassTR_nsp2_20170822_002_thresh35.mat'; % for some reason the orienations are 0 and 1 - look into it in the parser.


};