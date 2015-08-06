#' Read a shapefile described in a .shp file.
#'
#' This function will load data from an ESRI shapefile
#'
#' @param data.file The name of the data file to be read.
#' @param filename The path to the data set to be loaded.
#' @param variable.name The name to be assigned to in the global environment.
#'
#' @return No value is returned; this function is called for its side effects.
#'
#' @importFrom rgdal readGDAL readOGR
#' @import sp
#'
#' @examples
#' library('ProjectTemplate')
#'
#' \dontrun{shp.reader('example.shp', 'data/example.shp', 'example')}
shp.reader <- function(data.file, filename, variable.name)
{
  dn <- dirname(filename)
  bn <- sub('\\.shp$', '', basename(filename))
  
  ef <- function(e) {
    warning(paste("The shapefile", bn, "didn't load correctly."))
  }
  
  tryCatch(assign(variable.name,
                  rgdal::readOGR(dsn = dn, layer = bn),
                  envir = .GlobalEnv),
           error = ef)
  
}

#' Overriden dbf reader
#' 
#' This alternative reader avoids loading shapefiles' dbf companion files as if
#' they were XBASE files
#' 
#' @param data.file The name of the data file to be read.
#' @param filename The path to the data set to be loaded.
#' @param variable.name The name to be assigned to in the global environment.
dbf.reader <- function(data.file, filename, variable.name)
{
  bn <- sub('\\.dbf$', '', basename(filename))
  
  ## Only call the original dbf reader if there is no .shp file
  ## with the same basename
  if (!file.exists(sub('\\.dbf', '\\.shp', filename))) {
    .TargetEnv <- .GlobalEnv
    do.call(ProjectTemplate:::dbf.reader, 
            list(data.file, filename, variable.name))
  }
  
  ## Otherwise don't do anything, and ProjectTemplate
  ## will eventually process the .shp extension
}


#' @import ProjectTemplate
.onLoad <- function(...)
{
  ## Register new and overriden readers
	.add.extension('shp', shp.reader)
	.add.extension('dbf', dbf.reader)
}



