#起点聚类
setwd('F:\\作业\\数据挖掘\\中期作业及说明')
dat <- read.csv('df3.csv',header = TRUE)
dat <- dat[,5:6]
kc <- kmeans(dat,3)
kc$centers
kc$cluster
dat$cluster <- kc$cluster
pt1 <- cut(dat$cluster,breaks = c(0,1,2,3),labels = c("#050505", "#6495ED", "#FF0000"))
dat$State3 <- pt1
library(leaflet)
df = data.frame(
  lat = dat[,2],
  lng = dat[,1]
)
m <- leaflet(data=df)
m<- addTiles(m)
addCircleMarkers(m,lng=~lng,lat=~lat, color =as.character(dat[, c('State3')]),radius=3,fill = TRUE)



#终点聚类
setwd('F:\\作业\\数据挖掘\\中期作业及说明')
dat <- read.csv('df3.csv',header = TRUE)
dat <- dat[,7:8]
kc <- kmeans(dat,5)
kc$centers
kc$cluster
dat$cluster <- kc$cluster
pt1 <- cut(dat$cluster,breaks = c(0,1,2,3,4,5),labels = c("#050505", "#6495ED", "#FF0000","#00FF7F","#FFF000"))
dat$State5 <- pt1
library(leaflet)
df = data.frame(
  lat = dat[,2],
  lng = dat[,1]
)
m <- leaflet(data=df)
m<- addTiles(m)
addCircleMarkers(m,lng=~lng,lat=~lat, color =as.character(dat[, c('State5')]),radius=3,fill = TRUE)



#od线聚类
setwd('F:\\作业\\数据挖掘\\中期作业及说明')
dataline <- read.csv('df3.csv',header =TRUE)
ide  <- dataline[,5:8]

for (i in 1:nrow(ide)){
  
  if (ide[i,"Lng_e"]-ide[i,'Lng'] != 0 & ide[i,"Lat_e"]-ide[i,'Lat'] != 0)
  {
    if (ide[i,"Lng_e"]-ide[i,'Lng'] > 0){
      lng = (ide[i,"Lng_e"]-ide[i,'Lng']) / 4
      alng1 = (ide[i,'Lng']) + lng
      alng2 = (ide[i,'Lng']) + (lng * 2)
      alng3 = (ide[i,'Lng']) + (lng * 3)
      lat = (ide[i,"Lat_e"]-ide[i,'Lat']) / 4
      alat1 = (ide[i,'Lat']) + lat
      alat2 = (ide[i,'Lat']) + (lat * 2)
      alat3 = (ide[i,'Lat']) + (lat * 3)
    }
    else {
      lng = (ide[i,"Lng"]-ide[i,'Lng_e']) / 4
      alng1 = (ide[i,'Lng_e']) + lng
      alng2 = (ide[i,'Lng_e']) + (lng * 2)
      alng3 = (ide[i,'Lng_e']) + (lng * 3)
      lat = (ide[i,"Lat"]-ide[i,'Lat_e']) / 4
      alat1 = (ide[i,'Lat_e']) + lat
      alat2 = (ide[i,'Lat_e']) + (lat * 2)
      alat3 = (ide[i,'Lat_e']) + (lat * 3)
    }
  }else{
    alng1 = (ide[i,'Lng_e'])
    alng2 = (ide[i,'Lng_e'])
    alng3 = (ide[i,'Lng_e'])
    alat1 = (ide[i,'Lat_e'])
    alat2 = (ide[i,'Lat_e'])
    alat3 = (ide[i,'Lat_e'])
  }
  rake = atan2((ide[i,'Lat_e'] - ide[i,"Lat"]) ,(ide[i,"Lng_e"]-ide[i,'Lng']))
  ide$rake[i] = rake
  ide$alng1[i] = alng1
  ide$alng2[i] = alng2
  ide$alng3[i] = alng3
  ide$alat1[i] = alat1
  ide$alat2[i] = alat2
  ide$alat3[i] = alat3
  
}
  
julei <- kmeans(ide[,5:10],5)

jieguo<-data.frame(ide,julei$cluster)
pt <- cut(jieguo$julei.cluster,breaks = c(0,1,2,3,4,5),labels = c("#00FF00", "#FF0000", "#FFFF00","#050505", "#6495ED"))
jieguo$State <- pt

map = leaflet(jieguo)  %>%  addTiles()
for (i in 1:nrow(jieguo)) {
  map <- addPolylines(map,lng=c(jieguo[i,'Lng'],jieguo[i,'Lng_e']), lat = c(jieguo[i,'Lat'],jieguo[i,'Lat_e']),
                      color = as.character(jieguo[i, c('State')])
  )
}