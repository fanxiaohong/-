% 调整胡红军181105的图像显示范围，改进配准效果
clc;
clear all;
close all;

mat_str = 'E:\roi_feat_dose\data\' ;
patient_name = '8.chenfangqiu';
data_time = '190812';
% plan和190812图片都要处理
str_dcm = [mat_str,patient_name,'\segment\segment_',data_time,'\image_beforeplan\'];   % 待修改dcm存放位置
str_save = [mat_str,patient_name,'\segment\segment_',data_time,'\image_afterplan\'];  % 修改后的dcm文件存放位置
run_mode = 1 ;  % 运行模式，是否保存图片，1保存，0测试图像效果
k = 30 ;  % 测试模式的图片序号
start_x = 1;
end_x = 350;
start_y = 1;
end_y = 512;
num_image = 44 ;  % 190812是155，plan是44

%% dcm文件修改
if run_mode == 1   % 运行模式，是否保存图片，1保存，0，测试图像效果
    if num_image>=100
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
    end
    if num_image>=10  && num_image<100
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
        for k =10:num_image   
            data_str = strcat(str_dcm,'IMG00',num2str(k),'.dcm');
            Image_data = dicomread(data_str);
            dcm_information = dicominfo(data_str);  %显示图像的存储信息
            len = size(Image_data);
            Image_data = Image_data(start_x:end_x,start_y:end_y);
            % 保存图片
            save_name =[str_save,'IMG00',num2str(k),'.dcm'] ;
            dicomwrite(Image_data, save_name,dcm_information);%写入Dicom图像
        end
    end
end

%% 运行模式，是否保存图片，1保存，0，测试图像效果
if run_mode == 0
    data_str = strcat(str_dcm,'IMG00',num2str(k),'.dcm');
    Image_data = dicomread(data_str);
    dcm_information = dicominfo(data_str);  %显示图像的存储信息
    len = size(Image_data);
    Image_data = Image_data(start_x:end_x,start_y:end_y);
    % 转换数据为0-255
    A=double(Image_data);
    C=mat2gray(A);
    figure;imshow(C, 'DisplayRange',[]);
end
