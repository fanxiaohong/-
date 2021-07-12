clc;
clear all;
t1=clock;
profile on

%% 超参数，读入mat文件，mat.bz2压缩过的不行
mat_str = 'E:\roi_feat_dose\plan\' ;
patient_name = '1.zhouzhengyuan';
paramFileName = 'E:/roi_feat_dose/json_set/roi_settings.json';       % 定义参数文件位置
save_file = 'E:/roi_feat_dose/result/feature_lung.xls' ;
roi_name = {'lung_seg','dose0_5','dose5_10','dose10_15','dose15_20','dose20_25','dose25_30','dose30_35','dose35_40',...
    'dose40_45','dose45_50','dose50_55','dose55_60','dose60_65'};
% roi_name = {'dose60_65'};
% filt_name = {'Original'};
filt_name = {'Original','Wavelets_Coif1__HHH','Sobel','Gabor_radius3_sigma0_5_AR1_30_deg_wavelength1'};
data_time = {'190420','190611','190619','190824','190830','190910'} ;
% data_time = {'190420'} ;
name_time = '190505' ;      % 文件读取的设置
save_file_temp = 'E:/roi_feat_dose/result/feature_lung_temp.xls' ;   % 临时存放数据的文件，会删除
          
% 载入参数设置参数
paramS = getRadiomicsParamTemplate(paramFileName);  % 定义参数文件位置
len = size(roi_name);
roi_num = len(2);

%% 循环计算各个时间点纹理特征值并保存
feat_matrix_all = [] ;
for p = 1 : length(data_time)
    filename_after = [mat_str,patient_name,'\',char(data_time(p)),'\planC',char(data_time(p)),'_roi.mat'];    % plan计划配准后
    filename_plan = [mat_str,patient_name,'\',char(data_time(p)),'\planC',name_time,'_roi.mat'];    % plan计划配准后
    % 计算全部纹理特征值
    [featS_after] = feat_cal(filename_after,paramS,roi_name);  % 计算治疗后特征值
    [featS_plan] = feat_cal(filename_plan,paramS,roi_name);
    % 把计算得出的feat结构体写入excel文件
    [feat_matrix] = write_data(featS_after,featS_plan,filt_name,roi_name,save_file_temp);
    feat_matrix_all = [feat_matrix_all,feat_matrix] ;
    clm_data = ['D',num2str(3)];     % 把特征名称写入excel文件
    xlswrite(save_file,feat_matrix_all,patient_name,clm_data);
end

%% 输出表头并保存
p = 1;  
[feat_name,col_name] = write_file(featS_after,filt_name,roi_name,data_time);     % 把表头写入excel文件

%% 把特征数据写入excel文件中转一下，因为无法操作cell做运算
clm_txt = ['A',num2str(3)];     % 把特征名称写入excel文件
xlswrite(save_file,feat_name,patient_name,clm_txt);
clm_txt2 = ['A',num2str(1)];     % 把特征名称写入excel文件
xlswrite(save_file,col_name,patient_name,clm_txt2);

%% 输出总耗时
profile viewer
t2=clock;
etime(t2,t1)