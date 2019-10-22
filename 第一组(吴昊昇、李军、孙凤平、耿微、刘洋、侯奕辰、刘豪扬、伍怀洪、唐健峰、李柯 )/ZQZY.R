library(cluster)
library(leaflet)
library(geosphere)
library(ggplot2)
library(ggfortify)
df3 <- read.csv("df3.csv",header = T)
#df3$distance = 6371000*acos(cos(df3$Lat)*cos(df3$Lat_e)*cos(df3$Lng-df3$Lng_e)+sin(df3$Lat)*sin(df3$Lat_e))
#x <- df3$distance
x3 <- df3[,7:8]
x3.pam <- pam(x3,3)
plot(x3.pam)
autoplot(x3.pam, frame = TRUE, frame.type = 'norm')
df3$clustering <- x3.pam$clustering
pt1 <- cut(df3$clustering,breaks = c(0,1,2,3),labels = c("#00FF00", "#FF0000", "#FFFF00"))
df3$State3 <- pt1

x2 <- df3[,5:6]
x2.pam <- pam(x2,3)
df3$clustering <- x2.pam$clustering
pt2 <- cut(df3$clustering,breaks = c(0,1,2,3),labels = c("#00FF00", "#FF0000", "#FFFF00"))
df3$State4 <- pt2
plot(x2.pam)
#求距离

#画地图
map = leaflet(df3)  %>%  addTiles()
for (i in 1:nrow(df3)) {
  map <- addCircles(map,lng=c(df3[i,'Lng']), lat = c(df3[i,'Lat']),
                    color = as.character(df3[i, c('State3')]))
}
map
map = leaflet(df3)  %>%  addTiles()
for (i in 1:nrow(df3)) {
  map <- addCircles(map,lng=c(df3[i,'Lng_e']), lat = c(df3[i,'Lat_e']),
                    color = as.character(df3[i, c('State4')]))
}
map

y1<-data.frame(df3$Lng_e)
y0<-data.frame(df3$Lng)
z1<-data.frame(df3$Lat_e)
z0<-data.frame(df3$Lat)
jd<-atan((y1-y0)/(z1-z0))
df4<-data.frame(df3,jd)
df4<-df4[complete.cases(df4[,10]),]
jd<-na.omit(jd)

x4<-kmeans(jd,3)
df4 <- na.omit(df4)
df4<-data.frame(df4,x4$cluster)
zy<-(df4$Lng_e+df4$Lng)/2
zx<-(df4$Lat_e+df4$Lat)/2
c<-cbind(zx,zy)
x5<-kmeans(c,3)
df4<-data.frame(df4,x5$cluster)
pt <- cut(df4$x4.cluster,breaks = c(0,1,2,3),labels = c("#00FF00", "#FF0000", "#FFFF00"))
df4$State <- pt
df5 <- data.frame(c,jd)
x8.pam <- kmeans(df5,8)
df5 <-data.frame(df5,df4)
df5 <- data.frame(df5,x8.pam$cluster)
pt <- cut(df5$x8.pam.cluster,breaks = c(0,1,2,3,4,5,6),labels = c("#00FF00", "#FF0000", "#FFFF00","#009E73","#56B4E9","#F0E442"))
df5$State8 <- pt

df4 = df4[order(df4$count,decreasing = T),]
map = leaflet(df4)  %>%  addTiles()
for (i in 1:nrow(df4)) {
  map <- addPolylines(map,lng=c(df4[i,'Lng'],df4[i,'Lng_e']), lat = c(df4[i,'Lat'],df4[i,'Lat_e']), 
                      color = as.character(df4[i, c('State')])
  )
}
map

pt <- cut(df4$x5.cluster,breaks = c(0,1,2,3),labels = c("#00FF00", "#FF0000", "#FFFF00"))
df4$State2 <- pt
map = leaflet(df4)  %>%  addTiles()
for (i in 1:nrow(df4)) {
  map <- addPolylines(map,lng=c(df4[i,'Lng'],df4[i,'Lng_e']), lat = c(df4[i,'Lat'],df4[i,'Lat_e']), 
                      color = as.character(df4[i, c('State2')])
  )
}
map

df5 = df5[order(df5$count,decreasing = T),]
map = leaflet(df5)  %>%  addTiles()
for (i in 1:nrow(df5)) {
  map <- addPolylines(map,lng=c(df5[i,'Lng'],df5[i,'Lng_e']), lat = c(df5[i,'Lat'],df5[i,'Lat_e']), 
                      color = as.character(df5[i, c('State8')])
  )
}
map
