import os.path
import numpy as np
import os
import pandas as pd
from sklearn import svm
from sklearn import metrics
from sklearn.decomposition import PCA
from sklearn.datasets import load_boston
from timeit import default_timer as timer
from sklearn.model_selection  import train_test_split,learning_curve,KFold,GridSearchCV
from sklearn.linear_model import LogisticRegression
from sklearn.svm import SVC
from sklearn.neighbors import KNeighborsClassifier
from sklearn.tree import DecisionTreeClassifier
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import cross_val_score,GridSearchCV
from sklearn.metrics import mean_squared_error as MSE
from sklearn.ensemble import GradientBoostingClassifier
from sklearn.naive_bayes import MultinomialNB
from sklearn.metrics import classification_report
from sklearn.metrics import precision_score, recall_score, f1_score
from sklearn.naive_bayes import MultinomialNB
from sklearn.naive_bayes import GaussianNB
from sklearn import preprocessing
import warnings
# import torch
import xlrd
from sklearn.decomposition import PCA
import matplotlib.pyplot as plt
import csv
from sklearn import manifold
warnings.filterwarnings("ignore")
#####################################################################################
#  数据降维可视化，对比七种图像分配方式的可分性
######################################################################################
####   对所有数据进行机器学习二分类
# 使用方法：决策树，随机森林，SVM，KNN
# 超参数
# odd_threshold = 10000000   # 认定为奇异值的界限，1000
# file_str = '..\\result\\2class\\'   # 2分类
file_str = '..\\result\\'   # 3分类
data_pre_method = ['Orginal','Scale0-1','Standardization','Robust scale','L1 normalization','L2 normalization']
# image_mode = ['O','W','S','G','O+W','O+W+S','O+W+S+G']
image_mode = ['M1','M2','M3','M4','M5','M6','M7','The proposed']
# image_mode = 'The proposed'  # M1-M7,The proposed
method = 3 # 1原始特征，3标准化
num_1 = 60
num_2 = 60
num_3 = 60
# 制作标签397/576
#####################################################################
##  数据处理方法选择
def pre_data(method,trainData):
    if method == 1:  # 替换超出范围的数值，直接PCA需要
        # 溢出float 64处理
        print('filt odd data...')
        # data_filt = []
        # for j in range(trainData.shape[0]):
        #     if (trainData[j, :].max() <= odd_threshold) & (trainData[j, :].min() >= -odd_threshold):
        #         data_filt.append(trainData[j, :])
        # trainData = np.array(data_filt)  # 将这个数组转化为 float64 位的数
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
###################################################################################
def data_read(num_1, num_2, num_3, str_data):
    # 制作标签397/576
    train_Label1 = [0 for i in range(num_1)]  # 制作标签397/576
    train_Label2 = [1 for i in range(num_2)]  # 制作标签349/484
    train_Label3 = [2 for i in range(num_3)]  # 制作标签349/484
    train_Label = np.hstack((train_Label1, train_Label2, train_Label3))
    # print(train_Label)
    print('Label length: ', np.array(train_Label).shape)
    #  数据预处理
    start1 = timer()  # 计时开始
    # 加载数据集
    start_data = timer()  # 计时开始
    # 获取workbook中所有的表格
    wb = xlrd.open_workbook(str_data)
    patient_name = wb.sheet_names()
    print('sheet name:', patient_name)  # 打印出表格的名称
    # 循环遍历所有sheet
    print('load data...')
    # 读入训练数据
    train = pd.read_excel(str_data, sheetname=patient_name[0])  # 读取数据
    trainData = train.values[1:, 1:]  # 读入评估数据
    print(trainData.shape)
    for i in range(1, len(patient_name)):
        df = pd.read_excel(str_data, sheet_name=i, index=False, encoding='utf8')
        train_Data = df.values[1:, 1:]  # 读入评估数据
        trainData = np.concatenate((trainData, train_Data), axis=1)  # 默认情况下，axis=0可以不写
    #   选择一种图像模式
    # trainData =  trainData[270:540,:]  # 270,540,810,1080
    print(trainData.shape)

    trainData = trainData.T
    # 转置矩阵方便分析
    # trainData = trainData.T
    trainData = trainData.astype(np.float64)  # 将这个数组转化为 float64 位的数组
    # 将矩阵中的NaN替换为0
    print('replace nan...')
    where_are_nan = np.isnan(trainData)  # 将矩阵中的NaN替换为0
    trainData[where_are_nan] = 0
    #####################################################################
    trainData = np.array(trainData)  # 将这个数组转化为 float64 位的数组
    print(trainData.shape)
    end_data = timer()  # 计算总的运行时间并打印出来
    print('数据加载完毕，time: %.4f' % (end_data - start_data), 's')
    return trainData, train_Label
#####################################################################################################
for ii in range(len(image_mode)):
    str_data = file_str +image_mode[ii]+'.xlsx'   # M1-M7,The proposed
    trainData,train_Label = data_read(num_1, num_2, num_3, str_data)
    # 读取数据
    plt.figure(figsize=(6.5,6))
    print(trainData.shape)
    trainData = pre_data(method,trainData)
    print(trainData.shape)
    trainData = np.array(trainData)
    #####################################################################################################
    n_samples, n_features = trainData.shape
    tsne = manifold.TSNE(n_components=2, init='random', random_state=0)
    X_tsne = tsne.fit_transform(trainData)

    print("Org data dimension is {}.Embedded data dimension is {}".format(trainData.shape[-1], X_tsne.shape[-1]))
    x_min, x_max = X_tsne.min(0), X_tsne.max(0)
    X_norm = (X_tsne - x_min) / (x_max - x_min)  # 归一化
    for i in range(X_norm.shape[0]):
        plt.text(X_norm[i, 0], X_norm[i, 1], str(train_Label[i]), color=plt.cm.Set1(train_Label[i]),
                 fontdict={'weight': 'bold', 'size': 18})
        # plt.title(image_mode)
        ax = plt.gca()
        # 设置坐标刻度值的大小以及刻度值的字体
        plt.tick_params(labelsize=20)
        labels = ax.get_xticklabels() + ax.get_yticklabels()
        [label.set_fontname('Times New Roman') for label in labels]

        plt.xlim(-0.05, 1.05)
        plt.ylim(-0.05, 1.05)
    # plt.xticks([])
    # plt.yticks([])
    fig_name = file_str+'tsne\\'+image_mode[ii]+'.png'     # 要保存的图片名称
    # 判断文件夹是否存在，不存在则创建
    if os.path.exists(file_str+'tsne\\') == False:
        os.makedirs(file_str+'tsne\\')

    print(fig_name)
    plt.savefig(fig_name)
    ###############################################################################################################
# 显示图像
plt.show()
end_dt = timer()    # 计算总的运行时间并打印出来
print('程序运行结束！')
