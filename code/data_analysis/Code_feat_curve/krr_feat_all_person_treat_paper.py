import time
import numpy as np
from sklearn.svm import SVR
from sklearn.model_selection import GridSearchCV
from sklearn.model_selection import learning_curve
from sklearn.kernel_ridge import KernelRidge
from matplotlib.pyplot import MultipleLocator
import matplotlib.pyplot as plt
import pandas as pd
import xlrd
from timeit import default_timer as timer
import warnings
warnings.filterwarnings("ignore")
start_data = timer()   # 计时开始
####  人均时间与纹理特征剂量响应曲线绘制，krr
# 超参数
fig_size_h = 10     # 图像保存用尺寸高
fig_size_w = fig_size_h/2    # 图像保存用尺寸宽度
X = [2.5,7.5,12.5,17.5,22.5,30,40,50,60]    # 横坐标剂量值
patient_datatime = [2,4,8,7]    # 各个病人诊断CT的时间点个数
x1 = 30     # 剂量竖直线横坐标
line_marker = ['o','*','s','v','d']
datatime = [10,20,30,'2.5month']
str_data = 'E:\\roi_feat_dose\\result\\feature_all_person_treat.xls'
# pic_str = 'E:\\roi_feat_dose\\result\\plot_compare\\during_treat\\gabor\\'
pic_str = 'E:\\roi_feat_dose\\workflow\paper\\2\\'
pic_str_name = '1'  # 图片保存名称
feature_start = [271,255]     # 特征开始的行数0为第一行,对应excel表行特征图1：287,270,46,58,174,61,7,280,185,
                              #   图2：288,255，47,43,258，271,257，275，6,50
roi_num = 10
mode = 0            # 运行模式，1为保存图片，0为不保存

# 获取workbook中所有的表格
wb = xlrd.open_workbook(str_data)
patient_name = wb.sheet_names()

# 设置画布
plt.figure(figsize=(fig_size_h, fig_size_w))
plt.suptitle('Dose response curve')  # 给图像加总标题
for l in range(len(feature_start)):
    j = feature_start[l]-2
    # plt.figure(figsize=(fig_size_h, fig_size_w))
    plt.subplot(1,2,1+l)    # 绘制krr图
    for i in range(len(patient_datatime)):
        train = pd.read_excel(str_data, sheetname=i)  # 读取数据
        feat_name = train.values[:, 0]  # 读入评估数据
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
        ymin = max(yPost_pre_kr)
        ymax = min(yPost_pre_kr)  # 画竖直分割线
        # plt.vlines(x1, ymin, ymax, colors="k", linestyles="-")
        # plt.vlines(x1, ymin, ymax, colors="k", linestyles="-")
        plt.title(feat_name[j])  # 给图像加总标题
        plt.plot(X, yPost_pre_kr, marker=line_marker[i], label=datatime[i],linewidth=1,ms=10)
        ax = plt.gca()
        x_major_locator = MultipleLocator(5)   # 设置横坐标的间隔
        ax.xaxis.set_major_locator(x_major_locator)
        plt.xlabel('Dose(Gy)')
        plt.ylabel('Δfeature(%)')
        # plt.legend(loc='best' ,fontsize=8)
        plt.legend(loc='best')
if mode == 1:  # 运行模式，1为保存图片，0，不保存
    save_str = pic_str + pic_str_name + '.png'  # 图片保存名称更新
    plt.savefig(save_str)  # 保存汇总图像
    plt.close()  # 关闭图片，并继续执行后续代码。
print(j)   # 打印当前正在绘制的剂量响应曲线特征顺序号

end_data = timer()    # 计算总的运行时间并打印出来
print('time: %.4f' %(end_data - start_data),'s')
# plt.pause(10)           # 图像显示秒数
# plt.close()             # 关闭图片，并继续执行后续代码。
plt.show()
print('程序运行结束')