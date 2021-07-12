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
# 超参数
fig_size_h = 10     # 图像保存用尺寸高
fig_size_w = fig_size_h/2    # 图像保存用尺寸宽度
feature_start = 581     # 特征开始的行数0为第一行,对应excel表行特征
                          # paper图4:262，587,257，1168,1182，571,551,471,564，570
                         # paper图3:1175,255,1171,313,350,344,559,581,573,583,562,560,558,1078,1173,1177,579
                          #  306,314,
feature_end   =   feature_start     # pca筛选出的特征总数,+5就是5张图一起放
mode = 1            # 运行模式，1为保存图片，0为不保存
roi_num = 10          # 分类的类别
str_data = 'E:\\roi_feat_dose\\result\\feature_lung_all.xls'
# pic_str = 'E:\\roi_feat_dose\\result\\plot_compare\\all_time\\gabor\\'
pic_str = 'E:\\roi_feat_dose\\workflow\paper\\3\\'
patient_datatime = [5,7,6,4,1,5,1,1,7,5,5,7,7]    # 各个病人诊断CT的时间点个数
roi_name = ['lung','dose0-5','dose5-10','dose10-15','dose15-20','dose20-25','dose25-35','dose35-45','dose45-55','dose55-65']
# 病人时间点
data_time_1 = [1.23,1.50,3.70,3.90,4.27]     # zhouzhengyuan
data_time_2 = [0.87,1.37,2.80,3.73,4.30,5.70,8.13]    # huhongjun
data_time_3 = [1.80,2.30,4.47,7.60,7.97,9.20]      # pengzhenwu
data_time_4 = [1.43,3.80,6.97,11.60]     #  jiangxiaoping
data_time_5 = [2.63]        #   fengjuyun
data_time_6 = [3.73,6.77,8.40,11.73,14.43]    #  data_time_6mo
data_time_7 = [2.53]      #  xiangzhilin
data_time_8 = [1.07]     # chenfangqiu
data_time_9 = [1.50,2.53,5.23,7.67,9.67,12.40,15.50]      #  xiangzhilin
data_time_10= [0.53,1.33,2.07,4.60,5.63]     # chenfangqiu
data_time_11= [1.03,1.90,3.7,5.13,6.90]     # 11.wangziran
data_time_12= [0.43,2.20,4.47,6.27,8.07,9.77,1.73]     # 12.caoboyun
data_time_13 =[1.87,2.60,4.4,6.87,10.87,11.90,12.63]  # 13.luoguiqiu


# 获取workbook中所有的表格
wb = xlrd.open_workbook(str_data)
patient_name = wb.sheet_names()
# 循环遍历所有sheet
print('load data...')
# 读入训练数据
train = pd.read_excel(str_data, sheetname= patient_name[0])   # 读取数据
feat_name = train.values[1:, 0]  # 读入评估数据
trainData = train.values[1:,1:]  # 读入评估数据
for i in range(1,len(patient_datatime)):
    df = pd.read_excel(str_data, sheet_name=i, index=False, encoding='utf8')
    train_Data = df.values[1:, 1:]  # 读入评估数据
    trainData = np.concatenate((trainData,train_Data), axis=1)  # 默认情况下，axis=0可以不写
# 转置矩阵方便分析
# trainData = trainData.T
trainData = trainData.astype(np.float64) # 将这个数组转化为 float64 位的数组

# 设置画布
for j in range(feature_start-3,feature_end-2):
    plt.figure(figsize=(fig_size_h, fig_size_w))
    plt.suptitle(feat_name[j])  # 给图像加总标题
    for l in range(2):
        for m in range(roi_num):
            y = []  # 存储纵坐标的列表
            x = []  # 存储横坐标的列表
            for i in range(len(patient_datatime)):
                exec("data_time = data_time_%s" % (i+1))
                for n in range(len(data_time)):
                    y_tmp = trainData[j,roi_num * n + m]
                    x_tmp = data_time[n]
                    y.append(y_tmp)
                    x.append(x_tmp)
            data = np.vstack((np.array(x), np.array(y)))   # 合并x,y后进行排序，方便krr拟合
            data_sort = data[:,data[0].argsort()]
            x = np.array(data_sort[0,:]).reshape(-1, 1)
            y = np.array(data_sort[1,:])
            krPost_pre = GridSearchCV(KernelRidge(kernel='rbf', gamma=0.1), cv=5,
                                      param_grid={"alpha": [1e0, 0.1, 1e-2, 1e-3],
                                                  "gamma": np.logspace(-2, 2, 5)})
            krPost_pre.fit(x[:], y[:])
            y_krr = krPost_pre.predict(x)
            if l == 0:  # 运行模式，1为start平移，0为original
                plt.subplot(1, 2, l+1)  # 绘制krr图
                plt.plot(x, y_krr, label=roi_name[m])
                plt.title('Time response curve')  # 给图像加总标题
            else:
                y_start = [y_krr[0]] * (len(x))  # 创建起点矩阵
                y_krr = y_krr - np.array(y_start)
                plt.subplot(1, 2, l+1)  # 绘制krr图
                plt.plot(x, y_krr, label=roi_name[m])
                plt.title('Time response curve(start)')  # 给图像加总标题
        ax = plt.gca()
        x_major_locator = MultipleLocator(1)  # 设置横坐标的间隔
        ax.xaxis.set_major_locator(x_major_locator)
        plt.ylabel('Δfeature(%)')
        plt.xlabel('Month')
        plt.legend(loc='best')
    if mode == 1:  # 运行模式，1为保存图片，0，不保存
        save_str = pic_str + feat_name[j] + '_month.png'  # 图片保存名称更新
        plt.savefig(save_str)  # 保存汇总图像
        plt.close()  # 关闭图片，并继续执行后续代码。
    print(j + 2)  # 打印当前正在绘制的剂量响应曲线特征顺序号


end_data = timer()    # 计算总的运行时间并打印出来
print('time: %.4f' %(end_data - start_data),'s')
# plt.pause(10)           # 图像显示秒数
# plt.close()             # 关闭图片，并继续执行后续代码。
plt.show()
print('程序运行结束')