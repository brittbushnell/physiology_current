function matPasses = GetMatrixPasses(expoIn)

matBlockIds = expoIn.matrix.MatrixBaseID + (0:expoIn.matrix.NumOfBlocks-1);
matPasses = find(ismember(expoIn.passes.BlockIDs,matBlockIds))-1;