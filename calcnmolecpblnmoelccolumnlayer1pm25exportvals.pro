pro CalcNMolecPBLNMoelcColumnLayer1PM25ExportVals
; This calculates the number of molecules of sulfate and nitrate within the PBL, 
; the number of molecules of sulfate and nitrate over the entire column,
; and PM2.5 concentrations in the first layer.
; These values are then exported as a csv file along with the lat long values.
; This is done for each time step in the years 2003, 2004, and 2005,
; and for the region: [[37.6, -88.2, -78.2, 27.8].

FOR tau = 186002.00, 192840.00, 2 DO BEGIN
  Date = TAU2YYMMDD(tau)
  IF (Date.HOUR LT 21) AND (Date.HOUR GT 12) THEN BEGIN
    Filename = '/terra/2006/ts' + STRING(Date.YEAR, FORMAT='(I4)') + STRING(Date.MONTH, FORMAT='(I02)') + STRING(Date.DAY, FORMAT='(I02)') + '.bpch'  
  
; ------------
; Calculate number of sulfate molecules in column
; ------------
    CTM_GET_DATA, Sulfate, 'IJ-AVG-$', FILENAME=Filename, TRACER=27, TAU0=tau
    CTM_GET_DATA, AirDensity, 'TIME-SER', FILENAME=Filename, TRACER=19007, TAU0=tau
    CTM_GET_DATA, BoxHeight, 'BXHGHT-$', FILENAME=Filename, TRACER=24001, TAU0=tau
    XYZSulf = (*(Sulfate.DATA))*(*(AirDensity.DATA))*(*(BoxHeight.DATA))/1000000000
    XYZSulf_Col = TOTAL(XYZSulf, 3)
  
; -----------
; Calculate number of nitrate molecules within column
; -----------
    CTM_GET_DATA, Nitrate, 'IJ-AVG-$', FILENAME=Filename, TRACER=32, TAU0=tau
    XYZNit = (*(Nitrate.DATA))*(*(AirDensity.DATA))*(*(BoxHeight.DATA))/1000000000
    XYZNit_Col = TOTAL(XYZNit, 3)
  
; -----------
; Calculate number of sulfate and nitrate molecules within PBL
; -----------
    SulfMolecPBL = MAKE_ARRAY(144, 91)
    NitMolecPBL = MAKE_ARRAY(144, 91)
    CTM_GET_DATA, PBLheight, 'PBLDEPTH', FILENAME=Filename, TRACER=27002, TAU0=tau
    PBLheight2 = *(PBLheight.DATA)
    FOR row = 0, 143 DO BEGIN
      FOR column = 0, 90 DO BEGIN
        SulfMolecPBL[row, column] = TOTAL(XYZSulf[row, column, 0:FLOOR(PBLheight2[row, column]-1)])
        NitMolecPBL[row, column] = TOTAL(XYZNit[row, column, 0:FLOOR(PBLheight2[row, column] - 1)])
      ENDFOR
    ENDFOR
; ----------
; Calculate ratios of sulfate and nitrate within PBL to total column
; ----------

    RatioXYZ_Sulf = SulfMolecPBL/XYZSulf_Col
    RatioXYZ_Nit = NitMolecPBL/XYZNit_Col
  
; -----------
; Calculate PM2.5 concentrations in the first layer
; -----------
    NIT = *(Nitrate.DATA)
    SO4 = *(Sulfate.DATA)
    CTM_GET_DATA, Ammonium, 'IJ-AVG-$', FILENAME=Filename, TRACER=31, TAU0=tau
    NH4 = *(Ammonium.DATA)
    CTM_GET_DATA, BCPI, 'IJ-AVG-$', FILENAME=Filename, TRACER=34, TAU0=tau
    BCPI2 = *(BCPI.DATA)
    CTM_GET_DATA, OCPI, 'IJ-AVG-$', FILENAME=Filename, TRACER=35, TAU0=tau
    OCPI2 = *(OCPI.DATA)
    CTM_GET_DATA, BCPO, 'IJ-AVG-$', FILENAME=Filename, TRACER=36, TAU0=tau
    BCPO2 = *(BCPO.DATA)
    CTM_GET_DATA, OCPO, 'IJ-AVG-$', FILENAME=Filename, TRACER=37, TAU0=tau
    OCPO2 = *(OCPO.DATA)
    CTM_GET_DATA, DST1, 'IJ-AVG-$', FILENAME=Filename, TRACER=38, TAU0=tau
    DST1_2 = *(DST1.DATA)
    CTM_GET_DATA, DST2, 'IJ-AVG-$', FILENAME=Filename, TRACER=39, TAU0=tau
    DST2_2 = *(DST2.DATA)
    CTM_GET_DATA, SALA, 'IJ-AVG-$', FILENAME=Filename, TRACER=42, TAU0=tau
    SALA2 = *(SALA.DATA)
    CTM_GET_DATA, TSOA1, 'IJ-AVG-$', FILENAME=Filename, TRACER=76, TAU0=tau
    TSOA1_2 = *(TSOA1.DATA)
    CTM_GET_DATA, TSOA2, 'IJ-AVG-$', FILENAME=Filename, TRACER=77, TAU0=tau
    TSOA2_2 = *(TSOA2.DATA)
    CTM_GET_DATA, TSOA3, 'IJ-AVG-$', FILENAME=Filename, TRACER=78, TAU0=tau
    TSOA3_2 = *(TSOA3.DATA)
    CTM_GET_DATA, TSOA0, 'IJ-AVG-$', FILENAME=Filename, TRACER=79, TAU0=tau
    TSOA0_2 = *(TSOA0.DATA)
    CTM_GET_DATA, ISOA1, 'IJ-AVG-$', FILENAME=Filename, TRACER=83, TAU0=tau
    ISOA1_2 = *(ISOA1.DATA)
    CTM_GET_DATA, ISOA2, 'IJ-AVG-$', FILENAME=Filename, TRACER=84, TAU0=tau
    ISOA2_2 = *(ISOA2.DATA)
    CTM_GET_DATA, ISOA3, 'IJ-AVG-$', FILENAME=Filename, TRACER=85, TAU0=tau
    ISOA3_2 = *(ISOA3.DATA)
    CTM_GET_DATA, ASOA1, 'IJ-AVG-$', FILENAME=Filename, TRACER=93, TAU0=tau
    ASOA1_2 = *(ASOA1.DATA)
    CTM_GET_DATA, ASOA2, 'IJ-AVG-$', FILENAME=Filename, TRACER=94, TAU0=tau
    ASOA2_2 = *(ASOA2.DATA)
    CTM_GET_DATA, ASOA3, 'IJ-AVG-$', FILENAME=Filename, TRACER=95, TAU0=tau
    ASOA3_2 = *(ASOA3.DATA)
    CTM_GET_DATA, ASOAN, 'IJ-AVG-$', FILENAME=Filename, TRACER=92, TAU0=tau
    ASOAN_2 = *(ASOAN.DATA)
  
    AirDens2 = *(AirDensity.DATA)
    AirDens3 = AirDens2[*,*,0]
  
    NH4_ConcMgM3 = ((NH4[*,*,0])*(AirDens3)*18)/(6.22*10*(1e19))
    NIT_ConcMgM3 = (NIT[*,*,0]*AirDens3*62)/(6.22*10*(1e19))
    SO4_ConcMgM3 = (SO4[*,*,0]*AirDens3*96)/(6.22*10*(1e19))
    BCPI_ConcMgM3 = (BCPI2[*,*,0]*AirDens3*12)/(6.22*10*(1e19))
    OCPI_ConcMgM3 = (OCPI2[*,*,0]*AirDens3*12)/(6.22*10*(1e19))
    BCPO_ConcMgM3 = (BCPO2[*,*,0]*AirDens3*12)/(6.22*10*(1e19))
    OCPO_ConcMgM3 = (OCPO2[*,*,0]*AirDens3*12)/(6.22*10*(1e19))
    DST1_ConcMgM3 = (DST1_2[*,*,0]*AirDens3*29)/(6.22*10*(1e19))
    DST2_ConcMgM3 = (DST2_2[*,*,0]*AirDens3*29)/(6.22*10*(1e19))
    SALA_ConcMgM3 = (SALA2[*,*,0]*AirDens3*31.4)/(6.22*10*(1e19))
  ; Calculate SOA concentrations
    SOA = TSOA1_2[*,*,1] + TSOA2_2[*,*,0] + TSOA3_2[*,*,0] + TSOA0_2[*,*,0] + ISOA1_2[*,*,0] + ISOA2_2[*,*,0] + ISOA3_2[*,*,0] + ASOA1_2[*,*,0] + ASOA2_2[*,*,0] + ASOA3_2[*,*,0] + ASOAN_2[*,*,0]
    SOA_ConcMgM3 = (SOA*AirDens3*150)/(6.22*10*(1e19))
  ; Calculate PM
    PM25 = 1.33*(NH4_ConcMgM3 + NIT_ConcMgM3 + SO4_ConcMgM3) + (BCPI_ConcMgM3 + BCPO_ConcMgM3) + 2.1*(1.16*OCPI_ConcMgM3 + OCPO_ConcMgM3) + DST1_ConcMgM3 + 0.38*DST2_ConcMgM3 + 1.86*SALA_ConcMgM3 + 1.16*(SOA_ConcMgM3)

; -----------
; Format outputs and export to csv
; -----------

    ExportPBLheight = REFORM(REFORM(PBLheight2, 144L*91L, 1))
    ExportRatioXYZSulf = REFORM(REFORM(RatioXYZ_Sulf, 144L*91L, 1))
    ExportRatioXYZNit = REFORM(REFORM(RatioXYZ_Nit, 144L*91L, 1))
    ExportPM25 = REFORM(REFORM(PM25, 144L*91L, 1))
  
    FileOut = '/terra/Jess_Merra2SOA_Outputs/' + STRING(Date.YEAR, FORMAT='(I4)') + '/tp' + STRING(Date.YEAR, FORMAT='(I4)') + STRING(Date.MONTH, FORMAT='(I02)') + STRING(Date.DAY, FORMAT='(I02)') + STRING(Date.HOUR, FORMAT='(I02)') + '.csv'
    head = ['PBLheight', 'RatioXYZSulf', 'RatioXYZNit' , 'PM25']
    WRITE_CSV, FileOut, ExportPBLheight, ExportRatioXYZSulf, ExportRatioXYZNit, ExportPM25, HEADER=head
  ENDIF
ENDFOR

end
