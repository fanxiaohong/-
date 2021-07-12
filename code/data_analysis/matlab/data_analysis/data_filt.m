function [feat_num,feature_total3,feature_txt3] = data_filt(data_str,patient_name,row,datatime_num,...
    silk_data,silk_percent,width,data_limit);
% ɸѡ��������

%% �������ݶ�ȡ��num���ص���excel�е����ݣ�txt��������ı����ݣ�row�������δ��������
[num_feature] = xlsread(data_str,patient_name);
[num_feature,txt] = xlsread(data_str,patient_name);

%% �����ľ���
len = size(num_feature);
col = len(1);   % ����

%% ������������ֵ�仯�ٷֱ�
for j= 1:row
    for i = 1:col
        for k = 1:datatime_num
            % �Լƻ�ʱ���ǰ�仯��
            eval(['feature_',num2str(k),'=','num_feature(:,',num2str(k),');',]);
        end
    end
end

% �Ѳ���ʱ�����ݵ�����ֵ
eval(['silk','=','feature_',num2str(silk_data),';']);

%% ѭ��ɸѡ
for comp_col = 1:row
    % ��һ��ɸѡ���ٲ���ʱ�仯���ȴ���15%
    k1 =1;
    feature_total1 = [];
    for i = 1:col-2
        if  (abs(silk(i,comp_col))>silk_percent) & (abs(silk(i,comp_col))< data_limit)
            for j= 1:row
                feature_txt1(k1,1) = txt(i,1);
                for k =1:datatime_num
                    eval(['feature_total1','(k1,j+k-1)','=','feature_',num2str(k),'(i,j);']);
                end
            end
            k1 = k1 + 1;
        end
    end

    %% �ڶ�ϵ��ɸѡ���ٺ���ʱ�������widthҪ��
    k2 =1;
    feature_total2 = [];
    for i = 1:k1-1
        k2_data = 0;
        k2_sum = 0;
        while k2_data < (datatime_num-silk_data+1)    % ѭ���жϸ���ʱ����Ƿ����width��Ҫ��
            if abs(feature_total1(i,silk_data+k2_data))>(silk_percent-width)
                k2_sum = k2_sum+1;
            end
            k2_data = k2_data+1;
        end
        if  k2_sum == (datatime_num-silk_data+1)
            for j= 1:row
                feature_txt2(k2,1) = feature_txt1(i,1);
                for k =1:datatime_num
                    eval(['feature_total2','(k2,j+k-1)','=','feature_total1','(i,j+k-1);']);
                end
            end
            k2 = k2+1;
        end
    end

    %% ����ϵ��ɸѡ��ͬ����
    k3 =1;
    feature_total3 = [];
    for i = 1:k2-1
        k3_data = 1;
        k3_sum = 0;
        while k3_data < (datatime_num)    % ѭ���жϸ���ʱ����Ƿ�ͬ����
            if feature_total2(i,k3_data)*feature_total2(i,k3_data+1) > 0
                k3_sum = k3_sum+1;
            end
            k3_data = k3_data+1;
        end
        if  k3_sum == (datatime_num-silk_data) 
            for j= 1:row
                feature_txt3(k3,1) = feature_txt2(i,1);
                for k =1:datatime_num
                    eval(['feature_total3','(k3,j+k-1)','=','feature_total2','(i,j+k-1);']);
                end
            end
            k3 = k3+1;
        end
    end
end

feat_num = length(feature_txt3); 

% %% ����ɸѡ��������
% xlswrite(save_str,feature_total3,'����','B3');
% xlswrite(save_str,feature_txt3,'����','A3');

