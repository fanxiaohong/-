function  plot_dose_response_feat_pca(i,roi_num,roi_name,data_row,patient_name,data_time_1,data_str,data_time_2,...
    data_time_3,data_time_4,data_time_5,data_time_6,data_time_7,data_time_8,data_time_9,data_time_10,...
    num_dose_response,dose_x,save_str,line_style,print_select)
% ���Ƹ����˵������仯������Ӧ����ͼ

%% �������ݶ�ȡ��num���ص���excel�е����ݣ�txt��������ı����ݣ�row�������δ��������
% ѭ����ȡ��������
for p = 1: length(patient_name)
    eval(['[num_data_',num2str(p),',txt_featname]= xlsread(data_str,char(patient_name(p)));']);
end

num_plot1 = ceil(sqrt(length(num_dose_response))) ;  % ��ͼ��2�У�n��

%% ѭ������plot�����0
figure()
for k = 1:length(num_dose_response)
    subplot(num_plot1,num_plot1,k)   % ������ͼ
    p = num_dose_response(k) ; 
    eval(['y_',num2str(p),'= [];']);
    eval(['len_datatime = length(data_time_',num2str(p),');']);
    eval(['datatime = data_time_',num2str(p),';']);
    for j = 1 : len_datatime
        eval(['y_',num2str(j),'=','[0,num_data_',num2str(p),'(',num2str(i),',',num2str(data_row+roi_num*(j-1)),...
            ':',num2str(roi_num*j),')];']);
        x = [0,dose_x] ;  
        eval(['y = y_',num2str(j),';']); 
        line_s = [char(line_style(j)),'-'];    % ���ݵ㲻ͬ��ʶ��
        plot(x,y,line_s)
        hold on
    end
    % ͼ�������Ϣ����
    datatime = num2str(datatime);
    datatime = str2Cell(datatime);
    legend(datatime,'location','northeast','FontSize',7);
    set(legend,'edgecolor','none')   % ͼ���ޱ߿�
    xlabel('Dose/Gy');
    ylabel('�� �����仯�ٷֱ�/%');
%     set(gca,'YLim',[100 400]);%X���������ʾ��Χ
%     title([patient_name(p),txt_featname(i,1)]);
    title(patient_name(p));
end    

%% ����ͼ��
figure_str = [save_str,num2str(i),'.png'];  % figure�����λ��
set(gcf,'position',[100,100, 3000, 1500]); %�趨figure��λ�úʹ�С get current figure
set(gcf,'color','white'); %�趨figure�ı�����ɫ
if print_select == 1   % �ж��Ƿ��ӡͼƬ
    print(gcf,'-dpng',figure_str)   %���浱ǰ���ڵ�ͼ��
end

%% ѭ������plot2�����dose0-5
figure()
for k = 1:length(num_dose_response)
    subplot(num_plot1,num_plot1,k)   % ������ͼ
    p = num_dose_response(k) ; 
    eval(['y_',num2str(p),'= [];']);
    eval(['len_datatime = length(data_time_',num2str(p),');']);
    eval(['datatime = data_time_',num2str(p),';']);
    for j = 1 : len_datatime
        eval(['y_start=','num_data_',num2str(p),'(',num2str(i),',',num2str(data_row+roi_num*(j-1)),');']);   % ����ÿ������ʱ������
        y0 = y_start * ones(1,roi_num-1) ;   
        eval(['y_',num2str(j),'=','[num_data_',num2str(p),'(',num2str(i),',',num2str(data_row+roi_num*(j-1)),...
            ':',num2str(roi_num*j),')]-y0;']);
        x = [dose_x] ;  
        eval(['y = y_',num2str(j),';']); 
        line_s = [char(line_style(j)),'-'];    % ���ݵ㲻ͬ��ʶ��
        plot(x,y,line_s)
        hold on
    end
    % ͼ�������Ϣ����
    datatime = num2str(datatime);
    datatime = str2Cell(datatime);
    legend(datatime,'location','northeast','FontSize',7);
    set(legend,'edgecolor','none')   % ͼ���ޱ߿�
    xlabel('Dose/Gy');
    ylabel('�� �����仯�ٷֱ�/%');
%     set(gca,'YLim',[100 400]);%X���������ʾ��Χ
%     title([patient_name(p),txt_featname(i,1)]);
    title(patient_name(p));
end    

%% ����ͼ��
figure_str = [save_str,num2str(i),'_start.png'];  % figure�����λ��
set(gcf,'position',[100,100, 3000, 1500]); %�趨figure��λ�úʹ�С get current figure
set(gcf,'color','white'); %�趨figure�ı�����ɫ
if print_select == 1   % �ж��Ƿ��ӡͼƬ
    print(gcf,'-dpng',figure_str)   %���浱ǰ���ڵ�ͼ��
end

if print_select ==1;
    close all;
end
