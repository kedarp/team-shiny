prepareAccidents <- function(a) {
    a$date <- as.Date(sprintf('%4s-%02s-%02s', a$YEAR, a$Month, a$Calendar_DAY))
    a$state <- a$State.Abbreviation
    a
}

loadFatalityDataset <- function(year, rootDir='') {
    ds <- c()
    zipFileName <- paste(rootDir, 'data/NHTSA_Fatality-', year, '.zip', sep='')
    ds$accidents <- read.csv(unz(zipFileName, 'Accident-2013.csv'))
    ds$accidents <- prepareAccidents(ds$accidents)
    
    ds$persons <- read.csv(unz(zipFileName, 'Person-2013.csv'))
    
    ds$vehicles <- read.csv(unz(zipFileName, 'Vehicle-2013.csv'))
    ds$states <- read.csv(paste(rootDir, 'data/states.csv', sep=''))
    ds$avm <- read.csv(paste(rootDir, 'data/annual-vehicle-miles-', year, '.csv', sep=''))
    ds$urbanPct <- read.csv(paste(rootDir, 'data/urban-percent-', year, '.csv', sep=''))
    ds
}

