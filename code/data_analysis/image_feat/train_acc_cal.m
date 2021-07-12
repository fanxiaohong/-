function  [train_acc,train_all] = train_acc_cal(image_str,file_name,I0,I1,image_num,train_label);
% 循环计算训练集合
train_all = [] ;
train_acc_num = 0 ;
for i = 1:image_num   
    image_name = [image_str,file_name,'\\',num2str(i),'.png'] ;
    IMG = imread(image_name);
    I = rgb2gray(IMG);
    image_shape = size(I);
    % 计算变化百分比    
    % 计算变化百分比    
    C0 =((double(I)-double(I0))./double(I0));
    s0 = sum(sum(C0.^2))/image_shape(1)/image_shape(2);
    C1 =((double(I)-double(I1))./double(I1));
    s1 = sum(sum(C1.^2))/image_shape(1)/image_shape(2);
    % 统计训练准确率
    if (train_label(i) == 1) && (s0 > s1)
        train_acc_num = train_acc_num +1 ;
    else if (train_label(i) == 0) && (s0 < s1)
            train_acc_num = train_acc_num +1 ;
        end
    end
    train_all = [train_all;train_label(i),s0,s1] ;
end
train_acc = train_acc_num/image_num * 100 ;
% disp(['train acc:',num2str(train_acc)]);