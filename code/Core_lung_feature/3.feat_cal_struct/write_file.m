function [feat_name,col_name] = write_file(featS_after,filt_name,roi_name,data_time);
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

%% ѭ�������ͷ,��ȡ������
feat_name = [];
for i = 1 : n_imagetype
    for j =1 : n_feature
        colum1 = [];    % ��ͷ�������͵ĸ�ֵ
        colum2 = [] ;
        if j>=3 & j<=12
            name = strsplit(char(radiomics_feature(j)),'.');
            feat_name_read = fieldnames(featS_after.(char(roi_name(1))).(char(filt_name(i))).(char(name(1))).(char(name(2))));
            colum1 = cell(length(feat_name_read),1);    % ��ͷ�������͵ĸ�ֵ
            colum2 = colum1 ;
            for k=1:length(feat_name_read)
                colum1{k,1} = char(filt_name(i));
                colum2{k,1} = char(radiomics_feature(j));
            end
            feat_name_all = [colum1,colum2,feat_name_read] ;
            feat_name = [feat_name;feat_name_all];   % �������ݶѵ�����
        else
            feat_name_read = fieldnames(featS_after.(char(roi_name(1))).(char(filt_name(i))).(char(radiomics_feature(j))));
            colum1 = cell(length(feat_name_read),1);    % ��ͷ�������͵ĸ�ֵ
            colum2 = colum1 ;
            for k=1:length(feat_name_read)
                colum1{k,1} = char(filt_name(i));
                colum2{k,1} = char(radiomics_feature(j));
            end
            feat_name_all = [colum1,colum2,feat_name_read] ;
            feat_name = [feat_name;feat_name_all];   % �������ݶѵ�����
        end
    end
end

%% ���һ�еı�ͷ
col_name_datatime = [] ;
col_name_roi = [] ;
for j = 1 : length(data_time)
    col_name_roi = [col_name_roi,roi_name] ;
    for k = 1 : length(roi_name)
        col_name_datatime = [col_name_datatime,data_time(j)];
    end
end
col_name2 = [col_name_datatime;col_name_roi];
col_name1 = {'ͼ������','��������','������';'ͼ������','��������','������'};
col_name = [col_name1,col_name2];

