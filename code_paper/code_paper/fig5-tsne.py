import os.path
import numpy as np
import pandas as pd
from sklearn import svm
from sklearn import metrics
from sklearn.decomposition import PCA
from timeit import default_timer as timer
from sklearn.model_selection  import train_test_split
from sklearn.linear_model import LogisticRegression
from sklearn.svm import SVC
from sklearn import manifold
from sklearn.neighbors import KNeighborsClassifier
from sklearn.tree import DecisionTreeClassifier
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import cross_val_score
from sklearn.ensemble import GradientBoostingClassifier
from sklearn.naive_bayes import MultinomialNB
from sklearn.metrics import classification_report
from sklearn.naive_bayes import MultinomialNB
from sklearn.naive_bayes import GaussianNB
from sklearn import preprocessing
from matplotlib import rcParams
import matplotlib.pyplot as plt
import matplotlib
# from data_process import data_nn_filt,pca_component,dpPCA_train
import warnings
import torch
import xlrd
from sklearn.decomposition import PCA
import csv
warnings.filterwarnings("ignore")
#################################################
# 文章中t-sne的可视化
##################################################
####   对所有数据进行机器学习二分类
# 使用方法：决策树，随机森林，SVM，KNN
# 超参数
# pca_percent = 0.99      # pca贡献率90%
n_output = 2          # 分类的类别
odd_threshold = 2000   # 认定为奇异值的界限，1000
# pca_mode = 1    # pca模式，1则pca降维，0则不降维
data_pre_method = ['Orginal','Scale0-1','Standardization','Robust scale','L1 normalization','L2 normalization']
str_data = '..\\data\\feature_lung_silk_health.xls'
str_name = '..\\data\\feature_all.csv'         # 纹理特征名称存储地址
patient_datatime = [5,7,6,4,1,5,1,1,7,5,5,7,7,5,2,1,5,2]    # 各个病人诊断CT的时间点个数
train_Label = np.tile([0,1],sum(patient_datatime))   # 制作标签

#  数据预处理
font1 = {'family' : 'Times New Roman',
    'weight' : 'normal',
    'size' : 22,
    }
font2 = {'family' : 'Times New Roman',
    'weight' : 'normal',
    'size' : 38,
    }

#  数据预处理
# 读取数据
warnings.filterwarnings("ignore")
start1 = timer()  # 计时开始
# 加载数据集
start_data = timer()  # 计时开始
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
trainData_excel = np.array(data_filt).T  # 将这个数组转化为 float64 位的数组
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

# 数据规整方法去掉大于1000的值，1去掉大于1000的值，2归一化，3标准化，4robust_scale，5l1l2规范化
matplotlib.rc('font',family ='Times New Roman')
plt.figure()
for k in range(1,7):
    method = k
    print(k)

    # 数据规整方法，1去掉大于1000的值，2归一化，3标准化，4robust_scale，5l1l2规范化
    print(trainData_excel.shape)
    trainData = pre_data(method,trainData_excel)
    print(trainData.shape)
    # # 缩小维度
    # if pca_mode == 1:   #pca，1则进行pca数据降维
    #     pca_n = pca_component(trainData,pca_percent)
    #     trainData=dpPCA_train(trainData,pca_n)
    # trainData = np.array(trainData)
    # print(trainData.shape)
    end_data = timer()  # 计算总的运行时间并打印出来
    # 数据分级
    print('数据加载完毕，time: %.4f' % (end_data - start_data), 's')

    n_samples, n_features = trainData.shape
    tsne = manifold.TSNE(n_components=2,init='pca',random_state=0)
    X_tsne = tsne.fit_transform(trainData)

    print("Org data dimension is {}.Embedded data dimension is {}".format(trainData.shape[-1], X_tsne.shape[-1]))
    x_min, x_max = X_tsne.min(0), X_tsne.max(0)
    X_norm = (X_tsne - x_min) / (x_max - x_min)  # 归一化
    plt.subplot(2,3,k)
    for i in range(X_norm.shape[0]):
        plt.text(X_norm[i, 0], X_norm[i, 1], str(train_Label[i]), color=plt.cm.Set1(train_Label[i]),
                 fontdict={'weight': 'bold', 'size': 9})
        plt.title(data_pre_method[k-1],font1)
        ax=plt.gca()
        if i ==0:
            plt.xlim(-0.05, 0.45)
            plt.ylim(-0.05, 0.75)
        elif i ==3:
            plt.xlim(0.1, 0.45)
            plt.ylim(0.15, 0.95)
        else:
            plt.xlim(-0.05, 1.05)
            plt.ylim(-0.05, 1.05)
# plt.xticks([])
# plt.yticks([])

# 显示图像
plt.show()

print('程序运行结束！')
