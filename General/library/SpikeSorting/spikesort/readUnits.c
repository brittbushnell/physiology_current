#include "io64.h"
#include <math.h>
#include "mex.h"

#define PI 3.14159265

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{ 
  double * packetLocations;
  int spikeCount;
  unsigned char * units;
  int i;
  char * filename;
  FILE * fid;
  char * junk;
  int buflen;
  unsigned char unit;

  spikeCount = mxGetDimensions(prhs[0])[0];
  packetLocations = mxGetPr(prhs[0]);

  plhs[0] = mxCreateNumericMatrix(256, 1, mxUINT8_CLASS, mxREAL);
  units = (unsigned char *) mxGetPr(plhs[0]);
  for (i = 0; i < 256; i++)
    units[i] = 0;

  buflen = mxGetM(prhs[1]) * mxGetN(prhs[1])+1;
  filename = mxCalloc(buflen, sizeof(char));
  mxGetString(prhs[1], filename, buflen);
  fid = fopen(filename,"rb");

  junk = mxCalloc(20,sizeof(char));

  for (i = 0; i < spikeCount; i++)
  {
    fseek(fid,(long)packetLocations[i],SEEK_SET);
    fread(&unit,1,1,fid);
    units[unit] = 1;
  }

  fclose(fid);
}
