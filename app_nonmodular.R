# Load necessary libraries
library(tidyverse)  # Collection of data manipulation and visualization packages
library(DT)         # R interface to the DataTables library for interactive tables
library(shiny)      # Web application framework for R

# Read the dataset from a CSV file
dataset <- read.csv("./data/bfro_reports_geocoded.csv")

# Define the user interface (UI) for the Shiny app
ui <- fluidPage(
  theme = bslib::bs_theme(version = 5, bootswatch = "flatly", primary = "#008080", bg = "#f7fdfd", fg = "black"),
  h1("Bigfoot Sightings in the United States", align = "center"),  # Main title
  hr(),  # Horizontal line
  
  # First section: Sightings for a selected state's top 10 counties
  fluidRow(
    column(2,  # Column for the select input
           selectizeInput(
             inputId = "state",
             label = "Select State",
             choices = unique(dataset$state),  # Unique states from the dataset
             selected = "Washington",          # Default selected state
             multiple = FALSE                  # Only one state can be selected
           )
    ),
    column(5,  # Column for the first plot
           h4("Sightings for top 10 counties"),  # Subtitle for the plot
           plotOutput(outputId = "plotcounty")   # Placeholder for the first plot
    ),
    column(5,  # Column for the second plot
           h4("Sightings over time"),            # Subtitle for the plot
           plotOutput(outputId = "plotyearly")   # Placeholder for the second plot
    )
  ),
  
  hr(),  # Another horizontal line
  
  # Second section: Comparison of sightings for two selected states
  fluidRow(
    column(2,  # Column for the select input
           selectizeInput(
             inputId = "state2",
             label = "Select State to compare",
             choices = unique(dataset$state),  # Unique states from the dataset
             selected = "Ohio",                # Default selected state
             multiple = FALSE                  # Only one state can be selected
           )
    ),
    column(5,  # Column for the first plot
           plotOutput(outputId = "plotcounty2")  # Placeholder for the first plot
    ),
    column(5,  # Column for the second plot
           plotOutput(outputId = "plotyearly2")  # Placeholder for the second plot
    )
  )
)


# Define server logic ----
server <- function(input, output, session) {
  
  # Filter data based on the user's selected state
  data_filtered <- reactive({
    dataset |> filter(state == input$state)
  })
  
  # County plot: Render the plot for the top 10 counties with the most sightings
  output$plotcounty <- renderPlot({
    data_filtered() |>                 # Get the filtered dataset for the selected state
      count(county) |>                # Count the number of sightings for each county
      mutate(county = fct_reorder(as.factor(county), n)) |>  # Reorder counties based on the number of sightings
      arrange(desc(n)) |>             # Arrange data in descending order of sightings
      top_n(10) |>                    # Select the top 10 counties with the most sightings
      ggplot() +                      # Create a ggplot object
      geom_col(aes(county, n, fill = n), colour = NA, width = 0.8) +  # Create a bar plot
      geom_label(aes(county, n + 1.5, label = n), size = 4, color = "black") +  # Add labels above the bars
      scale_fill_gradientn(colours = c("#008080", high = "black")) +    # Apply a color gradient to the bars
      labs(y = "", x = "") +          # Remove y and x axis labels
      theme_minimal() +               # Use a minimal theme
      coord_flip() +                  # Flip the x and y axes
      ylim(c(0, 85)) +                # Set y-axis limits
      theme(                          # Additional theme customization
        panel.grid = element_blank(),
        text = element_text(size = 20),
        axis.text.x = element_blank(),
        legend.position = "none",
        plot.background = element_rect(fill = "#e7fafa")
      )
  })
  
  # Yearly plot: Render the plot for yearly sightings over time
  output$plotyearly <- renderPlot({
    data_filtered() |>                 # Get the filtered dataset for the selected state
      mutate(year = floor_date(as.Date(date), 'year')) |>  # Extract the year from the date column
      count(year) |>                   # Count the number of sightings for each year
      filter(!is.na(year)) |>          # Remove rows with missing years
      arrange(desc(n)) |>              # Arrange data in descending order of sightings
      mutate(
        highest = ifelse(row_number() == 1, str_glue("Highest yearly sighting: {n}\nYear: {substr(year, 1, 4)}"), NA),
        highest_count = ifelse(row_number() == 1, n, NA)
      )  |>                           # Create two new columns for annotation
      ggplot(aes(year, n)) +           # Create a ggplot object
      geom_point(color = "#008080", alpha = 0.3, size = 2) +   # Create a scatter plot
      geom_point(aes(year, highest_count), color = "red", alpha = 1, size = 2) +   # Add a red point on the highest sighting year
      stat_smooth(inherit.aes = TRUE, se = FALSE, span = 0.3, show.legend = TRUE, color = "#008080") +  # Add a smoothed line
      scale_y_continuous(breaks = function(z) seq(0, range(z)[2], by = 5)) +   # Set y-axis breaks
      ylim(c(0, 38)) +                 # Set y-axis limits
      geom_text(aes(year, n + 1, label = highest), hjust = 0, size = 7, nudge_y = 2) +   # Add labels for the highest sighting year
      scale_x_date(date_labels = "%Y", breaks = "6 year", limits = as.Date(c("1989-01-01", "2023-01-01"))) +  # Set date axis formatting
      theme_minimal() +                # Use a minimal theme
      theme(
        panel.grid.major = element_blank(),
        text = element_text(size = 20),
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        plot.background = element_rect(fill = "#e7fafa")
      )
  })
  
  
  # Filter data based on the user's selected state2
  data_filtered2 <- reactive({
    dataset |> filter(state == input$state2)
  })
  
  # County plot for state2: Render the plot for the top 10 counties with the most sightings in state2
  output$plotcounty2 <- renderPlot({
    data_filtered2() |>               # Get the filtered dataset for state2
      count(county) |>                # Count the number of sightings for each county
      mutate(county = fct_reorder(as.factor(county), n)) |>  # Reorder counties based on the number of sightings
      arrange(desc(n)) |>             # Arrange data in descending order of sightings
      top_n(10) |>                    # Select the top 10 counties with the most sightings
      ggplot() +                      # Create a ggplot object
      geom_col(aes(county, n, fill = n), colour = NA, width = 0.8) +  # Create a bar plot
      geom_label(aes(county, n + 1.5, label = n), size = 4, color = "black") +  # Add labels above the bars
      scale_fill_gradientn(colours = c("#008080", high = "black")) +    # Apply a color gradient to the bars
      labs(y = "", x = "") +          # Remove y and x axis labels
      theme_minimal() +               # Use a minimal theme
      coord_flip() +                  # Flip the x and y axes
      ylim(c(0, 85)) +                # Set y-axis limits
      theme(                          # Additional theme customization
        panel.grid = element_blank(),
        text = element_text(size = 20),
        axis.text.x = element_blank(),
        legend.position = "none",
        plot.background = element_rect(fill = "#e7fafa")
      )
  })
  
  # Yearly plot for state2: Render the plot for yearly sightings over time in state2
  output$plotyearly2 <- renderPlot({
    data_filtered2() |>               # Get the filtered dataset for state2
      mutate(year = floor_date(as.Date(date), 'year')) |>  # Extract the year from the date column
      count(year) |>                   # Count the number of sightings for each year
      filter(!is.na(year)) |>          # Remove rows with missing years
      arrange(desc(n)) |>              # Arrange data in descending order of sightings
      mutate(
        highest = ifelse(row_number() == 1, str_glue("Highest yearly sighting: {n}\nYear: {substr(year, 1, 4)}"), NA),
        highest_count = ifelse(row_number() == 1, n, NA)
      )  |>                           # Create two new columns for annotation
      ggplot(aes(year, n)) +           # Create a ggplot object
      geom_point(color = "#008080", alpha = 0.3, size = 2) +   # Create a scatter plot
      geom_point(aes(year, highest_count), color = "red", alpha = 1, size = 2) +   # Add a red point on the highest sighting year
      stat_smooth(inherit.aes = TRUE, se = FALSE, span = 0.3, show.legend = TRUE, color = "#008080") +  # Add a smoothed line
      scale_y_continuous(breaks = function(z) seq(0, range(z)[2], by = 5)) +   # Set y-axis breaks
      ylim(c(0, 38)) +                 # Set y-axis limits
      geom_text(aes(year, n + 1, label = highest), hjust = 0, size = 7, nudge_y = 2) +   # Add labels for the highest sighting year
      scale_x_date(date_labels = "%Y", breaks = "6 year", limits = as.Date(c("1989-01-01", "2023-01-01"))) +  # Set date axis formatting
      theme_minimal() +                # Use a minimal theme
      theme(
        panel.grid.major = element_blank(),
        text = element_text(size = 20),
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        plot.background = element_rect(fill = "#e7fafa")
      )
  })
  
}



# Run the application 
shinyApp(ui = ui, server = server)