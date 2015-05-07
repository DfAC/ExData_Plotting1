rm(list = ls(all = TRUE)) #clear environment

#Plot3

plot(Data$DT,Data$Sub_metering_1, type = 'l',  xlab ='',  ylab = 'Energy sub metering')
lines(Data$DT,Data$Sub_metering_2, col='red')
lines(Data$DT,Data$Sub_metering_3, col='blue')
legend('topright',c('Sub_metering_1','Sub_metering_2','Sub_metering_3'),
       lty=c(1,1,1), #define lines for legend
       col=c('black','red','blue') #define line colors
)
#plot to file
dev.copy(png,file = "plot3.png",width = 980, height = 980, units = "px", pointsize = 15)
dev.off() #close device
DataUrl<-file.path(getwd(),"household_power_consumption.txt")
library(data.table)


#### read data

#define data type in file
#forcing colums to numeric will produce N/A if '?' present
DataClasses<-c('character','character','numeric','numeric','numeric','numeric','numeric','numeric','numeric')

#read data
Data<-fread(DataUrl,header = F,skip="1/2/2007", nrows = 2880,colClass=DataClasses)

#set names for columns
setnames(Data,1:9,c('Date','Time','Global_active_power','Global_reactive_power','Voltage','Global_intensity','Sub_metering_1','Sub_metering_2','Sub_metering_3'))
names(Data)

#remove any records with N/A
Data<-Data[complete.cases(Data)]

#create proper time&date
Data$DT<-as.POSIXct(paste(Data$Date, Data$Time), format="%d/%m/%Y %H:%M:%S")
#can strip columns 1&2 as wellnow
Data[,c("Date","Time")]<-list(NULL)


###Plotting
#Plot3

plot(Data$DT,Data$Sub_metering_1, type = 'l',  xlab ='',  ylab = 'Energy sub metering')
lines(Data$DT,Data$Sub_metering_2, col='red')
lines(Data$DT,Data$Sub_metering_3, col='blue')
legend('topright',c('Sub_metering_1','Sub_metering_2','Sub_metering_3'),
       lty=c(1,1,1), #define lines for legend
       col=c('black','red','blue') #define line colors
)
#plot to file
dev.copy(png,file = "plot3.png",width = 480, height = 480, units = "px", pointsize = 15)
dev.off() #close device