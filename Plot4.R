dev.off() #close device
rm(list = ls(all = TRUE)) #clear environment

#### get data
DataUrl<-file.path(getwd(),"household_power_consumption.txt")
library(data.table)

#### read data

#define data type in file
#forcing columns to numeric will produce N/A if '?' present
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

#make sure we got default settings for plotting
.pardefault <- par(no.readonly = T)

#To avid text problems plot straight to device
#lets first set device 

png(file = "plot4.png",width = 480, height = 480, units = "px")
dev.cur()


#Plot4
par(mfrow = c(2, 2), mar = c(4, 4, 2, 1), oma = c(0, 0, 2, 0))
with(Data, {
  #sub-plot 1
  plot(Data$DT,Data$Global_active_power, type = 'l', ylab = 'Global Active Power', xlab = '')
  #sub-plot 2
  plot(Data$DT,Data$Voltage, type = 'l', ylab = 'Voltage', xlab = 'Date')
  
{#sub-plot 3
    plot(Data$DT,Data$Sub_metering_1, type = 'l',  xlab ='',  ylab = 'Energy sub metering')
    lines(Data$DT,Data$Sub_metering_2, col='red')
    lines(Data$DT,Data$Sub_metering_3, col='blue')
    legend('topright',c('Sub_metering_1','Sub_metering_2','Sub_metering_3'),
           lty=c(1,1,1), #define lines for legend
           col=c('black','red','blue'), #define line colors
           bty = "n" #no border
    )} #sub-plot 3 ends

#sub-plot 4
plot(Data$DT,Data$Global_reactive_power, type = 'l', ylab = 'Global Reactive Power', xlab = 'Date')
})

dev.off() #close device
