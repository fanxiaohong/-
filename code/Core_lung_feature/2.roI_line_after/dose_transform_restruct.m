function [doseArray_after,dose_space,X_after,Y_after,Z_after] = dose_transform_restruct(planC,doseNum,num_image,str_tranformDose,delta_x,delta_y,delta_z,dose_grid_space);
% ��׼���ȡ����dcm�ļ��ع�������

% ��ӡһ��Ŀ¼
indexS = planC{end};        % plan�е�����

%% ����ȫ�ּ���
planC{indexS.dose}(doseNum);
[xDoseVals, yDoseVals, zDoseVals] = getDoseXYZVals(planC{indexS.dose}(doseNum));
doseArray = planC{indexS.dose}(doseNum).doseArray;    %method2

%% ��ȡ��������׼���3άdose����;
dose_after_X = [];
dose_after_Y = [];
dose_after_Z = [];
doseArray_after = [];

%% �ж�num_imageҲ������׼��doseͼƬ������������ȡ�ع��ķ�ʽ
str1 = strcat(str_tranformDose,'IMG000',num2str(1),'.dcm');
dose_transform = dicomread(str1);
dcm_information_after = dicominfo(str1);  %��ʾͼ��Ĵ洢��Ϣ
doseArray_after = ones(size(dose_transform, 1), size(dose_transform, 2),num_image,'double') ; % �������κ�dose4ά����
% num_image������10��99֮��
if  num_image >= 10 && num_image <100
    for i =1:9
        str1 = strcat(str_tranformDose,'IMG000',num2str(i),'.dcm');
        dose_transform = dicomread(str1);
        dcm_information_after = dicominfo(str1);  %��ʾͼ��Ĵ洢��Ϣ
        doseArray_after(:,:,i) = dose_transform;
    end
    for i = 10:num_image
        str1 = strcat(str_tranformDose,'IMG00',num2str(i),'.dcm');
        dose_transform = dicomread(str1);
        dcm_information_after = dicominfo(str1);  %��ʾͼ��Ĵ洢��Ϣ
        doseArray_after(:,:,i) = dose_transform;
    end
end

% num_image������100��999֮��
if  num_image >= 100 && num_image <1000
    for i =1:9
        str1 = strcat(str_tranformDose,'IMG000',num2str(i),'.dcm');
        dose_transform = dicomread(str1);
        dcm_information_after = dicominfo(str1);  %��ʾͼ��Ĵ洢��Ϣ
        doseArray_after(:,:,i) = dose_transform;
    end
    for i = 10:99
        str1 = strcat(str_tranformDose,'IMG00',num2str(i),'.dcm');
        dose_transform = dicomread(str1);
        dcm_information_after = dicominfo(str1);  %��ʾͼ��Ĵ洢��Ϣ
        doseArray_after(:,:,i) = dose_transform;
    end
    for i = 100:num_image
        str1 = strcat(str_tranformDose,'IMG0',num2str(i),'.dcm');
        dose_transform = dicomread(str1);
        dcm_information_after = dicominfo(str1);  %��ʾͼ��Ĵ洢��Ϣ
        doseArray_after(:,:,i) = dose_transform;
    end
end

sizeI_doseArray_after = size(doseArray_after);

%% �ѱ��κ������������ϵת��Ϊ��ͼ������ϵ
X_after = [];  % �������ǰ����
for i= 1:sizeI_doseArray_after(2)
    x_after_data = min(xDoseVals)-delta_x*0.1 + (i-1)*dose_grid_space ;
    X_after = [X_after,x_after_data];
end
Y_after = [];  % �������ǰ����
for i= 1:sizeI_doseArray_after(1)
    y_after_data = max(yDoseVals)+delta_y*0.1 - (i-1)*dose_grid_space ;
    Y_after = [Y_after,y_after_data];
end
Z_after = [];  % �������ǰ����
for i= 1:sizeI_doseArray_after(3)
    z_after_data = max(zDoseVals) - delta_z * 0.1 - (i-1)*dose_grid_space ;
    Z_after = [Z_after;z_after_data];
end

%% ���������ͼ��
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
