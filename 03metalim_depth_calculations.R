### Load packages
library(rLakeAnalyzer)
library(dplyr)

### Load data
setwd("C:\\Users\\adminuser\\Desktop\\EVERYTHING THOMAS\\MOECC Alagae project\\Lake Physics")
dat <- read.csv("tempDO_profiles.csv")
names(dat)
dat <- dat[, 1:8] # left out the dissolved oxygen column because it had a lot of NAs
dat <- na.omit(dat) # omit rows with missing temperature and depth values


### Using the "meta.depths" function in rLakeAnalyzer to create a simple function with set parameters
meta <- function (x) {
  meta.depths(x$TEMPERATURE, x$DEPTH, slope=0.1, seasonal=FALSE)
}

test <- dat[1:21,] ### These rows represent 1 sampling period
meta(test)
### Top of metalimnion = 7.017519m
### Bottom of metalimnion = 7.750571m


### Note 1: I create these new variables for individual lakes because some had data inputted incorrectly and it was easier to fix when working lake by lake

### Note 2: The reason I calculated metalimnion depths for August was because it is the only month each year that has data for all years for each lake. Other months range from missing one to several years of data in each lake

### Note 3: As I ran through each lake, I found a data entry mistake in Harp Lake. Steps on how to fix it are included

### Note 4: Heney Lake is extremely shallow, and consequently, produces a lot of NAs; presumably because the "meta" function cannot find the metalimnion


## BLUE CHALK LAKE
BC <- dat[dat$LAKE_NAME=="Blue_Chalk", 1:8]
BC8 <- filter(BC, MONTH == 8)
df1 <- data.frame()

sampling.BC <- unique(BC8$SAMPLE_DATE)

### Create a loop that uses the "meta" function to calculate the depth of the top and bottom of the metalimnion for each unique sampling date
for (i in sampling.BC) {
  m <- meta(BC8[BC8$SAMPLE_DATE==i, 4:5])
  outputs <- data.frame(sample_date=i, m)
  df1 <- rbind(df1,outputs)
}

#### If you look at "df1" after running the loop you'll see that top and bottom metalimnion depths are stacked on top of each other in a single column.The following code separates the top and bottom metalimnion depths and puts them in separate columns
df.new1 = df1[seq(1, nrow(df1), 2), ]
df.new2 = df1[seq(2, nrow(df1), 2), ]

df.BC <- data.frame(df.new1, df.new2)
df.BC <- df.BC[, -c(3), drop=FALSE]
colnames(df.BC)[2] <- "Top_metalimnion"
colnames(df.BC)[3] <- "Bottom_metalimnion"

df.BC$Lake_Name <- c("Blue Chalk")
df.BC<-df.BC[, c(4,1:3)]
head(df.BC)


##CHUB LAKE
CB <- dat[dat$LAKE_NAME=="Chub", 1:8]
CB8 <- filter(CB, MONTH == 8)
df.CB8 <- data.frame()

sampling.CB <- unique(CB8$SAMPLE_DATE)
for (i in sampling.CB) {
  m1 <- meta(CB8[CB8$SAMPLE_DATE==i, 4:5])
  outputs <- data.frame(sample_date=i, m1)
  df.CB8 <- rbind(df.CB8,outputs)
}

df.CB8.new1 = df.CB8[seq(1, nrow(df.CB8), 2), ]
df.CB8.new2 = df.CB8[seq(2, nrow(df.CB8), 2), ]

df.CB <- data.frame(df.CB8.new1, df.CB8.new2)
df.CB <- df.CB[, -c(3), drop=FALSE]
colnames(df.CB)[2] <- "Top_metalimnion"
colnames(df.CB)[3] <- "Bottom_metalimnion"

df.CB$Lake_Name <- c("Chub")
df.CB<-df.CB[, c(4,1:3)]
head(df.CB)


##CROSSON LAKE
CN <- dat[dat$LAKE_NAME=="Crosson", 1:8]
CN8 <- filter(CN, MONTH == 8)
df.CN8 <- data.frame()

sampling.CN <- unique(CN8$SAMPLE_DATE)
for (i in sampling.CN) {
  m1 <- meta(CN8[CN8$SAMPLE_DATE==i, 4:5])
  outputs <- data.frame(sample_date=i, m1)
  df.CN8 <- rbind(df.CN8,outputs)
}

df.CN8.new1 = df.CN8[seq(1, nrow(df.CN8), 2), ]
df.CN8.new2 = df.CN8[seq(2, nrow(df.CN8), 2), ]

df.CN <- data.frame(df.CN8.new1, df.CN8.new2)
df.CN <- df.CN[, -c(3), drop=FALSE]
colnames(df.CN)[2] <- "Top_metalimnion"
colnames(df.CN)[3] <- "Bottom_metalimnion"

df.CN$Lake_Name <- c("Crosson")
df.CN<-df.CN[, c(4,1:3)]
head(df.CN)


##DICKIE LAKE
DE <- dat[dat$LAKE_NAME=="Dickie", 1:8]
DE8 <- filter(DE, MONTH == 8)
df.DE8 <- data.frame()

sampling.DE <- unique(DE8$SAMPLE_DATE)
for (i in sampling.DE) {
  m1 <- meta(DE8[DE8$SAMPLE_DATE==i, 4:5])
  outputs <- data.frame(sample_date=i, m1)
  df.DE8 <- rbind(df.DE8,outputs)
}

df.DE8.new1 = df.DE8[seq(1, nrow(df.DE8), 2), ]
df.DE8.new2 = df.DE8[seq(2, nrow(df.DE8), 2), ]

df.DE <- data.frame(df.DE8.new1, df.DE8.new2)
df.DE <- df.DE[, -c(3), drop=FALSE]
colnames(df.DE)[2] <- "Top_metalimnion"
colnames(df.DE)[3] <- "Bottom_metalimnion"

df.DE$Lake_Name <- c("Dickie")
df.DE<-df.DE[, c(4,1:3)]
head(df.DE)


##HARP LAKE
HP <- dat[dat$LAKE_NAME=="Harp", 1:8]
HP8 <- filter(HP, MONTH == 8)
df.HP8 <- data.frame()

### Stop here... this lake had data inputted incorrectly somewhere. I added the column "diff" which is each depth value minus the previous depth value
HP8$diff <- ave(HP8$DEPTH, HP8$LAKE_NAME, FUN=function(x) c(0, diff(x))) # create "diff"
HP8_error <- HP8[order(HP8$diff),] # Sort by "diff"
HP8_error[1:75,] # Found a 0 in row 945, which means it was a duplicate
HP8[942:947, ] # row 944 and 945 are duplicates
### The 27m "DEPTH" profile was duplicated in row 945. This will cause the "meta" function to error out

### Recreate the original dataframe with the duplicate row and the "diff" column removed
HP8 <- HP8[-c(945),]
HP8 <- subset(HP8, select = -c(diff))
HP8[942:947, ] # making sure it's gone

### The looped "meta" function should work now that the duplicate depth is removed
sampling.HP <- unique(HP8$SAMPLE_DATE)
for (i in sampling.HP) {
  m1 <- meta(HP8[HP8$SAMPLE_DATE==i, 4:5])
  outputs <- data.frame(sample_date=i, m1)
  df.HP8 <- rbind(df.HP8,outputs)
}

df.HP8.new1 = df.HP8[seq(1, nrow(df.HP8), 2), ]
df.HP8.new2 = df.HP8[seq(2, nrow(df.HP8), 2), ]

df.HP <- data.frame(df.HP8.new1, df.HP8.new2)
df.HP <- df.HP[, -c(3), drop=FALSE]
colnames(df.HP)[2] <- "Top_metalimnion"
colnames(df.HP)[3] <- "Bottom_metalimnion"

df.HP$Lake_Name <- c("Harp")
df.HP<-df.HP[, c(4,1:3)]
head(df.HP)


##HENEY LAKE
HY <- dat[dat$LAKE_NAME=="Heney", 1:8]
HY8 <- filter(HY, MONTH == 8)
df.HY8 <- data.frame()

sampling.HY <- unique(HY8$SAMPLE_DATE)
for (i in sampling.HY) {
  m1 <- meta(HY8[HY8$SAMPLE_DATE==i, 4:5])
  outputs <- data.frame(sample_date=i, m1)
  df.HY8 <- rbind(df.HY8,outputs)
}

df.HY8.new1 = df.HY8[seq(1, nrow(df.HY8), 2), ]
df.HY8.new2 = df.HY8[seq(2, nrow(df.HY8), 2), ]

df.HY <- data.frame(df.HY8.new1, df.HY8.new2)
df.HY <- df.HY[, -c(3), drop=FALSE]
colnames(df.HY)[2] <- "Top_metalimnion"
colnames(df.HY)[3] <- "Bottom_metalimnion"

df.HY$Lake_Name <- c("Heney")
df.HY<-df.HY[, c(4,1:3)]
head(df.HY)


##PLASTIC LAKE
PC <- dat[dat$LAKE_NAME=="Plastic", 1:8]
PC8 <- filter(PC, MONTH == 8)
df.PC8 <- data.frame()

sampling.PC <- unique(PC8$SAMPLE_DATE)
for (i in sampling.PC) {
  m1 <- meta(PC8[PC8$SAMPLE_DATE==i, 4:5])
  outputs <- data.frame(sample_date=i, m1)
  df.PC8 <- rbind(df.PC8,outputs)
}

df.PC8.new1 = df.PC8[seq(1, nrow(df.PC8), 2), ]
df.PC8.new2 = df.PC8[seq(2, nrow(df.PC8), 2), ]

df.PC <- data.frame(df.PC8.new1, df.PC8.new2)
df.PC <- df.PC[, -c(3), drop=FALSE]
colnames(df.PC)[2] <- "Top_metalimnion"
colnames(df.PC)[3] <- "Bottom_metalimnion"

df.PC$Lake_Name <- c("Plastic")
df.PC<-df.PC[, c(4,1:3)]
head(df.PC)


##RED CHALK LAKE EAST
RE <- dat[dat$LAKE_NAME=="Red_Chalk_E", 1:8]
RE8 <- filter(RE, MONTH == 8)
df.RE8 <- data.frame()

sampling.RE <- unique(RE8$SAMPLE_DATE)
for (i in sampling.RE) {
  m1 <- meta(RE8[RE8$SAMPLE_DATE==i, 4:5])
  outputs <- data.frame(sample_date=i, m1)
  df.RE8 <- rbind(df.RE8,outputs)
}

df.RE8.new1 = df.RE8[seq(1, nrow(df.RE8), 2), ]
df.RE8.new2 = df.RE8[seq(2, nrow(df.RE8), 2), ]

df.RE <- data.frame(df.RE8.new1, df.RE8.new2)
df.RE <- df.RE[, -c(3), drop=FALSE]
colnames(df.RE)[2] <- "Top_metalimnion"
colnames(df.RE)[3] <- "Bottom_metalimnion"

df.RE$Lake_Name <- c("Red Chalk East")
df.RE<-df.RE[, c(4,1:3)]
head(df.RE)


##RED CHALK LAKE MAIN
RM <- dat[dat$LAKE_NAME=="Red_Chalk_M", 1:8]
RM8 <- filter(RM, MONTH == 8)
df.RM8 <- data.frame()

sampling.RM <- unique(RM8$SAMPLE_DATE)
for (i in sampling.RM) {
  m1 <- meta(RM8[RM8$SAMPLE_DATE==i, 4:5])
  outputs <- data.frame(sample_date=i, m1)
  df.RM8 <- rbind(df.RM8,outputs)
}

df.RM8.new1 = df.RM8[seq(1, nrow(df.RM8), 2), ]
df.RM8.new2 = df.RM8[seq(2, nrow(df.RM8), 2), ]

df.RM <- data.frame(df.RM8.new1, df.RM8.new2)
df.RM <- df.RM[, -c(3), drop=FALSE]
colnames(df.RM)[2] <- "Top_metalimnion"
colnames(df.RM)[3] <- "Bottom_metalimnion"

df.RM$Lake_Name <- c("Red Chalk Main")
df.RM<-df.RM[, c(4,1:3)]
head(df.RM)

### Export data
all.lakes <- rbind(df.BC,df.CB,df.CN,df.DE,df.HP,df.HY,df.PC,df.RE,df.RM) # stack rows
rownames(all.lakes) <- c() # Just resetting the column of row names
write.csv(all.lakes, "Aug_meta_depths.csv") # Write outputs to a CSV