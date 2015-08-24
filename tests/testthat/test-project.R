context('Reading shapefiles and dbf files')

test_that('Both shapefiles and dbf files are correctly read', {
  require(rgdal)
  require(foreign)
  
  td <- data.frame(x=1:5, y = rnorm(5))
  tp <- SpatialPointsDataFrame(expand.grid(x = 1:4, y = 1:4),
                               data.frame(z = 1:16))
  
  create.project('testproject')
  wd <- setwd('testproject')
  on.exit({
    ## cleanup
    setwd(wd)
    unlink('testproject', recursive = TRUE)
    rm(writen.td, writen.tp, envir = .GlobalEnv)
  })
  
  ## Write a dummy xls data file
  foreign::write.dbf(td, file = 'data/writen_td.dbf')
  rgdal::writeOGR(tp, 'data', 'writen_tp', driver = 'ESRI Shapefile')
  
  ## Load project (and data)
  sink('/dev/null')
  load.project()
  sink()
  
  ## checks
  expect_equal(td, writen.td, check.attributes = FALSE)
  expect_equal(tp, writen.tp, check.attributes = FALSE)
})
