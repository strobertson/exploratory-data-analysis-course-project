## Coursera Exploratory Data Analysis - Course Project 2 ##
## title: plot1.R ##
## output: plot1.png ##
## author: Scott Robertson ##
## os: macOS 10.13.6 ##
## R version: 3.5.1 ##
## Required packages: dplyr, RColorBrewer ##

## Pre-Processing: Install packages ##

if("dplyr" %in% rownames(installed.packages()) == FALSE){
      install.packages("dplyr")
}

if("RColorBrewer" %in% rownames(installed.packages()) == FALSE){
  install.packages("RColorBrewer")
}

library(dplyr)
library(RColorBrewer)

## Step 1: Download Data ##

# Create "data" folder within working directory to store information if not
# already avaliable
if (!file.exists("data")) {
      dir.create("data")
}

# Set URL to download files from
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"

# Check if download file exists in data folder. If not, download file, store 
# download date and unzip the files
if(!file.exists("./data/dataset.zip")) {
      download.file(fileUrl, "./data/dataset.zip", method = "curl")
      dateDownloaded <- date()
      unzip("./data/dataset.zip", exdir = "./data/")
}

# End of step message
message("Data downloaded and folders unzipped")


## Step 2: Reading raw data set into R and subsetting only required data ##

# Read in data sets
if(!exists("NEI")) {
   NEI <- readRDS("./data/summarySCC_PM25.rds")
}

if(!exists("SCC")) {
  SCC <- readRDS("./data/Source_Classification_Code.rds")
}

emissionAggYear <- aggregate(Emissions ~ year, data = NEI, FUN = sum)

# End of step message
message("Date read in, formatted and filterd for graphing")


## Step 3: Create graph

# Initalize png file
png(filename = "plot1.png")

# Generate graph
plot <- barplot(names = emissionAggYear$year,
        height = emissionAggYear$Emissions/1000, 
        col = brewer.pal(4, "Set1"),
        ylim = c(0, 8000),
        xlab = "Year",
        ylab = expression('Total PM'[2.5]*' emission in kilotons'),
        main=expression('Total PM'[2.5]*' emissions in 1999, 2002, 2005 and 2008 in kilotons')
        )

text(x = plot, 
     y = round(emissionAggYear$Emissions/1000,2), 
     label = round(emissionAggYear$Emissions/1000,2), 
     pos = 3, 
     cex = 0.8, 
     col = "black")

# Save graph to png file
dev.off()

# End of step message
message("Graph generated and saved to working directory as plot1.png")
