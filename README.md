## Source code to generate CAMELSH: A Large-Sample Hourly Hydrometeorological Dataset and Attributes at Watershed-Scale for Contiguous United States

****** UPDATE 05/015/2025

We have increased the number of basins with observational data from 3,166 to 5,188.

In addition, we have added water level data alongside streamflow measurements.

The hourly streamflow and water level data for a total of 5,188 USGS gauges are stored in individual NetCDF files and packaged together in the Hourly.7z archive. The dataset covers the period from 1980-01-01 00:00:00 to 2024-12-31 23:00:00. Missing values are indicated by NaN.

DOI: https://doi.org/10.5281/zenodo.15413207

 

****** UPDATE 05/01/2025

ERA5-Land forcings can be downloaded here: https://doi.org/10.5281/zenodo.15264814

 

******

The current version of the CAMELSH dataset, containing data for 9,008 basins,. Due to the total data volume in the repository being approximately 57 GB, which exceeds Zenodo's size limit, we split it into two different links. The first link (https://doi.org/10.5281/zenodo.15066778) contains data on attributes, shapefiles, and time series data for the first set of basins. The second link (https://doi.org/10.5281/zenodo.14889025) contains forcing (time series) data for the the remaining basins. All data is compressed in 7zip format. After extraction, the dataset is organized into the following subfolders: 


•    The attributes folder contains 28 CSV (comma-separated values) files that store basin attributes with all files beginning with "attributes_" and one excel file. Of these, the 'attributes_nldas2_climate.csv' file contains nine climate attributes (Table 2) derived from NLDAS-2 data. The 'attributes_hydroATLAS.csv' file includes 195 basin attributes derived from the HydroATLAS dataset. 26 files with names starting with 'attributes_gageii_' contain a total of 439 basin attributes extracted from the GAGES-II dataset. The name of each file represents a distinct group of attributes, as described in Table S.1. The remaining file, named 'Var_description_gageii.xlsx', provides explanatory details regarding the variable names included in the 26 CSV files, with information similar to that presented in Table S.1. The first column in all CSV files, labeled 'STAID', contains the identification (ID) names of the stream gauges. These IDs are assigned by the USGS and are sourced from the original GAGES-II dataset.
•    The shapefiles folder contains two sets of shapefiles for the catchment boundary. The first set, CAMELSH_shapefile.shp, is derived from the original GAGES-II dataset and is used to obtain the corresponding climate forcing data for each catchment. The second set, CAMELSH_shapefile_hydroATLAS.shp, includes catchment boundaries derived from the HydroATLAS dataset. Each polygon in both shapefiles contains a field named GAGE_ID, which represents the ID of the stream gauges.
•    The timeseries (7zip) file contains a compressed archive (7zip) that includes time series data for 3,166 basins with observed streamflow data. Within this 7zip file, there are a total of 3,166 NetCDF files, each corresponding to a specific basin. The name of each NetCDF file matches the stream gauge ID. Each file contains an hourly time series from 1980-01-01 00:00:00 to 2024-12-31 23:00:00 for streamflow (denoted as "Streamflow" in the NetCDF file) and 11 climate variables (see Table 1). The streamflow data series includes missing values, which are represented as "NaN". All meteorological forcing data and streamflow records have been standardized to the +0 UTC time zone.
•    The timeseries_nonobs (7zip) file contains time series data for the remaining 5,842 basins. The structure of each NetCDF file is similar to the one described above.
•    The info.csv file, located in the main directory of the dataset, contains basic information for 9,008 stream stations. This includes the stream gauge ID, the total number of observed hourly data points over 45 years (from 1980 to 2024), and the number of observed hourly data points for each year from 1980 to 2024. Stations with and without observed data are distinguished by the value in the second column, where stations without observed streamflow data have a corresponding value of 0.

 

DOI: https://doi.org/10.5281/zenodo.15066778

https://doi.org/10.5281/zenodo.14889025

Google Drive repository: https://drive.google.com/drive/folders/15dk6qlU38LqsUkf9hiIZHXGtzzrDfl-q?usp=sharing
