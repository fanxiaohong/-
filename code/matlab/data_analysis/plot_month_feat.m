function  plot_month_feat(i,roi_num,roi_name,data_row,patient_name,data_time_1,data_str,data_time_2,data_time_3,...
    data_time_4,data_time_5,data_time_6,data_time_7,data_time_8,data_time_9,data_time_10,num_plot_month_feat,...
    save_str,line_style,print_select,data_time_11,data_time_12)
% ���Ƹ�������ʱ��������仯ͼ

%% �������ݶ�ȡ��num���ص���excel�е����ݣ�txt��������ı����ݣ�row�������δ��������
% ѭ����ȡ��������
for p = 1: length(patient_name)
    eval(['[num_data_',num2str(p),',txt_featname]= xlsread(data_str,char(patient_name(p)));']);
end

%% ѭ������plot
figure()
for k = 1:num_plot_month_feat
    subplot(2,2,k)   % ������ͼ
    for p = 1: length(patient_name)
        eval(['y_',num2str(p),'= [];']);
        eval(['len_datatime = length(data_time_',num2str(p),');']);
        for j = 1 : len_datatime
            j0 = k+roi_num*(j-1);  % k��Ӧ�������У�butongroi��lung,dose0-5��
            eval(['y_',num2str(p),'= [y_',num2str(p),',num_data_',num2str(p),'(i,j0)];']);
        end
        eval(['x = data_time_',num2str(p),';']);  
        eval(['y = y_',num2str(p),';']); 
        line_s = [char(line_style(p)),'-'];    % ���ݵ㲻ͬ��ʶ��
        plot(x,y,line_s)
        hold on
    end
    % ͼ�������Ϣ����
    legend(patient_name,'location','northeast','FontSize',7);
    set(legend,'edgecolor','none')   % ͼ���ޱ߿�
    xlabel('Month');
    ylabel('�� �����仯�ٷֱ�/%');
%     set(gca,'YLim',[100 400]);%X���������ʾ��Χ
    title([roi_name(k),txt_featname(i,1)]);
end 

%% ����ͼ��
figure_str = [save_str,char(txt_featname(i,1)),'_LowDose.png'];  % figure�����λ��
set(gcf,'position',[100,100, 2000, 1000]); %�趨figure��λ�úʹ�С get current figure
set(gcf,'color','white'); %�趨figure�ı�����ɫ
if print_select == 1   % �ж��Ƿ��ӡͼƬ
    print(gcf,'-dpng',figure_str)   %���浱ǰ���ڵ�ͼ��
end

%% ѭ������plot
figure()
for k = 1:num_plot_month_feat
    subplot(2,2,k)   % ������ͼ
    for p = 1: length(patient_name)
        eval(['y_',num2str(p),'= [];']);
        eval(['len_datatime = length(data_time_',num2str(p),');']);
        for j = 1 : len_datatime
            j0 = length(roi_name)-k+1+roi_num*(j-1);  % k��Ӧ�������У�butongroi��lung,dose0-5��
            eval(['y_',num2str(p),'= [y_',num2str(p),',num_data_',num2str(p),'(i,j0)];']);
        end
        eval(['x = data_time_',num2str(p),';']);  
        eval(['y = y_',num2str(p),';']); 
        line_s = [char(line_style(p)),'-'];    % ���ݵ㲻ͬ��ʶ��
        plot(x,y,line_s)
        hold on
    end
    % ͼ�������Ϣ����
    legend(patient_name,'location','northeast','FontSize',7);
    set(legend,'edgecolor','none')   % ͼ���ޱ߿�
    xlabel('Month');
    ylabel('�� �����仯�ٷֱ�/%');
%     set(gca,'YLim',[100 400]);%X���������ʾ��Χ
    title([roi_name(length(roi_name)-k+1),txt_featname(i,1)]);
end 

%% ����ͼ��
figure_str = [save_str,char(txt_featname(i,1)),'_HighDose.png'];  % figure�����λ��
set(gcf,'position',[100,100, 2000, 1000]); %�趨figure��λ�úʹ�С get current figure
set(gcf,'color','white'); %�趨figure�ı�����ɫ
if print_select == 1   % �ж��Ƿ��ӡͼƬ
    print(gcf,'-dpng',figure_str)   %���浱ǰ���ڵ�ͼ��
end

if print_select == 1   % �ж��Ƿ��ӡͼƬ
    close all;   %���浱ǰ���ڵ�ͼ��
end
