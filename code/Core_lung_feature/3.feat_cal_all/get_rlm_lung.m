function [rlmFeatures] = get_rlm_lung(dirctn, rlmType, quantizedM, numGrLevels, numVoxels, rlmFlagS)
  % Get directional offsets
  offsetsM = getOffsets(dirctn);

  % Calculate RLM
  rlmM = calcRLM(quantizedM, offsetsM, numGrLevels, rlmType);

%   if rlmType==1
%     % calculate scalar features
%     rlmFeatureCombS = rlmToScalarFeatures(rlmM, numVoxels, rlmFlagS);
% 
%     % save
%     rlmFeatures = struct;
%     rlmFeatures.CombS = rlmFeatureCombS;
% 
%   elseif rlmType==2
    rlmFeatureAllDirS = struct();
    % calculate scalar features
    for i = 1:length(rlmM)
         rlmCurrentDirS = rlmToScalarFeatures(rlmM{i}, numVoxels, rlmFlagS);
         rlmFeatureAllDirS = dissimilarInsert(rlmFeatureAllDirS,rlmCurrentDirS);
    end

    
    rlmFeatures = reduceDirFeatures_lung(rlmFeatureAllDirS);  % 计算所有rlm纹理特征值
end
    % reduce and save
%     rlmFeatures = struct;
% 
%     featureReduceType = 'avg';
%     rlmFeatures.AvgS = reduceDirFeatures(rlmFeatureAllDirS,featureReduceType);
% 
%     featureReduceType = 'max';
%     rlmFeatures.MaxS = reduceDirFeatures(rlmFeatureAllDirS,featureReduceType);
% 
%     featureReduceType = 'min';
%     rlmFeatures.MinS = reduceDirFeatures(rlmFeatureAllDirS,featureReduceType);
% 
%     featureReduceType = 'std';
%     rlmFeatures.StdS = reduceDirFeatures(rlmFeatureAllDirS,featureReduceType);
% 
%     featureReduceType = 'mad';
%     rlmFeatures.MadS = reduceDirFeatures(rlmFeatureAllDirS,featureReduceType);
%   end
