% ���������181105��ͼ����ʾ��Χ���Ľ���׼Ч��
clc;
clear all;
close all;

mat_str = 'E:\roi_feat_dose\data\' ;
patient_name = '8.chenfangqiu';
data_time = '190812';
% plan��190812ͼƬ��Ҫ����
str_dcm = [mat_str,patient_name,'\segment\segment_',data_time,'\image_beforeplan\'];   % ���޸�dcm���λ��
str_save = [mat_str,patient_name,'\segment\segment_',data_time,'\image_afterplan\'];  % �޸ĺ��dcm�ļ����λ��
run_mode = 1 ;  % ����ģʽ���Ƿ񱣴�ͼƬ��1���棬0����ͼ��Ч��
k = 30 ;  % ����ģʽ��ͼƬ���
start_x = 1;
end_x = 350;
start_y = 1;
end_y = 512;
num_image = 44 ;  % 190812��155��plan��44

%% dcm�ļ��޸�
if run_mode == 1   % ����ģʽ���Ƿ񱣴�ͼƬ��1���棬0������ͼ��Ч��
    if num_image>=100
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
    end
    if num_image>=10  && num_image<100
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
        for k =10:num_image   
            data_str = strcat(str_dcm,'IMG00',num2str(k),'.dcm');
            Image_data = dicomread(data_str);
            dcm_information = dicominfo(data_str);  %��ʾͼ��Ĵ洢��Ϣ
            len = size(Image_data);
            Image_data = Image_data(start_x:end_x,start_y:end_y);
            % ����ͼƬ
            save_name =[str_save,'IMG00',num2str(k),'.dcm'] ;
            dicomwrite(Image_data, save_name,dcm_information);%д��Dicomͼ��
        end
    end
end

%% ����ģʽ���Ƿ񱣴�ͼƬ��1���棬0������ͼ��Ч��
if run_mode == 0
    data_str = strcat(str_dcm,'IMG00',num2str(k),'.dcm');
    Image_data = dicomread(data_str);
    dcm_information = dicominfo(data_str);  %��ʾͼ��Ĵ洢��Ϣ
    len = size(Image_data);
    Image_data = Image_data(start_x:end_x,start_y:end_y);
    % ת������Ϊ0-255
    A=double(Image_data);
    C=mat2gray(A);
    figure;imshow(C, 'DisplayRange',[]);
end
