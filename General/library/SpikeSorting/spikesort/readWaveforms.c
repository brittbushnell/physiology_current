#include <math.h>
#include "mex.h"
#include <stdio.h>

#define PI 3.14159265

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{ 
  double * packetLocations;
  int spikeCount;
  int samples;
  short int * waveforms;
  char * units;
  unsigned int * times;
  int i;
  char * filename;
  FILE * fid;
  char * junk;
  int buflen;

  spikeCount = mxGetDimensions(prhs[0])[0];
  samples = (int) * mxGetPr(prhs[1]);
  packetLocations = mxGetPr(prhs[0]);

  plhs[0] = mxCreateNumericMatrix(samples, spikeCount, mxINT16_CLASS, mxREAL);
  plhs[1] = mxCreateNumericMatrix(spikeCount, 1, mxUINT32_CLASS,mxREAL);
  plhs[2] = mxCreateNumericMatrix(spikeCount, 1, mxUINT8_CLASS, mxREAL);
  waveforms = (short int *) mxGetPr(plhs[0]);
  times = (unsigned int *)mxGetPr(plhs[1]);
  units = (char *) mxGetPr(plhs[2]);

  buflen = mxGetM(prhs[2]) * mxGetN(prhs[2])+1;
  filename = mxCalloc(buflen, sizeof(char));
  mxGetString(prhs[2], filename, buflen);
  fid = fopen(filename,"rb");

  junk = mxCalloc(20,sizeof(char));

  for (i = 0; i < spikeCount; i++)
  {
    fseek(fid,(long)packetLocations[i],SEEK_SET);
    fread(times+i,4,1,fid);
    fread(junk,1,2,fid);
    fread(units+i,1,1,fid);
    fread(junk,1,1,fid);
    fread(waveforms+(i*samples),2,samples,fid);
  }

  fclose(fid);
}
