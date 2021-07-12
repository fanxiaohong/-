function szmFlagS = getSizeZoneFlags_lung(varargin)
                
        szmFlagS.gln = 1;
        szmFlagS.glnNorm = 1;
        szmFlagS.glv = 1;
        szmFlagS.hglze = 1;
        szmFlagS.lglze = 1;
        szmFlagS.lae = 1;
        szmFlagS.lahgle = 1;
        szmFlagS.lalgle = 1;
        szmFlagS.szn = 1;
        szmFlagS.sznNorm = 1;
        szmFlagS.szv = 1;
        szmFlagS.zp = 1;
        szmFlagS.sae = 1;    
        szmFlagS.salgle = 1;
        szmFlagS.sahgle = 1;
        szmFlagS.ze = 1;
        
        
        if nargin==1 && ~strcmpi(varargin{1},'all')
            featureC = lower(varargin{1});
            allFeatC = fieldnames(szmFlagS);
            idxV = find(~ismember(allFeatC,featureC));
            for n = 1:length(idxV)
                szmFlagS.(allFeatC{idxV(n)})  = 0;
            end
        end
        
    end