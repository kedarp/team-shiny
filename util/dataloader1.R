loadDataset1 <- function(filename) {
    df <- read.csv(filename, stringsAsFactors=F)
    df$BOROUGH <- factor(df$BOROUGH)
    df$ZIP.CODE <- factor(df$ZIP.CODE)
    
    df$CONTRIBUTING.FACTOR.VEHICLE.1 <- factor(df$CONTRIBUTING.FACTOR.VEHICLE.1)
    df$CONTRIBUTING.FACTOR.VEHICLE.2 <- factor(df$CONTRIBUTING.FACTOR.VEHICLE.2)
    df$CONTRIBUTING.FACTOR.VEHICLE.3 <- factor(df$CONTRIBUTING.FACTOR.VEHICLE.3)
    df$CONTRIBUTING.FACTOR.VEHICLE.4 <- factor(df$CONTRIBUTING.FACTOR.VEHICLE.4)
    df$CONTRIBUTING.FACTOR.VEHICLE.5 <- factor(df$CONTRIBUTING.FACTOR.VEHICLE.5)
    
    df$VEHICLE.TYPE.CODE.1 <- factor(df$VEHICLE.TYPE.CODE.1)
    df$VEHICLE.TYPE.CODE.2 <- factor(df$VEHICLE.TYPE.CODE.2)
    df$VEHICLE.TYPE.CODE.3 <- factor(df$VEHICLE.TYPE.CODE.3)
    df$VEHICLE.TYPE.CODE.4 <- factor(df$VEHICLE.TYPE.CODE.4)
    df$VEHICLE.TYPE.CODE.5 <- factor(df$VEHICLE.TYPE.CODE.5)
    
    df$t <- as.POSIXct(paste(df$DATE, df$TIME), format='%m/%d/%Y %H:%M')
    df$DATE <- as.Date(df$DATE, format='%m/%d/%Y')
    df
}

loadCollisions1_Mini <- function() {
    loadDataset1( '../data/collisions1-mini.csv.gz')   
}

loadCollisions1_Full <- function() {
    loadDataset1( '../data/collisions1-full.csv.gz')   
}
