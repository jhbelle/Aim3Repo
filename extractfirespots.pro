pro ExtractFireSpots, InputDir
  ; Takes as input a directory with MODIS fire spot data in it, and returns a text file containing the fire spots 
  ; Get list of files in directory
  FilesExtracting = FILE_SEARCH(InputDir, "*.hdf")
  ; Loop over files in directory
  FOREACH file, FilesExtracting DO BEGIN
    ; Open hdf file
    FID = HDF_SD_START(file, /READ)
    varIDlon = HDF_SD_SELECT(FID, 4)
    
  ENDFOREACH
end