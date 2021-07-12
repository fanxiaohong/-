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
io = r'E:\roi_feat_dose\result\feature_lung_all.xls'
patient_name = 'zhouzhengyuan'
datatime = ['190420', '190611', '190619', '190830', '190910']  # CT日期
roi_num = 14  # roi的数量
trainPost = pd.read_excel(io, sheet_name = patient_name)    # 读入治疗后数据
# #############################################################################
# 输出想要的LR拟合图像
def feature_picture(feature,j):
    # 计算纹理特征值及回归
    print('计算：'+trainPost.values[feature,2])
    def feature_plot(patient_name,feature):
        X = list(range(0,66,5)) # 读入横坐标dose数据
        yPost_pre = trainPost.values[feature,3:(14+3)].reshape(-1,1)  # 读入训练数据
        return X, yPost_pre
    # #############################################################################

    # 逻辑回归拟合曲线
    X,y190420_pre = feature_plot(patient_name,feature)
    # X,y0611_pre,y0611_pre_kr = feature_plot(datatime[1],feature)
    # X,y0505_pre,y0505_pre_kr = feature_plot(datatime[2],feature)
    # X,y0420_pre,y0420_pre_kr = feature_plot(datatime[3],feature)
    # X,y0418_pre,y0418_pre_kr = feature_plot(datatime[4],feature)

    # #############################################################################
    # 绘制krr图，起点相同
    plt.subplot(4,3,1+j)
    plt.plot(X, y190420_pre, c='r',label=datatime[0])
    # plt.plot(X, y0611_pre_kr, c='k',label=datatime[1])
    # plt.plot(X, y0505_pre_kr-y0505_pre_kr[0], c='g',label=datatime[2])
    # plt.plot(X, y0420_pre_kr-y0420_pre_kr[0], c='b',label=datatime[3])
    # plt.plot(X, y0418_pre_kr-y0418_pre_kr[0], c='m',label=datatime[4])
    plt.xlabel('Dose (Gy)')
    plt.ylabel('Δ feature(%)')
    plt.title(trainPost.values[feature,2])
    plt.legend(loc=2 ,fontsize=10)

feature_glcm_start = 12      # glcm纹理特征列数12-22
# 循环输出glcm纹理图
j = 0
plt.figure(figsize=(fig_size_h, fig_size_w))
# plt.suptitle('GLCM')            # 给图像加总标题
for i in range(feature_glcm_start,feature_glcm_start+5):
    feature_picture(i,j)
    j =j+1
# plt.savefig('.//picture//total_glcm_krr.png')  # 保存汇总图像

print('图片保存成功')
end_data = timer()    # 计算总的运行时间并打印出来
print('time: %.4f' %(end_data - start_data),'s')
plt.show()
# plt.pause(5)           # 图像显示秒数
# plt.close()             # 关闭图片，并继续执行后续代码。
print('程序运行结束')