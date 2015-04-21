loadFatalityDataset <- function(year) {
    ds <- c()
    zipFileName <- paste('data/NHTSA_Fatality-', year, '.zip', sep='')
    ds$accidents <- read.csv(unz(zipFileName, 'Accident-2013.csv'))
    ds$persons <- read.csv(unz(zipFileName, 'Person-2013.csv'))
    ds$vehicles <- read.csv(unz(zipFileName, 'Person-2013.csv'))
    ds$states <- read.csv('data/states.csv')
    ds$avm <- read.csv(paste('data/annual-vehicle-miles-', year, '.csv', sep=''))
    ds$urbanPct <- read.csv(paste('data/urban-percent-', year, '.csv', sep=''))
    ds
}

