% 测试发病时间病人纹理数据中的统计指标
clc;
close all;
clear all;

%% 公共超参数，需要自己设定的数据
result_str = 'E:/roi_feat_dose/result/';
data_str = [result_str,'feature_lung_all.xls'];
save_str = [result_str,'plot_compare/matlab_treat/'];   % figure画出的图保存
roi_num = 10 ; % roi的数量
data_row = 2 ;  % 特征是的列位置，第一列是lung舍去
num_plot_month_feat = 4;    % 观察的roi区间数目
num_dose_response = [1,2,3,4,8,9,10,11,12];    %  做剂量响应曲线的病人顺序号，
dose_x = [2.5,7.5,12.5,17.5,22.5,30,40,50,60]  ; % 剂量横坐标，剂量区间中间点
% feat = [53,62,141,167,278,825,841,855,866,883,886,944,970,978,996,1004,1030,1046,1056,1064,1175];
feat = 61; ;%[58,61,17,271,178,182,183] ;   % 58,61,17,271看出20和30次高剂量去差异不大，178,182,183供给量取差异大。
print_select = 0 ;  % 是否打印图片，1打印，其余如0等不打印

%%  病人的超参数
roi_name = {'lung','dose0-5','dose5-10','dose10-15','dose15-20','dose20-25','dose25-35','dose35-45','dose45-55','dose55-65'};
patient_name = {'1.zhouzhengyuan','2.huhongjun','3.pengzhenwu','4.jiangxiaoping','5.fengjuyun','6.moyuee',...
    '7.xiangzhilin','8.chenfangqiu','9.yinyunhua','10.tanghaibo','11.wangziran','12.caoboyun'};
line_style = {'+','o','*','x','s','d','p','h','>','<','+','o','*','x','s','d','p','h','>','<'};  % plot数据标记点设置
% 各病人诊断CT时间
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

%% 绘制各病人的特征变化剂量响应曲线图
for k = 1:length(feat)
    i = feat(k);
    % 绘制各病人的特征变化剂量响应曲线图
   plot_dose_response_feat(i,roi_num,roi_name,data_row,patient_name,data_time_1,data_str,data_time_2,data_time_3,...
       data_time_4,data_time_5,data_time_6,data_time_7,data_time_8,data_time_9,data_time_10,num_dose_response,...
       dose_x,save_str,line_style,print_select,data_time_11,data_time_12)
   % 绘制各病人随时间的特征变化图
%     plot_month_feat(i,roi_num,roi_name,data_row,patient_name,data_time_1,data_str,data_time_2,data_time_3,...
%     data_time_4,data_time_5,data_time_6,data_time_7,data_time_8,data_time_9,data_time_10,num_plot_month_feat,...
%     save_str,line_style,print_select,data_time_11,data_time_12)
end

disp('程序运行结束！')