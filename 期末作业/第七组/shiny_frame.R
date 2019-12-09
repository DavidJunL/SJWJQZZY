library(shiny)
library(shinydashboard)
library(ggplot2)
library(DT)
# 载入
library("stringr")
library("wordcloud2")


# Define UI for application that draws a histogram
ui <- dashboardPage(
  dashboardHeader(title = "paper analyze"),
  dashboardSidebar(fileInput('file1', 'Choose CSV File',
                             accept=c('text/csv', 'text/comma-separated-values,text/plain','.csv')),
   sidebarMenu(
     menuItem("中文分类号", tabName = "classification", icon = icon("th")),
     menuItem("文献编码", tabName = "code", icon = icon("th")),
     menuItem("关键词", tabName = "keywords", icon = icon("th"))
  )),
  dashboardBody(dataTableOutput("Data"),
                tabItems(
                  # First tab content
                  tabItem(tabName = "classification",
                          fluidRow(          
                            plotOutput("plot3")
                          )
                  ),
                  
                  # Second tab content
                  tabItem(tabName = "code",
                          fluidRow(          
                            plotOutput("plot2")
                          )
                  ),
                  # Second tab content
                  tabItem(tabName = "keywords",
                          fluidRow(          
                            wordcloud2Output("plot1")
                          )
                  )
                )
    )
  )




# Define server logic required to draw a histogram
server <- function(input, output) {
  
  dataset <- reactive({inFile <- input$file1 
  if(!is.null(inFile)) 
    read.csv(inFile$datapath, header = TRUE, sep= ",", stringsAsFactors = T)  })   
  
  output$Data <- renderDataTable({datatable(dataset())})
  output$plot1<-renderWordcloud2({inFile <- input$file1
  if(!is.null(inFile)) {
  csv_data<-read.csv(inFile$datapath) #"D:/学习资料/数据挖掘/HOMEWORK/mydata.csv"
  word_list = c()
  nrow = nrow(csv_data)
  for (i in 1:nrow) {
    str = as.character(csv_data[i, 3])
    t = unlist(strsplit(str, " "))
    n = length(t)
    for (j in 1:n) {
      if (identical(t[j], "")){
        
      } else {
        word_list = append(word_list, t[j])
      }
      
    }
  }
  wordsFreq = data.frame(table(word_list))
  wordsFreq = wordsFreq[order(wordsFreq[,2],decreasing = T),]#给词频排序
  wordsFreq = wordsFreq[1:100,]   #第一行是空格
  wordcloud2(wordsFreq, size = 0.3, color = 'random-light',fontFamily = "微软雅黑")#渲染词云
  }
  })
  
  output$plot2<- renderPlot({
    inFile <- input$file1
    if(!is.null(inFile)){
    csv_data<-read.csv(inFile$datapath)
    pie1 = table(csv_data$PaperFlag)
    per.sales <- paste(round(100 * pie1 / sum(pie1),2),"%")
    slice.col <- rainbow(10)
    pie(pie1,labels = per.sales,col= slice.col,main="文献类别分类")
    legend("topright",names(pie1),cex=0.85, fill=slice.col)
    }
  }
    ) 
  output$plot3 <- renderPlot({
    inFile <- input$file1
    if(!is.null(inFile)){
    csv_data<-read.csv(inFile$datapath)
    
    item = table(csv_data$PaperClass)
    slice.col <- rainbow(10)
    per.sales <- paste(item)
    plot(item,lwd=2,xlab='图书分类号',ylab='数量',main="图书分类号统计",col= slice.col)
    legend("topright",names(item),cex=0.85, fill=slice.col)
    }
    })

}

#output$Plot <- renderPlot({    ggplot(data = data, aes(x = (!!!input$variable), y = price, colour = color)) +      geom_point() +  ggtitle("scatter diagram") +      theme(plot.title = element_text(hjust = 0.5))  })  


# Run the application 
shinyApp(ui = ui, server = server)