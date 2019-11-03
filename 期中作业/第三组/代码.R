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

