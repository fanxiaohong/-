function [feature_dataTotal_hu,feature_dataTotal_zhou,feature_txt] =...
    dataEqual(num_feature_zhou,txt_zhou,num_feature_hu,txt_hu,result_str);
% ɸѡ������ͬ������ָ�겢���

%% ����ָ����ͬ�����������
sum_all = 0;
feature_dataTotal_hu = [];
feature_dataTotal_zhou = [];
feature_txt = [];
for len1 = 1:length(txt_zhou)
    for len2 = 1:length(txt_hu)
        if isequal(txt_zhou(len1,1),txt_hu(len2,1)) % ���ָ����ͬ��ͳ�ƺͼ�1
            sum_all = sum_all+1;
            feature_dataTotal_hu = [feature_dataTotal_hu;num_feature_hu(len2,:)];
            feature_dataTotal_zhou = [feature_dataTotal_zhou;num_feature_zhou(len1,:)];
            feature_txt = [feature_txt;txt_hu(len2,:)];
            formatSpec = '��ͬ��������%d �к͵� %d �к͵� %d ��\n';
            fprintf(formatSpec,len1,len2)
            break
        end
    end
end
fprintf('������ͬ����: %d\n',sum_all');
feat_choose = {feature_txt,feature_dataTotal_hu,feature_dataTotal_zhou};


