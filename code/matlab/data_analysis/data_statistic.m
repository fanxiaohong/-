function [min_data,max_data,mean_data,median_data,mode_data,std_data,cov_data,x,y] = data_statistic(num_data,m);
% ͳ�������ڵ�ָ��

%����ͳ��ָ��
min_data = min(num_data);
max_data = max(num_data);
mean_data = mean(num_data);
median_data = median(num_data);  % 
mode_data = mode(num_data);   % ����
std_data = std(num_data);    % ��׼��
cov_data = cov(num_data);    % ����


% ��ֱ��ͼ
[x,y] = hist(num_data,m);
hist(num_data,m);



