function [feat_num,feature_total3,feature_txt3] = data_filt(data_str,patient_name,row,datatime_num,...
    silk_data,silk_percent,width,data_limit);
% 筛选纹理数据

%% 纹理数据读取，num返回的是excel中的数据，txt输出的是文本内容，row输出的是未处理数据
[num_feature] = xlsread(data_str,patient_name);
[num_feature,txt] = xlsread(data_str,patient_name);

%% 创建的矩阵
len = size(num_feature);
col = len(1);   % 行数

%% 计算纹理特征值变化百分比
for j= 1:row
    for i = 1:col
        for k = 1:datatime_num
            % 以计划时间点前变化做
            eval(['feature_',num2str(k),'=','num_feature(:,',num2str(k),');',]);
        end
    end
end

% 把病发时间数据单独赋值
eval(['silk','=','feature_',num2str(silk_data),';']);

%% 循环筛选
for comp_col = 1:row
    % 第一次筛选：①病变时变化幅度大于15%
    k1 =1;
    feature_total1 = [];
    for i = 1:col-2
        if  (abs(silk(i,comp_col))>silk_percent) & (abs(silk(i,comp_col))< data_limit)
            for j= 1:row
                feature_txt1(k1,1) = txt(i,1);
                for k =1:datatime_num
                    eval(['feature_total1','(k1,j+k-1)','=','feature_',num2str(k),'(i,j);']);
                end
            end
            k1 = k1 + 1;
        end
    end

    %% 第二系列筛选：①后续时间点满足width要求
    k2 =1;
    feature_total2 = [];
    for i = 1:k1-1
        k2_data = 0;
        k2_sum = 0;
        while k2_data < (datatime_num-silk_data+1)    % 循环判断各个时间点是否符合width的要求
            if abs(feature_total1(i,silk_data+k2_data))>(silk_percent-width)
                k2_sum = k2_sum+1;
            end
            k2_data = k2_data+1;
        end
        if  k2_sum == (datatime_num-silk_data+1)
            for j= 1:row
                feature_txt2(k2,1) = feature_txt1(i,1);
                for k =1:datatime_num
                    eval(['feature_total2','(k2,j+k-1)','=','feature_total1','(i,j+k-1);']);
                end
            end
            k2 = k2+1;
        end
    end

    %% 第三系列筛选：同符号
    k3 =1;
    feature_total3 = [];
    for i = 1:k2-1
        k3_data = 1;
        k3_sum = 0;
        while k3_data < (datatime_num)    % 循环判断各个时间点是否同符号
            if feature_total2(i,k3_data)*feature_total2(i,k3_data+1) > 0
                k3_sum = k3_sum+1;
            end
            k3_data = k3_data+1;
        end
        if  k3_sum == (datatime_num-silk_data) 
            for j= 1:row
                feature_txt3(k3,1) = feature_txt2(i,1);
                for k =1:datatime_num
                    eval(['feature_total3','(k3,j+k-1)','=','feature_total2','(i,j+k-1);']);
                end
            end
            k3 = k3+1;
        end
    end
end

feat_num = length(feature_txt3); 

% %% 保存筛选出的数据
% xlswrite(save_str,feature_total3,'纹理','B3');
% xlswrite(save_str,feature_txt3,'纹理','A3');

