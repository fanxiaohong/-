function featuresS = ngldmToScalarFeatures(s,numVoxels)
% function featuresS = ngldmToScalarFeatures(s,numVoxels)
% 
% APA, 03/16/2017

% Coarseness
Ns = sum(s(:));
Nn = size(s,2);
Ng = size(s,1);
lenV = 1:Nn;
levV = 1:Ng;

%1 Low dependence emphasis
sLdeM = bsxfun(@rdivide,s,lenV.^2);
featuresSlde = sum(sLdeM(:))/Ns;

%2 High dependence emphasis
sHdeM = bsxfun(@times,s,lenV.^2);
featuresShde = sum(sHdeM(:))/Ns;

%3 Low grey level count emphasis
sLgceM = bsxfun(@rdivide,s',(1:Ng).^2);
featuresSlgce = sum(sLgceM(:))/Ns;

%4 High grey level count emphasis
sHgceM = bsxfun(@times,s',(1:Ng).^2);
featuresShgce = sum(sHgceM(:))/Ns;

%5 Low dependence low grey level emphasis
sLdlgeM = bsxfun(@rdivide,bsxfun(@rdivide,s,lenV.^2)',(1:Ng).^2);
featuresSldlge = sum(sLdlgeM(:))/Ns;

%6 Low dependence high grey level emphasis
sLdhgeM = bsxfun(@times,bsxfun(@rdivide,s,lenV.^2)',(1:Ng).^2);
featuresSldhge = sum(sLdhgeM(:))/Ns;

%7 High dependence low grey level emphasis
sHdlgeM = bsxfun(@rdivide,bsxfun(@times,s,lenV.^2)',(1:Ng).^2);
featuresShdlge = sum(sHdlgeM(:))/Ns;

%8 High dependence high grey level emphasis
sHdhgeM = bsxfun(@times,bsxfun(@times,s,lenV.^2)',(1:Ng).^2);
featuresShdhge = sum(sHdhgeM(:))/Ns;

%9 Grey level non-uniformity
featuresSgln = sum(sum(s,2).^2)/Ns;

%10 Grey level non-uniformity normalised
featuresSglnNorm = sum(sum(s,2).^2)/Ns^2;

%11 Dependence count non-uniformity
featuresSdcn = sum(sum(s,1).^2)/Ns;

%12 Dependence count non-uniformity normalised
featuresSdcnNorm = sum(sum(s,1).^2)/Ns^2;

%13 Dependence count percentage
featuresSdcp = Ns/numVoxels;

%14 Grey level variance
iPij = bsxfun(@times,s'/sum(s(:)),levV);
mu = sum(iPij(:));
iMinusMuPij = bsxfun(@times,s'/sum(s(:)),(levV-mu).^2);
featuresSglv = sum(iMinusMuPij(:));

%15 Dependence count variance
jPij = bsxfun(@times,s/sum(s(:)),lenV);
mu = sum(jPij(:));
jMinusMuPij = bsxfun(@times,s/sum(s(:)),(lenV-mu).^2);
featuresSdcv = sum(jMinusMuPij(:));

%16 Dependence count entropy
p = s(:)/sum(s(:));
featuresSentropy = -sum(p .* log2(p+eps));

%17 Dependence count energy
p = s(:)/sum(s(:));
featuresSenergy = sum(p .^2);

featuresS =[featuresSlde;featuresShde;featuresSlgce;featuresShgce;featuresSldlge;featuresSldhge;featuresShdlge;...
    featuresShdhge;featuresSgln;featuresSglnNorm;featuresSdcn;featuresSdcnNorm;featuresSdcp;featuresSglv;...
    featuresSdcv;featuresSentropy;featuresSenergy];  % ×é×°





