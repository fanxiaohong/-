clc;
clear all;
t1=clock;

%% 超参数，读入mat文件，mat.bz2压缩过的不行
mat_str = 'E:/roi_feat_dose/plan/';
patient_name = 'zhouzhengyuan\';
data_time = '190619\' ;
filename = [mat_str,patient_name,data_time,'planC190505'];    % plan计划配准后
save_file = [filename,'_line'];          % 保存文件
dose_seg = 5 ;          % 剂量划分区间，dose bin
roi_num_start = 19 ;     % 已有的roi数量
doseNum = 7;             % 用第几种剂量方案，周正元方案7，胡红军方案1
seg_linename = 'lung_seg' ; % 肺分割线名称
lung_start = 2 ;      % 肺部图像开始slicer
lung_end = 45 ;   % 肺部图像结束slicer
num_image_lungSeg = 269;  % 肺分割图片数量
lung_mask = 1 ;          % 肺分割mask区域的值
strName = 'lung';        % 肺名称
dose_grid_space = 0.4 ;
image_grid_space_xyplan = 0.976563 ;
image_grid_space_xy = 0.7734379768 ;
image_grid_space_z = 1 ;
gird_num_incerp_xy = ceil(512*image_grid_space_xyplan/0.7734379768);
delete_grid = ceil((gird_num_incerp_xy-512)/2) ;   % 两边删除的网格数，保持三维矩阵xy面为512X512尺寸
gird_num_incerp_z = (46-1)*5/1 ;

%% 载入mat文件，planC
m = matfile(filename);
global planC 
planC = m.planC;
indexS = planC{end};        % plan有的内容

%% 把编辑好的lung,dose,image_interp存入mat文件，planC
structNum = roi_num_start+1;
[lungRoiArray,scanInterpArray,X_after,Y_after,Z_after,x_grid,y_grid] = scan_lung_interp_plan(planC,structNum,...
    delete_grid,image_grid_space_xy,image_grid_space_z,gird_num_incerp_z,lung_mask,lung_start,lung_end,strName);
planC{1,4}(1) = lungRoiArray;            % 覆盖第一条，去掉多余的roi线
planC{1,4}(1).roiNumber = 1; 
planC{1,3} = scanInterpArray ;
% 栅格化等剂量线，否则CERR的gui几个ROI之间不能布尔操作
[segmentsM] = doseRoiRasterSeg(1,planC);
planC{indexS.structures}(1).rasterSegments = segmentsM;
for i = 3:10
    planC{1,4}(i) = [];            % 去掉多余的roi线
end


%% 循环计算所有剂量线
planC{indexS.dose}(doseNum);    % 计算全局剂量最大值，确定计量划分区间
doseArray = planC{indexS.dose}(doseNum).doseArray;    %method2
dose_max = max(max(max(doseArray)));
dose_slicer = fix(dose_max/dose_seg);

%% 把剂量线写入mat文件
i0 = 1;
while i0 < dose_slicer+1
    dose_value = dose_seg*i0 ;
    structNum = i0+1;
    % 计算等剂量线并保存入mat文件
    [dose_line] = doseLineSeg_plan(planC,dose_value,structNum,doseNum,X_after,Y_after,Z_after,x_grid,y_grid);
    planC{indexS.structures}(structNum) = dose_line;
    % 栅格化等剂量线，否则CERR的gui几个ROI之间不能布尔操作
    [segmentsM] = doseRoiRasterSeg(structNum,planC);
    planC{indexS.structures}(structNum).rasterSegments = segmentsM;
    i0 =i0+1;
end

%% 保存更改后的数据到mat文件中
save(save_file,'planC');   % 保存更改后的数据到mat文件中

%% 计算总的运行时间
t2=clock;
etime(t2,t1)