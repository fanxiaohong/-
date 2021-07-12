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

## 超参数，文件名
str_image = 'E:\\roi_feat_dose\data\zhouzhengyuan\segment_0619\image\\'     # 要分割图片存放位置
str_image1 = 'CT0619.00000'                       # 文件名
save_str = 'E:\\roi_feat_dose\data\zhouzhengyuan\segment_0619\label_creat\\'   # 分割好图片存放位置
image_end = 269         # 图片序列结束
# 超参数，分割效果，调好后较稳定
image_start = 1         # 图片序列开始
width = 1500     # 肺窗宽度，控制像素范围，是分割效果更好
center = -1300+46.5    # 肺窗中心,-600zhouzhengyuan分割效果不错
large_set = 2    # 结节的大小设置，腐蚀，step5
large_set1 = 10    # 使结节附着在肺上，step6
k = 1                   # 图片命名序列开始
large_area = 2          # 分割保留最大的区域，step4

def get_segmented_lungs(im, plot=False):
    '''
    This funtion segments the lungs from the given 2D slice.
    '''
    if plot == True:
        f, plots = plt.subplots(4, 2, figsize=(5, 40))
    '''
    Step 1: Convert into a binary image.
    '''
    binary = im < (center+width)
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


for i in range(image_start,image_end+1):
    if (i>=image_start and i<10):
        filename = str_image + str_image1 + '00' +str(i) + '.bmp'
        print(filename)
    if (i>=10 and i<100):
        filename = str_image + str_image1 + '0' + str(i) + '.bmp'
        print(filename)
    if (i>=100 and i<image_end+1):
        filename = str_image + str_image1 + str(i) + '.bmp'
        print(filename)
    if os.path.exists(filename):
        save_label = save_str +str(k) + '.bmp'
        print(k)
        k = k+1
        ds = plt.imread(filename)  #读取.dcm文件
        numpyImage = ds  # 提取图像信息
        data = numpyImage
        im,binary = get_segmented_lungs(data, plot=False)     # plot=true 展示处理过程的
        image = Image.fromarray(binary )
        image.save(save_label)

print('creat_over')