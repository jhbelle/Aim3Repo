## -----------
## Name: AddNARR.R
## Program Version: R 3.3.3
## Dependencies:
## Data: NARR Netcdf files; Combined output files
## Author: J.H. Belle
## Purpose: Add NARR fields to existing combined files
## -----------

# Libraries
library(ncdf4)


## ----
# Variables to set
## ----

Startday = 1
Endday = 365
Year = 2009

# Location of Combined files
CombLoc = "/terra/CombinedValues_Jess_GA_Aqua/"

RH = nc_open("/terra/Data/rhum.2m.2009.nc")
RH2 = ncvar_get(RH, "rhum")
time = ncvar_get(RH, "time")
Datetimes = as.POSIXlt(time*60*60, origin=as.POSIXlt("1800-01-01 00:00", "%Y-%m-%d %H:%M", tz="GMT"), tz="GMT")
lat = matrix(ncvar_get(RH, "lat"), ncol=1)
lon = matrix(ncvar_get(RH, "lon"), ncol=1)
# Export NARR lat/lon values for spatial join to MAIAC grid
#NARRLatLon = cbind.data.frame(lat, lon)
#write.csv(NARRLatLon, "T:/eohprojs/CDC_Climatechange/Jess/Dissertation/Paper3_Data/NARRlatlon.csv", row.names = F)
PBLh = nc_open("/terra/Data/hpbl.2009.nc")
hPBL = ncvar_get(PBLh, "hpbl")

# Read in matching between MAIAC and NARR grids
MAIACtoNARR = read.csv("/terra/Data/FinGrid/MAIACto_NEI2008_NARR_DistRds.csv", stringsAsFactors = F)[,c("Input_FID", "Count_", "NEAR_DIST", "lat", "lon")]
MAIACtoNARR$lat = round(MAIACtoNARR$lat, digits=5)
MAIACtoNARR$lon = round(MAIACtoNARR$lon, digits=5)

## ----
# Loop over days in year
## ----

for (i in Startday:Endday){
  # Read combined file
  CombFile = sprintf("%sCombMAIACCloudNLDASGC_Text_%d%03d_A.csv", CombLoc, Year, i)
  CombDat = try(read.csv(CombFile, stringsAsFactors = F))
  if (is.data.frame(CombDat)){
    # Pull timestamp of overpass and get matching timestamp for NARR
    Timestamp = strptime(sprintf("%d %03d %d", Year, i, round(mean(CombDat$Timestamp))), "%Y %j %H", tz="GMT")
    Timeslice = which.min(abs(Timestamp - Datetimes))
    # Pull RH and PBL height values
    RHday = matrix(RH2[,,Timeslice], ncol=1)
    PBLday = matrix(hPBL[,,Timeslice], ncol=1)
    # Get dataset for merging
    DatAdd = cbind.data.frame(lat, lon, RHday, PBLday)
    DatAdd$lat = round(DatAdd$lat, digits=5)
    DatAdd$lon = round(DatAdd$lon, digits=5)
    # Merge into CombDat
    DatAdd2 = merge(MAIACtoNARR, DatAdd, by=c("lat", "lon"))
    OutDat = merge(CombDat, DatAdd2, all.x=T, by="Input_FID")
    # Write new combined file to old location
    write.csv(OutDat, CombFile, row.names = F)
  }
}
