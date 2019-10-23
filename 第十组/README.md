-期中作业
=========
小组成员(字母排序）：
---
### 3190704005 韩  旭：分析点聚类结果并反复测试确定最合适的K值，成果展示。
### 3190702019 侯  涛：查找相关文献，从kmeans，k中值，PAM三种聚类方法中，选择合适的方法进行点聚类。
### 3190702001 李  炜：阅读文献，查找OD线聚类方案。
### 3190702017 廖文利：文件读取，分析数据，点聚类，绘制终点点的大小展示路径数目的多少，编写报告。
### 3190702016 任  宇：使用kmeans算法对点进行聚类，参与修改点聚类代码。
### 3190702020 孙琛恺：文件读取，分析数据，编写并修改点聚类及PlotOnStaticmap画图程序，编写报告。
### 3190702026 谢俊章：文件读取，分析数据，阅读文献，查找OD线聚类方案。
### 3190704006 谢  雨：文件读取，分析数据，od线特征提取，od线聚类，描绘od线，leaflet画图。
### 3190704004 杨尚林：参与修改OD线聚类代码，分析结果。
### 3190702004 尹麟名：分析线聚类结果并根据编写的程序反复测试最合适的K值。
# (数据选取为绵阳市某时段人流情况)
# 一、数据样本
本次数据分析使用的数据如下的395条数据。
```
    kml_e	kml_s	Lng	Lat	Lng_e	Lat_e	count
终点编号	起点编号	起点经度	起点纬度	终点经度	终点纬度	轨迹条数
```
![数据样本.png](https://github.com/DavidJunL/SJWJQZZY/blob/master/第十组/数据样本.png)
# 二、数据处理
## 算法
使用K-means算法对起点和终点聚类
### 1、点聚类
#### 代码
```
library(RgoogleMaps)
library(googleVis)
library(ggplot2)
library(maptools)
library(maps)
library(mapproj)
library(mapdata)
# 导入数据
mydata<-read.table(header=T,file="df3.csv",sep=",")
# 获取起点坐标并使用k-means算法聚类
origdata<-mydata[,5:6]
origdata.kmeans<-kmeans(origdata,5)
lng <- mydata[,5]
lat <- mydata[,6]
# 获取终点坐标并使用k-means算法聚类
descdata<-mydata[,7:8]
descdata.kmeans<-kmeans(descdata,5)
lng_e<-mydata[,7]
lat_e<-mydata[,8]
# 设置背景
MapBackground(lat,lng, destfile ="bckg",maptype ="terrain")
doubs.map <- ReadMapTile(destfile = "bckg")
# 绘制地图
PlotOnStaticMap(doubs.map,lat,lng,cex = 1.0,col = origdata.kmeans$cluster,pch = 19)
# 绘制起点聚类
PlotOnStaticMap(doubs.map,lat,lng,cex = 1.0,add=TRUE,col = origdata.kmeans$cluster,pch = 19)
# 绘制终点聚类
PlotOnStaticMap(doubs.map,lat_e,lng_e,cex = 1.0,add=TRUE,col = descdata.kmeans$cluster,pch = 19)
```
#### 起点聚类

![起点聚类.png](https://github.com/DavidJunL/SJWJQZZY/blob/master/第十组/起点聚类.png)

将起点数据使用K-means算法聚为了五类，分别用红、绿、深蓝、浅蓝、黑表示。
培城区（红色）
游仙区（黑色）
元通村至培城区部分（深蓝色）
西南科技大学、西南财经大学天府校区附件（浅蓝色）
元通村至永兴（绿色）

#### 终点聚类
![终点聚类.png](https://github.com/DavidJunL/SJWJQZZY/blob/master/第十组/终点聚类.png)

终点数据同样使用k-means算法聚为了五类，分别使用红、绿、深蓝、浅蓝、黑表示。
科学城（浅蓝色）
培城区（红色）
元通村（绿色）
安州区（黑色）
永兴（深蓝色）

#### 结论

根据聚类可以看出游仙区和培城区人口密度高的地区点比较密集，而安州区、永兴、元通村附近人口较少，因此点比较稀疏。

### 2、OD线聚类
#### 算法
使用K-means算法对线的中心点位置聚类

#### PlotOnStaticMap画图
```
#定义y1,y0,z1,z0简化计算过程
y1<-lng_e
y0<-lng
z1<-lat_e
z0<-lat
di<-(y1-y0)/(z1-z0)
newdata<-data.frame(mydata,di)
#将有缺省值的行数据删除。
newdata<-newdata[complete.cases(newdata[,10]),]
#实际工作中，数据集很少是完整的，许多情况下样本中都会包括若干缺失值NA，这在进行数据分析和挖掘时比较麻烦。
di<-na.omit(di) 
#根据距离进行k—means算法聚类
x.kmeans<-kmeans(di,3)
newdata <-na.omit(newdata)
newdata<-data.frame(newdata,x.kmeans$cluster)
zy<-(newdata$Lng_e+newdata$Lng)/2
zx<-(newdata$Lat_e+newdata$Lat)/2
#根据列进行合并，形成角度和经纬度生成的矩阵
c<-cbind(zx,zy)
#根据每条连线的中心点进行k—means算法聚类
x2.kmeans<-kmeans(c,3)
newdata<-data.frame(newdata,x2.kmeans$cluster)
#将聚类结果分为三类
my.data1<-subset(newdata, x2.kmeans.cluster== '1')
my.data2<-subset(newdata, x2.kmeans.cluster== '2')
my.data3<-subset(newdata, x2.kmeans.cluster== '3')
#第一类的结果用绿线表示
mydata1.f1<-c(my.data1$Lat,my.data1$Lat_e)
mydata1.f2<-c(my.data1$Lng,my.data1$Lng_e)
PlotOnStaticMap(doubs.map,mydata1.f1,mydata1.f2,lwd=1.5,col = "green", FUN = lines, add=TRUE)
#第二类的结果用蓝线表示
mydata2.f1<-c(my.data2$Lat,my.data2$Lat_e)
mydata2.f2<-c(my.data2$Lng,my.data2$Lng_e)
PlotOnStaticMap(doubs.map,mydata2.f1,mydata2.f2,lwd=1.5,col = "blue", FUN = lines, add=TRUE)
#第三类的结果用红线表示
mydata3.f1<-c(my.data3$Lat,my.data3$Lat_e)
mydata3.f2<-c(my.data3$Lng,my.data3$Lng_e)
PlotOnStaticMap(doubs.map,mydata3.f1,mydata3.f2,lwd=1.5,col = "red", FUN = lines, add=TRUE)
```

![OD线聚类.png](https://github.com/DavidJunL/SJWJQZZY/blob/master/第十组/OD线聚类2.png)

#### leaflet画图
```
library(leaflet)
library(maps)
mydata <- read.csv("df3.csv",header = T)
ViewData<-data.frame(mydata)
#对线的中心点位置进行Kmeans聚类
CenterOfLineLng<-(ViewData$Lng_e+ViewData$Lng)/2
CenterOfLineLat<-(ViewData$Lat_e+ViewData$Lat)/2
CenterLo<-cbind(CenterOfLineLng,CenterOfLineLat)
KOfCenter<-kmeans(CenterLo,5)
ViewData<-data.frame(ViewData,KOfCenter$cluster)
#给每个类设置线条颜色
pt <- cut(ViewData$KOfCenter.cluster,breaks = c(0,1,2,3,4,5),labels = c("#00FF00", "#FF0000", "#FFFF00","#0000FF","#000000"))
ViewData$State2 <- pt
#画地图
map<-leaflet()
map<- fitBounds(map,104.61,31.42,104.78,31.52)
map<-addProviderTiles(map,"OpenStreetMap.Mapnik")
#循环完成在地图上线的描绘
for (i in 1:nrow(ViewData)) {
  map <- addPolylines(map,lng=c(ViewData[i,'Lng'],ViewData[i,'Lng_e']), lat = c(ViewData[i,'Lat'],ViewData[i,'Lat_e']), 
                      color = as.character(ViewData[i, c('State2')])
  )
}
map<-addCircleMarkers(map,lng = ViewData$Lng_e,lat = ViewData$Lat_e,color = 'red',radius = ViewData$count/5)
map
```
![OD线聚类.png](https://github.com/DavidJunL/SJWJQZZY/blob/master/第十组/OD线聚类.png)

OD线聚类使用的是K-means算法对线的中心点聚类，共聚为5类，分别使用红、绿、蓝、黄、黑表示。
使用终点标记的大小表示轨迹条数的多少。

#### 结论

从OD聚类图中可以看到，在培城区、游仙区的轨迹密集，在永兴、元通村附近轨迹稀疏，由此可以猜测培城区和游仙区很有可能是主城区，生活设施便利，人口密度较大。永兴、元通村路径普遍较长，可能是因为附近缺少某些设施，如学校、医院、汽车站等。
