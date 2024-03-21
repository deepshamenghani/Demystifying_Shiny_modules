# Demystifying Shiny modules by turning an existing Bigfoot sightings app modular

This repository contains the non-modularized and modularized code for the bigfoot shiny app. The goal is to showcase how to learn Shiny modules by modularizing an existing app, hence there is the code for non-modularized as well as modularized app.R files. The code is simple because the goal is to explain module concepts as simply as possible. 

This Shiny web application provides interactive visualizations of Bigfoot sightings in the United States. It allows users to explore and analyze Bigfoot sighting data through county-wise and yearly plots. The app also provides an option to compare data for two different states.

![image](https://github.com/deepshamenghani/cascadia_bigfoot_shiny/assets/46545400/95d7194b-9834-4ba5-b18b-53b8c88744d2)

## Getting Started with app_modular.R file

### Prerequisites

Before running the application, make sure you have the following libraries installed:

- tidyverse: For data manipulation and visualization
- shiny: For building interactive web applications

You can install the required libraries using the following command:

```R
install.packages(c("tidyverse", "shiny"))
```

### Installing

1. Clone this GitHub repository to your local machine.

2. Place the `bfro_reports_geocoded.csv` dataset file in the `./data` directory.

3. Open the `app.R` file, which contains the Shiny app code.

4. Make sure to run all the necessary installations and source the required modules using the following code snippet:

```R
# Load necessary libraries
library(tidyverse)   # For data manipulation and visualization
library(shiny)       # For building interactive web applications
source("constants.R")  # Source custom constants

# Source custom modules
source("./modules/module_input.R")        # Module for user input UI
source("./modules/module_countyplot.R")   # Module for county plot UI and server logic
source("./modules/module_yearlyplot.R")   # Module for yearly plot UI and server logic

# Read the dataset from CSV file
dataset <- read.csv("./data/bfro_reports_geocoded.csv")
```

## Running the App

After installing the necessary libraries and setting up the required files, you can run the Shiny app by executing the `shinyApp` function at the end of the `app_modular.R` file:

```R
# Run the Shiny application 
shinyApp(ui = ui, server = server)
```

The app will be launched in your default web browser, and you can now explore the Bigfoot sightings data interactively.

## App Layout

The app consists of the following components:

### Title

The main title "Bigfoot Sightings in the United States" is displayed at the center of the app.

### User Input Section

The user input section allows users to select a state from a dropdown menu. It is located on the left side of the app.

### County Plot Section

The county plot section displays a bar plot of the top 10 counties with the highest number of Bigfoot sightings. It is located in the center-left part of the app.

### Yearly Plot Section

The yearly plot section displays a line plot of the yearly trend of Bigfoot sightings. It also highlights the highest yearly sighting count for the selected state. This section is located in the center-right part of the app.

### Comparison Section

The app also allows users to compare data for two different states. The comparison section includes a second user input to select a second state, and corresponding county and yearly plots for the selected state. This section is located at the bottom of the app.

## How the App Works

The app is structured using modularization for better code organization and reusability. It consists of three main modules:

1. **module_input_ui**: This module creates the user input UI for selecting a state. It takes the ID and the dataset as inputs.

2. **module_input_server**: This module handles the server logic for user input. It filters the data based on the selected state and returns the filtered data.

3. **module_county_ui**: This module creates the UI for the county plot section. It takes the ID as an input.

4. **module_county_server**: This module handles the server logic for the county plot. It receives the filtered data and generates the bar plot of the top 10 counties with the highest number of sightings.

5. **module_yearly_ui**: This module creates the UI for the yearly plot section. It takes the ID as an input.

6. **module_yearly_server**: This module handles the server logic for the yearly plot. It receives the filtered data and generates the line plot of the yearly trend of sightings, highlighting the highest yearly sighting count.

The app utilizes ggplot2 for creating interactive and visually appealing plots.

## Authors

- Deepsha Menghani - Initial work - [GitHub Profile](https://github.com/deepshamenghani)

## Acknowledgments

- Thanks to Timothy Renner at [https://data.world/timothyrenner/bfro-sightings-data](https://data.world/timothyrenner/bfro-sightings-data) for providing the Bigfoot sightings dataset.
