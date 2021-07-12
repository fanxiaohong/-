clc;
clear all;
t1=clock;

%% 超参数，读入mat文件，mat.bz2压缩过的不行
mat_str = 'E:\roi_feat_dose\plan\' ;
patient_name = 'zhouzhengyuan\';
data_time = '190611\' ;
filename = [mat_str,patient_name,data_time,'planC190611_line'];    % plan计划配准后
save_file = [filename,'_line'];          % 保存文件
str_tranformDose = 'E:\roi_feat_dose\data\zhouzhengyuan\register_plan_to_0619\dose_transform\';   % 计划剂量经过变形场处理后存放位置
str_lungSeg = 'E:\roi_feat_dose\data\zhouzhengyuan\segment_0619\label_creat\'; % 肺部分割图片存放位置
dose_seg = 5 ;          % 剂量划分区间，dose bin
roi_num_start = 19 ;     % 已有的roi数量
doseNum = 7;             % 用第几种剂量方案，周正元方案7，胡红军方案1
num_image = 110;         % 变形后剂量图片数量
seg_linename = 'lung_seg' ; % 肺分割线名称
num_image_lungSeg = 269;  % 肺分割图片数量
lung_mask = 1 ;          % 肺分割mask区域的值
delta_x =  13.444 ;  % 单位mm，x方向偏移,变形后减去变形前，通过3Dslicer变形场可计算得到,程序xdose起点-254.426，与DCM文件符号相反
delta_y =  -17.583 ;  % 单位mm，y方向偏移，27.9647，与DCM文件一致
delta_z =  -629.191 ;  % 单位mm，y方向偏移，-6.1314，与DCM文件符号相反，顺序相反
dose_grid_space = 0.4 ;


% 载入mat文件，planC
m = matfile(filename);
global planC 
planC = m.planC;
indexS = planC{end};        % plan有的内容

% 循环计算所有剂量线
planC{indexS.dose}(doseNum);    % 计算全局剂量最大值，确定计量划分区间
doseArray = planC{indexS.dose}(doseNum).doseArray;    %method2
dose_max = max(max(max(doseArray)));
dose_slicer = fix(dose_max/dose_seg);

% 配准后读取剂量dcm文件重构剂量场
[doseArray_after,dose_space,X_after,Y_after,Z_after] = dose_transform_restruct(planC,doseNum,num_image,...
    str_tranformDose,delta_x,delta_y,delta_z,dose_grid_space);
% 赋予剂量场图像
planC{indexS.dose}(doseNum) = dose_space ;

% 读取分割后的图片文件重构lung_roi
structNum = roi_num_start+1;
[lungRoiArray] = lung_roi_restruct(planC,structNum,num_image_lungSeg,str_lungSeg,lung_mask,seg_linename);
planC{1,4}(1) = lungRoiArray;            % 覆盖第一条，去掉多余的roi线
planC{1,4}(1).roiNumber = 1; 
% 栅格化等剂量线，否则CERR的gui几个ROI之间不能布尔操作
[segmentsM] = doseRoiRasterSeg(1,planC);
planC{indexS.structures}(1).rasterSegments = segmentsM;
for i = 3:10
    planC{1,4}(i) = [];            % 去掉多余的roi线
end

% 把剂量线写入mat文件
i0 = 1;
while i0 < dose_slicer+1
    dose_value = dose_seg*i0 ;
    structNum = i0+1;
    % 计算等剂量线并保存入mat文件
    [dose_line] = doseLineSeg_transform(planC,dose_value,structNum,doseArray_after,X_after,Y_after,Z_after);
    planC{indexS.structures}(structNum) = dose_line;
    % 栅格化等剂量线，否则CERR的gui几个ROI之间不能布尔操作
    [segmentsM] = doseRoiRasterSeg(structNum,planC);
    planC{indexS.structures}(structNum).rasterSegments = segmentsM;
    i0 =i0+1;
end

% 保存更改后的数据到mat文件中
save(save_file,'planC');   % 保存更改后的数据到mat文件中


%% 计算总的运行时间
t2=clock;
etime(t2,t1)