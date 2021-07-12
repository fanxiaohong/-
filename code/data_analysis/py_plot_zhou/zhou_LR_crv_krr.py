import time
import numpy as np
from sklearn.svm import SVR
from sklearn.model_selection import GridSearchCV
from sklearn.model_selection import learning_curve
from sklearn.kernel_ridge import KernelRidge
import matplotlib.pyplot as plt
import pandas as pd
from timeit import default_timer as timer
import warnings

warnings.filterwarnings("ignore")

# 超参数
fig_size_h = 16     # 图像保存用尺寸高
fig_size_w = 8     # 图像保存用尺寸宽度
# feature = [12,14]      # W纹理特征列数

# 数据加载
start_data = timer()   # 计时开始
io = r'data_analysis.xlsx'
# #############################################################################
# 输出想要的LR拟合图像
def feature_picture(feature):
    # 计算纹理特征值及回归
    # print('计算:'+train.values[feature, 0])
    def feature_plot(datatime,feature,i):
        trainPost = pd.read_excel(io, sheet_name = datatime)    # 读入治疗后数据
        X = trainPost.values[0,1:].reshape(-1,1)  # 读入横坐标dose数据
        yPost = trainPost.values[feature,1:].reshape(-1,1)  # 读入训练数据
        # 计算治疗前后纹理变化值
        yPost_pre = yPost
    # #############################################################################
        # Fit regression model
        svrPost_pre = GridSearchCV(SVR(kernel='rbf', gamma=0.1), cv=5,param_grid={"C": [1e0, 1e1, 1e2, 1e3],
                                       "gamma": np.logspace(-2, 2, 5)})
        krPost_pre = GridSearchCV(KernelRidge(kernel='rbf', gamma=0.1), cv=5,param_grid={"alpha": [1e0, 0.1, 1e-2, 1e-3],
                                      "gamma": np.logspace(-2, 2, 5)})
        svrPost_pre.fit(X[:], yPost_pre[:])
        krPost_pre.fit(X[:], yPost_pre[:])
        yPost_pre_svr = svrPost_pre.predict(X)
        yPost_pre_kr = krPost_pre.predict(X)
    # #############################################################################
        # 画出结果图
        svPost_pre_ind = svrPost_pre.best_estimator_.support_
        plt.subplot(321+i)
        plt.scatter(X[svPost_pre_ind], yPost_pre[svPost_pre_ind], c='r', s=50,
                    label='SVR support vectors',zorder=2, edgecolors=(0, 0, 0))
        plt.scatter(X, yPost_pre, c='k', label='data', zorder=1,
                    edgecolors=(0, 0, 0))
        plt.plot(X, yPost_pre_svr, c='r',label='SVR ')
        plt.plot(X, yPost_pre_kr, c='g',label='KRR ')
        # plt.xlabel('dose(Gy)')
        plt.ylabel('Δfeature (%) | '+datatime)
        # plt.title(train_pre.values[feature,0]+'__'+datatime)
        plt.legend(loc = 2,fontsize=7)
        return X,yPost_pre,yPost_pre_svr,yPost_pre_kr

    # 逻辑回归拟合曲线
    datatime = ['0611','0619','0830','0910']     #  CT日期
    plt.figure(figsize=(fig_size_h, fig_size_w))
    X,y0611_pre,y0619_pre_svr,y0611_pre_kr = feature_plot(datatime[0],feature,0)
    X,y0619_pre,y0611_pre_svr,y0619_pre_kr = feature_plot(datatime[1],feature,1)
    # X,y0505_pre,y0505_pre_svr,y0505_pre_kr = feature_plot(datatime[2],feature,2)
    # X,y0420_pre,y0420_pre_svr,y0420_pre_kr = feature_plot(datatime[3],feature,3)
    # X,y0418_pre,y0418_pre_svr,y0418_pre_kr = feature_plot(datatime[4],feature,4)
    plt.suptitle(train_pre.values[feature,0])            # 给图像加总标题
    plt.savefig('.//picture//'+train_pre.values[feature,0]+'_lr.png')   # 保存LR拟合图像

    # #############################################################################
    plt.figure(figsize=(fig_size_h, fig_size_w))
    # 绘制svr图，起点相同
    plt.subplot(221)
    plt.plot(X, y0611_pre_svr-y0611_pre_svr[0], c='r',label=datatime[0])
    plt.plot(X, y0619_pre_svr-y0619_pre_svr[0], c='k',label=datatime[1])
    # plt.plot(X, y0505_pre_svr-y0505_pre_svr[0], c='g',label=datatime[2])
    # plt.plot(X, y0420_pre_svr-y0420_pre_svr[0], c='b',label=datatime[3])
    # plt.plot(X, y0418_pre_svr-y0418_pre_svr[0], c='m',label=datatime[4])
    plt.ylabel('Δ feature (%)')
    plt.title(train_pre.values[feature,0]+'_SVR')
    plt.legend(loc=2 ,fontsize=9)

    # 绘制svr图，起点不同
    plt.subplot(223)
    plt.plot(X, y0611_pre_svr, c='r',label=datatime[0])
    plt.plot(X, y0619_pre_svr, c='k',label=datatime[1])
    # plt.plot(X, y0505_pre_svr, c='g',label=datatime[2])
    # plt.plot(X, y0420_pre_svr, c='b',label=datatime[3])
    # plt.plot(X, y0418_pre_svr, c='m',label=datatime[4])
    plt.xlabel('Dose (Gy)')
    plt.ylabel('Δ feature_percent (%)')
    plt.legend(loc=2 ,fontsize=9)

    # 绘制krr图，起点相同
    plt.subplot(222)
    plt.plot(X, y0611_pre_kr-y0611_pre_kr[0], c='r',label=datatime[0])
    plt.plot(X, y0619_pre_kr-y0619_pre_kr[0], c='k',label=datatime[1])
    # plt.plot(X, y0505_pre_kr-y0505_pre_kr[0], c='g',label=datatime[2])
    # plt.plot(X, y0420_pre_kr-y0420_pre_kr[0], c='b',label=datatime[3])
    # plt.plot(X, y0418_pre_kr-y0418_pre_kr[0], c='m',label=datatime[4])
    plt.title(train_pre.values[feature,0]+'_KRR')
    plt.legend(loc=2 ,fontsize=9)

    # 绘制krr图，起点不同
    plt.subplot(224)
    plt.plot(X, y0611_pre_kr, c='r',label=datatime[0])
    plt.plot(X, y0619_pre_kr, c='k',label=datatime[1])
    # plt.plot(X, y0505_pre_kr, c='g',label=datatime[2])
    # plt.plot(X, y0420_pre_kr, c='b',label=datatime[3])
    # plt.plot(X, y0418_pre_kr, c='m',label=datatime[4])
    plt.xlabel('Dose (Gy)')
    plt.legend(loc=2 ,fontsize=9)
    plt.savefig('.//picture//'+train_pre.values[feature,0]+'_add.png')  # 保存汇总图像

feature_glcm_start = 1     # glcm纹理特征列数12-22
# 循环输出glcm纹理图
for i in range(feature_glcm_start,feature_glcm_start+11):
    feature_picture(i)

print('图片保存成功')
end_data = timer()    # 计算总的运行时间并打印出来
print('time: %.4f' %(end_data - start_data),'s')

# plt.pause(15)           # 图像显示秒数
plt.close()             # 关闭图片，并继续执行后续代码。
print('程序运行结束')