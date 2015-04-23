library(shinydashboard)
library(ggvis)


source('../../util/dataloader2.R')

# actionLink <- function(inputId, ...) {
#     tags$a(href='javascript:void',
#            id=inputId,
#            class='action-button',
#            ...)
# }

dashboardPage(
  dashboardHeader(
    title = "US Roads Fatality Data"),
  dashboardSidebar(
    sidebarMenu(
        menuItem("Overview", tabName="overview_tab", icon=icon("car")),
        menuItem("Location", tabName="map_tab", icon=icon("map-marker")),
        menuItem("Timing", tabName="timing_tab", icon=icon("calendar")),
        menuItem("Alcohol", tabName="alco_tab", icon=icon("beer")),
        menuItem("Children", tabName="children_tab", icon=icon("child")),
        menuItem("Bikes", tabName="bike_tab", icon=icon("bicycle")),
        menuItem("Motorcycles", tabName="moto_tab", icon=icon("bolt")),
        menuItem("Trends", tabName="trends_tab", icon=icon("line-chart")),
#        menuItem("Data Explorer", tabName="data_explorer", icon=icon("line-chart")),
        menuItem("Largest crashes", tabName="largest_tab", icon=icon("users"))

        )
    ),
  dashboardBody(

      
####################### 
tabItems(
    tabItem(tabName="overview_tab",
        fluidRow(
            column(width=12),
            h2('US Motor Vehicle Fatalities 1899-2012'),
            plotOutput("overviewPlot1"),
            h3('Adjusted for vehicle-miles'),
            plotOutput("overviewPlot2"),
            h3('Fatalities per million population'),
            plotOutput("overviewPlot3")
        )
    ),
      
####################### 
tabItem(tabName="map_tab",
        # Boxes need to be put in a row (or column)
        fluidRow(
            column(width=12, 
                   h2("Map"),
                   p("Animated map of US roads collisions in 2013:"),
                   tags$iframe(src = "https://denniskorablev.cartodb.com/viz/e2b8cbac-e8fe-11e4-8cab-0e853d047bba/embed_map", seamless=NA,width='100%',height='520'),
                   p(""),
                   p(""))
        )
),


####################### 
    tabItem(tabName="timing_tab",
            # Boxes need to be put in a row (or column)
            fluidRow(
                column(width=12),
                h3('Fatalities by weekday'),
                plotOutput("timingPlot1"),
                h3('Fatalities by state and weekday'),
                plotOutput("timingPlot2"),
                h3('Fatalities by state and weekday adjusted by annual vehicle miles'),
                plotOutput("timingPlot5"),
                h3('Fatalities (adjusted by annual vehicle miles) vs. State Urban'),
                plotOutput("timingPlot6"),
                h3('Time of day'),
                plotOutput("timingPlot3"),
                h3('Over the course of the week'),
                plotOutput("timingPlot4")
            )
    ),
    
####################### 
  tabItem(tabName="alco_tab",
          # Boxes need to be put in a row (or column)
          fluidRow(
              column(width=12, 
                     h2("Alcohol"),
                     p("Change over the years"),
                     p("% of total fatalities over the years"),
                     p("Do we have peaks on national holidays"),
                     p("City/Intercity"),
                     p(""))
          )
  ),
  
              


####################### 
  tabItem(tabName="children_tab",
          # Boxes need to be put in a row (or column)
          fluidRow(
              column(width=12, 
                     h2("Children"),
                     p("% by state"),
                     p("% by drunk drivers"),
                     p("% by city/intercity road"),
                     p(""),
                     p(""))
          )
  ),
  
                  
####################### 
  tabItem(tabName="bike_tab",
          # Boxes need to be put in a row (or column)
          fluidRow(
              column(width=12, 
                     h2("Bikes"),
                     p("% by year"),
                     p("% by state"),
                     p(""),
                     p(""),
                     p(""))
          )
  ),
                   
                      
                      
####################### 
  tabItem(tabName="moto_tab",
          # Boxes need to be put in a row (or column)
          fluidRow(
              column(width=12, 
                     h2("Motorcycles"),
                     p("% by year"),
                     p("% by state"),
                     p(""),
                     p(""),
                     p(""))
          )
  ),
####################### 
    tabItem(tabName="trends_tab",
            # Boxes need to be put in a row (or column)
            fluidRow(
                column(width=12, 
                       h2("Trends"),
                       h3('Fatalities rate per 1 mln cars vs Total Fatalities per state'),
                       ggvisOutput("StatePlot1"),
                       p("Seasonality by state"),
                       p("Average seasonality"),
                       p("Average seasonality"),
                       p("By total number of fatalities (seasonal trends)"),
                       p("Fatalities vs weekday"),
                       p("Fatalities by type of the vehicle"),
                       p(""),
                       p(""))
            )
    ),
      




#######################
# This is an experiment


# For dropdown menu


# tabItem(tabName="data_explorer",
#     fluidRow(
#         column(3,
#                wellPanel(
#                    h4("Filter"),
#                    selectInput("State", "State",
#                                c('ALABAMA', 'ALASKA', 'ARIZONA', 'ARKANSAS', 'CALIFORNIA', 'COLORADO', 'CONNECTICUT', 'DELAWARE', 'DISTRICT OF COLUMBIA', 'FLORIDA', 'GEORGIA', 'HAWAII', 'IDAHO', 'ILLINOIS', 'INDIANA', 'IOWA', 'KANSAS', 'KENTUCKY', 'LOUISIANA', 'MAINE', 'MARYLAND', 'MASSACHUSETTS', 'MICHIGAN', 'MINNESOTA', 'MISSISSIPPI', 'MISSOURI', 'MONTANA', 'NEBRASKA', 'NEVADA', 'NEW HAMPSHIRE', 'NEW JERSEY', 'NEW MEXICO', 'NEW YORK', 'NORTH CAROLINA', 'NORTH DAKOTA', 'OHIO', 'OKLAHOMA', 'OREGON', 'PENNSYLVANIA', 'RHODE ISLAND', 'SOUTH CAROLINA', 'SOUTH DAKOTA', 'TENNESSEE', 'TEXAS', 'UTAH', 'VERMONT', 'VIRGINIA', 'WASHINGTON', 'WEST VIRGINIA', 'WISCONSIN', 'WYOMING')
#                    ),
#                    textInput("City_County_Name", "City County Name (e.g. New York)")
#                ),
#                wellPanel(
#                    selectInput("xvar", "X-axis variable", axis_vars),
#                    selectInput("yvar", "Y-axis variable", axis_vars)
#                )
#         ),
#         column(9,
#                ggvisOutput("plot1"),
#                wellPanel(
#                    span("Number of accidents selected:",
#                         textOutput("n_accidents")
#                    )
#                )
#         ))
# ),
                              
                              
####################### 
  tabItem(tabName="largest_tab",
          # Boxes need to be put in a row (or column)
          fluidRow(
              column(width=12, 
                     h2("Largest crashes"),
                     p("Largest fatal collisions in 2013:"),
                     tags$iframe(src = "https://denniskorablev.cartodb.com/viz/46e8c95c-e91c-11e4-934f-0e018d66dc29/embed_map", seamless=NA,width='100%',height='520'),
                     p("Biggest accidents with bikes"),
                     p(""),
                     p(""))
          )
  )
  
                                  
                                  

          
      )
      )
  )