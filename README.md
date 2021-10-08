# operativo_WRF_grafica
Rutinas para graficado del operativo WRF

## alertas.ncl

### Objetivo
Generar las gráficas correspondientes a alertas. El script genéra un grupo de gráficas que se indican con el parámerto indice_f.

### Sintaxis
ncl Dom arch arch_alerta var_met indice_f alertas.ncl

### Requiere
recursos.ncl
archivo para referencias de hora 

### Parámetros
* arch - archivo de referencia de tiempo (salida WRF)
* arch_alerta - archivo a procesar (con las alertas)
* indice_f - índice de ejecución. define que gráfica se realiza cuando se corre en paralelo.
* Dom - número de dominio. Puede ser 1,2

### Salidas/productos
Imagen en JPG con la gráfica.


### Ejemplo 
ncl arch=\"/LUSTRE/OPERATIVO/EXTERNO-salidas/WRF/2018/03_marzo/wrfout_d01_2018-03-20_00.nc\" arch_alerta=\"/LUSTRE/OPERATIVO/owgis/Alertas/2018/03_marzo/VIENTO_dom1_2018-03-20.nc\" var_met=\"VIENTO\" indice_f=0 Dom=2 alertas.ncl
