## Check if data has already been parsed and saved
if (!file.exists("clean-data.csv"))
{
    ## Check if data has been unzipped, or downloaded
    if (!file.exists("household_power_consumption.txt"))
    {
        if (!file.exists("exdata-data-household_power_consumption.zip")) 
        {
            download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", 
                          "exdata-data-household_power_consumption.zip",
                          method = "curl")
        }
        
        unzip("exdata-data-household_power_consumption.zip")
    }
    ## Read in data
    consumption <- read.table(file = "household_power_consumption.txt", 
                     sep = ";", header = TRUE, 
                     colClasses = c("factor", "factor", "numeric", 
                                    "numeric", "numeric", "numeric", 
                                    "numeric", "numeric", "numeric"), 
                     na.strings = "?")
    
    ## Subset to needed dates and fields
    consumption <- consumption[consumption$Date == "1/2/2007" | consumption$Date == "2/2/2007",c(0:5,7:9)]
    
    ## Format Date and time and collapse into one field
    consumption$Date <- as.POSIXct(paste(consumption$Date, consumption$Time), 
                            format="%d/%m/%Y %H:%M:%S")
    consumption <- consumption[,c(1,3:8)]
    
    ## Write to file to avoid parsing "household_power_consumption.txt"
    write.csv(consumption, "clean-data.csv")
    
}

if (!exists("consumption")) {
    consumption <- read.csv("clean-data.csv")
    consumption$Date <- as.POSIXct(consumption$Date)
}

png("plot1.png")
hist(consumption$Global_active_power, col = "red", 
     xlab = "Global Active Power (kilowatts)",
     main = "Global Active Power")
dev.off()

