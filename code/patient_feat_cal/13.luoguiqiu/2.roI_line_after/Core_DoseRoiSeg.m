clc;
clear all;
t1=clock;
profile on

%% ���CT������������mat�ļ���mat.bz2ѹ�����Ĳ���
mat_str = 'E:\roi_feat_dose\' ;
patient_name = '13.luoguiqiu';
data_time = {'180920','181012','181205','190217','190423','190617','190718','190809'} ;   %   181009
plan_time = {'180726'} ; % �ƻ�ʱ��
num_image = [98,91,95,97,97,96,104,98];         % ���κ����ͼƬ����
num_image_lungSeg = [231,207,209,231,224,231,212,247] ;  % �ηָ�ͼƬ����,321,165
delta_x =  [3.375167039,6.902,-4.705,-8.469,-5.421,2.391,6.248,-0.534] ;  % ��λmm��x����ƫ��,���κ��ȥ����ǰ��ͨ��3Dslicer���γ��ɼ���õ�,����xdose���-254.426����DCM�ļ������෴
delta_y =  [4.119741596,4.929,-15.597,-30.636,3.831,-31.711,-9.959,-40.052] ;  % ��λmm��y����ƫ�ƣ�27.9647����DCM�ļ�һ��
delta_z =  [-27.0983509,-16.116,-10.779,-31.443,-55.284,-4.418,-3.978,-209.809] ;  % ��λmm��y����ƫ�ƣ�-6.1314����DCM�ļ������෴��˳���෴
dose_grid_space = 0.4 ;   % ��������ߴ�
dose_seg = 5 ;          % �����������䣬dose bin
doseNum = 7;             % �õڼ��ּ�������������Ԫ����7�����������1
seg_linename = 'lung_seg' ; % �ηָ�������
lung_mask = 1 ;          % �ηָ�mask�����ֵ
%% plan������������mat�ļ���mat.bz2ѹ�����Ĳ���
lung_start = 5 ;      % �β�ͼ��ʼslicer
lung_end = 52 ;   % �β�ͼ�����slicer
plan_dcm_num = 57 ;    % �ƻ�������dcm�ļ���
strName = 'lung0';        % ������
image_grid_space_xyplan = 0.976563 ;
image_grid_space_zplan = 5 ;
image_size = 512   ;   % ͼƬ��С
image_grid_space_xy = [0.857421994,0.976562977,0.902343988,0.839843988,0.886718988,0.783203006,0.753906012,0.835937977] ;   %��ʱ���ͼ��xy������
image_grid_space_z = [1.25,1.25,1.25,1.25,1.160313901,1.25,1.25,1.25] ;      %��ʱ���ͼ��z������

%% ѭ������һ�����˵ļ���ʱ����mat�ļ�
for p = 1: length(data_time)
    % ��������ʱ����line������mat�ļ�
    [planC,save_file] = mat_renew(mat_str,patient_name,data_time(p),num_image(p),num_image_lungSeg(p),delta_x(p),...
        delta_y(p),delta_z(p),dose_grid_space,dose_seg,doseNum,seg_linename,lung_mask);
    save(save_file,'planC');   % ������ĺ�����ݵ�mat�ļ���
    % �����Ӧ����ʱ���plan��line������mat�ļ�
    [planC,save_file] = mat_renew_plan(mat_str,patient_name,data_time(p),dose_seg,doseNum,seg_linename,lung_start,...
        lung_end,plan_dcm_num,num_image_lungSeg(p),lung_mask,strName,dose_grid_space,image_grid_space_xyplan,image_grid_space_xy(p),...
        image_grid_space_z(p),image_grid_space_zplan,image_size,plan_time);
    save(save_file,'planC');   % ������ĺ�����ݵ�mat�ļ���
end
close;

%% �����ܵ�����ʱ��
profile viewer
t2=clock;
etime(t2,t1)
