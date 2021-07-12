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
####  人均时间与纹理特征剂量响应曲线绘制，krr
# 超参数
# 超参数
fig_size_h = 10     # 图像保存用尺寸高
fig_size_w = fig_size_h/2    # 图像保存用尺寸宽度
feature_start = 265      # 特征开始的行数0为第一行,对应excel表行特征
feature_end   =   feature_start     # pca筛选出的特征总数,+5就是5张图一起放
x1 = 1.5  # 治疗结束时间
mode = 0            # 运行模式，1为保存图片，0为不保存
str_data = 'E:\\roi_feat_dose\\result\\feature_GTV_all.xls'
pic_str = 'E:\\roi_feat_dose\\result\\plot_compare\\cure_time\\original\\'

# 获取workbook中所有的表格
wb = xlrd.open_workbook(str_data)
patient_name = wb.sheet_names()
# 循环遍历所有sheet
print('load data...')
# 读入训练数据
train = pd.read_excel(str_data, sheetname= patient_name[0])   # 读取数据
feat_name = train.values[1:, 0]  # 读入评估数据
trainData = train.values[1:,1:]  # 读入评估数据
trainData = trainData.astype(np.float64) # 将这个数组转化为 float64 位的数组

# 设置画布
for j in range(feature_start-3,feature_end-2):
    plt.figure(figsize=(fig_size_h, fig_size_w))
    # plt.figure()
    plt.suptitle(feat_name[j])  # 给图像加总标题
    x = train.values[0, 1:]  # 读入横坐标时间数据
    y_all = trainData[j,:]   # 读取特征改变量的值
    data = np.vstack((np.array(x), np.array(y_all)))   # 合并x,y后进行排序，方便krr拟合
    data_sort = data[:,data[0].argsort()]
    x = np.array(data_sort[0,:]).reshape(-1, 1)
    y = np.array(data_sort[1,:])
    krPost_pre = GridSearchCV(KernelRidge(kernel='rbf', gamma=0.1), cv=5,
                              param_grid={"alpha": [1e0, 0.1, 1e-2, 1e-3],
                                          "gamma": np.logspace(-2, 2, 5)})
    svrPost_pre = GridSearchCV(SVR(kernel='rbf', gamma=0.1), cv=5, param_grid={"C": [1e0, 1e1, 1e2, 1e3],
                                                                               "gamma": np.logspace(-2, 2, 5)})
    krPost_pre.fit(x[:], y[:])
    svrPost_pre.fit(x[:], y[:])
    y_krr = krPost_pre.predict(x)     # krr回归
    y_svr = svrPost_pre.predict(x)    # svr回归
    plt.subplot(121)
    plt.plot(x, y_svr,'bo-',label='SVR_GTV')
    ymin =  max(y_svr)
    ymax =  min(y_svr)  # 画竖直分割线
    plt.vlines(x1, ymin, ymax, colors="k", linestyles="-",label='Radiation finished')
    # hlines(y, xmin, xmax)   # 画水平分割线
    plt.title('cure_response_people')  # 给图像加总标题
    plt.ylabel('Δfeature(%)')
    plt.xlabel('month')
    plt.legend(loc=2, fontsize=7)
    plt.subplot(122)
    plt.plot(x, y_krr,'r*-', label='KRR_GTV')
    ymin = max(y_krr)
    ymax = min(y_krr)  # 画竖直分割线
    plt.vlines(x1, ymin, ymax, colors="k", linestyles="-",label='Radiation finished')
    plt.title('cure_response_people')  # 给图像加总标题
            # plt.scatter(x, y_all, label='GTV')
            # plt.title('cure_response_people_dot')  # 给图像加总标题
    plt.ylabel('Δfeature(%)')
    plt.xlabel('month')
    plt.legend(loc=2, fontsize=7)
    if mode == 1:  # 运行模式，1为保存图片，0，不保存
        save_str = pic_str + feat_name[j] + '.png'  # 图片保存名称更新
        plt.savefig(save_str)  # 保存汇总图像
        plt.close()  # 关闭图片，并继续执行后续代码。
    print(j + 2)  # 打印当前正在绘制的剂量响应曲线特征顺序号


end_data = timer()    # 计算总的运行时间并打印出来
print('time: %.4f' %(end_data - start_data),'s')
# plt.pause(10)           # 图像显示秒数
# plt.close()             # 关闭图片，并继续执行后续代码。
plt.show()
print('程序运行结束')