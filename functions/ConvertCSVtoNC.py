# -*- coding: utf-8 -*-
"""
Created on Mon Feb 17 21:35:18 2025

@author: vinhtn1
"""

import pandas as pd
import xarray as xr
import scipy.io as sio

def csv_to_netcdf(csv_path, nc_path):
    # Read CSV file
    df = pd.read_csv(csv_path, parse_dates=[0], index_col=0)
    
    # Convert to xarray Dataset
    ds = xr.Dataset.from_dataframe(df)
    
    # Save as NetCDF
    ds.to_netcdf(nc_path, format='NETCDF4')
    print(f"Data saved to {nc_path}")

def convert_all_csv_to_nc(mat_file):
    # Load MATLAB .mat file
    mat_data = sio.loadmat(mat_file)
    basins_all = mat_data['basins_all']
    
    for i in range(len(basins_all)):
        print(i)
        gage_id = str(basins_all[i]['GAGE_ID'][0][0])
        csv_path = f"Data/CAMELS_Final/{gage_id}.csv"
        nc_path = f"Data/CAMELSH/timeseries/{gage_id}.nc"
        csv_to_netcdf(csv_path, nc_path)

# Example usage
mat_file = 'results/R2_Basin_info.mat'
convert_all_csv_to_nc(mat_file)


import os
import subprocess

def compress_with_7z(nc_folder, zip_name):
    """Compresses all NetCDF files in a folder into a 7z archive with high compression."""
    if not os.path.exists(nc_folder):
        print(f"Error: Folder {nc_folder} does not exist.")
        return

    # Construct 7z command
    command = [
        "7z", "a", "-t7z", zip_name,  # Create a .7z archive
        nc_folder,                    # Target folder to compress
        "-mx=9",                       # Maximum compression level
        "-mmt=on"                      # Enable multi-threading (faster compression)
    ]

    # Run command
    try:
        subprocess.run(command, check=True)
        print(f"Compression successful: {zip_name}")
    except subprocess.CalledProcessError as e:
        print(f"Compression failed: {e}")

# Paths to compress
folders = [
    ("Data/CAMELSH/timeseries", "Data/CAMELSH/timeseries.7z"),
    ("Data/CAMELSH/timeseries_nonobs", "Data/CAMELSH/timeseries_nonobs.7z")
]

# Compress each folder
for nc_folder, zip_name in folders:
    compress_with_7z(nc_folder, zip_name)
