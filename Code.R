# ---- Package Installation & Loading ----
if (!require("pacman")) install.packages("pacman")
options(timeout = 60000, repos = "http://cran.rstudio.com/")
pacman::p_load(tidyverse, sf, igraph, tidygraph, ggraph, maps,
               ggplot2, rnaturalearth, rnaturalearthdata, ggrepel)

# ---- Load India Map ----
india_shp_path <- "D:/RStudio_3/Airport/IND_Boundary.shp"
india <- st_read(india_shp_path)
plot(india)

# ---- Load Airport Data ----
airport_file <- "D:/RStudio_3/Airport/airports.dat"
airport_url <- "https://raw.githubusercontent.com/jpatokal/openflights/master/data/airports.dat"
download.file(airport_url, airport_file, mode = "wb")

airport <- read.csv(airport_file, header = FALSE)
colnames(airport)[1:14] <- c("ID", "Name", "City", "Country", "IATA", "ICAO",
                             "Latitude", "Longitude", "Altitude", "Timezone",
                             "DST", "Tz", "Type", "Source")

# ---- Filter Indian Airports ----
ind_airport <- airport %>% filter(Country == "India", IATA != "\\N")
ind_airport_sf <- st_as_sf(ind_airport, coords = c("Longitude", "Latitude"), crs = 4326)
ind_airport_df <- ind_airport %>%
  mutate(lon = Longitude, lat = Latitude)

# ---- Load Flight Routes Data ----
routes_file <- "D:/RStudio_3/Airport/routes.dat"
routes_url <- "https://raw.githubusercontent.com/jpatokal/openflights/master/data/routes.dat"
download.file(routes_url, routes_file, mode = "wb")

routes <- read.csv(routes_file, header = FALSE)
colnames(routes) <- c("Airline", "Airline_ID", "Source_Airport", "Source_ID",
                      "Destination_Airport", "Destination_ID", "Codeshare", "Stops", "Equipment")

# ---- Filter Routes within India ----
ind_iata <- ind_airport$IATA
ind_flights <- routes %>%
  filter(Source_Airport %in% ind_iata & Destination_Airport %in% ind_iata) %>%
  distinct(Source_Airport, Destination_Airport)

# ---- Prepare Node and Edge Data ----
vertices <- ind_airport_df %>%
  filter(IATA %in% c(ind_flights$Source_Airport, ind_flights$Destination_Airport))

edges <- ind_flights %>%
  rename(origin = Source_Airport, dest = Destination_Airport)

graph <- tbl_graph(nodes = vertices, edges = edges, node_key = "IATA")

# ---- Flight Network Map with ggraph ----
library(ggspatial)
library(ggplot2)
library(grid)

flight_map <- ggraph(graph, layout = "manual", x = vertices$lon, y = vertices$lat) +
  geom_sf(data = india, fill = NA, color = "white", linewidth = 0.3, inherit.aes = FALSE) +
  ggraph::geom_edge_bundle_path(color = "#007ACC", width = 0.35, alpha = 0.45) +
  geom_node_point(color = "orange", size = 1) +
  
  # Add scale bar and north arrow
  annotation_scale(
    location = "bl",
    width_hint = 0.25,
    text_cex = 0.8,
    line_col = "white",
    text_col = "white",
    height = unit(0.4, "cm")
  ) +
  annotation_north_arrow(
    location = "tr",
    which_north = "true",
    style = north_arrow_fancy_orienteering(
      text_col = "white",
      fill = c("white", "gray")
    ),
    height = unit(1.2, "cm"),
    width = unit(1.2, "cm")
  ) +
  
  # Add graticules (lat/lon gridlines)
  coord_sf(crs = st_crs(4326), expand = FALSE, label_graticule = "SW") +
  
  # Add title and apply theme settings
  ggtitle("Flight Network of India") +
  theme_minimal(base_family = "Times New Roman") +
  theme(
    plot.title = element_text(hjust = 0.5, color = "white", size = 26, face = "bold"),
    panel.background = element_rect(fill = "black"),
    plot.background = element_rect(fill = "black"),
    panel.grid.major = element_line(color = NA, size = 0.1),
    axis.text = element_text(color = "white", size = 16, face = "bold"),
    axis.title = element_blank()
  )

# Print the plot
print(flight_map)

ggsave("D:/RStudio_3/Airport/indian_flight_network.png", plot = flight_map, width = 8, height = 9, dpi = 1200, bg = "black")
