function [lungRoiArray,scanInterpArray,X_after,Y_after,Z_after,x_grid,y_grid] = scan_lung_interp_plan_simplify(planC,structNum,...
    delete_grid,image_grid_space_xy,image_grid_space_z,gird_num_incerp_z,lung_mask,lung_start,lung_end,strName);
% 配准后读取剂量dcm文件重构剂量场

% 打印一下目录
indexS = planC{end};        % plan有的内容

%% 读取扫描矩阵及CT坐标X,Y,Z
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

% 把图像矩阵调整后的网格
[XI,YI,ZI] = meshgrid(xScanVals,yScanVals,zScanVals);
[XII,YII,ZII] = meshgrid(X_after,Y_after,Z_after);
VI = interp3(XI,YI,ZI,double(scan3M),XII,YII,ZII);    % 通过插值得到对应治疗后的计划图像矩阵
VI = uint16(VI) ;          % 转化为同一种数值类型

% 把更改后的图像矩阵数据存入计划mat文件内
planC{1,3}.scanArray = VI;
planC{1,3}.uniformScanInfo.sliceThickness =  image_grid_space_z*0.1;
planC{1,3}.uniformScanInfo.grid1Units = image_grid_space_xy*0.1 ;
planC{1,3}.uniformScanInfo.grid2Units = image_grid_space_xy*0.1 ; 
planC{1,3}.uniformScanInfo.sliceNumInf = gird_num_incerp_z ;
planC{1,3}.uniformScanInfo.firstZValue = Z_after(1) ;
 
% 把第一层网格数据更改为插值后数据
planC{1,3}.scanInfo(1).grid1Units = image_grid_space_xy*0.1 ;
planC{1,3}.scanInfo(1).grid2Units = image_grid_space_xy*0.1 ;
planC{1,3}.scanInfo(1).sliceThickness = image_grid_space_z*0.1 ;
planC{1,3}.scanInfo(1).voxelThickness = planC{1,3}.scanInfo(1).sliceThickness ;
for i =1:gird_num_incerp_z
    planC{1,3}.scanInfo(i) = planC{1,3}.scanInfo(1);
    planC{1,3}.scanInfo(i).imageNumber = i ;
    planC{1,3}.scanInfo(i).zValue = Z_after(i) ;
end

%% 提取lung分割线并作插值
ROI_contour = {planC{indexS.structures}.contour};
strC = {planC{indexS.structures}.structureName};
structNum1 = getMatchingIndex(strName,strC,'exact');
scanNum = getStructureAssociatedScan(structNum1 , planC);

% 处理得到mask三维矩阵及mask区域内image三维矩阵
[rasterSegments, planC] = getRasterSegments(structNum1,planC);
[mask3M]  = rasterToMask(rasterSegments, scanNum, planC);   % 读出mask和lung的ROI所在的slicer
[XI_lung,YI_lung,ZI_lung] = meshgrid(xScanVals,yScanVals,zScanVals(lung_start:lung_end));
lungRoiArray = interp3(XI_lung,YI_lung,ZI_lung,double(mask3M),XII,YII,ZII);    % 通过插值得到对应治疗后的计划图像矩阵

% 给剂量线赋值
planC{1,4}(structNum) = planC{1,4}(2);            % 增加剂量线，先复制前面的一条
% 更改内容，四项
planC{1,4}(structNum).roiNumber = structNum ;           % 更改roi的编号
planC{1,4}(structNum).structureName = ['lung_seg'];    % 线命名
planC{1,4}(structNum).structureColor = planC{1,4}(18).structureColor;    % 剂量线颜色

%% 给contour赋值
len_s = size(VI);
for i =1:len_s(3)
    % 抽取一张slicer测试绘制剂量等高线
    c = [];
%     [c,h]=contourf(XII(:,:,i),YII(:,:,i),lungRoiArray(:,:,i),'LevelList',[lung_mask],'ShowText','on');  % 输出特定等值线
%     close;
    c=contourf(XII(:,:,i),YII(:,:,i),lungRoiArray(:,:,i),'LevelList',[lung_mask  lung_mask]); 
    len = length(c);
    c_add = zeros(1,len-1);
    c_add(1,:) = Z_after(i);
    c = [c(:,2:end);c_add]';    % c为20层的30等高线的三维矩阵
    
    d = [];
    m = 1;   % 第一次筛选，去掉独立点
    for n = 1:len-2
        if ((abs(c(n,1)-c(n+1,1)) < x_grid) | (abs(c(n,2)-c(n+1,2)) < y_grid))
            d(m,1) = c(n,1);
            d(m,2) = c(n,2);
            d(m,3)= c(n,3);
            m = m+1;
        end
    end
    % 补上最有一行
    if ((abs(c(n,1)-c(n+1,1)) < x_grid) | (abs(c(n,2)-c(n+1,2)) < y_grid))
        d(m,1) = c(n+1,1);
        d(m,2) = c(n+1,2);
        d(m,3)= c(n+1,3);
    end

    % 把等高线分开
    j = 1;  % 一张等高线有一个区域，初始为1
    place = 0;
    for k = 1:length(d)-1
        if ((abs(d(k,1)-d(k+1,1)) > x_grid) & (abs(d(k,2)-d(k+1,2)) > y_grid)) | ((abs(d(k,1)-d(k+1,1)) > x_grid*10) | (abs(d(k,2)-d(k+1,2)> y_grid*10)))
            % 给roi边沿赋值
            place = [place;k];
            j = j+1;
        end
    end
    place = [place;length(d)];
    % 拆开等剂量区域并存入planC
    for j1 = 1:j
        eval(['d',num2str(j1),'=','d(place(j1)+1:place(j1+1),:,:);']);
        eval(['planC{1,4}(structNum).contour(i).segments(j1).points',' = ','d',num2str(j1),';']);
    end
end

lungRoiArray = planC{1,4}(structNum);    % 输出roi结构
scanInterpArray = planC{1,3};            % 输出插值后的image矩阵信息，在主程序写入mat文件
