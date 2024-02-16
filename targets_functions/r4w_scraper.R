
r4w_scrape <- function(r4w_url) {
  # library(rvest)
  # library(dplyr)
  # library(tidyr)
  # library(lubridate)
  # library(sf)
  
  
  whales_html <- read_html(
    r4w_url
  ) 
  
  # Pull out the table using the XPath
  # (Ctrl + Shift + I in Chrome, then:
  #   right click the element > Copy > Copy Full XPath)
  whales <- whales_html |> 
    html_element(xpath = '/html/body/table[1]') |> 
    html_table()
  
  # The "style" HTML attribute encodes the information.
  # Pull out the "style" attribute from each table row, found using the XPath
  colors <- whales_html |> 
    html_elements(xpath = '/html/body/table[1]/tr/td')|> 
    html_attr('style')
  
  # There are other "style" attributes. Use base::grepl to pull out anything that
  # contains the text "background-color"
  colors <- colors[grepl('background-color', colors)]
  
  # Use base::gsub to substitute the text "background-color:" with nothing
  #   (delete the text "background-color:" from everything, leaving just the color)
  colors <- gsub('background-color:', '', colors)
  
  # This has created a character vector, but it's really a 4-column matrix with
  #   the same amount of rows as the "whales" data frame made above.
  # Tell R this is a 4-column matrix, byrow meaning it's
  #   "Row 1, Row 1, Row 1, Row 1,
  #    Row 2, Row 2, Row 2, Row 2, etc.
  # AND directly replace the corresponding columns of the "whales" data frame
  whales[, 2:5] <- matrix(colors, ncol = 4, byrow = T)
  
  # Convert written colors to D/PD/ND
  whales <- whales |>
    mutate(
      # For every column ("across everything") convert the color text to the
      #   corresponding detection information
      across(
        everything(),
        ~ case_when(. == 'lightgray' ~ 'not detected',
                    . == 'yellow' ~ 'possibly detected',
                    . == 'red' ~ 'detected',
                    T ~ .)
      ),
      # Convert the "Date" column to R's Date class
      Date = as.Date(Date, format = '%m/%d/%Y')
    ) |> 
    pivot_longer(cols = contains('whale'),
                 names_to = 'species',
                 values_to = 'detected')
  
  
  whales <- whales |> 
    mutate(station = gsub('.*_|\\..*', '', r4w_url))
  
  whales
}


add_detection_range <- function(whale_detections, detection_range){
  whales <- whale_detections |>
    right_join(detection_range, by = join_by(station, species)) |>
    mutate(detected = if_else(detected == "detected", TRUE, FALSE)) |>
    sf::st_as_sf()
  
  whales
}


# combine_rtwb <- function(rtwbs){
#   # rtwbs <- st_read('data/spatial/rtwbs.gpkg')
# 
#   whale_detections <- apply(
#     X = rtwbs,
#     MARGIN = 1,
#     function(.){
#       detections <- r4w_scrape(.$url)
#       mutate(detections, station = .$station)
#     }
#   ) |>
#     bind_rows() |>
#     pivot_longer(cols = contains('whale'),
#                  names_to = 'species',
#                  values_to = 'detected')
# 
#   whale_detections
# }
# 
# 
# 
# 
# detection_range <- st_read("data/spatial/detection_range_key.gpkg")
# 
# wd <- whale_detections |>
#   right_join(detection_range, by = join_by(station, species)) |>
#   mutate(detected = if_else(detected == "detected", TRUE, FALSE)) |>
#   st_as_sf()
# 
# 
# st_write(wd, "data/rtwb_detections.gpkg", delete_dsn = TRUE)
