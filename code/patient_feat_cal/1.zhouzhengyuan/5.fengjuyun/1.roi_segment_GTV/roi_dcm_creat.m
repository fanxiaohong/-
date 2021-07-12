function roi_dcm_creat(str,patient_name,roi_name,num_image);
% ��roiͼƬд���Ӧ��dcm�ļ���ʹ�京��������Ϣ��Ϊ�˺�����׼ʹ��

%% �ж��Ƿ�����ļ��У�û���򴴽�
str_dcm  = [str,'data\',patient_name,'\original\roi_segment\image_plan\'] ;  % ���޸�dcm���λ��
str_save = [str,'data\',patient_name,'\original\roi_segment\',roi_name,'_plan_dcm\'] ; ;   % �޸ĺ��dcm�ļ����λ��
save_str = [str,'data\',patient_name,'\original\roi_segment\'];  % roi�ָ�ͼƬ�Ĵ洢λ��
file_name_roi = [roi_name,'_plan'] ;  % ��Ӧroi���ļ��������ڴ��labelͼƬ
file_name = [roi_name,'_plan_dcm'] ;  % ��Ӧroi���ļ��������ڴ��labelͼƬ
sec_path = [save_str, file_name,'\'];
if ~exist(sec_path,'file')
    mkdir([save_str, file_name]);
end

%% �滻dcm��imageΪroi��label
i = 1;
for k = 1:9 
    imageName=strcat('label_',num2str(num_image+1-k),'.bmp');
    roi_str = [save_str,file_name_roi,'\',imageName];
    if exist(roi_str,'file')
        roi_image = imread(roi_str);
        data_str = strcat(str_dcm,'IMG000',num2str(k),'.dcm');
        Image_data = dicomread(data_str);
        dcm_information = dicominfo(data_str);  %��ʾͼ��Ĵ洢��Ϣ
        Image_data = roi_image;
        % ����ͼƬ
        save_name =[str_save,'IMG000',num2str(i),'.dcm'] ;
        dicomwrite(Image_data, save_name,dcm_information);%д��Dicomͼ��
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
        dcm_information = dicominfo(data_str);  %��ʾͼ��Ĵ洢��Ϣ
        Image_data = roi_image;
        % ����ͼƬ
        if i < 10
            save_name =[str_save,'IMG000',num2str(i),'.dcm'] ;
        else
            save_name =[str_save,'IMG00',num2str(i),'.dcm'] ;
        end
        dicomwrite(Image_data, save_name,dcm_information);%д��Dicomͼ��
        i = i +1 ;
    end
end

% %% ����ģ�飬���dcmimage�滻�Ƿ���Ч
% k = 15 ;
% imageName=strcat('label_',num2str(k),'.bmp');
% roi_str = [save_str,file_name_roi,'\',imageName];
% if exist(roi_str,'file')
%     roi_image = imread(roi_str);
%     data_str = strcat(str_dcm,'IMG00',num2str(k),'.dcm');
%     Image_data = dicomread(data_str);
%     dcm_information = dicominfo(data_str);  %��ʾͼ��Ĵ洢��Ϣ
%     Image_data = roi_image;
%     % ����ͼƬ
%     save_name =[str_save,'IMG00',num2str(k),'.dcm'] ;
%     dicomwrite(Image_data, save_name,dcm_information);%д��Dicomͼ��
%     % ת������Ϊ0-255
%     A=double(Image_data);
%     C=mat2gray(A);
%     figure;imshow(C, 'DisplayRange',[]);
% end