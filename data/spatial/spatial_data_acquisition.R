library(sf)

## RTWB locations ----
#   Assembled 2024-02-14
rtwbs <- read.csv(
  text = 
    'station, latitude, longitude, url
  nybnw, 40.4, -73.5, http://dcs.whoi.edu/nybnw0723/nybnw0723_nybnw.shtml
  nybse, 40.25, -73.2, http://dcs.whoi.edu/nybse0823/nybse0823_nybse.shtml
  njatl, 39.1, -74.1, http://dcs.whoi.edu/njatl0224/njatl0224_njatl.shtml
  mdoc, 38.4, -74.6, http://dcs.whoi.edu/mdoc1023/mdoc1023_mdoc.shtml
  vacc, 37.2, -75.2, http://dcs.whoi.edu/vacc1023/vacc1023_vacc.shtml
  vanf, 36.6, -75.4, http://dcs.whoi.edu/vanf1023/vanf1023_vanf.shtml',
  strip.white = TRUE
) |> 
  st_as_sf(
    coords = c('longitude', 'latitude'),
    crs = 4326
  )

st_write(rtwbs, 'data/spatial/rtwbs.gpkg', delete_dsn = FALSE)


## Detection range key ---
detection_range_key <- expand.grid(
  species = paste(c("Right", "Humpback", "Sei", "Fin"), "whale", sep = ' '),
  station = rtwbs$station
) |> 
  right_join(rtwbs, by = join_by(station)) |> 
  mutate(geometry = case_when(
    grepl("Right|Hump", species) ~ st_buffer(geometry, 1e4),
    species == "Sei whale" ~ st_buffer(geometry, 1.2e4),
    species == "Fin whale" ~ st_buffer(geometry, 15e5))
  )

st_write(detection_range_key, "data/spatial/detection_range_key.gpkg")

## Natural Earth ----
#   Downloaded 2024-02-14
coastline <- paste0(
  '/vsizip/vsicurl/',
  'https://www.naturalearthdata.com/',
  'http//www.naturalearthdata.com/download/110m/physical/ne_110m_land.zip/',
  'ne_110m_land.shp'
) |> 
  st_read()

st_write(coastline, 'data/spatial/coastline.gpkg', delete_dsn = FALSE)


## USA NARW critical habitat ----
#   Downloaded 2024-02-14
#   https://noaa.maps.arcgis.com/home/item.html?id=3115892b737a447abe2affa7e773701c
narw_usa <- paste0(
  '/vsizip/',
  'data/spatial/WhaleNorthAtlanticRight_20160127.zip/',
  'WhaleNorthAtlanticRight_20160127.shp'
) |> 
  st_read()

st_write(narw_usa, 'data/spatial/narw_usa.gpkg', delete_dsn = FALSE)


## CAN NARW critical habitat ----
#   Downloaded 2024-02-14
#   https://open.canada.ca/data/en/dataset/db177a8c-5d7d-49eb-8290-31e6a45d786c
narw_can <- paste0(
  'https://gisp.dfo-mpo.gc.ca/arcgis/rest/services/FGP/',
  'DFO_SARA_CriticalHabitat/MapServer/0/query?',
  'where=Common_Name_EN+LIKE+%27%25North+Atlantic+Right+Whale%25%27',
  '&outFields=*&f=geojson'
) |> 
  st_read()

st_write(narw_can, 'data/spatial/narw_can.gpkg', delete_dsn = FALSE)


## NARW seasonal management areas ----
#   Downloaded 2024-02-14
#
narw_sma <- paste0(
  "https://services2.arcgis.com/C8EMgrsFcRFL6LrL/arcgis/rest/services/",
  "Seasonal_Management_Areas/FeatureServer/3/query?",
  "where=gid+LIKE+%27%25%27&outFields=*&f=geojson"
) |> 
  st_read()

st_write(narw_sma, 'data/spatial/narw_sma.gpkg', delete_dsn = FALSE)
