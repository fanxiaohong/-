% ���������181105��ͼ����ʾ��Χ���Ľ���׼Ч��
clc;
clear all;
close all;

str_dcm  = 'E:\roi_feat_dose\data\2.huhongjun\segment\segment_181105\image1\' ;  % ���޸�dcm���λ��
str_save = 'E:\roi_feat_dose\data\2.huhongjun\segment\segment_181105\image2\' ;   % �޸ĺ��dcm�ļ����λ��
start_x = 50;
end_x = 300;
start_y = 50;
end_y = 450;
num_image = 207 ;

%% dcm�ļ��޸�
for k =1:9   
    data_str = strcat(str_dcm,'IMG000',num2str(k),'.dcm');
    Image_data = dicomread(data_str);
    dcm_information = dicominfo(data_str);  %��ʾͼ��Ĵ洢��Ϣ
    len = size(Image_data);
    Image_data = Image_data(start_x:end_x,start_y:end_y);
    % ����ͼƬ
    save_name =[str_save,'IMG000',num2str(k),'.dcm'] ;
    dicomwrite(Image_data, save_name,dcm_information);%д��Dicomͼ��
end
for k =10:99   
    data_str = strcat(str_dcm,'IMG00',num2str(k),'.dcm');
    Image_data = dicomread(data_str);
    dcm_information = dicominfo(data_str);  %��ʾͼ��Ĵ洢��Ϣ
    len = size(Image_data);
    Image_data = Image_data(start_x:end_x,start_y:end_y);
    % ����ͼƬ
    save_name =[str_save,'IMG00',num2str(k),'.dcm'] ;
    dicomwrite(Image_data, save_name,dcm_information);%д��Dicomͼ��
end
for k = 100:num_image   
    data_str = strcat(str_dcm,'IMG0',num2str(k),'.dcm');
    Image_data = dicomread(data_str);
    dcm_information = dicominfo(data_str);  %��ʾͼ��Ĵ洢��Ϣ
    len = size(Image_data);
    Image_data = Image_data(start_x:end_x,start_y:end_y);
    % ����ͼƬ
    save_name =[str_save,'IMG0',num2str(k),'.dcm'] ;
    dicomwrite(Image_data, save_name,dcm_information);%д��Dicomͼ��
end



% % ת������Ϊ0-255
% A=double(Image_data);
% C=mat2gray(A);
% figure;imshow(C, 'DisplayRange',[]);
