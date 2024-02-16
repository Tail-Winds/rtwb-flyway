
<!-- README.md is generated from README.Rmd. Please edit that file -->

# rtwb-flyway

<!-- badges: start -->
<!-- badges: end -->

Currently deployed at <https://tailwinds.umces.edu/rtwb-flyway>

## What is this?

Use [R targets](https://docs.ropensci.org/targets/) and GitHub Actions
continuous integration to plot WHOI near-real-time whale buoy (RTWB)
detections for various species in the Mid-Atlantic Flyway.

Basically, an in-house version of <https://whalemap.org/> that also
includes fin, sei, and humpback whales.

Dashboard is updated every day at 05:00 UTC or on demand. The last run
occurred at 2024-02-16 20:09:04.

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
  - slow_zone_id
  - slow_zone_active
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

``` mermaid
graph LR
  style Legend fill:#FFFFFF00,stroke:#000000;
  style Graph fill:#FFFFFF00,stroke:#000000;
  subgraph Legend
    direction LR
    x0a52b03877696646([""Outdated""]):::outdated --- x7420bd9270f8d27d([""Up to date""]):::uptodate
    x7420bd9270f8d27d([""Up to date""]):::uptodate --- xbf4603d6c2c2ad6b([""Stem""]):::none
    xbf4603d6c2c2ad6b([""Stem""]):::none --- x70a5fa6bea6f298d[""Pattern""]:::none
    x70a5fa6bea6f298d[""Pattern""]:::none --- xf0bce276fe2b9d3e>""Function""]:::none
  end
  subgraph Graph
    direction LR
    x9f056268bcaf484c(["coastline_midatl"]):::outdated --> x5143ae3bdfbc5e1b(["last_month"]):::outdated
    x006ddd8351612b3e>"flyway_plot_summary"]:::uptodate --> x5143ae3bdfbc5e1b(["last_month"]):::outdated
    x32f78397cebde190(["narw_critical_habitat"]):::outdated --> x5143ae3bdfbc5e1b(["last_month"]):::outdated
    x17b3c6c5f2f97a8a(["narw_seasonal_management_areas"]):::outdated --> x5143ae3bdfbc5e1b(["last_month"]):::outdated
    x5fc1f85cdae42a15(["whale_detections"]):::outdated --> x5143ae3bdfbc5e1b(["last_month"]):::outdated
    x9f056268bcaf484c(["coastline_midatl"]):::outdated --> xfd50dd5ee08cb00e(["yesterday"]):::outdated
    x29978318f74a1f1a>"flyway_plot"]:::uptodate --> xfd50dd5ee08cb00e(["yesterday"]):::outdated
    x32f78397cebde190(["narw_critical_habitat"]):::outdated --> xfd50dd5ee08cb00e(["yesterday"]):::outdated
    x17b3c6c5f2f97a8a(["narw_seasonal_management_areas"]):::outdated --> xfd50dd5ee08cb00e(["yesterday"]):::outdated
    x5fc1f85cdae42a15(["whale_detections"]):::outdated --> xfd50dd5ee08cb00e(["yesterday"]):::outdated
    x6f114575981f728f>"r4w_scrape"]:::uptodate --> xc1ace7b91afbb712["whale_detections_raw"]:::outdated
    xbc96fea7a3a6c834(["rtwb_urls"]):::outdated --> xc1ace7b91afbb712["whale_detections_raw"]:::outdated
    x4ebdc012c833dea9>"add_detection_range"]:::uptodate --> x5fc1f85cdae42a15(["whale_detections"]):::outdated
    x498842ceb8b647f9(["detection_range"]):::outdated --> x5fc1f85cdae42a15(["whale_detections"]):::outdated
    xc1ace7b91afbb712["whale_detections_raw"]:::outdated --> x5fc1f85cdae42a15(["whale_detections"]):::outdated
    xb9ffe861cb7124d8(["day_before"]):::outdated --> x7b5b71e4271dec15(["flyway_dashboard"]):::outdated
    x5143ae3bdfbc5e1b(["last_month"]):::outdated --> x7b5b71e4271dec15(["flyway_dashboard"]):::outdated
    xd4e3cb7cdf26cbd3(["last_week"]):::outdated --> x7b5b71e4271dec15(["flyway_dashboard"]):::outdated
    xfd50dd5ee08cb00e(["yesterday"]):::outdated --> x7b5b71e4271dec15(["flyway_dashboard"]):::outdated
    x51f7d0055c0e8771(["coastline"]):::outdated --> x9f056268bcaf484c(["coastline_midatl"]):::outdated
    x9f056268bcaf484c(["coastline_midatl"]):::outdated --> xb9ffe861cb7124d8(["day_before"]):::outdated
    x29978318f74a1f1a>"flyway_plot"]:::uptodate --> xb9ffe861cb7124d8(["day_before"]):::outdated
    x32f78397cebde190(["narw_critical_habitat"]):::outdated --> xb9ffe861cb7124d8(["day_before"]):::outdated
    x17b3c6c5f2f97a8a(["narw_seasonal_management_areas"]):::outdated --> xb9ffe861cb7124d8(["day_before"]):::outdated
    x5fc1f85cdae42a15(["whale_detections"]):::outdated --> xb9ffe861cb7124d8(["day_before"]):::outdated
    x9f056268bcaf484c(["coastline_midatl"]):::outdated --> xd4e3cb7cdf26cbd3(["last_week"]):::outdated
    x006ddd8351612b3e>"flyway_plot_summary"]:::uptodate --> xd4e3cb7cdf26cbd3(["last_week"]):::outdated
    x32f78397cebde190(["narw_critical_habitat"]):::outdated --> xd4e3cb7cdf26cbd3(["last_week"]):::outdated
    x17b3c6c5f2f97a8a(["narw_seasonal_management_areas"]):::outdated --> xd4e3cb7cdf26cbd3(["last_week"]):::outdated
    x5fc1f85cdae42a15(["whale_detections"]):::outdated --> xd4e3cb7cdf26cbd3(["last_week"]):::outdated
  end
  classDef outdated stroke:#000000,color:#000000,fill:#78B7C5;
  classDef uptodate stroke:#000000,color:#ffffff,fill:#354823;
  classDef none stroke:#000000,color:#000000,fill:#94a4ac;
  linkStyle 0 stroke-width:0px;
  linkStyle 1 stroke-width:0px;
  linkStyle 2 stroke-width:0px;
  linkStyle 3 stroke-width:0px;
```
