function [planC,save_file] = mat_renew_plan(mat_str,patient_name,data_time,dose_seg,doseNum,seg_linename,lung_start,...
        lung_end,plan_dcm_num,num_image_lungSeg,lung_mask,strName,dose_grid_space,image_grid_space_xyplan,image_grid_space_xy,...
        image_grid_space_z,image_grid_space_zplan,image_size,plan_time);
% ���¶�Ӧʱ��ļƻ�line,�ƻ�CT��ֵ

% ·�����Ƹ�ֵ
filename = [mat_str,'plan\',patient_name,'\',char(data_time),'\planC',char(plan_time)];    % plan�ƻ���׼��
save_file = [filename,'_line'];          % �����ļ�
% ��������
gird_num_incerp_xy = ceil(image_size*image_grid_space_xyplan/image_grid_space_xy);
delete_grid = ceil((gird_num_incerp_xy-image_size)/2) ;   % ����ɾ������������������ά����xy��Ϊ512X512�ߴ�
gird_num_incerp_z = (plan_dcm_num-1)*image_grid_space_zplan/image_grid_space_z ;

%% ����mat�ļ���planC
m = matfile(filename);
global planC 
planC = m.planC;
indexS = planC{end};        % plan�е�����

%% �ѱ༭�õ�lung,dose,image_interp����mat�ļ���planC
structNum_empty = length(planC{1,4});   % �Ѻ�����roi��ɾ��
structNum = structNum_empty+1;
[lungRoiArray,scanInterpArray,X_after,Y_after,Z_after,x_grid,y_grid] = scan_lung_interp_plan(planC,structNum,...
    delete_grid,image_grid_space_xy,image_grid_space_z,gird_num_incerp_z,lung_mask,lung_start,lung_end,strName);
planC{1,4}(1) = lungRoiArray;            % ���ǵ�һ����ȥ�������roi��
planC{1,4}(1).roiNumber = 1; 
planC{1,4}(1). structureName = seg_linename ;   % �Ѳ�ֵ���lung������Ϊlung_seg
planC{1,3} = scanInterpArray ;
% դ�񻯵ȼ����ߣ�����CERR��gui����ROI֮�䲻�ܲ�������
[segmentsM] = doseRoiRasterSeg(1,planC);
planC{indexS.structures}(1).rasterSegments = segmentsM;
for i = 3:(structNum_empty-9)    % �������գ�����ֲ�����ʾ�Ĵ���
    planC{1,4}(i) = [];            % ȥ�������roi��
end

%% ѭ���������м�����
planC{indexS.dose}(doseNum);    % ����ȫ�ּ������ֵ��ȷ��������������
doseArray = planC{indexS.dose}(doseNum).doseArray;    %method2
dose_max = max(max(max(doseArray)));
dose_slicer = fix(dose_max/dose_seg);

%% �Ѽ�����д��mat�ļ�
i0 = 1;
while i0 < dose_slicer+1
    dose_value = dose_seg*i0 ;
    structNum = i0+1;
    % ����ȼ����߲�������mat�ļ�
    [dose_line] = doseLineSeg_plan(planC,dose_value,structNum,doseNum,X_after,Y_after,Z_after,x_grid,y_grid);
    planC{indexS.structures}(structNum) = dose_line;
    % դ�񻯵ȼ����ߣ�����CERR��gui����ROI֮�䲻�ܲ�������
    [segmentsM] = doseRoiRasterSeg(structNum,planC);
    planC{indexS.structures}(structNum).rasterSegments = segmentsM;
    i0 =i0+1;
end