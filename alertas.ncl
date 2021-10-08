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

;solo necesarias en ncl <6.2
;load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
;load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
;load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRFUserARW.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"
;date 
load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/calendar_decode2.ncl"
;load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/cd_string.ncl"


; Ejemplo de ejecutarlo 
; ncl Dom=2 arch=\"/LUSTRE/OPERATIVO/EXTERNO-salidas/WRF/2018/01_enero/wrfout_d02_2018-01-23_00.nc\" var_met=\"temp\" indice_f=0 alertas.ncl 
;srun -N1 -n1 --exclusive ncl Dom=$Dom arch=\"${SALIDA_WRF}\" arch_alerta=\"${SALIDA_ALERTA}\" var_met=\"${variable}\" indice_f=$ij $RAIZ_SISTEMA/scripts/ncl/wrf/paralelo/alertas.ncl > parallel_${ij}.log &

begin
               
    archivo =  addfile(arch_alerta,"r") 
    
    it=0

    lat=archivo->Latitude
    lon=archivo->Longitude
    init_lat=lat(0)
    init_lon=lon(0)
    end_lat=lat(dimsizes(lat)-1)
    end_lon=lon(dimsizes(lon)-1)
    len_lat= end_lat-init_lat
    len_lon= end_lon-init_lon
    print(end_lat-init_lat)
    print(end_lon-init_lon)
    printVarSummary(init_lat)
    if (len_lat<9 .and. len_lon<15)
      Dom=2
    else
      Dom=1
    end if
      

load "recursos.ncl"
    ;archivo->Time hora del archivo (GMT)
    ;mktime hora local (GMT-6 o GMT-5)
    ;mydate hora local en arreglo de enteros

    zona=stringtoint(systemfunc("date +'%z'"))/100
    mktime=archivo->Time+zona
    copy_VarMeta(archivo->Time,mktime)
    ;mydate =calendar_decode2(mktime,-5)
    txt_fecha_inicio = cd_string(archivo->Time(0), "%D/%N/%Y %H:%M")  
    mtimes=dimsizes(mktime)-1
    txt_intervalo= cd_string(mktime(0), "De %H:%M %D/%N/%Y ") + cd_string(mktime(mtimes), "a %H:%M %D/%N/%Y ")
    print("procesando: "+txt_fecha_inicio+ " intervalo: "+txt_intervalo)
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
    
        
;-----------------------------------------------------------------------
;   Detalles de los contornos de rapidez
;------------------------------------------------------------------------
  
    temp_res@lbTitleString    = encabezado_b ;"Indice de alerta para " + bar_name + " en superficie"
    temp_res@lbTitleFontHeightF= .009 
    temp_res@cnLevels    := (/0.1, 1.0,5.0,95.0,99.0,99.9/)   ; set levels
    temp_res@cnLinesOn                := True           ; turn off contour lines


    temp_res@cnFillMode            = "CellFill"
    temp_res@cnMissingValFillColor = -1
    temp_res@cnLineLabelsOn        = False
    temp_res@cnLinesOn             = False
    temp_res@lbLabelStrings       :=  (/"0.1","1.0","5.0","95.0","99.0","99.9"/)
   
;-------------------------------------------------------------------------------
;   Descripcion del grafico
;-------------------------------------------------------------------------------
    if ( (var_met.eq."VIENTO") .or. (var_met.eq."VIENTO_M") .or. (var_met.eq."PREC") .or. (var_met.eq."PREC_M")) then
	    temp_res@cnLevels    := (/95.0,99.0,99.9/)   ; set levels
	    temp_res@lbLabelStrings :=  (/"95.0","99.0","99.9"/)
    end if

    Titulo_info2 = ("                      Periodo de validez");            M"+aacute+"ximo de 120 horas de pron"+oacute+"stico")
    Titulo_info3 = txt_intervalo

    Titulo_info      = "Modelo WRF      " + txt_fecha_inicio + " GMT"
;-----------------------------------------------------------------------
;Empieza el loop del tiempo
;-----------------------------------------------------------------------

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
      ; Etiquetas de encabezados
      ;Para variables no máximas
      if ( .not.isStrSubset(var_met, "_M")) then
          Titulo_info2     = "                     Pron" + oacute + "stico a " + sprinti("%0.3i",(it*1)) + " hrs"
          Titulo_info3     = cd_string(mktime(it),"Hora Local CDMX %H:%M %D/%N/%Y")
      end if
      
      ;Estructura el nombre del grafico 
      nombre = ("d"+Dom+"_alerta_max_"+var_met+"_"+sprinti("%0.3i",(it*1))) 
      if .not.total.eq.0
          nombre = str_sub_str(nombre,"_max","") 
      end if
      
      data= archivo->$Variable_indice$(it,:,:)
      data!0         = "lat"
      data!1         = "lon"
      data@units     := Titulo_info2 + "~C~" +Titulo_info3       
      data@long_name := Titulo_info  + "~C~" + encabezado 
      data&lat       = lat
      data&lon       = lon
    ;-----------------------------------------------------------------------
    ; Crear el grafico
    ;------------------------------------------------------------------------
      type   = "png"
      wks    := gsn_open_wks(type,nombre)
      gsn_define_colormap(wks,cmap)
      contour = gsn_csm_contour_map(wks,data,temp_res)
      draw(contour)   ; This will draw all overlaid plots and the map
      frame(wks)
      delete(wks)
      convierte = "convert -trim " + nombre+ ".png " +nombre + ".jpg"
      system(convierte)  
        
	end do    
 	print("termina graficado")
        
end
