%% �����ļ��������е���ͼƬ��Ӱ����ѧ������ֻ����ͼƬ��û��mask
clc;
clear all;
close all;

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ����������
dir_str = 'C:/Users/Administrator/Desktop/radiomics_code/'; % ���ļ���ν��λ��
file_way = [dir_str,'data/'] ;   %ͼƬλ��
paramFileName = [dir_str,'/json_set/roi_settings.json'];       % ��������ļ�λ��
image_type = 'nomask' ;   % ͼƬ�����ͼ��ļ�������covid����noncovid
image_type1 = 'image';  % ���õķ���
save_mode = 1 ;          % ����ģʽ��1���棬���಻����
data_kind = 255 ;          % labelmeΪ255��unetΪ1������ͼ��Ϊmask=1�ĵط�
save_file = [dir_str,'/result/',image_type,'_',image_type1,'.xlsx'] ;
figure_mode = 0  ;       % ͼ��ģʽ��1Ϊ��ͼ��֤������δ����ͼ
image_thick = 1   ;      % ����ͼƬ������������
zValsV1 = 0;             % zֵ�������
PixelSpacingX1 = 0.1;    % ��������ߴ粢��ͼƬ�ߴ������ά�ռ�����
PixelSpacingY1 = 0.1;
PixelSpacingZ1 = 0.1;

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % ��ȡmask�ļ����������ļ���
% mask_file_name = [file_way,image_type,'/',image_type1,'/����60��'];
% fileFolder=fullfile(mask_file_name);   % ��ȡ�ļ����������ļ���
% dirOutput=dir(fullfile(fileFolder,'*.png'));
% fileNames={dirOutput.name}';
% ��ȡͼƬ�ļ����������ļ���
image_file_name = [file_way,image_type,'_',image_type1];
fileFolder_image=fullfile(image_file_name);   % ��ȡ�ļ����������ļ���
dirOutput=dir(fullfile(fileFolder_image,'*.png'));
fileNames={dirOutput.name}';

% ��json�ļ���ȡ����
paramS = getRadiomicsParamTemplate(paramFileName);  % ��ȡ�����ļ�

% ѭ�������ļ���������ͼƬ����������ֵ
feat_all = [] ; % �����������ͼƬ��������ֵ�ľ���
for i =  1 : length(fileNames)
    image_name_split = strsplit(char(fileNames(i)),'.') ;   % �ѵ�ǰ���ļ�����.����
    image_order = char(image_name_split(1)) ;  % ��ǰͼƬ˳���
%     mask_name = [mask_file_name,'/',image_order,'.png'];   % ��ȡmask�ļ�������
    image_name = [image_file_name,'/',image_order,'.png'];   % ��ȡimage�ļ�������
%     mask=imread(mask_name)/data_kind;  % ��ȡͼƬ
    image=imread(image_name);  % ��ȡͼƬ
    image_size1 = size(image);
    if length(image_size1)==3
        image = rgb2gray(image); 
    end

    % ����ͼ��ƽ��ռ�
    [m,n]=size(image);       % ��ȡͼƬ�ߴ�
    volOrig3M = zeros(m,n,image_thick);    % ����ͬ�ȳߴ����ά����
    volOrig3M(:,:,image_thick) = image ;       % �Ѷ�ȡ��ͼƬ���ݴ�Ϊ��ά����

    % ����ͼ��maskƽ��ռ�
    mask= uint8(ones(m,n));     % ����mask
    [m1,n1]=size(mask);       % ��ȡͼƬ�ߴ�
    maskBoundingBox3M = zeros(m1,n1,image_thick);    % ����ͬ�ȳߴ����ά����
    maskBoundingBox3M(:,:,image_thick) = mask ;       % �Ѷ�ȡ��ͼƬ���ݴ�Ϊ��ά����

    % ��������ߴ粢��ͼƬ�ߴ������ά�ռ�����
    xValsV1 = [0:PixelSpacingX1:(m-1)*PixelSpacingX1];
    yValsV1 = [0:PixelSpacingY1:(n-1)*PixelSpacingY1];
    VoxelVol1 = PixelSpacingX1*PixelSpacingY1*PixelSpacingZ1*1000; % convert cm to mm

    % ����gridS,����ṹ��
    gridS = struct ;
    gridS.xValsV = xValsV1 ;
    gridS.yValsV = yValsV1 ;
    gridS.zValsV = zValsV1 ;
    gridS.PixelSpacingV = [PixelSpacingX1,PixelSpacingZ1,PixelSpacingZ1] ;

    % ������������  
    featureS = calcRadiomicsForImgType_covid19(volOrig3M,maskBoundingBox3M,paramS,gridS);
    feat_all = [feat_all,featureS] ;   % ��װ����ͼƬ����������ֵ
end

%% ��������
if save_mode ==1   % �ж��Ƿ񱣴�����,1Ϊ���棬���಻����
%     dlmwrite(save_file,feat_all,'precision','%6.8f');
    clm_data = ['B',num2str(3)];     % ����������д��excel�ļ�
    xlswrite(save_file,feat_all,image_type1,clm_data);
end

%% ��ӡ��ͼƬ���Էָ�Ч��
if figure_mode ==1 % ��ͼģʽ��1Ϊ��ͼ������Ϊ����ͼ
    mask_location = find(mask(:,:)==0);  % �ҵ���ǩ���ڵ�λ��
    mask_location1 = find(mask(:,:)==1);  % 
    c = image ; % ��ֵһ��ͼ�����ڵ���mask��ֻ��ʾmask��lungͼ��
    d = image ; 
    figure()
    c(mask_location) = 0 ;
    d(mask_location1) = 0 ;
    subplot(2,2,1);imshow(image)
    subplot(2,2,2);imshow(mask,[])
    subplot(2,2,3);imshow(c)
    subplot(2,2,4);imshow(d)
end

