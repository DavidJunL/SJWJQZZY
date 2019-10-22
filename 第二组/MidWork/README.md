# 中期作业报告
## 一、数据说明
如图所示类型的数据共有395条  
Lng 起点经度
Lat 起点纬度 
Lng_e 终点经度
Lat_e 终点纬度


![数据展示：](第二组/MidWork/data.png)
## 二、聚类实现与效果
### 1、起点聚类
``` R
library(ggplot2)
library(ggfortify)
library(fpc)
library(cluster)
data <- read.csv('df3.csv')
# 起点经纬度

b = data[5:6]
#特征归一化
std_b = scale(b)
#计算不同聚类结果的平均轮廓值（avg.silwidth）
get_cluster<-function(arg1){
  k_list = 2:10
  k_list
  set.seed(2)
  sw = sapply(k_list, function(k) {
    cluster.stats(dist(arg1), kmeans(arg1, centers = k)$cluster)$avg.silwidth
  })
  plot(k_list,
       sw,
       type = "l",
       xlab = "number of clusters",
       ylab = "average silhouette width")
  num_classify = k_list[which.max(sw)]
  return(num_classify)
}
#kmeans算法聚类
fit <- kmeans(std_b, get_cluster(std_b))
autoplot(
  fit,
  data = std_b,
  label = TRUE,
  label.size = 3,
  frame = TRUE,
  main = "My_kmeansClustering"
)
```
### 效果图如下：
![起点聚类数：](第二组/MidWork/origin1.png)
![起点聚类效果图：](第二组/MidWork/origin2.png)
### 2、终点聚类
``` R
library(ggplot2)

library(ggfortify)
library(fpc)
library(cluster)
data <- read.csv('df3.csv')
# 终点经纬度
b = data[7:8]
#特征归一化
std_b = scale(b)
#计算不同聚类结果的平均轮廓值（avg.silwidth）

get_cluster<-function(arg1){
  k_list = 2:10
  k_list
  set.seed(2)
  sw = sapply(k_list, function(k) {
    cluster.stats(dist(arg1), kmeans(arg1, centers = k)$cluster)$avg.silwidth
  })
  plot(k_list,
       sw,
       type = "l",
       xlab = "number of clusters",
       ylab = "average silhouette width")
  num_classify = k_list[which.max(sw)]
  return(num_classify)
}
#kmeans算法聚类
fit <- kmeans(std_b, get_cluster(std_b))
autoplot(
  fit,
  data = std_b,
  label = TRUE,
  label.size = 3,
  frame = TRUE,
  main = "My_kmeansClustering"
)
```
### 效果图如下：
![终点聚类数：](第二组/MidWork/destination1.png)
![终点聚类效果图：](第二组/MidWork/destination2.png)
### 3、OD线聚类
``` R
library(leaflet)
library(fpc)
df3 <- read.csv("df3.csv",header = T)
#聚类的算法过程
zy<-(df3$Lng_e+df3$Lng)/2
zx<-(df3$Lat_e+df3$Lat)/2
c<-cbind(zx,zy)#组合成矩阵
get_cluster<-function(arg1){
  k_list = 2:10
  k_list
  set.seed(2)
  sw = sapply(k_list, function(k) {
    cluster.stats(dist(arg1), kmeans(arg1, centers = k)$cluster)$avg.silwidth
  })
  plot(k_list,
       sw,
       type = "l",
       xlab = "number of clusters",
       ylab = "average silhouette width")
  num_classify = k_list[which.max(sw)]
  return(num_classify)
}
#计算不同聚类结果的平均轮廓值（avg.silwidth）
line_cluster<-kmeans(c,get_cluster(c))
df3<-data.frame(df3,cluster=line_cluster$cluster)
df3$color <- cut(df3$cluster,breaks = c(0,1,2),labels = c( "#556B2F", "#FFD700"))

#开始画图
map = leaflet(df3) %>%  addTiles()#leaflet
for (i in 1:nrow(df3)) {
  map <- addPolylines(map,lng=c(df3[i,'Lng'],df3[i,'Lng_e']), lat = c(df3[i,'Lat'],df3[i,'Lat_e']),
                      color = as.character(df3[i, c('color')]),opacity = 1,weight = 1)
}
map
```
![OD线聚类数：](第二组/MidWork/od1.png)
![OD线聚类效果图：](第二组/MidWork/od2.png)
## 三、总结
在本次作业中，我们实现了起点、终点和OD线的聚类。思路均为先计算聚类结果的平均轮廓值，根据平均轮廓值确定聚类数目，之后再使用k-means算法进行聚类。


虽然实现效果止步于此，但我们的研究与思考并没有止步于此。关于OD线的聚类，我们将其抽象为线段聚类的问题，通过查找相关文献，得出一个线段聚类的方案，首先基于线段的方向进行聚类，然后根据线段的距离进行聚类。