## Coursera Exploratory Data Analysis - Course Project 2 ##
## title: plot5.R ##
## output: plot5.png ##
## author: Scott Robertson ##
## os: macOS 10.13.6 ##
## R version: 3.5.1 ##
## Required packages: dplyr, ggplot2 ##

## Pre-Processing: Install packages ##

if("dplyr" %in% rownames(installed.packages()) == FALSE){
      install.packages("dplyr")
}

if("ggplot2" %in% rownames(installed.packages()) == FALSE){
      install.packages("ggplot")
}

library(dplyr)
library(ggplot2)


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

baltimoreroad <- subset(NEI, NEI$fips == "24510" & type == "ON-ROAD" , select = fips:year)

baltimoreroadAggYear <- baltimoreroad %>% 
      group_by(year) %>% 
      summarise(Emissions = sum(Emissions))

# End of step message
message("Date read in, formatted and filterd for graphing")


## Step 3: Create graph

# Generate graph
ggplot(data = baltimoreroadAggYear, 
       aes(x = factor(year), y = Emissions/1000, fill = factor(year))) + 
      geom_bar(stat = "identity") + 
      geom_label(aes(label = round(Emissions/1000,2), fill = factor(year)), color = "white", fontface = "bold") +
      labs(y = expression('Total PM'[2.5]*' emission in kilotons'),
           x = "Year",
           title = expression('Total PM'[2.5]*' emission in Baltimore from On-Road Sources'))

# Save graph to png file
ggsave("plot5.png", device = "png")

# End of step message
message("Graph generated and saved to working directory as plot5.png")
