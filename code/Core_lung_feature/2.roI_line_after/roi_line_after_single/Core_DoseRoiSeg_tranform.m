clc;
clear all;
t1=clock;

%% ������������mat�ļ���mat.bz2ѹ�����Ĳ���
mat_str = 'E:\roi_feat_dose\plan\' ;
patient_name = 'zhouzhengyuan\';
data_time = '190611\' ;
filename = [mat_str,patient_name,data_time,'planC190611_line'];    % plan�ƻ���׼��
save_file = [filename,'_line'];          % �����ļ�
str_tranformDose = 'E:\roi_feat_dose\data\zhouzhengyuan\register_plan_to_0619\dose_transform\';   % �ƻ������������γ��������λ��
str_lungSeg = 'E:\roi_feat_dose\data\zhouzhengyuan\segment_0619\label_creat\'; % �β��ָ�ͼƬ���λ��
dose_seg = 5 ;          % �����������䣬dose bin
roi_num_start = 19 ;     % ���е�roi����
doseNum = 7;             % �õڼ��ּ�������������Ԫ����7�����������1
num_image = 110;         % ���κ����ͼƬ����
seg_linename = 'lung_seg' ; % �ηָ�������
num_image_lungSeg = 269;  % �ηָ�ͼƬ����
lung_mask = 1 ;          % �ηָ�mask�����ֵ
delta_x =  13.444 ;  % ��λmm��x����ƫ��,���κ��ȥ����ǰ��ͨ��3Dslicer���γ��ɼ���õ�,����xdose���-254.426����DCM�ļ������෴
delta_y =  -17.583 ;  % ��λmm��y����ƫ�ƣ�27.9647����DCM�ļ�һ��
delta_z =  -629.191 ;  % ��λmm��y����ƫ�ƣ�-6.1314����DCM�ļ������෴��˳���෴
dose_grid_space = 0.4 ;


% ����mat�ļ���planC
m = matfile(filename);
global planC 
planC = m.planC;
indexS = planC{end};        % plan�е�����

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
structNum = roi_num_start+1;
[lungRoiArray] = lung_roi_restruct(planC,structNum,num_image_lungSeg,str_lungSeg,lung_mask,seg_linename);
planC{1,4}(1) = lungRoiArray;            % ���ǵ�һ����ȥ�������roi��
planC{1,4}(1).roiNumber = 1; 
% դ�񻯵ȼ����ߣ�����CERR��gui����ROI֮�䲻�ܲ�������
[segmentsM] = doseRoiRasterSeg(1,planC);
planC{indexS.structures}(1).rasterSegments = segmentsM;
for i = 3:10
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
    % դ�񻯵ȼ����ߣ�����CERR��gui����ROI֮�䲻�ܲ�������
    [segmentsM] = doseRoiRasterSeg(structNum,planC);
    planC{indexS.structures}(structNum).rasterSegments = segmentsM;
    i0 =i0+1;
end

% ������ĺ�����ݵ�mat�ļ���
save(save_file,'planC');   % ������ĺ�����ݵ�mat�ļ���


%% �����ܵ�����ʱ��
t2=clock;
etime(t2,t1)