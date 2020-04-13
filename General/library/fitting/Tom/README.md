# Fitting routines

I've tried to adhere to a standard in fitting functions. Because Matlab has a variety of ways to fit functions I wrote a **wrapper function** called `anyfit.m`. This function does the hard work and its behavior can be manipulated by giving optional arguments.

The fit functions are called `[FUNC]fit.m` where `[FUNC]` is the name of the function. E.g. `gaussfit.m` fits a normal distribution. These functions pass their work on to `anyfit.m`.

## input

The fit function receives two inputs. `x`: the independent variable (e.g. stimulus). `y`: dependent variable (e.g. response). Most functions can fit **multiple curves in one call**. The different curves must be provided in the **second** dimension. I.e. in 2D functions (e.g. [gausfit.m](./gausfit.m)) different curves are in **columns** and different data points are in **rows**. In 3D functions (e.g. [gausfit2.m](./gausfit2.m)) the **3rd dimension** is the second input to the function (e.g. stimulus dimension 2).

1) `x(:,j,k)` : all data points of stimulus dimension `k` of curve `j` 
2) `x(i,:,k)` : first data points of all curves of stimulus dimension `k`
3) `x(i,j,:)` : first set of data points across all stimulus dimensions of curve `j` 


##  output
The fitted parameters is the **first** output of the function. In general the first parameter is _offset_, followed by _gain_.

* `b(1)` offset
* `b(2)` gain
* `b(3)` shape parameter 1 (usually the critical value like max)
* `b(4)` shape parameter 2 (usually the variance value like s.d.)
* ...
* `b(i+2)` shape parameter _i_

## bounds and guesses

**Lower**, **upper** bounds and initial **guesses** can be explicitly set or left standard. 

If lower and upper bound are identical the parameter is considered **fixed**. For example if a normal distribution need to be fitted with a fixed offset at 10, the first upper and lower bound values are set at 10. If the function can have an offset between 0 and 7 and needs to be **restricted**, the first upper bound is set to 7 and the first lower bound is set to 0.

For simplicity the guesses are obtained by the dedicated function `intialguess_[FUNC]`. 
