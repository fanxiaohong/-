function featureReducedSAll = reduceDirFeatures_lung(featuresAllDirS)
% function featureReducedS = reduceDirFeatures(featuresAllDirS, reduceType)
%
% This function combines the directional feature values into a single
% value. The reduceType specifies how the different directions should be
% combined. The supported reduceTypes are 'avg', 'max', 'min', 'std',
% 'mad', 'iqr'
%
% APA, 4/11/2017

filedNamC = fieldnames(featuresAllDirS);

featureReducedSavgAll = [];
featureReducedSminAll = [];
featureReducedSmaxAll = [];
featureReducedSstdAll = [];
featureReducedSmadAll = [];
featureReducedSAll = [];
for iField = 1:length(filedNamC)
    fieldName = filedNamC{iField};
%     switch lower(reduceType)
%         case 'avg'
            featureReducedSavg = mean([featuresAllDirS.(fieldName)]);
            featureReducedSavgAll = [featureReducedSavgAll;featureReducedSavg];
%         case 'min'
            featureReducedSmin = min([featuresAllDirS.(fieldName)]);
            featureReducedSminAll = [featureReducedSminAll;featureReducedSmin];
%         case 'max'
            featureReducedSmax = max([featuresAllDirS.(fieldName)]);
            featureReducedSmaxAll = [featureReducedSmaxAll;featureReducedSmax];
%         case 'std'
            featureReducedSstd = std([featuresAllDirS.(fieldName)]);
            featureReducedSstdAll = [featureReducedSstdAll;featureReducedSstd];
%         case 'mad'
            featureReducedSmad = mad([featuresAllDirS.(fieldName)]);
            featureReducedSmadAll = [featureReducedSmadAll;featureReducedSmad];
%         case 'iqr'
%             featureReducedS.(fieldName) = mad([featuresAllDirS.(fieldName)]);
%     end
end

% 把glcm特征组装
featureReducedSAll = [featureReducedSavgAll;featureReducedSmaxAll;featureReducedSminAll;featureReducedSstdAll;...
     featureReducedSmadAll];
