% ���Է���ʱ�䲡�����������е�ͳ��ָ��
clc;
close all;
clear all;

%% ��������������Ҫ�Լ��趨������
result_str = 'E:\roi_feat_dose\code\data_analysis\';
data_str = [result_str,'output_l2_pca.xlsx'];
save_str = [result_str,'plot_l2_pca/'];   % figure������ͼ����
roi_num = 10 ; % roi������
data_row = 2 ;  % �����ǵ���λ�ã���һ����lung��ȥ
num_plot_month_feat = 4;    % �۲��roi������Ŀ
num_dose_response = [1,2,3,4,6,9,10];    %  ��������Ӧ���ߵĲ���˳��ţ�
dose_x = [2.5,7.5,12.5,17.5,22.5,30,40,50,60]  ; % ���������꣬���������м��
i_start = 2 ;  %  53,62,141,167,278,825,841,855,866,883,886,944,970.978,1175
i_end = 34 ;
print_select = 1 ;  % �Ƿ��ӡͼƬ��1��ӡ��������0�Ȳ���ӡ

%%  ���˵ĳ�����
roi_name = {'lung','dose0-5','dose5-10','dose10-15','dose15-20','dose20-25','dose25-35','dose35-45','dose45-55','dose55-65'};
patient_name = {'1.zhouzhengyuan','2.huhongjun','3.pengzhenwu','4.jiangxiaoping','5.fengjuyun','6.moyuee',...
    '7.xiangzhilin','8.chenfangqiu','9.yinyunhua','10.tanghaibo'};
line_style = {'+','o','*','x','s','d','p','h','>','<','��','��'};  % plot���ݱ�ǵ�����
% ���������CTʱ��
data_time_1 = [1.23,1.50,3.70,3.90,4.27] ;    % zhouzhengyuan
data_time_2 = [0.87,1.37,2.80,3.73,4.30,5.70,8.13] ;   %huhongjun
data_time_3 = [1.80,2.30,4.47,7.60,7.97,9.20] ;     %  pengzhenwu
data_time_4 = [1.43,3.80,6.97,11.60] ;    %   jiangxiaoping
data_time_5 = [2.63] ;       %   fengjuyun
data_time_6 = [3.73,6.77,8.40,11.73,14.43] ;   %  data_time_6mo   
data_time_7 = [2.53] ;     %  xiangzhilin
data_time_8 = [1.07] ;    % chenfangqiu
data_time_9 = [1.50,2.53,5.23,7.67,9.67,12.40,15.50] ;     %  xiangzhilin
data_time_10= [0.53,1.33,2.07,4.60,5.63] ;    % chenfangqiu

%% ���Ƹ����˵������仯������Ӧ����ͼ
for i = i_start : i_end
   plot_dose_response_feat_pca(i,roi_num,roi_name,data_row,patient_name,data_time_1,data_str,data_time_2,data_time_3,...
       data_time_4,data_time_5,data_time_6,data_time_7,data_time_8,data_time_9,data_time_10,num_dose_response,...
       dose_x,save_str,line_style,print_select)
end

%% ���Ƹ�������ʱ��������仯ͼ
for i = i_start : i_end
    plot_month_feat_pca(i,roi_num,roi_name,data_row,patient_name,data_time_1,data_str,data_time_2,data_time_3,...
    data_time_4,data_time_5,data_time_6,data_time_7,data_time_8,data_time_9,data_time_10,num_plot_month_feat,...
    save_str,line_style,print_select)
end

disp('�������н�����')