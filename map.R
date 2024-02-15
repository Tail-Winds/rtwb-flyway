library(sf)
# Custom Oblique Mercator projection
projection <- st_crs("+proj=omerc +lat_0=40 +lonc=-74 +gamma=-40")

# RTWB detections
rtwb <- st_read('data/rtwb_detections.gpkg',
                quiet = TRUE) |> 
  st_transform(projection)


# Coastline
coastline <- st_read('data/spatial/coastline.gpkg',
                     quiet = TRUE) |> 
  st_make_valid() |> 
  # Crop to eastern seaboard
  st_intersection(
    st_bbox(c(xmin = -80, xmax = -50,
              ymin = 30, ymax = 50), crs = 4326) |> 
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

# NARW SMA
narw_sma <- st_read('data/spatial/narw_sma.gpkg',
                    quiet = TRUE) |> 
  st_transform(projection)

library(ggplot2)
library(patchwork)

yesterday <- rtwb |>
  filter(Date == Sys.Date() - 1)

day_before <- rtwb |>
  filter(Date == Sys.Date() - 2)

flyway_plot <- function(data_subset){
  narw_plot <- ggplot() + 
    geom_sf(data = narw_usa, fill = 'pink', color = NA, alpha = 0.5) +
    labs(subtitle = 'NARW') +
    geom_sf(data = narw_sma, fill = 'red', alpha = 0.5) +
    geom_sf(data = filter(data_subset, species == 'Right whale'),
            aes(fill = detected, alpha = detected, geometry = geom),
            show.legend = FALSE, color = NA) +
    geom_sf(data = coastline) + 
    scale_fill_manual(values = c("black", "red")) +
    scale_alpha_manual(values = c(0.1, 1))+
    coord_sf(xlim = c(-1e5, 3e5),
             ylim = c(-5e5, 6e5),
             crs = projection) +
    theme_minimal()
  
  fin_plot <- ggplot() +
    geom_sf(data = filter(data_subset, species == 'Fin whale'),
            aes(fill = detected, alpha = detected, geometry = geom),
            show.legend = FALSE, color = "black") +
    geom_sf(data = coastline) +
    geom_sf(data = st_centroid(filter(data_subset, species == 'Fin whale'))) +
    scale_fill_manual(values = c("black", "red")) +
    scale_alpha_manual(values = c(0.1, 1))+
    coord_sf(xlim = c(-1e5, 3e5),
             ylim = c(-5e5, 6e5),
             crs = projection) +
    labs(subtitle = 'Fin whale') +
    theme_minimal()
  
  sei_plot <- base +
    geom_sf(data = filter(data_subset, species == 'Sei whale'),
            aes(fill = detected, alpha = detected, geometry = geom),
            show.legend = FALSE, color = NA) +
    scale_fill_manual(values = c("black", "red")) +
    scale_alpha_manual(values = c(0.1, 1)) +
    coord_sf(xlim = c(-1e5, 3e5),
             ylim = c(-5e5, 6e5),
             crs = projection) +
    labs(subtitle = 'Sei whale') +
    theme_minimal()
  
  humpback_plot <- base +
    geom_sf(data = filter(data_subset, species == 'Humpback whale'),
            aes(fill = detected, alpha = detected, geometry = geom),
            show.legend = FALSE, color = NA) +
    scale_fill_manual(values = c("black", "red")) +
    scale_alpha_manual(values = c(0.1, 1)) +
    coord_sf(xlim = c(-1e5, 3e5),
             ylim = c(-5e5, 6e5),
             crs = projection) +
    labs(subtitle = 'Humpback') +
    theme_minimal() 
  
  
  
  narw_plot + fin_plot + sei_plot + humpback_plot +
    plot_layout(nrow = 1)
}

flyway_plot(yesterday)
flyway_plot(day_before)

data_subset <- rtwb |> 
  filter(Date %in% seq.Date(Sys.Date() - 7, Sys.Date() - 1, by = "day")) |> 
  group_by(species, station) |> 
  summarize(pct = n() / 7)

flyway_plot_summary <- function(data_subset){
  narw_plot <-
    ggplot() + 
    geom_sf(data = narw_usa, fill = 'pink', color = NA, alpha = 0.5) +
    labs(subtitle = 'NARW') +
    geom_sf(data = narw_sma, fill = 'red', alpha = 0.5) +
    geom_sf(data = filter(one_week, species == 'Right whale'),
            aes(fill = pct, geometry = geom),
           color = NA) +
    scale_fill_viridis_c(option = "H") +
    geom_sf(data = coastline) + 
    coord_sf(xlim = c(-1e5, 3e5),
             ylim = c(-5e5, 6e5),
             crs = projection) +
    theme_minimal()
  
  fin_plot <- ggplot() +
    geom_sf(data = filter(data_subset, species == 'Fin whale'),
            aes(fill = pct, geometry = geom),
             color = "black") +
    geom_sf(data = coastline) +
    geom_sf(data = st_centroid(filter(data_subset, species == 'Fin whale'))) +
    coord_sf(xlim = c(-1e5, 3e5),
             ylim = c(-5e5, 6e5),
             crs = projection) +
    labs(subtitle = 'Fin whale') +
    theme_minimal()
  
  sei_plot <- base +
    geom_sf(data = filter(data_subset, species == 'Sei whale'),
            aes(fill = pct, geometry = geom), color = NA) +
    coord_sf(xlim = c(-1e5, 3e5),
             ylim = c(-5e5, 6e5),
             crs = projection) +
    labs(subtitle = 'Sei whale') +
    theme_minimal()
  
  humpback_plot <- base +b
    geom_sf(data = filter(data_subset, species == 'Humpback whale'),
            aes(fill = pct, geometry = geom),
             color = NA) +
    coord_sf(xlim = c(-1e5, 3e5),
             ylim = c(-5e5, 6e5),
             crs = projection) +
    labs(subtitle = 'Humpback') +
    theme_minimal() 
  
  
  
  narw_plot + fin_plot + sei_plot + humpback_plot +
    plot_layout(nrow = 1, guides = 'collect') +scale_color_viridis_c(option = "B")
}

flyway_plot_summary(one_week)
