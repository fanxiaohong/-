% ͳ�Ʋ��˷���Ҫ���������paperͼ2ָ��ɸѡ
clc;
close all;
clear all;

%% ��������������Ҫ�Լ��趨������
result_str = 'E:/roi_feat_dose/result/';
data_str = [result_str,'feature_lung_silk_health.xls'];
save_file = [result_str,'/feat_filt_silk_health.xls'] ;
roi_num = 2 ; % roi������
patient_datatime = [5,7,6,4,1,5,1,1,7,5,5,7,7,5,2,1,5,2] ;   % �����������CT��ʱ������
save_mode = 1 ; % ����ģʽ��1Ϊ��������0������������

%% ��ȡ����
num_data_all = [];  % �洢�������ݵľ���
sheet_num = length(patient_datatime);  % ��������
for p = 1: sheet_num   % ��ȡ����
    [num_data,txt_featname]= xlsread(data_str,p);
    num_data = num_data(3:end,:);
    txt_featname = txt_featname(3:end,1);  % ��ȡ���õ�feat_name
    num_data_all = [num_data_all,num_data]; % 
end
num_data_all(find(isnan(num_data_all)==1)) = 0;   % ��һ��ɸѡ���������е�nan�滻Ϊ0

%% ��һ��ɸѡ������silk�ı�������ֵ����health����ֵ
num_data_all2 = [];  % ����������
txt_featname_filt2 = []; % ������ʼ������
for i = 1:length(txt_featname)
    sum_j = 0 ; % ���ڱȽϼ���
    for j = 1:sum(patient_datatime)   % ѭ��
        if  (abs(num_data_all(i,2*j-1)>5)) && (abs(num_data_all(i,2*j-1)<1000))  &&...
                (abs((num_data_all(i,j*2-1)-num_data_all(i,j*2))/num_data_all(i,j*2)*100)>10) 
            sum_j = sum_j +1 ; % ����������+1
        end
    end
    if sum_j > (sum(patient_datatime)-12)   % ָ�����76-10������������
        num_data_all2 = [num_data_all2,num_data_all(i,:)];
        txt_featname_filt2 = [txt_featname_filt2;txt_featname(i)] ;
    end
end

%% �ҵ�ɸѡ����feat��ԭ�������е�˳��ż��к�
col_feat = [];
for i = 1:length(txt_featname_filt2)
    [x,y] = find(strcmp(txt_featname,txt_featname_filt2(i)));  % x,y�ֱ�����������������������ֻ�õ�x
    col_feat = [col_feat;(x+2)] ;  % +2��Ӧexcel�����кţ�������ͼ
end

% ����ɸѡ��������
if save_mode ==1   % ����ģʽ��1��������0�򲻱���
    clm_data = ['A',num2str(2)];     % ����������д��excel�ļ�
    xlswrite(save_file,txt_featname_filt2,'silk_health',clm_data);
    clm_data1 = ['B',num2str(2)];     % ����������д��excel�ļ�
    xlswrite(save_file,col_feat,'silk_health',clm_data1);
end

    
    
    