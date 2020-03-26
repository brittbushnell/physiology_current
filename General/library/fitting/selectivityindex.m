%SELECTIVITYINDEX returns sensitivity index
%
%   This function returns a dimensionless selectivity index for direction
%   tuning or orientation tuning experiments. This function uses the
%   technique described in [1] (Smith et al. 2002).
%       SI = 0 :    Insensitive to direction / orientation
%       SI = 1 :    Responding to only one orientation / direction
%
%   Note that this function assumes the response is baseline corrected!
%
%
%   Input:
%   directionindex(P,R,nLobes)
%       P :         stimulus orientation in degrees
%       R :         response magnitude baseline subtracted (e.g. FR)
%       nLobes :    number of lobes. 1: dir. selectivity, 2: ori, 4:
%                   quadropoles.
%           Default nLobes = 1
%
%   Output:
%   SI = directionindex(..)
%       SI :    Selectivity index
%
%   Theory:
%   [1] Smith, M.A., Bair, W., Movshon, J.A., 2002. Signals in macaque
%       striate cortical neurons that support the perception of glass
%       patterns. J. Neurosci. 22, 8334?8345.
%   [2] Leventhal AG, Thompson KG, Liu D, Zhou Y, Ault SJ. Concomitant
%       sensitivity to orientation, direction, and color of cells in layers
%       2, 3, and 4 of monkey striate cortex. J Neurosci. 1995 Mar;15(3 Pt
%       1):1808-18.
%   [3] Priebe, N.J., Lisberger, S.G., Movshon, J.A., 2006. Tuning for
%       spatiotemporal frequency and speed in directionally selective
%       neurons of macaque striate cortex. J. Neurosci. 26, 2941?2950.
%
%
%
%   In [1] note that this technique duplicates theta_n. This is to wrap
%   opposite angles and intended to use in orientation selectivity.
%
%       "To characterize orientation tuning curves, we determined the
%       selectivity and preferred angle by calculating a tuning bias
%       vector (Leventhal et al., 1995; O'Keefe and Movshon, 1998),
%       similar to the vector strength calculation introduced by Levick
%       and Thibos (1982). We represented an orientation tuning curve as
%       a set of vectors, (theta_n, R_n), where theta_n is stimulus
%       orientation, R_n is the response magnitude (with baseline
%       subtracted), and n is an index from 1 to the number of points, N,
%       in the tuning curve. The preferred orientation is given by the
%       circular mean angle:
% 
%           \textup{m} = \frac{1}{2}  \textup{arctan}  \left(  \frac
%           {\sum_{n=1}^{N} R_{n}\textup{sin}(2\theta_{n})}
%           {\sum_{n=1}^{N} R_{n}\textup{cos}(2\theta_{n})
%           }  \right)
%       with,
%           m :         Circular mean angle
%           theta_n :   Stimulus orientation
%           R_n :       Response magnitude (b.l. subtracted)
%           n :         Angle number (1-N, N: number of angles)
% 
%       To measure selectivity, we calculated the summed response vector:
% 
%           v = \sum_{n=1}^{N}R_{n}\textup{exp}^{i2\theta_{n}}
%       with,
%           v : summed response vector
% 
%       and normalized its magnitude by the summed magnitude of all the response
%       vectors:
% 
%           \textup{si} = \frac
%           {\left \| v \right \|}
%           {\sum_{n=1}^{N}R_{n}\left \| R_{n} \right \|}
%       with,
%           si :    Orientation Index
%           
% 
%       The selectivity index is 0 for a cell responding equally at all
%       orientations and 1 for a cell that responds only to a single orientation.
%       To estimate the significance of each selectivity estimate, we used the
%       permutation technique described in O'Keefe and Movshon (1998). For each
%       tuning curve, we performed the selectivity index analysis on 2000 random
%       permutations of the data and considered a measured selectivity index to
%       be significant if it exceeded the 90th percentile of the permuted
%       distribution. 
%       To estimate analogous quantities for tuning curves with
%       four lobes (rather than two), which we term ?quadropoles,? we modified
%       the first two equations simply by substituting 4?nfor 2?n and taking
%       one-quarter rather than one-half of the arctangent. This results in a
%       measure of preference and bias appropriate for functions with periodic
%       peaks and troughs every 90°, rather than every 180°."
%
%   Factor of two is explained in [2].
%
%       "Briefly, the responses of each cell to the different directions of
%       the stimulus presented were stored in the computer as a series of
%       vectors. The vectors were added and divided by the sum of the
%       absolute values of the vectors. The angle of the resultant vector
%       gives the preferred direction of the cell. The length of the
%       resultant vector, termed the orientation or direction bias,
%       provides a quantitative measure of the orientation or direction
%       sensitivity of the cell. Because the periodicity of orientation is
%       180 deg, the angles of the direction of the stimulus grating, bar,
%       or spot are multiplied by a factor of two when calculating
%       orientation preferences. However, direction is cyclic over 360 deg,
%       therefore the actual directions of the stimulus gratings, bars, or
%       spots are used to calculate the direction preferences of the cell.
%       Orientation and direction biases range from 0 to 1, with 0 being
%       completely insensitive to orientation or direction and 1 responding
%       to only one orientation or only one direction. Although in theory
%       the range is from 0 to 1, the observed range of orientation biases
%       for cortical cells is from 0 to about 0.75, and the range of
%       direction biases observed is from 0 to about 0.5."
%
%   An alternative technique is used in [3].
%
%       "We estimated the direction selectivity of each neuron from the
%       responses to gratings of 32% contrast at the preferred spatial and
%       temporal frequency of the neuron under study. Direction selectivity
%       was quantified using the direction index (DI):
%       
%       	\textup{di} = \frac{R_p-R_n}{R_p+R_n}
%       with,
%           di :    direction index
%           R_p :   Response preferred direction
%           R_n :   Response opposite direction
%       
%       where R_p and R_n are response amplitudes for grating motion in the
%       preferred and opposite directions, respectively."
%
% V0: TvG Aug 2015, NYU: added help


function SI = selectivityindex(P,R,nLobes)
%
if nargin < 3
    nLobes = 1; % number of lobes. 1: dir. selectivity, 2: ori, 4: quadropoles
end


%%
% let x = 0 to 2*pi
% let y = be there responses at x;
x = deg2rad(P);
y = R;

% summed response vector
%v = sum(y.*exp(sqrt(-1)*1*x));

% Selectivity index
SI = abs( sum(y.*exp(sqrt(-1)*nLobes*x),2) ) ./ sum(y,2); % Mat Smith multiplies with .*norm(y));


%%
return
equation_editor('\frac{1}{2}  \textup{arctan}  \left(  \frac {\sum_{n=1}^{N} R_{n}\textup{sin}(2\theta_{n})} {\sum_{n=1}^{N} R_{n}\textup{cos}(2\theta_{n}) }  \right)')
equation_editor('v=\sum_{n=1}^{N}R_{n}\textup{exp}^{i2\theta_{n}}')
equation_editor('\textup{selectivity index} = \frac {\left \| v \right \|} {\sum_{n=1}^{N}R_{n}\left \| R_{n} \right \|}')

