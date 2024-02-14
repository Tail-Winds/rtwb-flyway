
<!-- README.md is generated from README.Rmd. Please edit that file -->

# rtwb-flyway

<!-- badges: start -->
<!-- badges: end -->

Use GitHub Actions continuous integration to plot WHOI near-real-time
whale buoy (RTWB) detections for various species in the Mid-Atlantic
Flyway.

## Data sources

- RTWB
  - <http://robots4whales.whoi.edu/>
- Natural Earth
  - <https://www.naturalearthdata.com/http//www.naturalearthdata.com/download/110m/physical/ne_110m_land.zip>
- USA critical habitat
  - <https://noaa.maps.arcgis.com/home/item.html?id=3115892b737a447abe2affa7e773701c>
- CAN critical habitat
  - <https://open.canada.ca/data/en/dataset/db177a8c-5d7d-49eb-8290-31e6a45d786c>
- Slow zones

## Desired output

- Table with columns:
  - date
  - species
  - detected
  - slow_zone_id
  - slow_zone_active
- Figures (5; 4 facets, 1 per species):
  - All:
    - Coastline in OMERC projection
    - Critical habitat polygons
  - Yesterday: 4 plots, 1 per species
    - RTWB location filled if present, point if absent
    - slow zone polygon filled if active, transparent if not
  - 2 days ago
  - One-week running mean
  - Two-week running mean
  - One-month running mean
