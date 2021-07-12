function rlmFlagS = getRunLengthFlags_lung(varargin)
        
        rlmFlagS.sre = 1;
        rlmFlagS.lre = 1;
        rlmFlagS.gln = 1;
        rlmFlagS.glnNorm = 1;
        rlmFlagS.rln = 1;
        rlmFlagS.rlnNorm = 1;
        rlmFlagS.rp = 1;
        rlmFlagS.lglre = 1;
        rlmFlagS.hglre = 1;
        rlmFlagS.srlgle = 1;
        rlmFlagS.srhgle = 1;
        rlmFlagS.lrlgle = 1;
        rlmFlagS.lrhgle = 1;
        rlmFlagS.glv = 1;
        rlmFlagS.rlv = 1;
        rlmFlagS.re = 1;
        
        if nargin==1 && ~strcmpi(varargin{1},'all')
            featureC = lower(varargin{1});
            allFeatC = fieldnames(rlmFlagS);
            idxV = find(~ismember(allFeatC,featureC));
            for n = 1:length(idxV)
                rlmFlagS.(allFeatC{idxV(n)})  = 0;
            end
        end
        
    end