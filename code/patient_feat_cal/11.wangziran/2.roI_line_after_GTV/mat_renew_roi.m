function [planC,save_file] = mat_renew_roi(roi_name,roi_x,roi_y,roi_z,lung_mask,image_grid_space_xyplan,...
    image_grid_space_zplan,num_image,str_tranform_roi,filename);
% ��roi_segд��mat�ļ�

%% ·�����Ƹ�ֵ
save_file = [filename,'_',roi_name];          % �����ļ�
% ����mat�ļ���planC
m = matfile(filename);
global planC 
planC = m.planC;
indexS = planC{end};        % plan�е�����

%% ��ȡ��������׼���3άdose����;
roiArray_after = [];

%% �ж�num_imageҲ������׼��doseͼƬ������������ȡ�ع��ķ�ʽ
str1 = strcat(str_tranform_roi,'IMG000',num2str(1),'.dcm');
roi_transform = dicomread(str1);
dcm_information_after = dicominfo(str1);  %��ʾͼ��Ĵ洢��Ϣ
roiArray_after = ones(size(roi_transform, 1), size(roi_transform, 2),num_image,'double') ; % �������κ�dose4ά����
% num_image������10��99֮��
if  num_image >= 10 && num_image <100
    for i =1:9
        str1 = strcat(str_tranform_roi,'IMG000',num2str(i),'.dcm');
        roi_transform = dicomread(str1);
        dcm_information_after = dicominfo(str1);  %��ʾͼ��Ĵ洢��Ϣ
        roiArray_after(:,:,i) = roi_transform;
    end
    for i = 10:num_image
        str1 = strcat(str_tranform_roi,'IMG00',num2str(i),'.dcm');
        roi_transform = dicomread(str1);
        dcm_information_after = dicominfo(str1);  %��ʾͼ��Ĵ洢��Ϣ
        roiArray_after(:,:,i) = roi_transform;
    end
end

sizeI_roiArray_after = size(roiArray_after);

%% �ѱ��κ������������ϵת��Ϊ��ͼ������ϵ
X_after = [];  % �������ǰ����
for i= 1:sizeI_roiArray_after(2)
    x_after_data = -roi_x*0.1 + (i-1)*image_grid_space_xyplan*0.1 ;
    X_after = [X_after,x_after_data];
end
Y_after = [];  % �������ǰ����
for i= 1:sizeI_roiArray_after(1)
    y_after_data = roi_y*0.1 - (i-1)*image_grid_space_xyplan*0.1 ;
    Y_after = [Y_after,y_after_data];
end
Z_after = [];  % �������ǰ����
for i= 1:sizeI_roiArray_after(3)
    z_after_data = -roi_z * 0.1 - (i-1)*image_grid_space_zplan*0.1 ;
    Z_after = [Z_after;z_after_data];
end

%% �ѱ��κ�roi����ֵ������ǰ������ϵ��
% ��ȡɨ�����CT����X,Y,Z
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

%% �ָ�roi�߲�����ԭ��
ROI_contour = {planC{indexS.structures}.contour};
strC = {planC{indexS.structures}.structureName};
structNum1 = length(planC{1,4})+1;

% ��roi�߸�ֵ
planC{1,4}(structNum1) = planC{1,4}(2);            % ���Ӽ����ߣ��ȸ���ǰ���һ��
% �������ݣ�����
planC{1,4}(structNum1).roiNumber = structNum1 ;           % ����roi�ı��
planC{1,4}(structNum1).structureName = [roi_name];    % ����������
planC{1,4}(structNum1).structureColor = planC{1,4}(2).structureColor;    % ��������ɫ


%% ��contour��ֵ
len_s = size(VI);
for i =1:len_s(3)
    %% ��ȡһ��slicer���Ի��Ƽ����ȸ���
    c = [];
    c=contourf(XI(:,:,i),YI(:,:,i),VI(:,:,i),'LevelList',[lung_mask  lung_mask]);
    len = length(c);
    c_add = zeros(1,len-1);
    c_add(1,:) = zScanVals(i);
    c = [c(:,2:end);c_add]';    % cΪ20���30�ȸ��ߵ���ά����
    
    d = [];
    m = 1;   % ��һ��ɸѡ��ȥ��������
    for n = 1:len-2
        if ((abs(c(n,1)-c(n+1,1)) < x_grid) | (abs(c(n,2)-c(n+1,2)) < y_grid))
            d(m,1) = c(n,1);
            d(m,2) = c(n,2);
            d(m,3)= c(n,3);
            m = m+1;
        end
    end
    % ��������һ��
    if ((abs(c(n,1)-c(n+1,1)) < x_grid) | (abs(c(n,2)-c(n+1,2)) < y_grid))
        d(m,1) = c(n+1,1);
        d(m,2) = c(n+1,2);
        d(m,3)= c(n+1,3);
    end

    % �ѵȸ��߷ֿ�
    j = 1;  % һ�ŵȸ�����һ�����򣬳�ʼΪ1
    roi_place = 0;
    for k = 1:length(d)-1
        if ((abs(d(k,1)-d(k+1,1)) > x_grid) & (abs(d(k,2)-d(k+1,2)) > y_grid)) | ((abs(d(k,1)-d(k+1,1)) > x_grid*10) | (abs(d(k,2)-d(k+1,2)> y_grid*10)))
            % ��roi���ظ�ֵ
            roi_place = [roi_place;k];
            j = j+1;
        end
    end
    roi_place = [roi_place;length(d)];
    % �𿪵ȼ������򲢴���planC
    for j1 = 1:j
        eval(['d',num2str(j1),'=','d(roi_place(j1)+1:roi_place(j1+1),:,:);']);
        eval(['planC{1,4}(structNum1).contour(i).segments(j1).points',' = ','d',num2str(j1),';']);
    end
end

roi_line = planC{1,4}(structNum1);
planC{indexS.structures}(structNum1) = roi_line;
[segmentsM] = doseRoiRasterSeg(structNum1,planC);
planC{indexS.structures}(structNum1).rasterSegments = segmentsM;