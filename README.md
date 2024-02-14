
<!-- README.md is generated from README.Rmd. Please edit that file -->

# rtwb-flyway

<!-- badges: start -->
<!-- badges: end -->

Use GitHub Actions continuous integration to plot WHOI near-real-time
whale buoy (RTWB) detections for various species in the Mid-Atlantic
Flyway.

## Data sources

- RTWB
- Natural Earth
- USA critical habitat
- CAN critical habitat
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
