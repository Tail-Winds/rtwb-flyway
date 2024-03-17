
<!-- README.md is generated from README.Rmd. Please edit that file -->

# rtwb-flyway

<!-- badges: start -->

<!-- badges: end -->

This dashboard is currently deployed at
<https://tailwinds.umces.edu/rtwb-flyway>.

## What is this?

Use [R targets](https://docs.ropensci.org/targets/) and GitHub Actions
continuous integration to plot WHOI near-real-time whale buoy (RTWB)
detections for various species in the Mid-Atlantic Flyway.

Basically, an in-house version of <https://whalemap.org/> that also
includes fin, sei, and humpback whales.

Dashboard is updated every day at 05:00 UTC or on demand. The last run
occurred at 2024-03-17 05:04:49.

## Data sources

  - RTWB
      - <http://robots4whales.whoi.edu/>
  - Natural Earth
      - <https://www.naturalearthdata.com/http//www.naturalearthdata.com/download/110m/physical/ne_110m_land.zip>
  - USA NARW critical habitat
      - <https://noaa.maps.arcgis.com/home/item.html?id=3115892b737a447abe2affa7e773701c>
  - CAN NARW critical habitat
      - <https://open.canada.ca/data/en/dataset/db177a8c-5d7d-49eb-8290-31e6a45d786c>
  - NOAA NARW seasonal management areas
      - <https://www.fisheries.noaa.gov/resource/map/north-atlantic-right-whale-seasonal-management-areas-sma>  
  - Slow zones

## Desired output

  - Table with columns:
      - date
      - species
      - detected
      - slow\_zone\_id
      - slow\_zone\_active
  - Figures (5; 4 facets, 1 per species):
      - All:
          - [x] Coastline in OMERC projection
          - [x] Critical habitat polygons
      - Yesterday: 4 plots, 1 per species
          - RTWB location filled if present, point if absent
          - slow zone polygon filled if active, transparent if not
      - 2 days ago
      - One-week running mean
      - Two-week running mean
      - One-month running mean

## Example plot

![](README_files/figure-gfm/unnamed-chunk-2-1.png)<!-- -->

## Repository `targets` workflow:

``` mermaid
graph LR
  style Legend fill:#FFFFFF00,stroke:#000000;
  style Graph fill:#FFFFFF00,stroke:#000000;
  subgraph Legend
    direction LR
    x7420bd9270f8d27d([""Up to date""]):::uptodate --- xbf4603d6c2c2ad6b([""Stem""]):::none
    xbf4603d6c2c2ad6b([""Stem""]):::none --- x70a5fa6bea6f298d[""Pattern""]:::none
    x70a5fa6bea6f298d[""Pattern""]:::none --- xf0bce276fe2b9d3e>""Function""]:::none
  end
  subgraph Graph
    direction LR
    x9f056268bcaf484c(["coastline_midatl"]):::uptodate --> x5143ae3bdfbc5e1b(["last_month"]):::uptodate
    x006ddd8351612b3e>"flyway_plot_summary"]:::uptodate --> x5143ae3bdfbc5e1b(["last_month"]):::uptodate
    x32f78397cebde190(["narw_critical_habitat"]):::uptodate --> x5143ae3bdfbc5e1b(["last_month"]):::uptodate
    x17b3c6c5f2f97a8a(["narw_seasonal_management_areas"]):::uptodate --> x5143ae3bdfbc5e1b(["last_month"]):::uptodate
    xe2cc1738a9b9cdfb(["slow_zones"]):::uptodate --> x5143ae3bdfbc5e1b(["last_month"]):::uptodate
    x5fc1f85cdae42a15(["whale_detections"]):::uptodate --> x5143ae3bdfbc5e1b(["last_month"]):::uptodate
    x9f056268bcaf484c(["coastline_midatl"]):::uptodate --> xfd50dd5ee08cb00e(["yesterday"]):::uptodate
    x29978318f74a1f1a>"flyway_plot"]:::uptodate --> xfd50dd5ee08cb00e(["yesterday"]):::uptodate
    x32f78397cebde190(["narw_critical_habitat"]):::uptodate --> xfd50dd5ee08cb00e(["yesterday"]):::uptodate
    x17b3c6c5f2f97a8a(["narw_seasonal_management_areas"]):::uptodate --> xfd50dd5ee08cb00e(["yesterday"]):::uptodate
    xe2cc1738a9b9cdfb(["slow_zones"]):::uptodate --> xfd50dd5ee08cb00e(["yesterday"]):::uptodate
    x5fc1f85cdae42a15(["whale_detections"]):::uptodate --> xfd50dd5ee08cb00e(["yesterday"]):::uptodate
    x6f114575981f728f>"r4w_scrape"]:::uptodate --> xc1ace7b91afbb712["whale_detections_raw"]:::uptodate
    xbc96fea7a3a6c834(["rtwb_urls"]):::uptodate --> xc1ace7b91afbb712["whale_detections_raw"]:::uptodate
    x4ebdc012c833dea9>"add_detection_range"]:::uptodate --> x5fc1f85cdae42a15(["whale_detections"]):::uptodate
    x498842ceb8b647f9(["detection_range"]):::uptodate --> x5fc1f85cdae42a15(["whale_detections"]):::uptodate
    xc1ace7b91afbb712["whale_detections_raw"]:::uptodate --> x5fc1f85cdae42a15(["whale_detections"]):::uptodate
    xb9ffe861cb7124d8(["day_before"]):::uptodate --> x7b5b71e4271dec15(["flyway_dashboard"]):::uptodate
    x5143ae3bdfbc5e1b(["last_month"]):::uptodate --> x7b5b71e4271dec15(["flyway_dashboard"]):::uptodate
    xd4e3cb7cdf26cbd3(["last_week"]):::uptodate --> x7b5b71e4271dec15(["flyway_dashboard"]):::uptodate
    xfd50dd5ee08cb00e(["yesterday"]):::uptodate --> x7b5b71e4271dec15(["flyway_dashboard"]):::uptodate
    x51f7d0055c0e8771(["coastline"]):::uptodate --> x9f056268bcaf484c(["coastline_midatl"]):::uptodate
    xf3cf2ececfcedcb0>"scrape_slow_zones"]:::uptodate --> xe2cc1738a9b9cdfb(["slow_zones"]):::uptodate
    x9f056268bcaf484c(["coastline_midatl"]):::uptodate --> xb9ffe861cb7124d8(["day_before"]):::uptodate
    x29978318f74a1f1a>"flyway_plot"]:::uptodate --> xb9ffe861cb7124d8(["day_before"]):::uptodate
    x32f78397cebde190(["narw_critical_habitat"]):::uptodate --> xb9ffe861cb7124d8(["day_before"]):::uptodate
    x17b3c6c5f2f97a8a(["narw_seasonal_management_areas"]):::uptodate --> xb9ffe861cb7124d8(["day_before"]):::uptodate
    xe2cc1738a9b9cdfb(["slow_zones"]):::uptodate --> xb9ffe861cb7124d8(["day_before"]):::uptodate
    x5fc1f85cdae42a15(["whale_detections"]):::uptodate --> xb9ffe861cb7124d8(["day_before"]):::uptodate
    x9f056268bcaf484c(["coastline_midatl"]):::uptodate --> xd4e3cb7cdf26cbd3(["last_week"]):::uptodate
    x006ddd8351612b3e>"flyway_plot_summary"]:::uptodate --> xd4e3cb7cdf26cbd3(["last_week"]):::uptodate
    x32f78397cebde190(["narw_critical_habitat"]):::uptodate --> xd4e3cb7cdf26cbd3(["last_week"]):::uptodate
    x17b3c6c5f2f97a8a(["narw_seasonal_management_areas"]):::uptodate --> xd4e3cb7cdf26cbd3(["last_week"]):::uptodate
    xe2cc1738a9b9cdfb(["slow_zones"]):::uptodate --> xd4e3cb7cdf26cbd3(["last_week"]):::uptodate
    x5fc1f85cdae42a15(["whale_detections"]):::uptodate --> xd4e3cb7cdf26cbd3(["last_week"]):::uptodate
  end
  classDef uptodate stroke:#000000,color:#ffffff,fill:#354823;
  classDef none stroke:#000000,color:#000000,fill:#94a4ac;
  linkStyle 0 stroke-width:0px;
  linkStyle 1 stroke-width:0px;
  linkStyle 2 stroke-width:0px;
```
