import os.path
import numpy as np
import pandas as pd
from sklearn import svm
from sklearn import metrics
from sklearn.decomposition import PCA
from sklearn.neural_network import MLPClassifier
from sklearn.discriminant_analysis import LinearDiscriminantAnalysis
from sklearn.externals import joblib
import xgboost as xgb
from xgboost import XGBClassifier as XGBC
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
from sklearn.pipeline import make_pipeline
from sklearn.naive_bayes import MultinomialNB
from sklearn.metrics import classification_report
from sklearn.metrics import precision_score, recall_score, f1_score
from sklearn.naive_bayes import MultinomialNB
from sklearn.naive_bayes import GaussianNB
from sklearn import preprocessing
import warnings
import torch
import xlrd
from sklearn.decomposition import PCA
import matplotlib.pyplot as plt
import csv
warnings.filterwarnings("ignore")
#################################################################3
# 文章中实验2的5折交叉验证对比，实验二，对比多图模式和多窗宽的优势code
##################################################################
####   对所有数据进行机器学习二分类
# 使用方法：决策树，随机森林，SVM，KNN
# 超参数
# n_output = 2          # 分类的类别
# bin_num = 15          # 分类的类别
bin_adapt_mode = 0  # 是否是多窗宽1是，0不是
method = 3    # 数据规整方法，1去掉大于1000的值，2归一化，3标准化，4robust_scale，5l1,6l2规范化
str_data = '..\\result\\proposed_mrpd+mrt2.xlsx'   # mrpd,mrt1,mrt2,proposed_mrpd+mrt1,proposed_mrpd+mrt2
str_name = '..\\result\\feature_all.csv'         # 纹理特征名称存储地址
dirname_train = '..\\result\\标准化3分类\\'   # 保存输出的5fold结果位置
filename_train = dirname_train + 'proposed_mrpd+mrt2.txt'  # 机器学习方法名称
start_image = [0]      # 图像数据开始
end_image = [1080]  # 图像数据结束
# train_Label_before = [0, 1, 2]
num_1 = 20
num_2 = 20
num_3 = 20
train_Label1 = [0 for i in range(num_1)]   # 制作标签397/576
train_Label2 = [1 for i in range(num_2)]   # 制作标签349/484
train_Label3 = [2 for i in range(num_3)]   # 制作标签349/484
train_Label = np.hstack((train_Label1,train_Label2,train_Label3))
# print(train_Label)
print('Label length: ',np.array(train_Label).shape)
########################################################################################
warnings.filterwarnings("ignore")
start1 = timer()  # 计时开始
# 加载数据集
start_data = timer()  # 计时开始
# 获取workbook中所有的表格
wb = xlrd.open_workbook(str_data)
patient_name = wb.sheet_names()
print('sheet name:',patient_name)   # 打印出表格的名称
feature_name = pd.read_csv(str_name)         #读取csv文件中的纹理特征名称列表
feature_name = feature_name.values.tolist()
str_list = []
str_list.extend([x[0] for x in feature_name])   # 去掉列表中元素的中括号
feature_name = str_list
print('feat_name shape: ',np.array(feature_name).shape)
# 循环遍历所有sheet
print('load data...')
# 读入训练数据
train = pd.read_excel(str_data, sheetname= patient_name[0])   # 读取数据
trainData = train.values[1:,1:]  # 读入评估数据
print(trainData.shape)
for i in range(1,len(patient_name)):
    df = pd.read_excel(str_data, sheet_name=i, index=False, encoding='utf8')
    train_Data = df.values[1:, 1:]  # 读入评估数据
    trainData = np.concatenate((trainData,train_Data), axis=1)  # 默认情况下，axis=0可以不写

# 转置矩阵方便分析
trainData = trainData.astype(np.float64) # 将这个数组转化为 float64 位的数组
print(trainData.shape)
# 将矩阵中的NaN替换为0
print('replace nan...')
where_are_nan = np.isnan(trainData)    # 将矩阵中的NaN替换为0
trainData[where_are_nan] = 0
#####################################################################
name_filt = []
for j in range(trainData.shape[0]):
    name_filt.append(feature_name[j])
trainData_excel = np.array(trainData)  # 将这个数组转化为 float64 位的数组
# lda = LinearDiscriminantAnalysis(n_components=20)
# trainData_excel = trainData_excel.T
# trainData_excel = lda.fit(trainData_excel, train_Label).transform(trainData_excel)
# trainData_excel = trainData_excel.T
##  数据处理方法选择
def pre_data(method,xg):
    if method == 1:  # 替换超出范围的数值，直接PCA需要
        xg1 =   xg
    if method == 2:   # 数据按列特征做归一化
        xg1 = make_pipeline(preprocessing.MinMaxScaler(), xg)
    if method ==3:   # 数据按列特征做标准化
        xg1 = make_pipeline(preprocessing.StandardScaler(), xg)
    if method ==4:    # robust_scale,去除异常值
        xg1 = make_pipeline(preprocessing.RobustScaler(copy=True, quantile_range=(25.0, 75.0), with_centering=True,
                                                 with_scaling=True), xg)
    if method ==5:   # 数据按列特征做l1,l2规范化
        xg1 = make_pipeline(preprocessing.Normalizer(copy=True, norm='l1'), xg)
    if method ==6:   # 数据按列特征做l1,l2规范化
        xg1 = make_pipeline(preprocessing.Normalizer(copy=True, norm='l2'), xg)
    return xg1

end_data = timer()  # 计算总的运行时间并打印出来
print('数据加载完毕，time: %.4f' % (end_data - start_data), 's')
#############################################################################
# 循环method和pca，依次输出结果
list1 = []  # 六种预处理方法的结合
for k in range(0,7):
    # list_all = []  # 六种预处理方法的结合
    print(k)
    for j in range(len(start_image)):
        print(j)
        # 数据规整方法，1去掉大于1000的值，2归一化，3标准化，4robust_scale，5l1l2规范化
        trainData = trainData_excel[start_image[j]:end_image[j],:]  # 270,540,810,1080
        print(trainData.shape)
        #   选择一种图像模式
        # 转置矩阵方便分析
        if bin_adapt_mode == 1:  # 判断是否是多窗宽，如果是则进行操作
            # 把15个窗宽数据堆叠程一列
            kmeans = []
            for l in range(len(train_Label)):
                trainData_kmeans = []
                for m in range(bin_num):
                    trainData_kmeans = np.concatenate((trainData_kmeans, trainData[:, m + l * bin_num]), axis=0)
                kmeans.append(trainData_kmeans)
            trainData = np.array(kmeans)  # 将这个数组转化为 float64 位的数组
            trainData = trainData.T
        trainData = trainData.T
        print(start_image[j])
        print(trainData.shape)

#####################################################################################
        if k == 0:
            xg_original = RandomForestClassifier()  # 随机森林
        # xg = GaussianNB()   # 朴素贝叶斯
        elif k == 1:
            xg_original = LogisticRegression()  # LR逻辑回归
        elif k == 2:
            xg_original = KNeighborsClassifier()  # KNN
        elif k == 3:
            xg_original = svm.SVC()  # svm
        elif k == 4:
            xg_original = GradientBoostingClassifier()  # 梯度提升决策树
        elif k == 5:
            xg_original = XGBC()  # xgboost
        elif k == 6:
            xg_original = MLPClassifier(solver='adam', activation='relu', alpha=1e-4, hidden_layer_sizes=(50, 50, 50),
                                        random_state=0,max_iter=500, verbose=False, learning_rate_init=0.0001)
        xg = pre_data(method, xg_original)
        ########################################################

        '''
          scoring参数
          accuracy/average_precision/f1/f1_micro/f1_macro/f1_weighted/f1_samples/neg_log_loss/
          precision/recall/roc_auc
          # 表现较好的：roc_auc/neg_log_loss/average_precision
        '''
        i = 0
        cv = KFold(n_splits=10, shuffle=True, random_state=i)
        # fold_auc_all = cross_val_score(xg, trainData, train_Label, cv=cv, scoring='roc_auc')  # 计算训练准确率
        fold_acc_all = cross_val_score(xg, trainData, train_Label, cv=cv, scoring='accuracy')  # 计算训练准确率
        fold_f1_all = cross_val_score(xg, trainData, train_Label, cv=cv, scoring='f1_weighted')  # 计算训练准确率
        fold_recall_all = cross_val_score(xg, trainData, train_Label, cv=cv, scoring='recall_weighted')  # 计算训练准确率
        fold_precision_all = cross_val_score(xg, trainData, train_Label, cv=cv, scoring='precision_weighted')  # 计算训练准确率
        # score_model = np.array(fold_auc_all).mean() + np.array(fold_acc_all).mean() + np.array(fold_f1_all).mean() + \
        #               np.array(fold_recall_all).mean() + np.array(fold_precision_all).mean()
        score_model =  np.array(fold_acc_all).mean() + np.array(fold_f1_all).mean() + \
                      np.array(fold_recall_all).mean() + np.array(fold_precision_all).mean()
        #####################################################################################
        print('score=%.4f'%score_model)
        # print('fold_auc_all=',fold_auc_all)
        # print('fold_auc_all_mean=%.4f'%np.array(fold_auc_all).mean(),'| std=%.4f'%np.array(fold_auc_all).std(),
        #       '| median=%.4f'%np.median(np.array(fold_auc_all)),
        #       '| max=%.4f'%np.array(fold_auc_all).max(),'| min=%.4f'%np.array(fold_auc_all).min())
        print('fold_acc_all=',fold_acc_all)
        print('fold_acc_all_mean=%.4f'%np.array(fold_acc_all).mean(),'| std=%.4f'%np.array(fold_acc_all).std(),
              '| median=%.4f'%np.median(np.array(fold_acc_all)),
              '| max=%.4f'%np.array(fold_acc_all).max(),'| min=%.4f'%np.array(fold_acc_all).min())
        print('fold_f1_all=',fold_f1_all)
        print('fold_f1_all_mean=%.4f'%np.array(fold_f1_all).mean(),'| std=%.4f'%np.array(fold_f1_all).std(),
              '| median=%.4f'%np.median(np.array(fold_f1_all)),
              '| max=%.4f'%np.array(fold_f1_all).max(),'| min=%.4f'%np.array(fold_f1_all).min())
        print('fold_recall_all=',fold_recall_all)
        print('fold_recall_all_mean=%.4f'%np.array(fold_recall_all).mean(),'| std=%.4f'%np.array(fold_recall_all).std(),
              '| median=%.4f'%np.median(np.array(fold_recall_all)),
              '| max=%.4f'%np.array(fold_recall_all).max(),'| min=%.4f'%np.array(fold_recall_all).min())
        print('fold_precision_all=',fold_precision_all)
        print('fold_precision_all_mean=%.4f'%np.array(fold_precision_all).mean(),'| std=%.4f'%np.array(fold_precision_all).std(),
              '| median=%.4f'%np.median(np.array(fold_precision_all)),
              '| max=%.4f'%np.array(fold_precision_all).max(),'| min=%.4f'%np.array(fold_precision_all).min())
        ##########################################################################################3
        # save train
        # list1 = []
        # list_auc = str(round(np.array(fold_auc_all).mean(),4))+'±'+str(round(np.array(fold_auc_all).std(),4))
        list_acc = str(round(np.array(fold_acc_all).mean(),4))
        list_f1 = str(round(np.array(fold_f1_all).mean(),4))
        list_recall = str(round(np.array(fold_recall_all).mean(),4))
        list_precision = str(round(np.array(fold_precision_all).mean(),4))
        # list1.append(list_auc)
        list1.append(list_acc)
        list1.append(list_f1)
        list1.append(list_recall)
        list1.append(list_precision)
        # list_all.append(list_auc)
        # list_all = list(zip(*list1))  # 转置列表
        print(list1)
    # list_all1.append(list1)
    # print(list_all1)

##################################################################
# 保存文件
file = open(filename_train, 'w')
if not os.path.exists(dirname_train):
    os.makedirs(dirname_train)
for fp in list1:
    file.write(str(fp))
    file.write('\n')
file.close()
###########################################################################################
end_dt = timer()    # 计算总的运行时间并打印出来
print('程序运行结束！')
