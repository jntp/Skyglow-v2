import numpy as np
import xarray as xr
import matplotlib.pyplot as plt
from matplotlib.ticker import ScalarFormatter

import geocat.datafiles as gdf
from geocat.viz import util as gvutil
from geocat.viz import cmaps as gvcmap

# Open a netCDF data file using xarray default engine and load the data into xarrays
diff = xr.open_dataset("skg_swn_urb_ctlmcln.nc") # difference file
cont = xr.open_dataset("skg_swn_urb_cln.nc") # used to address "zero" issues in difference file and calculating the percentage

# Read in data required for calculation
diff_lmn = diff.lmn_bb_aa # broadband azimuthally averaged luminance
cont_lmn = cont.lmn_bb_aa 
levp = diff.levp # pressure coordinates 
plr_dgr = cont.plr_dgr # polar angle in degrees

# Divide difference data by control data and multiply by 100 to obtain percentage
percentage = (diff_lmn / cont_lmn) * 100

# Swap values on plr_dgr to plot angles in the viewer's perspective instead of the light's
plr_dgr = plr_dgr[::-1]

# Generate figure (set its size (width, height) in inches) and axes
plt.figure(figsize = (8, 8))
ax = plt.axes()

# Specify which contour should be drawn
levels = np.linspace(-100, 100, 21) # from -100 to 100, with 21 intervals (spaced by 10)

# Plot contour lines
lines = percentage.plot.contour(ax = ax, levels = levels, colors = 'black', linewidths = 0.5, linestyles = 'solid', add_labels = False)

# Draw contour labels and set their backgrounds to be white
ax.clabel(lines, fmt = '%d', levels = levels)
[
  txt.set_bbox(dict(facecolor = 'white', edgecolor = 'none', pad = 1))
  for txt in lines.labelTexts
]

# Plot filled contours
colors = percentage.plot.contourf(ax = ax, levels = levels, cmap = gvcmap.BlueRed, add_labels = False, add_colorbar = False)

# Add colorbar
plt.colorbar(colors, ax = ax, orientation = 'vertical', ticks = levels[1::2], drawedges = True, aspect = 12, shrink = 0.7, pad = 0.1) # Look up slice notation on levels[1::2]

# Force the plot to be square by setting the aspect ratio to 1
ax.set_box_aspect(1)

plt.tight_layout() # automatically adjust subplot parameters to give specified padding
plt.show() 



