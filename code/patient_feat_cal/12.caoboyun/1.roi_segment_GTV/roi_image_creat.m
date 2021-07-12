function  roi_image_creat(str,patient_name,data_time,plan_time,roi_name,roi_start);
% roi图片生成函数

save_str = [str,'data\',patient_name,'\original\roi_segment\'];  % roi分割图片的存储位置
file_name = [roi_name,'_plan'] ;  % 对应roi的文件名，用于存放label图片
filename = [str,'plan\',patient_name,'\',data_time,'\planC',plan_time,'.mat'];

%% 判断是否存在文件夹，没有则创建
sec_path = [save_str, file_name,'\'];
if ~exist(sec_path,'file')
    mkdir([save_str, file_name]);
end

%% 载入mat文件，planC
m = matfile(filename);
global planC 
planC = m.planC;
indexS = planC{end};        % plan有的内容
planC{indexS.structures};

% Initialize scan vector
ROI_contour = {planC{indexS.structures}.contour};
strC = {planC{indexS.structures}.structureName};
structNum = getMatchingIndex(roi_name,strC,'exact');
scanNum = getStructureAssociatedScan(structNum , planC);

%% 处理得到mask三维矩阵及mask区域内image三维矩阵
[rasterSegments, planC, isError] = getRasterSegments(structNum,planC);
[mask3M, uniqueSlices]  = rasterToMask(rasterSegments, scanNum, planC);   % 读出mask和lung的ROI所在的slicer
scanArray3M = getScanArray(planC{indexS.scan}(scanNum));
scanArray3M = double(scanArray3M) - planC{indexS.scan}(scanNum).scanInfo(1).CTOffset;    
SUVvals3M = mask3M.*double(scanArray3M(:,:,uniqueSlices));
[minr, maxr, minc, maxc, mins, maxs]= compute_boundingbox(mask3M);
maskBoundingBox3M = mask3M(minr:maxr,minc:maxc,mins:maxs);
volToEval = SUVvals3M(minr:maxr,minc:maxc,mins:maxs);

%% 循环存储mask图片，label
size_mask = size(mask3M) ;
for i = 1:size_mask(3)
%     mask3M20 = mask3M(:,:,15);          % ROI内图像
    mask3M_slicer = mat2gray(double(mask3M(:,:,i)));
    imageName=strcat('label_',num2str(i+roi_start-1),'.bmp');
    imageName = [save_str,file_name,'\',imageName];
    imwrite(mask3M_slicer,imageName)
end

%% 根据扫描矩阵一层数据画出一张图验证。
% mask3M20 = mask3M(:,:,10);          % ROI内图像
% volToEval_s20 = volToEval(:,:,20);  % ROI内图像
% % 转换数据为double
% A=double(mask3M20);
% C=mat2gray(A);
% figure;imshow(C, 'DisplayRange',[]);