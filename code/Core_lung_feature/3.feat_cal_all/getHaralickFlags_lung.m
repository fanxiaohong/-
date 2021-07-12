function glcmFlagS = getHaralickFlags_lung(varargin)
        
        %Default: all features
        glcmFlagS.energy = 1;
        glcmFlagS.jointEntropy = 1;
        glcmFlagS.jointMax = 1;
        glcmFlagS.jointAvg = 1;
        glcmFlagS.jointVar = 1;
        glcmFlagS.contrast = 1;
        glcmFlagS.invDiffMoment = 1;
        glcmFlagS.sumAvg = 1;
        glcmFlagS.corr = 1;
        glcmFlagS.clustShade = 1;
        glcmFlagS.clustProm = 1;
        glcmFlagS.haralickCorr = 1;
        glcmFlagS.invDiffMomNorm = 1;
        glcmFlagS.invDiff = 1;
        glcmFlagS.invDiffNorm = 1;
        glcmFlagS.invVar = 1;
        glcmFlagS.dissimilarity = 1;
        glcmFlagS.diffEntropy = 1;
        glcmFlagS.diffVar = 1;
        glcmFlagS.diffAvg = 0;  %Equivalent to dissimilarity
        glcmFlagS.sumVar = 1;
        glcmFlagS.sumEntropy = 1;
        glcmFlagS.clustTendency = 1;
        glcmFlagS.autoCorr = 1;
        glcmFlagS.invDiffMomNorm = 1;
        glcmFlagS.firstInfCorr = 1;
        glcmFlagS.secondInfCorr = 1;
        
        if nargin==1 && ~strcmpi(varargin{1},'all')
            featureC = varargin{1};
            allFeatC = fieldnames(glcmFlagS);
            idxV = find(~ismember(allFeatC,featureC));
            for n = 1:length(idxV)
                glcmFlagS.(allFeatC{idxV(n)})  = 0;
            end
        end
        
    end