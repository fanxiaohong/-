clc;
clear all;
close all;

%% 超参数，读入mat文件，mat.bz2压缩过的不行
str = 'E:\roi_feat_dose\' ;
patient_name = '1.zhouzhengyuan' ;   %  病人名称
data_time = '190611';    % 对应病人的一个治疗时间，为了读取该文件夹下的plan的mat文件
plan_time = '190505';    % 对应病人的计划时间
roi_name = 'GTV';
roi_start = 9   ; %  roi在plan对应的起始slicer
num_image = 46 ;

%% roi图片生成函数
roi_image_creat(str,patient_name,data_time,plan_time,roi_name,roi_start);

%% 把roi图片写入对应的dcm文件，使其含有坐标信息，为了后续配准使用
roi_dcm_creat(str,patient_name,roi_name,num_image);

