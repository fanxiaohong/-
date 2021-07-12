clc;
clear all;
t1=clock;
profile on

%% ������������mat�ļ���mat.bz2ѹ�����Ĳ���
mat_str = 'E:\roi_feat_dose\plan\' ;
patient_name = '1.zhouzhengyuan';
paramFileName = 'E:/roi_feat_dose/json_set/roi_settings.json';       % ��������ļ�λ��
save_file = 'E:/roi_feat_dose/result/feature_lung.xls' ;
roi_name = {'lung_seg','dose0_5','dose5_10','dose10_15','dose15_20','dose20_25','dose25_30','dose30_35','dose35_40',...
    'dose40_45','dose45_50','dose50_55','dose55_60','dose60_65'};
% roi_name = {'dose60_65'};
% filt_name = {'Original'};
filt_name = {'Original','Wavelets_Coif1__HHH','Sobel','Gabor_radius3_sigma0_5_AR1_30_deg_wavelength1'};
data_time = {'190420','190611','190619','190824','190830','190910'} ;
% data_time = {'190420'} ;
name_time = '190505' ;      % �ļ���ȡ������
save_file_temp = 'E:/roi_feat_dose/result/feature_lung_temp.xls' ;   % ��ʱ������ݵ��ļ�����ɾ��
          
% ����������ò���
paramS = getRadiomicsParamTemplate(paramFileName);  % ��������ļ�λ��
len = size(roi_name);
roi_num = len(2);

%% ѭ���������ʱ�����������ֵ������
feat_matrix_all = [] ;
for p = 1 : length(data_time)
    filename_after = [mat_str,patient_name,'\',char(data_time(p)),'\planC',char(data_time(p)),'_roi.mat'];    % plan�ƻ���׼��
    filename_plan = [mat_str,patient_name,'\',char(data_time(p)),'\planC',name_time,'_roi.mat'];    % plan�ƻ���׼��
    % ����ȫ����������ֵ
    [featS_after] = feat_cal(filename_after,paramS,roi_name);  % �������ƺ�����ֵ
    [featS_plan] = feat_cal(filename_plan,paramS,roi_name);
    % �Ѽ���ó���feat�ṹ��д��excel�ļ�
    [feat_matrix] = write_data(featS_after,featS_plan,filt_name,roi_name,save_file_temp);
    feat_matrix_all = [feat_matrix_all,feat_matrix] ;
    clm_data = ['D',num2str(3)];     % ����������д��excel�ļ�
    xlswrite(save_file,feat_matrix_all,patient_name,clm_data);
end

%% �����ͷ������
p = 1;  
[feat_name,col_name] = write_file(featS_after,filt_name,roi_name,data_time);     % �ѱ�ͷд��excel�ļ�

%% ����������д��excel�ļ���תһ�£���Ϊ�޷�����cell������
clm_txt = ['A',num2str(3)];     % ����������д��excel�ļ�
xlswrite(save_file,feat_name,patient_name,clm_txt);
clm_txt2 = ['A',num2str(1)];     % ����������д��excel�ļ�
xlswrite(save_file,col_name,patient_name,clm_txt2);

%% ����ܺ�ʱ
profile viewer
t2=clock;
etime(t2,t1)