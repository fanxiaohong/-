function [lungRoiArray,scanInterpArray,X_after,Y_after,Z_after,x_grid,y_grid] = scan_lung_interp_plan_simplify(planC,structNum,...
    delete_grid,image_grid_space_xy,image_grid_space_z,gird_num_incerp_z,lung_mask,lung_start,lung_end,strName);
% ��׼���ȡ����dcm�ļ��ع�������

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

% ��ȡ��������׼���3ά����;
X_after = [];  % �������ǰ����
for i= 1:512
    x_after_data = min(xScanVals)+delete_grid*image_grid_space_xy*0.1 + (i-1)*image_grid_space_xy*0.1 ;
    X_after = [X_after,x_after_data];
end
Y_after = [];  % �������ǰ����
for i= 1:512
    y_after_data = max(yScanVals) -delete_grid*image_grid_space_xy*0.1- (i-1)*image_grid_space_xy*0.1 ;
    Y_after = [Y_after,y_after_data];
end
Z_after = [];  % �������ǰ����
for i= 1:(gird_num_incerp_z+1)
    z_after_data = max(zScanVals)  - (i-1)*image_grid_space_z*0.1 ;
    Z_after = [Z_after;z_after_data];
end
Z_after = Z_after(end:-1:1) ;  % ���굹��

% ��ͼ���������������
[XI,YI,ZI] = meshgrid(xScanVals,yScanVals,zScanVals);
[XII,YII,ZII] = meshgrid(X_after,Y_after,Z_after);
VI = interp3(XI,YI,ZI,double(scan3M),XII,YII,ZII);    % ͨ����ֵ�õ���Ӧ���ƺ�ļƻ�ͼ�����
VI = uint16(VI) ;          % ת��Ϊͬһ����ֵ����

% �Ѹ��ĺ��ͼ��������ݴ���ƻ�mat�ļ���
planC{1,3}.scanArray = VI;
planC{1,3}.uniformScanInfo.sliceThickness =  image_grid_space_z*0.1;
planC{1,3}.uniformScanInfo.grid1Units = image_grid_space_xy*0.1 ;
planC{1,3}.uniformScanInfo.grid2Units = image_grid_space_xy*0.1 ; 
planC{1,3}.uniformScanInfo.sliceNumInf = gird_num_incerp_z ;
planC{1,3}.uniformScanInfo.firstZValue = Z_after(1) ;
 
% �ѵ�һ���������ݸ���Ϊ��ֵ������
planC{1,3}.scanInfo(1).grid1Units = image_grid_space_xy*0.1 ;
planC{1,3}.scanInfo(1).grid2Units = image_grid_space_xy*0.1 ;
planC{1,3}.scanInfo(1).sliceThickness = image_grid_space_z*0.1 ;
planC{1,3}.scanInfo(1).voxelThickness = planC{1,3}.scanInfo(1).sliceThickness ;
for i =1:gird_num_incerp_z
    planC{1,3}.scanInfo(i) = planC{1,3}.scanInfo(1);
    planC{1,3}.scanInfo(i).imageNumber = i ;
    planC{1,3}.scanInfo(i).zValue = Z_after(i) ;
end

%% ��ȡlung�ָ��߲�����ֵ
ROI_contour = {planC{indexS.structures}.contour};
strC = {planC{indexS.structures}.structureName};
structNum1 = getMatchingIndex(strName,strC,'exact');
scanNum = getStructureAssociatedScan(structNum1 , planC);

% ����õ�mask��ά����mask������image��ά����
[rasterSegments, planC] = getRasterSegments(structNum1,planC);
[mask3M]  = rasterToMask(rasterSegments, scanNum, planC);   % ����mask��lung��ROI���ڵ�slicer
[XI_lung,YI_lung,ZI_lung] = meshgrid(xScanVals,yScanVals,zScanVals(lung_start:lung_end));
lungRoiArray = interp3(XI_lung,YI_lung,ZI_lung,double(mask3M),XII,YII,ZII);    % ͨ����ֵ�õ���Ӧ���ƺ�ļƻ�ͼ�����

% �������߸�ֵ
planC{1,4}(structNum) = planC{1,4}(2);            % ���Ӽ����ߣ��ȸ���ǰ���һ��
% �������ݣ�����
planC{1,4}(structNum).roiNumber = structNum ;           % ����roi�ı��
planC{1,4}(structNum).structureName = ['lung_seg'];    % ������
planC{1,4}(structNum).structureColor = planC{1,4}(18).structureColor;    % ��������ɫ

%% ��contour��ֵ
len_s = size(VI);
for i =1:len_s(3)
    % ��ȡһ��slicer���Ի��Ƽ����ȸ���
    c = [];
%     [c,h]=contourf(XII(:,:,i),YII(:,:,i),lungRoiArray(:,:,i),'LevelList',[lung_mask],'ShowText','on');  % ����ض���ֵ��
%     close;
    c=contourf(XII(:,:,i),YII(:,:,i),lungRoiArray(:,:,i),'LevelList',[lung_mask  lung_mask]); 
    len = length(c);
    c_add = zeros(1,len-1);
    c_add(1,:) = Z_after(i);
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

lungRoiArray = planC{1,4}(structNum);    % ���roi�ṹ
scanInterpArray = planC{1,3};            % �����ֵ���image������Ϣ����������д��mat�ļ�
