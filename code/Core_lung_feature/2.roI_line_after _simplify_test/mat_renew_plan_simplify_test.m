function [planC,save_file] = mat_renew_plan_simplify(mat_str,patient_name,data_time,dose_seg,doseNum,seg_linename,lung_start,...
        lung_end,lung_mask,strName,dose_grid_space,image_grid_space_xy,image_grid_space_z,image_size,plan_time);
% 更新对应时间的计划line,计划CT插值

% 路径名称赋值
filename = [mat_str,'plan\',patient_name,'\',char(data_time),'\planC',char(plan_time)];    % plan计划配准后
save_file = [filename,'_line'];          % 保存文件
str_plantime = char(plan_time);      % 把计划时间字符化，方便后续分解
str_lungSeg = [mat_str,'data\',patient_name,'\segment\segment_',char(data_time),'\label_creat\']; % 肺部分割图片存放位置
str_plan_remain = [mat_str,'data\',patient_name,'\original\20',str_plantime(1:2),'-',str_plantime(3:4),'-',str_plantime(5:6),'plan'] ;   % 计划剩余文件存放地址
num_image_lungSeg = length(dir([str_lungSeg,'*.bmp']));   % 读取目标文件夹下图片label文件的数量
plan_dcm_num = length(dir([str_plan_remain]))-2;   % 读取目标文件夹下变形后dose文件的数量

%% 载入mat文件，planC
m = matfile(filename);
global planC 
planC = m.planC;
indexS = planC{end};        % plan有的内容
% 参数计算
scanNum = 1;
scan3M = getScanArray(scanNum,planC); 
[xScanVals, yScanVals, zScanVals] = getScanXYZVals(planC{indexS.scan}(scanNum));
image_grid_space_xyplan = double(abs(xScanVals(2)-xScanVals(1)))*10;   % x,y间隔
image_grid_space_zplan = abs(zScanVals(2)-zScanVals(1))*10;   % x,y间隔
% 参数计算
gird_num_incerp_xy = ceil(image_size*image_grid_space_xyplan/image_grid_space_xy);
delete_grid = ceil((gird_num_incerp_xy-image_size)/2) ;   % 两边删除的网格数，保持三维矩阵xy面为512X512尺寸
gird_num_incerp_z = (plan_dcm_num-1)*image_grid_space_zplan/image_grid_space_z ;

%% 把编辑好的lung,dose,image_interp存入mat文件，planC
structNum_empty = length(planC{1,4});   % 把后续的roi线删除
structNum = structNum_empty+1;
[lungRoiArray,scanInterpArray,X_after,Y_after,Z_after,x_grid,y_grid] = scan_lung_interp_plan(planC,structNum,...
    delete_grid,image_grid_space_xy,image_grid_space_z,gird_num_incerp_z,lung_mask,lung_start,lung_end,strName);
planC{1,4}(1) = lungRoiArray;            % 覆盖第一条，去掉多余的roi线
planC{1,4}(1).roiNumber = 1; 
planC{1,4}(1). structureName = seg_linename ;   % 把插值后的lung线命名为lung_seg
planC{1,3} = scanInterpArray ;
% 栅格化等剂量线，否则CERR的gui几个ROI之间不能布尔操作
[segmentsM] = doseRoiRasterSeg(1,planC);
planC{indexS.structures}(1).rasterSegments = segmentsM;
for i = 3:(structNum_empty-9)     % 如果不清空，会出现不能显示的错误
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
    % 清理剂量线
    if structNum>2
        [planC] = dose_line_clear_simplify(planC,structNum);
    end
    % 栅格化等剂量线，否则CERR的gui几个ROI之间不能布尔操作
    [segmentsM] = doseRoiRasterSeg(structNum,planC);
    planC{indexS.structures}(structNum).rasterSegments = segmentsM;
    i0 =i0+1;
end