function [featS] = feat_cal(filename,paramS,roi_name);
% ����ȫ����������ֵ

%% ����mat�ļ���planC
m = matfile(filename);
global planC 
planC = m.planC;

%% plan�е�����
indexS = planC{end};        % plan�е�����
strC = {planC{indexS.structures}.structureName};    % ����plan��structure��λ�õõ�����λ�ñ������

%% ѭ�����㼸��roi
len = size(roi_name);
roi_num = len(2);
for n = 1:roi_num
    structNum = getMatchingIndex(paramS.structuresC{n},strC,'exact');    % ���ݲ��������ļ��õ�ROI������
    scanNum = getStructureAssociatedScan(structNum,planC);
    eval(['featS.',char(roi_name(n)),'=' 'calcGlobalRadiomicsFeatures(scanNum, structNum, paramS, planC);']);   % �������е���������
end