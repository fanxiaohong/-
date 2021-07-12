function featureS = szmToScalarFeatures(szmM, numVoxels, flagS)
% function featureS = szmToScalarFeatures(szmM, numVoxels, flagS)
%
% INPUT:  szmM of size nL x maxLength (in units of number of voxels)
%         flagS is a structure with feature names as its fields.
%         The values represent flags to calculate (or not) that particular feature.
%         EXAMPLE:
%         ** flagS.sre = 1;
%            flagS.lre = 0;
%            flagS.rln = 1;
% OUTPUT: featureS is a structure array with scalar texture features as its
%         fields. Each field's value is a vector containing the feature values
%         for each szmM
%
% EXAMPLE:
%
% numRows = 10;
% numCols = 10;
% numSlcs = 1;
% 
% % get directions
% offsetM = getOffsets(1);
% 
% % number of gray levels
% nL = 3;
% 
% % create an image with random numbers
% imgM = randi(nL,numRows,numCols,numSlcs);
% 
% 2-d or 3-d zones
% szmType = 1;
%
% % call the rlm calculator
% szmM = calcSZM(quantizedM, nL, szmType)
% 
% % define feature flags
% flagS.sae = 1;
% flagS.lae = 1;
% flagS.gln = 1;
% flagS.glv = 1;
% flagS.szv = 1;
% flagS.glnNorm
% flagS.szn = 1;
% flagS.sznNorm
% flagS.zp = 1;
% flagS.lglze = 1;
% flagS.hglze = 1;
% flagS.salgle = 1;
% flagS.sahgle = 1;
% flagS.lalgle = 1;
% flagS.larhgle = 1;
%
% % Number of voxels
% numVoxels = numel(imgM);
%
% % Convert RLM matrix to scalar features
% featureS = rlmToScalarFeatures(szmM, numVoxels, flagS);
%
%
% APA, 3/02/2018

nL = size(szmM,1);
lenV = 1:size(szmM,2);
levV = 1:nL;

% Small Area Emphasis (SAE) (Aerts et al, Nature suppl. eq. 45)
%1 if flagS.sae
    saeM = bsxfun(@rdivide,szmM,lenV.^2);
    featureSsae = sum(saeM(:))/sum(szmM(:));
% end

%2 Large Area Emphasis (LAE) (Aerts et al, Nature suppl. eq. 46)
% if flagS.lae
    laeM = bsxfun(@times,szmM,lenV.^2);
    featureSlae = sum(laeM(:))/sum(szmM(:));
% end

% Gray Level Non-Uniformity (GLN) (Aerts et al, Nature suppl. eq. 47)
%3 if flagS.gln
    featureSgln = sum(sum(szmM,2).^2) / sum(szmM(:));
% end

%4 if flagS.glnNorm
    featureSglnNorm = sum(sum(szmM,2).^2) / sum(szmM(:))^2;
% end

%5 Size Zone Non-Uniformity (SZN) (Aerts et al, Nature suppl. eq. 48)
% if flagS.szn
    featureSszn = sum(sum(szmM,1).^2) / sum(szmM(:));
% end

%6 Size Zone Non-Uniformity Normalized (SZNN) (Aerts et al, Nature suppl. eq. 48)
% if flagS.sznNorm
    featureSsznNorm = sum(sum(szmM,1).^2) / sum(szmM(:))^2;
% end

%7 Zone Percentage (ZP) (Aerts et al, Nature suppl. eq. 49)
% if flagS.zp
    if isempty(numVoxels)
        numVoxels = 1;
    end
    featureSzp = sum(szmM(:)) / numVoxels;
% end

%8 Low Gray Level Zone Emphasis (LGLZE) (Aerts et al, Nature suppl. eq. 50)
% if flagS.lglze
    lglzeM = bsxfun(@rdivide,szmM',levV.^2);
    featureSlglze = sum(lglzeM(:)) / sum(szmM(:));
% end

% High Gray Level Zone Emphasis (HGLZE) (Aerts et al, Nature suppl. eq. 51)
%9 if flagS.hglze
    hglzeM = bsxfun(@times,szmM',levV.^2);
    featureShglze = sum(hglzeM(:)) / sum(szmM(:));
% end

%10 Small Area Low Gray Level Emphasis (SALGLE) (Aerts et al, Nature suppl. eq. 52)
% if flagS.salgle
    levLenM = bsxfun(@times,(levV').^2,lenV.^2);
    salgleM = bsxfun(@rdivide,szmM,levLenM);
    featureSsalgle = sum(salgleM(:)) / sum(szmM(:));
% end

%11 Small Area High Gray Level Emphasis (SAHGLE) (Aerts et al, Nature suppl. eq. 53)
% if flagS.sahgle
    levLenM = bsxfun(@times,(levV').^2,1./lenV.^2);
    sahgleM = bsxfun(@times,szmM,levLenM);
    featureSsahgle = sum(sahgleM(:)) / sum(szmM(:));
% end

%12 Large Area Low Gray Level Emphasis (LALGLE) (Aerts et al, Nature suppl. eq. 54)
% if flagS.lalgle
    levLenM = bsxfun(@times,1./(levV').^2,lenV.^2);
    lalgleM = bsxfun(@times,szmM,levLenM);
    featureSlalgle = sum(lalgleM(:)) / sum(szmM(:));
% end

%13 Large Area High Gray Level Emphasis (LAHGLE) (Aerts et al, Nature suppl. eq. 55)
% if flagS.lahgle
    levLenM = bsxfun(@times,(levV').^2,lenV.^2);
    lahgleM = bsxfun(@times,szmM,levLenM);
    featureSlahgle = sum(lahgleM(:)) / sum(szmM(:));
% end

%14 Grey Level Variance
% if flagS.glv
    iPij = bsxfun(@times,szmM'/sum(szmM(:)),levV);
    mu = sum(iPij(:));
    iMinusMuPij = bsxfun(@times,szmM'/sum(szmM(:)),(levV-mu).^2);
    featureSglv = sum(iMinusMuPij(:));
% end

%15 Size Zone Variance
% if flagS.szv
    jPij = bsxfun(@times,szmM/sum(szmM(:)),lenV);
    mu = sum(jPij(:));
    jMinusMuPij = bsxfun(@times,szmM/sum(szmM(:)),(lenV-mu).^2);
    featureSszv = sum(jMinusMuPij(:));
% end

%16 Zone Entropy
% if flagS.ze
    zoneSum = sum(szmM(:));
    featureSze = -sum(szmM(:)/zoneSum .* log2(szmM(:)/zoneSum + eps));
% end

featureS = [featureSsae;featureSlae;featureSgln;featureSglnNorm;featureSszn;featureSsznNorm;featureSzp;...
    featureSlglze;featureShglze;featureSsalgle;featureSsahgle;featureSlalgle;featureSlahgle;featureSglv;...
    featureSszv;featureSze] ; %  ×é×°