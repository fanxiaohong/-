% ��ȡ���
clc;
clear all;
close all;

%%  ����������
Label=[1,1,1,1,1,0,0,0,1,0,0,0,0,0,1,1,1,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,  0,1,1,1,0,1,1,0,0,0,0,0] ;   % norm_pca�޼ල����
result_str = 'E:\roi_feat_dose\code\data_analysis\python\Code_classification\';
image_mode = {'mean','std','max','min','median'} ;  % ͼƬ���׵�ģʽ
result_mode = {'SSIM','COSIN','HIS','MIE'} ; % ָ���ģʽ
data_str = [result_str,'result1.xlsx'];
image_shape = '20'   ;  % ͼƬ�ߴ�
image_num = 42  ;   % ѵ��ͼƬ������
label_kind =  2 ;   % ��ǩ����

%% ѵ������
sheet_name = ['train',image_shape] ;
train_label = Label(1:image_num)' ;   % �ָ�ѵ����label
[train_acc] = acc_cal(data_str,sheet_name,image_num,train_label,image_mode,result_mode,label_kind)
% ���Լ���
sheet_name = ['test',image_shape] ;
image_num_test = length(Label)-image_num;  % ѵ��ͼƬ������
test_label = Label(image_num+1:end)' ;   % �ָ�ѵ����label
[test_acc] = acc_cal(data_str,sheet_name,image_num_test,test_label,image_mode,result_mode,label_kind)


