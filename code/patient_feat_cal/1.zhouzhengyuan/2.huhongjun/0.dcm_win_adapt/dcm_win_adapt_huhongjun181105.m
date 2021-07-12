% 调整胡红军181105的图像显示范围，改进配准效果
clc;
clear all;
close all;

str_dcm  = 'E:\roi_feat_dose\data\2.huhongjun\segment\segment_181105\image1\' ;  % 待修改dcm存放位置
str_save = 'E:\roi_feat_dose\data\2.huhongjun\segment\segment_181105\image2\' ;   % 修改后的dcm文件存放位置
start_x = 50;
end_x = 300;
start_y = 50;
end_y = 450;
num_image = 207 ;

%% dcm文件修改
for k =1:9   
    data_str = strcat(str_dcm,'IMG000',num2str(k),'.dcm');
    Image_data = dicomread(data_str);
    dcm_information = dicominfo(data_str);  %显示图像的存储信息
    len = size(Image_data);
    Image_data = Image_data(start_x:end_x,start_y:end_y);
    % 保存图片
    save_name =[str_save,'IMG000',num2str(k),'.dcm'] ;
    dicomwrite(Image_data, save_name,dcm_information);%写入Dicom图像
end
for k =10:99   
    data_str = strcat(str_dcm,'IMG00',num2str(k),'.dcm');
    Image_data = dicomread(data_str);
    dcm_information = dicominfo(data_str);  %显示图像的存储信息
    len = size(Image_data);
    Image_data = Image_data(start_x:end_x,start_y:end_y);
    % 保存图片
    save_name =[str_save,'IMG00',num2str(k),'.dcm'] ;
    dicomwrite(Image_data, save_name,dcm_information);%写入Dicom图像
end
for k = 100:num_image   
    data_str = strcat(str_dcm,'IMG0',num2str(k),'.dcm');
    Image_data = dicomread(data_str);
    dcm_information = dicominfo(data_str);  %显示图像的存储信息
    len = size(Image_data);
    Image_data = Image_data(start_x:end_x,start_y:end_y);
    % 保存图片
    save_name =[str_save,'IMG0',num2str(k),'.dcm'] ;
    dicomwrite(Image_data, save_name,dcm_information);%写入Dicom图像
end



% % 转换数据为0-255
% A=double(Image_data);
% C=mat2gray(A);
% figure;imshow(C, 'DisplayRange',[]);
