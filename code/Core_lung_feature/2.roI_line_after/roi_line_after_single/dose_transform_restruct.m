function [doseArray_after,dose_space,X_after,Y_after,Z_after] = dose_transform_restruct(planC,doseNum,num_image,str_tranformDose,delta_x,delta_y,delta_z,dose_grid_space);
% 配准后读取剂量dcm文件重构剂量场

% 打印一下目录
indexS = planC{end};        % plan有的内容

%% 计算全局剂量
planC{indexS.dose}(doseNum);
[xDoseVals, yDoseVals, zDoseVals] = getDoseXYZVals(planC{indexS.dose}(doseNum));
doseArray = planC{indexS.dose}(doseNum).doseArray;    %method2

%% 读取并构造配准后的3维dose矩阵;
dose_after_X = [];
dose_after_Y = [];
dose_after_Z = [];
doseArray_after = [];

%% 判断num_image也就是配准后dose图片的数量决定读取重构的方式
str1 = strcat(str_tranformDose,'IMG000',num2str(1),'.dcm');
dose_transform = dicomread(str1);
dcm_information_after = dicominfo(str1);  %显示图像的存储信息
doseArray_after = ones(size(dose_transform, 1), size(dose_transform, 2),num_image,'double') ; % 构建变形后dose4维矩阵
% num_image数量在10和99之间
if  num_image >= 10 && num_image <100
    for i =1:9
        str1 = strcat(str_tranformDose,'IMG000',num2str(i),'.dcm');
        dose_transform = dicomread(str1);
        dcm_information_after = dicominfo(str1);  %显示图像的存储信息
        doseArray_after(:,:,i) = dose_transform;
    end
    for i = 10:num_image
        str1 = strcat(str_tranformDose,'IMG00',num2str(i),'.dcm');
        dose_transform = dicomread(str1);
        dcm_information_after = dicominfo(str1);  %显示图像的存储信息
        doseArray_after(:,:,i) = dose_transform;
    end
end

% num_image数量在100和999之间
if  num_image >= 100 && num_image <1000
    for i =1:9
        str1 = strcat(str_tranformDose,'IMG000',num2str(i),'.dcm');
        dose_transform = dicomread(str1);
        dcm_information_after = dicominfo(str1);  %显示图像的存储信息
        doseArray_after(:,:,i) = dose_transform;
    end
    for i = 10:99
        str1 = strcat(str_tranformDose,'IMG00',num2str(i),'.dcm');
        dose_transform = dicomread(str1);
        dcm_information_after = dicominfo(str1);  %显示图像的存储信息
        doseArray_after(:,:,i) = dose_transform;
    end
    for i = 100:num_image
        str1 = strcat(str_tranformDose,'IMG0',num2str(i),'.dcm');
        dose_transform = dicomread(str1);
        dcm_information_after = dicominfo(str1);  %显示图像的存储信息
        doseArray_after(:,:,i) = dose_transform;
    end
end

sizeI_doseArray_after = size(doseArray_after);

%% 把变形后剂量矩阵坐标系转化为到图像坐标系
X_after = [];  % 计算变形前坐标
for i= 1:sizeI_doseArray_after(2)
    x_after_data = min(xDoseVals)-delta_x*0.1 + (i-1)*dose_grid_space ;
    X_after = [X_after,x_after_data];
end
Y_after = [];  % 计算变形前坐标
for i= 1:sizeI_doseArray_after(1)
    y_after_data = max(yDoseVals)+delta_y*0.1 - (i-1)*dose_grid_space ;
    Y_after = [Y_after,y_after_data];
end
Z_after = [];  % 计算变形前坐标
for i= 1:sizeI_doseArray_after(3)
    z_after_data = max(zDoseVals) - delta_z * 0.1 - (i-1)*dose_grid_space ;
    Z_after = [Z_after;z_after_data];
end

%% 赋予剂量场图像
planC{indexS.dose}(doseNum).numberMultiFrameImages =  size(doseArray_after, 3) ;
planC{indexS.dose}(doseNum).sizeOfDimension1 =  size(doseArray_after, 2) ;
planC{indexS.dose}(doseNum).sizeOfDimension2 =  size(doseArray_after, 1) ;
planC{indexS.dose}(doseNum).sizeOfDimension3 =  size(doseArray_after, 3) ;
planC{indexS.dose}(doseNum).coord1OFFirstPoint = X_after(1) ;
planC{indexS.dose}(doseNum).coord2OFFirstPoint = Y_after(1) ;
planC{indexS.dose}(doseNum).horizontalGridInterval =  X_after(2)-X_after(1);
planC{indexS.dose}(doseNum).verticalGridInterval = Z_after(2)-Z_after(1) ;
planC{indexS.dose}(doseNum).doseArray = doseArray_after/256 ;
planC{indexS.dose}(doseNum).zValues = Z_after;

dose_space = planC{indexS.dose}(doseNum);
