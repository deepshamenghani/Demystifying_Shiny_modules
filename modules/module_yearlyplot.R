# UI function for the yearly plot module
module_yearly_ui <- function(id) {
  ns <- NS(id)  # Create a namespace to isolate the inputs and outputs within this module
  
  # Output UI command for the plotOutput widget
  plotOutput(outputId = ns("plotyearly"))  # Output plot with id namespaced using the created namespace
}


# Server function for the yearly plot module
module_yearly_server <- function(id, df_filtered) {
  # Define the server logic for the yearly plot module using moduleServer
  
  # id: The id assigned to the module
  # df_filtered: The filtered data frame received from the input module
  
  moduleServer(id,  # Use moduleServer to create a modularized server function
               function(input, output, session) {
                 
                 # Render the yearly plot based on the filtered data frame 'df_filtered'
                 
                 output$plotyearly <- renderPlot({
                   df_filtered() |>  # Filtered data frame received from the input module
                     mutate(year = floor_date(as.Date(date), 'year')) |>  # Convert the 'date' column to year only
                     count(year) |>  # Count the occurrences of each year
                     filter(!is.na(year)) |>  # Remove rows with missing year values
                     arrange(desc(n)) |>  # Arrange the data by the count of sightings in descending order
                     mutate(
                       highest = ifelse(row_number() == 1, str_glue("Highest yearly sighting: {n}\nYear: {substr(year, 1, 4)}"), NA),
                       highest_count = ifelse(row_number() == 1, n, NA)
                     ) |>  # Create additional columns for labeling the highest yearly sighting
                     ggplot(aes(year, n)) +  # Create a ggplot with year on x-axis and count on y-axis
                     geom_point(color = "#008080", alpha = 0.3, size = 2) +  # Add point markers with color and transparency
                     geom_point(aes(year, highest_count), color = "red", alpha = 1, size = 2) +  # Add red points for the highest yearly sighting
                     stat_smooth(inherit.aes = TRUE, se = FALSE, span = 0.3, show.legend = TRUE, color = "#008080") +  # Add a smooth trend line
                     scale_y_continuous(breaks = function(z) seq(0, range(z)[2], by = 5)) +  # Customize y-axis breaks
                     ylim(c(0, 38)) +  # Set the y-axis limits
                     geom_text(aes(year, n + 1, label = highest), hjust = 0, size = 7, nudge_y = 2) +  # Add labels for the highest yearly sighting
                     scale_x_date(date_labels = "%Y", breaks = "6 year", limits = as.Date(c("1989-01-01", "2023-01-01"))) +  # Customize x-axis date labels and breaks
                     theme_minimal() +  # Use a minimal theme for the plot
                     theme(
                       panel.grid.major = element_blank(),  # Remove major grid lines
                       text = element_text(size = 20),  # Customize text size
                       axis.title.x = element_blank(),  # Remove x-axis title
                       axis.title.y = element_blank(),  # Remove y-axis title
                       plot.background = element_rect(fill = "#e7fafa")  # Set plot background color
                     )
                 })
               }
  )
}
