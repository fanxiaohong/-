function  plot_dose_response_feat_pca(i,roi_num,roi_name,data_row,patient_name,data_time_1,data_str,data_time_2,...
    data_time_3,data_time_4,data_time_5,data_time_6,data_time_7,data_time_8,data_time_9,data_time_10,...
    num_dose_response,dose_x,save_str,line_style,print_select)
% 绘制各病人的特征变化剂量响应曲线图

%% 纹理数据读取，num返回的是excel中的数据，txt输出的是文本内容，row输出的是未处理数据
% 循环读取病人数据
for p = 1: length(patient_name)
    eval(['[num_data_',num2str(p),',txt_featname]= xlsread(data_str,char(patient_name(p)));']);
end

num_plot1 = ceil(sqrt(length(num_dose_response))) ;  % 画图成2行，n列

%% 循环绘制plot，起点0
figure()
for k = 1:length(num_dose_response)
    subplot(num_plot1,num_plot1,k)   % 绘制子图
    p = num_dose_response(k) ; 
    eval(['y_',num2str(p),'= [];']);
    eval(['len_datatime = length(data_time_',num2str(p),');']);
    eval(['datatime = data_time_',num2str(p),';']);
    for j = 1 : len_datatime
        eval(['y_',num2str(j),'=','[0,num_data_',num2str(p),'(',num2str(i),',',num2str(data_row+roi_num*(j-1)),...
            ':',num2str(roi_num*j),')];']);
        x = [0,dose_x] ;  
        eval(['y = y_',num2str(j),';']); 
        line_s = [char(line_style(j)),'-'];    % 数据点不同标识符
        plot(x,y,line_s)
        hold on
    end
    % 图像基本信息设置
    datatime = num2str(datatime);
    datatime = str2Cell(datatime);
    legend(datatime,'location','northeast','FontSize',7);
    set(legend,'edgecolor','none')   % 图例无边框
    xlabel('Dose/Gy');
    ylabel('Δ 特征变化百分比/%');
%     set(gca,'YLim',[100 400]);%X轴的数据显示范围
%     title([patient_name(p),txt_featname(i,1)]);
    title(patient_name(p));
end    

%% 保存图像
figure_str = [save_str,num2str(i),'.png'];  % figure保存的位置
set(gcf,'position',[100,100, 3000, 1500]); %设定figure的位置和大小 get current figure
set(gcf,'color','white'); %设定figure的背景颜色
if print_select == 1   % 判断是否打印图片
    print(gcf,'-dpng',figure_str)   %保存当前窗口的图像
end

%% 循环绘制plot2，起点dose0-5
figure()
for k = 1:length(num_dose_response)
    subplot(num_plot1,num_plot1,k)   % 绘制子图
    p = num_dose_response(k) ; 
    eval(['y_',num2str(p),'= [];']);
    eval(['len_datatime = length(data_time_',num2str(p),');']);
    eval(['datatime = data_time_',num2str(p),';']);
    for j = 1 : len_datatime
        eval(['y_start=','num_data_',num2str(p),'(',num2str(i),',',num2str(data_row+roi_num*(j-1)),');']);   % 计算每个争端时间的起点
        y0 = y_start * ones(1,roi_num-1) ;   
        eval(['y_',num2str(j),'=','[num_data_',num2str(p),'(',num2str(i),',',num2str(data_row+roi_num*(j-1)),...
            ':',num2str(roi_num*j),')]-y0;']);
        x = [dose_x] ;  
        eval(['y = y_',num2str(j),';']); 
        line_s = [char(line_style(j)),'-'];    % 数据点不同标识符
        plot(x,y,line_s)
        hold on
    end
    % 图像基本信息设置
    datatime = num2str(datatime);
    datatime = str2Cell(datatime);
    legend(datatime,'location','northeast','FontSize',7);
    set(legend,'edgecolor','none')   % 图例无边框
    xlabel('Dose/Gy');
    ylabel('Δ 特征变化百分比/%');
%     set(gca,'YLim',[100 400]);%X轴的数据显示范围
%     title([patient_name(p),txt_featname(i,1)]);
    title(patient_name(p));
end    

%% 保存图像
figure_str = [save_str,num2str(i),'_start.png'];  % figure保存的位置
set(gcf,'position',[100,100, 3000, 1500]); %设定figure的位置和大小 get current figure
set(gcf,'color','white'); %设定figure的背景颜色
if print_select == 1   % 判断是否打印图片
    print(gcf,'-dpng',figure_str)   %保存当前窗口的图像
end

if print_select ==1;
    close all;
end
