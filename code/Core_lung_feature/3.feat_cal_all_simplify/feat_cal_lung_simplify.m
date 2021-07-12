function [featSAll] = feat_cal_lung_simplify(filename,paramS);
% 计算全部纹理特征值

%% 载入mat文件，planC
m = matfile(filename);
global planC 
planC = m.planC;

%% plan有的内容
indexS = planC{end};        % plan有的内容
strC = {planC{indexS.structures}.structureName};    % 根据plan中structure的位置得到他的位置编号数字

%% 循环计算几个roi
roi_num = length(paramS.structuresC);   % 替换原来的输入，改为直接读取参数文件
featSAll = [];
for n = 1:roi_num
    structNum = getMatchingIndex(paramS.structuresC{n},strC,'exact');    % 根据参数设置文件得到ROI的数字
    scanNum = getStructureAssociatedScan(structNum,planC);
    featS = calcGlobalRadiomicsFeatures_lung(scanNum, structNum, paramS, planC);   % 计算所有的纹理特征
    featSAll = [featSAll,featS];   % 组装所有特征值
end