% ���ͼƬ����ͼ�ĻҶȹ�������
clc;
clear all;
close all;

Label=[1,1,1,1,1,0,0,0,1,0,0,0,0,0,1,1,1,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,  0,1,1,1,0,1,1,0,0,0,0,0] ;   % norm_pca�޼ල����
image_str = 'E:\\roi_feat_dose\\code\\data_analysis\\python\\Code_classification\\' ;   % ͼƬ��ŵ�λ��
image_type = 'image40\\'   ;    % ͼƬ���ͣ�20,30�ߴ�
image_mode = {'mean','std','max','min','median'} ;  % ͼƬ���׵�ģʽ
result_mode = {'contrast','homogeneity','correlation','energy'} ; % ָ���ģʽ
image_num = 42  ;   % ѵ��ͼƬ������

% ѭ������ѵ������
sheet_name = 'train' ;   % �洢�ı����
train_label = Label(1:image_num)' ;   % �ָ�ѵ����label
[train_acc_all] = acc_cal_glcm(image_str,image_type,sheet_name,image_num,train_label,image_mode,result_mode)

% ѭ��������Լ���
sheet_name = 'test' ;   % �洢�ı����
test_label = Label((image_num+1):end)' ;   % �ָ�ѵ����label
[test_acc_all] = acc_cal_glcm(image_str,image_type,sheet_name,(length(Label)-image_num),test_label,image_mode,...
    result_mode)


    