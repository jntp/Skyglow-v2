load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"

begin

  ;** Read in netCDF file 
  ctl = addfile("skg_swn_rmt_ctl.nc", "r") ;-- from control file (present day)
  xpt = addfile("skg_swn_rmt_xpt.nc", "r") ;-- from experiment file (geoengineered)
  cln = addfile("skg_swn_rmt_cln.nc", "r") ;-- form clean file

  ;** Read in data required for calculation
  ctl_ndr = ctl->lmn_bb_aa_ndr(31:) ;-- broadband azimuthally averaged luminance toward nadir (x axis)
  xpt_ndr = xpt->lmn_bb_aa_ndr(31:)
  cln_ndr = cln->lmn_bb_aa_ndr(31:)

  levp = ctl->levp(31:) ;-- pressure coordinates (y axis)

  x_dim = dimsizes(levp) ;-- get dimensions for a multidimensional array containing control and experiment values 

  ;** Reorder the dimensions of lmn_bb_aa to allow for plotting
  x = (/ctl_ndr, xpt_ndr, cln_ndr/) 
  x@long_name = "Broadband azimuthally averaged luminance towards nadir"
  x!0 = "conditions"
  x!1 = "luminance"

  ;** Convert units for better readability
  x = x * 1000 ;-- convert to millicandelas per meter squared
  x@units = "millicandela meter-2"

  levp = levp / 100 ;-- convert to hPa or millibars
  levp@units = "hectopascal" 

  ;** Prepare plot
  wks = gsn_open_wks("png", "skg_lmn_znt_rmt_vz")

  res = True
  res@gsnDraw = False ;-- don't draw plot yet
  res@gsnFrame = False ;-- don't advance frame
  res@tiMainString = "Remote Night Sky Brightness"
  res@tiXAxisString = "Zenith-viewing Luminance [mcd m~S~-2~N~]"
  res@tiYAxisString = "Pressure [mb]"
  res@tiMainFontHeightF = 0.025
  res@tiXAxisFontHeightF = 0.020
  res@tiYAxisFontHeightF = 0.020
  res@xyLineThicknessF = 5
  res@trYReverse = True ;-- reverse Y-axis
  res@trYMinF = 0 ;-- y axis minimum value
  res@trYMaxF = 1000 ;-- y axis maximum value

  ;-- NOTE... FOR URBAN AREAS, CHOOSE BETWEEN 0 and 2.8
  ;-- FOR REMOTE, CHOOSE BETWEEN 0.160 and 0.174
  res@trXMinF = 0.160 ;-- x axis minimum value
  res@trXMaxF = 0.174 ;-- x axis maximum value
  
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
