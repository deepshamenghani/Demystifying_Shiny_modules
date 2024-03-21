# UI function for the county plot module
module_county_ui <- function(id) {
  ns <- NS(id)  # Create a namespace to isolate the inputs and outputs within this module
  plotOutput(outputId = ns("plotcounty"))  # Output a plot with the specified id
}


# Server function for the county plot module
module_county_server <- function(id, df_filtered) {
  # Define the server logic for the county plot module using moduleServer
  
  # id: The id assigned to the module
  # df_filtered: A reactive expression containing the filtered data to be used for the plot
  
  moduleServer(id,  # Use moduleServer to create a modularized server function
               function(input, output, session) {
                 
                 # Render the county plot output using ggplot and the filtered data
                 
                 # Output plotcounty, as defined in module_county_ui
                 output$plotcounty <- renderPlot({
                   df_filtered() |>
                     count(county) |>   # Count occurrences of each county in the filtered data
                     mutate(county = fct_reorder(as.factor(county), n)) |>  # Reorder counties by frequency (n)
                     arrange(desc(n)) |>  # Sort the data in descending order based on the frequency (n)
                     top_n(10) |>  # Select the top 10 counties with the highest frequency
                     ggplot() +  # Start building the ggplot object
                     geom_col(aes(county, n, fill = n), colour = NA, width = 0.8) +  # Create a bar plot with county on the x-axis, frequency (n) on the y-axis, and fill the bars based on frequency
                     geom_label(aes(county, n+1.5, label = n), size = 4, color = "black") +  # Add data labels above each bar
                     scale_fill_gradientn(colours = c("#008080", high = "black")) +  # Set the color scale for the bars
                     labs(y = "", x = "") +  # Remove axis labels
                     theme_minimal() +  # Use a minimal theme for the plot
                     coord_flip() +  # Flip the x and y axes to create a horizontal bar plot
                     ylim(c(0, 85)) +  # Set the y-axis limits
                     theme(
                       panel.grid = element_blank(),  # Remove grid lines
                       text = element_text(size = 20),  # Set the text size
                       axis.text.x = element_blank(),  # Remove x-axis tick labels
                       legend.position = "none",  # Remove the legend
                       plot.background = element_rect(fill = "#e7fafa")  # Set the plot background color
                     )
                 })
               }
  )
}
