import os
import numpy as np
import pandas as pd
from sklearn.feature_selection import SelectKBest
from sklearn.feature_selection import chi2
import torch.utils.data as Data
import matplotlib.pyplot as plt
from timeit import default_timer as timer
import warnings
from sklearn import preprocessing
import timeit
import xlrd
from sklearn.decomposition import PCA
import csv
warnings.filterwarnings("ignore")
######    数据处理模块

###############################################################################################
# 加载数据集，chi2检验用数据预处理
def data_feat_filt(str_data,str_name,method,patient_datatime,roi_name,odd_threshold,roi_num,roi_mode,train_Label):
    # 获取workbook中所有的表格
    wb = xlrd.open_workbook(str_data)
    patient_name = wb.sheet_names()
    feature_name = pd.read_csv(str_name)         #读取csv文件中的纹理特征名称列表
    feature_name = feature_name.values.tolist()
    str_list = []
    str_list.extend([x[0] for x in feature_name])   # 去掉列表中元素的中括号
    feature_name = str_list
    # 循环遍历所有sheet
    print('load data...')
    # 读入训练数据
    train = pd.read_excel(str_data, sheetname= patient_name[0])   # 读取数据
    trainData = train.values[1:,1:]  # 读入评估数据
    for i in range(1,len(patient_datatime)):
        df = pd.read_excel(str_data, sheet_name=i, index=False, encoding='utf8')
        train_Data = df.values[1:, 1:]  # 读入评估数据
        trainData = np.concatenate((trainData,train_Data), axis=1)  # 默认情况下，axis=0可以不写
    # 转置矩阵方便分析
    # trainData = trainData.T
    trainData = trainData.astype(np.float64) # 将这个数组转化为 float64 位的数组
    # 将矩阵中的NaN替换为0
    print('replace nan...')
    where_are_nan = np.isnan(trainData)    # 将矩阵中的NaN替换为0
    trainData[where_are_nan] = 0
    # 溢出float 64处理
    print('filt odd data...')
    data_filt = []
    name_filt = []
    for j in range(trainData.shape[0]):
        if (trainData[j,:].max() <= odd_threshold) & (trainData[j,:].min() >= -odd_threshold):
            data_filt.append(trainData[j,:])
            name_filt.append(feature_name[j])
    trainData = np.array(data_filt)  # 将这个数组转化为 float64 位的数组
    # print(len(name_filt))
    ## 根据数据的合并形式，mode为1则合并肉为一列，42X9900，为0不为1则是420X990
    if roi_mode == 1:
        name_filt_all = []
        for j in range(roi_num):    # 为标签打上后缀第几个roi
            name_filt_temp = []
            for i in range(len(name_filt)):
                name_filt_temp.append(str(name_filt[i])+ roi_name[j])
            name_filt_all = np.hstack((name_filt_all, name_filt_temp))   # list横向合并
        # print(len(name_filt_all))
        # print(name_filt_all)
        # 把每一个病人10个roi即10列组装成一个数据
        kmeans = []
        patient_data = int(trainData.shape[1]//roi_num)
        for j in range(patient_data):
            trainData_kmeans = []
            for k in range(roi_num):
                trainData_kmeans = np.concatenate((trainData_kmeans,trainData[:,k+j*roi_num]), axis=0)
            kmeans.append(trainData_kmeans)
        trainData = np.array(kmeans)  # 将这个数组转化为 float64 位的数组
        train_Label = train_Label
    else:    # 根据数据的合并形式，mode为1则合并肉为一列，42X9900，为0不为1则是420X990
        if roi_mode == 0 :
            name_filt_all = name_filt
            trainData = np.array(trainData.T)
            ##  组装label
            label = []
            for i in range(len(train_Label)):
                label1 = [train_Label[i]] * roi_num
                label = np.hstack((label, label1))
            print(len(label))
            train_Label = label
    # print(trainData.shape)
    ##  数据处理方法选择
    def pre_data(method,trainData):
        if method == 1:  # 替换超出范围的数值，直接PCA需要
            trainData = trainData
        if method == 2:   # 数据按列特征做归一化
            min_max_scaler = preprocessing.MinMaxScaler()  # 数据按列特征做归一化
            trainData = min_max_scaler.fit_transform(trainData)
        if method ==3:   # 数据按列特征做标准化
            trainData = preprocessing.scale(trainData)    # 数据按列特征做标准化
        if method ==4:    # robust_scale,去除异常值
            trainData = preprocessing.robust_scale(trainData, axis=0, with_centering=True,
                                                   with_scaling=True, quantile_range=(25.0, 75.0), copy=True)
        if method ==5:   # 数据按列特征做l1,l2规范化
            trainData = preprocessing.normalize(trainData, norm='l1')
        if method ==6:   # 数据按列特征做l1,l2规范化
            trainData = preprocessing.normalize(trainData, norm='l2')
        return trainData
    # 数据规整方法，1去掉大于1000的值，2归一化，3标准化，4robust_scale，5l1l2规范化
    trainData = pre_data(method,trainData)
    trainData = np.array(trainData)
    return trainData,name_filt_all,train_Label

###############################################################################################
# 加载数据集，神经网络所有参数检验用数据预处理
def data_nn_filt(str_data,method,patient_datatime,odd_threshold,roi_num,k,roi_mode):
    # 获取workbook中所有的表格
    wb = xlrd.open_workbook(str_data)
    patient_name = wb.sheet_names()
    # 循环遍历所有sheet
    print('read data...')
    # 读入训练数据
    train = pd.read_excel(str_data, sheetname=patient_name[0])  # 读取数据
    trainData = train.values[1:, 1:]  # 读入评估数据
    for i in range(1, len(patient_datatime)):
        df = pd.read_excel(str_data, sheet_name=i, index=False, encoding='utf8')
        train_Data = df.values[1:, 1:]  # 读入评估数据
        trainData = np.concatenate((trainData, train_Data), axis=1)  # 默认情况下，axis=0可以不写
    trainData = trainData.astype(np.float64)  # 将这个数组转化为 float64 位的数组
    # 将矩阵中的NaN替换为0
    print('replace nan...')
    where_are_nan = np.isnan(trainData)  # 将矩阵中的NaN替换为0
    trainData[where_are_nan] = 0
    # 溢出float 64处理
    print('filt odd data...')
    data_filt = []
    for j in range(trainData.shape[0]):
        if (trainData[j, :].max() <= odd_threshold) & (trainData[j, :].min() >= -odd_threshold):
            data_filt.append(trainData[j, :])
    trainData = np.array(data_filt)  # 将这个数组转化为 float64 位的数组
    print(trainData.shape)  # 所有病人数据拼装完成后的数据维度

    # 把每一个病人10个roi即10列组装成一个数据
    kmeans = []
    patient_data = int(trainData.shape[1] // roi_num)
    for j in range(patient_data):
        trainData_kmeans = []
        if roi_mode == 1:   # 只使用一个roi数据用做分类训练
            trainData_kmeans = np.concatenate((trainData_kmeans, trainData[:, k + j * roi_num]), axis=0)
            kmeans.append(trainData_kmeans)
        else:
            for k in range(roi_num):
                trainData_kmeans = np.concatenate((trainData_kmeans, trainData[:, k + j * roi_num]), axis=0)
            kmeans.append(trainData_kmeans)
    trainData = np.array(kmeans)  # 将这个数组转化为 float64 位的数组
    print(trainData.shape)
    ##  数据处理方法选择
    def pre_data(method, trainData):
        if method == 1:  # 替换超出范围的数值，直接PCA需要
            trainData = trainData
        if method == 2:  # 数据按列特征做归一化
            min_max_scaler = preprocessing.MinMaxScaler()  # 数据按列特征做归一化
            trainData = min_max_scaler.fit_transform(trainData)
        if method == 3:  # 数据按列特征做标准化
            trainData = preprocessing.scale(trainData)  # 数据按列特征做标准化
        if method == 4:  # robust_scale,去除异常值
            trainData = preprocessing.robust_scale(trainData, axis=0, with_centering=True,
                                                   with_scaling=True, quantile_range=(25.0, 75.0), copy=True)
        if method == 5:  # 数据按列特征做l1,l2规范化
            trainData = preprocessing.normalize(trainData, norm='l1')
        if method == 6:  # 数据按列特征做l1,l2规范化
            trainData = preprocessing.normalize(trainData, norm='l2')
        return trainData
    #  数据预处理
    # 数据规整方法，1去掉大于1000的值，2归一化，3标准化，4robust_scale，5l1l2规范化
    trainData = pre_data(method, trainData)
    trainData = np.array(trainData)
    return trainData

###############################################################################################
# 计算PCA，贡献率90%,进一步减少PCA个数，加速训练
def pca_component(data,pca_percent):
    pca = PCA()
    pca.fit(data)
    # 累计贡献率 又名 累计方差贡献率 不要简单理解为 解释方差！！！
    EV_List = pca.explained_variance_
    EVR_List = []
    for j in range(len(EV_List)):
        EVR_List.append(EV_List[j]/EV_List[0])
    for j in range(len(EVR_List)):
        if(EVR_List[j]<(1-pca_percent)):  #  贡献率90%
            print ('PCA recommend number: %d' %j)
            return j

## PCA降维
def dpPCA_train(trainData1,Com):
    print('decompose data dimension...')
    pca=PCA(n_components=Com,copy=True,whiten=False)
    pca.fit(trainData1)
    pcaTrainData=pca.transform(trainData1)     # 在 X上进行降维
    print(pcaTrainData.shape ) # 返回模型的各个特征向量
    print('PCA finished')
    print(pca.explained_variance_ratio_)  #  各方差所占比率
    # print(pca.explained_variance_)        #   方差值
    return pcaTrainData

###############################################################################################
#
