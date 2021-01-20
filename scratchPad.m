
goodQuads = trLE.rfQuadrant(trLE.goodCh == 1 & trLE.inStimCenter == 0 & trLE.within2Deg == 1 & trLE.prefParamSI >=0.5);
goodOris = trLE.prefParamsPrefOri(trLE.goodCh == 1 & trLE.inStimCenter == 0  & trLE.within2Deg == 1 & trLE.prefParamSI >=0.5);
goodRanks = chRanksLE(trLE.goodCh == 1 & trLE.inStimCenter == 0 & trLE.within2Deg == 1 & trLE.prefParamSI >=0.5);
t1Text = ({'Distribution of preferred orientations all channels within 2deg of the stimulus (no center)';...
   sprintf('%s LE %s', trLE.animal,trLE.array)});

[trLE.within2OrisHighSI, trLE.within2RanksHighSI] = getOrisInRFs_plotDists(goodQuads, goodRanks, goodOris, t1Text);

