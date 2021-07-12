function [planC,save_file] = plan_roi_make(mat_str,patient_name,plan_time,data_time,p);
% 模式2，根据已有的制作好的计划CT插值生成其余时间点的计划CT

%% 路径名称赋值
filename_plan = [mat_str,'plan\',patient_name,'\',char(data_time(1)),'\planC',char(plan_time),'_roi'];    % 制作好的plan计划
filename_diagnose = [mat_str,'plan\',patient_name,'\',char(data_time(p)),'\planC',char(data_time(p))];    % plan计划配准后
save_file = [mat_str,'plan\',patient_name,'\',char(data_time(p)),'\planC',char(plan_time),'_roi'];    % % 保存文件
str_plantime = char(plan_time);      % 把计划时间字符化，方便后续分解
str_lungSeg = [mat_str,'data\',patient_name,'\segment\segment_',char(data_time(p)),'\label_creat\']; % 肺部分割图片存放位置
str_plan_remain = [mat_str,'data\',patient_name,'\original\20',str_plantime(1:2),'-',str_plantime(3:4),'-',str_plantime(5:6),'plan'] ;   % 计划剩余文件存放地址
num_image_lungSeg = length(dir([str_lungSeg,'*.bmp']));   % 读取目标文件夹下图片label文件的数量

%% 载入对应诊断mat文件，planC
m = matfile(filename_diagnose);
global planC 
planC = m.planC;
indexS = planC{end};        % plan有的内容
% 参数计算
scanNum = 1;
scan3M = getScanArray(scanNum,planC); 
[xScanVals, yScanVals, zScanVals] = getScanXYZVals(planC{indexS.scan}(scanNum));
image_grid_space_xy = double(abs(xScanVals(2)-xScanVals(1)))*10;   % x,y间隔
image_grid_space_z = abs(zScanVals(2)-zScanVals(1))*10;   % x,y间隔

%% 载入制作好的plan_roi_mat文件，planC
m = matfile(filename_plan);
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
gird_num_incerp_z = (length(zScanVals)-1)*image_grid_space_zplan/image_grid_space_z ;

%% 循环插值
structNum_plan_roi = length(planC{1,4}) ;   % 计算当前做好的planC的roi数量

%% 肺部插值
% 打印一下目录
indexS = planC{end};        % plan有的内容
% 读取扫描矩阵及CT坐标X,Y,Z
scanNum = 1;
planC{indexS.scan}(scanNum);
sliceNum = 1;
planC{indexS.scan}(scanNum).scanInfo(sliceNum);
[xScanVals, yScanVals, zScanVals] = getScanXYZVals(planC{indexS.scan}(scanNum));
x_grid = ceil((max(xScanVals)-min(xScanVals(2)))/length(xScanVals))/10;
y_grid = ceil((max(yScanVals)-min(yScanVals(2)))/length(yScanVals))/10;
scan3M = getScanArray(scanNum,planC); 

% 读取并构造配准后的3维矩阵;
X_after = [];  % 计算变形前坐标
for i= 1:512
    x_after_data = min(xScanVals)+delete_grid*image_grid_space_xy*0.1 + (i-1)*image_grid_space_xy*0.1 ;
    X_after = [X_after,x_after_data];
end
Y_after = [];  % 计算变形前坐标
for i= 1:512
    y_after_data = max(yScanVals) -delete_grid*image_grid_space_xy*0.1- (i-1)*image_grid_space_xy*0.1 ;
    Y_after = [Y_after,y_after_data];
end
Z_after = [];  % 计算变形前坐标
for i= 1:(gird_num_incerp_z+1)
    z_after_data = max(zScanVals)  - (i-1)*image_grid_space_z*0.1 ;
    Z_after = [Z_after;z_after_data];
end
Z_after = Z_after(end:-1:1) ;  % 坐标倒个






for struct_num = 1 : structNum_plan_roi
    
end





