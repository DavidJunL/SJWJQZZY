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
    采用k-means聚类方法，聚类数选择为7.
## 1.3可视化图形


## 组员：
## 何瑞
## 靳含
## 宋琼成
## 卢晓晓
## 任帅龙
## Meltem Kaplan
