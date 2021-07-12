clc;
clear all;
tic

%% ���CT������������mat�ļ���mat.bz2ѹ�����Ĳ���
mat_str = 'E:\roi_feat_dose\' ;
patient_name = '2.huhongjun';
data_time = {'180926','181105','181120','190102','190130','190216','190330','190611'} ;  % �����CTʱ��
plan_time = {'181010'} ; % �ƻ�ʱ��
num_image = [117,117,118,117,123,118,121,121];         % ���κ����ͼƬ����
num_image_lungSeg = [253,207,219,228,273,217,233,215] ;  % �ηָ�ͼƬ����
delta_x =  [20.1971283,58.339,6.951,12.7730646,-22.33236313,27.183,19.628,13.71530533] ;  % ��λmm��x����ƫ��,���κ��ȥ����ǰ��ͨ��3Dslicer���γ��ɼ���õ�,����xdose���-254.426����DCM�ļ������෴
delta_y =  [8.109930038,119.997,0.747,7.2760706,-142.160614,-5.682,11.882,-42.08330536] ;  % ��λmm��y����ƫ�ƣ�27.9647����DCM�ļ�һ��
delta_z =  [-46.13620758,-91.297,-30.076,-54.9469833,-618.4110014,-213.072,-43.155,-247.1460266] ;  % ��λmm��y����ƫ�ƣ�-6.1314����DCM�ļ������෴��˳���෴
dose_grid_space = 0.4 ;   % ��������ߴ�
dose_seg = 5 ;          % �����������䣬dose bin
roi_num_start = 19 ;     % ���е�roi����
doseNum = 1;             % �õڼ��ּ�������������Ԫ����7�����������1
seg_linename = 'lung_seg' ; % �ηָ�������
lung_mask = 1 ;          % �ηָ�mask�����ֵ
%% plan������������mat�ļ���mat.bz2ѹ�����Ĳ���
lung_start = 2 ;      % �β�ͼ��ʼslicer
lung_end = 55 ;   % �β�ͼ�����slicer
plan_dcm_num = 56 ;    % �ƻ�������dcm�ļ���
strName = 'lung';        % ������
image_grid_space_xyplan = 0.763672 ;
image_grid_space_zplan = 5 ;
image_size = 512   ;   % ͼƬ��С
image_grid_space_xy = [0.798828006,0.955078006,0.826171994,0.845703006,0.775390625,0.841796994,0.833984017,0.826171994,] ;   %��ʱ���ͼ��xy������
image_grid_space_z = [1.25,1.25,1.25,1.25,1,1.25,1.25,1.25] ;      %��ʱ���ͼ��z������
roi_empty = 14 ;  % ����roi�ÿ�

%% ѭ������һ�����˵ļ���ʱ����mat�ļ�
for p = 1 : length(data_time)
    % ��������ʱ����line������mat�ļ�
    [planC,save_file] = mat_renew(mat_str,patient_name,data_time(p),num_image(p),num_image_lungSeg(p),delta_x(p),...
        delta_y(p),delta_z(p),dose_grid_space,dose_seg,roi_num_start,doseNum,seg_linename,lung_mask);
    save(save_file,'planC');   % ������ĺ�����ݵ�mat�ļ���
    % �����Ӧ����ʱ���plan��line������mat�ļ�
    [planC,save_file] = mat_renew_plan(mat_str,patient_name,data_time(p),dose_seg,roi_num_start,doseNum,seg_linename,lung_start,...
        lung_end,plan_dcm_num,num_image_lungSeg(p),lung_mask,strName,dose_grid_space,image_grid_space_xyplan,image_grid_space_xy(p),...
        image_grid_space_z(p),image_grid_space_zplan,image_size,plan_time,roi_empty);
    save(save_file,'planC');   % ������ĺ�����ݵ�mat�ļ���
end

%% �����ܵ�����ʱ��
toc