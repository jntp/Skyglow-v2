load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"

begin

  ;** Read in netCDF file 
  ctl = addfile("skg_swn_rmt_ctl.nc", "r") ;-- from control file (present day)
  xpt = addfile("skg_swn_rmt_xpt.nc", "r") ;-- from experiment file (geoengineered)
  cln = addfile("skg_swn_rmt_cln.nc", "r") ;-- from clean file

  ;** Read in data required for calculation
  ctl_ilm = ctl->ilm_dwn(31:) ;-- total downwelling illuminance (direct + diffuse)
  xpt_ilm = xpt->ilm_dwn(31:)
  cln_ilm = cln->ilm_dwn(31:)
  levp = ctl->levp(31:) ;-- pressure coordinates (y axis)

  x_dim = dimsizes(levp) ;-- get dimensions for a multidimensional array containing control and experiment values

  ;** Reorder the dimensions of lmn_bb_aa to allow for plotting
  x = (/ctl_ilm, xpt_ilm, cln_ilm/) 
  x@long_name = "Total downwelling illuminance (direct + diffuse)"
  x!0 = "conditions"
  x!1 = "illuminance"

  ;** Convert units for better readability
  x = x * 1000 ;-- convert to millilux (lux = lumen/meter-2)
  x@units = "millilux"

  levp = levp / 100 ;-- convert to hPa or millibars
  levp@units = "hectopascal" 

  ;** Prepare plot
  wks = gsn_open_wks("png", "skg_ilm_rmt_vz")

  res = True
  res@gsnDraw = False ;-- don't draw plot yet
  res@gsnFrame = False ;-- don't advance frame
  res@tiMainString = "Remote Night Sky Illuminance"
  res@tiXAxisString = "Downwelling Illuminance [mlux]"
  res@tiYAxisString = "Pressure [mb]"
  res@tiMainFontHeightF = 0.025
  res@tiXAxisFontHeightF = 0.020
  res@tiYAxisFontHeightF = 0.020
  res@xyLineThicknessF = 5
  res@trYReverse = True ;-- reverse Y-axis
  res@trYMinF = 0 ;-- y axis minimum value
  res@trYMaxF = 1000 ;-- y axis maximum value

  ;-- NOTE... FOR URBAN AREAS, CHOOSE BETWEEN 0 and 16
  ;-- FOR REMOTE, CHOOSE BETWEEN 0.470 and 0.542
  res@trXMinF = 0.470 ;-- x axis minimum value
  res@trXMaxF = 0.542 ;-- x axis maximum value
  
  res@xyDashPattern = 0 ;-- makes all lines solid
  res@xyLineColors = (/"black", "green", "blue"/) 

  ;** Turn off tickmarks on the top and right side
  res@tmYROn = False ;-- right off
  res@tmXTOn = False ;-- top off

  ;** Create a legend
  res@pmLegendDisplayMode = "Always" ;-- turn on legend
  res@pmLegendSide = "Top" ;-- position of legend (what side)

  ;-- NOTE... FOR URBAN AREAS, CHOOSE 0.73 for ParallelPos and -0.38 for OrthogonalPos
  ;-- FOR REMOTE, CHOOSE 0.24 for ParallelPos and -0.34 for OrthogonalPos
  res@pmLegendParallelPosF = 0.24 ;-- move units right
  res@pmLegendOrthogonalPosF = -0.34 ;-- move units down

  res@lgPerimOn = False ;-- turn off legend perimeter
  res@pmLegendWidthF = 0.11
  res@pmLegendHeightF = 0.14
  res@lgLabelFontHeightF = 0.020
  res@xyExplicitLegendLabels = (/"  Present Day", "  Geoengineered", "  Clean Sky" /) 
  res@lgItemOrder = (/1, 2, 0/) ;-- reorder items on legend

  ;** Make the plot
  plot = gsn_csm_xy(wks, x, levp, res) ;-- draw a pressure/height plot  

  draw(plot)
  frame(wks)

end
