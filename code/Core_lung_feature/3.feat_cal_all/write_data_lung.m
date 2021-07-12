function [feat_matrix_all] = write_data_lung(data_time,mat_str,patient_name,roi_name,name_time,paramS);
% ��excel�ļ�д���ͷ�ı�ʾ����Ϣ

feat_matrix_all = [] ;
for p = 1 : length(data_time)
    filename_after = [mat_str,patient_name,'\',char(data_time(p)),'\planC',char(data_time(p)),'_roi.mat'];    % plan�ƻ���׼��
    filename_plan = [mat_str,patient_name,'\',char(data_time(p)),'\planC',name_time,'_roi.mat'];    % plan�ƻ���׼��
    % ����ȫ����������ֵ
    [featS_after] = feat_cal_lung(filename_after,paramS,roi_name);  % �������ƺ�����ֵ
    [featS_plan] = feat_cal_lung(filename_plan,paramS,roi_name);
    % �Ѽ���ó���feat�ṹ��д��excel�ļ�
    feat_matrix = (featS_after - featS_plan)./featS_plan*100 ;
    feat_matrix_all = [feat_matrix_all,feat_matrix] ;
%     clm_data = ['D',num2str(3)];     % ����������д��excel�ļ�
%     xlswrite(save_file,feat_matrix_all,patient_name,clm_data);
end