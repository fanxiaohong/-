function  [train_acc_all] = acc_cal_glcm(image_str,image_type,sheet_name,image_num,train_label,image_mode,result_mode);
% 循环计算glcm准确率 

glcm_all = [] ;
for i = 1:image_num   
    image_name = [image_str,image_type,sheet_name,'\\',num2str(i),'.png'] ;
    IMG = imread(image_name);
    I = rgb2gray(IMG);
    GLCM = graycomatrix(I,'GrayLimits',[]);
    stats = graycoprops(GLCM,{'contrast','homogeneity','correlation','energy'});
    glcm_values = [stats.Contrast,stats.Correlation,stats.Energy,stats.Homogeneity] ;
    glcm_all = [ glcm_all; glcm_values] ;
end
    
% 循环计算训练标签集合
glcm_label_all = [] ;
train_percent_all = [] ;
for k = 1:image_num
    train_percent_all_col = [] ;
    for i = 1:length(image_mode)
        for j = 1:2
            image_name = [image_str,image_type,'label\\label_',num2str(j-1),'_',char(image_mode(i)),'.png'] ;
            IMG = imread(image_name);
            I = rgb2gray(IMG);
            GLCM = graycomatrix(I,'GrayLimits',[]);
            stats = graycoprops(GLCM,{'contrast','homogeneity','correlation','energy'});
            glcm_label = [stats.Contrast,stats.Correlation,stats.Energy,stats.Homogeneity] ;
            glcm_label_all = [glcm_label_all; glcm_label] ;
        end
        % 计算当前模式下的准确率
        train_acc_col0 = (glcm_all(k,:)-glcm_label_all(i*2-1,:))./glcm_label_all(i*2-1,:)*100 ; % 计算单行的准确率
        train_acc_col1 = (glcm_all(k,:)-glcm_label_all(i*2,:))./glcm_label_all(i*2,:)*100 ;
        train_percent_all_col = [train_percent_all_col,train_acc_col0,train_acc_col1] ;  % 循环存入准确率进入矩阵
    end
    train_percent_all = [train_percent_all;train_percent_all_col] ;
end
% 统计正确率
% 统计正确率
train_acc_all = [] ;
for k = 1: length(result_mode)   % 循环读取图片指标类型的识别效果
    train_all1 = [] ;
    for j = 1: length(image_mode)   % 循环读取图片基底类型的识别效果
        train_acc_num = 0 ;
        for i = 1:image_num
            if (train_label(i) == 1) && (abs(train_percent_all(i,2*j+(k-1)*length(image_mode))) > abs(train_percent_all(i,2*j-1+(k-1)*length(image_mode))))
                    train_acc_num = train_acc_num +1 ;
                else if (train_label(i) == 0) && (abs(train_percent_all(i,2*j+(k-1)*length(image_mode))) < abs(train_percent_all(i,2*j-1+(k-1)*length(image_mode))))
                        train_acc_num = train_acc_num +1 ;
                end
            end
        end
        train_acc = train_acc_num/image_num * 100 ;
        train_all1 = [train_all1,train_acc] ;
    end
    train_acc_all = [train_acc_all;train_all1] ;
end