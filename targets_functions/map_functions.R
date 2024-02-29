flyway_plot <- function(data_subset,
                        narw_usa,
                        narw_sma,
                        slow_zones,
                        coastline){
  # narw_sma <- 
  projection <- st_crs("+proj=omerc +lat_0=40 +lonc=-74 +gamma=-40")
  coastline <- st_transform(coastline, projection)
  narw_usa <- st_transform(narw_usa, projection)
  narw_sma <- st_transform(narw_sma, projection)
  sz <- st_transform(slow_zones, projection)
  data_subset <- st_transform(data_subset, projection)
  
  narw_plot <- ggplot() + 
    geom_sf(data = sz, fill = 'yellow', color = NA) +
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
  
  sei_plot <- ggplot() +
    geom_sf(data = filter(data_subset, species == 'Sei whale'),
            aes(fill = detected, alpha = detected, geometry = geom),
            show.legend = FALSE, color = NA) +
    geom_sf(data = coastline) +
    scale_fill_manual(values = c("black", "red")) +
    scale_alpha_manual(values = c(0.1, 1)) +
    coord_sf(xlim = c(-1e5, 3e5),
             ylim = c(-5e5, 6e5),
             crs = projection) +
    labs(subtitle = 'Sei whale') +
    theme_minimal()
  
  humpback_plot <- ggplot() +
    geom_sf(data = filter(data_subset, species == 'Humpback whale'),
            aes(fill = detected, alpha = detected, geometry = geom),
            show.legend = FALSE, color = NA) +
    geom_sf(data = coastline) +
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



flyway_plot_summary <- function(data_subset,
                                narw_usa,
                                narw_sma,
                                coastline){
  projection <- st_crs("+proj=omerc +lat_0=40 +lonc=-74 +gamma=-40")
  coastline <- st_transform(coastline, projection)
  narw_usa <- st_transform(narw_usa, projection)
  narw_sma <- st_transform(narw_sma, projection)
  
  data_subset <- st_transform(data_subset, projection)
  
  narw_plot <-
    ggplot() + 
    geom_sf(data = narw_usa, fill = 'pink', color = NA, alpha = 0.5) +
    labs(subtitle = 'NARW') +
    geom_sf(data = narw_sma, fill = 'red', alpha = 0.5) +
    geom_sf(data = filter(data_subset, species == 'Right whale'),
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
    scale_fill_viridis_c(option = "H") +
    coord_sf(xlim = c(-1e5, 3e5),
             ylim = c(-5e5, 6e5),
             crs = projection) +
    labs(subtitle = 'Fin whale') +
    theme_minimal()
  
  sei_plot <- ggplot() +
    geom_sf(data = filter(data_subset, species == 'Sei whale'),
            aes(fill = pct, geometry = geom), color = NA) +
    geom_sf(data = coastline) +
    scale_fill_viridis_c(option = "H") +
    coord_sf(xlim = c(-1e5, 3e5),
             ylim = c(-5e5, 6e5),
             crs = projection) +
    labs(subtitle = 'Sei whale') +
    theme_minimal()
  
  humpback_plot <- ggplot() +
  geom_sf(data = filter(data_subset, species == 'Humpback whale'),
          aes(fill = pct, geometry = geom),
          color = NA) +
    geom_sf(data = coastline) +
    scale_fill_viridis_c(option = "H") +
    coord_sf(xlim = c(-1e5, 3e5),
             ylim = c(-5e5, 6e5),
             crs = projection) +
    labs(subtitle = 'Humpback') +
    theme_minimal() 
  
  
  
  narw_plot + fin_plot + sei_plot + humpback_plot +
    plot_layout(nrow = 1, guides = 'collect')
}
