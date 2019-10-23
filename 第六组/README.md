数据挖掘期中实验报告
==========

第六组成员：
-------

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


