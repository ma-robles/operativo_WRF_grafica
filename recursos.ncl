
load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/cd_string.ncl"


;-----------------------------------
; Funcion para generar la hora local
;-----------------------------------

undef("hora_local")

function hora_local(time)

local time

begin
   
    DOUBLE_QUOTE = integertochar(34)

    oacute  = "o~H-13V2F35~B~FV-2H3~"
    
    dtstr     = "TZ="+DOUBLE_QUOTE+"America/Mexico_City"+DOUBLE_QUOTE+" "+ time + " UTC"
    cmd       = "date --date='" + dtstr + "' " + DOUBLE_QUOTE + "+%d/%m/%Y %H:%M %Z" + DOUBLE_QUOTE
    datetime  = systemfunc(cmd)
    
    fecha = stringtochar(datetime)
  
    dia_l  = chartostring(fecha(0:1))
    mes_l  = chartostring(fecha(3:4))
    anio_l = chartostring(fecha(8:9))
    hora_l = chartostring(fecha(11:12))
    min_l  = chartostring(fecha(14:15))
  
    
    return([/dia_l,mes_l,anio_l,hora_l,min_l/])
    
end

;-----------------------------------------------------------------------
; Opciones basicas de graficado
;-----------------------------------------------------------------------

    res                   = True    
    res@gsnDraw           = False
    res@gsnFrame          = False
    res@gsnMaximize     = True                   ; use full page
    res@gsnAddCyclic    = False
    
    limits = (/-120.0,-80.0, 10., 35./)

    if Dom.eq.2
        print("es dominio 2")
        limits = (/-106.1447+0.5,-93.1004-0.5, 14.56853+0.5, 21.62866-0.5/)

    end if
    
     if Dom.eq.1
        print("es dominio 1")
        ;limits = (/-123.361 + 1.5,-74.8767 - 1.5, 4.12603 + 1.5 , 38.4261 -1.5/)
        limits = (/-123.361 + 1.5,-74.8767 - 1.5, 4.12603 + 1.5 , 38.4261 -1.5/)
    end if    
    
    res@mpMinLatF       = limits(2);  10.0 
    res@mpMaxLatF       = limits(3);  35.0 
    res@mpMinLonF       = limits(0);-120.0 
    res@mpMaxLonF       = limits(1); -80.0
    res@tmXBTickSpacingF= 5
    res@tmYLTickSpacingF= 5

    if Dom.eq.2
	res@tmYLTickSpacingF = 2
	res@tmXBTickSpacingF = 2
	res@mpGridLonSpacingF = 2
	res@mpGridLatSpacingF = 2
    end if
 
    oacute  = "o~H-13V2F35~B~FV-2H3~" ;acento
    iacute  = "i~H-08V2F35~B~FV-2~" 

;-----------------------------------------------------------------------
; Detalles de la division politica
;---------------------------------------------------------------------

   
    a_c = 1

    if Dom.eq.2
        a_c = 2
    end if
    
    res@mpGeophysicalLineColor      = "Black"
    res@mpNationalLineColor         = "Black"
    res@mpUSStateLineColor          = "Black"
    res@mpGridLineColor             = "Black"
    res@mpLimbLineColor             = "Black"
    res@mpPerimLineColor            = "Black"
    res@mpGeophysicalLineThicknessF = 2.0 + a_c
    res@mpDataSetName               = "Earth..4"   ; This new database contains
                                            ; divisions for other countries.
    res@mpDataBaseVersion           = "MediumRes"  ; Medium resolution database
    res@mpOutlineOn                 = True         ; Turn on map outlines
    res@mpOutlineSpecifiers         = (/"Mexico:states"/)
    res@mpGridAndLimbOn             = True
    res@tmXBLabelFontHeightF        = 0.008
    res@tmYLLabelFontHeightF        = 0.008
    res@mpLimbLineThicknessF        = 2. + a_c
    res@mpNationalLineThicknessF    = 2. + a_c
    res@mpUSStateLineThicknessF     = 2. + a_c
    res@mpGeophysicalLineThicknessF = 3.0 + a_c
    res@mpGridLineDashPattern       = 5                  ; lat/lon lines dashed
    res@mpGridLatSpacingF           = 5
    res@mpGridLonSpacingF           = 5
    res@tmXBMajorOutwardLengthF     = -10 -0.00	; set tickmarks
    res@tmYLMajorOutwardLengthF     = -10-0.00	; set tickmarks
    res@tmXBMinorOutwardLengthF     = -10-0.00
    res@tmYLMinorOutwardLengthF     = -10-0.00 
    res@mpGridLineColor =  "gray36"
    
    if Dom.eq.2
        res@mpGridLonSpacingF           = 2
        res@mpGridLatSpacingF           = 2
    end if
    
    res@cnExplicitLabelBarLabelsOn   =True
    res@lbTitleFontHeightF           = .005                 ; make title smaller 
    res@tmXBLabelDeltaF              = -2.3
    res@tmYLLabelDeltaF              = -3.5
    res@pmLabelBarOrthogonalPosF     = .010           ; move whole thing down
    res@tiMainOffsetYF               =-0.2
    res@gsnLeftStringOrthogonalPosF  = 0.005
    res@gsnRightStringOrthogonalPosF = 0.015
    res@pmLabelBarHeightF            = 0.03               ; default is taller
    res@pmLabelBarWidthF             = 0.7               ; default is shorter
    res@lbLabelFontHeightF           = .009              ; default is HUGE
    res@gsnStringFontHeightF =  0.011
    res@tmXBLabelFont        = "Helvetica-Bold"
    res@tmYLLabelFont        = "Helvetica-Bold"

    
    panel_res                            = True
    panel_res@gsnPanelLabelBar           = True
    panel_res@pmLabelBarWidthF           = 0.99
    panel_res@pmLabelBarHeightF          = 0.05 
    panel_res@gsnPanelRowSpec            = True
    panel_res@gsnPanelMainFontHeightF    = 0.015
    panel_res@lbTitleOn                  = True                  ; turn on title
    panel_res@lbTitleFontHeightF         = .0125                   ; make title smaller 
    panel_res@pmLabelBarOrthogonalPosF   = -.01           ; move whole thing down
    panel_res@gsnPanelXWhiteSpacePercent = 1.0
    panel_res@gsnPanelYWhiteSpacePercent = 1.0
    panel_res@amJust                     = "BottomLeft"
    panel_res@gsnPanelMainOffsetYF       = -0.02

    
;----------------------------------------------------------------------
;Definicion de constantes
;-----------------------------------------------------------------------

    meses = (/"","01","02","03","04","05","06","07","08","09","10","11","12"/)
 
;-----------------------------------------------------------------------
;   Detalles de los contornos de rapidez
;------------------------------------------------------------------------
   
    wind_mag_res                            = res
    wind_mag_res@InitTime                   = False
    wind_mag_res@cnMonoFillColor            = False
    wind_mag_res@cnFillOn                   = True
    wind_mag_res@cnLevelSelectionMode       = "ExplicitLevels"
    wind_mag_res@cnLevels                   = (/ 10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 118, 153, 177, 209, 249 /)
    wind_mag_res@cnExplicitLabelBarLabelsOn = True
    wind_mag_res@lbLabelStrings             =  (/"","20","","40","","60","","80","","100"," C1"," C2"," C3"," C4"," C5"/)
    wind_mag_res@cnLinesOn                = False           ; turn off contour lines
    
;-----------------------------------------------------------------------
;   Detalles de los contornos de rapidez altura
;------------------------------------------------------------------------
   
    wind_mag_res_altura                            = res
    wind_mag_res_altura@cnMonoFillColor            = False
    wind_mag_res_altura@cnFillOn                   = True
    wind_mag_res_altura@cnLevelSelectionMode       = "ExplicitLevels"
    wind_mag_res_altura@cnLevels = (/ 10, 20,30,40,50, 60,70, 80,90, 100, 120, 150, 170, 200, 250 /)
    wind_mag_res_altura@cnExplicitLabelBarLabelsOn = True
    wind_mag_res_altura@lbLabelStrings =(/"","20","","40","","60","","80","","100","120","150","170","200","250"/)
    wind_mag_res_altura@pmLabelBarWidthF           = 0.7               ; default is shorter
    wind_mag_res_altura@pmLabelBarHeightF          = 0.05               ; default is taller
    wind_mag_res_altura@lbLabelFontHeightF         = .01              ; default is HUGE
    wind_mag_res_altura@pmLabelBarOrthogonalPosF   = .060           ; move whole thing down
    wind_mag_res_altura@cnLinesOn                = False           ; turn off contour lines


;-----------------------------------------------------------------------
; Detalles de las barbas de viento
;------------------------------------------------------------------------

    vec_res                  = res
    vec_res@InitTime             = False
    vec_res@vcMinDistanceF   = 0.017
    vec_res@vcRefLengthF     = 0.015  
    vec_res@vcMinFracLengthF = 0.2
    vec_res@vcGlyphStyle     = "WindBarb"
    vec_res@vcRefAnnoOn      = False

;-----------------------------------------------------------------------
;   Detalles de los contornos de SLP
;------------------------------------------------------------------------
    
    levels      = ispan(1000,1100,2)
    info_string = "";Sea level pressure contours from 900 to 1100 by 4"
    slp_res                                = res
    slp_res@cnLineColor                    = "NavyBlue"
    slp_res@cnLevelSelectionMode           = "ExplicitLevels"
    slp_res@cnLevels                       = levels
    slp_res@cnLineLabelBackgroundColor     = -1    ; transparent
    slp_res@cnLineThicknessF               = 2.5
    slp_res@cnHighLabelsOn                 = True
    slp_res@cnLowLabelsOn                  = True
    slp_res@cnHighLabelBackgroundColor     = -1
    slp_res@cnLowLabelBackgroundColor      = -1
    slp_res@cnInfoLabelString              = info_string
    slp_res@cnInfoLabelFontColor           = "NavyBlue"
    slp_res@cnInfoLabelPerimOn             = False
    
;-----------------------------------------------------------------------
;   Detalles de los contornos de precipitacion
;------------------------------------------------------------------------
   
    preci_tot_res                          = res
    ;preci_tot_res@InitTime                 = False
    preci_tot_res@cnMonoFillColor          = False
    preci_tot_res@cnFillOn                 = True
    preci_tot_res@cnLevelSelectionMode     = "ExplicitLevels"
    preci_tot_res@lbLabelStrings           =  (/"1","","3","","5","10","15","20","30","40","50","100","150","200","300","400"/)
    preci_tot_res@cnLevelSelectionMode     = "ExplicitLevels"
    preci_tot_res@cnLevels                 = (/ 1, 2, 3, 4, 5, 10, 15, 20, 30,40, 50, 100, 150, 200, 300, 400 /)
    preci_tot_res@cnLinesOn                = False           ; turn off contour lines

;-----------------------------------------------------------------------
;   Detalles de los contornos de nubosidad
;------------------------------------------------------------------------
     
     cloud_res                          = res
    ;cloud_res@InitTime                 = False
    cloud_res@cnMonoFillColor          = False
    cloud_res@cnFillOn                 = True
    ;cloud_res@cnLevelSelectionMode     = "ExplicitLevels"
    ;cloud_res@lbLabelStrings           = (/"","10","","20","","30","","40","","50","","60","","70","","80","","90",""/)
    cloud_res@cnLevelSelectionMode     = "ExplicitLevels"
    cloud_res@cnLevels =  ispan(0,100,1);  (/ 5.,95.,5./)                =  (/ 5.,95.,5./);(/ 1, 2, 3, 4, 5, 10, 15, 20, 30,40, 50, 100, 150, 200, 300, 400 /)
    cloud_res@cnLinesOn                = False           ; turn off contour lines
   ; cloud_res@cnFillMode          = "RasterFill"    ; cell mode

;-----------------------------------------------------------------------
;   Detalles de los contornos de temperatura a 2m
;------------------------------------------------------------------------
   
    temp_res                            = res
    temp_res@InitTime                   = False
    temp_res@cnMonoFillColor            = False
    temp_res@cnFillOn                   = True
    temp_res@cnLevelSelectionMode = "ExplicitLevels"
    temp_res@cnLevels             = fspan(-13,49,63)
    temp_res@cnExplicitLabelBarLabelsOn=True
    temp_res@lbLabelStrings =  (/"","","","-10","","","","","-5","","","", \
                                 "","0","","","","","5","","","","","10","", \
                                 "","","","15","","","","","20","","","","", \
                                 "25","","","","","30","","","","","35","","",\
                                 "","","40","","","","","45","","","",""/)
    temp_res@cnLinesOn                = False           ; turn off contour lines
    
;-----------------------------------------------------------------------
;   Detalles de los contornos de cizalladura
;------------------------------------------------------------------------
    
     cizallamiento_res = res
     cizallamiento_res@InitTime             = False
     cizallamiento_res@cnMonoFillColor      = False
     cizallamiento_res@cnFillOn             = True
     cizallamiento_res@cnLevelSelectionMode = "ExplicitLevels"      
     cizallamiento_res@cnLevels             = (/ 10, 20, 30, 40, 50, 60, 70, 80, 90, \
                                     100, 125, 150, 175, 200, 225 /)
     cizallamiento_res@cnLinesOn                = False           ; turn off contour lines
     
     
;-----------------------------------------------------------------------
; Detalles de las barbas de viento
;------------------------------------------------------------------------

    cizallamiento_vector_res = res
    cizallamiento_vector_res@InitTime=False
    cizallamiento_vector_res@NumVectors = 40
    cizallamiento_vector_res@vcWindBarbColor = "Black"
    cizallamiento_vector_res@vcWindBarbLineThicknessF     = 1.0
    
    ;-----------------------------------------------------------------------
;   Detalles de los contornos de nubosidad
;------------------------------------------------------------------------
 
    
    pwat_res                          = res
    pwat_res@InitTime                 = False
    pwat_res@cnMonoFillColor          = False
    pwat_res@cnFillOn                 = True
    pwat_res@cnLevelSelectionMode     = "ExplicitLevels"
    pwat_res@lbLabelStrings           = (/ "5", "10", "15", "20", "25", "30", "35", "40", "45", "50", "55", "60", "65", "70", "75"/)
    pwat_res@cnLevelSelectionMode     = "ExplicitLevels"
    pwat_res@cnLevels                 = (/ 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 75 /)
    pwat_res@cnLinesOn                = False           ; turn off contour lines

;-----------------------------------------------------------------------
;   Detalles de los contornos de humedad relativa
;------------------------------------------------------------------------
 
    
    rh_res                            = res
    rh_res@InitTime                   = False
    rh_res@cnMonoFillColor            = False
    rh_res@cnFillOn                   = True
    rh_res@cnLevelSelectionMode       = "ManualLevels"
	rh_res@cnLevelSpacingF            = 5
	rh_res@cnMinLevelValF             = 55
	rh_res@cnMaxLevelValF             = 95
	rh_res@cnExplicitLabelBarLabelsOn =True
    rh_res@lbLabelStrings             =  (/"55","60","65","70","75","80","85","90","95"/)
    rh_res@cnLinesOn                 = False           ; turn off contour lines
    rh_res@cnFillColors = (/"White","White","green2","green3","forestgreen","darkgreen","lightskyblue","deepskyblue2","dodgerblue3","dodgerblue4"/)

;-----------------------------------------------------------------------
;   Detalles de los contornos de omega
;------------------------------------------------------------------------
 
    
    omega_res                          = res
    omega_res@InitTime                 = False
    omega_res@cnMonoFillColor          = False
    omega_res@cnFillOn                 = True
    omega_res@cnLineLabelsOn           = False
    omega_res@cnExplicitLabelBarLabelsOn=True
    omega_res@lbLabelStrings =  (/" -30",""," "," "," "," "," -15"," "," "," "," "," ","   0"," "," "," "," "," ","  15"," ","  ","  "," "," ","  30"/)
    omega_res@cnLevelSelectionMode = "ManualLevels"
    omega_res@cnLevelSpacingF = 0.0025
    omega_res@cnMinLevelValF  = -0.03
    omega_res@cnMaxLevelValF  = 0.03
    omega_res@cnLinesOn                = False           ; turn off contour lines
    
;-----------------------------------------------------------------------
;   Detalles de los contornos de divergen
;------------------------------------------------------------------------
 
    
    divergencia_res                          = res
    divergencia_res@cnMonoFillColor          = False
    divergencia_res@cnFillOn                 = True
    divergencia_res@cnLevelSelectionMode = "ManualLevels"
    divergencia_res@cnLevelSpacingF = 3
    divergencia_res@cnMinLevelValF  = -36
    divergencia_res@cnMaxLevelValF  = 36
    divergencia_res@cnLinesOn                = False           ; turn off contour lines

;-----------------------------------------------------------------------
;   Detalles de los contornos de omega
;------------------------------------------------------------------------
 
    
    divergencia_res_altura                          = res
    divergencia_res_altura@cnMonoFillColor          = False
    divergencia_res_altura@cnFillOn                 = True
    divergencia_res_altura@cnLevelSelectionMode = "ManualLevels"
    divergencia_res_altura@cnLevelSpacingF = 3
    divergencia_res_altura@cnMinLevelValF  = -36
    divergencia_res_altura@cnMaxLevelValF  = 36
    divergencia_res_altura@pmLabelBarWidthF         = 0.7       
    divergencia_res_altura@pmLabelBarHeightF        = 0.05               ; default is taller
    divergencia_res_altura@lbLabelFontHeightF       = .01              ; default is HUGE
    divergencia_res_altura@pmLabelBarOrthogonalPosF = .060           ; move whole thing down
    divergencia_res_altura@cnLinesOn                = False           ; turn off contour lines
    
;-----------------------------------------------------------------------
;   Detalles de los contornos de eth
;------------------------------------------------------------------------
 
    
    eth_res                          = res
    eth_res@InitTime                 = False
    eth_res@cnMonoFillColor          = False
    eth_res@cnFillOn                 = True
    eth_res@cnLevelSelectionMode     = "ManualLevels"
    eth_res@cnLevelSelectionMode     = "ExplicitLevels"
    eth_res@cnLevels                 = (/ 270, 275, 280, 285, 290, 295, 300, 305, 310, 315,320,325,330,335,340,345,350,355,360/) + 3 - 273
    ;eth_res@lbLabelStrings           = (/"270", "", "280", "", "290", "", "300", "", "310", "","320","","330","","340","","350","","360"/)
    eth_res@lbLabelStrings           = (/"0","5","10","15","20","25","30","35","40","45","50","55","60","65","70","75","80","85","90"/)
    eth_res@pmLabelBarWidthF         = 0.7       
    eth_res@pmLabelBarHeightF        = 0.05               ; default is taller
    eth_res@lbLabelFontHeightF       = .01              ; default is HUGE
    eth_res@cnLinesOn                = False           ; turn off contour lines
    eth_res@cnLineLabelsOn  = False
    
;-----------------------------------------------------------------------
;   Detalles de los contornos de geopotencial
;------------------------------------------------------------------------
    geopotencial_res = res                                  ; Add basic resources
    geopotencial_res@InitTime=False
    geopotencial_res@FieldTitle = ""
    geopotencial_res@cnLineColor = "tomato4"                        ; Set line color
    geopotencial_res@gsnContourLineThicknessesScale = 3.5
    geopotencial_res@cnInfoLabelOn       = False  ; mod no info label
    geopotencial_res@cnLineLabelsOn = True ; con este aparecen
    geopotencial_res@cnLineLabelBackgroundColor = "white"       ; white bckgrnd around label
    
;-----------------------------------------------------------------------
;   Detalles de los contornos de vorticidad relativa
;------------------------------------------------------------------------    
        
    rel_vorticity_res                          = res
    rel_vorticity_res@cnMonoFillColor          = False
    rel_vorticity_res@cnFillOn                 = True
    rel_vorticity_res@cnLevelSelectionMode = "ManualLevels"
    rel_vorticity_res@cnLevelSpacingF = 10
    rel_vorticity_res@cnMinLevelValF  = -70
    rel_vorticity_res@cnMaxLevelValF  = 70
    rel_vorticity_res@cnLinesOn                = False           ; turn off contour lines
    
    
             ;1  2   3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20  21  22  23  24
    fig_i = (/0 ,5 ,10,15,20,25,30,35,40,45,50,55,60,65,70,75,80,85,90,95,100,105,110,115/)
    fig_f = (/4 ,9 ,14,19,24,29,34,39,44,49,54,59,64,69,74,79,84,89,94,99,104,109,114,120/)
    
    cmap = (/(/250,250,250/),(/0,0,0/),(/ 58,   0, 176/),\; (/9,47,145/),\
                 (/25,122,237/), \
                 (/ 134, 205, 249/),\
                 (/250, 250,   250/), \
                 (/250, 250,   0/),\
                 (/250, 187,   0/),\
                 (/250, 0,   0/)/)/250.
