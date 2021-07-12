clc;
clear all;
tic

%% ���CT������������mat�ļ���mat.bz2ѹ�����Ĳ���
mat_str = 'E:\roi_feat_dose\' ;
patient_name = '1.zhouzhengyuan';
data_time = {'190420','190611','190619','190824','190830','190910'} ;
plan_time = {'190505'} ; % �ƻ�ʱ��
num_image = [103,107,110,101,108,110];         % ���κ����ͼƬ����
num_image_lungSeg = [220,251,269,216,269,263] ;  % �ηָ�ͼƬ����
delta_x =  [14.863,5.044,13.444,30.42648888,23.6868,10.093] ;  % ��λmm��x����ƫ��,���κ��ȥ����ǰ��ͨ��3Dslicer���γ��ɼ���õ�,����xdose���-254.426����DCM�ļ������෴
delta_y =  [-41.404,-178.82,-17.583,-38.86192322,-1.5314,-20.575] ;  % ��λmm��y����ƫ�ƣ�27.9647����DCM�ļ�һ��
delta_z =  [158.384,-582.527,-629.191,-185.4846497,-617.9028,-645.117] ;  % ��λmm��y����ƫ�ƣ�-6.1314����DCM�ļ������෴��˳���෴
dose_grid_space = 0.4 ;   % ��������ߴ�
dose_seg = 5 ;          % �����������䣬dose bin
roi_num_start = 19 ;     % ���е�roi����
doseNum = 7;             % �õڼ��ּ�������������Ԫ����7�����������1
seg_linename = 'lung_seg' ; % �ηָ�������
lung_mask = 1 ;          % �ηָ�mask�����ֵ
%% plan������������mat�ļ���mat.bz2ѹ�����Ĳ���
lung_start = 2 ;      % �β�ͼ��ʼslicer
lung_end = 45 ;   % �β�ͼ�����slicer
plan_dcm_num = 46 ;    % �ƻ�������dcm�ļ���
strName = 'lung';        % ������
image_grid_space_xyplan = 0.976563 ;
image_grid_space_zplan = 5 ;
image_size = 512   ;   % ͼƬ��С
image_grid_space_xy = [0.824218988 ,0.755859375 ,0.7734379768 ,0.767578006,0.865234017 ,0.763671994] ;   %��ʱ���ͼ��xy������
image_grid_space_z = [1.25 ,1 ,1 ,1.25,1 ,1] ;      %��ʱ���ͼ��z������
roi_empty = 14 ;  % ����roi�ÿ�

%% ѭ������һ�����˵ļ���ʱ����mat�ļ�
for p = 1 :1% length(data_time)
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