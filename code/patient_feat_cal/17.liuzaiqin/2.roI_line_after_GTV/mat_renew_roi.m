function [planC,save_file] = mat_renew_roi(roi_name,roi_x,roi_y,roi_z,lung_mask,image_grid_space_xyplan,...
    image_grid_space_zplan,num_image,str_tranform_roi,filename);
% 把roi_seg写入mat文件

%% 路径名称赋值
save_file = [filename,'_',roi_name];          % 保存文件
% 载入mat文件，planC
m = matfile(filename);
global planC 
planC = m.planC;
indexS = planC{end};        % plan有的内容

%% 读取并构造配准后的3维dose矩阵;
roiArray_after = [];

%% 判断num_image也就是配准后dose图片的数量决定读取重构的方式
str1 = strcat(str_tranform_roi,'IMG000',num2str(1),'.dcm');
roi_transform = dicomread(str1);
dcm_information_after = dicominfo(str1);  %显示图像的存储信息
roiArray_after = ones(size(roi_transform, 1), size(roi_transform, 2),num_image,'double') ; % 构建变形后dose4维矩阵
% num_image数量在10和99之间
if  num_image >= 10 && num_image <100
    for i =1:9
        str1 = strcat(str_tranform_roi,'IMG000',num2str(i),'.dcm');
        roi_transform = dicomread(str1);
        dcm_information_after = dicominfo(str1);  %显示图像的存储信息
        roiArray_after(:,:,i) = roi_transform;
    end
    for i = 10:num_image
        str1 = strcat(str_tranform_roi,'IMG00',num2str(i),'.dcm');
        roi_transform = dicomread(str1);
        dcm_information_after = dicominfo(str1);  %显示图像的存储信息
        roiArray_after(:,:,i) = roi_transform;
    end
end

sizeI_roiArray_after = size(roiArray_after);

%% 把变形后剂量矩阵坐标系转化为到图像坐标系
X_after = [];  % 计算变形前坐标
for i= 1:sizeI_roiArray_after(2)
    x_after_data = -roi_x*0.1 + (i-1)*image_grid_space_xyplan*0.1 ;
    X_after = [X_after,x_after_data];
end
Y_after = [];  % 计算变形前坐标
for i= 1:sizeI_roiArray_after(1)
    y_after_data = roi_y*0.1 - (i-1)*image_grid_space_xyplan*0.1 ;
    Y_after = [Y_after,y_after_data];
end
Z_after = [];  % 计算变形前坐标
for i= 1:sizeI_roiArray_after(3)
    z_after_data = -roi_z * 0.1 - (i-1)*image_grid_space_zplan*0.1 ;
    Z_after = [Z_after;z_after_data];
end

%% 把变形后roi场插值到变形前的坐标系内
% 读取扫描矩阵及CT坐标X,Y,Z
scanNum = 1;
planC{indexS.scan}(scanNum);
sliceNum = 1;
planC{indexS.scan}(scanNum).scanInfo(sliceNum);
[xScanVals, yScanVals, zScanVals] = getScanXYZVals(planC{indexS.scan}(scanNum));
x_grid = ceil((max(xScanVals)-min(xScanVals(2)))/length(xScanVals))/10;
y_grid = ceil((max(yScanVals)-min(yScanVals(2)))/length(yScanVals))/10;
scan3M = getScanArray(scanNum,planC);

[XI,YI,ZI] = meshgrid(xScanVals,yScanVals,zScanVals);
[XII,YII,ZII] = meshgrid(X_after,Y_after,Z_after);
VI = interp3(XII,YII,ZII,roiArray_after,XI,YI,ZI);

%% 分割roi线并存入原来
ROI_contour = {planC{indexS.structures}.contour};
strC = {planC{indexS.structures}.structureName};
structNum1 = length(planC{1,4})+1;

% 给roi线赋值
planC{1,4}(structNum1) = planC{1,4}(2);            % 增加剂量线，先复制前面的一条
% 更改内容，四项
planC{1,4}(structNum1).roiNumber = structNum1 ;           % 更改roi的编号
planC{1,4}(structNum1).structureName = [roi_name];    % 剂量线命名
planC{1,4}(structNum1).structureColor = planC{1,4}(2).structureColor;    % 剂量线颜色


%% 给contour赋值
len_s = size(VI);
for i =1:len_s(3)
    %% 抽取一张slicer测试绘制剂量等高线
    c = [];
    c=contourf(XI(:,:,i),YI(:,:,i),VI(:,:,i),'LevelList',[lung_mask  lung_mask]);
    len = length(c);
    c_add = zeros(1,len-1);
    c_add(1,:) = zScanVals(i);
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
    roi_place = 0;
    for k = 1:length(d)-1
        if ((abs(d(k,1)-d(k+1,1)) > x_grid) & (abs(d(k,2)-d(k+1,2)) > y_grid)) | ((abs(d(k,1)-d(k+1,1)) > x_grid*10) | (abs(d(k,2)-d(k+1,2)> y_grid*10)))
            % 给roi边沿赋值
            roi_place = [roi_place;k];
            j = j+1;
        end
    end
    roi_place = [roi_place;length(d)];
    % 拆开等剂量区域并存入planC
    for j1 = 1:j
        eval(['d',num2str(j1),'=','d(roi_place(j1)+1:roi_place(j1+1),:,:);']);
        eval(['planC{1,4}(structNum1).contour(i).segments(j1).points',' = ','d',num2str(j1),';']);
    end
end

roi_line = planC{1,4}(structNum1);
planC{indexS.structures}(structNum1) = roi_line;
[segmentsM] = doseRoiRasterSeg(structNum1,planC);
planC{indexS.structures}(structNum1).rasterSegments = segmentsM;