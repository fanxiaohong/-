function [min_data,max_data,mean_data,median_data,mode_data,std_data,cov_data,x,y] = data_statistic(num_data,m);
% 统计数据内的指标

%计算统计指标
min_data = min(num_data);
max_data = max(num_data);
mean_data = mean(num_data);
median_data = median(num_data);  % 
mode_data = mode(num_data);   % 众数
std_data = std(num_data);    % 标准差
cov_data = cov(num_data);    % 方差


% 画直方图
[x,y] = hist(num_data,m);
hist(num_data,m);



