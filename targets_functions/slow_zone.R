scrape_slow_zones <- function(url) {
  slow_zones <- read_html(url)
  
  sz <- slow_zones |> 
    html_element(xpath = '/html/body/div[1]/main/div/section/div/div[2]/div[2]/div[2]/div/div[1]/div/div[2]/div[2]') |> 
    #https://developer.mozilla.org/en-US/docs/Web/CSS/:dir
    html_elements('[dir=ltr]') |> 
    html_text()
    
  sz <- split(sz, rep(seq(1, length(sz)/5, 1), each = 5))
  
  #strip dates and names
  #convert noted bounds to polygon
  
  sz <- sz |> 
    lapply(FUN = function(x) {
      # pull name
      sz_id <- gsub(" Acoustic.*", "", x[1])
      
      # pull date
      start_date <- paste(
        gsub(".*Effective |-.*$", "", x[1]),
        gsub(".*,", "", x[1]),
        sep = ","
      ) |> 
        as.Date(format = "%B %d, %Y")
      
      end_date <- gsub(".*-", "", x[1]) |> 
        as.Date(format = "%B %d, %Y")
      
      # convert coords to polygon
      bounds <- x[2:5]
      bounds <- gsub(".*: |\' [NW]$", "", bounds)
      bounds <- as.numeric(gsub("°.*$", "", bounds)) +
        as.numeric(gsub("^.*°", "", bounds)) / 60
      bounds[3:4] <- -bounds[3:4]
      
      bounds <- expand.grid(bounds[3:4], bounds[1:2])[c(1, 2, 4, 3, 1),]
      bounds <- st_multipoint(as.matrix(bounds)) |>
        st_cast('POLYGON') |> 
        st_sfc(crs = 4326)
      
      data.frame(id = sz_id, start_date, end_date, geom = bounds) |> 
        st_as_sf()
    }) |> 
    do.call(rbind, args = _)
  
  sz
}
