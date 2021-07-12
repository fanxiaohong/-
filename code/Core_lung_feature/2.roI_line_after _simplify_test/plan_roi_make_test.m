function [planC,save_file] = plan_roi_make(mat_str,patient_name,plan_time,data_time,p);
% ģʽ2���������е������õļƻ�CT��ֵ��������ʱ���ļƻ�CT

%% ·�����Ƹ�ֵ
filename_plan = [mat_str,'plan\',patient_name,'\',char(data_time(1)),'\planC',char(plan_time),'_roi'];    % �����õ�plan�ƻ�
filename_diagnose = [mat_str,'plan\',patient_name,'\',char(data_time(p)),'\planC',char(data_time(p))];    % plan�ƻ���׼��
save_file = [mat_str,'plan\',patient_name,'\',char(data_time(p)),'\planC',char(plan_time),'_roi'];    % % �����ļ�
str_plantime = char(plan_time);      % �Ѽƻ�ʱ���ַ�������������ֽ�
str_lungSeg = [mat_str,'data\',patient_name,'\segment\segment_',char(data_time(p)),'\label_creat\']; % �β��ָ�ͼƬ���λ��
str_plan_remain = [mat_str,'data\',patient_name,'\original\20',str_plantime(1:2),'-',str_plantime(3:4),'-',str_plantime(5:6),'plan'] ;   % �ƻ�ʣ���ļ���ŵ�ַ
num_image_lungSeg = length(dir([str_lungSeg,'*.bmp']));   % ��ȡĿ���ļ�����ͼƬlabel�ļ�������

%% �����Ӧ���mat�ļ���planC
m = matfile(filename_diagnose);
global planC 
planC = m.planC;
indexS = planC{end};        % plan�е�����
% ��������
scanNum = 1;
scan3M = getScanArray(scanNum,planC); 
[xScanVals, yScanVals, zScanVals] = getScanXYZVals(planC{indexS.scan}(scanNum));
image_grid_space_xy = double(abs(xScanVals(2)-xScanVals(1)))*10;   % x,y���
image_grid_space_z = abs(zScanVals(2)-zScanVals(1))*10;   % x,y���

%% ���������õ�plan_roi_mat�ļ���planC
m = matfile(filename_plan);
global planC 
planC = m.planC;
indexS = planC{end};        % plan�е�����
% ��������
scanNum = 1;
scan3M = getScanArray(scanNum,planC); 
[xScanVals, yScanVals, zScanVals] = getScanXYZVals(planC{indexS.scan}(scanNum));
image_grid_space_xyplan = double(abs(xScanVals(2)-xScanVals(1)))*10;   % x,y���
image_grid_space_zplan = abs(zScanVals(2)-zScanVals(1))*10;   % x,y���
% ��������
gird_num_incerp_xy = ceil(image_size*image_grid_space_xyplan/image_grid_space_xy);
delete_grid = ceil((gird_num_incerp_xy-image_size)/2) ;   % ����ɾ������������������ά����xy��Ϊ512X512�ߴ�
gird_num_incerp_z = (length(zScanVals)-1)*image_grid_space_zplan/image_grid_space_z ;

%% ѭ����ֵ
structNum_plan_roi = length(planC{1,4}) ;   % ���㵱ǰ���õ�planC��roi����

%% �β���ֵ
% ��ӡһ��Ŀ¼
indexS = planC{end};        % plan�е�����
% ��ȡɨ�����CT����X,Y,Z
scanNum = 1;
planC{indexS.scan}(scanNum);
sliceNum = 1;
planC{indexS.scan}(scanNum).scanInfo(sliceNum);
[xScanVals, yScanVals, zScanVals] = getScanXYZVals(planC{indexS.scan}(scanNum));
x_grid = ceil((max(xScanVals)-min(xScanVals(2)))/length(xScanVals))/10;
y_grid = ceil((max(yScanVals)-min(yScanVals(2)))/length(yScanVals))/10;
scan3M = getScanArray(scanNum,planC); 

% ��ȡ��������׼���3ά����;
X_after = [];  % �������ǰ����
for i= 1:512
    x_after_data = min(xScanVals)+delete_grid*image_grid_space_xy*0.1 + (i-1)*image_grid_space_xy*0.1 ;
    X_after = [X_after,x_after_data];
end
Y_after = [];  % �������ǰ����
for i= 1:512
    y_after_data = max(yScanVals) -delete_grid*image_grid_space_xy*0.1- (i-1)*image_grid_space_xy*0.1 ;
    Y_after = [Y_after,y_after_data];
end
Z_after = [];  % �������ǰ����
for i= 1:(gird_num_incerp_z+1)
    z_after_data = max(zScanVals)  - (i-1)*image_grid_space_z*0.1 ;
    Z_after = [Z_after;z_after_data];
end
Z_after = Z_after(end:-1:1) ;  % ���굹��






for struct_num = 1 : structNum_plan_roi
    
end





