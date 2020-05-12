# making the cdf plot for TRMM and the ground station data
rm(list = ls())
library(dplyr)
setwd("D:/Bias Correction Paper Writing")

df = read.csv("Book1.csv", header = TRUE)

df_trueData = as.data.frame(table(df$True.data))
df_modelData = as.data.frame(table(df$model.data))

df_trueData$PDF = df_trueData$Freq / length(df$True.data)
df_modelData$PDF = df_modelData$Freq / length(df$True.data)

df_trueData$CDF = cumsum(df_trueData$PDF)
df_modelData$CDF = cumsum(df_modelData$PDF)

df_trueData$Var1 = as.character(df_trueData$Var1) %>% as.numeric()
df_modelData$Var1 = as.character(df_modelData$Var1) %>% as.numeric()

min_lim_x = min(df_trueData$Var1, df_modelData$Var1)
max_lim_x = max(df_trueData$Var1, df_modelData$Var1)

png("CDF plotting.png", width = 3.25, height = 3.25, units = "in", res = 600, pointsize = 4)
par(lwd = 0.3)
plot(1, xlim = c(min_lim_x, max_lim_x), ylim = c(0,1), type = "n", xlab = "Rainfall", ylab = "CDF")
points(df_trueData$Var1,df_trueData$CDF, col = "blue", pch = "*")
points(df_modelData$Var1,df_modelData$CDF, col = "red", pch = "*")
dev.off()


######################################################
# plotting besdie bar plot for understanding the underestimation and overestimation of rainfall value. 
# Here, some rainfall values were slices to get a better visual of the rainfall. 

df_slicing = df[!(df$True.data <= 100 & df$model.data <= 100), ]
df_slicing$seq = seq(1, length(df_slicing$True.data))
df_t = t(as.matrix(df_slicing[-3]))
colnames(df_t) = df_slicing$seq

colours = c("blue", "red")
png("barplot_rainfall.png", width = 6.25, height = 3.25, units = "in", res = 600, pointsize = 4)
par(lwd = 0.3)
barplot(df_t, main = "Rainfall plot", xlab = "Time Steps", ylab = "Rainfall", beside = TRUE, col = colours,
        ylim = c(0, max(df_t) * 1.3), lwd = 0.3)

box()
legend('topright', fill = colours, legend = c("True", "TRMM"))
dev.off()

##########################################################
# interpolation algorithm for the value transfering

sim = df_modelData$Var1[751]
sim_q = df_modelData$CDF[751]

j = 0
for(i in df_trueData$CDF){
  j = j + 1
  if(i > sim_q){
    # interp_df = data.frame(df_trueData$CDF[j-1:j], df_trueData$Var1[j-1:j])
    x = df_trueData$CDF[j-1:j]
    break
  }
}