%% �����߷ָ��ȡ�ηָ���������
clc;
clear all;
t1=clock;
profile on

%% ���CT������������mat�ļ���mat.bz2ѹ�����Ĳ���
mat_str = 'E:\roi_feat_dose\' ;
patient_name = '17.liuzaiqin';
data_time = {'180607','180702','180714','180803','180827'} ;   %   181009
% data_time = {'180623'} ;   %   181009
plan_time = {'180312'} ; % �ƻ�ʱ��
delta_x =  [7.132,17.0485919,-39.6986198,-19.56868831,-2.091] ;  % ��λmm��x����ƫ��,���κ��ȥ����ǰ��ͨ��3Dslicer���γ��ɼ���õ�,����xdose���-254.426����DCM�ļ������෴
delta_y =  [-22.463,-166.1794256,-33.0633828,-10.58995486,-22.191] ;  % ��λmm��y����ƫ�ƣ�27.9647����DCM�ļ�һ��
delta_z =  [-38.524,-570.339909,-19.6911278,-39.13912076,-12.659] ;  % ��λmm��y����ƫ�ƣ�-6.1314����DCM�ļ������෴��˳���෴
dose_grid_space = 0.4 ;   % ��������ߴ�
dose_seg = 5 ;          % �����������䣬dose bin
doseNum = 7;             % �õڼ��ּ�������������Ԫ����7�����������1
seg_linename = 'lung_seg' ; % �ηָ�������
lung_mask = 1 ;          % �ηָ�mask�����ֵ
%% plan������������mat�ļ���mat.bz2ѹ�����Ĳ���
lung_start = 2 ;      % �β�ͼ��ʼslicer
lung_end = 44 ;   % �β�ͼ�����slicer
strName = 'lung';        % ������
image_size = 512   ;   % ͼƬ��С

%% ѭ������һ�����˵ļ���ʱ����mat�ļ�
for p = 1: length(data_time)
    % ��������ʱ����line������mat�ļ�
    [planC,save_file,image_grid_space_xy,image_grid_space_z] = mat_renew_simplify(mat_str,patient_name,data_time(p),delta_x(p),...
        delta_y(p),delta_z(p),dose_grid_space,dose_seg,doseNum,seg_linename,lung_mask,plan_time);
    save(save_file,'planC');   % ������ĺ�����ݵ�mat�ļ���
    % �����Ӧ����ʱ���plan��line������mat�ļ�
    [planC,save_file] = mat_renew_plan_simplify(mat_str,patient_name,data_time(p),dose_seg,doseNum,seg_linename,lung_start,...
        lung_end,lung_mask,strName,dose_grid_space,image_grid_space_xy,image_grid_space_z,image_size,plan_time);
    save(save_file,'planC');   % ������ĺ�����ݵ�mat�ļ���
end
close;

%% �����ܵ�����ʱ��
profile viewer
t2=clock;
etime(t2,t1)
