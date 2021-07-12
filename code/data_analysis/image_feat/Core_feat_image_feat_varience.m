% 求解图片特征图的灰度共生矩阵
clc;
clear all;
close all;

Label=[1,1,1,1,1,0,0,0,1,0,0,0,0,0,1,1,1,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,1,1,0,1,1,0,0,0,0,0] ;   % norm_pca无监督聚类
image_str = 'E:\\roi_feat_dose\\code\\data_analysis\\python\\Code_classification\\image20\\' ;   % 图片存放的位置
image_mode = {'mean','std','max','min','median'} ;  % 图片基底的模式
image_num = 42  ;   % 训练图片的数量

% 读取标签图片
result_acc = [] ;
for i = 1:length(image_mode)
    image_name0 = [image_str,'label\\label_0_',char(image_mode(i)),'.png'] ;
    image_name1 = [image_str,'label\\label_1_',char(image_mode(i)),'.png'] ;
    IMG0 = imread(image_name0);
    IMG1 = imread(image_name1);
    I0 = rgb2gray(IMG0);
    I1 = rgb2gray(IMG1);

    %% 循环计算训练集合
    train_label = Label(1:image_num)' ;   % 分割训练的label
    file_name = 'train' ; 
    [train_acc,train_all] = train_acc_cal(image_str,file_name,I0,I1,image_num,train_label) ;
    % disp(['train acc:',num2str(train_acc)]);

    % 循环计算测试集合
    test_label = Label(image_num+1:end)' ;   % 分割训练的label
    file_name = 'test' ; 
    [test_acc,test_all] = train_acc_cal(image_str,file_name,I0,I1,(length(Label)-image_num),test_label) ;
    % disp(['test acc:',num2str(test_acc)]); 
    result_acc = [result_acc;train_acc,test_acc];  % 输出所有的acc
end

    