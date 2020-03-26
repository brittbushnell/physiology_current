#include <math.h>
#include "mex.h"
#include <stdio.h>

#define PI 3.14159265

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{ 
  double * packetLocations;
  int spikeCount;
  unsigned char * units;
  int i;
  char * filename;
  FILE * fid;
  int buflen;
  unsigned char unit;

  spikeCount = mxGetDimensions(prhs[0])[0];
  packetLocations = mxGetPr(prhs[0]);

  units = (unsigned char *) mxGetPr(prhs[1]);

  buflen = mxGetM(prhs[2]) * mxGetN(prhs[2])+1;
  filename = mxCalloc(buflen, sizeof(char));
  mxGetString(prhs[2], filename, buflen);
  fid = fopen(filename,"rb+");
  
  for (i = 0; i < spikeCount; i++)
  {
      fseek(fid,(long)packetLocations[i],SEEK_SET);
      fwrite(units+i,1,1,fid);
  }

  fclose(fid);
}
