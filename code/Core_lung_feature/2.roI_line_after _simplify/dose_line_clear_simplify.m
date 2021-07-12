function [planC] = dose_line_clear_simplify(planC,k);;
% 清除重复的剂量线

% 载入mat文件，planC
% m = matfile(filename);
global planC 
% planC = m.planC;
indexS = planC{end};        % plan有的内容

% 循环dose10到dose65，去除多余的dose5的分割
dose5 = planC{1,4}(2);        % dose5的剂量线
dose5_line = dose5.contour;
dose_line_length = length(dose5.contour);   % 总的长度
% for k = 3 : 14 % 循环dose10到dose65，去除多余的dose5的分割
eval(['dose_clear = planC{1,4}(',num2str(k),');']);        % dose10的剂量线
dose_clear_line = dose_clear.contour;
for i = 1 : dose_line_length  % 循环所有slice，当前slice
    dose5_point = dose5_line(i).segments;   % 读取当前slice的edose5的结构体个数
    eval(['dose_clear_point = dose_clear_line(',num2str(i),').segments;']);
    len_dose_clear = length(dose_clear_point);  % 求当前dose当前slice的结构体个数
    for j = 1: length(dose5_point)   % 循环当前dose5个数并清理doseline
        size_dose5 = size(dose5_point(j).points);
        l = 1 ;
        while l < (len_dose_clear+1) 
            eval(['size_dose_clear = size(dose_clear_point(',num2str(l),').points);']);  % 读取当前清理dose线尺寸
            if size_dose5(1) == size_dose_clear(1)
                eval(['dose_clear_point(',num2str(l),') = [];']) ; 
                len_dose_clear = len_dose_clear-1 ;  % 因为清空的原因，所以减去1
            end
            l = l+1 ;
        end
    end
    % 把清理后的数据替换
    eval(['dose_clear_line(',num2str(i),').segments = dose_clear_point ;']);
end
 % 把清理后的数据存入planC
eval(['planC{1,4}(',num2str(k),').contour = dose_clear_line;']);

end              





