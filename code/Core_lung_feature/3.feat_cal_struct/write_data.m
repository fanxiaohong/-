
function [feat_matrix] = write_flie(featS_after,featS_plan,filt_name,roi_name,save_file_temp);
% ��excel�ļ�д���ͷ�ı�ʾ����Ϣ

radiomics_feature = {'firstOrderS','shapeS',...
    'glcmFeatS.AvgS','glcmFeatS.MaxS','glcmFeatS.MinS','glcmFeatS.StdS','glcmFeatS.MadS',...
    'rlmFeatS.AvgS','rlmFeatS.MaxS','rlmFeatS.MinS','rlmFeatS.StdS','rlmFeatS.MadS',...
    'ngtdmFeatS','ngldmFeatS','szmFeatS','ivhFeaturesS'};

% ��������
len = size(roi_name);
roi_num = len(2);
len1 = size(filt_name);
n_imagetype = len1(2);
n_feature = length(radiomics_feature);

%% ѭ�����feat_data
feat_aft = [];
feat_pl = [];
feat_matrix = [] ;
for n = 1:roi_num
    feat_after_data = [];
    feat_plan_data = [];
    % ��ȡ������������ѭ������299������
    for i = 1 : n_imagetype
        for j =1 : n_feature
            %  ��ȡstcture�ж�Ӧ��������ֵ
            eval(['feat_after','=','struct2cell(featS_after.',cell2mat(roi_name(n)),'.',cell2mat(filt_name(i)),'.',cell2mat(radiomics_feature(j)),');']);
            eval(['feat_plan','=','struct2cell(featS_plan.',cell2mat(roi_name(n)),'.',cell2mat(filt_name(i)),'.',cell2mat(radiomics_feature(j)),');']);
            feat_after_data = [feat_after_data;feat_after];   % ��roiˮƽ�洢����
            feat_plan_data = [feat_plan_data;feat_plan];      % ��roiˮƽ�洢����
        end
    end
    feat_aft = [feat_aft,feat_after_data];   % ��roiˮƽ�洢����
    feat_pl = [feat_pl,feat_plan_data];      % ��roiˮƽ�洢����
end

clm_after = ['A',num2str(1)];
xlswrite(save_file_temp,feat_aft,'after',clm_after);     % ����������д��excel�ļ���תһ�£���Ϊ�޷�����cell������
[feature_after] = xlsread(save_file_temp,'after');
clm_plan = ['A',num2str(1)];
xlswrite(save_file_temp,feat_pl,'plan',clm_plan);     % ����������д��excel�ļ���תһ�£���Ϊ�޷�����cell������
[feature_plan] = xlsread(save_file_temp,'plan');
delete([save_file_temp]);
feat_matrix = (feature_after - feature_plan)./feature_plan*100 ;
