clc;
clear all;
t1=clock;
profile on

%% 诊断CT超参数，读入mat文件，mat.bz2压缩过的不行
mat_str = 'E:\roi_feat_dose\' ;
patient_name = '9.yinyunhua';
data_time = {'180820','180920','181210','190221','190422','190713','191014'} ;   %   181009
plan_time = {'180706'} ; % 计划时间
num_image = [90,90,90,89,98,97,91];         % 变形后剂量图片数量
num_image_lungSeg = [173,185,176,177,187,202,178] ;  % 肺分割图片数量,321,165
delta_x =  [-4.354,-19.108,27.5,-1.602689128,-14.69483852,-19.403,-17.994] ;  % 单位mm，x方向偏移,变形后减去变形前，通过3Dslicer变形场可计算得到,程序xdose起点-254.426，与DCM文件符号相反
delta_y =  [-10.992,-17.709,-34.208,12.42359352,5.465054989,-18.435,-12.237] ;  % 单位mm，y方向偏移，27.9647，与DCM文件一致
delta_z =  [26.101,36.467,-9.683,-17.86162264,-39.90619231,4.871,24.925] ;  % 单位mm，y方向偏移，-6.1314，与DCM文件符号相反，顺序相反
dose_grid_space = 0.4 ;   % 剂量网格尺寸
dose_seg = 5 ;          % 剂量划分区间，dose bin
roi_num_start = 19 ;     % 已有的roi数量
doseNum = 7;             % 用第几种剂量方案，周正元方案7，胡红军方案1
seg_linename = 'lung_seg' ; % 肺分割线名称
lung_mask = 1 ;          % 肺分割mask区域的值
%% plan超参数，读入mat文件，mat.bz2压缩过的不行
lung_start = 4 ;      % 肺部图像开始slicer
lung_end = 46 ;   % 肺部图像结束slicer
plan_dcm_num = 51 ;    % 计划保留的dcm文件数
strName = 'lung';        % 肺名称
image_grid_space_xyplan = 0.976562 ;
image_grid_space_zplan = 5 ;
image_size = 512   ;   % 图片大小
image_grid_space_xy = [0.703125,0.828125,0.767578006,0.736328006,0.769531012,0.748046994,0.730468988] ;   %各时间点图像xy方向间隔
image_grid_space_z = [1.25,1.25,1.25,1.249994318,1.25,1.25,1.25] ;      %各时间点图像z方向间隔
roi_empty = 10 ;  % 多余roi置空

%% 循环计算一个病人的几个时间点的mat文件
for p = 7 : length(data_time)
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
