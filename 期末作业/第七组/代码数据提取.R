#install.packages('pdftools')
#install.packages('pdftables')
#install.packages('stringr')
#library(wordcloud2)
#library(jiebaRD)
#library(jiebaR)
library(pdftools)
library(pdftables)
library(stringr)


#func 获取指定路径中所有文件名
getFileName <- function(path){
  setwd(path)
  ret = dir()
  return (ret)
}

#func 确认指定文件是否是PDF文件
# return isPDF, 不含后缀的文件名
isPDF <- function(fn){
  typ = "pdf"
  parts <- strsplit(fn, ".", fixed = TRUE)
  n_parts <- length(parts[[1]])
  ispdf = (parts[[1]][n_parts] == typ)
  name = parts[[1]][1]
  # return(parts[[1]][n_parts] == typ)
  return (list(ispdf, name))
}

#func 文件名处理(提取论文名)
getPaperName <- function(fn){
  ret = str_remove(fn,'_.?.?.?.?.pdf')
  return(ret)
}

#func 取文件名后部分
getNameEnd <- function(name, i=4){
  n = nchar(name)
  ret = substr(name, n-i, n)
  return(ret)
}

#func 剔除关键字中多余符号
rmNotation <- function(Word){
  #Word = str_replace_all(Word, " ", ';')
  
  Word = str_remove_all(Word, "[：:】]")          #去除：:】
  Word = str_replace_all(Word, "[;；，、]", " ")   #用空格" "代替;；，、
  Word = str_replace_all(Word, "\\s+", " ")        #用一个空格代替多个空格
  Word = str_remove_all(Word, "关键词")
  Word = str_remove_all(Word, "关 键 词")   #关 键词
  Word = str_remove_all(Word, "关 键词")
  # word = wordcloud2(Word, size = 1, shape = 'circle',color = 'random-light',fontFamily = "微软雅黑")
  return(Word)
}


file_list = getFileName('C:/Users/hasee/Desktop/cy')
# print(isPDF(tmp[1])[2])

df = data.frame(Name=0, Auther=0, KeyWord=0, PaperClass=0, PaperFlag=0)
df = df[-1,]
#df[1,] = c("aaa","bb", "ccc", "ddd")
i = 1
for(item in file_list){
  tmp = isPDF(item)
  if(tmp[1] == TRUE){
    paperName = getPaperName(item)
    print(paperName)
    
    context = pdf_text(item)
    
    keyWord = str_extract(context[1], "(关\\s*键\\s*词).+.(?=\r\n)")
    
    if(is.na(keyWord))
    {
      
      keyWord = str_extract(context[1], "(?<=主 ?题 ?词).+.(?=\r\n)")
      
      if(is.na(keyWord)){
        
        keyWord = str_extract(context[2], "(?<=关 ?键 ?词).+.(?=\r\n)")    #(?<=关 ?键 ?词).{0,10}[\\s+]+.(?=\r\n)
        
      }
      
    }
    # 删除额外字符
    keyWord = rmNotation(keyWord)
    print(keyWord)
    
    autherpattern = str_c("(?<=", getNameEnd(paperName), "\r\n).+.(?=\r\n)")
    auther = str_extract(context[1], autherpattern)
    
    #paperClassN = str_extract(context[1], "(?<=中 ?图 ?法?分 ?类 ?号).{8}")
    paperClassN = str_extract(context[1], "(?<=中 ?图 ?法?分 ?类 ?号).{0,8}[A-Z0-9.\\s+]{0,15}")
    if(is.na(paperClassN))
    {
      paperClassN =  str_extract(context[2], "(?<=中 ?图 ?法?分 ?类 ?号).{0,3}[A-Z0-9.]{0,8}")
    }
    
    
    paperClassN = rmNotation(paperClassN)
    paperClassN = str_remove_all(paperClassN, "[ ]")
    paperClassN = str_remove_all(paperClassN, "[.．0123456789]")          #去除.．-0123456789
    paperClassN = str_remove_all(paperClassN, "[-]")
    
    paperFlag = str_extract(context[1], "(?<=文 ?献 ?标 ?[识志] ?码).{0,3}[A-ZＡ-Ｚ]{1}")
    if(is.na(paperFlag))
    {
      paperFlag = str_extract(context[2], "(?<=文 ?献 ?标 ?[识志] ?码).{0,3}[A-ZＡ-Ｚ]{1}")
    }
    
    
    paperFlag = rmNotation(paperFlag)
    paperFlag = str_remove_all(paperFlag, "[ ]")
    
    
    #paperClassN = str_extract(context[1], "(?<=中图分类号).+(?=文献标识码)")
    
    
    df[i,] = c(paperName, auther, keyWord, paperClassN, paperFlag)
    write.csv(df,file = "C:/Users/hasee/Desktop/mydata.csv",row.names = F)
    print(i)
    i = i + 1
  }
}


# Test Code
name = "基于模糊联合聚类方法的针灸处方主穴挖掘研究_郭艳珍.pdf"
context = pdf_text(name)
print(context[1])

# 提取中图分类号及文献标志码
#paperClassN = str_extract(context[1], "(?<=中图分类号).+(?=  )")
#print(paperClassN)

paperFlag = str_extract(context[1], "(?<=文 ?献 ?标 ?[识志] ?码).*[A-ZＡ-Ｚ]")
print(paperFlag)


paperName = getPaperName(name)
print(paperName)

keyWord = str_extract(context[1], "(?<=关 ?键 ?词).+.(?=\r\n)")
# 删除额外字符
keyWord = str_remove_all(keyWord, "[：:]")
keyWord = str_replace_all(keyWord,"[;；]", " ")
print(keyWord)

autherpattern = str_c("(?<=",paperName,"\r\n).+.(?=\r\n)")
print(autherpattern)
