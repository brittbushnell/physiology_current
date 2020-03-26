#include "mex.h"
#include <math.h>

void mexFunction(int nlhs, mxArray *plhs[],int nrhs, const mxArray *prhs[])
{
    int ii,jj,kk;
    double *outputptr,*inputptr;
    mwSize nrows,ncols,nother,ndims;
    const mwSize *dims;
    mwSize dims_new[3] = {0,0,0};
    
    ndims    = mxGetNumberOfDimensions(prhs[0]);
    if (nrhs > 1)
        mexErrMsgTxt("Too many inputs.");
    if (nrhs < 1)
        mexErrMsgTxt("Too few inputs.");
    if ((ndims > 3)|(ndims < 2))
        mexErrMsgTxt("Too many dimensions, only 2 or 3 are allowed.");
    
    
    inputptr    = mxGetPr(prhs[0]);
    dims        = mxGetDimensions(prhs[0]);    
    dims_new[1] = dims[0];
    dims_new[0] = dims[1];
    dims_new[2] = dims[2];
    nrows       = dims[1];
    ncols       = dims[0];
    nother      = dims[2];
    
    /*
    plhs[0] = mxCreateDoubleMatrix((mwSize)nrows,(mwSize)ncols, mxREAL);
     */
    plhs[0] = mxCreateNumericArray(ndims, dims_new, mxDOUBLE_CLASS, 0);
    outputptr = mxGetPr(plhs[0]);        
    
    for (kk=0;kk<nother;kk++){
        for (ii=0;ii<nrows;ii++){                    
            for (jj=0;jj<ncols;jj++){
                outputptr[kk*nrows*ncols + jj*nrows+(nrows-1-ii)] = inputptr[kk*nrows*ncols + ii*ncols+(ncols-1-jj)];
            }
        }
    }
    
}