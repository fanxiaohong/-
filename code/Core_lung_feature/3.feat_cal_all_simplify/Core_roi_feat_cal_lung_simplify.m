clc;
clear all;
t1=clock;
profile on

%% ������������mat�ļ���mat.bz2ѹ�����Ĳ���
file_way = 'E:/roi_feat_dose/' ;
mat_str = [file_way,'plan/'] ;
patient_name = '1.zhouzhengyuan';
paramFileName = [file_way,'json_set/roi_settings.json'];       % ��������ļ�λ��
save_file = [file_way,'result/feature_lung1904201.txt'] ;
save_file_title = [file_way,'result/feature_lung_title.xls'] ;
data_time = {'190611','190619','190824','190830','190910'} ;
name_time = '190505' ;      % �ļ���ȡ������
          
% ����������ò���
paramS = getRadiomicsParamTemplate(paramFileName);  % ��������ļ�λ��

%% ������������ֵ������excel
[feat_matrix_all] = write_data_lung_simplify(data_time,mat_str,patient_name,name_time,paramS);
% % clm_data = ['D',num2str(3)];     % ����������д��excel�ļ�
% % xlswrite(save_file,feat_matrix_all,patient_name,clm_data);
dlmwrite(save_file,feat_matrix_all,'precision','%6.8f');

%% ����ܺ�ʱ
profile viewer
t2=clock;
etime(t2,t1)