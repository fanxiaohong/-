function roi_dcm_creat(str,patient_name,roi_name,num_image);
% 把roi图片写入对应的dcm文件，使其含有坐标信息，为了后续配准使用

%% 判断是否存在文件夹，没有则创建
str_dcm  = [str,'data\',patient_name,'\original\roi_segment\image_plan\'] ;  % 待修改dcm存放位置
str_save = [str,'data\',patient_name,'\original\roi_segment\',roi_name,'_plan_dcm\'] ; ;   % 修改后的dcm文件存放位置
save_str = [str,'data\',patient_name,'\original\roi_segment\'];  % roi分割图片的存储位置
file_name_roi = [roi_name,'_plan'] ;  % 对应roi的文件名，用于存放label图片
file_name = [roi_name,'_plan_dcm'] ;  % 对应roi的文件名，用于存放label图片
sec_path = [save_str, file_name,'\'];
if ~exist(sec_path,'file')
    mkdir([save_str, file_name]);
end

%% 替换dcm中image为roi的label
i = 1;
for k = 1:9 
    imageName=strcat('label_',num2str(num_image+1-k),'.bmp');
    roi_str = [save_str,file_name_roi,'\',imageName];
    if exist(roi_str,'file')
        roi_image = imread(roi_str);
        data_str = strcat(str_dcm,'IMG000',num2str(k),'.dcm');
        Image_data = dicomread(data_str);
        dcm_information = dicominfo(data_str);  %显示图像的存储信息
        Image_data = roi_image;
        % 保存图片
        save_name =[str_save,'IMG000',num2str(i),'.dcm'] ;
        dicomwrite(Image_data, save_name,dcm_information);%写入Dicom图像
        i = i +1 ;
    end
end
for k = 10:num_image 
    imageName=strcat('label_',num2str(num_image+1-k),'.bmp');
    roi_str = [save_str,file_name_roi,'\',imageName];
    if exist(roi_str,'file')
        roi_image = imread(roi_str);
        data_str = strcat(str_dcm,'IMG00',num2str(k),'.dcm');
        Image_data = dicomread(data_str);
        dcm_information = dicominfo(data_str);  %显示图像的存储信息
        Image_data = roi_image;
        % 保存图片
        if i < 10
            save_name =[str_save,'IMG000',num2str(i),'.dcm'] ;
        else
            save_name =[str_save,'IMG00',num2str(i),'.dcm'] ;
        end
        dicomwrite(Image_data, save_name,dcm_information);%写入Dicom图像
        i = i +1 ;
    end
end

% %% 测试模块，检测dcmimage替换是否有效
% k = 15 ;
% imageName=strcat('label_',num2str(k),'.bmp');
% roi_str = [save_str,file_name_roi,'\',imageName];
% if exist(roi_str,'file')
%     roi_image = imread(roi_str);
%     data_str = strcat(str_dcm,'IMG00',num2str(k),'.dcm');
%     Image_data = dicomread(data_str);
%     dcm_information = dicominfo(data_str);  %显示图像的存储信息
%     Image_data = roi_image;
%     % 保存图片
%     save_name =[str_save,'IMG00',num2str(k),'.dcm'] ;
%     dicomwrite(Image_data, save_name,dcm_information);%写入Dicom图像
%     % 转换数据为0-255
%     A=double(Image_data);
%     C=mat2gray(A);
%     figure;imshow(C, 'DisplayRange',[]);
% end