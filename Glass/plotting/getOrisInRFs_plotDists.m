function [quadOris, quadRanks, quadOSI] = getOrisInRFs_plotDists(quadrants, stimRanks, prefOri, prefOSI, titleText)
% 
% INPUTS: 
% quadrants  = What quadrant do the receptive fields live in?
% stimRanks  = What is the preferred Glass pattern for each channel (con, rad, noise)
% prefOri    = What is the preferred orientation for each channel?
% titleText  = This will become the title for the polar plot 

[quadOris,quadRanks, quadOSI] = getGlassPrefsByQuad(prefOri,quadrants,stimRanks,prefOSI);
GlassPolarPlotsByStimQuadrant(quadOris,quadRanks,titleText);
 
