function  [dose_line] = doseLineSeg_transform(planC,dose_value,structNum,doseArray_after,X_after,Y_after,Z_after);
% 计算等剂量线并保存入mat文件

% 打印一下目录
indexS = planC{end};        % plan有的内容

%% 读取扫描矩阵及CT坐标X,Y,Z
scanNum = 1;
planC{indexS.scan}(scanNum);
sliceNum = 1;
planC{indexS.scan}(scanNum).scanInfo(sliceNum);
[xScanVals, yScanVals, zScanVals] = getScanXYZVals(planC{indexS.scan}(scanNum));
x_grid = ceil((max(xScanVals)-min(xScanVals(2)))/length(xScanVals))/10;
y_grid = ceil((max(yScanVals)-min(yScanVals(2)))/length(yScanVals))/10;
scan3M = getScanArray(scanNum,planC); 

%% 把变形后剂量场插值到变形前的坐标系内
[XI,YI,ZI] = meshgrid(xScanVals,yScanVals,zScanVals);
[XII,YII,ZII] = meshgrid(X_after,Y_after,Z_after);
VI = interp3(XII,YII,ZII,doseArray_after/256,XI,YI,ZI);

%% 给剂量线赋值
planC{1,4}(structNum) = planC{1,4}(2);            % 增加剂量线，先复制前面的一条

%% 更改内容，四项
planC{1,4}(structNum).roiNumber = structNum ;           % 更改roi的编号
planC{1,4}(structNum).structureName = ['dose',num2str(dose_value)];    % 剂量线命名
planC{1,4}(structNum).structureColor = planC{1,4}(2).structureColor;    % 剂量线颜色

% 给contour赋值
len_s = size(scan3M);
for i =1:len_s(3)
    %% 抽取一张slicer测试绘制剂量等高线
    c = [];
%     [c,h]=contourf(XI(:,:,i),YI(:,:,i),VI(:,:,i),'LevelList',[dose_value],'ShowText','on');  % 输出特定等值线
%     close;
    c=contourf(XI(:,:,i),YI(:,:,i),VI(:,:,i),'LevelList',[dose_value  dose_value]);
    len = length(c);
    c_add = zeros(1,len-1);
    c_add(1,:) = zScanVals(i);
    c = [c(:,2:end);c_add]';    % c为20层的30等高线的三维矩阵
    
    d = [];
    m = 1;   % 第一次筛选，去掉独立点
    for n = 1:len-2
        if ((abs(c(n,1)-c(n+1,1)) < x_grid) | (abs(c(n,2)-c(n+1,2)) < y_grid))
            d(m,1) = c(n,1);
            d(m,2) = c(n,2);
            d(m,3)= c(n,3);
            m = m+1;
        end
    end
    % 补上最有一行
    if ((abs(c(n,1)-c(n+1,1)) < x_grid) | (abs(c(n,2)-c(n+1,2)) < y_grid))
        d(m,1) = c(n+1,1);
        d(m,2) = c(n+1,2);
        d(m,3)= c(n+1,3);
    end

    % 把等高线分开
    j = 1;  % 一张等高线有一个区域，初始为1
    dose_place = 0;
    for k = 1:length(d)-1
        if ((abs(d(k,1)-d(k+1,1)) > x_grid) & (abs(d(k,2)-d(k+1,2)) > y_grid)) | ((abs(d(k,1)-d(k+1,1)) > x_grid*10) | (abs(d(k,2)-d(k+1,2)> y_grid*10)))
            % 给roi边沿赋值
            dose_place = [dose_place;k];
            j = j+1;
        end
    end
    dose_place = [dose_place;length(d)];
    % 拆开等剂量区域并存入planC
    for j1 = 1:j
        eval(['d',num2str(j1),'=','d(dose_place(j1)+1:dose_place(j1+1),:,:);']);
        eval(['planC{1,4}(structNum).contour(i).segments(j1).points',' = ','d',num2str(j1),';']);
    end
end

dose_line = planC{1,4}(structNum);

