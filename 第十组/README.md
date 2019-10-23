-期中作业
=========
小组成员：韩旭、侯涛、李炜、廖文利、任宇、孙琛恺、谢俊章、谢雨、杨尚林、尹麟名(字母排序）
-------
# (数据选取为绵阳市某时段人流情况)
# 一、数据样本
本次数据分析使用的数据如下的395条数据。
```
    kml_e	kml_s	Lng	Lat	Lng_e	Lat_e	count
终点编号	起点编号	起点经度	起点纬度	终点经度	终点纬度	轨迹条数
```
![数据样本.png](https://github.com/shengunxiansen/Test/raw/master/数据样本.png)
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

![起点聚类.png](https://github.com/shengunxiansen/Test/raw/master/起点聚类.png)

将起点数据使用K-means算法聚为了五类，分别用红、绿、深蓝、浅蓝、黑表示。
培城区（红色）
游仙区（黑色）
元通村至培城区部分（深蓝色）
西南科技大学、西南财经大学天府校区附件（浅蓝色）
元通村至永兴（绿色）

#### 终点聚类
![终点聚类.png](https://github.com/shengunxiansen/Test/raw/master/终点聚类.png)

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
#### 代码
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
![OD线聚类.png](https://github.com/shengunxiansen/Test/raw/master/OD线聚类.png)

OD线聚类使用的是K-means算法对线的中心点聚类，共聚为5类，分别使用红、绿、蓝、黄、黑表示。
使用终点标记的大小表示轨迹条数的多少。
