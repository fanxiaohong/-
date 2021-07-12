% ���Է���ʱ�䲡�����������е�ͳ��ָ��
clc;
close all;
clear all;

%% ��������������Ҫ�Լ��趨������
result_str = 'E:/roi_feat_dose/result/';
data_str = [result_str,'feature_lung_all.xls'];
roi_num = 14 ; % roi������

%%  ��һ�����˵ĳ�����
patient_name = 'huhongjun';
datetime_num_hu = 6 ;   % CT���ڵĸ���
silk_data = 2  ;     % ����ʱ�������

%% �������ݶ�ȡ��num���ص���excel�е����ݣ�txt��������ı����ݣ�row�������δ��������
[num_feature] = xlsread(data_str,patient_name);
[num_feature,txt] = xlsread(data_str,patient_name);

%% ��һ�����˼���
num_data_hu = num_feature(:,:) ;
len = size(num_data_hu);

%% ��һ��ɸѡ
% �û�data�����е�����ֵ
num_data_hu(find(num_data_hu>1000))=1000;
num_data_hu(find(num_data_hu<-1000))=-1000;
% ����ͳ��ָ��
m = 20 ;
figure()
[min_hu,max_hu,mean_hu,median_hu,mode_hu,std_hu,cov_hu,x_hu,y_hu] = data_statistic(num_data_hu,m)


%%  �ڶ���ɸѡ
num_data_hu1 = num_data_hu(find((num_data_hu >= -500) & (num_data_hu <= 500)));
num_hu1 = length(num_data_hu1);
m1 = 20 ;
figure()
[min_hu1,max_hu1,mean_hu1,median_hu1,mode_hu1,std_hu1,cov_hu1,x_hu1,y_hu1] = data_statistic(num_data_hu1,m1)

%%  ������ɸѡ
num_data_hu2 = num_data_hu1(find((num_data_hu1 >= -150) & (num_data_hu1 <= 300)));
num_hu2 = length(num_data_hu2);
m2 = 20 ;
figure()
[min_hu2,max_hu2,mean_hu2,median_hu2,mode_hu2,std_hu2,cov_hu2,x_hu2,y_hu2] = data_statistic(num_data_hu2,m2)

%%  ���Ĵ�ɸѡ
num_data_hu3 = num_data_hu2(find((num_data_hu2 >= -100) & (num_data_hu2 <= 100)));
num_hu3 = length(num_data_hu3);
m3 = 20 ;
figure()
[min_hu3,max_hu3,mean_hu3,median_hu3,mode_hu3,std_hu3,cov_hu3,x_hu3,y_hu3] = data_statistic(num_data_hu3,m3)

% ������ͼ�ϼ�����̬�ֲ�ͼ
figure()
[mu,sigma] = normfit(num_data_hu3);
bar(y_hu3,x_hu3,'FaceColor','b','EdgeColor','w');box off
xlim([mu-3*sigma,mu+3*sigma]);
a2 = axes;
ezplot(@(x)normpdf(x,mu,sigma),[mu-3*sigma,mu+3*sigma]);
set(a2,'box','off','yaxislocation','right','color','none');

% ͳ�����������ڵ�ָ��
num_hu_20 = length(num_data_hu(find(num_data_hu >= 20)))/len(1)/len(2)*100;
num_hu_20_w5 = length(num_data_hu(find(num_data_hu >= 15 )))/len(1)/len(2)*100;