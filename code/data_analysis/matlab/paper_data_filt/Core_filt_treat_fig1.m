% 统计病人符合要求的特征
clc;
close all;
clear all;

%% 公共超参数，需要自己设定的数据
result_str = 'E:/roi_feat_dose/result/';
data_str = [result_str,'feature_all_person_treat.xls'];
save_file = [result_str,'/feat_filt.xls'] ;
roi_num = 10 ; % roi的数量
X = [2.5,7.5,12.5,17.5,22.5,30,40,50,60] ;    % 横坐标剂量值
sheet_name = {'10','20','30','2.5month'};
patient_datatime = [2,4,8,7] ;    % 各个病人诊断CT的时间点个数

%% 读取数据
for p = 1: length(sheet_name)   % 读取数据
    [num_data,txt_featname]= xlsread(data_str,char(sheet_name(p)));
    num_data = num_data(3:end,:);
    txt_featname = txt_featname(3:end,1);  % 读取有用的feat_name
    eval(['num_data_avg',num2str(p),' = [] ;']) ;  
    for i = 1: length(num_data)   
        num_data_tmp = reshape(num_data(i,:),roi_num,patient_datatime(p))';   % 把每一行按roi数目reshape
        num_data_tmp = sum(num_data_tmp)/patient_datatime(p);    % 按列求和,并求平均
        eval(['num_data_avg',num2str(p),'= [num_data_avg',num2str(p),';num_data_tmp];']) ; % 组装求平均后的特征值
    end
    eval(['num_data_avg',num2str(p),'(find(isnan(num_data_avg',num2str(p),')==1)) = 0 ;']);   % 第一步筛选，将矩阵中的nan替换为0
end

%% 第一步筛选，筛选出dose0-5、5-10、10-15、15-20区间都满足10次比后续小的特征
for p = 1: length(sheet_name)   % 循环命名初始空数组
    eval(['num_data_avg',num2str(p),'_filt2 = [];']);
end
txt_featname_filt2 = []; % 命名初始空数组
for i2 = 1:length(txt_featname)
    for i = 2:4   % 将10次和20次、30次、2.5个月进行对比
        eval(['logistic',num2str(i),' = 0 ;']);  % 第一次筛选赋初始逻辑
        logistic1 = 0; % 统计用
        for j = 2 : 5  %4个剂量区间纳入考核
            eval(['aa = abs(num_data_avg1(i2,j))<abs(num_data_avg',num2str(i),'(i2,j));']);
            logistic1 = logistic1 + aa;
        end
        eval(['logistic',num2str(i),' = logistic1;']);  % 第一次筛选赋初始逻辑
    end
    if (logistic2 >= 3) & (logistic3 >= 3)& (logistic4 >= 3) %如果符合条件则保存对应的特征数据和特征名
        for p = 1: length(sheet_name)   % 循环命名初始空数组
            eval(['num_data_avg',num2str(p),'_filt2 = [num_data_avg',num2str(p),'_filt2;num_data_avg',num2str(p),'(i2,:)];']);
        end
        txt_featname_filt2 = [txt_featname_filt2;txt_featname(i2)] ;
    end
end
        
%% 第二步筛选，筛选出dose0-5、5-10、10-15、15-20区间都满足10次比后续改变量在50%以上
for p = 1: length(sheet_name)   % 循环命名初始空数组
    eval(['num_data_avg',num2str(p),'_filt3 = [];']);
end
txt_featname_filt3 = []; % 命名初始空数组
for i3 = 1:length(txt_featname_filt2)
    for i = 2:4   % 将10次和20次、30次、2.5个月进行对比
        eval(['logistic',num2str(i),' = 0 ;']);  % 第一次筛选赋初始逻辑
        logistic1 = 0; % 统计用
        for j = 2 : 5  %5个剂量区间纳入考核
            eval(['aa = (num_data_avg1_filt2(i3,j)-num_data_avg',num2str(i),'_filt2(i3,j))/num_data_avg1_filt2(i3,j)*100;']);
            aa = (abs(aa)>50) ;
            logistic1 = logistic1 + aa;
        end
        eval(['logistic',num2str(i),' = logistic1;']);  % 第一次筛选赋初始逻辑
    end
    if (logistic2 >= 3) & (logistic3 >= 3)& (logistic4 >= 3) %如果符合条件则保存对应的特征数据和特征名
        for p = 1: length(sheet_name)   % 循环命名初始空数组
            eval(['num_data_avg',num2str(p),'_filt3 = [num_data_avg',num2str(p),'_filt3;num_data_avg',num2str(p),'_filt2(i3,:)];']);
        end
        txt_featname_filt3 = [txt_featname_filt3;txt_featname_filt2(i3)] ;
    end
end

%% 第三步筛选，筛选出dose35-45、45-55、55-60区间都满足10次比后续改变量在50%内
for p = 1: length(sheet_name)   % 循环命名初始空数组
    eval(['num_data_avg',num2str(p),'_filt4 = [];']);
end
txt_featname_filt4 = []; % 命名初始空数组
for i4 = 1:length(txt_featname_filt3)
    for i = 2:4   % 将10次和20次、30次、2.5个月进行对比
        eval(['logistic',num2str(i),' = 0 ;']);  % 第一次筛选赋初始逻辑
        logistic1 = 0; % 统计用
        for j = 8 : 10  %5个剂量区间纳入考核
            eval(['aa = (num_data_avg1_filt3(i4,j)-num_data_avg',num2str(i),'_filt3(i4,j))/num_data_avg1_filt3(i4,j)*100;']);
            aa = (abs(aa)<35) ;
            logistic1 = logistic1 + aa;
        end
        eval(['logistic',num2str(i),' = logistic1;']);  % 第一次筛选赋初始逻辑
    end
    if (logistic2 >= 2) & (logistic3 >= 2)& (logistic4 >= 2)  %如果符合条件则保存对应的特征数据和特征名
        for p = 1: length(sheet_name)   % 循环命名初始空数组
            eval(['num_data_avg',num2str(p),'_filt4 = [num_data_avg',num2str(p),'_filt4;num_data_avg',num2str(p),'_filt3(i4,:)];']);
        end
        txt_featname_filt4 = [txt_featname_filt4;txt_featname_filt3(i4)] ;
    end
end

%% 第四步筛选，筛选出dose0-5、5-10、10-15、15-20区间有奇异性的数据
for p = 1: length(sheet_name)   % 循环命名初始空数组
    eval(['num_data_avg',num2str(p),'_filt5 = [];']);
end
txt_featname_filt5 = []; % 命名初始空数组
for i5 = 1:length(txt_featname_filt4)
    j = 4 ; % dose10-15
    if (num_data_avg4_filt4(i5,j)-num_data_avg1_filt4(i5,j)) * (num_data_avg3_filt4(i5,j)-num_data_avg1_filt4(i5,j))>0
        for p = 1: length(sheet_name)   % 循环命名初始空数组
            eval(['num_data_avg',num2str(p),'_filt5 = [num_data_avg',num2str(p),'_filt5;num_data_avg',num2str(p),'_filt4(i5,:)];']);
        end
        txt_featname_filt5 = [txt_featname_filt5;txt_featname_filt4(i5)] ;
    end
end


%% 找到筛选出的feat在原来数列中的顺序号即行号
col_feat = [];
for i = 1:length(txt_featname_filt5)
    [x,y] = find(strcmp(txt_featname,txt_featname_filt5(i)));  % x,y分别是行向量和列向量，这里只用到x
    col_feat = [col_feat;(x+2)] ;  % +2对应excel表中行号，方便做图
end

%% 保存筛选出的数据
clm_data = ['A',num2str(2)];     % 把特征名称写入excel文件
xlswrite(save_file,txt_featname_filt5,'1',clm_data);
clm_data1 = ['B',num2str(2)];     % 把特征名称写入excel文件
xlswrite(save_file,col_feat,'1',clm_data1);

    
    
    