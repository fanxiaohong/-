% Define data source and destination paths 
clc;
clear all;
close all;

sourceDir = 'E:\\mat_import_dcm\\2018-10-10plan\\';    
destinationDir = 'E:\\mat_file\\A\\';
file_name = 'B1' ;   % 保存的mat文件的名称

%Set flags for compression and merging
zipFlag = 'No'; %Set to 'Yes' for compression to bz2 zip 
mergeScansFlag = 'Yes'; %Set to 'Yes' to merge all scans into a single series

%Batch import
init_ML_DICOM;
batchConvert_lung (sourceDir,destinationDir,zipFlag,mergeScansFlag,file_name);