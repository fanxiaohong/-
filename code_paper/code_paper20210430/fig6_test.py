import matplotlib.pyplot as plt
plt.rcParams['font.family'] = ['sans-serif']
plt.rcParams['font.sans-serif'] = ['SimHei']#替换sans-serif字体为黑体
plt.rcParams['axes.unicode_minus'] = False   # 解决坐标轴负数的负号显示问题


plt.plot([1, 2], [1, 2],[5,6], [5, 3])
plt.xlabel("x轴")
plt.ylabel("y轴") # 步骤一    （宋体）
plt.title("标题", fontproperties="SimHei") #          （黑体）
plt.show()
