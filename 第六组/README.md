数据挖掘期中实验报告
==========

班级：软工学硕1班
------
第六组成员：
------
### 3190704003杨蕾：起点聚类和终点聚类的代码实现
### 3190704012何瑞：完成OD聚类里面斜率聚类的方法，用数据测试pam算法和k-means算法
### 3190704002宋琼成：完成OD聚类里面角度聚类和中心点聚类的方法
### 3190704010靳含：终点聚类算法的分析，并撰写实验报告word文档
### 3190704001卢晓晓：起点聚类算法的分析，并把整个实验报告转换成markdown文件
### 3190702021任帅龙：OD线聚类算法的分析和演讲报告
### 20190910Meltem Kaplan：起点聚类、终点聚类和OD线聚类算法相关资料收集

# 1.起点聚类
## 1.1代码
``` R
library(leaflet)
dataAll<- read.csv("df3.csv")
lng<-dataAll[,5]
lat<-dataAll[,6]
start_lat_lng<-dataAll[,5:6]
k_start<-kmeans(start_lat_lng,centers = 7)
pal <- colorFactor(domain = k_start$cluster)
leaflet(start_lat_lng)%>%addProviderTiles("Esri.WorldStreetMap")%>%
  addCircleMarkers(fillColor = ~pal(k_start$cluster),stroke = FALSE,fillOpacity = 0.8,popup=~as.character(k_start$cluster))
``` 
## 1.2说明
    采用k-means聚类方法，聚类数选择为7。
## 1.3可视化图形
![](https://github.com/DavidJunL/SJWJQZZY/blob/master/第六组/images/起点聚类.png)
# 2.终点聚类
## 2.1代码
``` R
end_lat_lng<-dataAll[,7:8]
k_end<-kmeans(end_lat_lng,centers = 6)
names(end_lat_lng)<-c("Lng","Lat")
pal <- colorFactor(domain = k_end$cluster)
leaflet(end_lat_lng)%>%addProviderTiles("Esri.WorldStreetMap")%>%
  addCircleMarkers(fillColor = ~pal(k_end$cluster),stroke = FALSE,fillOpacity = 0.8,popup=~as.character(k_end$cluster))
``` 
## 2.2说明
    采用k-means聚类方法，聚类数选择为6。
## 2.3可视化图形
![](https://github.com/DavidJunL/SJWJQZZY/blob/master/第六组/images/终点聚类.png)
# 3.OD线聚类
## 3.1角度
### 3.1.1代码
``` R
library(cluster)
library(leaflet)
library(geosphere)
library(ggplot2)
library(ggfortify)
#读取的csv数据
data3 <- read.csv("C:/Users/hr/Desktop/课程/数据挖掘/中期作业及说明/df3.csv",header = T)

# 处理起始点数度

#根据角度筛度
lo_e<-data.frame(data3$Lng_e)#结束点经度
lo_s<-data.frame(data3$Lng)#起始点经度
la_e<-data.frame(data3$Lat_e)#结束点纬度
la_s<-data.frame(data3$Lat)#起始点纬度
angle<-atan((lo_e-lo_s)/(la_e-la_s))#计算角度

data4<-data.frame(data3,angle)#将角度加入data3
angle<-na.omit(angle)#去除角度中空数
od_get1<-kmeans(angle,5)
data4 <- na.omit(data4)#去除data4中空数
data4<-data.frame(data4,od_get1$cluster)

#根据角度筛选数据展示OD线聚类于地图
pt <- cut(data4$od_get1.cluster,breaks = c(0,1,2,3,4,5),labels = c("#d01123", "#194ec5", "#19c54e","#32dcdc","#d2dc32"))
data4$State <- pt

data4 = data4[order(data4$count,decreasing = T),]
map = leaflet(data4)  %>%  addTiles()
for (i in 1:nrow(data4)) {
  map <- addPolylines(map,lng=c(data4[i,'Lng'],data4[i,'Lng_e']), lat = c(data4[i,'Lat'],data4[i,'Lat_e']),
                      color = as.character(data4[i, c('State')])
  )
}
map
``` 
### 3.1.2说明
    采用k-means聚类方法，根据角度筛选数据展示OD线聚类于地图。
### 3.1.3可视化图形
![](https://github.com/DavidJunL/SJWJQZZY/blob/master/第六组/images/OD线聚类角度.png)
## 3.2中心点
### 3.2.1代码
``` R
#根据中心点筛度
zy<-(data4$Lng_e+data4$Lng)/2#计算中心点
zx<-(data4$Lat_e+data4$Lat)/2
together<-cbind(zx,zy)#合并两列中心点数列
od_get2<-kmeans(together,5)
data4<-data.frame(data4,od_get2$cluster)

#根据中心点筛选数据展示OD线聚类于地图
data4 = data4[order(data4$count,decreasing = T),]
map = leaflet(data4)  %>%  addTiles()
for (i in 1:nrow(data4)) {
  map <- addPolylines(map,lng=c(data4[i,'Lng'],data4[i,'Lng_e']), lat = c(data4[i,'Lat'],data4[i,'Lat_e']),
                      color = as.character(data4[i, c('State')])
  )
}
map
``` 
### 3.2.2说明
    采用k-means聚类方法，根据中心点筛选数据展示OD线聚类于地图。
### 3.2.3可视化图形
![](https://github.com/DavidJunL/SJWJQZZY/blob/master/第六组/images/OD线聚类中心点.png)
# 4.总结
    起点聚类我们设置了7个簇，根据绵阳市的片区我们设立了7个K点，从聚类结果的可视化图中我们可以明显的看出每个点所在的片区和分布。
    终点聚类我们设置了6个簇，根据绵阳市的片区我们设立了6个K点，从聚类结果的可视化图中我们可以明显的看出每个点所在的片区和分布。
    OD线聚类最开始是从起始点经纬度和终点经纬度的连线与起始点的纬线的角度作为线的一个特征值来聚类。我们将其划分为5族。其中可以看出大面积都是蓝色和红色的线段，聚类效果不是很理想。所以我们考虑了另外一种算法。我们利用起始点和终点的经纬度求出两点连线的中心点，将中心点作为线的又一个特征值。再根据这个特征值对线使用K-means算法，进行聚类。
