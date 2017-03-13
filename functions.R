fill.na <- function(ds, dsNA){
        
        means <- tapply(ds$steps, ds$interval, mean)

        for(i in 1:288){
                ## Update with the mean
                dsNA[dsNA$interval == as.integer(names(means[i])),]$steps <- means[i]
        }
        return (dsNA)
}