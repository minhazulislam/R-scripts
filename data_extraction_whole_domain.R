library('ncdf4')
nc <- nc_open('APHRO_1998_2007_Meghna_on_TRMM.nc')
#time
time <- ncvar_get(nc, "time")
time <- as.Date(time, origin = as.Date("1998-01-01"))
#locations
lat <- ncvar_get(nc, "lat")
lon <- ncvar_get(nc, "lon")
stns <- expand.grid(lon, lat)
stns$name <- paste(stns[,1],' ',stns[,2])
#rain_data
indata <- ncvar_get(nc, 'precip')
outdata <- as.data.frame(matrix(NA, nrow = length(time), ncol = length(stns$name)))
#naming_row_column
colnames(outdata) <- stns$name
rownames(outdata) <- time
#importing_data_to_data_frame_loop
for (i in 1:length(stns$name)) 
{
  outdata[ ,i] <- indata[lon == stns[i, 1], lat == stns[i, 2], ];
}

write.csv(outdata,"try1.csv")