#' Read a shapefile described in a .shp file.
#'
#' This function will load data from an ElasticSearch index based on configuration
#' information found in the specified .es file. The .es file must specify
#' an ElasticSearch sercer to be accessed. A specific query against any index may be executed to generate
#' a data set.
#'
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
#' \dontrun{es.reader('example.es', 'data/example.es', 'example')}
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

#' @import ProjectTemplate
.onLoad <- function(...)
{
	.add.extension('shp', shp.reader)
}



