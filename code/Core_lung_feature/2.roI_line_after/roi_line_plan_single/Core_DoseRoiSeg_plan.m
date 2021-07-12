clc;
clear all;
t1=clock;

%% ������������mat�ļ���mat.bz2ѹ�����Ĳ���
mat_str = 'E:/roi_feat_dose/plan/';
patient_name = 'zhouzhengyuan\';
data_time = '190619\' ;
filename = [mat_str,patient_name,data_time,'planC190505'];    % plan�ƻ���׼��
save_file = [filename,'_line'];          % �����ļ�
dose_seg = 5 ;          % �����������䣬dose bin
roi_num_start = 19 ;     % ���е�roi����
doseNum = 7;             % �õڼ��ּ�������������Ԫ����7�����������1
seg_linename = 'lung_seg' ; % �ηָ�������
lung_start = 2 ;      % �β�ͼ��ʼslicer
lung_end = 45 ;   % �β�ͼ�����slicer
num_image_lungSeg = 269;  % �ηָ�ͼƬ����
lung_mask = 1 ;          % �ηָ�mask�����ֵ
strName = 'lung';        % ������
dose_grid_space = 0.4 ;
image_grid_space_xyplan = 0.976563 ;
image_grid_space_xy = 0.7734379768 ;
image_grid_space_z = 1 ;
gird_num_incerp_xy = ceil(512*image_grid_space_xyplan/0.7734379768);
delete_grid = ceil((gird_num_incerp_xy-512)/2) ;   % ����ɾ������������������ά����xy��Ϊ512X512�ߴ�
gird_num_incerp_z = (46-1)*5/1 ;

%% ����mat�ļ���planC
m = matfile(filename);
global planC 
planC = m.planC;
indexS = planC{end};        % plan�е�����

%% �ѱ༭�õ�lung,dose,image_interp����mat�ļ���planC
structNum = roi_num_start+1;
[lungRoiArray,scanInterpArray,X_after,Y_after,Z_after,x_grid,y_grid] = scan_lung_interp_plan(planC,structNum,...
    delete_grid,image_grid_space_xy,image_grid_space_z,gird_num_incerp_z,lung_mask,lung_start,lung_end,strName);
planC{1,4}(1) = lungRoiArray;            % ���ǵ�һ����ȥ�������roi��
planC{1,4}(1).roiNumber = 1; 
planC{1,3} = scanInterpArray ;
% դ�񻯵ȼ����ߣ�����CERR��gui����ROI֮�䲻�ܲ�������
[segmentsM] = doseRoiRasterSeg(1,planC);
planC{indexS.structures}(1).rasterSegments = segmentsM;
for i = 3:10
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

%% ������ĺ�����ݵ�mat�ļ���
save(save_file,'planC');   % ������ĺ�����ݵ�mat�ļ���

%% �����ܵ�����ʱ��
t2=clock;
etime(t2,t1)