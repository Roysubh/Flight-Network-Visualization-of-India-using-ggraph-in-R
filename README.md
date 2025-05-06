🛫 Flight Network Visualization of India using ggraph in R

  This project aims to visualize the flight network across India by mapping the connections between Indian airports. The visualization uses real-world data, including airport locations and flight routes, and renders the flight network on a map of India.

The dataset includes:
  Airport Data: A comprehensive list of airports across India, including their locations and details such as IATA codes and names.
  Flight Route Data: Routes connecting the airports, showing the direct flight paths between airports within India.

The map shows:
  Airports as nodes connected by edges representing the flight routes between them.
  The visualization includes key map features such as scale bars, north arrows, and graticules for orientation.

The map is visually appealing, with a dark background to enhance the airport locations (highlighted in orange) and the flight routes (highlighted in blue). The focus of the project is to provide a clean and readable visualization of the flight network, suitable for understanding the connectivity between airports in India.

📊 Project Overview:
  This project uses the following datasets:
  Indian Airport Boundary Data (IND_Boundary.shp).
  Indian Airport Data (airports.dat) sourced from OpenFlights Airport Data.
  Flight Routes Data (routes.dat) sourced from OpenFlights Flight Routes Data.

The flight routes are filtered to display only flights within India, and the airports are visualized as nodes in a network. The edges represent flight routes between airports.

The visualization includes the following:
  A flight network map with airport locations and flight connections.
  A scale bar and north arrow for orientation.
  Graticules showing latitude and longitude lines.

The map background is set to black, with white and orange colors for the map elements.

📦 Libraries Used
  tidyverse – Data manipulation and visualization.
  sf – Handling spatial data.
  igraph – Creating and analyzing graphs.
  tidygraph – A tidy interface for graph data.
  ggraph – Visualizing graph objects.
  ggplot2 – Base plotting system.
  ggspatial – Handling spatial objects in ggplot2 visualizations.

🏁 Conclusion
This project demonstrates how to visualize a flight network using data from OpenFlights and ggraph. The map is styled with a dark background, white borders, and orange airport markers to create a visually appealing representation of the flight routes within India.

🔗 Data Links
Indian Airport Data (https://raw.githubusercontent.com/jpatokal/openflights/master/data/airports.dat)
Flight Routes Data ("https://raw.githubusercontent.com/jpatokal/openflights/master/data/routes.dat")

📝 License
This project is licensed under the MIT License – see the LICENSE file for details.
