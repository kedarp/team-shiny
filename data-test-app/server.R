library(shiny)
library(dplyr)
library(ggplot2)
library(scales)

getCollisionsForDate <- function(collisions, date) {
    message(date)
    df <- collisions %>% filter(DATE == date)
    t <- factor(substr(as.character(df$t), 0, 13))
    collisionsByHour <- data.frame(t) %>% group_by(t) %>% summarize(n=length(t))
    collisionsByHour$t <- as.POSIXct(collisionsByHour$t, format='%Y-%m-%d %H')
    collisionsByHour
}

shinyServer(function(input, output) {

    collisions <- loadCollisions1_Mini();

    output$collisionsPlot <- renderPlot({
        df <- getCollisionsForDate(collisions, as.Date(input$date))  
        g <- ggplot(df, aes(x=t, y=n)) + 
            geom_line(aes(alpha=0.02)) +
            geom_point(aes(alpha=0.02)) +
            theme_bw() + 
            ggtitle(sprintf("Hourly collisions for %s", input$date)) + 
            xlab('Date') + 
            ylab('Number of collisions') +
            theme(legend.position="none")

        print(g)
      })
})
