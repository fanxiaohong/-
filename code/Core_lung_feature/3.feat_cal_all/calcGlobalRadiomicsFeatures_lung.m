function featureS = ...
calcGlobalRadiomicsFeatures_lung(scanNum, structNum, paramS, planC)
% Wrapper to extract global radiomics features
%
% APA, 6/3/2017
% MCO, 04/19/2017
% Based on APA, 04/17/2017
% AI, 3/22/19 Updated for compatibility with JSON input for batch extraction
% AI, 3/28/19 Created scripts for pre-processing & feature extraction

% %Read JSON parameter file
% paramS = getRadiomicsParamTemplate(paramFilename);

%% Pre-processing 
[volToEval,maskBoundingBox3M,gridS] =  preProcessForRadiomics_lung(scanNum,...
                                       structNum, paramS, planC);

%% Feature extraction
featureS = calcRadiomicsForImgType_lung(volToEval,maskBoundingBox3M,paramS,gridS);

%%
% featS_after = featureS;  zValsV出错时，总共需要添加两行语句此处为第二处