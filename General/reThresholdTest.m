clear all
close all
clc
%%
% make sure the shit is in your path
addpath(genpath('/share/code/'));
addpath(genpath('/km/vs/array/bushnell_arrays'));
% 
threshold = 3:0.5:4.5;

%% 
% just change this to match your path and filename
ns6 = '/km/vs/array/bushnell_arrays/nsp2/nsp2_blackrock/WU/WU_LE_GlassTR_nsp2_20170825_002.ns6';
nev = '/km/vs/array/bushnell_arrays/nsp2/nsp2_blackrock/WU/WU_LE_GlassTR_nsp2_20170825_002.nev';

for thresh = 1:length(threshold)
    output = sprintf('/mnt/vnlstorage3/bushnell_arrays/nsp2/reThreshold/WU_LE_GlassTR_nsp2_20170825_002_thresh%.1f',threshold(thresh));
    car_nsx(nev,ns6,output,threshold(thresh));
end