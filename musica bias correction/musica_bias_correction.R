
a1<-read.csv("sylhet_historical.csv",header=TRUE)
b1<-read.csv("sylhet_daily_4.5_2041_2070.csv",header =TRUE )
c1<-read.table("DTM_historical.txt",header=TRUE)
d1<-read.table("DTM_future.txt",header = TRUE)
L=min(length(a1[,1]),length(b1[,1]),length(c1[,1]),length(d1[,1]))


a<-a1[1:L,]
b<-b1[1:L,]
c<-data.frame(c1[1:L,])
d<-data.frame(d1[1:L,])
colnames(c)<-"DTM"
colnames(d)<-"DTM"

output<-c("ACCESS1_8.5_2071.csv",	"CCSM4_8.5_2071.csv",	"CNRM_8.5_2071.csv",	"MPI-REMo_8.5_2071.csv",	"MPI_8.5_2071.csv",	"SMHI_8.5_2071.csv")
output1<-c("ACCESS1_historical.csv",	"CCSM4_historical.csv",	"CNRM_historical.csv",	"MPI-REMo_historical.csv",	"MPI_historical.csv",	"SMHI_historical.csv")


library("musica")

for(i in 1:6)
{

observed<-as.data.frame(matrix(NA,nrow=length(a[,1]),ncol=3))
colnames(observed)<-c("DTM","PR","TAS")
observed$DTM<-c$DTM
observed$PR<-a[,4]
observed$TAS<--999
observed$DTM<-as.Date(observed$DTM)



control<-as.data.frame(matrix(NA,nrow=length(a[,1]),ncol=3))
colnames(control)<-c("DTM","PR","TAS")
control$DTM<-c$DTM
control$PR<-a[,i+4]
control$TAS<--999
control$DTM<-as.Date(control$DTM)

scenario<-as.data.frame(matrix(NA,nrow=length(b[,1]),ncol=3))
colnames(scenario)<-c("DTM","PR","TAS")
scenario$DTM<-d$DTM
scenario$PR<-b[,i+3]
scenario$TAS<--999
scenario$DTM<-as.Date(scenario$DTM)

data<-list(obs_ctrl=observed,sim_ctrl=control,sim_scen=scenario)


scen = data$sim_scen
ctrl = data$sim_ctrl
obs = data$obs_ctrl

dta_future = list(TO = obs, FROM = ctrl, NEWDATA = scen)
dta_his = list(TO = obs, FROM = ctrl, NEWDATA = ctrl)

correction_future<-msTrans_abs(dta_future,  maxiter = 10, period = 'D1',wet_int_thr = 1)
correction_his<-msTrans_abs(dta_his,  maxiter = 10, period = 'D1',wet_int_thr = 1)



write.csv(correction_future,output[i])

write.csv(correction_his,output1[i])

}
#**************************************************
a1<-read.csv("ACCESS1_historical.csv",header = TRUE)
b1<-read.csv("CCSM4_historical.csv",header = TRUE)
c1<-read.csv("CNRM_historical.csv",header = TRUE)
d1<-read.csv("MPI-REMo_historical.csv",header = TRUE)
e1<-read.csv("MPI_historical.csv",header = TRUE)
f1<-read.csv("SMHI_historical.csv",header = TRUE)

historical<-cbind(a[,1:4],a1[,3],b1[,3],c1[,3],d1[,3],e1[,3],f1[,3])

colnames(historical)<-c("day",	"month",	"year",	"obs",
                      "ACCESS1",	"CCSM4",	"CNRM",	"MPI-REMo",	"MPI",	"SMHI")


a11<-read.csv("ACCESS1_8.5_2071.csv",header = TRUE)
b11<-read.csv("CCSM4_8.5_2071.csv",header = TRUE)
c11<-read.csv("CNRM_8.5_2071.csv",header = TRUE)
d11<-read.csv("MPI-REMo_8.5_2071.csv",header = TRUE)
e11<-read.csv("MPI_8.5_2071.csv",header = TRUE)
f11<-read.csv("SMHI_8.5_2071.csv",header = TRUE)

future<-cbind(b[,1:3],a11[,3],b11[,3],c11[,3],d11[,3],e11[,3],f11[,3])
colnames(future)<-c("day",	"month",	"year","ACCESS1",	"CCSM4",	"CNRM",	"MPI-REMo",	"MPI",	"SMHI")


#write.csv(historical,"BhairabBazar_bias_corrected_historical.csv",row.names = FALSE)
write.csv(future,"BhairabBazar_bias_corrected_8.5_2071_2100.csv",row.names = FALSE)

file.remove("ACCESS1_historical.csv","CCSM4_historical.csv","CNRM_historical.csv","MPI-REMo_historical.csv","MPI_historical.csv","SMHI_historical.csv")
file.remove("ACCESS1_8.5_2071.csv","CCSM4_8.5_2071.csv","CNRM_8.5_2071.csv","MPI-REMo_8.5_2071.csv","MPI_8.5_2071.csv","SMHI_8.5_2071.csv")










