import os.path
import csv
import xlrd
import numpy as np
import pandas as pd
from sklearn import svm
from sklearn.decomposition import PCA
from timeit import default_timer as timer
from sklearn.model_selection  import train_test_split
from sklearn.linear_model import LogisticRegression
from sklearn.svm import SVC
from sklearn.neighbors import KNeighborsClassifier
from sklearn.tree import DecisionTreeClassifier
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import cross_val_score
from sklearn.ensemble import GradientBoostingClassifier
from sklearn.naive_bayes import MultinomialNB
from sklearn.metrics import classification_report
from sklearn.discriminant_analysis import LinearDiscriminantAnalysis
from sklearn.naive_bayes import MultinomialNB
from sklearn.naive_bayes import GaussianNB
from sklearn import preprocessing
from sklearn.preprocessing import Imputer
# from sklearn.externals import joblib
import warnings
warnings.filterwarnings("ignore")
##  对纹理特征降维后保存降维后的所有数据
# 使用方法：决策树，随机森林，SVM，KNN
# 超参数
pca_percent = 0.99     # pca贡献率90%
roi_num = 10          # 分类的类别
odd_threshold = 1000   # 认定为奇异值的界限，1000
method = 6     # 数据规整方法，1去掉大于1000的值，2归一化，3标准化，4robust_scale，5l1,6l2规范化
str_data = 'E:\\roi_feat_dose\\result\\feature_lung_all.xls'
save_str = './/data//output_l2_pca.xlsx'    # 文件保存名称目录
patient_datatime = [5,7,6,4,1,5,1,1,7,5,5,7]    # 各个病人诊断CT的时间点个数
test_mode = 0       # 运行模式，决定是否保存文件，1保存，0不保存

# 获取workbook中所有的表格
wb = xlrd.open_workbook(str_data)
patient_name = wb.sheet_names()
# 循环遍历所有sheet
print('读入数据...')
train = pd.read_excel(str_data, sheetname= patient_name[0])   # 读取数据
trainData = train.values[1:,1:]  # 读入评估数据
for i in range(1,len(patient_datatime)):
    df = pd.read_excel(str_data, sheet_name=i, index=False, encoding='utf8')
    train_Data = df.values[1:, 1:]  # 读入评估数据
    trainData = np.concatenate((trainData,train_Data), axis=1)  # 默认情况下，axis=0可以不写

# 转置矩阵方便分析
# trainData = trainData.T
trainData = trainData.astype(np.float64) # 将这个数组转化为 float64 位的数组
print(trainData.shape)
# 将矩阵中的NaN替换为0
print('替换nan...')
where_are_nan = np.isnan(trainData)    # 将矩阵中的NaN替换为0
trainData[where_are_nan] = 0

# 溢出float 64处理
print('过滤奇异特征值...')
data_filt = []
for j in range(trainData.shape[0]):
    if (trainData[j,:].max() <= odd_threshold) & (trainData[j,:].min() >= -odd_threshold):
        data_filt.append(trainData[j,:])

trainData = np.array(data_filt).T  # 将这个数组转化为 float64 位的数组
print(trainData.shape)    # 所有病人数据拼装完成后的数据维度

# 计算PCA，贡献率90%,进一步减少PCA个数，加速训练
def pca_component(data):
    pca = PCA()
    pca.fit(data)
    # 累计贡献率 又名 累计方差贡献率 不要简单理解为 解释方差！！！
    EV_List = pca.explained_variance_
    EVR_List = []
    for j in range(len(EV_List)):
        EVR_List.append(EV_List[j]/EV_List[0])
    for j in range(len(EVR_List)):
        if(EVR_List[j]<(1-pca_percent)):  #  贡献率90%
            print ('PCA推荐个数: %d' %j)
            return j

## PCA降维
def dpPCA_train(trainData1,Com):
    print('减少数据维度...')
    pca=PCA(n_components=Com,copy=True,whiten=False)
    pca.fit(trainData1)
    pcaTrainData=pca.transform(trainData1)     # 在 X上进行降维
    print(pcaTrainData.shape ) # 返回模型的各个特征向量
    print('PCA完成')
    print(pca.explained_variance_ratio_)  #  各方差所占比率
    # print(pca.explained_variance_)        #   方差值
    return pcaTrainData

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

#  数据预处理
# 数据规整方法，1去掉大于1000的值，2归一化，3标准化，4robust_scale，5l1l2规范化
trainData = pre_data(method,trainData)
# 缩小维度
pca_n = pca_component(trainData)
trainData_pca=dpPCA_train(trainData,pca_n)
data = np.array(trainData_pca.T)

## 拆分各个病人的数据，并存入对应的sheet表内
if test_mode == 1:
    writer = pd.ExcelWriter(save_str)      # 创建要写入的Excel文件
    data_patient_end = 0
    for k in range(len(patient_datatime)):
        # 保存降维后的数据
        data_patient_start = data_patient_end
        data_patient_end   = data_patient_start + roi_num * patient_datatime[k]
        data_patient = data[:,data_patient_start:data_patient_end]
        print(data_patient.shape)
        data_patient = pd.DataFrame(data_patient)
        data_patient.to_excel(writer, patient_name[k])		# ‘page_1’是写入excel的sheet名
        writer.save()
        # writer.close()
    writer.close()

print('程序运行结束！')
