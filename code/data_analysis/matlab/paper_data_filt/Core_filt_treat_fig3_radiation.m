% ͳ�Ʋ��˷���Ҫ���������paperͼ2ָ��ɸѡ
clc;
close all;
clear all;

%% ��������������Ҫ�Լ��趨������
result_str = 'E:/roi_feat_dose/result/';
data_str = [result_str,'feature_all_person_radiation.xls'];
save_file = [result_str,'/feat_filt_radiation.xls'] ;
roi_num = 10 ; % roi������
X = [2.5,7.5,12.5,17.5,22.5,30,40,50,60] ;    % ���������ֵ
sheet_name = {'1.5','4','8','12','15'};
patient_datatime = [8,11,6,4,2] ;   % ����ʱ�䣬�����������CT��ʱ������
save_mode = 1;  % ����ģʽ�����Ϊ1���򱣴�

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

%% ��һ��ɸѡ��ɸѡ��54��43��32ͳ�ƴ��ڹ�ϵ�������
for p = 1: length(sheet_name)   % ѭ��������ʼ������
    eval(['num_data_avg',num2str(p),'_filt2 = [];']);
end
txt_featname_filt2 = []; % ������ʼ������
for i3 = 1:length(txt_featname)
    for i = 3:5   % ��1.5��4.2�ֱ���\8\12\15�Ա�ͳ��
        eval(['logistic',num2str(i-1),num2str(i),' = 0 ;']);  % ��һ��ɸѡ����ʼ�߼�
        logistic1 = 0; % ͳ����
        for j = 2 :10  % 9�������������뿼��
            eval(['aa=(abs(num_data_avg',num2str(i),'(i3,j))>abs(num_data_avg',num2str(i-1),'(i3,j)));']);
            logistic1 = logistic1 + aa;
        end
        eval(['logistic',num2str(i-1),num2str(i),' = logistic1 ;']);  % ��һ��ɸѡ����ʼ�߼�
    end
    if (logistic23 >= 5) & (logistic34 >= 5)& (logistic45 >= 5) %������������򱣴��Ӧ���������ݺ�������
        for p = 1: length(sheet_name)   % ѭ��������ʼ������
            eval(['num_data_avg',num2str(p),'_filt2 = [num_data_avg',num2str(p),'_filt2;num_data_avg',num2str(p),'(i3,:)];']);
        end
        txt_featname_filt2 = [txt_featname_filt2;txt_featname(i3)] ;
    end
end
        
%% �ڶ���ɸѡ��ɸѡ��53��42ͳ�ƴ��ڹ�ϵ�������
for p = 1: length(sheet_name)   % ѭ��������ʼ������
    eval(['num_data_avg',num2str(p),'_filt3 = [];']);
end
txt_featname_filt3 = []; % ������ʼ������
for i3 = 1:length(txt_featname_filt2)
    for i = 4:5   % ��1.5��4.2�ֱ���\8\12\15�Ա�ͳ��
        eval(['logistic',num2str(i-2),num2str(i),' = 0 ;']);  % ��һ��ɸѡ����ʼ�߼�
        logistic1 = 0; % ͳ����
        for j = 2 : 10  % 9�������������뿼��
            eval(['aa=(abs(num_data_avg',num2str(i),'_filt2(i3,j))>abs(num_data_avg',num2str(i-2),'_filt2(i3,j)));']);
            logistic1 = logistic1 + aa;
        end
        eval(['logistic',num2str(i-2),num2str(i),' = logistic1 ;']);  % ��һ��ɸѡ����ʼ�߼�
    end
    if (logistic24 >= 8) & (logistic35 >= 8) %������������򱣴��Ӧ���������ݺ�������
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
for i3 = 1:length(txt_featname_filt3)
    for i = 4:5   % ��1.5��4.2�ֱ���\8\12\15�Ա�ͳ��
        eval(['logistic',num2str(i-3),num2str(i),' = 0 ;']);  % ��һ��ɸѡ����ʼ�߼�
        logistic1 = 0; % ͳ����
        for j = 2 : 10  % 9�������������뿼��
            eval(['aa=(abs(num_data_avg',num2str(i),'_filt3(i3,j))>abs(num_data_avg',num2str(i-3),'_filt3(i3,j)));']);
            logistic1 = logistic1 + aa;
        end
        eval(['logistic',num2str(i-3),num2str(i),' = logistic1 ;']);  % ��һ��ɸѡ����ʼ�߼�
    end
    if (logistic25 >= 8) %������������򱣴��Ӧ���������ݺ�������
        for p = 1: length(sheet_name)   % ѭ��������ʼ������
            eval(['num_data_avg',num2str(p),'_filt4 = [num_data_avg',num2str(p),'_filt4;num_data_avg',num2str(p),'_filt3(i3,:)];']);
        end
        txt_featname_filt4 = [txt_featname_filt4;txt_featname_filt3(i3)] ;
    end
end

%% ���Ĳ�ɸѡ��ɸѡ��45-55��55-60�������죬ɾ��12����15��
for p = 1: length(sheet_name)   % ѭ��������ʼ������
    eval(['num_data_avg',num2str(p),'_filt5 = [];']);
end
txt_featname_filt5 = []; % ������ʼ������
for i3 = 1:length(txt_featname_filt4)
    for i = 3:5   % ��1.5��4.2�ֱ���\8\12\15�Ա�ͳ��
        eval(['logistic',num2str(i-1),num2str(i),' = 0 ;']);  % ��һ��ɸѡ����ʼ�߼�
        eval(['logistic',num2str(i-2),num2str(i),' = 0 ;']);  % ��һ��ɸѡ����ʼ�߼�
        logistic1 = 0; % ͳ����
        logistic2 = 0; % ͳ����
        for j = 9 : 10  % 9�������������뿼��
            eval(['aa=(abs(num_data_avg',num2str(i),'_filt4(i3,j))>abs(num_data_avg',num2str(i-1),'_filt4(i3,j)));']);
            logistic1 = logistic1 + aa;
            eval(['aa2=(abs(num_data_avg',num2str(i),'_filt4(i3,j))>abs(num_data_avg',num2str(i-2),'_filt4(i3,j)));']);
            logistic2 = logistic2 + aa2;
        end
        eval(['logistic',num2str(i-1),num2str(i),' = logistic1 ;']);  % ��һ��ɸѡ����ʼ�߼�
        eval(['logistic',num2str(i-2),num2str(i),' = logistic1 ;']);  % ��һ��ɸѡ����ʼ�߼�
    end
    if (logistic45 >= 2)&(logistic34 >= 1)  %������������򱣴��Ӧ���������ݺ�������
        for p = 1: length(sheet_name)   % ѭ��������ʼ������
            eval(['num_data_avg',num2str(p),'_filt5 = [num_data_avg',num2str(p),'_filt5;num_data_avg',num2str(p),'_filt4(i3,:)];']);
        end
        txt_featname_filt5 = [txt_featname_filt5;txt_featname_filt4(i3)] ;
    end
end

%% ���岽ɸѡ��ɸѡ��54��43��32ͳ�ƴ��ڹ�ϵ�������
for p = 1: length(sheet_name)   % ѭ��������ʼ������
    eval(['num_data_avg',num2str(p),'_filt6 = [];']);
end
txt_featname_filt6 = []; % ������ʼ������
for i3 = 1:length(txt_featname_filt5)
    for i = 3:5   % ��1.5��4.2�ֱ���\8\12\15�Ա�ͳ��
        eval(['logistic',num2str(i-1),num2str(i),' = 0 ;']);  % ��һ��ɸѡ����ʼ�߼�
        logistic1 = 0; % ͳ����
        for j = 2 :5  % 9�������������뿼��
            eval(['aa=(abs(num_data_avg',num2str(i),'_filt5(i3,j))>abs(num_data_avg',num2str(i-1),'_filt5(i3,j)));']);
            logistic1 = logistic1 + aa;
        end
        eval(['logistic',num2str(i-1),num2str(i),' = logistic1 ;']);  % ��һ��ɸѡ����ʼ�߼�
    end
    if (logistic23 >= 3) & (logistic34 >= 4)& (logistic45 >= 3) %������������򱣴��Ӧ���������ݺ�������
        for p = 1: length(sheet_name)   % ѭ��������ʼ������
            eval(['num_data_avg',num2str(p),'_filt6 = [num_data_avg',num2str(p),'_filt6;num_data_avg',num2str(p),'_filt5(i3,:)];']);
        end
        txt_featname_filt6 = [txt_featname_filt6;txt_featname_filt5(i3)] ;
    end
end

%% �ҵ�ɸѡ����feat��ԭ�������е�˳��ż��к�
col_feat = [];
for i = 1:length(txt_featname_filt6)
    [x,y] = find(strcmp(txt_featname,txt_featname_filt6(i)));  % x,y�ֱ�����������������������ֻ�õ�x
    col_feat = [col_feat;(x+2)] ;  % +2��Ӧexcel�����кţ�������ͼ
end

% ����ɸѡ��������
if save_mode == 1  % ����ģʽ�����Ϊ1�򱣴浽excel
    clm_data = ['A',num2str(2)];     % ����������д��excel�ļ�
    xlswrite(save_file,txt_featname_filt6,'3',clm_data);
    clm_data1 = ['B',num2str(2)];     % ����������д��excel�ļ�
    xlswrite(save_file,col_feat,'3',clm_data1);
end

    
    
    