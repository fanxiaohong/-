% 统计病人符合要求的特征，paper图2指标筛选
clc;
close all;
clear all;

%% 公共超参数，需要自己设定的数据
result_str = 'E:/roi_feat_dose/result/';
data_str = [result_str,'feature_lung_silk_health.xls'];
save_file = [result_str,'/feat_filt_silk_health.xls'] ;
roi_num = 2 ; % roi的数量
patient_datatime = [5,7,6,4,1,5,1,1,7,5,5,7,7,5,2,1,5,2] ;   % 各个病人诊断CT的时间点个数
save_mode = 1 ; % 保存模式，1为保存结果，0和其他不保存

%% 读取数据
num_data_all = [];  % 存储所有数据的矩阵
sheet_num = length(patient_datatime);  % 病人总数
for p = 1: sheet_num   % 读取数据
    [num_data,txt_featname]= xlsread(data_str,p);
    num_data = num_data(3:end,:);
    txt_featname = txt_featname(3:end,1);  % 读取有用的feat_name
    num_data_all = [num_data_all,num_data]; % 
end
num_data_all(find(isnan(num_data_all)==1)) = 0;   % 第一步筛选，将矩阵中的nan替换为0

%% 第一步筛选，所有silk改变量绝对值大于health绝对值
num_data_all2 = [];  % 创建空数组
txt_featname_filt2 = []; % 命名初始空数组
for i = 1:length(txt_featname)
    sum_j = 0 ; % 用于比较计数
    for j = 1:sum(patient_datatime)   % 循环
        if  (abs(num_data_all(i,2*j-1)>5)) && (abs(num_data_all(i,2*j-1)<1000))  &&...
                (abs((num_data_all(i,j*2-1)-num_data_all(i,j*2))/num_data_all(i,j*2)*100)>10) 
            sum_j = sum_j +1 ; % 满足条件，+1
        end
    end
    if sum_j > (sum(patient_datatime)-12)   % 指标大于76-10的则满足条件
        num_data_all2 = [num_data_all2,num_data_all(i,:)];
        txt_featname_filt2 = [txt_featname_filt2;txt_featname(i)] ;
    end
end

%% 找到筛选出的feat在原来数列中的顺序号即行号
col_feat = [];
for i = 1:length(txt_featname_filt2)
    [x,y] = find(strcmp(txt_featname,txt_featname_filt2(i)));  % x,y分别是行向量和列向量，这里只用到x
    col_feat = [col_feat;(x+2)] ;  % +2对应excel表中行号，方便做图
end

% 保存筛选出的数据
if save_mode ==1   % 保存模式，1保存结果，0则不保存
    clm_data = ['A',num2str(2)];     % 把特征名称写入excel文件
    xlswrite(save_file,txt_featname_filt2,'silk_health',clm_data);
    clm_data1 = ['B',num2str(2)];     % 把特征名称写入excel文件
    xlswrite(save_file,col_feat,'silk_health',clm_data1);
end

    
    
    