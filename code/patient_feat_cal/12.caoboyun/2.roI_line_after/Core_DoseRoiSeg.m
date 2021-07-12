clc;
clear all;
t1=clock;
profile on

%% 诊断CT超参数，读入mat文件，mat.bz2压缩过的不行
mat_str = 'E:\roi_feat_dose\' ;
patient_name = '12.caoboyun';
data_time = {'180807','180929','181206','190129','190324','190514','190612'} ;   %   181009
plan_time = {'180725'} ; % 计划时间
num_image = [119,111,113,115,114,114,114];         % 变形后剂量图片数量
num_image_lungSeg = [307,242,225,243,249,234,247] ;  % 肺分割图片数量,321,165
delta_x =  [12.014,-24.66554016,28.999,-2.666,-6.602,18.326,-7.39722] ;  % 单位mm，x方向偏移,变形后减去变形前，通过3Dslicer变形场可计算得到,程序xdose起点-254.426，与DCM文件符号相反
delta_y =  [-135.722,-1.62262562,12.591,21.45,8.295,-0.575,-5.07271] ;  % 单位mm，y方向偏移，27.9647，与DCM文件一致
delta_z =  [-551.167,-20.65546367,-2.179,-19.055,14.536,32.177,-1.20751] ;  % 单位mm，y方向偏移，-6.1314，与DCM文件符号相反，顺序相反
dose_grid_space = 0.4 ;   % 剂量网格尺寸
dose_seg = 5 ;          % 剂量划分区间，dose bin
roi_num_start = 19 ;     % 已有的roi数量
doseNum = 1;             % 用第几种剂量方案，周正元方案7，胡红军方案1
seg_linename = 'lung_seg' ; % 肺分割线名称
lung_mask = 1 ;          % 肺分割mask区域的值
%% plan超参数，读入mat文件，mat.bz2压缩过的不行
lung_start = 2 ;      % 肺部图像开始slicer
lung_end = 54 ;   % 肺部图像结束slicer
plan_dcm_num = 56 ;    % 计划保留的dcm文件数
strName = 'lung000';        % 肺名称
image_grid_space_xyplan = 0.976563 ;
image_grid_space_zplan = 5 ;
image_size = 512   ;   % 图片大小
image_grid_space_xy = [0.755859375,0.916015983,0.947265983,0.783203006,0.773437977,0.916015983,0.828125] ;   %各时间点图像xy方向间隔
image_grid_space_z = [1,1.25,1.25,1.25,1.25,1.25,1.25] ;      %各时间点图像z方向间隔
roi_empty = 10 ;  % 多余roi置空

%% 循环计算一个病人的几个时间点的mat文件
for p = 1: length(data_time)
    % 计算治疗时间点的line并存入mat文件
    [planC,save_file] = mat_renew(mat_str,patient_name,data_time(p),num_image(p),num_image_lungSeg(p),delta_x(p),...
        delta_y(p),delta_z(p),dose_grid_space,dose_seg,roi_num_start,doseNum,seg_linename,lung_mask);
    save(save_file,'planC');   % 保存更改后的数据到mat文件中
    % 计算对应治疗时间点plan的line并存入mat文件
    [planC,save_file] = mat_renew_plan(mat_str,patient_name,data_time(p),dose_seg,roi_num_start,doseNum,seg_linename,lung_start,...
        lung_end,plan_dcm_num,num_image_lungSeg(p),lung_mask,strName,dose_grid_space,image_grid_space_xyplan,image_grid_space_xy(p),...
        image_grid_space_z(p),image_grid_space_zplan,image_size,plan_time,roi_empty);
    save(save_file,'planC');   % 保存更改后的数据到mat文件中
end
close;

%% 计算总的运行时间
profile viewer
t2=clock;
etime(t2,t1)
