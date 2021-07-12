function [planC,save_file,image_grid_space_xy,image_grid_space_z] = mat_renew_simplify(mat_str,patient_name,data_time,delta_x,delta_y,...
    delta_z,dose_grid_space,dose_seg,doseNum,seg_linename,lung_mask,plan_time);
% 把lung_seg和剂量线写入mat文件

%% 路径名称赋值
filename = [mat_str,'plan\',patient_name,'\',char(data_time),'\planC',char(data_time)];    % plan计划配准后
str_tranformDose = [mat_str,'data\',patient_name,'\register\register_plan_to_',char(data_time),'\dose_transform\'];   % 计划剂量经过变形场处理后存放位置
str_lungSeg = [mat_str,'data\',patient_name,'\segment\segment_',char(data_time),'\label_creat\']; % 肺部分割图片存放位置
save_file = [filename,'_line'];          % 保存文件名称
num_image = length(dir([str_tranformDose,'*.dcm']));   % 读取目标文件夹下变形后dose文件的数量
num_image_lungSeg = length(dir([str_lungSeg,'*.bmp']));   % 读取目标文件夹下图片label文件的数量

% 载入mat文件，planC
m = matfile(filename);
global planC 
planC = m.planC;
indexS = planC{end};        % plan有的内容
% 参数计算
scanNum = 1;
scan3M = getScanArray(scanNum,planC); 
[xScanVals, yScanVals, zScanVals] = getScanXYZVals(planC{indexS.scan}(scanNum));
image_grid_space_xy = double(abs(xScanVals(2)-xScanVals(1)))*10;   % x,y间隔
image_grid_space_z = abs(zScanVals(2)-zScanVals(1))*10;   % x,y间隔

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
structNum_empty = length(planC{1,4});   % 把后续的roi线删除
structNum = structNum_empty+1;
[lungRoiArray] = lung_roi_restruct(planC,structNum,num_image_lungSeg,str_lungSeg,lung_mask,seg_linename);
planC{1,4}(1) = lungRoiArray;            % 覆盖第一条，去掉多余的roi线
planC{1,4}(1).roiNumber = 1; 
% 栅格化等剂量线，否则CERR的gui几个ROI之间不能布尔操作
[segmentsM] = doseRoiRasterSeg(1,planC);
planC{indexS.structures}(1).rasterSegments = segmentsM;
for i = 3:(structNum_empty-9)   % 如果不清空，会出现不能显示的错误
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
    % 清理剂量线
    if structNum>2
        [planC] = dose_line_clear_simplify(planC,structNum);
    end
    % 栅格化等剂量线，否则CERR的gui几个ROI之间不能布尔操作
    [segmentsM] = doseRoiRasterSeg(structNum,planC);
    planC{indexS.structures}(structNum).rasterSegments = segmentsM;
    i0 =i0+1;
end


