% 求解图片特征图的灰度共生矩阵
clc;
clear all;
close all;

Label=[1,1,1,1,1,0,0,0,1,0,0,0,0,0,1,1,1,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,  0,1,1,1,0,1,1,0,0,0,0,0] ;   % norm_pca无监督聚类
image_str = 'E:\\roi_feat_dose\\code\\data_analysis\\python\\Code_classification\\' ;   % 图片存放的位置
image_type = 'image40\\'   ;    % 图片类型，20,30尺寸
image_mode = {'mean','std','max','min','median'} ;  % 图片基底的模式
result_mode = {'contrast','homogeneity','correlation','energy'} ; % 指标的模式
image_num = 42  ;   % 训练图片的数量

% 循环计算训练集合
sheet_name = 'train' ;   % 存储的表格名
train_label = Label(1:image_num)' ;   % 分割训练的label
[train_acc_all] = acc_cal_glcm(image_str,image_type,sheet_name,image_num,train_label,image_mode,result_mode)

% 循环计算测试集合
sheet_name = 'test' ;   % 存储的表格名
test_label = Label((image_num+1):end)' ;   % 分割训练的label
[test_acc_all] = acc_cal_glcm(image_str,image_type,sheet_name,(length(Label)-image_num),test_label,image_mode,...
    result_mode)


    