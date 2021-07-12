% ���ͼƬ����ͼ�ĻҶȹ�������
clc;
clear all;
close all;

Label=[1,1,1,1,1,0,0,0,1,0,0,0,0,0,1,1,1,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,1,1,0,1,1,0,0,0,0,0] ;   % norm_pca�޼ල����
image_str = 'E:\\roi_feat_dose\\code\\data_analysis\\python\\Code_classification\\image20\\' ;   % ͼƬ��ŵ�λ��
image_mode = {'mean','std','max','min','median'} ;  % ͼƬ���׵�ģʽ
image_num = 42  ;   % ѵ��ͼƬ������

% ��ȡ��ǩͼƬ
result_acc = [] ;
for i = 1:length(image_mode)
    image_name0 = [image_str,'label\\label_0_',char(image_mode(i)),'.png'] ;
    image_name1 = [image_str,'label\\label_1_',char(image_mode(i)),'.png'] ;
    IMG0 = imread(image_name0);
    IMG1 = imread(image_name1);
    I0 = rgb2gray(IMG0);
    I1 = rgb2gray(IMG1);

    %% ѭ������ѵ������
    train_label = Label(1:image_num)' ;   % �ָ�ѵ����label
    file_name = 'train' ; 
    [train_acc,train_all] = train_acc_cal(image_str,file_name,I0,I1,image_num,train_label) ;
    % disp(['train acc:',num2str(train_acc)]);

    % ѭ��������Լ���
    test_label = Label(image_num+1:end)' ;   % �ָ�ѵ����label
    file_name = 'test' ; 
    [test_acc,test_all] = train_acc_cal(image_str,file_name,I0,I1,(length(Label)-image_num),test_label) ;
    % disp(['test acc:',num2str(test_acc)]); 
    result_acc = [result_acc;train_acc,test_acc];  % ������е�acc
end

    