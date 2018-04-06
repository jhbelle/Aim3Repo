pro procMaiac, FinGridJoined, yrint, startday, endday, fileloc, outloc, maiacString, LocTAFlag, LocTStamp
  ; Takes as input a file containing the columns and rows or indexes of maiac values from the tile that are inside the study area as extracted from the lat/lon files, the year and days of interest, and the file input and output locations, a string of maiac data to look for and the locations of the TA flag and time stamp in the filepath string 
  ; Produces a csv for each day containing all maiac data within the bounding box
  ; Open FinGridJoined with information needed later
  Dat = READ_CSV(FinGridJoined, HEADER=DatHead)
  Column=Dat.(WHERE(DatHead EQ 'row'))
  Row=Dat.(WHERE(DatHead EQ 'col'))
  ; Create list of days to loop over
  FOR day = startday, endday DO BEGIN
    f = FILE_SEARCH(STRING(fileloc + maiacString + STRING(FORMAT='(I04)', yrint) + STRING(FORMAT='(I03)', day) + "*.hdf"))
    FOREACH file, f DO BEGIN
      ; Open maiac file and extract AOD 47; AOD 55, and the AOD QA field
      FID = EOS_GD_OPEN(file)
      gridID = EOS_GD_ATTACH(FID, "grid1km")
      stat1 = EOS_GD_READFIELD(gridID, "Optical_Depth_047", AOD47)
      stat2 = EOS_GD_READFIELD(gridID, "Optical_Depth_055", AOD55)
      stat3 = EOS_GD_READFIELD(gridID, "AOT_QA", AODQA)
      IF (stat1 EQ 0) AND (stat2 EQ 0) AND (stat3 EQ 0) THEN BEGIN
        ; Get only values that are in the study area. Leaving AOD unscaled and the QA codes unconverted to binary
        AOD47 = AOD47[Column, Row]
        AOD55 = AOD55[Column, Row]
        AODQA = AODQA[Column, Row]
        ; Get Time stamp and terra aqua flag fields
        TerraAquaFlag = STRMID(file, LocTAFlag, 1)
        TStamp = STRMID(file, LocTStamp, 4)
	; Open file to append to later
  	OPENW, 1, outloc + 'MAIACdat_' + STRING(FORMAT='(I04)', yrint) + STRING(FORMAT='(I03)', day) + '_' + TStamp + '.csv'
  	PRINTF, 1, "InputFID, row, col, lat, lon, Year, Date, Timestamp, Overpass, AOD47, AOD55, QA"
        FOR J = 0, N_ELEMENTS(AODQA)-1 DO BEGIN
          PRINTF, 1, Dat.(WHERE(DatHead EQ "Input_FID"))[J], Dat.(WHERE(DatHead EQ "row"))[J], Dat.(WHERE(DatHead EQ "col"))[J], Dat.(WHERE(DatHead EQ "lat"))[J], Dat.(WHERE(DatHead EQ "lon"))[J], yrint, day, TStamp, TerraAquaFlag, AOD47[J], AOD55[J], AODQA[J], FORMAT='(I10, 4(", ", D), 2(", ", I5), 2(", ", A15), 3(", ", I15))'
        ENDFOR
        CLOSE, 1
      ENDIF
      ; Close the maiac file
      stat3 = EOS_GD_DETACH(gridID)
      stat4 = EOS_GD_CLOSE(FID)
    ENDFOREACH
  ENDFOR
end
