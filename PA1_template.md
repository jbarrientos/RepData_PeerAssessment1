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
##### 1. Calculate the total number of steps taken per day

```r
agg <- tapply(activities$steps, activities$date, sum, na.rm = T)
```
##### 2. Make a histogram of the total number of steps taken each day

```r
qplot(agg, main = "Number of steps taken per day")
```

```
## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.
```

![](PA1_template_files/figure-html/unnamed-chunk-3-1.png)<!-- -->

##### 3. Calculate and report the mean and median of the total number of steps taken per day

```r
aggMean <- mean(agg)
aggMedian <- median(agg)

aggMean
```

```
## [1] 9354.23
```

```r
aggMedian
```

```
## [1] 10395
```



## What is the average daily activity pattern?
##### 1. Make a time series plot (i.e. type = "l") of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all days (y-axis)

```r
dailyAvg <- aggregate(activities$steps, by = list(interval = activities$interval), FUN = mean, na.rm = T)

ggplot(dailyAvg, aes(interval, x)) + geom_line()  + xlab("Intervals") + ylab("AVG") 
```

![](PA1_template_files/figure-html/unnamed-chunk-5-1.png)<!-- -->

##### 2. Which 5-minute interval, on average across all the days in the dataset, contains the maximum number of steps?



```r
dailyAvg[dailyAvg$x == max(dailyAvg$x),]
```

```
##     interval        x
## 104      835 206.1698
```

## Imputing missing values

##### 1. Calculate and report the total number of missing values in the dataset (i.e. the total number of rows with NAs)

```r
nrow(activities[is.na(activities$steps),])
```

```
## [1] 2304
```

##### 2. Devise a strategy for filling in all of the missing values in the dataset. The strategy does not need to be sophisticated. For example, you could use the mean/median for that day, or the mean for that 5-minute interval, etc.

```r
## File with a function used to fill NA's values with the mean of intervals
source("./functions.R")
## NA's lines
activitiesNAS <- activities[is.na(activities$steps),]
## Filled lines
activitiesFilled <- activities[!is.na(activities$steps),]
## Invoke funtion to get filled steps
activitiesFilled2 <- fill.na(activitiesFilled, activitiesNAS)
```
##### 3. Create a new dataset that is equal to the original dataset but with the missing data filled in.

```r
## Merge Rows
activitiesOK = rbind(activitiesFilled, activitiesFilled2)
```
##### 4. Make a histogram of the total number of steps taken each day and Calculate and report the mean and median total number of steps taken per day. Do these values differ from the estimates from the first part of the assignment? What is the impact of imputing missing data on the estimates of the total daily number of steps?

```r
aggFilled <- tapply(activitiesOK$steps, activitiesOK$date, sum, na.rm = T)
qplot(aggFilled, main = "Number of steps taken per day")
```

```
## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.
```

![](PA1_template_files/figure-html/unnamed-chunk-10-1.png)<!-- -->

```r
meanActivitiesOK <- mean(aggFilled)
medianActivitiesOK <- median(aggFilled)
```


## Are there differences in activity patterns between weekdays and weekends?
##### 1. Create a new factor variable in the dataset with two levels - "weekday" and "weekend" indicating whether a given date is a weekday or weekend day.

```r
## activitiesOK$asDate <- as.Date(activitiesOK$date, format = "%Y-%m-%d")
activityDays <- ifelse(weekdays(activitiesOK$asDate) %in% c("Monday","Tuesday","Wednesday","Thursday","Friday"), yes = "Weekday", no = "Weekend")
activitiesOK$day <- activityDays
table(activitiesOK$day)
```

```
## 
## Weekday Weekend 
##   12960    4608
```
##### 2. Make a panel plot containing a time series plot (i.e. type = "l") of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all weekday days or weekend days (y-axis). See the README file in the GitHub repository to see an example of what this plot should look like using simulated data.


```r
avgActivitiesOK <- aggregate(steps ~ interval + day, data=activitiesOK, mean)

ggplot(avgActivitiesOK,aes(x=interval,y=steps, col=day))+geom_point()+facet_wrap(~day) + geom_line() + theme_bw() + xlab("5 Min. Interv.") + ylab("AVG No. Steps")
```

![](PA1_template_files/figure-html/unnamed-chunk-12-1.png)<!-- -->


