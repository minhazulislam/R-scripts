library('ncdf4')
setwd("/media/D/ALL_DATASETS_BIAS_CORRECTION/TRMM/Year_basis_TRMM_3hrly_98_17_meghna_regridded_domain_rainfall_mm")
file <- list.files(pattern = "\\.nc$")

for (j in 1:length(file)){
  nc <- nc_open(file[j])
  #time
  time <- ncvar_get(nc, "time")
  time <- format(as.Date(time/24, origin = as.Date(paste(unlist(strsplit(unlist(strsplit(file[j],"_"))[1],"[.]"))[2],"-1-1",sep = "")), "%Y-%m-%d %H:%M:%S"))
  #locations
  lat <- ncvar_get(nc, "lat")
  lon <- ncvar_get(nc, "lon")
  stns <- expand.grid(lon,lat)
  colnames(stns) <- c("lon","lat")
  #rain_data
  indata <- ncvar_get(nc, 'pcp')
  outdata <- as.data.frame(matrix(NA, nrow = length(time)+2, ncol = length(stns$lon)+1))
  
  outdata$V1[-c(1,2)] <- time
  outdata[c(1,2),-1] <- rbind(t(stns$lon),t(stns$lat))
  #importing_data_to_data_frame_loop
  for (i in 1:length(stns$lon)) 
  {
    outdata[-c(1,2),i+1] <- indata[lon == stns[i, 1], lat == stns[i, 2], ];
  }
  
  write.csv(outdata,paste(unlist(strsplit(unlist(strsplit(file[j],"_"))[1],"[.]"))[2],".csv",sep = ""))
  
}