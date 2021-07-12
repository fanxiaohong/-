% ͳ�Ʋ��˷���Ҫ���������paperͼ2ָ��ɸѡ
clc;
close all;
clear all;

%% ��������������Ҫ�Լ��趨������
result_str = 'E:/roi_feat_dose/result/';
data_str = [result_str,'feature_all_person.xls'];
save_file = [result_str,'/feat_filt.xls'] ;
roi_num = 10 ; % roi������
X = [2.5,7.5,12.5,17.5,22.5,30,40,50,60] ;    % ���������ֵ
sheet_name = {'1.5','4.2','8','12','15'};
patient_datatime = [8,9,5,3,2] ;   % �����������CT��ʱ������

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

%% ��һ��ɸѡ��ɸѡ��dose45-55��55-65�д���������
for p = 1: length(sheet_name)   % ѭ��������ʼ������
    eval(['num_data_avg',num2str(p),'_filt2 = [];']);
end
txt_featname_filt2 = []; % ������ʼ������
for i3 = 1:length(txt_featname)
    for i = 3:5   % ��1.5��4.2�ֱ���\8\12\15�Ա�ͳ��
        eval(['logistic1',num2str(i),' = 0 ;']);  % ��һ��ɸѡ����ʼ�߼�
        eval(['logistic2',num2str(i),' = 0 ;']);  % ��һ��ɸѡ����ʼ�߼�
        logistic1 = 0; % ͳ����
        logistic2 = 0; % ͳ����
        logistic12 = 0 ; % ͳ����
        for j = 9 : 10  % 9�������������뿼��
            eval(['aa = (num_data_avg1(i3,j)-num_data_avg',num2str(i),'(i3,j))/num_data_avg1(i3,j)*100;']);
            eval(['aa2 = (num_data_avg2(i3,j)-num_data_avg',num2str(i),'(i3,j))/num_data_avg1(i3,j)*100;']);
            aa12 = (num_data_avg2(i3,j)-num_data_avg1(i3,j))/num_data_avg1(i3,j)*100;
            aa = (abs(aa)>35) ;
            aa2 = (abs(aa2)>35) ;
            aa12 = (abs(aa12)<50) ;
            logistic1 = logistic1 + aa;
            logistic2 = logistic2 + aa2;
            logistic12 = logistic12 + aa12 ; 
        end
        eval(['logistic1',num2str(i),' = logistic1;']);  % ��һ��ɸѡ����ʼ�߼�
        eval(['logistic2',num2str(i),' = logistic2;']);  % ��һ��ɸѡ����ʼ�߼�
    end
    if (logistic13 >= 2) & (logistic14 >= 2)& (logistic15 >= 2)&...
             (logistic23 >= 2) & (logistic24 >= 2)& (logistic25 >= 2) &...
             (abs(num_data_avg1(i3,8)-num_data_avg4(i3,8))>5)& (abs(num_data_avg2(i3,8)-num_data_avg4(i3,8))<100); %������������򱣴��Ӧ���������ݺ�������
        for p = 1: length(sheet_name)   % ѭ��������ʼ������
            eval(['num_data_avg',num2str(p),'_filt2 = [num_data_avg',num2str(p),'_filt2;num_data_avg',num2str(p),'(i3,:)];']);
        end
        txt_featname_filt2 = [txt_featname_filt2;txt_featname(i3)] ;
    end
end
        
%% �ڶ���ɸѡ��ɸѡ��dose0-5��5-10��10-15��15-20���䶼����10�αȺ����ı�����50%����
for p = 1: length(sheet_name)   % ѭ��������ʼ������
    eval(['num_data_avg',num2str(p),'_filt3 = [];']);
end
txt_featname_filt3 = []; % ������ʼ������
for i3 = 1:length(txt_featname_filt2)
    for i = 1:5   % ��1.5��4.2�ֱ���\8\12\15�Ա�ͳ��
        eval(['logistic',num2str(i),' = 0 ;']);  % ��һ��ɸѡ����ʼ�߼�
        logistic1 = 0; % ͳ����
        for j = 2 : 5  % 6�������������뿼��
            eval(['aa = (num_data_avg1_filt2(i3,j)-num_data_avg',num2str(i),'_filt2(i3,j))/num_data_avg1_filt2(i3,j)*100;']);
            aa = (abs(aa)<100) ;
            logistic1 = logistic1 + aa;
        end
        eval(['logistic',num2str(i),' = logistic1;']);  % ��һ��ɸѡ����ʼ�߼�
    end
    if (logistic1 >= 4) & (logistic3 >=4)& (logistic4 >= 4) & (logistic5 >= 4)%������������򱣴��Ӧ���������ݺ�������
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
    j = 1 ; % dose10-15
    if (abs(num_data_avg4_filt3(i4,j)) <30) %& (abs(num_data_avg4_filt3(i4,j)-) >30)
        for p = 1: length(sheet_name)   % ѭ��������ʼ������
            eval(['num_data_avg',num2str(p),'_filt4 = [num_data_avg',num2str(p),'_filt4;num_data_avg',num2str(p),'_filt3(i4,:)];']);
        end
        txt_featname_filt4 = [txt_featname_filt4;txt_featname_filt3(i4)] ;
    end
end


%% �ҵ�ɸѡ����feat��ԭ�������е�˳��ż��к�
col_feat = [];
for i = 1:length(txt_featname_filt4)
    [x,y] = find(strcmp(txt_featname,txt_featname_filt4(i)));  % x,y�ֱ�����������������������ֻ�õ�x
    col_feat = [col_feat;(x+2)] ;  % +2��Ӧexcel�����кţ�������ͼ
end

% ����ɸѡ��������
clm_data = ['A',num2str(2)];     % ����������д��excel�ļ�
xlswrite(save_file,txt_featname_filt4,'4',clm_data);
clm_data1 = ['B',num2str(2)];     % ����������д��excel�ļ�
xlswrite(save_file,col_feat,'4',clm_data1);

    
    
    