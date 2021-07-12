function [planC,save_file,image_grid_space_xy,image_grid_space_z] = mat_renew_simplify(mat_str,patient_name,data_time,delta_x,delta_y,...
    delta_z,dose_grid_space,dose_seg,doseNum,seg_linename,lung_mask,plan_time);
% ��lung_seg�ͼ�����д��mat�ļ�

%% ·�����Ƹ�ֵ
filename = [mat_str,'plan\',patient_name,'\',char(data_time),'\planC',char(data_time)];    % plan�ƻ���׼��
str_tranformDose = [mat_str,'data\',patient_name,'\register\register_plan_to_',char(data_time),'\dose_transform\'];   % �ƻ������������γ��������λ��
str_lungSeg = [mat_str,'data\',patient_name,'\segment\segment_',char(data_time),'\label_creat\']; % �β��ָ�ͼƬ���λ��
save_file = [filename,'_line'];          % �����ļ�����
num_image = length(dir([str_tranformDose,'*.dcm']));   % ��ȡĿ���ļ����±��κ�dose�ļ�������
num_image_lungSeg = length(dir([str_lungSeg,'*.bmp']));   % ��ȡĿ���ļ�����ͼƬlabel�ļ�������

% ����mat�ļ���planC
m = matfile(filename);
global planC 
planC = m.planC;
indexS = planC{end};        % plan�е�����
% ��������
scanNum = 1;
scan3M = getScanArray(scanNum,planC); 
[xScanVals, yScanVals, zScanVals] = getScanXYZVals(planC{indexS.scan}(scanNum));
image_grid_space_xy = double(abs(xScanVals(2)-xScanVals(1)))*10;   % x,y���
image_grid_space_z = abs(zScanVals(2)-zScanVals(1))*10;   % x,y���

% ѭ���������м�����
planC{indexS.dose}(doseNum);    % ����ȫ�ּ������ֵ��ȷ��������������
doseArray = planC{indexS.dose}(doseNum).doseArray;    %method2
dose_max = max(max(max(doseArray)));
dose_slicer = fix(dose_max/dose_seg);

% ��׼���ȡ����dcm�ļ��ع�������
[doseArray_after,dose_space,X_after,Y_after,Z_after] = dose_transform_restruct(planC,doseNum,num_image,...
    str_tranformDose,delta_x,delta_y,delta_z,dose_grid_space);
% ���������ͼ��
planC{indexS.dose}(doseNum) = dose_space ;

% ��ȡ�ָ���ͼƬ�ļ��ع�lung_roi
structNum_empty = length(planC{1,4});   % �Ѻ�����roi��ɾ��
structNum = structNum_empty+1;
[lungRoiArray] = lung_roi_restruct(planC,structNum,num_image_lungSeg,str_lungSeg,lung_mask,seg_linename);
planC{1,4}(1) = lungRoiArray;            % ���ǵ�һ����ȥ�������roi��
planC{1,4}(1).roiNumber = 1; 
% դ�񻯵ȼ����ߣ�����CERR��gui����ROI֮�䲻�ܲ�������
[segmentsM] = doseRoiRasterSeg(1,planC);
planC{indexS.structures}(1).rasterSegments = segmentsM;
for i = 3:(structNum_empty-9)   % �������գ�����ֲ�����ʾ�Ĵ���
    planC{1,4}(i) = [];            % ȥ�������roi��
end

% �Ѽ�����д��mat�ļ�
i0 = 1;
while i0 < dose_slicer+1
    dose_value = dose_seg*i0 ;
    structNum = i0+1;
    % ����ȼ����߲�������mat�ļ�
    [dose_line] = doseLineSeg_transform(planC,dose_value,structNum,doseArray_after,X_after,Y_after,Z_after);
    planC{indexS.structures}(structNum) = dose_line;
    % ���������
    if structNum>2
        [planC] = dose_line_clear_simplify(planC,structNum);
    end
    % դ�񻯵ȼ����ߣ�����CERR��gui����ROI֮�䲻�ܲ�������
    [segmentsM] = doseRoiRasterSeg(structNum,planC);
    planC{indexS.structures}(structNum).rasterSegments = segmentsM;
    i0 =i0+1;
end


