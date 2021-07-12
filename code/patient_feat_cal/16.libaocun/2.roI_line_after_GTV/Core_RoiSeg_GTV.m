clc;
clear all;
t1=clock;
profile on

%% 诊断CT超参数，读入mat文件，mat.bz2压缩过的不行
mat_str = 'E:\roi_feat_dose\' ;
patient_name = '13.luoguiqiu';
data_time = {'180920','181012'} ;
plan_time = {'180726'} ; % 计划时间
num_image = [21,16];         % 变形后GTV图片数量量
num_image_plan = [16];    % 计划的roi的dcm文件数量
roi_x =  [257.381189,260.1036] ;  % 单位mm，x方向偏移,变形后减去变形前，通过3Dslicer变形场可计算得到,程序xdose起点-254.426，与DCM文件符号相反
roi_y =  [253.689199,255.2512] ;  % 单位mm，y方向偏移，27.9647，与DCM文件一致
roi_z =  [-84.867725,-78.4156] ;  % 单位mm，y方向偏移，-6.1314，与DCM文件符号相反，顺序相反
roi_x_plan = 253.271;    % 计划roidcm坐标信息
roi_y_plan = 250 ;
roi_z_plan = -61.599 ;
roi_name = 'GTV'  ;      % roi的名称
lung_mask = 1 ;          % 肺分割mask区域的值
% plan超参数，读入mat文件，mat.bz2压缩过的不行
image_grid_space_xyplan = 0.976563 ;
image_grid_space_zplan = 5 ;

%% 开始计算插入GTV
for p = 1:length(data_time)
    % 计算治疗时间点的插入GTV并存入mat文件
    str_tranform_roi = [mat_str,'data\',patient_name,'\register\register_plan_to_',char(data_time(p)),'\',roi_name,...
        '_transform\'];   % GTV经过变形场处理后存放位置
    filename = [mat_str,'plan\',patient_name,'\',char(data_time(p)),'\planC',char(data_time(p)),'_roi'];    % plan计划配准后
    [planC,save_file] = mat_renew_roi(roi_name,roi_x(p),roi_y(p),roi_z(p),lung_mask,...
        image_grid_space_xyplan,image_grid_space_zplan,num_image(p),str_tranform_roi,filename);
    save(save_file,'planC');   % 保存更改后的数据到mat文件中
    % 计算对应治疗时间点plan插入GTV并存入mat文件
%     str_tranform_roi_plan = [mat_str,'data\',patient_name,'\original\roi_segment\GTV_plan_dcm\'];   % GTV经过变形场处理后存放位置
%     filename_plan = [mat_str,'plan\',patient_name,'\',char(data_time(p)),'\planC',char(plan_time),'_roi'];    % plan计划配准后
%     [planC,save_file] = mat_renew_roi(roi_name,roi_x_plan,roi_y_plan,roi_z_plan,lung_mask,...
%         image_grid_space_xyplan,image_grid_space_zplan,num_image_plan,str_tranform_roi_plan,filename_plan);
%     save(save_file,'planC');   % 保存更改后的数据到mat文件中
end
close all;

%% 计算总的运行时间
profile viewer
t2=clock;
etime(t2,t1)