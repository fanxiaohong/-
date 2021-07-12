function  plot_month_feat(i,roi_num,roi_name,data_row,patient_name,data_time_1,data_str,data_time_2,data_time_3,...
    data_time_4,data_time_5,data_time_6,data_time_7,data_time_8,data_time_9,data_time_10,num_plot_month_feat,...
    save_str,line_style,print_select,data_time_11,data_time_12)
% 绘制各病人随时间的特征变化图

%% 纹理数据读取，num返回的是excel中的数据，txt输出的是文本内容，row输出的是未处理数据
% 循环读取病人数据
for p = 1: length(patient_name)
    eval(['[num_data_',num2str(p),',txt_featname]= xlsread(data_str,char(patient_name(p)));']);
end

%% 循环绘制plot
figure()
for k = 1:num_plot_month_feat
    subplot(2,2,k)   % 绘制子图
    for p = 1: length(patient_name)
        eval(['y_',num2str(p),'= [];']);
        eval(['len_datatime = length(data_time_',num2str(p),');']);
        for j = 1 : len_datatime
            j0 = k+roi_num*(j-1);  % k对应的数据列，butongroi，lung,dose0-5等
            eval(['y_',num2str(p),'= [y_',num2str(p),',num_data_',num2str(p),'(i,j0)];']);
        end
        eval(['x = data_time_',num2str(p),';']);  
        eval(['y = y_',num2str(p),';']); 
        line_s = [char(line_style(p)),'-'];    % 数据点不同标识符
        plot(x,y,line_s)
        hold on
    end
    % 图像基本信息设置
    legend(patient_name,'location','northeast','FontSize',7);
    set(legend,'edgecolor','none')   % 图例无边框
    xlabel('Month');
    ylabel('Δ 特征变化百分比/%');
%     set(gca,'YLim',[100 400]);%X轴的数据显示范围
    title([roi_name(k),txt_featname(i,1)]);
end 

%% 保存图像
figure_str = [save_str,char(txt_featname(i,1)),'_LowDose.png'];  % figure保存的位置
set(gcf,'position',[100,100, 2000, 1000]); %设定figure的位置和大小 get current figure
set(gcf,'color','white'); %设定figure的背景颜色
if print_select == 1   % 判断是否打印图片
    print(gcf,'-dpng',figure_str)   %保存当前窗口的图像
end

%% 循环绘制plot
figure()
for k = 1:num_plot_month_feat
    subplot(2,2,k)   % 绘制子图
    for p = 1: length(patient_name)
        eval(['y_',num2str(p),'= [];']);
        eval(['len_datatime = length(data_time_',num2str(p),');']);
        for j = 1 : len_datatime
            j0 = length(roi_name)-k+1+roi_num*(j-1);  % k对应的数据列，butongroi，lung,dose0-5等
            eval(['y_',num2str(p),'= [y_',num2str(p),',num_data_',num2str(p),'(i,j0)];']);
        end
        eval(['x = data_time_',num2str(p),';']);  
        eval(['y = y_',num2str(p),';']); 
        line_s = [char(line_style(p)),'-'];    % 数据点不同标识符
        plot(x,y,line_s)
        hold on
    end
    % 图像基本信息设置
    legend(patient_name,'location','northeast','FontSize',7);
    set(legend,'edgecolor','none')   % 图例无边框
    xlabel('Month');
    ylabel('Δ 特征变化百分比/%');
%     set(gca,'YLim',[100 400]);%X轴的数据显示范围
    title([roi_name(length(roi_name)-k+1),txt_featname(i,1)]);
end 

%% 保存图像
figure_str = [save_str,char(txt_featname(i,1)),'_HighDose.png'];  % figure保存的位置
set(gcf,'position',[100,100, 2000, 1000]); %设定figure的位置和大小 get current figure
set(gcf,'color','white'); %设定figure的背景颜色
if print_select == 1   % 判断是否打印图片
    print(gcf,'-dpng',figure_str)   %保存当前窗口的图像
end

if print_select == 1   % 判断是否打印图片
    close all;   %保存当前窗口的图像
end
