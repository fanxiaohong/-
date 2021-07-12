%% 计算文件夹内所有单张图片的影像组学特征，只计算图片，没有mask
clc;
clear all;
close all;

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 超参数设置
dir_str = 'C:/Users/Administrator/Desktop/radiomics_code/'; % 总文件所谓在位置
file_way = [dir_str,'data/'] ;   %图片位置
paramFileName = [dir_str,'/json_set/roi_settings.json'];       % 定义参数文件位置
image_type = 'nomask' ;   % 图片的类型即文件夹名称covid或者noncovid
image_type1 = 'image';  % 所用的方法
save_mode = 1 ;          % 保存模式，1保存，其余不保存
data_kind = 255 ;          % labelme为255，unet为1，计算图像为mask=1的地方
save_file = [dir_str,'/result/',image_type,'_',image_type1,'.xlsx'] ;
figure_mode = 0  ;       % 图像模式，1为画图验证，其他未不画图
image_thick = 1   ;      % 单层图片计算纹理特征
zValsV1 = 0;             % z值坐标个数
PixelSpacingX1 = 0.1;    % 设置网格尺寸并按图片尺寸设计三维空间坐标
PixelSpacingY1 = 0.1;
PixelSpacingZ1 = 0.1;

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % 读取mask文件夹内所有文件名
% mask_file_name = [file_way,image_type,'/',image_type1,'/整合60张'];
% fileFolder=fullfile(mask_file_name);   % 读取文件夹内所有文件名
% dirOutput=dir(fullfile(fileFolder,'*.png'));
% fileNames={dirOutput.name}';
% 读取图片文件夹内所有文件名
image_file_name = [file_way,image_type,'_',image_type1];
fileFolder_image=fullfile(image_file_name);   % 读取文件夹内所有文件名
dirOutput=dir(fullfile(fileFolder_image,'*.png'));
fileNames={dirOutput.name}';

% 从json文件提取参数
paramS = getRadiomicsParamTemplate(paramFileName);  % 读取参数文件

% 循环计算文件夹内所有图片的纹理特征值
feat_all = [] ; % 创建存放所有图片纹理特征值的矩阵
for i =  1 : length(fileNames)
    image_name_split = strsplit(char(fileNames(i)),'.') ;   % 把当前的文件名用.隔开
    image_order = char(image_name_split(1)) ;  % 当前图片顺序号
%     mask_name = [mask_file_name,'/',image_order,'.png'];   % 读取mask文件的名称
    image_name = [image_file_name,'/',image_order,'.png'];   % 读取image文件的名称
%     mask=imread(mask_name)/data_kind;  % 读取图片
    image=imread(image_name);  % 读取图片
    image_size1 = size(image);
    if length(image_size1)==3
        image = rgb2gray(image); 
    end

    % 创建图像平面空间
    [m,n]=size(image);       % 读取图片尺寸
    volOrig3M = zeros(m,n,image_thick);    % 创建同等尺寸的三维矩阵
    volOrig3M(:,:,image_thick) = image ;       % 把读取的图片数据存为三维矩阵

    % 创建图像mask平面空间
    mask= uint8(ones(m,n));     % 创建mask
    [m1,n1]=size(mask);       % 读取图片尺寸
    maskBoundingBox3M = zeros(m1,n1,image_thick);    % 创建同等尺寸的三维矩阵
    maskBoundingBox3M(:,:,image_thick) = mask ;       % 把读取的图片数据存为三维矩阵

    % 设置网格尺寸并按图片尺寸设计三维空间坐标
    xValsV1 = [0:PixelSpacingX1:(m-1)*PixelSpacingX1];
    yValsV1 = [0:PixelSpacingY1:(n-1)*PixelSpacingY1];
    VoxelVol1 = PixelSpacingX1*PixelSpacingY1*PixelSpacingZ1*1000; % convert cm to mm

    % 创建gridS,网格结构体
    gridS = struct ;
    gridS.xValsV = xValsV1 ;
    gridS.yValsV = yValsV1 ;
    gridS.zValsV = zValsV1 ;
    gridS.PixelSpacingV = [PixelSpacingX1,PixelSpacingZ1,PixelSpacingZ1] ;

    % 纹理特征计算  
    featureS = calcRadiomicsForImgType_covid19(volOrig3M,maskBoundingBox3M,paramS,gridS);
    feat_all = [feat_all,featureS] ;   % 组装所有图片的纹理特征值
end

%% 保存数据
if save_mode ==1   % 判断是否保存数据,1为保存，其余不保存
%     dlmwrite(save_file,feat_all,'precision','%6.8f');
    clm_data = ['B',num2str(3)];     % 把特征名称写入excel文件
    xlswrite(save_file,feat_all,image_type1,clm_data);
end

%% 打印出图片测试分割效果
if figure_mode ==1 % 画图模式，1为画图，其余为不画图
    mask_location = find(mask(:,:)==0);  % 找到标签所在的位置
    mask_location1 = find(mask(:,:)==1);  % 
    c = image ; % 赋值一份图像，用于叠加mask，只显示mask内lung图像
    d = image ; 
    figure()
    c(mask_location) = 0 ;
    d(mask_location1) = 0 ;
    subplot(2,2,1);imshow(image)
    subplot(2,2,2);imshow(mask,[])
    subplot(2,2,3);imshow(c)
    subplot(2,2,4);imshow(d)
end

