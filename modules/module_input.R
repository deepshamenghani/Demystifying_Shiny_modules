# UI function for the input module
module_input_ui <- function(id, df, defaultstate = "Washington") {
  # Namespace
  ns <- NS(id)  # Create a namespace to isolate the inputs and outputs within this module
  
  # Input UI command for the selectizeInput widget
  selectizeInput(inputId = ns("stateinput"),  # Input id for the widget, namespaced using the created namespace
                 label = "Select state",  # Label to display above the dropdown
                 choices = unique(df$state),  # Available choices for the dropdown, derived from the unique values of the 'state' column in the provided data frame
                 selected = defaultstate,  # Default selected value for the dropdown
                 multiple = FALSE)  # Allow single selection only (not multiple selections)
}


# Server function for the input module
module_input_server <- function(id, df) {
  # Define the server logic for the input module using moduleServer
  
  # id: The id assigned to the module
  # df: The data frame to be used for filtering
  
  moduleServer(id,  # Use moduleServer to create a modularized server function
               function(input, output, session) {
                 
                 # Reactive expression to filter the data set based on the user input
                 
                 # Filter the data frame 'df' based on the selected value in the input$stateinput
                 table <- reactive({
                   df |> filter(state == input$stateinput)
                 })
                 
                 return(table)  # Return the filtered data frame
               }
  )
}


### Testing the modules

# Load the data set from the CSV file
dataset <- read.csv("./data/bfro_reports_geocoded.csv")

# UI for testing multiple input modules
ui_test_multiple <- fluidPage(
  # Call the ui module as a function with different ids and default states
  module_input_ui("input_test1", df = dataset),
  module_input_ui("input_test2", df = dataset, defaultstate = "Ohio"),
  module_input_ui("input_test3", df = dataset, defaultstate = "California")
)

# Server logic for testing multiple input modules
server_test_multiple <- function(input, output, session) {
  # Call the server module as a function with different ids and the data set
  
  data_filtered1 <- module_input_server("input_test1", df = dataset)
  data_filtered2 <- module_input_server("input_test2", df = dataset)
  data_filtered3 <- module_input_server("input_test3", df = dataset)
}

# Call the shiny app with multiple input modules
shinyApp(ui = ui_test_multiple, server = server_test_multiple)


# UI for testing a single input module
ui_test <- fluidPage(
  # Call the ui module as a function with a single id and the data set
  module_input_ui("input_test", df = dataset)
)

# Server logic for testing a single input module
server_test <- function(input, output, session) {
  # Call the server module as a function with the id and the data set
  
  data_filtered <- module_input_server("input_test", df = dataset)
}

# Call the shiny app with a single input module
shinyApp(ui = ui_test, server = server_test)
