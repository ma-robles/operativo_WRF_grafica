/;

###################################################
# Institucion: UNAM-CCA                           #
# Proyecto:    CENAPRED                           #
# Autor:       Fernando Nicolas Arellano Guerrero #
# Fecha:       Marzo de 2018                      #
# e-mail:      fnag@atmosfera.unam.mx             #
###################################################

# Codigo que genera los productos de alertamiento

;/

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRFUserARW.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

; Actualizar esta linea si se ejecuta en otro equipo
load "/LUSTRE/OPERATIVO/scripts/ncl/wrf/paralelo/recursos.ncl"

; Ejemplo de ejecutarlo 
; ncl Dom=2 arch=\"/LUSTRE/OPERATIVO/EXTERNO-salidas/WRF/2018/01_enero/wrfout_d02_2018-01-23_00.nc\" var_met=\"temp\" indice_f=0 alertas.ncl 
;srun -N1 -n1 --exclusive ncl Dom=$Dom arch=\"${SALIDA_WRF}\" arch_alerta=\"${SALIDA_ALERTA}\" var_met=\"${variable}\" indice_f=$ij $RAIZ_SISTEMA/scripts/ncl/wrf/paralelo/alertas.ncl > parallel_${ij}.log &

begin
               
;-----------------------------------------------------------------------
; Archivo del modelo WRF a analizar...
;-----------------------------------------------------------------------

; Tomar archivo WRF para referencia del tiempo

    a    = addfile(arch,"r")

    Ruta_datos = "/LUSTRE/HOME/fernando/operativo/owgis/Alertas/2018/01_enero/"

    ; Si se desea hacer un zoom modificar la variable limits
    
    ;;;;; DEFINIR MES DE SESGO
    
    Xtimes = a->XTIME
    stime  = cd_string(Xtimes, "%D/%N/%Y %H:%M")  
    ltime  = cd_string(Xtimes, "%Y-%N-%D %H:%M")
    
    it=0
    fecha_p =   hora_local(ltime(it))
  
    l_dia2  = fecha_p[0]
    l_mes2  = fecha_p[1]
    
    mes_sesgo = fecha_p[1]
    
    Dominio = Dom    
    
    total=1
    
    oacute  = "o~H-13V2F35~B~FV-2H3~"
    aacute  = "a~H-13V2F35~B~FV-2H3~"
    iacute  = "i~H-08V2F35~B~FV-2~"
    
    if (var_met.eq."T2") then
        Variable_indice = "T2"
        bar_name        = "temperatura"
        encabezado     := "Alerta de temperaturas en superficie" 
        encabezado_b   := "Alerta de temperaturas en superficie" + " (percentil)"

    end if
    
    if (var_met.eq."T2_M") then
        Variable_indice = "T2A"
        bar_name        = "temperatura"
        total           = 0
        encabezado     := "Alerta de temperaturas extremas en superficie" 
        encabezado_b   := "Alerta de temperaturas extremas en superficie" + " (percentil)"

        arch_alerta = str_sub_str(arch_alerta,"T2_M","T2")
    end if
    
    if (var_met.eq."VIENTO")
        Variable_indice = "VIENTO"
        bar_name        = "viento"
        encabezado     := "Alerta de viento en superficie" 
        encabezado_b   := "Alerta de viento en superficie" + " (percentil)"
        cmap           := (/(/250,250,250/),(/0,0,0/),\
                            (/250, 250,   250/),\
                            (/250, 250,     0/),\
                            (/250, 187,     0/),\
                            (/250,   0,    0/)/)/250.
    end if
    
    if (var_met.eq."VIENTO_M")
        Variable_indice = "VIENTOA"
        bar_name        = "viento"
        total           = 0
        encabezado     := "Alerta de viento m" + aacute + "ximo en superficie" 
        encabezado_b   := "Alerta de viento m" + aacute + "ximo en superficie" + " (percentil)"
        arch_alerta     = str_sub_str(arch_alerta,"VIENTO_M","VIENTO")
        cmap           := (/(/250,250,250/),(/0,0,0/),\
                            (/250, 250,   250/),\
                            (/250, 250,     0/),\
                            (/250, 187,     0/),\
                            (/250,   0,    0/)/)/250. 
   end if
    
    if (var_met.eq."PREC")
        Variable_indice = "PREC"
        bar_name        = "precipitacion"
        encabezado     := "Alerta de precipitaci"+oacute+"n" 
        encabezado_b   := "Alerta de precipitaci"+oacute+"n" + " (percentil)"
        ;arch_alerta    = str_sub_str(arch_alerta,"PRECIPITACION","VIENTO")
        cmap           := (/(/250,250,250/),(/0,0,0/),\
                            (/250, 250,   250/),\
                            (/250, 250,     0/),\
                            (/250, 187,     0/),\
                            (/250,   0,    0/)/)/250. 
    end if
    
    if (var_met.eq."PREC_M") 
        Variable_indice = "PRECA"
        bar_name        = "precipitacion"
        encabezado     := "Alerta de precipitaci"+oacute+"n extrema"
        encabezado_b   := "Alerta de precipitaci"+oacute+"n extrema" + " (percentil)"
        arch_alerta     = str_sub_str(arch_alerta,"PREC_M","PREC")
        total           = 0
        cmap           := (/(/250,250,250/),(/0,0,0/),\
                            (/250, 250,   250/),\
                            (/250, 250,     0/),\
                            (/250, 187,     0/),\
                            (/250,   0,    0/)/)/250. 
    end if
    
    archivo =  addfile(arch_alerta,"r") ; addfile( Ruta_datos + Variable_indice + "_dom" + Dominio + "_2018-01-22.nc","r") 
        
;----------------------------------------------------------------------
;Definicion de constantes
;-----------------------------------------------------------------------

    times  = wrf_user_list_times(a)
    ;ntimes = dimsizes(times)
  
;-----------------------------------------------------------------------
;Empieza el loop del tiempo
;-----------------------------------------------------------------------

    lat2 = wrf_user_getvar(a,"lat",0)
    lon2 = wrf_user_getvar(a,"lon",0)

    lat = lat2(:,1)
    lon = lon2(1,:)
    
    sesgo_matrix  = archivo->$Variable_indice$

    times_in_file = a->Times

    index_if =fig_i(indice_f)
    index_ff =fig_f(indice_f)

    if total.eq.0
        index_if = 0
        index_ff = 0
    end if

do it = index_if,index_ff ;  indice_f,indice_f ;            ; Loop de tiempo

;--------------------------------------------------------------------------
; Estructura de textos
;----------------------------------------------------------------------------
    
    print(it)
    
    printVarSummary(sesgo_matrix)
    
    if total .eq. 0
        sesgo = sesgo_matrix(it,:,:)
    else
        sesgo = sesgo_matrix(it,:,:)
    end if
        
    Xtimes = a->XTIME
    stime  = cd_string(Xtimes, "%D/%N/%Y %H:%M")  
    ltime  = cd_string(Xtimes, "%Y-%N-%D %H:%M")
    
    fecha_p = hora_local(ltime(it))
  
    l_dia2  = fecha_p[0]
    l_mes2  = fecha_p[1]
    l_anio2 = fecha_p[2]
    l_time2 = fecha_p[3]    

    fecha_ini =   hora_local(ltime(0))

    l_dia_ini  = fecha_ini[0]
    l_mes_ini  = fecha_ini[1]
    l_anio_ini = fecha_ini[2]
    l_time_ini = fecha_ini[3]

    ntimes = dimsizes(Xtimes)

    fecha_fin =   hora_local(ltime(ntimes-1))

    l_dia_fin  = fecha_fin[0]
    l_mes_fin  = fecha_fin[1]
    l_anio_fin = fecha_fin[2]
    l_time_fin = fecha_fin[3]

    ; Etiquetas de encabezados

    Titulo_info      = "Modelo WRF      " + stime(0) + " GMT"
    Titulo_info2     = "                     Pron" + oacute + "stico a " + sprinti("%0.3i",(it*1)) + " hrs"
    Titulo_info3     = "Hora Local CDMX " + l_time2 + ":00 " + l_dia2 + "/" + l_mes2 + "/" + l_anio2
    
    if total .eq. 0
        Titulo_variables = encabezado ;("Indice maximo de alerta para " + bar_name + " en superficie")
    else
        Titulo_variables = encabezado ;("Indice de alerta para " + bar_name + " en superficie")
    end if
    
    if ( (var_met.eq."VIENTO_M") .or. (var_met.eq."PREC_M") .or. (var_met.eq."T2_M")) then
        Titulo_info2     = ("                      Per"+ iacute +"odo de validez");            M"+aacute+"ximo de 120 horas de pron"+oacute+"stico")
        Titulo_info3     = ("De " +l_time_ini+":00 "+l_dia_ini+"/"+l_mes_ini+"/"+l_anio_ini +" a "+l_time_fin+":00 "+l_dia_fin+"/"+l_mes_fin+"/"+l_anio_fin)
   end if
    
    
;-------------------------------------------------------------------------
; Obtencion de las variables
;-------------------------------------------------------------------------

    slp = wrf_user_getvar(a,"slp",it)      ; Get slp
	wrf_smooth_2d( slp, 3 )                ; Smooth slp
                            
    t2 = wrf_user_getvar(a,"T2",it)                   ; Get T2 (deg K)
	temp_2 = t2-273.16                              ; Convert to deg C
    
    printVarSummary(temp_2)
    
    slp@lat       := wrf_user_getvar(a,"XLAT",it)   ; latitude/longitude
    slp@lon       := wrf_user_getvar(a,"XLONG",it)  ; required for plotting
    slp!0         = "lat"
    slp!1         = "lon"
    slp@units     := ""
    slp@long_name := ""
    slp&lat       = lat
    slp&lon       = lon
    slp&lat@units = "degrees_north"
    slp&lon@units = "degrees_east"
    
    
    temp_2@lat       := wrf_user_getvar(a,"XLAT",it)   ; latitude/longitude
    temp_2@lon       := wrf_user_getvar(a,"XLONG",it)  ; required for plotting
    temp_2!0         = "lat"
    temp_2!1         = "lon"
    temp_2@units     := ""
    temp_2@long_name := ""
    temp_2@units     := Titulo_info2 + "~C~" +Titulo_info3       
    temp_2@long_name := Titulo_info  + "~C~" +  Titulo_variables
    temp_2&lat       = lat
    temp_2&lon       = lon
    temp_2&lat@units = "degrees_north"
    temp_2&lon@units = "degrees_east"
    
;-------------------------------------------------------------------------------
;   Descripcion del grafico
;-------------------------------------------------------------------------------
    
    if total.eq.0
        nombre = ("d"+Dom+"_alerta_max_"+var_met+"_"+sprinti("%0.3i",(it*1))) ;Estructura el nombre del grafico "DOM1_120H_Viento10m_(Tiempo de pronostico)"
    else
        nombre = ("d"+Dom+"_alerta_"+var_met+"_"+sprinti("%0.3i",(it*1))) ;Estructura el nombre del grafico "DOM1_120H_Viento10m_(Tiempo de pronostico)"
    end if
    
    type   = "png"
    wks    := gsn_open_wks(type,nombre)
    gsn_define_colormap(wks,"barra_temperatura_PEMEX_2")

;-----------------------------------------------------------------------
;   Detalles de los contornos de rapidez
;------------------------------------------------------------------------
  
    temp_res@lbTitleString    = encabezado_b ;"Indice de alerta para " + bar_name + " en superficie"
    temp_res@lbTitleFontHeightF= .009 
    
    temp3 =sesgo
          
    limits = (/-115.0 ,-86.0, 14.0, (33.0-10.0)/)
     
     Dominio = 2
     
    if Dominio .eq. 2
          limits = (/min(lon) ,max(lon), min(lat),max(lat)/)
    end if

    temp_res@cnLevels    := (/0.1, 1.0,5.0,95.0,99.0,99.9/)   ; set levels
    temp_res@cnLinesOn                := True           ; turn off contour lines

    gsn_define_colormap(wks,cmap)

    temp_res@cnFillMode            = "CellFill"
    temp_res@cnMissingValFillColor = -1
    temp_res@cnLineLabelsOn        = False
    temp_res@cnLinesOn             = False
    temp_res@lbLabelStrings       :=  (/"0.1","1.0","5.0","95.0","99.0","99.9"/)
   
   print("aquitoy 2")

    if ( (var_met.eq."VIENTO") .or. (var_met.eq."VIENTO_M") .or. (var_met.eq."PREC") .or. (var_met.eq."PREC_M")) then
	    temp_res@cnLevels    := (/95.0,99.0,99.9/)   ; set levels
	    temp_res@lbLabelStrings :=  (/"95.0","99.0","99.9"/)
        ;temp_res@lbLabelPosition  = "Center"             ; label position
        ;temp_res@lbLabelAlignment = "BoxCenters"         ; label orientation
        ;temp_res@lbLabelStrings :=  (/"0.0-95.0","95.0","99.0","99.9"/)
        temp_res@lbLabelStrings :=  (/"95.0","99.0","99.9"/) 
    end if

    gsn_define_colormap(wks,cmap);  (::-1,::-1,::-1))
    
    copy_VarMeta(temp_2,temp3)
    copy_VarCoords(temp_2,temp3)  
      
    temp3@mpMinLatF := limits(2);  10.0 
    temp3@mpMaxLatF := limits(3);  35.0 
    temp3@mpMinLonF := limits(0);-120.0 
    temp3@mpMaxLonF := limits(1); -80.0
    
    contour = gsn_csm_contour_map(wks,temp3,temp_res)

	;-----------------------------------------------------------------------
	; Crear el grafico
	;------------------------------------------------------------------------

        draw(contour)   ; This will draw all overlaid plots and the map
	frame(wks)
        delete(wks)
        fname=nombre
        convierte = "convert -trim " + fname + ".png " +fname + ".jpg"
        system(convierte)  
        
	end do    

 	print("termina graficado")
        
end
