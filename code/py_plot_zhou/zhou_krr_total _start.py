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
fig_size_h = 30     # 图像保存用尺寸高
fig_size_w = fig_size_h/2     # 图像保存用尺寸宽度

# 数据加载
start_data = timer()   # 计时开始
io = r'data_analysis.xlsx'
train_pre = pd.read_excel(io, sheet_name = 'pre')    # 读入治疗前数据
# #############################################################################
# 输出想要的LR拟合图像
def feature_picture(feature,j):
    # 计算纹理特征值及回归
    print('计算：'+train_pre.values[feature, 0])
    def feature_plot(datatime,feature):
        trainPost = pd.read_excel(io, sheet_name = datatime)    # 读入治疗后数据
        X = trainPost.values[0,1:].reshape(-1,1)  # 读入横坐标dose数据
        y_pre = train_pre.values[feature,1:].reshape(-1,1)  # 读入训练数据
        yPost = trainPost.values[feature,1:].reshape(-1,1)  # 读入训练数据
        # 计算治疗前后纹理变化值
        yPost_pre = (yPost - y_pre)/y_pre*100
    # #############################################################################
        # Fit regression model
        krPost_pre = GridSearchCV(KernelRidge(kernel='rbf', gamma=0.1), cv=5,param_grid={"alpha": [1e0, 0.1, 1e-2, 1e-3],
                                      "gamma": np.logspace(-2, 2, 5)})
        krPost_pre.fit(X[:], yPost_pre[:])
        yPost_pre_kr = krPost_pre.predict(X)
        return X, yPost_pre, yPost_pre_kr
    # #############################################################################

    # 逻辑回归拟合曲线
    datatime = ['0619','0611','0505','0420','0418']     #  CT日期
    X,y0619_pre,y0619_pre_kr = feature_plot(datatime[0],feature)
    X,y0611_pre,y0611_pre_kr = feature_plot(datatime[1],feature)
    # X,y0505_pre,y0505_pre_kr = feature_plot(datatime[2],feature)
    # X,y0420_pre,y0420_pre_kr = feature_plot(datatime[3],feature)
    # X,y0418_pre,y0418_pre_kr = feature_plot(datatime[4],feature)

    # #############################################################################
    # 绘制krr图，起点相同
    plt.subplot(4,3,1+j)
    plt.plot(X, y0619_pre_kr-y0619_pre_kr[0], c='r',label=datatime[0])
    plt.plot(X, y0611_pre_kr-y0611_pre_kr[0], c='k',label=datatime[1])
    # plt.plot(X, y0505_pre_kr-y0505_pre_kr[0], c='g',label=datatime[2])
    # plt.plot(X, y0420_pre_kr-y0420_pre_kr[0], c='b',label=datatime[3])
    # plt.plot(X, y0418_pre_kr-y0418_pre_kr[0], c='m',label=datatime[4])
    # plt.xlabel('Dose (Gy)')
    plt.ylabel('Δfeature(%)')
    plt.title(train_pre.values[feature,0]+'_KRR')
    plt.legend(loc=2 ,fontsize=10)

feature_glcm_start = 12      # glcm纹理特征列数12-22
feature_glrlm_start = 251       # glrlm纹理特征列数251-260
# 循环输出glcm纹理图
j = 0
plt.figure(figsize=(fig_size_h, fig_size_w))
plt.suptitle('GLCM')            # 给图像加总标题
for i in range(feature_glcm_start,feature_glcm_start+11):
    feature_picture(i,j)
    j =j+1
plt.savefig('.//picture//total_glcm_krr_start.png')  # 保存汇总图像
# 循环输出glrlm纹理图
j = 0
plt.figure(figsize=(fig_size_h, fig_size_w))
plt.suptitle('GLRLM')            # 给图像加总标题
for i in range(feature_glrlm_start,feature_glrlm_start+10):
    feature_picture(i,j)
    j =j+1
plt.savefig('.//picture//total_glrlm_krr_strat.png')  # 保存汇总图像

print('图片保存成功')
end_data = timer()    # 计算总的运行时间并打印出来
print('time: %.4f' %(end_data - start_data),'s')

plt.pause(5)           # 图像显示秒数
plt.close()             # 关闭图片，并继续执行后续代码。
print('程序运行结束')