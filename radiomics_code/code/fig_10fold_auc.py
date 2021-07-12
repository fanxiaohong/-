import os.path
import numpy as np
import pandas as pd
from sklearn import svm
from sklearn import metrics
from sklearn.decomposition import PCA
from sklearn.neural_network import MLPClassifier
from sklearn.externals import joblib
from sklearn.metrics import auc
import xgboost as xgb
from xgboost import XGBClassifier as XGBC
from sklearn.datasets import load_boston
from sklearn.metrics import classification_report,roc_curve,precision_recall_curve
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
method = 1    # 数据规整方法，1去掉大于1000的值，2归一化，3标准化，4robust_scale，5l1,6l2规范化
file_str = '..\\result\\2class\\'   # 2分类
# file_str = '..\\result\\'   # 3分类
image_mode = 'The proposed'  # M1-M7,The proposed
str_data = file_str +image_mode+'.xlsx'   # M1-M7,The proposed
str_name = '..\\result\\feature_all.csv'         # 纹理特征名称存储地址
# dirname_train = 'E:\\covid19_single_image\\result\\paper_experiment3\\'   # 保存输出的5fold结果位置
# filename_train = dirname_train + 'bin15_imagemode_pipeline_746_labelme.txt'  # 机器学习方法名称
# train_Label_before = [0, 1, 2]
num_1 = 60
num_2 = 60
train_Label1 = [0 for i in range(num_1)]   # 制作标签397/576
train_Label2 = [1 for i in range(num_2)]   # 制作标签349/484
train_Label = np.hstack((train_Label1,train_Label2))
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
trainData = np.array(trainData)  # 将这个数组转化为 float64 位的数组
end_data = timer()  # 计算总的运行时间并打印出来
print('数据加载完毕，time: %.4f' % (end_data - start_data), 's')
#####################################################################################################
def result_print(train_Label, y_pred):
    xg_eval_auc = metrics.roc_auc_score(train_Label, y_pred, average='weighted')  # 验证集上的auc值
    xg_eval_f1 = metrics.f1_score(train_Label, y_pred, average='weighted')  # 验证集的f1得分
    xg_eval_acc = metrics.accuracy_score(train_Label, y_pred)  # 验证集的准确度
    xg_eval_precision = metrics.precision_score(train_Label, y_pred, average='weighted')  # 验证集的精度
    xg_eval_recall = metrics.recall_score(train_Label, y_pred, average='weighted')  # 验证集的召回率,灵敏度sensitivity
    print('eval_auc=%.4f' % np.array(xg_eval_auc))
    print('eval_f1=%.4f' % np.array(xg_eval_f1))
    print('eval_acc=%.4f' % np.array(xg_eval_acc))
    print('eval_precision=%.4f' % np.array(xg_eval_precision))
    print('eval_recall=%.4f' % np.array(xg_eval_recall))
    print(classification_report(train_Label, y_pred, digits=4))
    return xg_eval_auc,xg_eval_acc,xg_eval_f1,xg_eval_recall,xg_eval_precision
##############################################################################
# 数据规整方法，1去掉大于1000的值，2归一化，3标准化，4robust_scale，5l1l2规范化
print(trainData.shape)
trainData = trainData.T
print(trainData.shape)
#####################################################################################
# if k == 0:
#     xg_original = RandomForestClassifier()  # 随机森林
# # xg = GaussianNB()   # 朴素贝叶斯
# elif k == 1:
#     xg_original = LogisticRegression()  # LR逻辑回归
# elif k == 2:
#     xg_original = KNeighborsClassifier()  # KNN
# elif k == 3:
#     xg_original = svm.SVC()  # svm
# elif k == 4:
#     xg_original = GradientBoostingClassifier()  # 梯度提升决策树
# elif k == 5:
#     xg_original = XGBC()  # xgboost
# elif k==6:
#     xg_original = MLPClassifier(solver='adam', activation='relu', alpha=1e-4, hidden_layer_sizes=(50, 50, 50), random_state=0,
#                 max_iter=500, verbose=True, learning_rate_init=0.0001)
########################################################
'''
  scoring参数
  accuracy/average_precision/f1/f1_micro/f1_macro/f1_weighted/f1_samples/neg_log_loss/
  precision/recall/roc_auc
  # 表现较好的：roc_auc/neg_log_loss/average_precision
'''
xg = KNeighborsClassifier()  # 随机森林
# xg = GradientBoostingClassifier()  # 梯度提升决策树
# xg = XGBC()  # xgboost
xg = MLPClassifier(solver='adam', activation='relu', alpha=1e-4, hidden_layer_sizes=(50, 50, 50), random_state=0,
                        max_iter=500, verbose=False, learning_rate_init=0.0001)
i = 0
cv = KFold(n_splits=10, shuffle=True, random_state=i)
fig, ax = plt.subplots(figsize=(7,6))
tprs = []
aucs = []
mean_fpr = np.linspace(0, 1, 100)
for i, (train, test) in enumerate(cv.split(trainData, train_Label)):  # 10折模型训练并画图
    scaler = preprocessing.StandardScaler().fit(trainData[train])   # 根据训练数据标准化
    train_transform = scaler.transform(trainData[train])
    test_transform = scaler.transform(trainData[test])
    xg.fit(train_transform, train_Label[train])   # 训练模型
    test_transform_xg = xg.predict(test_transform)  # 预测
    xg_eval_auc, xg_eval_acc, xg_eval_f1, xg_eval_recall, xg_eval_precision = result_print(train_Label[test],test_transform_xg)
    y_pred_xg = xg.predict_proba(test_transform)[:, 1]  ###这玩意就是预测概率的
    # fpr, tpr = draw_roc(train_Label[test], y_pred_xg, line_name)
    fpr, tpr, thresholds = roc_curve(train_Label[test], y_pred_xg)  # 绘制roc曲线
    # precision, recall, thresholds = precision_recall_curve(y_true, y_pred)  # 绘制precision
    interp_tpr = np.interp(mean_fpr, fpr, tpr)
    test_auc = auc(fpr, tpr)
    line_name = 'ROC fold %0.0f (AUC = %0.4f)' % (i, test_auc)
    plt.plot(fpr, tpr, label=line_name)
    print('auc=%0.4f'%test_auc)
    interp_tpr[0] = 0.0
    tprs.append(interp_tpr)
    aucs.append(xg_eval_auc)

ax.plot([0, 1], [0, 1], linestyle='--', lw=2, color='r',label='Chance', alpha=.8)
plt.xlabel('False Postivie Rate')
plt.ylabel('True Positive Rate')

mean_tpr = np.mean(tprs, axis=0)
mean_tpr[-1] = 1.0
mean_auc = auc(mean_fpr, mean_tpr)
std_auc = np.std(aucs)
ax.plot(mean_fpr, mean_tpr, color='b',
        label=r'Mean ROC (AUC = %0.4f $\pm$ %0.4f)' % (mean_auc, std_auc),lw=2, alpha=.8)

std_tpr = np.std(tprs, axis=0)
tprs_upper = np.minimum(mean_tpr + std_tpr, 1)
tprs_lower = np.maximum(mean_tpr - std_tpr, 0)
ax.fill_between(mean_fpr, tprs_lower, tprs_upper, color='grey', alpha=0.5,
                label=r'$\pm$ 1 std. dev.')

ax.set(xlim=[-0.05, 1.05], ylim=[-0.05, 1.05],
       title="Receiver Operating Characteristic")
ax.legend(loc="lower right",fontsize='x-small')
###########################################################################################
plt.show()
end_dt = timer()    # 计算总的运行时间并打印出来
print('程序运行结束！')
