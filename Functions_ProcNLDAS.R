### ------------
## Function file for Proc NLDAS.R
### ------------

## -----
# Function 1: GetField - Gets a field's worth of data from a netcdf, formatted as a data frame and returns it
## -----

GetField <- function(ncdat, latvec, lonvec, varname){
  require(ncdf4)
  field <- ncvar_get(ncdat, varname)
  dimnames(field) <- list(lonvec, latvec)
  field_df <- as.data.frame(as.table(field))
  return(field_df)
}