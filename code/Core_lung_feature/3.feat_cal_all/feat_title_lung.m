function [feat_name,col_name] = feat_title_lung(roi_name,data_time,filt_name);
% ��ͷ

%% ��װ������ͷ��Ϣ
% 
if length(filt_name) == 4
    filt_name = {'Original','Wavelets_HHH','Sobel','Gabor'};  % �˲�����
end
% 1 fisterorder name
FirstOrder = {'FirstOrderS-min';'FirstOrderS-max';'FirstOrderS-mean';...
    'FirstOrderS-range';'FirstOrderS-std';'FirstOrderS-var';'FirstOrderS-median';...
    'FirstOrderS-skewness';'FirstOrderS-kurtosis';'FirstOrderS-entropy';'FirstOrderS-rms';...
    'FirstOrderS-energy';'FirstOrderS-totalEnergy';'FirstOrderS-meanAbsDev';...
    'FirstOrderS-medianAbsDev';'FirstOrderS-P10';'FirstOrderS-P90';...
    'FirstOrderS-robustMeanAbsDev';'FirstOrderS-robustMedianAbsDev';'FirstOrderS-interQuartileRange';...
    'FirstOrderS-coeffDispersion';'FirstOrderS-coeffVariation'};

% 2 shape name
shapeS = {'shapeS-majorAxis';'shapeS-minorAxis';'shapeS-leastAxis';'shapeS-flatness';'shapeS-elongation'...
    ;'shapeS-max3dDiameter';'shapeS-max2dDiameterAxialPlane';'shapeS-max2dDiameterSagittalPlane'...
    ;'shapeS-max2dDiameterCoronalPlane';'shapeS-surfArea';'shapeS-volume';'shapeS-filledVolume'...
    ;'shapeS-Compactness1';'shapeS-Compactness2';'shapeS-spherDisprop';'shapeS-sphericity';'shapeS-surfToVolRatio'};

% 3 glcm name
glcm = [];
glcm_name1 = {'glcmAvgS','glcmMaxS','glcmMinS','glcmStdS','glcmMadS'};
glcm_name2 = {'energy','jointEntropy','jointMax','jointAvg','jointVar','contrast','invDiffMom','invDiffMomNorm',...
            'invDiff','invDiffNorm','invVar','dissimilarity','diffEntropy','diffVar','diffAvg','sumAvg','sumVar',...
            'sumEntropy','corr','clustTendency','clustShade','clustPromin','haralickCorr','autoCorr','firstInfCorr',...
            'secondInfCorr'};
for i = 1:length(glcm_name1)
    for j = 1:length(glcm_name2)
        glcm_name3 = [char(glcm_name1(i)),'-',char(glcm_name2(j))];
        glcm = [glcm;{glcm_name3}];
    end
end

% 4 glrlm name
rlm = [];
rlm_name1 = {'rlmAvgS','rlmMaxS','rlmMinS','rlmStdS','rlmMadS'};
rlm_name2 = {'gln','glnNorm','glv','hglre','lglre','lre','lrhgle','lrlgle',...
            're','rln','rlnNorm','rlv','rp','sre','srhgle','srlgle'};
for i = 1:length(rlm_name1)
    for j = 1:length(rlm_name2)
        rlm_name3 = [char(rlm_name1(i)),'-',char(rlm_name2(j))];
        rlm = [rlm;{rlm_name3}];
    end
end

% 5 ngtdm name
ngtdmS = {'ngtdmS-coarseness';'ngtdmS-contrast';'ngtdmS-busyness';'ngtdmS-complexity';'ngtdmS-strength'};

% 6 ngldm name
ngldmS ={'ngldmS-lde';'ngldmS-hde';'ngldmS-lgce';'ngldmS-hgce';'ngldmS-ldlge';'ngldmS-ldhge';'ngldmS-hdlge';...
    'ngldmS-hdhge';'ngldmS-gln';'ngldmS-glnNorm';'ngldmS-dcn';'ngldmS-dcnNorm';'ngldmS-dcp';'ngldmS-glv';...
    'ngldmS-dcv';'ngldmS-entropy';'ngldmS-energy'};  % ��װ

% 7 szm name
szmS = {'szmS-sae';'szmS-lae';'szmS-gln';'szmS-glnNorm';'szmS-szn';'szmS-sznNorm';'szmS-zp';...
    'szmS-lglze';'szmS-hglze';'szmS-salgle';'szmS-sahgle';'szmS-lalgle';'szmS-lahgle';'szmS-glv';...
    'szmS-szv';'szmS-ze'} ; %  ��װ

% 8 ivh name
ivhS = {'ivhS-meanHist';'ivhS-maxHist';'ivhS-minHist';'ivhS-I50';'ivhS-rangeHist';...
    'ivhS-Vx0';'ivhS-Vx10';'ivhS-Vx20';'ivhS-Vx50';'ivhS-Vx80';'ivhS-Vx90';...
    'ivhS_Vx95'}; % ��װ

% ��װһ���˲�ͼ���feat name
feat_name_single = [FirstOrder;shapeS;glcm;rlm;ngtdmS;ngldmS;szmS;ivhS];

% ��ϳ��ܵ�feat name 
feat_name = [];
feat_name_single1 = cell(length(feat_name_single),1);
for k = 1: length(filt_name)
    for n = 1:length(feat_name_single)
        feat_name_single1(n) = {[char(filt_name(k)),'-',char(feat_name_single(n))]};
    end
    feat_name = [feat_name;feat_name_single1];
end


%%  ��װ���ŵı�ͷroi������CTʱ��
col_name = [];
for i = 1: length(data_time)
    col1 = [];
    for j = 1: length(roi_name)
        col1 = [col1,data_time(i)];
    end
    col_name1 = [col1;roi_name];
    col_name = [col_name,col_name1];
end
col_name2 = {'CTʱ��';'��������'};   % ��ͷ��2���������
col_name = [col_name2,col_name];


