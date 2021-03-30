% debugging/figuring out GlassCoh and why some match perfectly
    for ndx = 1:numel(REdata)
        RErcdT(ndx) = dataBE(REndxs(ndx));
    end
    
    vSum = sqrt(RErcdT(:,1).^2 + RErcdT(:,2).^2 + RErcdT(:,3).^2);
    [Ct,CoMsphRE(nb,:)] = triplotter_centerMass(RErcdT,vSum,[1 0 0],0);

    if isnan(Ct)
        keyboard
    else
        CoMRE(nb,:) = Ct;
    end
    clear RErcdT; clear vSum; clear Ct;