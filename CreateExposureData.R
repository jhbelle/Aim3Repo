## -------------
## Name: CreateExposureData.R
## Program version: R 3.3.3
## Dependencies:
## Author: J.H. Belle
## Purpose: Aggregate exposure data to single dataset - calculate cubic polynomials for weather parameters
## -------------

# Aggregated zip code file locations
AggregateFileLoc = "T:/eohprojs/CDC_climatechange/Jess/Dissertation/Paper3_Data/AggregatedValuesGA/"

# Set up timestepping
StartDate = as.Date("2003-01-01", "%Y-%m-%d")
EndDate = as.Date("2005-12-31", "%Y-%m-%d")
SeqDates = seq(StartDate, EndDate, by="day")

ListHolidays = c(as.Date("2003-01-01", "%Y-%m-%d"), as.Date("2003-01-20", "%Y-%m-%d"), as.Date("2003-02-17", "%Y-%m-%d"), as.Date("2003-05-26", "%Y-%m-%d"), as.Date("2003-07-04", "%Y-%m-%d"), as.Date("2003-09-01", "%Y-%m-%d"), as.Date("2003-10-13", "%Y-%m-%d"), as.Date("2003-11-11", "%Y-%m-%d"), as.Date("2003-11-27", "%Y-%m-%d"), as.Date("2003-12-25", "%Y-%m-%d"), as.Date("2004-01-01", "%Y-%m-%d"), as.Date("2004-01-19", "%Y-%m-%d"), as.Date("2004-02-16", "%Y-%m-%d"), as.Date("2004-05-31", "%Y-%m-%d"), as.Date("2004-07-05", "%Y-%m-%d"), as.Date("2004-09-06", "%Y-%m-%d"), as.Date("2004-10-11", "%Y-%m-%d"), as.Date("2004-11-11", "%Y-%m-%d"), as.Date("2004-11-25", "%Y-%m-%d"), as.Date("2004-12-24", "%Y-%m-%d"), as.Date("2004-12-31", "%Y-%m-%d"), as.Date("2005-01-17", "%Y-%m-%d"), as.Date("2005-02-21", "%Y-%m-%d"), as.Date("2005-05-30", "%Y-%m-%d"), as.Date("2005-07-04", "%Y-%m-%d"), as.Date("2005-09-05", "%Y-%m-%d"), as.Date("2005-10-10", "%Y-%m-%d"), as.Date("2005-11-11", "%Y-%m-%d"), as.Date("2005-11-24", "%Y-%m-%d"), as.Date("2005-12-26", "%Y-%m-%d"))

# Timestep
for (day in seq_along(SeqDates)){
  # Pull date and date-based variables out
  Date = SeqDates[day]
  Year = as.numeric(as.character(Date, "%Y"))
  DOY = as.numeric(as.character(Date, "%j"))
  DOW = as.numeric(as.character(Date, "%u"))
  Month = as.numeric(as.character(Date, "%m"))
  WarmSeason = ifelse(Month >= 5 & Month <= 10, 1, 0)
  Holiday = ifelse(Date %in% ListHolidays, 1, 0)
  Lag1Holiday = ifelse((Date - 1) %in% ListHolidays, 1, 0)
  Lag2Holiday = ifelse((Date - 2) %in% ListHolidays, 1, 0)
  LagHoliday = ifelse(Lag1Holiday == 1 | Lag2Holiday == 1, 1, 0)
  DaysDat = try(read.csv(sprintf("%sAggregatedPredictions_%d%03d.csv", AggregateFileLoc, Year, DOY)))
  if (is.data.frame(DaysDat)){
    DaysDat= DaysDat[,c("ZipCode", "UnGapFill", "CloudGapFill", "NoCldGapFill", "TempC", "RHday", "IndicatorCloud")]
    DaysDat$Year = rep(Year, nrow(DaysDat))
    DaysDat$DOY = rep(DOY, nrow(DaysDat))
    DaysDat$DOW = rep(DOW, nrow(DaysDat))
    DaysDat$Month = rep(Month, nrow(DaysDat))
    DaysDat$WarmSeason = rep(WarmSeason, nrow(DaysDat))
    DaysDat$Holiday = rep(Holiday, nrow(DaysDat))
    DaysDat$LagHoliday = rep(LagHoliday, nrow(DaysDat))
    DaysDat$TempCsqared = DaysDat$TempC^2
    DaysDat$TempCcubed = DaysDat$TempC^3
    DaysDat$RHsquared = DaysDat$RHday^2
    DaysDat$RHcubed = DaysDat$RHday^3
    if (day > 2){
      DaysDat = merge(DaysDat, Lag1Dat, by="ZipCode", all=T, suffixes=c("", ".Lag1"))
      DaysDat = merge(DaysDat, Lag2Dat, by="ZipCode", all=T, suffixes=c("", ".Lag2"))
      Lag2Dat = Lag1Dat[,c("ZipCode", "UnGapFill", "CloudGapFill", "NoCldGapFill")]
      Lag1Dat = DaysDat[,c("ZipCode", "UnGapFill", "CloudGapFill", "NoCldGapFill")]
      AllDat = rbind.data.frame(AllDat, DaysDat)
    } else if (day == 2){
      DaysDat = merge(DaysDat, Lag1Dat, by="ZipCode", all=T, suffixes=c("", ".Lag1"))
      DaysDat$UnGapFill.Lag2 = rep(NA, nrow(DaysDat))
      DaysDat$CloudGapFill.Lag2 = rep(NA, nrow(DaysDat))
      DaysDat$NoCldGapFill.Lag2 = rep(NA, nrow(DaysDat))
      Lag2Dat = Lag1Dat[,c("ZipCode", "UnGapFill", "CloudGapFill", "NoCldGapFill")]
      Lag1Dat = DaysDat[,c("ZipCode", "UnGapFill", "CloudGapFill", "NoCldGapFill")]
      AllDat= rbind.data.frame(AllDat, DaysDat)
    } else if (day == 1){
      DaysDat$UnGapFill.Lag1 = rep(NA, nrow(DaysDat))
      DaysDat$CloudGapFill.Lag1 = rep(NA, nrow(DaysDat))
      DaysDat$NoCldGapFill.Lag1 = rep(NA, nrow(DaysDat))
      DaysDat$UnGapFill.Lag2 = rep(NA, nrow(DaysDat))
      DaysDat$CloudGapFill.Lag2 = rep(NA, nrow(DaysDat))
      DaysDat$NoCldGapFill.Lag2 = rep(NA, nrow(DaysDat))
      Lag1Dat = DaysDat[,c("ZipCode", "UnGapFill", "CloudGapFill", "NoCldGapFill")]
      AllDat = DaysDat
    }
  } else {
    Lag2Dat = Lag1Dat[,c("ZipCode", "UnGapFill", "CloudGapFill", "NoCldGapFill")]
    Lag1Dat = Lag1Dat[1,c("ZipCode", "UnGapFill", "CloudGapFill", "NoCldGapFill")]
    Lag1Dat$ZipCode[1] <- NA
  }
}

AllDat = subset(AllDat, !is.na(AllDat$ZipCode))
AllDat$UnGapFillSummedLags012 = rowSums(AllDat[,c("UnGapFill", "UnGapFill.Lag1", "UnGapFill.Lag2")], na.rm=T)
AllDat$CloudGapFillSummedLags012 = rowSums(AllDat[,c("CloudGapFill", "CloudGapFill.Lag1", "CloudGapFill.Lag2")], na.rm=T)
AllDat$NoCldGapFillSummedLags012 = rowSums(AllDat[,c("NoCldGapFill", "NoCldGapFill.Lag1", "NoCldGapFill.Lag2")], na.rm=T)
AllDat$Date = as.Date(sprintf("%d-%03d", AllDat$Year, AllDat$DOY), "%Y-%j")
write.csv(AllDat, "T:/eohprojs/SCAPE/Project 3/Analysis/Georgia Satellite ED visits/Jess dissertation/AggregatedExposureData.csv", row.names = F, na=".")

AllDat = read.csv("T:/eohprojs/SCAPE/Project 3/Analysis/Georgia Satellite ED visits/Jess dissertation/AggregatedExposureData.csv", stringsAsFactors = F, na.strings = ".")
# Calculate aggregate statistics - 
UnGapFill = aggregate(UnGapFill ~ ZipCode, AllDat, mean, na.rm=T)
CloudGapFill = aggregate(CloudGapFill ~ ZipCode, AllDat, mean, na.rm=T)
NoCloudGapFill = aggregate(NoCldGapFill ~ ZipCode, AllDat, mean, na.rm=T)
AllDat$Cloudy = ifelse(is.na(AllDat$UnGapFill), 1, 0)
Cloudy = aggregate(Cloudy ~ ZipCode, AllDat, max, na.rm=T)
GapFill = merge(CloudGapFill, NoCloudGapFill)
Preds = merge(GapFill, UnGapFill)
Preds = merge(Preds, Cloudy)
Preds$DiffGapFill = Preds$CloudGapFill - Preds$NoCldGapFill

write.csv(Preds, "T://eohprojs/SCAPE/Project 3/Analysis/Georgia Satellite ED visits/Jess dissertation/ExposureData_ZipCodesAgg.csv", row.names = F)

Preds = read.csv("T://eohprojs/SCAPE/Project 3/Analysis/Georgia Satellite ED visits/Jess dissertation/ExposureData_ZipCodesAgg.csv", stringsAsFactors = F)

ggplot(Preds) + geom_histogram(aes(CloudGapFill), fill="blue", alpha=0.5, bins=60) + geom_histogram(aes(NoCldGapFill), fill="gray", alpha=0.5, bins=60) + geom_histogram(aes(UnGapFill), fill="red", alpha=0.5, bins=60)

ZipCodes = readOGR("T:/eohprojs/SCAPE/Project 3/Analysis/Georgia Satellite ED visits/Jess dissertation/2010ZipCodes/tl_2010_13_zcta510/ZipCodesProj.shp", "ZipCodesProj", stringsAsFactors = F)
ZipCodes@data$ZipCode = as.numeric(ZipCodes@data$ZCTA5CE10)
ZipCodes@data = merge(ZipCodes@data, Preds, by="ZipCode")

plot(ZipCodes)
ZipCodes@data$CloudCut = cut(ZipCodes@data$CloudGapFill, c(-1, 8, 10, 12, 15, 25, 100))
ZipCodes@data$NoCloudCut = cut(ZipCodes@data$NoCldGapFill, c(-1, 8, 10, 12, 15, 25, 100))
ZipCodes@data$UnGapFillCut = cut(ZipCodes@data$UnGapFill, c(-1, 8, 10, 12, 15, 25, 100))
spplot(ZipCodes["CloudCut"], col.regions=brewer.pal(6, "BuPu"))
spplot(ZipCodes["NoCloudCut"], col.regions=brewer.pal(6, "BuPu"))
spplot(ZipCodes["UnGapFillCut"], col.regions=brewer.pal(6, "BuPu"))


spplot(ZipCodes["DiffGapFill"])
