clc;
clear all;
t1=clock;
profile on

%% ���CT������������mat�ļ���mat.bz2ѹ�����Ĳ���
mat_str = 'E:\roi_feat_dose\' ;
patient_name = '11.wangziran';
data_time = {'180825','180920','181113','181226','190217'} ;   %   181009
plan_time = {'180725'} ; % �ƻ�ʱ��
num_image = [96,95,111,98,100];         % ���κ����ͼƬ����
num_image_lungSeg = [211,227,253,251,210] ;  % �ηָ�ͼƬ����,321,165
delta_x =  [-8.974,5.822,-2.813,-1.603986497,10.87013817] ;  % ��λmm��x����ƫ��,���κ��ȥ����ǰ��ͨ��3Dslicer���γ��ɼ���õ�,����xdose���-254.426����DCM�ļ������෴
delta_y =  [-33.979,5.319,23.917,-5.122390277,61.90418625] ;  % ��λmm��y����ƫ�ƣ�27.9647����DCM�ļ�һ��
delta_z =  [3.439,16.877,-27.587,-210.4186557,-202.0874329] ;  % ��λmm��y����ƫ�ƣ�-6.1314����DCM�ļ������෴��˳���෴
dose_grid_space = 0.4 ;   % ��������ߴ�
dose_seg = 5 ;          % �����������䣬dose bin
roi_num_start = 15 ;     % ���е�roi����
doseNum = 1;             % �õڼ��ּ�������������Ԫ����7�����������1
seg_linename = 'lung_seg' ; % �ηָ�������
lung_mask = 1 ;          % �ηָ�mask�����ֵ
%% plan������������mat�ļ���mat.bz2ѹ�����Ĳ���
lung_start = 23 ;      % �β�ͼ��ʼslicer,3
lung_end = 77 ;   % �β�ͼ�����slicer,57
plan_dcm_num = 84 ;    % �ƻ�������dcm�ļ���,59
strName = 'lung';        % ������
image_grid_space_xyplan = 0.976563 ;
image_grid_space_zplan = 5 ;
image_size = 512   ;   % ͼƬ��С
image_grid_space_xy = [0.808593988,0.976562977,0.830078006,0.914062977,0.755859017] ;   %��ʱ���ͼ��xy������
image_grid_space_z = [1.25,1.25,1.25,1.25,1.25] ;      %��ʱ���ͼ��z������
roi_empty = 13 ;  % ����roi�ÿ�

%% ѭ������һ�����˵ļ���ʱ����mat�ļ�
for p = 4 %: length(data_time)
    % ��������ʱ����line������mat�ļ�
    [planC,save_file] = mat_renew(mat_str,patient_name,data_time(p),num_image(p),num_image_lungSeg(p),delta_x(p),...
        delta_y(p),delta_z(p),dose_grid_space,dose_seg,roi_num_start,doseNum,seg_linename,lung_mask);
    save(save_file,'planC');   % ������ĺ�����ݵ�mat�ļ���
    %   �����Ӧ����ʱ���plan��line������mat�ļ�
%     [planC,save_file] = mat_renew_plan(mat_str,patient_name,data_time(p),dose_seg,roi_num_start,doseNum,seg_linename,lung_start,...
%         lung_end,plan_dcm_num,num_image_lungSeg(p),lung_mask,strName,dose_grid_space,image_grid_space_xyplan,image_grid_space_xy(p),...
%         image_grid_space_z(p),image_grid_space_zplan,image_size,plan_time,roi_empty);
%     save(save_file,'planC');   % ������ĺ�����ݵ�mat�ļ���
end
close;

%% �����ܵ�����ʱ��
profile viewer
t2=clock;
etime(t2,t1)
