## -------------
## Funcions_IDW.R
## Function file for IDW_COD.R
## -------------

idw.interp <- function(xo, yo, zo, xn, yn, nmax = 4, maxdist = Inf, projold, projnew) {
  # Require tools
  require(gstat)
  require(sp)
  require(akima)
  require(rgdal)
  
  old <- data.frame(x = xo, y = yo, z = zo, stringsAsFactors = F)
  new <- data.frame(x = xn, y = yn, stringsAsFactors = F)
  
  # Produce the coordinates
  coordinates(old) <- ~x + y
  coordinates(new) <- ~x + y
  #gridded(new) <- T
  # Project new to same projection as old
  proj4string(old) <- CRS(projold)
  proj4string(new) <- CRS(projnew)
  oldproj = spTransform(old, CRS(projnew))
  
  # Do the inverse distance weighted interpolation
  zn <- idw(formula = z ~ 1, locations = oldproj, newdata = new, nmax = nmax, maxdist = maxdist)
  zn <- as.data.frame(zn)
  
  # Post-processing of idw
  zn$var1.var <- NULL
  
  return(zn)
  
}
