# Load necessary libraries
library(tidyverse)   # For data manipulation and visualization
library(DT)          # For interactive data tables
library(shiny)       # For building interactive web applications
source("constants.R")  # Source custom constants

# Source custom modules
source("./modules/module_input.R")        # Module for user input UI
source("./modules/module_countyplot.R")   # Module for county plot UI and server logic
source("./modules/module_yearlyplot.R")   # Module for yearly plot UI and server logic

# Read the dataset from CSV file
dataset <- read.csv("./data/bfro_reports_geocoded.csv")

# App with two sections

# Define the UI layout for the Shiny app - Section 1
ui <- fluidPage(
  h1("Bigfoot Sightings in the United States", align = "center"),  # App title
  fluidRow(
    # Module for user input state
    column(2, module_input_ui("inputs", dataset)),
    # Module for displaying county plot
    column(5, module_county_ui("countyplot")),
    # Module for displaying yearly plot
    column(5, module_yearly_ui("timeplot"))
  ),
  hr(),  # Horizontal rule
  fluidRow(
    # Module for user input state2 with a default state (Ohio)
    column(2, module_input_ui("inputs_2", dataset, defaultstate = "Ohio")),
    # Module for displaying county plot for state2
    column(5, module_county_ui("countyplot_2")),
    # Module for displaying yearly plot for state2
    column(5, module_yearly_ui("timeplot_2"))
  )
)

# Define server logic for Section 1 ----
server <- function(input, output, session) {
  
  # Module for handling user input and filtering data for Section 1
  data_filtered <- module_input_server("inputs", dataset)
  # Module for county plot server logic for Section 1, using the filtered data
  module_county_server("countyplot", df_filtered = data_filtered)
  # Module for yearly plot server logic for Section 1, using the filtered data
  module_yearly_server("timeplot", df_filtered = data_filtered)
  
  # Module for handling user input and filtering data for Section 2
  data_filtered_2 <- module_input_server("inputs_2", dataset)
  # Module for county plot server logic for Section 2, using the filtered data
  module_county_server("countyplot_2", df_filtered = data_filtered_2)
  # Module for yearly plot server logic for Section 2, using the filtered data
  module_yearly_server("timeplot_2", df_filtered = data_filtered_2)
}

# Run the Shiny application for Section 1
shinyApp(ui = ui, server = server)


# App with Single Section

# Define the UI layout for the Shiny app - Single Section
ui <- fluidPage(
  h1("Bigfoot Sightings in the United States", align = "center"),  # App title
  fluidRow(
    # Module for user input state
    column(2, module_input_ui("inputs", dataset)),
    # Module for displaying county plot
    column(5, module_county_ui("countyplot")),
    # Module for displaying yearly plot
    column(5, module_yearly_ui("timeplot"))
  )
)

# Define server logic for Single Section ----
server <- function(input, output, session) {
  
  # Module for handling user input and filtering data for Single Section
  data_filtered <- module_input_server("inputs", dataset)
  # Module for county plot server logic for Single Section, using the filtered data
  module_county_server("countyplot", df_filtered = data_filtered)
  # Module for yearly plot server logic for Single Section, using the filtered data
  module_yearly_server("timeplot", df_filtered = data_filtered)
  
}

# Run the Shiny application for Single Section
shinyApp(ui = ui, server = server)


