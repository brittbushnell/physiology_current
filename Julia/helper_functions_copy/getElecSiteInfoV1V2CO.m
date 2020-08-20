function siteinfo = getElecSiteInfoV1V2CO(nlIN,elName,pialName,wmName,sitedepth,depthRelAbs,doCO,nbrspacing)
% by JK 2/5/18 
% For a given site along an electrode track, returns layer identity, 
% relative depth within layer, relative cortical depth (along normal), CO 
% patch alignment, and optionally radial and tangential displacement from 
% neighbors.
% Currently, relative depths in (non-opercular) V2 are not along surface
% normal for V2.
% 
% REQUIRED INPUTS: 
% nlIN: prepackaged neurolucida reconstruction containing fields:
%   electrodes (defines track trajectory), bvFits (lines fit to blood 
%   vessels to estimate surface-normal, lyrSurfs (scattered interpolant
%   representation of laminar boundaries), lyrInts (from preliminary
%   analysis of positions where track crossed each laminar boundary)
% elName: name of electrode 
% pialName: designation of pial surface (layer 1)
% wmName: designation of white matter
% sitedepth: depth of recording site queried, either in microns or units of
%   relative cortical depth 
% depthRelAbs: specifies whether sitedepth input in microns or relative
%   cortical depth (default microns)
% 
% OPTIONAL INPUTS:
% doCO: true to analyze position relative to reconstructed CO patches;
%   false to skip
% nbrspacing: spacing in microns between electrode sites (specify to get
%   the spacing between adjacent sites along the probe separated into
%   radial and tangential components
% 
% OUTPUT:
% structure with fields:
% area: cortical area (V1 or V2)
% relative cortical depth: distance below the pial surface along surface
%   normal, normalized by total pial-to-white matter distance 
% lyrname: name of layer containing site
% lyrreldepth: depth within cortical layer (along surface normal) divided
%   by total depth of layer
% raddistabove: displacement from preceding electrode site in surface
%   normal direction (only if 'nbrspacing' specified)
% raddistabovebelow: displacement from following electrode site in surface
%   normal direction (only if 'nbrspacing' specified)
% tandistabove: displacement from preceding electrode site in tangential
%   direction (only if 'nbrspacing' specified)
% tandistbelow: displacement from following electrode site in tangential
%   direction (only if 'nbrspacing' specified)
% cocenterdist: estimated distance in microns to nearest CO patch center
%   (only if doCO==true and CO patches are represented in the
%   reconstruction)

%%%%%%%%%%%%%%%%%%%
if nargin<6;     error('not enough input arguments'); end

elecs = nlIN.electrodes;
bvFits = nlIN.bvFits; 
lyrIntsTrack = nlIN.lyrInts;
S = nlIN.lyrSurfs;
if isfield(nlIN.lyrInts.(elName),'V2Depth')
    doV1V2 = true;
else
    doV1V2 = false;
end

if ~exist('doCO','var') || isempty(doCO) ||~isfield(nlIN,'co')
    doCO = false;
end
if exist('nbrspacing','var');	doRadTanDist = true;
else;    doRadTanDist = false;
end

options = optimset('MaxFunEvals',3200,'MaxIter',1600);
%%%%%%%%%%%%%%%%%%%
%%%% get position info
numlines = max(lyrIntsTrack.(elName).lyrInts(:,4));

if depthRelAbs=='rel' % default: 'abs'
    sitedepth = sitedepth*lyrIntsTrack.(elName).wmdepth; % convert to absolute depth
end

if numlines>1  % get depth along electrode trajectory instead of point-to-point
    if any(lyrIntsTrack.(elName).cutoffDepths<sitedepth)
        linenum = find(lyrIntsTrack.(elName).cutoffDepths<sitedepth,1,'last')+1;
        sitexyz = lyrIntsTrack.(elName).cutoffXYZB(linenum-1,:) +(sitedepth-lyrIntsTrack.(elName).cutoffDepths(linenum-1))*elecs.(elName).lines(linenum).V(:,1)';
    else 
        sitexyz = lyrIntsTrack.(elName).lyrInts(1,1:3) + sitedepth*elecs.(elName).lines(1).V(:,1)';  
    end
else
    sitexyz = lyrIntsTrack.(elName).lyrInts(1,1:3) + sitedepth*elecs.(elName).lines(1).V(:,1)';  
end

%%%% get surface normal
numBVs = max(size(bvFits));
bvV = nan(3,numBVs); dists = nan(1,numBVs);
for bv = 1:numBVs
    bvV(:,bv) = bvFits{bv}.surfNormal;
    dists(bv) = norm(cross((bvFits{bv}.V(:,1)'-sitexyz),(bvFits{bv}.V(:,1)'-bvFits{bv}.r0)))/norm(bvFits{bv}.V(:,1)'-bvFits{bv}.r0);
end
if any(dists==0)
    surfNormal = bvV(:,dists==0);
else
    dists = repmat(dists,3,1);
    surfNormal = sum(bvV./dists,2)./sum(dists.^(-1),2);
end

r0 = sitexyz;
V = surfNormal';

%%%% get layer info and relative cortical depth
lyrnames = fieldnames(S); 
wmix = find(~cellfun(@isempty,cellfun(@(x) strfind(x,wmName),lyrnames,'UniformOutput',0)));
pialix = find(~cellfun(@isempty,cellfun(@(x) strfind(x,pialName),lyrnames,'UniformOutput',0)));
v1v2 = find(~cellfun(@isempty,cellfun(@(x) strfind(x,'order'),lyrnames,'UniformOutput',0)));
lyrs = setdiff(1:size(lyrnames,1),v1v2);
v2oplyrs = find(~cellfun(@isempty,cellfun(@(x) strfind(x,'V2op_'),lyrnames,'UniformOutput',0)));
v2lyrs = find(~cellfun(@isempty,cellfun(@(x) strfind(x,'V2_'),lyrnames,'UniformOutput',0)));
v1lyrs = setdiff(lyrs,[v2lyrs,v2oplyrs]);

lyrIntsSN = nan(size(lyrnames,2),3);
for lyr = lyrs
    lyrf = S.(lyrnames{lyr}).f;
    startpoints = [(mean(mean(S.(lyrnames{lyr}).Y))-r0(2))/V(2) 0 ...
        (mean(S.(lyrnames{lyr}).x)-r0(1))/V(1) (mean(S.(lyrnames{lyr}).z)-r0(3))/V(3)];
    minz = min(S.(lyrnames{lyr}).z);
    maxz = max(S.(lyrnames{lyr}).z);
    xyz = getint(sitexyz,V,lyrf,minz,maxz,startpoints,options);    
    lyrIntsSN(lyr,:) = xyz; 
end
wmdepth = norm(lyrIntsSN(wmix,1:3)-lyrIntsSN(pialix,1:3));
pialDist=norm(lyrIntsSN(pialix,1:3)-sitexyz);
yDATF = lyrIntsSN(wmix,2)<lyrIntsSN(pialix,2);  % y vals descending or ascending with cortical depth

if (yDATF && lyrIntsSN(pialix,2)<sitexyz(2)) || (~yDATF && lyrIntsSN(pialix,2)>sitexyz(2)) % above cortex
    siteinfo.area = '';
    siteinfo.relativecorticaldepth = nan;
    siteinfo.lyrname = '';
    siteinfo.lyrreldepth = nan;
elseif pialDist>wmdepth
    if isempty(v2lyrs)  % no V2 traced: everything below 6/wm -> 'wm'
        siteinfo.area = '';
        siteinfo.relativecorticaldepth = pialDist/wmdepth;
        siteinfo.lyrname = 'wm';
        siteinfo.lyrreldepth = nan;
    elseif length(v2lyrs)==1  % only traced V2 wm
        v2wmdepth = norm(lyrIntsSN(v2lyrs,1:3)-lyrIntsSN(pialix,1:3));
        if pialDist<v2wmdepth
            siteinfo.area = '';
            siteinfo.relativecorticaldepth = pialDist/wmdepth;
            siteinfo.lyrname = 'wm';
            siteinfo.lyrreldepth = nan;
        else
            siteinfo.area = 'V2';
            siteinfo.relativecorticaldepth = nan;
            siteinfo.lyrname = '';
            siteinfo.lyrreldepth = nan;
        end
    else  % in V2
        %%%% untested %%%%
        lyrIntsSN = lyrIntsSN(v2lyrs,:);
        if yDATF
            [~,ix] = sort(lyrIntsSN(:,2),'descend');
        else
            [~,ix] = sort(lyrIntsSN(:,2),'ascend');
        end
        lyrIntsSN = lyrIntsSN(ix,:);
        a = lyrIntsSN(2:end,1:3); b = lyrIntsSN(1:end-1,1:3);
        lyrDepths = sqrt(sum((a-b).^2,2));
        if yDATF
            lyrnum = find(bsxfun(@ge,sitexyz(2),lyrIntsSN(:,2)),1,'last');
        else
            lyrnum = find(bsxfun(@le,sitexyz(2),lyrIntsSN(:,2)),1,'last');
        end
        if isempty(lyrnum)
            siteinfo.area = '';
            siteinfo.relativecorticaldepth = nan;
            siteinfo.lyrname = '';
            siteinfo.lyrreldepth = nan;
        else
            siteinfo.area = 'V2';
            siteinfo.relativecorticaldepth = norm(lyrIntsSN(1,1:3)-sitexyz)/norm(lyrIntsSN(1,1:3)-lyrIntsSN(end,1:3));
            siteinfo.lyrname = lyrnames{v2lyrs(ix(lyrnum))};
            lyrstartxyz = lyrIntsSN(v2lyrs(lyrnum),1:3);
            siteinfo.lyrreldepth = norm(sitexyz-lyrstartxyz)/(lyrDepths(lyrnum));
        end
    end    
elseif doV1V2 && sitedepth>nlIN.lyrInts.(elName).V2Depth % in opercular V2  
    siteinfo.area = 'V2';
    siteinfo.relativecorticaldepth = pialDist/wmdepth;
    if isempty(v2oplyrs)
        siteinfo.lyrname = nan;
        siteinfo.lyrreldepth = nan;
    else
        v2oplyrs = [pialix v2oplyrs wmix];
        lyrIntsSN = lyrIntsSN(v2oplyrs,:);
        if yDATF
            [~,ix] = sort(lyrIntsSN(:,2),'descend');
        else
            [~,ix] = sort(lyrIntsSN(:,2),'ascend');
        end
        lyrIntsSN = lyrIntsSN(ix,:);
        a = lyrIntsSN(2:end,1:3); b = lyrIntsSN(1:end-1,1:3);
        lyrDepths = sqrt(sum((a-b).^2,2));
        if yDATF
            lyrnum = find(bsxfun(@le,sitexyz(2),lyrIntsSN(:,2)),1,'last');
        else
            lyrnum = find(bsxfun(@ge,sitexyz(2),lyrIntsSN(:,2)),1,'last');
        end
        siteinfo.lyrname = lyrnames{v2oplyrs(ix(lyrnum))};  
        lyrstartxyz = lyrIntsSN(v2oplyrs(lyrnum),1:3);
        siteinfo.lyrreldepth = norm(sitexyz-lyrstartxyz)/(lyrDepths(lyrnum)); 
    end
    
else % V1
    siteinfo.area = 'V1';
    siteinfo.relativecorticaldepth = pialDist/wmdepth;
    lyrIntsSN = lyrIntsSN(v1lyrs,:);
    if yDATF
        [~,ix] = sort(lyrIntsSN(:,2),'descend');
    else
        [~,ix] = sort(lyrIntsSN(:,2),'ascend');
    end
    lyrIntsSN = lyrIntsSN(ix,:);
    a = lyrIntsSN(2:end,1:3); b = lyrIntsSN(1:end-1,1:3);
    lyrDepths = sqrt(sum((a-b).^2,2));
    if yDATF
        lyrnum = find(bsxfun(@le,sitexyz(2),lyrIntsSN(:,2)),1,'last');
    else
        lyrnum = find(bsxfun(@ge,sitexyz(2),lyrIntsSN(:,2)),1,'last');
    end
    siteinfo.lyrname = lyrnames{v1lyrs(ix(lyrnum))};
    lyrstartxyz = lyrIntsSN(v1lyrs(lyrnum),1:3);
    siteinfo.lyrreldepth = norm(sitexyz-lyrstartxyz)/(lyrDepths(lyrnum)); 

end

%%%% get displacement from neighbors
if doRadTanDist
    if numlines>1  
        if any(lyrIntsTrack.(elName).cutoffDepths<(sitedepth-nbrspacing))
            linenum = find(lyrIntsTrack.(elName).cutoffDepths<(sitedepth-nbrspacing),1,'last')+1;
            nbrAxyz = lyrIntsTrack.(elName).cutoffXYZB(linenum-1,:) +(sitedepth-nbrspacing-lyrIntsTrack.(elName).cutoffDepths(linenum-1))*elecs.(elName).lines(linenum).V(:,1)';
        else 
            nbrAxyz = lyrIntsTrack.(elName).lyrInts(1,1:3) + (sitedepth-nbrspacing)*elecs.(elName).lines(1).V(:,1)';  
        end
        if any(lyrIntsTrack.(elName).cutoffDepths<(sitedepth+nbrspacing))
            linenum = find(lyrIntsTrack.(elName).cutoffDepths<(sitedepth+nbrspacing),1,'last')+1;
            nbrBxyz = lyrIntsTrack.(elName).cutoffXYZB(linenum-1,:) +(sitedepth+nbrspacing-lyrIntsTrack.(elName).cutoffDepths(linenum-1))*elecs.(elName).lines(linenum).V(:,1)';
        else 
            nbrBxyz = lyrIntsTrack.(elName).lyrInts(1,1:3) + (sitedepth+nbrspacing)*elecs.(elName).lines(1).V(:,1)';  
        end
    else
        nbrAxyz = lyrIntsTrack.(elName).lyrInts(1,1:3) + (sitedepth-nbrspacing)*elecs.(elName).lines(1).V(:,1)';  
        nbrBxyz = lyrIntsTrack.(elName).lyrInts(1,1:3) + (sitedepth+nbrspacing)*elecs.(elName).lines(1).V(:,1)';  
    end
    siteinfo.raddistabove = abs(dot(sitexyz-nbrAxyz,surfNormal')/norm(surfNormal));
    siteinfo.raddistbelow = abs(dot(sitexyz-nbrBxyz,surfNormal')/norm(surfNormal));
    siteinfo.tandistabove = sqrt(nbrspacing^2-siteinfo.raddistabove^2);
    siteinfo.tandistbelow = sqrt(nbrspacing^2-siteinfo.raddistbelow^2);
end

%%%% get CO alignment
if doCO && strcmp(siteinfo.area,'V1') 
    dists = nan(1,nlIN.co.numCentroids);
    for copatch = 1:nlIN.co.numCentroids
        dists(copatch) = abs(norm(cross(nlIN.co.surfaceNormals(copatch,:),(sitexyz-nlIN.co.centroids(copatch,1:3))))/norm(nlIN.co.surfaceNormals(copatch,:)));
    end    

    [~,nearestcent] = min(dists);
    centgrpnums = unique(nlIN.co.centroids(:,4));
    pln = nlIN.co.planeABCD{centgrpnums==nlIN.co.centroids(nearestcent,4)};
    if isempty(pln)
        siteinfo.cocenterdist = min(dists);
        siteinfo.nearestcoID = 0;
    else
    %     siteinfo.cocenterdist = abs(sum(pln(1:3).*sitexyz)-pln(4))/norm(pln(1:3));
        siteinfo.cocenterdist = abs((sum(pln(1:3).*sitexyz)-pln(4))/norm(pln(1:3)));
        siteinfo.nearestcoID = nearestcent;
    end
    
    if siteinfo.cocenterdist>300 % possible error
        [dists,distsix] = sort(dists,'ascend');
        plndists = nan(1,min([10,length(dists)]));
        for nearestcent = distsix(1:min([10,length(dists)]))
            pln = nlIN.co.planeABCD{centgrpnums==nlIN.co.centroids(nearestcent,4)};
            if ~isempty(pln)
                plndists(distsix==nearestcent) = abs((sum(pln(1:3).*sitexyz)-pln(4))/norm(pln(1:3)));
            end
        end
        if any(~isnan(plndists))
            [mindist,minix] = min(plndists);
            if mindist<siteinfo.cocenterdist
                siteinfo.cocenterdist = mindist;
                siteinfo.nearestcoID = distsix(minix);
            end
        end
    end
end

%%%%%%%%%%%%%%%%%%%
function val = getint(r0,V,lyrf,minz,maxz,startpoints,options)
A = nan(length(startpoints),2);
F = @(x,r0,V,lyrf) linesurf(x,r0,V,lyrf);
for startix = 1:length(startpoints)
    [A(startix,1),A(startix,2)] = fminsearch(@(x) F(x,r0,V,lyrf),startpoints(startix),options);
end

if any(A(:,2)<0.001)
    A = A(A(:,2)<0.001,:);
end
% if any(A(:,1)>mint & A(:,1)<maxt)
%     A = A(A(:,1)>mint & A(:,1)<maxt,:);
% end
xyz = r0+A(:,1)*V;
if any(xyz(:,3)>minz & xyz(:,3)<maxz)
    A = A(xyz(:,3)>minz & xyz(:,3)<maxz,:);
end
[~,ix] = min(A(:,2));
val = r0+A(ix,1)*V;


%%%%%%%%%%%%%%%%%%%
function F = linesurf(x,r0,V,lyrf) 
% F = abs(r0(3)+x*V(3,1) - lyrf((r0(1)+x*V(1,1)),(r0(2)+x*V(2,1))));
F = abs(r0(2)+x*V(2) - lyrf((r0(1)+x*V(1)),(r0(3)+x*V(3))));

