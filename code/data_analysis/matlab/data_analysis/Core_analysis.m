%% ��������ɸѡ��������
clc;
close all;
clear all;

%% ��������������Ҫ�Լ��趨������
silk_percent = 20;  % �������������仯��������
width = 5 ;         % ɸѡָ������������������������ֵ
data_limit = 500 ;  % �����仯����ֵ
data_place = 'lung' ; % ������������lung,����dose0-5
result_str = 'E:/roi_feat_dose/result/';
data_str = [result_str,'lung.xls'];   % ���ݴ��λ��
save_str = [result_str,'feat_choice_',data_place,'_',num2str(silk_percent),'perc.xls'];   % �������λ��
roi_num = 1;        % ROI�ĸ���

%%  ��һ�����˵ĳ�����,zhouzhengyuan
patient_name = ['1.zhouzhengyuan'];
datetime_num_hu = 5 ;   % CT���ڵĸ���
silk_data = 1 ;     % ����ʱ�������
% ��������ɸѡ������
[feat_num_hu,num_feature_hu,txt_hu] = data_filt(data_str,patient_name,roi_num,datetime_num_hu,...
    silk_data,silk_percent,width,data_limit);

%%  �ڶ������˵ĳ�����
patient_name = ['2.huhongjun'];
datetime_num_zhou = 7 ;   % CT���ڵĸ���
silk_data = 1  ;     % ����ʱ�������
% ��������ɸѡ������
[feat_num_zhou,num_feature_zhou,txt_zhou] = data_filt(data_str,patient_name,roi_num,datetime_num_zhou,...
    silk_data,silk_percent,width,data_limit);

%% ���öԱȼ���������ͬ������ָ��
[feature_dataTotal_hu,feature_dataTotal_zhou,feature_txt] =...
    dataEqual(num_feature_zhou,txt_zhou,num_feature_hu,txt_hu,result_str);
% ����ɸѡ��������
xlswrite(save_str,feature_dataTotal_hu,patient_name,'B3');
col_zhou_str = [char(double('B')+datetime_num_hu),'3'];
xlswrite(save_str,feature_dataTotal_zhou,patient_name,col_zhou_str);
xlswrite(save_str,feature_txt,patient_name,'A3');

%% ��ͼ������ɸѡ���ͼ��
figure(1);
len_hu = size(feature_dataTotal_hu);
col_hu = len_hu(1);   % ���� 
for i = 1:col_hu
    plot(feature_dataTotal_hu(i,:));
    ylim([-100,100]);%��Y���趨��ʾ��Χ 
    hold on;
end

figure(2);
len_zhou = size(feature_dataTotal_zhou);
col_zhou = len_zhou(1);   % ����
for i = 1:col_zhou
    plot(feature_dataTotal_zhou(i,:));
    ylim([-100,100]);%��Y���趨��ʾ��Χ
    hold on;
end