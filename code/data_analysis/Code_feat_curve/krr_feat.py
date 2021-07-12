import time
import numpy as np
from sklearn.svm import SVR
from sklearn.model_selection import GridSearchCV
from sklearn.model_selection import learning_curve
from sklearn.kernel_ridge import KernelRidge
import matplotlib.pyplot as plt
import pandas as pd
import xlrd
from timeit import default_timer as timer
import warnings
warnings.filterwarnings("ignore")
start_data = timer()   # 计时开始
###  对pca降维后的数据进行曲线绘制
# 超参数
fig_size_h = 16     # 图像保存用尺寸高
fig_size_w = fig_size_h/2     # 图像保存用尺寸宽度
feature_start = 0      # 特征开始的行数0为第一行
feature_end   = feature_start     # pca筛选出的特征总数
X = [2.5,7.5,12.5,17.5,22.5,30,40,50,60]    # 横坐标剂量值
patient_datatime = [5,7,6,4,1,5,1,1,7,5,5,7]    # 各个病人诊断CT的时间点个数
str_data = './/data//output_l2_pca.xlsx'
pic_str = './/picture_l2//total_patient'
roi_num = 10
mode = 0            # 运行模式，1为保存图片，0为不保存
mode_start = 0      # 运行模式，1为start平移，0为original

# 各病人诊断CT时间
data_time_1 = [1.23,1.50,3.70,3.90,4.27]     # zhouzhengyuan
data_time_2 = [0.87,1.37,2.80,3.73,4.30,5.70,8.13]    #huhongjun
data_time_3 = [1.80,2.30,4.47,7.60,7.97,9.20]      #  pengzhenwu
data_time_4 = [1.43,3.80,6.97,11.60]     #   jiangxiaoping
data_time_5 = [2.63]        #   fengjuyun
data_time_6 = [3.73,6.77,8.40,11.73,14.43]    #  data_time_6mo
data_time_7 = [2.53]      #  xiangzhilin
data_time_8 = [1.07]     # chenfangqiu
data_time_9 = [1.50,2.53,5.23,7.67,9.67,12.40,15.50]      #  xiangzhilin
data_time_10= [0.53,1.33,2.07,4.60,5.63]     # chenfangqiu
data_time_11= [1.03,1.90,3.7,5.13,6.90]     # 11.wangziran
data_time_12= [0.43,2.20,4.47,6.27,8.07,9.77,1.73]    # 12.caoboyun

# 获取workbook中所有的表格
wb = xlrd.open_workbook(str_data)
patient_name = wb.sheet_names()

# 循环绘制同一个病人的krr图
for j in range(feature_start,feature_end):    # 循环保存所有特征图
    # 设置画布
    plt.figure(figsize=(fig_size_h, fig_size_w))
    plt.suptitle('剂量响应曲线')  # 给图像加总标题
    save_str = pic_str + str(j+1) + '.png'    # 图片保存名称更新
    for i in range(len(patient_datatime)):
        train = pd.read_excel(str_data, sheetname=i)  # 读取数据
        trainData = train.values[j, 1:]  # 读入评估数据
        trainData = trainData.astype(np.float64).T
        for k in range(patient_datatime[i]):
            exec("datatime=data_time_%s"%(i+1))    # 赋予变量时间
            yPost_pre = (trainData[(roi_num * k + 1):(roi_num * (k + 1))]).reshape(-1, 1)  # 读入训练数据
            X = np.array(X).reshape(-1,1)
            krPost_pre = GridSearchCV(KernelRidge(kernel='rbf', gamma=0.1), cv=5, param_grid={"alpha": [1e0, 0.1, 1e-2, 1e-3],
                                                                                                  "gamma": np.logspace(-2, 2, 5)})
            krPost_pre.fit(X[:], yPost_pre[:])
            if mode_start ==1: # 运行模式，1为start平移，0为original
                yPost_pre_kr1 = krPost_pre.predict(X)
                y_start = [yPost_pre_kr1[0]] * (roi_num - 1)   # 创建起点矩阵
                yPost_pre_kr = yPost_pre_kr1-np.array(y_start)
            else:
                yPost_pre_kr = krPost_pre.predict(X)
            plt.subplot(4,3,1+i)    # 绘制krr图
            plt.plot(X, yPost_pre_kr,label=datatime[k])
            plt.ylabel('Δfeature(%)')
            plt.title(patient_name[i])
            plt.legend(loc=2 ,fontsize=7)
    if mode == 1:  # 运行模式，1为保存图片，0，不保存
        plt.savefig(save_str)  # 保存汇总图像
        print(j)
        plt.close()  # 关闭图片，并继续执行后续代码。

end_data = timer()    # 计算总的运行时间并打印出来
print('time: %.4f' %(end_data - start_data),'s')

plt.pause(5)           # 图像显示秒数
plt.close()             # 关闭图片，并继续执行后续代码。
print('程序运行结束')