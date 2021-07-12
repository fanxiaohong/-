clc;
clear all;
profile on
t1=clock;

%% 超参数，读入mat文件，mat.bz2压缩过的不行
file_way = 'E:/roi_feat_dose/' ;
mat_str = [file_way,'plan/'] ;
patient_name = '7.xiangzhilin';
paramFileName = [file_way,'json_set/roi_settings.json'];       % 定义参数文件位置
save_file = [file_way,'result/feature_lung_7xiang_lung_silk_health.txt'] ;
% roi_name = {'lung_seg','dose0_5','dose5_10','dose10_15','dose15_20','dose20_25','dose25_35','dose35_45','dose45_55','dose55_65'};
filt_name = {'Original','Wavelets_Coif1__HHH','Sobel','Gabor_radius3_sigma0_5_AR1_30_deg_wavelength1'};
roi_name = {'lung_silk','lung_health'} ;
% filt_name = {'Original'};
data_time = {'181009'} ;
name_time = '180725' ;      % 文件读取的设置
          
% 载入参数设置参数
paramS = getRadiomicsParamTemplate(paramFileName);  % 定义参数文件位置
len = size(roi_name);
roi_num = len(2);

%% 计算纹理特征值并存入excel
[feat_matrix_all] = write_data_lung(data_time,mat_str,patient_name,roi_name,name_time,paramS);
% clm_data = ['D',num2str(3)];     % 把特征名称写入excel文件
% xlswrite(save_file,feat_matrix_all,patient_name,clm_data);
dlmwrite(save_file,feat_matrix_all,'precision','%6.8f');

%% 输出表头并保存
% [feat_name,col_name] = feat_title_lung(roi_name,data_time,filt_name);

%% 输出总耗时
profile viewer
t2=clock;
etime(t2,t1)