# 组员介绍
### 学院：网络空间安全学院
- 李源&emsp;3190802008
- 彭乔&emsp;3190802007
- 刘国航&emsp;3190802009
- 杨璐&emsp;3190809001
- 张玥靓&emsp;3190809002
- 谭鹏飞&emsp;3190802020
- 邓杭杭&emsp;3190802015
- 张运理&emsp;3190802017
- 刘盈江&emsp;3190802013



# 作业完成简介
&emsp;&emsp;小组分为三个小队，分别使用了自己的方法完成了作业。
第一分队(张运理，邓杭杭，刘盈江，谭鹏飞)负责OD线聚类，把起点终点也顺便聚类了。
第二分队(彭乔，李源，刘国航)，负责起点与终点的聚类以及整理文档。
第三分队(杨璐，张玥靓)，负责起点与终点的聚类。

-----
# 第一小分队(张运理，邓杭杭，刘盈江，谭鹏飞)
1. 安装写代码需要的包
```R
# install.packages("cluster")
library(cluster)
# install.packages("leaflet")
library(leaflet)
# install.packages("geosphere")
library(geosphere)
# install.packages("ggplot2")
library(ggplot2)
# install.packages("ggfortify")
library(ggfortify)
# install.packages("fpc")
library(fpc)
```
2. 数据读取与初步处理
```R
# 读取数据集
data_read <- read.csv("C:/Users/c401/Desktop/df3.CSV",header = T)
# 读取起点
data_start <- data_read[,5:6]
# 使用fpc包里的pamk函数来估计类的个数
pamk_start.best <- pamk(data_start)
# 输出合理的类个数
cat("number of start clusters estimated by optimum average silhouette width:", pamk_start.best$nc, "\n")
plot(pam(data_start, pamk_start.best$nc))
data_start.pam <- pam(data_start, pamk_start.best$nc)
data_read$clustering <- data_start.pam$clustering
pt1 <- cut(as.numeric(data_read$clustering),breaks = c(0,1,2,3,4,5,6,7,8,9,10),labels = c("#000000", "#008080", "#e60000","#8b4513","#00ffff","#b85798","#625b57","#0047ab","#ffd700","#ffb366"))
data_read$color_set1 <- pt1

# 读取终点
data_end <- data_read[,7:8]
pamk_end.best <- pamk(data_end)
cat("number of end clusters estimated by optimum average silhouette width:", pamk_end.best$nc, "\n")
plot(pam(data_end, pamk_end.best$nc))
data_end.pam <- pam(data_end, pamk_end.best$nc)
data_read$clustering <- data_end.pam$clustering
pt2 <- cut(as.numeric(data_read$clustering),breaks = c(0,1,2,3,4,5,6,7,8,9,10),labels = c("#000000", "#008080", "#e60000","#8b4513","#00ffff","#b85798","#625b57","#0047ab","#ffd700","#ffb366"))
data_read$color_set2 <- pt2
```

3. 分类回归与绘图
```R
#求距离
for (i in 1:nrow(data_read)){
  x1 = c(data_read[i,"Lng"],data_read[i,'Lat'])
  y1 = c(data_read[i,"Lng_e"],data_read[i,'Lat_e'])
  dist1 = distm(x1,y1)
  dist1 = dist1[1,1]
  data_read$dist[i] = dist1 
}


#添加起点，终点颜色
color_start = data.frame(color_start=c("#000000"))
color_end = data.frame(color_end=c("#fffafa"))
data_read = merge(data_read,color_start,all = T)
data_read = merge(data_read,color_end,all = T)

#画地图
map = leaflet(data_read)  %>%  addTiles()
for (i in 1:nrow(data_read)) {
  map <- addCircles(map,lng=c(data_read[i,'Lng']), lat = c(data_read[i,'Lat']),
                    color = as.character(data_read[i, c('color_set1')]))
}
map
map = leaflet(data_read)  %>%  addTiles()
for (i in 1:nrow(data_read)) {
  map <- addCircles(map,lng=c(data_read[i,'Lng_e']), lat = c(data_read[i,'Lat_e']),
                    color = as.character(data_read[i, c('color_set2')]))
}
map

# 绘线
y1<-data.frame(data_read$Lng_e)
y0<-data.frame(data_read$Lng)
z1<-data.frame(data_read$Lat_e)
z0<-data.frame(data_read$Lat)
jd<-(y1-y0)/(z1-z0)
df4<-data.frame(data_read,jd)
df4<-df4[complete.cases(df4[,10]),]
#pamk.best <- pamk(jd)
#x4<-pam(jd, pamk.best$nc)
jd<-na.omit(jd)
x4<-kmeans(jd,10)
df4 <- na.omit(df4)
df4<-data.frame(df4,x4$cluster)
zy<-(df4$Lng_e+df4$Lng)/2
zx<-(df4$Lat_e+df4$Lat)/2
c<-cbind(zx,zy)
#pamk.best <- pamk(c)
#x5<-pam(c, pamk.best$nc)
x5<-kmeans(c,10)
df4<-data.frame(df4,x5$cluster)
pt <- cut(as.numeric(df4$x4.cluster),breaks = c(0,1,2,3,4,5,6,7,8,9,10),labels = c("#000000", "#008080", "#e60000","#8b4513","#00ffff","#b85798","#625b57","#0047ab","#ffd700","#ffb366"))
df4$State <- pt

df4 = df4[order(df4$count,decreasing = T),]
map = leaflet(df4)  %>%  addTiles()
for (i in 1:nrow(df4)) {
  map <- addPolylines(map,lng=c(df4[i,'Lng'],df4[i,'Lng_e']), lat = c(df4[i,'Lat'],df4[i,'Lat_e']), 
                      color = as.character(df4[i, c('State')])
  )
}
map

pt <- cut(df4$x5.cluster,breaks = c(0,1,2,3,4,5,6,7,8,9,10),labels = c("#000000", "#008080", "#e60000","#8b4513","#00ffff","#b85798","#625b57","#0047ab","#ffd700","#ffb366"))
df4$State2 <- pt
map = leaflet(df4)  %>%  addTiles()
for (i in 1:nrow(df4)) {
  map <- addPolylines(map,lng=c(df4[i,'Lng'],df4[i,'Lng_e']), lat = c(df4[i,'Lat'],df4[i,'Lat_e']), 
                      color = as.character(df4[i, c('State2')])
  )
}
map
```

- 起点
![起点聚类图](https://user-images.githubusercontent.com/15363304/67291900-d13b8280-f514-11e9-962b-2389def91a03.png)
![起点聚类效果](https://user-images.githubusercontent.com/15363304/67291762-9df8f380-f514-11e9-8a13-5d8de156db32.png)
- 终点
![终点聚类图](https://user-images.githubusercontent.com/15363304/67291997-f7f9b900-f514-11e9-97a4-74cfbd24d777.png)
![终点聚类效果](https://user-images.githubusercontent.com/15363304/67292005-faf4a980-f514-11e9-8e04-c3066148d151.png)
- OD
![OD效果图](https://user-images.githubusercontent.com/15363304/67293540-25dffd00-f517-11e9-8bf2-c7fd9d506a44.png)

-----
# 第二小分队(彭乔，李源，刘国航)

- 起点
```r
library(ggplot2)
oddataset <- read.csv("./df3.csv")
kc_means_set <- cbind(oddataset[5], oddataset[6])
kc_set <- kmeans(kc_means_set, 4)
Lng = as.matrix(oddataset[5])
Lat = as.matrix(oddataset[6])
plot(Lng,Lat,col=kc_set$cluster, pch=20)
```
![起点聚类效果图](https://user-images.githubusercontent.com/15363304/67295293-82dcb280-f519-11e9-9e7d-3a936c1c1ae5.png)
- 终点
```r
library(ggplot2)
oddataset <- read.csv("./df3.csv")
kc_means_set <- cbind(oddataset[5], oddataset[6])
kc_set <- kmeans(kc_means_set, 4)
Lng = as.matrix(oddataset[7])
Lat = as.matrix(oddataset[8])
plot(Lng,Lat,col=kc_set$cluster, pch=20)
```
![终点聚类效果图](https://user-images.githubusercontent.com/15363304/67295305-853f0c80-f519-11e9-9642-b9456b2d72bf.png)

# 第三小分队(杨璐，张玥靓)

- 起点
```r
read.csv("df3.csv", header = FALSE)
km <- kmeans(df3[,5:6], 3,iter.max = 30)
plot(df3[c("Lng", "Lat")], col = km$cluster,pch = as.integer(iris$Species))
```

![起点聚类图](https://user-images.githubusercontent.com/15363304/67295958-67be7280-f51a-11e9-9c3a-e5ff4ffe4b3e.png)

- 终点
```r
read.csv("df3.csv", header = FALSE)
km <- kmeans(df3[,7:8], 3)
plot(df3[c("Lng_e", "Lat_e")], col = km$cluster,pch = as.integer(iris$Species))
```
![终点聚类图](https://user-images.githubusercontent.com/15363304/67295975-6db45380-f51a-11e9-9e0f-133e44221323.png)

