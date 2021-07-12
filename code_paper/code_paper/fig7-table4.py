import os
import numpy as np
import pandas as pd
from sklearn.feature_selection import SelectKBest
from sklearn.feature_selection import chi2
import torch.utils.data as Data
import matplotlib.pyplot as plt
from sklearn.neural_network import MLPClassifier
from timeit import default_timer as timer
from sklearn.metrics import classification_report
import warnings
from sklearn.model_selection  import train_test_split
from sklearn import preprocessing
from sklearn.metrics import roc_auc_score
import timeit
import xlrd
import csv
from data_process import data_feat_filt
import statsmodels.api as sm #最小二乘
from statsmodels.formula.api import ols #加载ols模型

warnings.filterwarnings("ignore")
start1 = timer()   # 计时开始
######  chi2检验筛选特征,42_9900
# 超参数
roi_mode = 0         # 根据数据的合并形式，mode为1则合并肉为一列，42X9900，为0不为1则是420X990
auc_mode = 0        # 判断auc是否输出，1为输出，其他为不输出
EOPCH = 200             # 几个周期
LR = 0.01              # 学习率
feat_num = 20         # chi2筛选出特征的数量
eval_percent = 0.2     # eval集占有标签数据比例
train_num = 84         # train集总的数目，现有42组数据，取前30组为训练集
roi_num = 2          # 分类的类别
odd_threshold = 1000   # 认定为奇异值的界限，1000
method = 2     # 数据规整方法，1去掉大于1000的值，2归一化，3标准化，4robust_scale，5l1,6l2规范化
str_data = '..\\data\\feature_lung_silk_health.xls'   # 纹理特征数据存储地址
str_name = '..\\data\\feature_all.csv'         # 纹理特征名称存储地址
roi_name = ['silk','health']    # roi的名字
patient_datatime = [5,7,6,4,1,5,1,1,7,5,5,7,7,5,2,1,5,2]    # 各个病人诊断CT的时间点个数
train_Label_original = np.tile([0,1],sum(patient_datatime))   # 制作标签

# 加载数据集
start_data = timer()   # 计时开始
# 数据和特征经过预处理后输出
trainData,name_filt_all,train_Label = data_feat_filt(str_data,str_name,method,patient_datatime,roi_name,
                                         odd_threshold,roi_num,roi_mode,train_Label_original)
print(trainData.shape)
train_Label = np.tile([0,1],sum(patient_datatime))   # 制作标签

##  chi2检验，筛选特征值
model = SelectKBest(chi2, k=feat_num)
trainData_chi2 = model.fit_transform(trainData, train_Label)
trainData_chi2_original = model.inverse_transform(trainData_chi2)
feature_name_chi2 = []
# 把数据和特征匹配输出
str_ols = 'value~ '
for k in range(trainData_chi2_original.shape[1]):   # 把数据和特征匹配输出
    if trainData_chi2_original[0,k] != 0 :
        feature_name_chi2.append(name_filt_all[k])
        str_ols = str_ols + str(name_filt_all[k])
        if len(feature_name_chi2) != feat_num :   # 除了最有一个其他的加入自负+
            str_ols = str_ols + ' + '
print(np.array(feature_name_chi2).shape)    # 输出筛选出特征名称
# df = pd.DataFrame(feature_name_chi2)
# df.to_csv("feature_name_chi2.txt")     # 保存卡方渐渐的20个特征名
print(trainData_chi2.shape)
# print(model.scores_)     # 输出筛选出特征的得分
# print(model.pvalues_)    # 输出筛选出特征的得分，越低越好
print('data load finished')

##  statsmodels简单建立多元线性回归模型
data=pd.DataFrame(trainData_chi2) #将自变量转换成dataframe格式，便于查看
print(data.shape) #查看数据量
print(data.head(5)) #查看前10行数据
data.columns=feature_name_chi2  #命名自变量
data.loc[:,"value"]=train_Label #合并自变量，因变量数据

## 训练nn模型计算AUC等指标
if auc_mode == 1:   # 判断auc是否输出，1为输出，其他为不输出
    data_auc = []
    for i in range(feat_num):
        trainData_auc_temp = trainData_chi2[:,i]
        trainData_auc = []  # 每次计算前置零auc计算训练数据
        for j in range(len(train_Label_original)):
            trainData_auc.append(trainData_auc_temp[(j*roi_num):((j+1)*roi_num)])
        # 数据分级
        trainData_auc = np.array(trainData_auc)   # 把list转换为np.array
        test_label = train_Label_original[train_num:]
        train_Label = train_Label_original[:train_num]
        testData = trainData_auc[train_num:,:]  # 测试集
        trainData = trainData_auc[:train_num,:]  # 截取部分为训练集和评估集
        train_data, eval_data, train_labels__, eval_labels__ = train_test_split(trainData, train_Label,
                                                                                test_size=eval_percent)
        ## 训练
        mlp = MLPClassifier(solver='adam', activation='relu', alpha=1e-4, hidden_layer_sizes=(100,20),
                            random_state=1, max_iter=EOPCH, verbose=False, learning_rate_init=LR)
        mlp.fit(train_data, train_labels__)  # 训练模型
        # 输出结果
        Train_score = mlp.score(train_data, train_labels__)
        Eval_score = mlp.score(eval_data, eval_labels__)
        Test_score = mlp.score(testData, test_label)
        predict_test = mlp.predict(testData)
        auc_score = roc_auc_score(predict_test, test_label)  # 打印出AUC计算结果
        auc_temp = [Train_score,Eval_score,Train_score,auc_score]
        data_auc.append(auc_temp)
    np.set_printoptions(precision=4, suppress=True)
    print('Train   Eval   Test   Auc')
    print(np.array(data_auc))   # 输出对应roi的auc值

#训练模型
lm=ols(str_ols,data=data).fit()
print(lm.summary())  # 输出回归参数

end1 = timer()    # 计算总的运行时间并打印出来
time = end1 - start1
print('time(S):%.4f' % time)
print('run finished！')