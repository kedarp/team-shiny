library(shiny)
library(dplyr)
library(ggplot2)
library(scales)
library(shinydashboard)
library(ggvis)
library(dplyr)
if (FALSE) library(RSQLite)

source('../../util/dataloader2.R')
ds <<- {loadFatalityDataset(2013, '../../')}

getOverviewPlot1 <- function(ds) {
    df <- ds$trend
    g <- ggplot(df, aes(x=year, y=fatalities)) + 
        geom_point() +
        geom_line() +
        theme_bw() + 
        theme(legend.key = element_blank()) +
        theme(legend.title = element_blank()) +
        xlab('Year') +
        ylab('Fatalities')
    g
}

getOverviewPlot2 <- function(ds) {
    df <- ds$trend
    g <- ggplot(df, aes(x=year, y=f100Mvmt)) + 
        geom_point() +
        geom_line() +
        theme_bw() + 
        theme(legend.key = element_blank()) +
        theme(legend.title = element_blank()) +
        xlab('Year') +
        ylab('Fatalities Per 100M Vehicle Miles')
    g
}

getOverviewPlot3 <- function(ds) {
    df <- ds$trend
    g <- ggplot(df, aes(x=year, y=f100Kpop*10)) + 
        geom_point() +
        geom_line() +
        theme_bw() + 
        theme(legend.key = element_blank()) +
        theme(legend.title = element_blank()) +
        xlab('Year') +
        ylab('Fatalities Per Million people')
    g
}

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

getTimingPlot3 <- function(ds) {
    a <- ds$accidents
    a$qtr <- factor(quarters(a$date))
    df <- a %>% group_by(qtr, HOUR) %>% summarize(fatalities=sum(FATALS))
    df <- filter(df, HOUR < 24)
    g <- ggplot(df, aes(x=HOUR, y=fatalities, color=qtr, group=qtr)) + 
        geom_line() +
        theme_bw() + 
        theme(legend.key = element_blank()) +
        theme(legend.title = element_blank()) +
        xlab('Hour of day') +
        ylab('Fatalities')
    g
}

getTimingPlot4 <- function(ds) {
    a <- ds$accidents
    whour <- as.POSIXlt(a$date)$wday * 24 + a$HOUR
    a$qtr <- factor(quarters(a$date))
    df <- data.frame(a, whour) %>% group_by(whour, qtr) %>% summarize(fatalities=sum(FATALS))
    df <- filter(df, whour < 168)
    # We want to show actual weekday on the x axis so we have to resort to a trick. 2/1/2015 is a Sunday.
    df$t <- as.POSIXct('2015-02-01') + df$whour * 3600
    
    g <- ggplot(df, aes(x=t, y=fatalities, color=qtr, group=qtr)) + 
        geom_line() +
        theme_bw() + 
        theme(legend.key = element_blank()) +
        theme(legend.title = element_blank()) +
        scale_x_datetime(labels=date_format("%I%P\n%a"), breaks=date_breaks("12 hours")) +    xlab('') +
        ylab('Fatalities')
    g
}

getSummaryPlot1 <- function(ds,vehicle_year_slider) {
    min_year <- vehicle_year_slider[1]
    max_year <- vehicle_year_slider[2]
    
    a <- ds$vehicles
    df <- a %>% group_by(MOD_YEAR) %>% summarize(fatalities=sum(DEATHS))
    df <- df[df$MOD_YEAR<2015 & df$MOD_YEAR<max_year & df$MOD_YEAR>min_year,]
    
    
    g <- ggplot(df, aes(x=MOD_YEAR, y=fatalities)) + 
        geom_bar(stat='identity') +
        theme_bw() + 
        theme(legend.key = element_blank()) +
        theme(legend.title = element_blank()) +
        xlab('') +
        ylab('Fatalities')
    g
}

# Function for generating tooltip text
state_tooltip <- function(x) {
    if (is.null(x)) return('Null object')
    if (is.null(x$st)) return(print(state_fatal))
    
    # Pick out the state with this name
    paste0("<b>", x$st, "</b><br>",
           "Number of fatalities:", x$fatalities, "<br>",
           "Fatalities rate per 1 mln cars:", format(x$fatalities_rate, digits = 0),"<br>",
           "Totan number of cars:", format(state_fatal$Automobiles[state_fatal$st==x$st], big.mark = ',')
    )
}


get_states_plot_data <- function() {
    a <- ds$accidents
    states_pop <- ds$states_pop
    df <- a %>% group_by(State.Name) %>% summarize(fatalities=sum(FATALS))
    df$st <- toupper(df$State.Name)
    states_pop$st <- toupper(states_pop$State)
    state_fatal <- merge(df,states_pop,by='st')
    state_fatal$Automobiles <- as.numeric(gsub(",","", state_fatal$Automobiles))
    state_fatal$fatalities_rate <- state_fatal$fatalities/state_fatal$Automobiles*1000000
    state_fatal <- state_fatal[order(state_fatal$fatalities_rate),]
    state_fatal$NY <- 1*(state_fatal$st=="NEW YORK")+0
    return(state_fatal)
}

getTimingPlot5 <- function(ds) {
    df <- getFatalitiesByStateAndWeekdayData(ds$accidents)
    df <- left_join(df, ds$avm, by='state')
    df$fatalityRate <- df$fatalities/(df$avm/7) 
    df$state <- reorder(df$state, -df$fatalityRate)
    g <- ggplot(df, aes(x=state, y=fatalityRate, color=weekday)) + 
        geom_point() +
        theme_bw() + 
        theme(legend.key = element_blank()) +
        theme(legend.title = element_blank()) +
        xlab('') +
        ylab('Fatality Rate')
    g
}

getTimingPlot6 <- function(ds) {
    df <- ds$accidents %>% group_by(state) %>% summarize(fatalities=sum(FATALS))
    df <- left_join(df, ds$avm, by='state')
    df$fatalityRate <- df$fatalities/(df$avm/7) 
    df <- left_join(df, ds$urbanPct, by='state')
    df$state <- reorder(df$state, -df$fatalityRate)
    g <- ggplot(df, aes(x=urbanPct, y=fatalityRate)) + 
        geom_point() +
        theme_bw() + 
        theme(legend.key = element_blank()) +
        theme(legend.title = element_blank()) +
        xlab('') +
        ylab('Fatality Rate')
    g
}



shinyServer(function(input, output,session) {
    output$overviewPlot1 <- renderPlot({getOverviewPlot1(ds)})    
    output$overviewPlot2 <- renderPlot({getOverviewPlot2(ds)})    
    output$overviewPlot3 <- renderPlot({getOverviewPlot3(ds)})    
    output$timingPlot1 <- renderPlot({getTimingPlot1(ds)})
    output$timingPlot2 <- renderPlot({getTimingPlot2(ds)})
    output$timingPlot3 <- renderPlot({getTimingPlot3(ds)})
    output$timingPlot4 <- renderPlot({getTimingPlot4(ds)})
<<<<<<< HEAD
    output$summaryPlot1 <- renderPlot({
        x <- input$year_slider
        getSummaryPlot1(ds,x)}
        )
    

    ###### Dennis ggvis plot
        
        state_fatal <- get_states_plot_data()
        state_fatal %>% ggvis(~fatalities, ~fatalities_rate, key:=~st,stroke=~NY) %>% layer_points() %>%
            add_axis("x", title = "Fatalities") %>%
            add_axis("y", title = "Fatalities rate per 1 mln cars") %>%
            add_tooltip(state_tooltip, "hover") %>% bind_shiny("StatePlot1")
    
    ######
         
    
    
    
    
=======
    output$timingPlot5 <- renderPlot({getTimingPlot5(ds)})
    output$timingPlot6 <- renderPlot({getTimingPlot6(ds)})
#     output$summaryPlot1 <- renderPlot({
#         x <- input$year_slider
#         getSummaryPlot1(ds,x)}
#         )
>>>>>>> bd5b04e0ef66d44175faf459c264977bc5ff676c
})


