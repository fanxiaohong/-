
function [feat_matrix] = write_flie(featS_after,featS_plan,filt_name,roi_name,save_file_temp);
% 在excel文件写入表头的标示性信息

radiomics_feature = {'firstOrderS','shapeS',...
    'glcmFeatS.AvgS','glcmFeatS.MaxS','glcmFeatS.MinS','glcmFeatS.StdS','glcmFeatS.MadS',...
    'rlmFeatS.AvgS','rlmFeatS.MaxS','rlmFeatS.MinS','rlmFeatS.StdS','rlmFeatS.MadS',...
    'ngtdmFeatS','ngldmFeatS','szmFeatS','ivhFeaturesS'};

% 参数计算
len = size(roi_name);
roi_num = len(2);
len1 = size(filt_name);
n_imagetype = len1(2);
n_feature = length(radiomics_feature);

%% 循环输出feat_data
feat_aft = [];
feat_pl = [];
feat_matrix = [] ;
for n = 1:roi_num
    feat_after_data = [];
    feat_plan_data = [];
    % 提取特征名，单个循环共有299个特征
    for i = 1 : n_imagetype
        for j =1 : n_feature
            %  提取stcture中对应特征的数值
            eval(['feat_after','=','struct2cell(featS_after.',cell2mat(roi_name(n)),'.',cell2mat(filt_name(i)),'.',cell2mat(radiomics_feature(j)),');']);
            eval(['feat_plan','=','struct2cell(featS_plan.',cell2mat(roi_name(n)),'.',cell2mat(filt_name(i)),'.',cell2mat(radiomics_feature(j)),');']);
            feat_after_data = [feat_after_data;feat_after];   % 按roi水平存储数据
            feat_plan_data = [feat_plan_data;feat_plan];      % 按roi水平存储数据
        end
    end
    feat_aft = [feat_aft,feat_after_data];   % 按roi水平存储数据
    feat_pl = [feat_pl,feat_plan_data];      % 按roi水平存储数据
end

clm_after = ['A',num2str(1)];
xlswrite(save_file_temp,feat_aft,'after',clm_after);     % 把特征数据写入excel文件中转一下，因为无法操作cell做运算
[feature_after] = xlsread(save_file_temp,'after');
clm_plan = ['A',num2str(1)];
xlswrite(save_file_temp,feat_pl,'plan',clm_plan);     % 把特征数据写入excel文件中转一下，因为无法操作cell做运算
[feature_plan] = xlsread(save_file_temp,'plan');
delete([save_file_temp]);
feat_matrix = (feature_after - feature_plan)./feature_plan*100 ;
