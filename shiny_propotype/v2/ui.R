library(shinydashboard)

# Define UI for application that draws a histogram
dashboardPage(
  dashboardHeader(
    title = "US Roads Fatality Data"),
  dashboardSidebar(
    sidebarMenu(
        menuItem("General numbers", tabName="summary_tab", icon=icon("car")),
        menuItem("Alcohol", tabName="alco_tab", icon=icon("beer")),
        menuItem("Children", tabName="children_tab", icon=icon("child")),
        menuItem("Bikes", tabName="bike_tab", icon=icon("bicycle")),
        menuItem("Motorcycles", tabName="moto_tab", icon=icon("bolt")),
        menuItem("Trends", tabName="trends_tab", icon=icon("line-chart")),
        menuItem("Largest crashes", tabName="", icon=icon("users")),
        menuItem("Map", tabName="statetab", icon=icon("map-marker"))
        )
    ),
  dashboardBody(
    tabItems(
      tabItem(tabName="summarytab",
              # Boxes need to be put in a row (or column)
              fluidRow(
                column(width=12, 
                       h2("Plotting demo data from R-Studio webinar"),
                       p("The interactive charts below are a result of demo code from the webinar, that has been adopted to suit project needs")),
                
                box(
                  title = "Control", status = "warning", solidHeader = TRUE,
                  collapsible = TRUE,
                  sliderInput("slider", "Number of observations:", 1, 100, 50)
                    ),
                
                box(title = "Main Chart", status = "primary", solidHeader = TRUE,
                    plotOutput("plot1", height = 250)
                    )
              )
            ),
      
      tabItem(tabName="trendstab",
              # Boxes need to be put in a row (or column)
              fluidRow(
                column(width=12, 
                       h2("Contents for Tab2 go here"),
                       p("The interactive charts below are a result of demo code from the webinar, that has been adopted to suit project needs")
                )          
                )
              ),
      
      tabItem(tabName="vehicletab",
              # Boxes need to be put in a row (or column)
              fluidRow(
                column(width=12, 
                       h2("Contents for Tab3: vehicle type view goes here"),
                       p("The interactive charts below are a result of demo code from the webinar, that has been adopted to suit project needs")
                ),
                
                tabBox(
                  #title = "Motor",
                  # The id lets us use input$tabset1 on the server to find the current tab
                  id = "tabset1", height = "250px",
                  tabPanel("All Vehicles", "First tab content", icon=icon("road")),
                  tabPanel("Passenger Cars", "Tab content about Cars", icon=icon("car")),
                  tabPanel("Light Trucks", "Light Truck content", icon=icon("truck")),
                  tabPanel("Motorcycles", "Motorbikes data", icon=icon("bicycle"))
                ),
                
                tabBox(
                  #title = "Non Motor",
                  # The id lets us use input$tabset1 on the server to find the current tab
                  id = "tabset1", height = "250px",
                  tabPanel("Pedestrians", "Tab content 2: Pedestrians", icon=icon("male")),
                  tabPanel("Bicycles", "Bicycles tab content", icon=icon("bicycle"))
                )                
              )
             ),
      
      tabItem(tabName="lawtab",
              # Boxes need to be put in a row (or column)
              fluidRow(
                column(width=12, 
                       h2("Contents for Tab4: View by type of law goes here"),
                       p("The interactive charts below are a result of demo code from the webinar, that has been adopted to suit project needs")
                ),
                
                tabBox(
                  #title = "Type of Law",
                  # The id lets us use input$tabset1 on the server to find the current tab
                  id = "tabset1", height = "250px",
                  tabPanel("Seatbelts", "First tab content", icon=icon("bell-slash")),
                  tabPanel("Alcohol", "Tab content 2", icon=icon("glass"))
                )
                
              )
            ),
      
      tabItem(tabName="statetab",
              # Boxes need to be put in a row (or column)
              fluidRow(
                column(width=12, 
                       h2("Contents for Tab5: State level view goes here"),
                       p("The interactive charts below are a result of demo code from the webinar, that has been adopted to suit project needs")
                )          
              )
            )      
      )
      )
  )