## -------------
## Name: ProcNLDAS.R
## Program version: R 3.3.3
## Dependencies:
## Author: J.H. Belle
## Purpose: Process combine maiac files with netcdf of meteorological data
## -------------

testfile = "T:/eohprojs/CDC_climatechange/Jess/Dissertation/TestingNLDAS/NLDAS_FORA0125_H.A20030101.0000.002.grb.nc"
test = nc_open(testfile)

Lat = ncvar_get(test, "lat")
Long = ncvar_get(test, "lon")

Temp2m = GetField(test, latvec=Lat, lonvec = Long, varname = "var11")
colnames(Temp2m) = c("Lonchar", "Latchar", "Temp2m")
Temp2m$Long = as.numeric(Temp2m$Lonchar)
Temp2m$Lat = as.numeric(Temp2m$Latchar)
write.csv(Temp2m, "T:/eohprojs/CDC_climatechange/Jess/Dissertation/Paper3_StudyDefs/NLDASGrid.csv")
