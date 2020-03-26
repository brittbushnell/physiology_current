#include "mex.h"
/*
 * erng.c
 *
 * Computational function that takes a seed and generates new numbers the way Expo does.
 *
 * Note: This mex function is not to be called directly, but through expo_random.m 
 *
 * Jan 22, 2010 - Romesh Kumbhani (romesh.kumbhani@nyu.edu)
*/
 
/* $Revision: 1.8.6.3 $ */

void erng(double result[], double lastseed[], double seed[], double numvals[])
{
    int i;
    unsigned int temp;

    temp = (unsigned int) seed[0];
    
    for (i=0;i<numvals[0];i++)
    {
        temp = temp * 1103515245 + 12345;
        result[i] = (double)(temp>>16);
    }
    lastseed[0] = (double) temp;
}

void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[] )
{
  double *seed,*numvals,*result,*lastseed;
  mwSize mrows,ncols;
  
  /* Check for proper number of arguments. */
  if(nrhs!=2) {
    mexErrMsgTxt("Two inputs are required.");
  } else if(nlhs>2) {
    mexErrMsgTxt("Too many output arguments.");
  }
  
  /* Assign pointers to each input. */
  seed      = mxGetPr(prhs[0]);
  numvals   = mxGetPr(prhs[1]);

  /* Create matrix for the return argument. */
  plhs[0]   = mxCreateDoubleMatrix(numvals[0], 1, mxREAL);
  plhs[1]   = mxCreateDoubleMatrix(1, 1, mxREAL);
  
  /* Assign pointers to each output. */
  result    = mxGetPr(plhs[0]);
  lastseed  = mxGetPr(plhs[1]);
  
  /* Call the timestwo subroutine. */
  erng(result,lastseed,seed,numvals);
}
