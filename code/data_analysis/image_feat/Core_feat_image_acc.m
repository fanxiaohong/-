% 读取结果
clc;
clear all;
close all;

%%  超参数设置
Label=[1,1,1,1,1,0,0,0,1,0,0,0,0,0,1,1,1,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,  0,1,1,1,0,1,1,0,0,0,0,0] ;   % norm_pca无监督聚类
result_str = 'E:\roi_feat_dose\code\data_analysis\python\Code_classification\';
image_mode = {'mean','std','max','min','median'} ;  % 图片基底的模式
result_mode = {'SSIM','COSIN','HIS','MIE'} ; % 指标的模式
data_str = [result_str,'result1.xlsx'];
image_shape = '20'   ;  % 图片尺寸
image_num = 42  ;   % 训练图片的数量
label_kind =  2 ;   % 标签种类

%% 训练集合
sheet_name = ['train',image_shape] ;
train_label = Label(1:image_num)' ;   % 分割训练的label
[train_acc] = acc_cal(data_str,sheet_name,image_num,train_label,image_mode,result_mode,label_kind)
% 测试集合
sheet_name = ['test',image_shape] ;
image_num_test = length(Label)-image_num;  % 训练图片的数量
test_label = Label(image_num+1:end)' ;   % 分割训练的label
[test_acc] = acc_cal(data_str,sheet_name,image_num_test,test_label,image_mode,result_mode,label_kind)


