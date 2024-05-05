#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

#Predictive Analysis of Energy Usage for eSC


## R Markdown

library(shiny)
library(rsconnect)
library(plotly)
library(dplyr)
library(caret)
library(shinydashboard)
library(tidyverse)

# Define UI
ui <- fluidPage(
  titlePanel("Predictive Analysis of Energy Usage for eSC"),
  sidebarLayout(
    sidebarPanel(
      fileInput("file_upload", "Upload CSV File"),
      numericInput("n_rows", "Number of Rows to Display for Model Predictions:", value = 10, min = 1),
      numericInput("n_rows1", "Number of Rows to Display for read in dataset:", value = 10, min = 1)
    ),
    mainPanel(
      plotlyOutput("energy_plot"),
      dataTableOutput("prediction_table"), 
      dataTableOutput("table") 
    )
  )
)

# Define server
server <- function(input, output, session) {
  
  # Load the pre-built model
  load(file = "our_model.rda")
  
  #require an input file, then read a CSV file
  getTestData <- reactive({
    req(input$file_upload)
    df <- read_csv(input$file_upload$datapath)
    return(df)
  })
  
  # Define the reactive expression to handle file upload and prediction
  predictions <- reactive({
    
    #TestData for predictions using model
    df <- getTestData()
    
    # Predict values for test data where `Dry Bulb Temperature [°C]` (weather temp predictor) is increased by 5
    predicted_values <- predict(our_model, df)
    df$`Dry Bulb Temperature [°C]` <- df$`Dry Bulb Temperature [°C]` + 5
    future_predicted_values <- predict(our_model, df)
    
    # Combine predicted values with test_data to retain county_id and date_time
    predicted_values_df <- data.frame(Present_Predicted = predicted_values, Future_Predicted = future_predicted_values)
    predicted_values_df <- cbind(predicted_values_df, df[, c("county_id", "date_time"), with = FALSE])
    
    # Aggregate the data by county and date to get total predicted energy
    aggregated_data <- aggregate(cbind(Present_Predicted, Future_Predicted) ~ county_id + date_time, predicted_values_df, sum)
    
    return(aggregated_data)
  })
  
  # Render the plot with predicted energy usage
  output$energy_plot <- renderPlotly({
    max_indices <- predictions() %>%
      group_by(county_id) %>%
      summarise(max_Predicted = max(Present_Predicted),
                max_Future_Predicted = max(Future_Predicted),
                date_time = date_time[which.max(Present_Predicted)])
    
    plot_ly(max_indices, x = ~county_id) %>%
      add_trace(y = ~max_Predicted, type = 'bar', name = 'Max Predicted Energy',
                text = ~paste('County ID:', county_id, '<br>Date:', date_time, '<br>Max Present Predicted Energy:', max_Predicted)) %>%
      add_trace(y = ~max_Future_Predicted, type = 'bar', name = 'Max Future Predicted Energy',
                text = ~paste('County ID:', county_id, '<br>Date:', date_time, '<br>Max Future Predicted Energy:', max_Future_Predicted)) %>%
      layout(title = 'Predictive Analysis of Energy Usage for eSC',
             xaxis = list(title = 'County ID'),
             yaxis = list(title = 'Energy Usage'),
             barmode = 'group') %>%
      config(displayModeBar = FALSE)
    
  })
  
  #Render the table with predictions
  #show the output of the model
  output$prediction_table <- renderDataTable({
    predictions<-predictions()
    # Format the date_time variable to include both date and time
    predictions$date_time <- format(predictions$date_time, "%Y-%m-%d %H:%M:%S")
    head(predictions, input$n_rows)
  })
  
  #show a few lines of the dataframe
  # Function to render the table
  output$table <- renderDataTable({
    read_in_data <- getTestData()
    # Display the first n_rows of the data
    head(read_in_data, input$n_rows1)
  })
  
}

# Run the application
shinyApp(ui = ui, server = server)

