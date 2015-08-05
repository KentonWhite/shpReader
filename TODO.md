- There is an extension conflict issue with shapefiles:
  - a shapefile is specified using at least three actual files with extensions .shp, .shx and .dbf)
  - this last file is recognized by `ProjectTemplate` as an XBASE format
  - this is read using `package:foreign`, **before** the `.shp` file (due to alphabetical ordering)
  - when the time comes for the `.shp` extension, the base name of the file is found in memory and thus skipped

This is a design problem in `.load.data()`. It is assumed implicitly that each recognized file corresponds to one object.
While in the case of shapefiles this is not the case.
