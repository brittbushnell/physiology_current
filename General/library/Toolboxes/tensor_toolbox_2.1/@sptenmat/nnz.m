function n = nnz(a)
%NNZ Return number of nonzeros in a sptenmat.
%
%   nnz(A) returns the number of nonzeros in A.
%
%   See also SPTENMAT.
%
%MATLAB Tensor Toolbox.
%Copyright 2006, Sandia Corporation. 

% This is the MATLAB Tensor Toolbox by Brett Bader and Tamara Kolda. 
% http://csmr.ca.sandia.gov/~tgkolda/TensorToolbox.
% Copyright (2006) Sandia Corporation. Under the terms of Contract
% DE-AC04-94AL85000, there is a non-exclusive license for use of this
% work by or on behalf of the U.S. Government. Export of this data may
% require a license from the United States Government.
% The full license terms can be found in tensor_toolbox/LICENSE.txt
% $Id: nnz.m,v 1.3 2006/08/21 21:04:39 bwbader Exp $

n = length(a.vals);
