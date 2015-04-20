library(shiny)
source('../util/dataloader1.R')

shinyUI(fluidPage(
  # Application title
  titlePanel("NYC Vehicle Collisions Data Test"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
        dateInput('date',
                  label = 'Date input: yyyy-mm-dd',
                  value = '2015-02-01'
        )
    ),
    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("collisionsPlot")
    )
  )
))
