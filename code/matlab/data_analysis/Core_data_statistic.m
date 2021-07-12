% 测试发病时间病人纹理数据中的统计指标
clc;
close all;
clear all;

%% 公共超参数，需要自己设定的数据
result_str = 'E:/roi_feat_dose/result/';
data_str = [result_str,'feature_lung_all.xls'];
roi_num = 14 ; % roi的数量

%%  第一个病人的超参数
patient_name = 'huhongjun';
datetime_num_hu = 6 ;   % CT日期的个数
silk_data = 2  ;     % 发病时间的排序

%% 纹理数据读取，num返回的是excel中的数据，txt输出的是文本内容，row输出的是未处理数据
[num_feature] = xlsread(data_str,patient_name);
[num_feature,txt] = xlsread(data_str,patient_name);

%% 第一个病人计算
num_data_hu = num_feature(:,:) ;
len = size(num_data_hu);

%% 第一次筛选
% 置换data矩阵中的奇异值
num_data_hu(find(num_data_hu>1000))=1000;
num_data_hu(find(num_data_hu<-1000))=-1000;
% 计算统计指标
m = 20 ;
figure()
[min_hu,max_hu,mean_hu,median_hu,mode_hu,std_hu,cov_hu,x_hu,y_hu] = data_statistic(num_data_hu,m)


%%  第二次筛选
num_data_hu1 = num_data_hu(find((num_data_hu >= -500) & (num_data_hu <= 500)));
num_hu1 = length(num_data_hu1);
m1 = 20 ;
figure()
[min_hu1,max_hu1,mean_hu1,median_hu1,mode_hu1,std_hu1,cov_hu1,x_hu1,y_hu1] = data_statistic(num_data_hu1,m1)

%%  第三次筛选
num_data_hu2 = num_data_hu1(find((num_data_hu1 >= -150) & (num_data_hu1 <= 300)));
num_hu2 = length(num_data_hu2);
m2 = 20 ;
figure()
[min_hu2,max_hu2,mean_hu2,median_hu2,mode_hu2,std_hu2,cov_hu2,x_hu2,y_hu2] = data_statistic(num_data_hu2,m2)

%%  第四次筛选
num_data_hu3 = num_data_hu2(find((num_data_hu2 >= -100) & (num_data_hu2 <= 100)));
num_hu3 = length(num_data_hu3);
m3 = 20 ;
figure()
[min_hu3,max_hu3,mean_hu3,median_hu3,mode_hu3,std_hu3,cov_hu3,x_hu3,y_hu3] = data_statistic(num_data_hu3,m3)

% 在柱型图上加入正态分布图
figure()
[mu,sigma] = normfit(num_data_hu3);
bar(y_hu3,x_hu3,'FaceColor','b','EdgeColor','w');box off
xlim([mu-3*sigma,mu+3*sigma]);
a2 = axes;
ezplot(@(x)normpdf(x,mu,sigma),[mu-3*sigma,mu+3*sigma]);
set(a2,'box','off','yaxislocation','right','color','none');

% 统计落在区间内的指标
num_hu_20 = length(num_data_hu(find(num_data_hu >= 20)))/len(1)/len(2)*100;
num_hu_20_w5 = length(num_data_hu(find(num_data_hu >= 15 )))/len(1)/len(2)*100;