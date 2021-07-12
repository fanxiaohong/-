clc;
clear all;
tic

%% ���CT������������mat�ļ���mat.bz2ѹ�����Ĳ���
mat_str = 'E:\roi_feat_dose\' ;
patient_name = '3.pengzhenwu';
data_time = {'181008','181218','190102','190308','190610','190621','190827'} ;
plan_time = {'181025'} ; % �ƻ�ʱ��
num_image = [110,106,110,111,117,111,111];         % ���κ����ͼƬ����
num_image_lungSeg = [193,186,195,241,234,196,184] ;  % �ηָ�ͼƬ����
delta_x =  [19.546,28.651,-3.731,38.548,31.277,32.23004696,28.935] ;  % ��λmm��x����ƫ��,���κ��ȥ����ǰ��ͨ��3Dslicer���γ��ɼ���õ�,����xdose���-254.426����DCM�ļ������෴
delta_y =  [-21.579,42.312,25,23.985,44.112,28.22543322,14.152] ;  % ��λmm��y����ƫ�ƣ�27.9647����DCM�ļ�һ��
delta_z =  [27.587,15.329,26.657,-736.3,-750.38,-8.107882131,-146.533] ;  % ��λmm��y����ƫ�ƣ�-6.1314����DCM�ļ������෴��˳���෴
dose_grid_space = 0.4 ;   % ��������ߴ�
dose_seg = 5 ;          % �����������䣬dose bin
roi_num_start = 19 ;     % ���е�roi����
doseNum = 7;             % �õڼ��ּ�������������Ԫ����7�����������1
seg_linename = 'lung_seg' ; % �ηָ�������
lung_mask = 1 ;          % �ηָ�mask�����ֵ
%% plan������������mat�ļ���mat.bz2ѹ�����Ĳ���
lung_start = 3 ;      % �β�ͼ��ʼslicer
lung_end = 49 ;   % �β�ͼ�����slicer
plan_dcm_num = 53 ;    % �ƻ�������dcm�ļ���
strName = 'lung';        % ������
image_grid_space_xyplan = 0.9765625;
image_grid_space_zplan = 4.9999994 ;
image_size = 512   ;   % ͼƬ��С
image_grid_space_xy = [0.927734017,0.78125,0.84375,0.722656012,0.845703006,0.9375,0.833984017] ;   %��ʱ���ͼ��xy������
image_grid_space_z = [1.25,1.25,1.25644,1,1,1.25,1.25] ;      %��ʱ���ͼ��z������
plan_empty = 14 ;

%% ѭ������һ�����˵ļ���ʱ����mat�ļ�
for p = 1 :  length(data_time)
    % ��������ʱ����line������mat�ļ�
    [planC,save_file] = mat_renew(mat_str,patient_name,data_time(p),num_image(p),num_image_lungSeg(p),delta_x(p),...
        delta_y(p),delta_z(p),dose_grid_space,dose_seg,roi_num_start,doseNum,seg_linename,lung_mask);
    save(save_file,'planC');   % ������ĺ�����ݵ�mat�ļ���
    % �����Ӧ����ʱ���plan��line������mat�ļ�
    [planC,save_file] = mat_renew_plan(mat_str,patient_name,data_time(p),dose_seg,roi_num_start,doseNum,seg_linename,lung_start,...
        lung_end,plan_dcm_num,num_image_lungSeg(p),lung_mask,strName,dose_grid_space,image_grid_space_xyplan,image_grid_space_xy(p),...
        image_grid_space_z(p),image_grid_space_zplan,image_size,plan_time,plan_empty);
    save(save_file,'planC');   % ������ĺ�����ݵ�mat�ļ���
end

%% �����ܵ�����ʱ��
toc