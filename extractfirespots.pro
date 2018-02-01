pro ExtractFireSpots, InputDir, filestring, outfile
  ; Takes as input a directory with MODIS fire spot data in it, and returns a text file containing the fire spots 
  ; Create output dataset
  OPENW, 1, outfile
  PRINTF, 1, "DayTAflag, latfire, lonfire"
  CLOSE, 1
  ; Get list of files in directory
  FilesExtracting = FILE_SEARCH(InputDir, filestring)
  ; Loop over files in directory
  FOREACH file, FilesExtracting DO BEGIN
    ; Open hdf file
    FID = HDF_SD_START(file, /READ)
    ; Open hdf variables of interest
    varindexlat = HDF_SD_NameToIndex(FID, 'FP_latitude')
    varIDlat = HDF_SD_SELECT(FID, varindexlat)
    varindexlon = HDF_SD_NameToIndex(FID, 'FP_longitude')
    varIDlon = HDF_SD_SELECT(FID, varindexlon)
    ; Test if fires exist in this file
    HDF_SD_GetInfo, varIDlat, dims=dimvec
    IF (dimvec GT 0) THEN BEGIN
      ; Extract lat and lon of fire spots
      HDF_SD_GetData, varIDlat, lat
      HDF_SD_GetData, varIDlon, lon
      dayflag = STRSPLIT(file, '.', /EXTRACT)
      dayflag2 = dayflag[1]
      ; Open output data and export
      OPENU, 2, outfile, /APPEND
      FOR i = 0,dimvec-1 DO BEGIN
        PRINTF, 2, dayflag2, lat[i], lon[i], FORMAT='(A15, D, D)'
      ENDFOR
      CLOSE, 2
    ENDIF
    ; Close hdf data
    HDF_SD_ENDACCESS, varIDlat
    HDF_SD_ENDACCESS, varIDlon
    HDF_SD_END, FID
  ENDFOREACH
end
