library(leaflet)
library(cluster)

data_s = read.csv("df3.csv")

data_start = data_s[,5:6]
data_end = data_s[,7:8]

df_start = data.frame(latitude = data_start[,2], longitude=data_start[,1])
df_end = data.frame(latitude = data_end[,2], longitude=data_end[,1])

# 绘制起点图
m <- leaflet() %>%
  addTiles() %>%
  addCircleMarkers(data=df_start, color = "green")
m

# 绘制终点图
m <- leaflet() %>%
  addTiles() %>%
  addCircleMarkers(data=df_end, color = "red")
m

# 绘制OD线
len = length(df_start$latitude)
m_line <- leaflet() 
m_line <- addTiles(m_line)
for(index in 1:len){
  m_line <- addPolylines(m_line,lng = c(df_start[index,2], df_end[index,2]), lat = c(df_start[index,1], df_end[index,1]), color = "red", weight = 5)
}
m_line

# 对起点和终点分别聚类
start.pam <- pam(data_start, 6)
end.pam <- pam(data_end, 6)
# 绘制起点聚类图
m_start <- leaflet() %>%
  addTiles() %>%
  addCircleMarkers(data=df_start[start.pam$clustering==1,],color="green") %>%
  addCircleMarkers(data=df_start[start.pam$clustering==2,],color="red") %>%
  addCircleMarkers(data=df_start[start.pam$clustering==3,],color="yellow") %>%
  addCircleMarkers(data=df_start[start.pam$clustering==4,],color="tomato") %>%
  addCircleMarkers(data=df_start[start.pam$clustering==5,],color="blue") %>%
  addCircleMarkers(data=df_start[start.pam$clustering==6,],color="gray")
m_start

# 绘制终点聚类图
m_end <- leaflet() %>%
  addTiles() %>%
  addCircleMarkers(data=df_end[end.pam$clustering==1,],color="green") %>%
  addCircleMarkers(data=df_end[end.pam$clustering==2,],color="red") %>%
  addCircleMarkers(data=df_end[end.pam$clustering==3,],color="yellow") %>%
  addCircleMarkers(data=df_end[end.pam$clustering==4,],color="tomato") %>%
  addCircleMarkers(data=df_end[end.pam$clustering==5,],color="purple") %>%
  addCircleMarkers(data=df_end[end.pam$clustering==6,],color="blue")
m_end

# OD线聚类
OD = df_end - df_start
OD$dist = sqrt(OD$latitude^2 + OD$longitude^2) 
OD_pam <- pam(OD$dist, 3)

# 绘制聚类图
m_line <- leaflet() 
m_line <- addTiles(m_line)
num_clu = c(0,0,0)
for(i in 1:len){
  if (OD_pam$clustering[i] == 1){
    m_line <- addPolylines(m_line,lng = c(df_start[i,2], df_end[i,2]), lat = c(df_start[i,1], df_end[i,1]), color = "red", weight = 5)
    num_clu[1] <- num_clu[1] + 1
  }
  if (OD_pam$clustering[i] == 2){
    m_line <- addPolylines(m_line,lng = c(df_start[i,2], df_end[i,2]), lat = c(df_start[i,1], df_end[i,1]), color = "blue", weight = 5)
    num_clu[2] <- num_clu[2] + 1
  }
  if (OD_pam$clustering[i] == 3){
    m_line <- addPolylines(m_line,lng = c(df_start[i,2], df_end[i,2]), lat = c(df_start[i,1], df_end[i,1]), color = "green", weight = 5)
    num_clu[3] <- num_clu[3] + 1
  }
}
print(num_clu)
m_line
