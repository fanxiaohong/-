import time
import numpy as np
from sklearn.svm import SVR
from sklearn.model_selection import GridSearchCV
from sklearn.model_selection import learning_curve
from sklearn.kernel_ridge import KernelRidge
import matplotlib.pyplot as plt
import pandas as pd
import os
import xlrd
from timeit import default_timer as timer
import warnings
warnings.filterwarnings("ignore")
start_data = timer()   # 计时开始
####  人均时间与纹理特征剂量响应曲线绘制，krr
# 超参数
fig_size_h = 10     # 图像保存用尺寸高
fig_size_w = fig_size_h/2    # 图像保存用尺寸宽度
feature_start = 441      # 特征开始的行数0为第一行,对应excel表行特征
feature_end   =  441 # feature_start    # pca筛选出的特征总数,+5就是5张图一起放
X = [2.5,7.5,12.5,17.5,22.5,30,40,50,60]    # 横坐标剂量值
patient_datatime = [2,4,8,8]    # 各个病人诊断CT的时间点个数
x1 = 30     # 剂量竖直线横坐标
line_marker = ['o','*','s','v','d']
datatime = [10,20,30,'2.5month']
str_data = 'E:\\roi_feat_dose\\result\\feature_all_person_treat.xls'
str_feat_start = 'E:\\roi_feat_dose\\result\\feat_filt_radiation.xls'   # 筛选出的特征结果存放位置
pic_str = 'E:\\roi_feat_dose\\result\\treat\\'
roi_num = 10
mode = 1            # 运行模式，1为保存图片，0为不保存
###############################################################################
# 判断有无文件夹，没有则创建
if not os.path.exists(pic_str):
    os.makedirs(pic_str)
    print("文件夹创建成功！")

# 获取workbook中所有的表格
wb = xlrd.open_workbook(str_data)
patient_name = wb.sheet_names()

# 设置画布
for j in range(feature_start-2,feature_end-1):
    plt.figure(figsize=(fig_size_h, fig_size_w))
    for l in range(2):
        plt.subplot(1,2,1+l)    # 绘制krr图
        for i in range(len(patient_datatime)):
            train = pd.read_excel(str_data, sheetname=i)  # 读取数据
            feat_name = train.values[:, 0]  # 读入评估数据
            plt.suptitle(feat_name[j])  # 给图像加总标题
            save_str = pic_str + feat_name[j] + '.png'  # 图片保存名称更新
            trainData = train.values[j, 1:]  # 读入评估数据
            trainData = trainData.astype(np.float64).T
            y = [0]*(roi_num-1)
            for k in range(patient_datatime[i]):  # 每个时间点求和并求平均值
                y1 = trainData[(roi_num * k + 1):(roi_num * (k + 1))]
                y = y + y1
            yPost_pre = y / patient_datatime[i]
            X = np.array(X).reshape(-1, 1)
            krPost_pre = GridSearchCV(KernelRidge(kernel='rbf', gamma=0.1), cv=5, param_grid={"alpha": [1e0, 0.1, 1e-2, 1e-3],
                                                                                                  "gamma": np.logspace(-2, 2, 5)})
            krPost_pre.fit(X[:], yPost_pre[:])
            yPost_pre_kr = krPost_pre.predict(X)
            if l ==1: # 运行模式，1为start平移，0为original
                y_start = [yPost_pre_kr[0]] * (roi_num - 1)   # 创建起点矩阵
                yPost_pre_kr_start = yPost_pre_kr-np.array(y_start)
                plt.title('dose_response_people_start')  # 给图像加总标题
                plt.plot(X, yPost_pre_kr_start, marker=line_marker[i], label=datatime[i])
            else:
                ymin = max(yPost_pre_kr)
                ymax = min(yPost_pre_kr)  # 画竖直分割线
                # plt.vlines(x1, ymin, ymax, colors="k", linestyles="-")
                plt.title('dose_response_people')  # 给图像加总标题
                plt.plot(X, yPost_pre_kr, marker=line_marker[i], label=datatime[i])
            plt.ylabel('Δfeature(%)')
            plt.legend(loc=2 ,fontsize=7)
    if mode == 1:  # 运行模式，1为保存图片，0，不保存
        plt.savefig(save_str)  # 保存汇总图像
        plt.close()  # 关闭图片，并继续执行后续代码。
    print(j)   # 打印当前正在绘制的剂量响应曲线特征顺序号

end_data = timer()    # 计算总的运行时间并打印出来
print('time: %.4f' %(end_data - start_data),'s')
# plt.pause(10)           # 图像显示秒数
# plt.close()             # 关闭图片，并继续执行后续代码。
# plt.show()
print('程序运行结束')