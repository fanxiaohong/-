function [planC] = dose_line_clear_simplify(planC,k);;
% ����ظ��ļ�����

% ����mat�ļ���planC
% m = matfile(filename);
global planC 
% planC = m.planC;
indexS = planC{end};        % plan�е�����

% ѭ��dose10��dose65��ȥ�������dose5�ķָ�
dose5 = planC{1,4}(2);        % dose5�ļ�����
dose5_line = dose5.contour;
dose_line_length = length(dose5.contour);   % �ܵĳ���
% for k = 3 : 14 % ѭ��dose10��dose65��ȥ�������dose5�ķָ�
eval(['dose_clear = planC{1,4}(',num2str(k),');']);        % dose10�ļ�����
dose_clear_line = dose_clear.contour;
for i = 1 : dose_line_length  % ѭ������slice����ǰslice
    dose5_point = dose5_line(i).segments;   % ��ȡ��ǰslice��edose5�Ľṹ�����
    eval(['dose_clear_point = dose_clear_line(',num2str(i),').segments;']);
    len_dose_clear = length(dose_clear_point);  % ��ǰdose��ǰslice�Ľṹ�����
    for j = 1: length(dose5_point)   % ѭ����ǰdose5����������doseline
        size_dose5 = size(dose5_point(j).points);
        l = 1 ;
        while l < (len_dose_clear+1) 
            eval(['size_dose_clear = size(dose_clear_point(',num2str(l),').points);']);  % ��ȡ��ǰ����dose�߳ߴ�
            if size_dose5(1) == size_dose_clear(1)
                eval(['dose_clear_point(',num2str(l),') = [];']) ; 
                len_dose_clear = len_dose_clear-1 ;  % ��Ϊ��յ�ԭ�����Լ�ȥ1
            end
            l = l+1 ;
        end
    end
    % �������������滻
    eval(['dose_clear_line(',num2str(i),').segments = dose_clear_point ;']);
end
 % �����������ݴ���planC
eval(['planC{1,4}(',num2str(k),').contour = dose_clear_line;']);

end              





