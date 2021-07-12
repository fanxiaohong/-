clc;
clear all;
t1=clock;
profile on

%% ���CT������������mat�ļ���mat.bz2ѹ�����Ĳ���
mat_str = 'E:\roi_feat_dose\' ;
patient_name = '9.yinyunhua';
data_time = {'180820','180920','181210','190221','190422','190713','191014'} ;   %   181009
plan_time = {'180706'} ; % �ƻ�ʱ��
num_image = [90,90,90,89,98,97,91];         % ���κ����ͼƬ����
num_image_lungSeg = [173,185,176,177,187,202,178] ;  % �ηָ�ͼƬ����,321,165
delta_x =  [-4.354,-19.108,27.5,-1.602689128,-14.69483852,-19.403,-17.994] ;  % ��λmm��x����ƫ��,���κ��ȥ����ǰ��ͨ��3Dslicer���γ��ɼ���õ�,����xdose���-254.426����DCM�ļ������෴
delta_y =  [-10.992,-17.709,-34.208,12.42359352,5.465054989,-18.435,-12.237] ;  % ��λmm��y����ƫ�ƣ�27.9647����DCM�ļ�һ��
delta_z =  [26.101,36.467,-9.683,-17.86162264,-39.90619231,4.871,24.925] ;  % ��λmm��y����ƫ�ƣ�-6.1314����DCM�ļ������෴��˳���෴
dose_grid_space = 0.4 ;   % ��������ߴ�
dose_seg = 5 ;          % �����������䣬dose bin
roi_num_start = 19 ;     % ���е�roi����
doseNum = 7;             % �õڼ��ּ�������������Ԫ����7�����������1
seg_linename = 'lung_seg' ; % �ηָ�������
lung_mask = 1 ;          % �ηָ�mask�����ֵ
%% plan������������mat�ļ���mat.bz2ѹ�����Ĳ���
lung_start = 4 ;      % �β�ͼ��ʼslicer
lung_end = 46 ;   % �β�ͼ�����slicer
plan_dcm_num = 51 ;    % �ƻ�������dcm�ļ���
strName = 'lung';        % ������
image_grid_space_xyplan = 0.976562 ;
image_grid_space_zplan = 5 ;
image_size = 512   ;   % ͼƬ��С
image_grid_space_xy = [0.703125,0.828125,0.767578006,0.736328006,0.769531012,0.748046994,0.730468988] ;   %��ʱ���ͼ��xy������
image_grid_space_z = [1.25,1.25,1.25,1.249994318,1.25,1.25,1.25] ;      %��ʱ���ͼ��z������
roi_empty = 10 ;  % ����roi�ÿ�

%% ѭ������һ�����˵ļ���ʱ����mat�ļ�
for p = 7 : length(data_time)
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
