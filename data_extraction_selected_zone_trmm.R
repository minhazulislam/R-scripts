library('ncdf4')
setwd("/media/D/Working_Folder/final")
nc <- nc_open('trmm_98_2007_mul_3_daysum.nc')
#time
time <- ncvar_get(nc, "time")
time <- as.Date(time/24, origin = as.Date("1998-01-01"))
#locations
lat <- ncvar_get(nc, "latitude")
lon <- ncvar_get(nc, "longitude")
stns <- read.csv("statons.csv")
stns$name <- paste(stns$Lon, stns$Lat)
#rain_data
indata <- ncvar_get(nc, 'pcp')
outdata <- as.data.frame(matrix(NA, nrow = length(time), ncol = length(stns$name)))
#naming_row_column
colnames(outdata) <- stns$name
rownames(outdata) <- time
#importing_data_to_data_frame_loop
for (i in 1:length(stns$name)) 
{
  outdata[ ,i] <- indata[lon == stns[i, 1], lat == stns[i, 2], ];
}

write.csv(outdata,"trmm_98_2007_mul_3_daysum.csv")
