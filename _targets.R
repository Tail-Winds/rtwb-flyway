# Created by use_targets().
# Follow the comments below to fill in this target script.
# Then follow the manual to check and run the pipeline:
#   https://books.ropensci.org/targets/walkthrough.html#inspect-the-pipeline

# Load packages required to define the pipeline:
library(targets)
library(tarchetypes) # Load other packages as needed.

# Set target options:
tar_option_set(
  packages = c(
    "rvest", "dplyr", "tidyr", "lubridate", "sf", "ggplot2",
    "patchwork"
  ), 
  format = "qs"
  #
  # For distributed computing in tar_make(), supply a {crew} controller
  # as discussed at https://books.ropensci.org/targets/crew.html.
  # Choose a controller that suits your needs. For example, the following
  # sets a controller with 2 workers which will run as local R processes:
  #
  #   controller = crew::crew_controller_local(workers = 2)
  #
  # Alternatively, if you want workers to run on a high-performance computing
  # cluster, select a controller from the {crew.cluster} package. The following
  # example is a controller for Sun Grid Engine (SGE).
  # 
  #   controller = crew.cluster::crew_controller_sge(
  #     workers = 50,
  #     # Many clusters install R as an environment module, and you can load it
  #     # with the script_lines argument. To select a specific verison of R,
  #     # you may need to include a version string, e.g. "module load R/4.3.0".
  #     # Check with your system administrator if you are unsure.
  #     script_lines = "module load R"
  #   )
  #
  # Set other options as needed.
)

# tar_make_clustermq() is an older (pre-{crew}) way to do distributed computing
# in {targets}, and its configuration for your machine is below.
# options(clustermq.scheduler = "multiprocess")

# tar_make_future() is an older (pre-{crew}) way to do distributed computing
# in {targets}, and its configuration for your machine is below.
# Install packages {{future}}, {{future.callr}}, and {{future.batchtools}} to allow use_targets() to configure tar_make_future() options.

# Run the R scripts in the R/ folder with your custom functions:
tar_source("targets_functions")
# source("other_functions.R") # Source other scripts as needed.

# Replace the target list below with your own:
list(
  tar_target(
    name = narw_critical_habitat,
    command = st_read('data/spatial/narw_usa.gpkg')
  ),
  tar_target(
    name = narw_seasonal_management_areas,
    command = st_read('data/spatial/narw_sma.gpkg')
  ),
  tar_target(
    name = coastline,
    command = st_read('data/spatial/coastline.gpkg') |> 
      st_make_valid()
  ),
  tar_target(
    name = coastline_midatl,
    command = coastline |> 
      st_intersection(
        st_bbox(c(xmin = -80, xmax = -50,
                  ymin = 30, ymax = 50), crs = 4326) |> 
          st_as_sfc() 
      )
  ),
  tar_target(
    name = rtwb_urls,
    command = st_read('data/spatial/rtwbs.gpkg')$url
  ),
  tar_target(
    name = detection_range,
    command = st_read('data/spatial/detection_range_key.gpkg')
  ),
  tar_age(
    name = whale_detections_raw,
    command = r4w_scrape(rtwb_urls),
    age = as.difftime(23, units = "hours"),
    pattern = map(rtwb_urls)
  ),
  tar_target(
    name = whale_detections,
    command = add_detection_range(whale_detections_raw, detection_range)
  ),
  
  tar_target(
    name = slow_zones,
    command = scrape_slow_zones(
      "https://www.fisheries.noaa.gov/national/endangered-species-conservation/reducing-vessel-strikes-north-atlantic-right-whales"
    )),
  
  tar_target(
    name = yesterday,
    command = flyway_plot(
      whale_detections[whale_detections$Date == Sys.Date() - 1,],
      narw_usa = narw_critical_habitat,
      narw_sma = narw_seasonal_management_areas,
      coastline = coastline_midatl,
      slow_zones = slow_zones[slow_zones$start_date <= Sys.Date() - 1 &
                                slow_zones$end_date >= Sys.Date() - 1]
    )
  ),
  tar_target(
    name = day_before,
    command = flyway_plot(
      whale_detections[whale_detections$Date == Sys.Date() - 2,],
      narw_usa = narw_critical_habitat,
      narw_sma = narw_seasonal_management_areas,
      coastline = coastline_midatl,
      slow_zones = slow_zones[slow_zones$start_date <= Sys.Date() - 2 &
                                slow_zones$end_date >= Sys.Date() - 2]
    )
  ),
  tar_target(
    name = last_week,
    command = flyway_plot_summary(
      whale_detections |> 
        filter(Date %in% seq.Date(Sys.Date() - 7, Sys.Date() - 1, by = "day")) |> 
        group_by(species, station) |> 
        summarize(pct = n() / 7),
      narw_usa = narw_critical_habitat,
      narw_sma = narw_seasonal_management_areas,
      coastline = coastline_midatl,
      slow_zones = slow_zones[slow_zones$start_date <= Sys.Date() - 1 &
                                slow_zones$end_date >= Sys.Date() - 1]
    )
  ),
  tar_target(
    name = last_month,
    command = flyway_plot_summary(
      whale_detections |> 
        filter(Date %in% seq.Date(Sys.Date() - 31, Sys.Date() - 1, by = "day")) |> 
        group_by(species, station) |> 
        summarize(pct = n() / 30),
      narw_usa = narw_critical_habitat,
      narw_sma = narw_seasonal_management_areas,
      coastline = coastline_midatl,
      slow_zones = slow_zones[slow_zones$start_date <= Sys.Date() - 1 &
                                slow_zones$end_date >= Sys.Date() - 1]
    )
  ),
  
  tar_quarto(
    flyway_dashboard,
    "index.qmd"
  )
)
