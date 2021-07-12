function  [train_all] = acc_cal(data_str,sheet_name,image_num,train_label,image_mode,result_mode,label_kind);
% 统计分类正确率

num_data= xlsread(data_str,sheet_name);
train_result = num_data(1:end,2:end);
%% 统计正确率
train_all = [] ;
for k = 1: length(result_mode)   % 循环读取图片指标类型的识别效果
    train_all1 = [] ;
    for j = 1: length(image_mode)   % 循环读取图片基底类型的识别效果
        train_acc_num = 0 ;
        for i = 1:image_num
            if (train_label(i) == 1) && (train_result(i,k*j*label_kind) > train_result(i,k*j*label_kind-1))
                    train_acc_num = train_acc_num +1 ;
                else if (train_label(i) == 0) && (train_result(i,k*j*label_kind) < train_result(i,k*j*label_kind-1))
                        train_acc_num = train_acc_num +1 ;
                end
            end
        end
        train_acc = train_acc_num/image_num * 100 ;
        train_all1 = [train_all1,train_acc] ;
    end
    train_all = [train_all;train_all1] ;
end
    
%% 全体投票决策
train_acc_vote_sum = 0 ;
for i = 1:image_num
    train_acc_num1 = 0 ;
    train_acc_num0 = 0 ;
    for k = 1: length(result_mode)
        for j = 1: length(image_mode)
            if (train_result(i,k*j*label_kind) > train_result(i,k*j*label_kind-1))   % 预测标签为1
                train_acc_num1 = train_acc_num1 +1 ;
            elseif (train_result(i,k*j*label_kind) < train_result(i,k*j*label_kind-1))   % 预测标签为0
                    train_acc_num0 = train_acc_num0 +1 ;
            end
        end
    end
    if train_acc_num1 > train_acc_num0
        pred_label = 1 ;  % 预测标签为1
    elseif train_acc_num1 < train_acc_num0
             pred_label = 0 ;  % 预测标签为0
    elseif train_acc_num1 == train_acc_num0
        pred_label = 0.5 ; % 不能评估出的标签
    end
    if pred_label == train_label(i)   %　判断原始标签和预测标签是否一致
        train_acc_vote_sum = train_acc_vote_sum +1 ;  % 统计标签
    end
end
train_acc_vote = train_acc_vote_sum/image_num * 100 ;

%% 按image_mode投票决策
train_acc_vote_imagemode = [];
for k = 1: length(result_mode)
    train_acc_vote_imagemode_sum = 0 ;
    for i = 1:image_num
        train_acc_imagemode_num1 = 0 ;
        train_acc_imagemode_num0 = 0 ;
        for j = 1: length(image_mode)
            if (train_result(i,k*j*label_kind) > train_result(i,k*j*label_kind-1))   % 预测标签为1
                train_acc_imagemode_num1 = train_acc_imagemode_num1 +1 ;
            elseif (train_result(i,k*j*label_kind) < train_result(i,k*j*label_kind-1))   % 预测标签为0
                    train_acc_imagemode_num0 = train_acc_imagemode_num0 +1 ;
            end
        end
        if train_acc_imagemode_num1 > train_acc_imagemode_num0
        pred_label = 1 ;  % 预测标签为1
        elseif train_acc_imagemode_num1 < train_acc_imagemode_num0
             pred_label = 0 ;  % 预测标签为0
        elseif train_acc_imagemode_num1 == train_acc_imagemode_num0
            pred_label = 0.5 ; % 不能评估出的标签
        end
        if pred_label == train_label(i)   %　判断原始标签和预测标签是否一致
            train_acc_vote_imagemode_sum = train_acc_vote_imagemode_sum +1 ;  % 统计标签
        end
    end
    train_acc_vote_imagemode1 = train_acc_vote_imagemode_sum/image_num * 100 ;
    train_acc_vote_imagemode = [train_acc_vote_imagemode,train_acc_vote_imagemode1] ;
end

%% 按result_mode投票决策
train_acc_vote_resultmode = [];
for k = 1: length(image_mode)
    train_acc_vote_resultmode_sum = 0 ;
    for i = 1:image_num
        train_acc_resultmode_num1 = 0 ;
        train_acc_resultmode_num0 = 0 ;
        for j = 1: length(result_mode)
            if (train_result(i,k*j*label_kind) > train_result(i,k*j*label_kind-1))   % 预测标签为1
                train_acc_resultmode_num1 = train_acc_resultmode_num1 +1 ;
            elseif (train_result(i,k*j*label_kind) < train_result(i,k*j*label_kind-1))   % 预测标签为0
                    train_acc_resultmode_num0 = train_acc_resultmode_num0 +1 ;
            end
        end
        if train_acc_resultmode_num1 > train_acc_resultmode_num0
        pred_label = 1 ;  % 预测标签为1
        elseif train_acc_resultmode_num1 < train_acc_resultmode_num0
             pred_label = 0 ;  % 预测标签为0
        elseif train_acc_resultmode_num1 == train_acc_resultmode_num0
            pred_label = 0.5 ; % 不能评估出的标签
        end
        if pred_label == train_label(i)   %　判断原始标签和预测标签是否一致
            train_acc_vote_resultmode_sum = train_acc_vote_resultmode_sum +1 ;  % 统计标签
        end
    end
    train_acc_vote_resultmode1 = train_acc_vote_resultmode_sum/image_num * 100 ;
    train_acc_vote_resultmode = [train_acc_vote_resultmode,train_acc_vote_resultmode1] ;
end        

%% 组装，vote和单因素分类
train_all = [train_all;train_acc_vote_resultmode] ;
train_acc_vote_imagemode_temp = [train_acc_vote_imagemode,train_acc_vote]' ; 
train_all = [train_all,train_acc_vote_imagemode_temp] ;



