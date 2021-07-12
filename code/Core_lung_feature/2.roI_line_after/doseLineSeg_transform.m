function  [dose_line] = doseLineSeg_transform(planC,dose_value,structNum,doseArray_after,X_after,Y_after,Z_after);
% ����ȼ����߲�������mat�ļ�

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

%% �ѱ��κ��������ֵ������ǰ������ϵ��
[XI,YI,ZI] = meshgrid(xScanVals,yScanVals,zScanVals);
[XII,YII,ZII] = meshgrid(X_after,Y_after,Z_after);
VI = interp3(XII,YII,ZII,doseArray_after/256,XI,YI,ZI);

%% �������߸�ֵ
planC{1,4}(structNum) = planC{1,4}(2);            % ���Ӽ����ߣ��ȸ���ǰ���һ��

%% �������ݣ�����
planC{1,4}(structNum).roiNumber = structNum ;           % ����roi�ı��
planC{1,4}(structNum).structureName = ['dose',num2str(dose_value)];    % ����������
planC{1,4}(structNum).structureColor = planC{1,4}(2).structureColor;    % ��������ɫ

% ��contour��ֵ
len_s = size(scan3M);
for i =1:len_s(3)
    %% ��ȡһ��slicer���Ի��Ƽ����ȸ���
    c = [];
%     [c,h]=contourf(XI(:,:,i),YI(:,:,i),VI(:,:,i),'LevelList',[dose_value],'ShowText','on');  % ����ض���ֵ��
%     close;
    c=contourf(XI(:,:,i),YI(:,:,i),VI(:,:,i),'LevelList',[dose_value  dose_value]);
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
    dose_place = 0;
    for k = 1:length(d)-1
        if ((abs(d(k,1)-d(k+1,1)) > x_grid) & (abs(d(k,2)-d(k+1,2)) > y_grid)) | ((abs(d(k,1)-d(k+1,1)) > x_grid*10) | (abs(d(k,2)-d(k+1,2)> y_grid*10)))
            % ��roi���ظ�ֵ
            dose_place = [dose_place;k];
            j = j+1;
        end
    end
    dose_place = [dose_place;length(d)];
    % �𿪵ȼ������򲢴���planC
    for j1 = 1:j
        eval(['d',num2str(j1),'=','d(dose_place(j1)+1:dose_place(j1+1),:,:);']);
        eval(['planC{1,4}(structNum).contour(i).segments(j1).points',' = ','d',num2str(j1),';']);
    end
end

dose_line = planC{1,4}(structNum);

