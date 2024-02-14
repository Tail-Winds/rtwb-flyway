library(sf)
# Custom Oblique Mercator projection
projection <- st_crs("+proj=omerc +lat_0=40 +lonc=-74 +gamma=-40")

# RTWB locations
rtwb_locations <- read.csv(text = 
  'name, latitude, longitude
  nybnw, 40.4, -73.5
  nybse, 40.25, -73.2
  njatl, 39.1, -74.1
  mdoc, 38.4, -74.6
  vacc, 37.2, -75.2
  vanf, 36.6, -75.4'
) |> 
  st_as_sf(
    coords = c('longitude', 'latitude'),
    crs = 4326
  ) |> 
  st_transform(projection)


# Coastline
coastline <- st_read('data/spatial/coastline.gpkg',
                     quiet = TRUE) |> 
  st_make_valid() |> 
  # Crop to eastern seaboard
  st_intersection(
    st_bbox(c(xmin = -90, xmax = -50,
              ymin = 33, ymax = 60), crs = 4326) |> 
      st_as_sfc() 
  ) |> 
  st_transform(projection)

# NARW critical habitat, USA
narw_usa <- st_read('data/spatial/narw_usa.gpkg',
                    quiet = TRUE) |> 
  st_transform(projection)

# NARW critical habitat, CAN
narw_can <- st_read('data/spatial/narw_can.gpkg',
                    quiet = TRUE) |> 
  st_transform(projection)


library(ggplot2)


ggplot() +
  geom_sf(data = coastline) +
  geom_sf(data = rtwb_locations) +
  geom_sf(data = narw_usa, fill = 'pink', color = NA, alpha = 0.5) +
  coord_sf(xlim = c(-1e5, 3e5),
           ylim = c(-5e5, 6e5),
           crs = projection) +
  theme_minimal() 
