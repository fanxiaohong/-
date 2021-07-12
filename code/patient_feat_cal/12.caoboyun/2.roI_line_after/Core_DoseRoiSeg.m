clc;
clear all;
t1=clock;
profile on

%% ���CT������������mat�ļ���mat.bz2ѹ�����Ĳ���
mat_str = 'E:\roi_feat_dose\' ;
patient_name = '12.caoboyun';
data_time = {'180807','180929','181206','190129','190324','190514','190612'} ;   %   181009
plan_time = {'180725'} ; % �ƻ�ʱ��
num_image = [119,111,113,115,114,114,114];         % ���κ����ͼƬ����
num_image_lungSeg = [307,242,225,243,249,234,247] ;  % �ηָ�ͼƬ����,321,165
delta_x =  [12.014,-24.66554016,28.999,-2.666,-6.602,18.326,-7.39722] ;  % ��λmm��x����ƫ��,���κ��ȥ����ǰ��ͨ��3Dslicer���γ��ɼ���õ�,����xdose���-254.426����DCM�ļ������෴
delta_y =  [-135.722,-1.62262562,12.591,21.45,8.295,-0.575,-5.07271] ;  % ��λmm��y����ƫ�ƣ�27.9647����DCM�ļ�һ��
delta_z =  [-551.167,-20.65546367,-2.179,-19.055,14.536,32.177,-1.20751] ;  % ��λmm��y����ƫ�ƣ�-6.1314����DCM�ļ������෴��˳���෴
dose_grid_space = 0.4 ;   % ��������ߴ�
dose_seg = 5 ;          % �����������䣬dose bin
roi_num_start = 19 ;     % ���е�roi����
doseNum = 1;             % �õڼ��ּ�������������Ԫ����7�����������1
seg_linename = 'lung_seg' ; % �ηָ�������
lung_mask = 1 ;          % �ηָ�mask�����ֵ
%% plan������������mat�ļ���mat.bz2ѹ�����Ĳ���
lung_start = 2 ;      % �β�ͼ��ʼslicer
lung_end = 54 ;   % �β�ͼ�����slicer
plan_dcm_num = 56 ;    % �ƻ�������dcm�ļ���
strName = 'lung000';        % ������
image_grid_space_xyplan = 0.976563 ;
image_grid_space_zplan = 5 ;
image_size = 512   ;   % ͼƬ��С
image_grid_space_xy = [0.755859375,0.916015983,0.947265983,0.783203006,0.773437977,0.916015983,0.828125] ;   %��ʱ���ͼ��xy������
image_grid_space_z = [1,1.25,1.25,1.25,1.25,1.25,1.25] ;      %��ʱ���ͼ��z������
roi_empty = 10 ;  % ����roi�ÿ�

%% ѭ������һ�����˵ļ���ʱ����mat�ļ�
for p = 1: length(data_time)
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
close;

%% �����ܵ�����ʱ��
profile viewer
t2=clock;
etime(t2,t1)
