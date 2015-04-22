library(shiny)
library(dplyr)
library(ggplot2)
library(scales)
library(shinydashboard)

getFatalitiesByWekdayData <- function(accidents) {
    df <- accidents %>% group_by(date) %>% summarize(fatalities=sum(FATALS))
    w <- as.POSIXlt(df$date)$wday
    weekdays <- c("Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday")
    df$weekday <- factor(weekdays[w+1], levels=weekdays)
    df
}

getTimingPlot1 <- function(ds) {
    df <- getFatalitiesByWekdayData(ds$accidents)
    g <- ggplot(df, aes(x=date, y=fatalities, color=weekday)) + 
        geom_point() +
        theme_bw() + 
        theme(legend.key = element_blank()) +
        theme(legend.title = element_blank()) +
        xlab('') +
        ylab('Fatalities')
    g
}

getFatalitiesByStateAndWeekdayData <- function(accidents) {
    df <- accidents %>% group_by(state, wday=as.POSIXlt(date)$wday) %>% summarize(fatalities=sum(FATALS))
    weekdays <- c("Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday")
    df$weekday <- factor(weekdays[df$wday+1], levels=weekdays)
    df
}

getTimingPlot2 <- function(ds) {
    df <- getFatalitiesByStateAndWeekdayData(ds$accidents)
    g <- ggplot(df, aes(x=state, y=fatalities, color=weekday)) + 
        geom_point() +
        theme_bw() + 
        theme(legend.key = element_blank()) +
        theme(legend.title = element_blank()) +
        xlab('') +
        ylab('Fatalities')
    g
}

shinyServer(function(input, output) {
    ds <- loadFatalityDataset(2013, '../../')
    output$timingPlot1 <- renderPlot({getTimingPlot1(ds)})
    output$timingPlot2 <- renderPlot({getTimingPlot2(ds)})
})


