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


