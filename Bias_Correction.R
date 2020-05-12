setwd("/media/D/Working_Folder/final")

library(qmap)

# Weight generation files
obs <- read.csv("APHRO_98_2007_Meghna.csv")
sim <- read.csv("trmm_98_2007_mulc_3_daysum.csv")

# Applied on this file
sim.3h <- read.csv("trmm_2007_mulc3.csv")
fitted.3h <- sim.3h

stations <- colnames(obs)

for (i in 2:length(stations)) {
  station <- stations[i]
  station.obs <- as.numeric(obs[, i])
  station.sim <- as.numeric(sim[, i])
  
  station.sim.3h <- as.numeric(sim.3h[, i])
  
  station.fit <- fitQmap(station.obs, 
                         station.sim, 
                         "QUANT", 
                         wet.day = 0.1, 
                         qstep = 0.01)
  
  station.fit.3h <- station.fit
  station.fit.3h$par$modq <- station.fit.3h$par$modq/8
  station.fit.3h$par$fitq <- station.fit.3h$par$fitq/8
  station.fit.3h$wet.day <- station.fit.3h$wet.day/8
  
  station.fitted.3h <- doQmap(station.sim.3h, station.fit.3h)
  fitted.3h[, i] <- station.fitted.3h
}

write.csv(fitted.3h, "trmm_2007_mulc3_Corrected.csv")
