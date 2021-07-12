import pydicom
import matplotlib.pyplot as plt
from skimage.segmentation import clear_border
from skimage.measure import label, regionprops, perimeter
from skimage.morphology import ball, disk, dilation, binary_erosion, binary_closing
from skimage.filters import roberts, sobel
from scipy import ndimage as ndi
import numpy as np
from PIL import Image
import os
########################################################################################
## 超参数，文件名
## 日期 181014、190113、190303、190611、190831
str_file = 'E:\\roi_feat_dose'  # 文件存放位置
patient_name = '15.guoboqiu'  # 病人名
# data_time = ['200129']   # CT时间
data_time = ['180508','180517']   # CT时间
# 超参数，分割效果，调好后较稳定
image_start = 1         # 图片序列开始
threshold = -200    # 肺窗阈值，舍去外围不必要部分，step1，-600为luna16所用值,-200为
large_set = 2    # 结节的大小设置，腐蚀，step5
large_set1 = 5    # 使结节附着在肺上，step6,10或者5
large_area = 3          # 分割保留最大的区域，step4，zhouzhengyuan190830，设为3单独出

#######################################################################################
def get_segmented_lungs(im, plot=False):
    '''
    This funtion segments the lungs from the given 2D slice.
    '''
    if plot == True:
        f, plots = plt.subplots(4, 2, figsize=(5, 40))
    '''
    Step 1: Convert into a binary image.
    '''
    binary = im < threshold
    if plot == True:
        plots[0][0].axis('off')
        plots[0][0].set_title('binary image')
        plots[0][0].imshow(binary, cmap=plt.cm.bone)
    '''
    Step 2: Remove the blobs connected to the border of the image.
    '''
    cleared = clear_border(binary)
    if plot == True:
        plots[0][1].axis('off')
        plots[0][1].set_title('after clear border')
        plots[0][1].imshow(cleared, cmap=plt.cm.bone)
    '''
    Step 3: Label the image.
    '''
    label_image = label(cleared)
    if plot == True:
        plots[1][0].axis('off')
        plots[1][0].set_title('found all connective graph')
        plots[1][0].imshow(label_image, cmap=plt.cm.bone)
    '''
    Step 4: Keep the labels with 2 largest areas.
    '''
    areas = [r.area for r in regionprops(label_image)]
    areas.sort()
    if len(areas) > large_area:
        for region in regionprops(label_image):
            if region.area < areas[-large_area]:
                for coordinates in region.coords:
                    label_image[coordinates[0], coordinates[1]] = 0
    binary = label_image > 0
    if plot == True:
        plots[1][1].axis('off')
        plots[1][1].set_title(' Keep the labels with 2 largest areas')
        plots[1][1].imshow(binary, cmap=plt.cm.bone)
    '''
    Step 5: Erosion operation with a disk of radius 2. This operation is
    seperate the lung nodules attached to the blood vessels.
    '''
    selem = disk(large_set)
    binary = binary_erosion(binary, selem)
    if plot == True:
        plots[2][0].axis('off')
        plots[2][0].set_title('seperate the lung nodules attached to the blood vessels')
        plots[2][0].imshow(binary, cmap=plt.cm.bone)
    '''
    Step 6: Closure operation with a disk of radius 10. This operation is
    to keep nodules attached to the lung wall.
    '''
    selem = disk(large_set1)
    binary = binary_closing(binary, selem)
    if plot == True:
        plots[2][1].axis('off')
        plots[2][1].set_title('keep nodules attached to the lung wall')
        plots[2][1].imshow(binary, cmap=plt.cm.bone)
    '''
    Step 7: Fill in the small holes inside the binary mask of lungs.
    '''
    edges = roberts(binary)
    binary = ndi.binary_fill_holes(edges)
    if plot == True:
        plots[3][0].axis('off')
        plots[3][0].set_title('Fill in the small holes inside the binary mask of lungs')
        plots[3][0].imshow(binary, cmap=plt.cm.bone)

    '''
    Step 8: Superimpose the binary mask on the input image.
    '''
    im = (255 / 1800 * im + 1200 * 255 / 1800)
    get_high_vals = binary == 0
    im[get_high_vals] = 170
    im = np.rint(im)
    if plot == True:
        plots[3][1].axis('off')
        plots[3][1].set_title('Superimpose the binary mask on the input image')
        plots[3][1].imshow(im, cmap=plt.cm.bone)
    return im,binary

for k in range(len(data_time)):
    str_image = [str_file+'\\data\\'+ patient_name +'\\segment\\segment_'+ data_time[k] +'\\image\\'] # 要分割图片存放位置
    save_str = [str_file+'\\data\\'+ patient_name +'\\segment\\segment_'+ data_time[k] +'\\label_creat\\'] # 分割好图片存放位置
    str_image1 = 'IMG0'  # 文件名
    path = ','.join(str_image)
    ls = os.listdir(path)
    image_end = 0
    for i in ls:
        if os.path.isfile(os.path.join(path, i)):
            image_end += 1
    print('序列图片数量：', image_end)
    image_end = [image_end]

    # 判断有没有文件夹，没有则创建
    if not os.path.exists(','.join(save_str)):
        os.mkdir(','.join(save_str))
    for j in range (0,len(image_end)):
        image_end_cal = image_end[j]
        str_image_cal = str_image[j]
        save_str_cal = save_str[j]
        k = 1                   # 图片命名序列开始，重置计数
        for i in range(image_start,image_end_cal+1):
            if (i>=image_start and i<10):
                filename = str_image_cal + str_image1 + '00' +str(i) + '.dcm'
            if (i>=10 and i<100):
                filename = str_image_cal + str_image1 + '0' + str(i) + '.dcm'
            if (i>=100 and i<image_end_cal+1):
                filename = str_image_cal + str_image1 + str(i) + '.dcm'
            if os.path.exists(filename):
                save_label = save_str_cal +str(k) + '.bmp'
                print(k)
                k = k+1
                ds = pydicom.read_file(filename)  # 读取.dcm文件
                numpyImage = ds.pixel_array  # 提取图像信息
                data = numpyImage
                im,binary = get_segmented_lungs(data, plot=False)     # plot=true 展示处理过程的
                image = Image.fromarray(binary )
                image.save(save_label)


# # 流程展示
# save_label = ','.join(save_str) +str(50) + '.bmp'
# filename = ','.join(str_image) + str_image1 + '0' +str(50) + '.dcm'
# ds = pydicom.read_file(filename)  # 读取.dcm文件
# numpyImage = ds.pixel_array  # 提取图像信息
# data = numpyImage
# plt.figure()               # 展示图像灰度图
# plt.imshow(data, cmap='gray')
# im,binary = get_segmented_lungs(data, plot=True)     # plot=true 展示处理过程的
# plt.figure()                                        # 展示处理完后的轮廓
# plt.imshow(binary, cmap=plt.cm.bone)
# plt.show()
# image = Image.fromarray(binary )
# image.save(save_label)

print('creat_over')