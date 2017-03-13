# Reproducible Research: Peer Assessment 1


## Loading and preprocessing the data

```r
library(ggplot2)
```

```
## Warning: package 'ggplot2' was built under R version 3.3.2
```

```r
if(!file.exists("./activity.csv") && file.exists("./activity.zip")){
        unzip("./activity.zip")
}else if(!file.exists("./activity.zip")){
        stop("activity.zip file does not exists.")
}
activities <- read.csv("./activity.csv")
activities$time <- as.POSIXct(sprintf("%04d", activities$interval), format = "%H%M")
activities$asDate <- as.Date(activities$date, format = "%Y-%m-%d")
```



## What is mean total number of steps taken per day?
### 1. Calculate the total number of steps taken per day

```r
agg <- tapply(activities$steps, activities$date, sum, na.rm = T)
```
### 2. Make a histogram of the total number of steps taken each day

```r
qplot(agg, main = "Number of steps taken per day")
```

```
## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.
```

![](PA1_template_files/figure-html/unnamed-chunk-3-1.png)<!-- -->

### 3. Calculate and report the mean and median of the total number of steps taken per day

```r
aggMean <- tapply(activities$steps, activities$date, mean, na.rm = T)
aggMedian <- tapply(activities$steps, activities$date, median, na.rm = T)
```



## What is the average daily activity pattern?



## Imputing missing values



## Are there differences in activity patterns between weekdays and weekends?
