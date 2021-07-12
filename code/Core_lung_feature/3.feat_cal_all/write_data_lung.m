function [feat_matrix_all] = write_data_lung(data_time,mat_str,patient_name,roi_name,name_time,paramS);
% 在excel文件写入表头的标示性信息

feat_matrix_all = [] ;
for p = 1 : length(data_time)
    filename_after = [mat_str,patient_name,'\',char(data_time(p)),'\planC',char(data_time(p)),'_roi.mat'];    % plan计划配准后
    filename_plan = [mat_str,patient_name,'\',char(data_time(p)),'\planC',name_time,'_roi.mat'];    % plan计划配准后
    % 计算全部纹理特征值
    [featS_after] = feat_cal_lung(filename_after,paramS,roi_name);  % 计算治疗后特征值
    [featS_plan] = feat_cal_lung(filename_plan,paramS,roi_name);
    % 把计算得出的feat结构体写入excel文件
    feat_matrix = (featS_after - featS_plan)./featS_plan*100 ;
    feat_matrix_all = [feat_matrix_all,feat_matrix] ;
%     clm_data = ['D',num2str(3)];     % 把特征名称写入excel文件
%     xlswrite(save_file,feat_matrix_all,patient_name,clm_data);
end