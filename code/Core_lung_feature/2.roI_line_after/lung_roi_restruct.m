function [lungRoiArray] = lung_roi_restruct(planC,structNum,num_image_lungSeg,str_lungSeg,lung_mask,seg_linename);
% ����lung�ָ��߲�������mat�ļ�

% ��ӡһ��Ŀ¼
indexS = planC{end};        % plan�е�����

%% ��ȡɨ�����CT����X,Y,Z
scanNum = 1;
planC{indexS.scan}(scanNum);
sliceNum = 1;
planC{indexS.scan}(scanNum).scanInfo(sliceNum);
[xScanVals, yScanVals, zScanVals] = getScanXYZVals(planC{indexS.scan}(scanNum));
x_grid = ceil((max(xScanVals)-min(xScanVals(2)))/length(xScanVals))/10;
y_grid = ceil((max(yScanVals)-min(yScanVals(2)))/length(yScanVals))/10;
scan3M = getScanArray(scanNum,planC); 

%% ��ȡ�β��ָ��ͼƬ�ع���ά����
str1 = strcat(str_lungSeg,num2str(1),'.bmp');
lung_roi = double(imread(str1));
% ��������Ϣ�������
lungRoiArray = zeros(size(lung_roi, 1), size(lung_roi, 2),num_image_lungSeg,'double') ; % �������κ�dose4ά����
for i = 1 : num_image_lungSeg
    str1 = strcat(str_lungSeg,num2str(i),'.bmp');
    lung_roi = imread(str1);
    % ��������Ϣ�������
    lungRoiArray(:,:,i) = lung_roi;
end
sizeI_lungRoiArray = size(lungRoiArray);

%% �ѷβ��ָ�ROI��Ӧ��ͼ������ϵ��
[XI,YI,ZI] = meshgrid(xScanVals,yScanVals,zScanVals);
VI = lungRoiArray;

%% �������߸�ֵ
planC{1,4}(structNum) = planC{1,4}(2);            % ���Ӽ����ߣ��ȸ���ǰ���һ��

%% �������ݣ�����
planC{1,4}(structNum).roiNumber = structNum ;           % ����roi�ı��
planC{1,4}(structNum).structureName = ['lung_seg'];    % ������
planC{1,4}(structNum).structureColor = planC{1,4}(18).structureColor;    % ��������ɫ

%% ��contour��ֵ
len_s = size(scan3M);
for i =1:len_s(3)
    %% ��ȡһ��slicer���Ի��Ƽ����ȸ���
    c = [];
%     [c,h]=contourf(XI(:,:,i),YI(:,:,i),VI(:,:,num_image_lungSeg+1-i),'LevelList',[lung_mask],'ShowText','on');  % ����ض���ֵ��
%     close;
    c=contourf(XI(:,:,i),YI(:,:,i),VI(:,:,num_image_lungSeg+1-i),'LevelList',[lung_mask lung_mask]); 
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
    place = 0;
    for k = 1:length(d)-1
        if ((abs(d(k,1)-d(k+1,1)) > x_grid) & (abs(d(k,2)-d(k+1,2)) > y_grid)) | ((abs(d(k,1)-d(k+1,1)) > x_grid*10) | (abs(d(k,2)-d(k+1,2)> y_grid*10)))
            % ��roi���ظ�ֵ
            place = [place;k];
            j = j+1;
        end
    end
    place = [place;length(d)];
    % �𿪵ȼ������򲢴���planC
    for j1 = 1:j
        eval(['d',num2str(j1),'=','d(place(j1)+1:place(j1+1),:,:);']);
        eval(['planC{1,4}(structNum).contour(i).segments(j1).points',' = ','d',num2str(j1),';']);
    end
end

lungRoiArray = planC{1,4}(structNum);

