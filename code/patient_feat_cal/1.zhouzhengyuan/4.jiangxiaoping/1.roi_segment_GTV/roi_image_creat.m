function  roi_image_creat(str,patient_name,data_time,plan_time,roi_name,roi_start);
% roiͼƬ���ɺ���

save_str = [str,'data\',patient_name,'\original\roi_segment\'];  % roi�ָ�ͼƬ�Ĵ洢λ��
file_name = [roi_name,'_plan'] ;  % ��Ӧroi���ļ��������ڴ��labelͼƬ
filename = [str,'plan\',patient_name,'\',data_time,'\planC',plan_time,'.mat'];

%% �ж��Ƿ�����ļ��У�û���򴴽�
sec_path = [save_str, file_name,'\'];
if ~exist(sec_path,'file')
    mkdir([save_str, file_name]);
end

%% ����mat�ļ���planC
m = matfile(filename);
global planC 
planC = m.planC;
indexS = planC{end};        % plan�е�����
planC{indexS.structures};

% Initialize scan vector
ROI_contour = {planC{indexS.structures}.contour};
strC = {planC{indexS.structures}.structureName};
structNum = getMatchingIndex(roi_name,strC,'exact');
scanNum = getStructureAssociatedScan(structNum , planC);

%% ����õ�mask��ά����mask������image��ά����
[rasterSegments, planC, isError] = getRasterSegments(structNum,planC);
[mask3M, uniqueSlices]  = rasterToMask(rasterSegments, scanNum, planC);   % ����mask��lung��ROI���ڵ�slicer
scanArray3M = getScanArray(planC{indexS.scan}(scanNum));
scanArray3M = double(scanArray3M) - planC{indexS.scan}(scanNum).scanInfo(1).CTOffset;    
SUVvals3M = mask3M.*double(scanArray3M(:,:,uniqueSlices));
[minr, maxr, minc, maxc, mins, maxs]= compute_boundingbox(mask3M);
maskBoundingBox3M = mask3M(minr:maxr,minc:maxc,mins:maxs);
volToEval = SUVvals3M(minr:maxr,minc:maxc,mins:maxs);

%% ѭ���洢maskͼƬ��label
size_mask = size(mask3M) ;
for i = 1:size_mask(3)
%     mask3M20 = mask3M(:,:,15);          % ROI��ͼ��
    mask3M_slicer = mat2gray(double(mask3M(:,:,i)));
    imageName=strcat('label_',num2str(i+roi_start-1),'.bmp');
    imageName = [save_str,file_name,'\',imageName];
    imwrite(mask3M_slicer,imageName)
end

%% ����ɨ�����һ�����ݻ���һ��ͼ��֤��
% mask3M20 = mask3M(:,:,10);          % ROI��ͼ��
% volToEval_s20 = volToEval(:,:,20);  % ROI��ͼ��
% % ת������Ϊdouble
% A=double(mask3M20);
% C=mat2gray(A);
% figure;imshow(C, 'DisplayRange',[]);