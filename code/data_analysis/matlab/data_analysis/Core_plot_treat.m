% ���Է���ʱ�䲡�����������е�ͳ��ָ��
clc;
close all;
clear all;

%% ��������������Ҫ�Լ��趨������
result_str = 'E:/roi_feat_dose/result/';
data_str = [result_str,'feature_lung_all.xls'];
save_str = [result_str,'plot_compare/matlab_treat/'];   % figure������ͼ����
roi_num = 10 ; % roi������
data_row = 2 ;  % �����ǵ���λ�ã���һ����lung��ȥ
num_plot_month_feat = 4;    % �۲��roi������Ŀ
num_dose_response = [1,2,3,4,8,9,10,11,12];    %  ��������Ӧ���ߵĲ���˳��ţ�
dose_x = [2.5,7.5,12.5,17.5,22.5,30,40,50,60]  ; % ���������꣬���������м��
% feat = [53,62,141,167,278,825,841,855,866,883,886,944,970,978,996,1004,1030,1046,1056,1064,1175];
feat = 61; ;%[58,61,17,271,178,182,183] ;   % 58,61,17,271����20��30�θ߼���ȥ���첻��178,182,183������ȡ�����
print_select = 0 ;  % �Ƿ��ӡͼƬ��1��ӡ��������0�Ȳ���ӡ

%%  ���˵ĳ�����
roi_name = {'lung','dose0-5','dose5-10','dose10-15','dose15-20','dose20-25','dose25-35','dose35-45','dose45-55','dose55-65'};
patient_name = {'1.zhouzhengyuan','2.huhongjun','3.pengzhenwu','4.jiangxiaoping','5.fengjuyun','6.moyuee',...
    '7.xiangzhilin','8.chenfangqiu','9.yinyunhua','10.tanghaibo','11.wangziran','12.caoboyun'};
line_style = {'+','o','*','x','s','d','p','h','>','<','+','o','*','x','s','d','p','h','>','<'};  % plot���ݱ�ǵ�����
% ���������CTʱ��
data_time_1 = [20,30] ;    % zhouzhengyuan
data_time_2 = [20,30] ;   %huhongjun
data_time_3 = [30] ;     %  pengzhenwu
data_time_4 = [30] ;    %   jiangxiaoping
data_time_5 = [2.63] ;       %   fengjuyun
data_time_6 = [3.73,6.77,8.40,11.73,14.43] ;   %  data_time_6mo   
data_time_7 = [2.53] ;     %  xiangzhilin
data_time_8 = [20] ;    % chenfangqiu
data_time_9 = [30] ;     %  xiangzhilin
data_time_10= [10,30] ;    % chenfangqiu
data_time_11= [20,30] ;    % 11.wangziran
data_time_12= [10] ;    % 12.caoboyun

%% ���Ƹ����˵������仯������Ӧ����ͼ
for k = 1:length(feat)
    i = feat(k);
    % ���Ƹ����˵������仯������Ӧ����ͼ
   plot_dose_response_feat(i,roi_num,roi_name,data_row,patient_name,data_time_1,data_str,data_time_2,data_time_3,...
       data_time_4,data_time_5,data_time_6,data_time_7,data_time_8,data_time_9,data_time_10,num_dose_response,...
       dose_x,save_str,line_style,print_select,data_time_11,data_time_12)
   % ���Ƹ�������ʱ��������仯ͼ
%     plot_month_feat(i,roi_num,roi_name,data_row,patient_name,data_time_1,data_str,data_time_2,data_time_3,...
%     data_time_4,data_time_5,data_time_6,data_time_7,data_time_8,data_time_9,data_time_10,num_plot_month_feat,...
%     save_str,line_style,print_select,data_time_11,data_time_12)
end

disp('�������н�����')