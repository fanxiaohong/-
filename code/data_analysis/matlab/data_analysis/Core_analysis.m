%% 用于数据筛选的主程序
clc;
close all;
clear all;

%% 公共超参数，需要自己设定的数据
silk_percent = 20;  % 发病纹理特征变化比率设置
width = 5 ;         % 筛选指标中允许病发后特征比例波动值
data_limit = 500 ;  % 特征变化上限值
data_place = 'lung' ; % 分析的数据是lung,还是dose0-5
result_str = 'E:/roi_feat_dose/result/';
data_str = [result_str,'lung.xls'];   % 数据存放位置
save_str = [result_str,'feat_choice_',data_place,'_',num2str(silk_percent),'perc.xls'];   % 结果保存位置
roi_num = 1;        % ROI的个数

%%  第一个病人的超参数,zhouzhengyuan
patient_name = ['1.zhouzhengyuan'];
datetime_num_hu = 5 ;   % CT日期的个数
silk_data = 1 ;     % 发病时间的排序
% 调用数据筛选主程序
[feat_num_hu,num_feature_hu,txt_hu] = data_filt(data_str,patient_name,roi_num,datetime_num_hu,...
    silk_data,silk_percent,width,data_limit);

%%  第二个病人的超参数
patient_name = ['2.huhongjun'];
datetime_num_zhou = 7 ;   % CT日期的个数
silk_data = 1  ;     % 发病时间的排序
% 调用数据筛选主程序
[feat_num_zhou,num_feature_zhou,txt_zhou] = data_filt(data_str,patient_name,roi_num,datetime_num_zhou,...
    silk_data,silk_percent,width,data_limit);

%% 调用对比几个病人相同的纹理指标
[feature_dataTotal_hu,feature_dataTotal_zhou,feature_txt] =...
    dataEqual(num_feature_zhou,txt_zhou,num_feature_hu,txt_hu,result_str);
% 保存筛选出的数据
xlswrite(save_str,feature_dataTotal_hu,patient_name,'B3');
col_zhou_str = [char(double('B')+datetime_num_hu),'3'];
xlswrite(save_str,feature_dataTotal_zhou,patient_name,col_zhou_str);
xlswrite(save_str,feature_txt,patient_name,'A3');

%% 画图，作出筛选后的图像
figure(1);
len_hu = size(feature_dataTotal_hu);
col_hu = len_hu(1);   % 行数 
for i = 1:col_hu
    plot(feature_dataTotal_hu(i,:));
    ylim([-100,100]);%对Y轴设定显示范围 
    hold on;
end

figure(2);
len_zhou = size(feature_dataTotal_zhou);
col_zhou = len_zhou(1);   % 行数
for i = 1:col_zhou
    plot(feature_dataTotal_zhou(i,:));
    ylim([-100,100]);%对Y轴设定显示范围
    hold on;
end