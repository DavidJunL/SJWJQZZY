# 挖掘机小组：中期作业实验报告
## 小组成员：   
林蒙 3190605005  
（1）组织小组成员讨论，共同探讨解决方案   
（2）用代码实现起点、终点、OD线聚类，实现整个程序，并绘制、处理实验生成的图片；
讨论聚类结果与地图位置的关系；
结合地图分析最合适的K值；
分析如何对OD线进行聚类  
（3）书写该markdown实验报告   
（4）作为小组代表上台演讲   
曾欣科 3190605001   
（1）研究pam 函数和 leaflet 的使用方法，以及加载地图和线符号的画法。   
（2）结合和地图分析最合适的k类数。   
（3）结合地图与队友讨论k聚类结果的缘由。   
张云霞 3190602031   
（1）使用kmeans算法聚类和结果分析;   
（2）尝试在地图上描点和划线;   
（3）写Markdown文档模板;   
（4）讨论分析聚类结果。   
徐铭美 3190604002   
（1）参与讨论使用PAM方法是如何进行分类。   
（2）和小组其他成员一起探讨了OD线聚类。   
（3）对起点，终点，OD线聚类的数据结果进行总结分析，并进行了该部分的文档撰写。   
冯李逍 3190602011   
（1）使用基于划分的K均值算法（k值取2-10）将终点和起点聚类。   
（2）聚类可视化，画出每个类的中心点。   
（3）查找关于OD线的聚类方法，并和小组成员讨论。   
（4）讨论为什么这样聚类更好，结合地理特性总结原因。   
郑文银 3190602024   
（1）尝试使用pam算法和K-means算法进行起点和终点坐标的聚类。   
（2）和小组成员讨论程序中应该如何加载地图和显示地图，以及点和线应该如何显示的问题。   
（3）和小组成员讨论不同簇数的pam点线聚类效果对应绵阳城区的人口分布的关系。   
（4）用markdown完成实验报告的初稿，并参与程序的调测试。   
程南江 3190604005   
（1）讨论如何加载地图，显示地图以及在地图上如何显示经纬度坐标的问题。   
（2）和小组成员讨论使用PAM算法和K-Means算法对坐标进行聚类的方法并进行相关验证。   
（3）和小组成员一起进行了OD线聚类的讨论。   
陈宇 3190604004   
（1）调试了如何在Rstudio中加载地图。   
（2）讨论使用PAM方法是如何进行分类。   
（3）调试出了k=2时的起点和终点的聚类图。   
（4）和小组其他成员一起探讨了OD线聚类。   
雷小唐 3190604001   
（1）和小组讨论聚类类别和方法，提供资料参考，可行性策略    
（2）使用k-means算法尝试初步性的聚类分析得出分类结果   
（3）参与OD线聚类的综合性讨论   
蒲文博 3190605006   
（1）参与小组关于聚类相关的讨论    
（2）讨论地图和数据融合现实的问题    
（3）讨论OD线聚类的相关问题，提出采用取断点均值聚类的方法   
（排名不分先后） 
## 一、目的
对绵阳出租车起点、终点坐标进行起点聚类、终点聚类和OD线聚类。
## 一、数据说明
一个csv文件，包含了起点经度、纬度，还有终点经度、纬度。  
![](https://github.com/jelly-lemon/midterm_homework/blob/master/image/csv%E6%96%87%E4%BB%B6.png)
## 二、聚类
### 1、起点聚类
#### 目标：对起点位置进行聚类   
#### 算法：使用PAM算法对坐标进行聚类。   
输入：簇的数目k和包含n个对象的数据库   
输出：k个簇，使得所有对象与其距离最近中心点的相异度总和最小   
（1） 任意选择k个对象作为初始的簇中心点    
（2） Repeat   
（3） 指派每个剩余对象给离他最近的中心点所表示的簇   
（4） Repeat   
（5） 选择一个未被选择的中心点Oi   
（6） Repeat   
（7） 选择一个未被选择过的非中心点对象Oh   
（8） 计算用Oh代替Oi的总代价并记录在S中   
（9） Until 所有非中心点都被选择过   
（10） Until 所有的中心点都被选择过   
（11） If 在S中的所有非中心点代替所有中心点后的计算出总代价有小于0的存在，then找出S中的用非中心点替代中心点后代价最小的一个，并用该非中心点替代对应的中心点，形成一个新的k个中心点的集合   
（12） Until 没有再发生簇的重新分配，即所有的S都大于0.
#### 代码：   
```{r}
install.packages("leaflet") # 安装地图
install.packages("cluster")

library(leaflet) # 加载地图
library(dplyr) # select函数
library(cluster)

# 读取经纬度,起点,终点
file_path = "C:/Users/lemon laptop/OneDrive/研究生/数据挖掘/中期作业及说明/df3.csv"
csv_data <- read.csv(file=file_path, header=TRUE)
start_point <- select(csv_data, 'Lng', 'Lat') # 取指定列
color = c("blue", "green", "red", "black", "orange", "pink", "purple", "white")

# 1、把起点位置显示在地图
global_map <- leaflet() # 生成一张地图
global_map <- addTiles(global_map) # 添加标题,必须有,否则不显示地图
global_map <- addMarkers(global_map, lng = ~Lng, lat = ~Lat, data = start_point)
global_map

# 2、对起点进行聚类
k = 2
start_point.pam <- pam(start_point, k = k)

# 3、聚类后画图，分颜色
global_map <- leaflet() # 生成一张地图
global_map <- addTiles(global_map) # 添加标题,必须有,否则不显示地图
for (i in 1:k) { # 遍历k个聚类
  icon = makeAwesomeIcon(icon= '', markerColor = color[i])
  global_map <- addAwesomeMarkers(global_map, lng = ~Lng, lat = ~Lat, icon = icon,
                                  data = start_point[start_point.pam$clustering==i,])
}
global_map
```
#### 结果：
起点分布图：   
![](https://github.com/jelly-lemon/midterm_homework/blob/master/image/%E8%B5%B7%E7%82%B9.png)
PAM聚类，k=2：   
![](https://github.com/jelly-lemon/midterm_homework/blob/master/image/%E8%B5%B7%E7%82%B9%E8%81%9A%E7%B1%BB%20k%3D2.png)      
PAM聚类，k=3：   
![](https://github.com/jelly-lemon/midterm_homework/blob/master/image/%E8%B5%B7%E7%82%B9%E8%81%9A%E7%B1%BB%20k%3D3.png)   
PAM聚类，k=4：   
![](https://github.com/jelly-lemon/midterm_homework/blob/master/image/%E8%B5%B7%E7%82%B9%E8%81%9A%E7%B1%BB%20k%3D4.png)   
PAM聚类，k=5：   
![](https://github.com/jelly-lemon/midterm_homework/blob/master/image/%E8%B5%B7%E7%82%B9%E8%81%9A%E7%B1%BB%20k%3D5.png)   
PAM聚类，k=6：   
![](https://github.com/jelly-lemon/midterm_homework/blob/master/image/%E8%B5%B7%E7%82%B9%E8%81%9A%E7%B1%BB%20k%3D6.png)   
PAM聚类，k=7：   
![](https://github.com/jelly-lemon/midterm_homework/blob/master/image/%E8%B5%B7%E7%82%B9%E8%81%9A%E7%B1%BB%20k%3D7.png)   
#### 分析：  
![](https://github.com/jelly-lemon/midterm_homework/blob/master/image/%E8%B5%B7%E7%82%B9%E8%81%9A%E7%B1%BB%20k%3D3.png)    
对于起点数据，本组采用PAM方法分别将绵阳市区内所有的起始点聚为2,3,4,5,6,7,个类（聚类结果分别如上图所示）。   
最后经过比较，选取了K值为3的聚类结果，因为当k=3时，坐标点分布的区域相对集中，而且每个区域间的间隔相对较大，因此聚类效果是比较好的。
并通过绿、红、蓝三个颜色进行标记区分。   
从地域上看，第一部分为涪城区以南的区域（绿色部分），相比其它区域起点数量较少。   
第二部分集中于游仙区西北区域（红色部分），由于靠近科学城人口密集，因此起始点最多，且分布最为密集。   
以西安到成都的客运专线为界以西为第三部分（蓝色部分），由于此区域属于绵阳市的乡村区域，所以地点分布较为稀疏。
### 2、终点聚类
#### 目标：对终点坐标进行聚类   
#### 算法：PAM，同上
#### 代码：
```{r}
install.packages("leaflet") # 安装地图
install.packages("cluster")

library(leaflet) # 加载地图
library(dplyr) # select函数
library(cluster)

# 读取经纬度,起点,终点
file_path = "C:/Users/lemon laptop/OneDrive/研究生/数据挖掘/中期作业及说明/df3.csv"
csv_data <- read.csv(file=file_path, header=TRUE)
end_point <- select(csv_data, 'Lng_e', 'Lat_e') # 取指定列
color = c("blue", "green", "red", "black", "orange", "pink", "purple", "white")

# 1、把位置显示在地图
global_map <- leaflet() # 生成一张地图
global_map <- addTiles(global_map) # 添加标题,必须有,否则不显示地图,必须有返回 <-
global_map <- addMarkers(global_map, lng = ~Lng_e, lat = ~Lat_e, data = end_point)
global_map

# 2、进行聚类
k = 7
end_point.pam <- pam(end_point, k = k)

# 3、聚类后画图，分颜色
global_map <- leaflet() # 生成一张地图
global_map <- addTiles(global_map) # 添加标题,必须有,否则不显示地图
for (i in 1:k) { # 遍历k个聚类
  icon = makeAwesomeIcon(icon= '', markerColor = color[i])
  global_map <- addAwesomeMarkers(global_map, lng = ~Lng_e, lat = ~Lat_e, icon = icon,
                                  data = end_point[end_point.pam$clustering==i,])
}
global_map
```
#### 结果：   
终点分布图：   
![](https://github.com/jelly-lemon/midterm_homework/blob/master/image/%E7%BB%88%E7%82%B9.png)   
PAM聚类，k=2，聚类结果如下：   
![](https://github.com/jelly-lemon/midterm_homework/blob/master/image/%E7%BB%88%E7%82%B9%E8%81%9A%E7%B1%BB%20k%3D2.png)
PAM聚类，k=3，聚类结果如下：   
![](https://github.com/jelly-lemon/midterm_homework/blob/master/image/%E7%BB%88%E7%82%B9%E8%81%9A%E7%B1%BB%20k%3D3.png)
PAM聚类，k=4，聚类结果如下：   
![](https://github.com/jelly-lemon/midterm_homework/blob/master/image/%E7%BB%88%E7%82%B9%E8%81%9A%E7%B1%BB%20k%3D4.png)
PAM聚类，k=5，聚类结果如下：   
![](https://github.com/jelly-lemon/midterm_homework/blob/master/image/%E7%BB%88%E7%82%B9%E8%81%9A%E7%B1%BB%20k%3D5.png)
PAM聚类，k=6，聚类结果如下：   
![](https://github.com/jelly-lemon/midterm_homework/blob/master/image/%E7%BB%88%E7%82%B9%E8%81%9A%E7%B1%BB%20k%3D6.png)
PAM聚类，k=7，聚类结果如下：   
![](https://github.com/jelly-lemon/midterm_homework/blob/master/image/%E7%BB%88%E7%82%B9%E8%81%9A%E7%B1%BB%20k%3D7.png)
#### 分析：
![](https://github.com/jelly-lemon/midterm_homework/blob/master/image/%E7%BB%88%E7%82%B9%E8%81%9A%E7%B1%BB%20k%3D4.png)
对于终点数据，同样采用PAM方法分别将绵阳市区内的终点聚为2,3,4,5,6,7个类（如上图所示）。   
最后经过比较，选取了K值为4的聚类结果。k=3时，类内间距太大，有离群点。k>=5时，聚类太多，每一个类的数量太少。
综上所述，k=4时类间距离最好，聚类个数合适。
通过绿、红、蓝、黑三个颜色进行标记区分。   
从区域分布上看，与起点聚类分布较为相似：   
第一部分为涪城区以南的区域（绿色部分）。   
第二部分集中于游仙区西北区域（蓝色部分），以西方向延伸至二环路，此区域内分布的起点数量最多，且最为密集。
第三部分（黑色），在一环外，二环内，相对集中。   
第四部分（红色），在二环外，此区域内的起点数量分布最少。 
### 3、OD线聚类
#### 目标：对OD线进行聚类   
#### 算法：PAM算法，同上   
#### 代码：
```{r}
install.packages("leaflet") # 安装地图
install.packages("cluster")

library(leaflet) # 加载地图
library(dplyr) # select函数
library(cluster)

# 读取经纬度,起点,终点
file_path = "C:/Users/lemon laptop/OneDrive/研究生/数据挖掘/中期作业及说明/df3.csv"
csv_data <- read.csv(file=file_path, header=TRUE)
line_data <- select(csv_data, 'Lng', 'Lat', 'Lng_e', 'Lat_e') # 取指定列
color = c("blue", "green", "red", "black", "orange", "pink", "purple", "white")

# 1、把位置显示在地图
global_map <- leaflet() # 生成一张地图
global_map <- addTiles(global_map) # 添加标题,必须有,否则不显示地图,必须有返回 <-
icon.blue <- makeAwesomeIcon(icon= '', markerColor = 'blue')
icon.red <- makeAwesomeIcon(icon= '', markerColor = 'red')
global_map <- addAwesomeMarkers(global_map, lng = ~Lng_e, lat = ~Lat_e, icon = icon.red, data = line_data)
global_map <- addAwesomeMarkers(global_map, lng = ~Lng, lat = ~Lat, icon = icon.blue, data = line_data)
global_map
n <- as.numeric(rownames(line_data))
for (i in n) {
  global_map <- addPolylines(global_map, lng = c(line_data[i,1], line_data[i,3]), lat = c(line_data[i,2], line_data[i,4]), weight = 1)
}
global_map

# 2、进行聚类
k = 4
line_data.pam <- pam(line_data, k = k)

# 3、聚类后画图，分颜色
global_map <- leaflet() # 生成一张地图
global_map <- addTiles(global_map) # 添加标题,必须有,否则不显示地图,必须有返回 <-
n <- as.numeric(rownames(line_data))
for (i in n) {
  global_map <- addPolylines(global_map, lng = c(line_data[i,1], line_data[i,3]), lat = c(line_data[i,2], line_data[i,4]), weight = 2, color = color[line_data.pam$clustering[i]])
}
global_map
```
#### 结果：   
OD线分布图：   
蓝色点位为起点，红色点位为终点。因为先画的起点，后画的终点，所有有些起点被终点覆盖。
![](https://github.com/jelly-lemon/midterm_homework/blob/master/image/%E7%BA%BF%20%E6%9C%AA%E5%88%86%E7%B1%BB%20%E5%85%88%E7%94%BB%E8%B5%B7%E7%82%B9%E5%90%8E%E7%94%BB%E7%BB%88%E7%82%B9%20%E6%9C%89%E8%A6%86%E7%9B%96%E7%8E%B0%E8%B1%A1.png)
PAM聚类，k=2，聚类结果如下：   
![](https://github.com/jelly-lemon/midterm_homework/blob/master/image/%E7%BA%BF%E8%81%9A%E7%B1%BB%20k%3D2.png)
PAM聚类，k=3，聚类结果如下：   
![](https://github.com/jelly-lemon/midterm_homework/blob/master/image/%E7%BA%BF%E8%81%9A%E7%B1%BB%20k%3D3.png)
PAM聚类，k=4，聚类结果如下：   
![](https://github.com/jelly-lemon/midterm_homework/blob/master/image/%E7%BA%BF%E8%81%9A%E7%B1%BB%20k%3D4.png)
#### 分析：   
![](https://github.com/jelly-lemon/midterm_homework/blob/master/image/%E7%BA%BF%E8%81%9A%E7%B1%BB%20k%3D3.png)
对于OD线的聚类，本组选取每条OD线的中点，再使用PAM方法来进行聚类。   
聚类前的OD线分布如上图一所示，红色代表终点，蓝色代表起点（其中部分既为起点，又是终点的点在标记时出现了覆盖现象，所以图中显示的红色点较多）。   
并分别取K值为2,3,4来进行聚类比较，最终取K=3来作为最终的聚类值（结果如图所示），分别用绿，蓝，红三色标记区分这三类OD线。
若k>=4，整个图颜色杂乱，不易观察。   
其中，蓝色部分的OD线分布最为交叉密集；   
绿色部分的起始点集中于机场东路上；   
红色部分的起始点集中于绵兴西路和辽宁大道。

