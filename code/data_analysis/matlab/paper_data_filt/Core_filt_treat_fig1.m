% ͳ�Ʋ��˷���Ҫ�������
clc;
close all;
clear all;

%% ��������������Ҫ�Լ��趨������
result_str = 'E:/roi_feat_dose/result/';
data_str = [result_str,'feature_all_person_treat.xls'];
save_file = [result_str,'/feat_filt.xls'] ;
roi_num = 10 ; % roi������
X = [2.5,7.5,12.5,17.5,22.5,30,40,50,60] ;    % ���������ֵ
sheet_name = {'10','20','30','2.5month'};
patient_datatime = [2,4,8,7] ;    % �����������CT��ʱ������

%% ��ȡ����
for p = 1: length(sheet_name)   % ��ȡ����
    [num_data,txt_featname]= xlsread(data_str,char(sheet_name(p)));
    num_data = num_data(3:end,:);
    txt_featname = txt_featname(3:end,1);  % ��ȡ���õ�feat_name
    eval(['num_data_avg',num2str(p),' = [] ;']) ;  
    for i = 1: length(num_data)   
        num_data_tmp = reshape(num_data(i,:),roi_num,patient_datatime(p))';   % ��ÿһ�а�roi��Ŀreshape
        num_data_tmp = sum(num_data_tmp)/patient_datatime(p);    % �������,����ƽ��
        eval(['num_data_avg',num2str(p),'= [num_data_avg',num2str(p),';num_data_tmp];']) ; % ��װ��ƽ���������ֵ
    end
    eval(['num_data_avg',num2str(p),'(find(isnan(num_data_avg',num2str(p),')==1)) = 0 ;']);   % ��һ��ɸѡ���������е�nan�滻Ϊ0
end

%% ��һ��ɸѡ��ɸѡ��dose0-5��5-10��10-15��15-20���䶼����10�αȺ���С������
for p = 1: length(sheet_name)   % ѭ��������ʼ������
    eval(['num_data_avg',num2str(p),'_filt2 = [];']);
end
txt_featname_filt2 = []; % ������ʼ������
for i2 = 1:length(txt_featname)
    for i = 2:4   % ��10�κ�20�Ρ�30�Ρ�2.5���½��жԱ�
        eval(['logistic',num2str(i),' = 0 ;']);  % ��һ��ɸѡ����ʼ�߼�
        logistic1 = 0; % ͳ����
        for j = 2 : 5  %4�������������뿼��
            eval(['aa = abs(num_data_avg1(i2,j))<abs(num_data_avg',num2str(i),'(i2,j));']);
            logistic1 = logistic1 + aa;
        end
        eval(['logistic',num2str(i),' = logistic1;']);  % ��һ��ɸѡ����ʼ�߼�
    end
    if (logistic2 >= 3) & (logistic3 >= 3)& (logistic4 >= 3) %������������򱣴��Ӧ���������ݺ�������
        for p = 1: length(sheet_name)   % ѭ��������ʼ������
            eval(['num_data_avg',num2str(p),'_filt2 = [num_data_avg',num2str(p),'_filt2;num_data_avg',num2str(p),'(i2,:)];']);
        end
        txt_featname_filt2 = [txt_featname_filt2;txt_featname(i2)] ;
    end
end
        
%% �ڶ���ɸѡ��ɸѡ��dose0-5��5-10��10-15��15-20���䶼����10�αȺ����ı�����50%����
for p = 1: length(sheet_name)   % ѭ��������ʼ������
    eval(['num_data_avg',num2str(p),'_filt3 = [];']);
end
txt_featname_filt3 = []; % ������ʼ������
for i3 = 1:length(txt_featname_filt2)
    for i = 2:4   % ��10�κ�20�Ρ�30�Ρ�2.5���½��жԱ�
        eval(['logistic',num2str(i),' = 0 ;']);  % ��һ��ɸѡ����ʼ�߼�
        logistic1 = 0; % ͳ����
        for j = 2 : 5  %5�������������뿼��
            eval(['aa = (num_data_avg1_filt2(i3,j)-num_data_avg',num2str(i),'_filt2(i3,j))/num_data_avg1_filt2(i3,j)*100;']);
            aa = (abs(aa)>50) ;
            logistic1 = logistic1 + aa;
        end
        eval(['logistic',num2str(i),' = logistic1;']);  % ��һ��ɸѡ����ʼ�߼�
    end
    if (logistic2 >= 3) & (logistic3 >= 3)& (logistic4 >= 3) %������������򱣴��Ӧ���������ݺ�������
        for p = 1: length(sheet_name)   % ѭ��������ʼ������
            eval(['num_data_avg',num2str(p),'_filt3 = [num_data_avg',num2str(p),'_filt3;num_data_avg',num2str(p),'_filt2(i3,:)];']);
        end
        txt_featname_filt3 = [txt_featname_filt3;txt_featname_filt2(i3)] ;
    end
end

%% ������ɸѡ��ɸѡ��dose35-45��45-55��55-60���䶼����10�αȺ����ı�����50%��
for p = 1: length(sheet_name)   % ѭ��������ʼ������
    eval(['num_data_avg',num2str(p),'_filt4 = [];']);
end
txt_featname_filt4 = []; % ������ʼ������
for i4 = 1:length(txt_featname_filt3)
    for i = 2:4   % ��10�κ�20�Ρ�30�Ρ�2.5���½��жԱ�
        eval(['logistic',num2str(i),' = 0 ;']);  % ��һ��ɸѡ����ʼ�߼�
        logistic1 = 0; % ͳ����
        for j = 8 : 10  %5�������������뿼��
            eval(['aa = (num_data_avg1_filt3(i4,j)-num_data_avg',num2str(i),'_filt3(i4,j))/num_data_avg1_filt3(i4,j)*100;']);
            aa = (abs(aa)<35) ;
            logistic1 = logistic1 + aa;
        end
        eval(['logistic',num2str(i),' = logistic1;']);  % ��һ��ɸѡ����ʼ�߼�
    end
    if (logistic2 >= 2) & (logistic3 >= 2)& (logistic4 >= 2)  %������������򱣴��Ӧ���������ݺ�������
        for p = 1: length(sheet_name)   % ѭ��������ʼ������
            eval(['num_data_avg',num2str(p),'_filt4 = [num_data_avg',num2str(p),'_filt4;num_data_avg',num2str(p),'_filt3(i4,:)];']);
        end
        txt_featname_filt4 = [txt_featname_filt4;txt_featname_filt3(i4)] ;
    end
end

%% ���Ĳ�ɸѡ��ɸѡ��dose0-5��5-10��10-15��15-20�����������Ե�����
for p = 1: length(sheet_name)   % ѭ��������ʼ������
    eval(['num_data_avg',num2str(p),'_filt5 = [];']);
end
txt_featname_filt5 = []; % ������ʼ������
for i5 = 1:length(txt_featname_filt4)
    j = 4 ; % dose10-15
    if (num_data_avg4_filt4(i5,j)-num_data_avg1_filt4(i5,j)) * (num_data_avg3_filt4(i5,j)-num_data_avg1_filt4(i5,j))>0
        for p = 1: length(sheet_name)   % ѭ��������ʼ������
            eval(['num_data_avg',num2str(p),'_filt5 = [num_data_avg',num2str(p),'_filt5;num_data_avg',num2str(p),'_filt4(i5,:)];']);
        end
        txt_featname_filt5 = [txt_featname_filt5;txt_featname_filt4(i5)] ;
    end
end


%% �ҵ�ɸѡ����feat��ԭ�������е�˳��ż��к�
col_feat = [];
for i = 1:length(txt_featname_filt5)
    [x,y] = find(strcmp(txt_featname,txt_featname_filt5(i)));  % x,y�ֱ�����������������������ֻ�õ�x
    col_feat = [col_feat;(x+2)] ;  % +2��Ӧexcel�����кţ�������ͼ
end

%% ����ɸѡ��������
clm_data = ['A',num2str(2)];     % ����������д��excel�ļ�
xlswrite(save_file,txt_featname_filt5,'1',clm_data);
clm_data1 = ['B',num2str(2)];     % ����������д��excel�ļ�
xlswrite(save_file,col_feat,'1',clm_data1);

    
    
    