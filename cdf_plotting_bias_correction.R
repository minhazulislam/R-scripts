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
# Bias correction algorithm for correcting the TRMM data

obs_vec = round(df_trueData$Var1, digits = 7)
obs_q_vec = round(df_trueData$CDF, digits = 7)

df$corrected = NA

for(i in seq(1,length(df$model.data)))
{
  sim = round(df$model.data[i], digits = 7)
  sim_q = round(approx(df_modelData$Var1, df_modelData$CDF, xout = sim)$y, digits = 7)
  
  if(sim_q > min(obs_q_vec))
  {
    cor_sim = approx(obs_q_vec, obs_vec, xout = sim_q)$y
    df$corrected[i] = cor_sim
  }
  else
  {
    cor_sim = min(obs_vec)
    df$corrected[i] = cor_sim
  }
}
#####################################################################
# checking the correction using cdf plotting 

cor = df$corrected
df_cor = as.data.frame(table(cor))
df_cor$cor = round(as.numeric(as.character(df_cor$cor)), digits = 7)
df_cor$PDF = df_cor$Freq / length(df$corrected)
df_cor$CDF = cumsum(df_cor$PDF)


min_lim_x = min(df_trueData$Var1, df_modelData$Var1, df_cor$cor)
max_lim_x = max(df_trueData$Var1, df_modelData$Var1, df_cor$cor)

# par(lwd = 0.3)
plot(1, xlim = c(min_lim_x, max_lim_x), ylim = c(0,1), type = "n", xlab = "Rainfall", ylab = "CDF")
points(df_trueData$Var1,df_trueData$CDF, col = "yellow", pch = "*")
points(df_modelData$Var1,df_modelData$CDF, col = "red", pch = "*")
points(df_cor$cor,df_cor$CDF, col = "black", pch = ".")
dev.off()
