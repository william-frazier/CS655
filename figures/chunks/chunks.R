library(ggplot2)
library(plyr)

c1000w5 <- read.csv("chunk1000w5", header=FALSE)
c1000w10 <- read.csv("chunk1000w10", header=FALSE)
c2000w5 <- read.csv("chunk2000w5", header=FALSE)
c2000w10 <- read.csv("chunk2000w10", header=FALSE)
c4000w5 <- read.csv("chunk4000w5", header=FALSE)
c4000w10 <- read.csv("chunk4000w10", header=FALSE)
c8000w5 <- read.csv("chunk8000w5", header=FALSE)
c8000w10 <- read.csv("chunk8000w10", header=FALSE)
c16000w5 <- read.csv("chunk16000w5", header=FALSE)
c16000w10 <- read.csv("chunk16000w10", header=FALSE)
c32000w5 <- read.csv("chunk32000w5", header=FALSE)
c32000w10 <- read.csv("chunk32000w10", header=FALSE)
c64000w5 <- read.csv("chunk64000w5", header=FALSE)
c64000w10 <- read.csv("chunk64000w10", header=FALSE)
c128000w5 <- read.csv("chunk128w5", header=FALSE)
c128000w10 <- read.csv("chunk128w10", header=FALSE)
c256000w5 <- read.csv("chunk256w5", header=FALSE)
c256000w10 <- read.csv("chunk256w10", header=FALSE)

names <- c('time','num_chunks', 'num_servers')
c1000w5 <-data.frame(c1000w5, rep(1000, 100), rep(5, 100))
colnames(c1000w5) <- names
c1000w10 <-data.frame(c1000w10, rep(1000, 100), rep(10, 100))
colnames(c1000w10) <- names
c2000w5 <-data.frame(c2000w5, rep(2000, 100), rep(5, 100))
colnames(c2000w5) <- names
c2000w10 <-data.frame(c2000w10, rep(2000, 100), rep(10, 100))
colnames(c2000w10) <- names
c4000w5 <-data.frame(c4000w5, rep(4000, 100), rep(5, 100))
colnames(c4000w5) <- names
c4000w10 <-data.frame(c4000w10, rep(4000, 100), rep(10, 100))
colnames(c4000w10) <- names
c8000w5 <-data.frame(c8000w5, rep(8000, 100), rep(5, 100))
colnames(c8000w5) <- names
c8000w10 <-data.frame(c8000w10, rep(8000, 100), rep(10, 100))
colnames(c8000w10) <- names
c16000w5 <-data.frame(c16000w5, rep(16000, 100), rep(5, 100))
colnames(c16000w5) <- names
c16000w10 <-data.frame(c16000w10, rep(16000, 100), rep(10, 100))
colnames(c16000w10) <- names
c32000w5 <-data.frame(c32000w5, rep(32000, 100), rep(5, 100))
colnames(c32000w5) <- names
c32000w10 <-data.frame(c32000w10, rep(32000, 100), rep(10, 100))
colnames(c32000w10) <- names
c64000w5 <-data.frame(c64000w5, rep(64000, 100), rep(5, 100))
colnames(c64000w5) <- names
c64000w10 <-data.frame(c64000w10, rep(64000, 100), rep(10, 100))
colnames(c64000w10) <- names
c128000w5 <-data.frame(c128000w5, rep(128000, 100), rep(5, 100))
colnames(c128000w5) <- names
c128000w10 <-data.frame(c128000w10, rep(128000, 100), rep(10, 100))
colnames(c128000w10) <- names
c256000w5 <-data.frame(c256000w5, rep(256000, 100), rep(5, 100))
colnames(c256000w5) <- names
c256000w10 <-data.frame(c256000w10, rep(256000, 100), rep(10, 100))
colnames(c256000w10) <- names


df <- rbind(c1000w5, c1000w10, c2000w5, c2000w10, c4000w5, c4000w10, c8000w5, c8000w10, c16000w5, c16000w10, c32000w5, c32000w10, c64000w5, c64000w10, c128000w5, c128000w10, c256000w5, c256000w10)

#df <- rbind(c1000w5, c1000w10, c2000w5, c2000w10, c4000w5, c4000w10, c8000w5, c8000w10, c16000w5, c16000w10, c32000w5, c32000w10, c64000w5, c64000w10)



# factor variables

df$num_chunks <- as.factor(df$num_chunks)
df$num_servers <- as.factor(df$num_servers)

# dot plot with colors
p<-ggplot(df, aes(x=num_chunks, y=time, fill=num_servers))+
  geom_boxplot(position=position_dodge(0.8)) +
  geom_dotplot(binaxis='y', stackdir='center', binwidth = 1000, position=position_dodge(.8)) +
  ggtitle("Crack Time by Number of Chunks") +
  xlab("Number of Chunks") + ylab("Crack Time (ms)") +
  labs(fill="Number of \n Workers") + 
  theme(plot.title = element_text(hjust = 0.5)) +
  stat_summary(fun.y=mean, geom="point", shape=18,size=3, color='black', position=position_dodge(.8)) +
  stat_summary(fun.y = mean, color = "black", geom = "line", size=.5, aes(group = num_servers, color=paste("mean", num_servers)), position=position_dodge(.8))

p



