
## What is dplyr?
# dplyr is a grammar that makes data manipulation quick and easy.
# https://www.rstudio.com/wp-content/uploads/2015/02/data-wrangling-cheatsheet.pdf

## Why learn dplyr?
# Data scientists spend 80% of their time cleaning data.  Being able to quickly 
# clean and summarize data adds great value to your data science tasks.

## How does dplyr work?
#dplyr has broken down the data cleaning tasks using 6 verbs.
# These verbs are:
# select()	select columns
# filter()	filter rows
# arrange()	re-order or arrange rows
# mutate()	create new columns
# summarise()	summarise values/aggregations
# group_by()	allows for group operations, similar to SQL


#######################
# The select verb
#######################

# Install the dplyr library
install.packages('dplyr')

# load the dplyr library
library(dplyr)

# Install the nycflights13 library
install.packages('nycflights13')

# Load the nycflights13 library
library(nycflights13)

# Assign the flights data
flights = flights

# View the column names
names(flights)

# Select the carrier and origin columns
select(flights, carrier, origin)

# Select the dep_tim and distance columsn and assign it to x
x = select(flights, dep_time, distance)

# Use str() to view the data
str(x)

# Select all columns except flight
x = select(flights, -flight)

# Select all columns except flight and hour
x = select(flights, -flight, - hour)

# Look at the names of the columns
names(flights)

# Select the last three columns using ':'
select(flights, hour:time_hour)

# Use starts_with to select variables that start with "a"
select(flights, starts_with('a'))

# Use ends_with to select variables that end with "y"
select(flights, ends_with('y'))

# Use contains to select variables that contain "u"
select(flights, contains('u'))

## Practice: select the columns that contain "time"
select(flights, contains('time'))

## select columns dep_delay through carrier
names(flights)
select(flights, dep_delay:carrier)

## Select all columns except "tailnum", "day", and "arr_delay"
select(flights, -tailnum, -day, -arr_delay)

#######################
# The filter verb
#######################

# Filter the flights data for rows where the hour was greater than or equal to 5
filter(flights, hour >= 5)

# day is 1 or day is 5
filter(flights, day == 1 | day == 5)

# two column conditions, day is greater than 2 and hour is greater than 10
filter(flights, day > 2 & hour > 10)

# carrier %in% "B6"
filter(flights, carrier %in% 'B6')

# carrier %in% "B6" or "UA"
filter(flights, carrier %in% c('B6', 'UA'))

# carrier not in "B6" or "UA"
filter(flights, !carrier %in% c('B6', 'UA'))

## Practice: filter flights that were in October and and departed at 5
filter(flights, month == 10 & dep_time == 5)

## select flights where air_time is less than 100.
filter(flights, air_time < 100)

#######################
# The arrange verb
#######################

# Arrange flights by month
arrange(flights, month)

# Arrange flights by month and dep_delay
arrange(flights, month, dep_delay)

# arrange in descending order by month
arrange(flights, -month)

# arrange month by descending order dep_delay in ascending order
arrange(flights, -month, dep_delay)

## Practice: arrange the flights by carrier and month and assign to x
x = arrange(flights, carrier, month)

#######################
# The mutate verb
#######################

# Create the variable gain, arr_time minus dep_time
x = mutate(flights, gain = arr_time - dep_time)

## Practice:
## divide distance by air_time and create speed
x = mutate(x, speed = distance/air_time)

###################################
# Combining verbs and the pipe
###################################

# select the columns year, month, day, and carrier. 
# Then filter where month is 12.
filter(select(flights, year, month, day, carrier), month == 12)

# select the columns year, month, day, and carrier. 
# Then filter where month is 12 and arrange by day
arrange(filter(select(flights, year, month, day, carrier), month == 12), day)

# The pipe operator %>%
# Simplifies the process of combining multiple steps and functions
# Take the object to the left and pass it to the function on the right.

# Use the pipe and select the columns year, month, day, and carrier.
# Then filter where month is 12 and arrange by day
x = flights %>%
  select(year, month, day, carrier) %>%
  filter(month == 12) %>%
  arrange(day) %>%
  filter(day == 1)

## Practice:
## select carrier, distance, air_time, and month.
## filter where month is 5
## create variable mpm = distance/air_time
## arrange by mpm in descending order
flights %>%
  select(carrier, distance, air_time, month) %>%
  filter(month == 5) %>%
  mutate(mpm = distance/air_time) %>%
  arrange(-mpm)

## select origin, dest, dep_time, arr_time, carrier
## filter carriers 'AA' and 'DL'
## create travel_time, arr_time minus dep_time
## arrange by travel_time
flights %>%
  select(origin, dest, dep_time, arr_time, carrier) %>%
  filter(carrier %in% c('AA', 'DL')) %>%
  mutate(travel_time = arr_time - dep_time) %>%
  arrange(travel_time)

###################################
# The summarise verb
###################################

# find the mean, median, standard deviation, min, and max of distance
x = summarise(flights, mean = mean(distance), median = median(distance), 
        sd = sd(distance), min = min(distance), max = max(distance))
x
# find the average of air_time

## Practice:
## filter carrier by 'DL'
## find the average distnace, median distance

###################################
# The Group By Verb
###################################

# Calcuate the mean and median distance for each carrier.
x = flights %>%
  group_by(carrier) %>%
  summarise(mean_distance = mean(distance), median_distance = median(distance))

## Practice:
## filter for month 9 and 10
## group_by carrier and month
## calculate average distance
x = flights %>%
  filter(month == 9 | month == 10) %>%
  filter(month %in% c(9,10)) %>%
  group_by(carrier, month) %>%
  summarise(avg_distance = mean(distance))

## Practice:
  ## Load the titanic data.
setwd("~/Documents/Introduction-to-R")
titanic = read.csv('Titanic.csv')

head(titanic)
titanic %>%
  group_by(sex) %>%
  summarise(Survival_Rate = mean(survived))

titanic %>%
  group_by(pclass) %>%
  summarise(Survival_Rate = mean(survived))

titanic %>%
  group_by(sex, pclass) %>%
  summarise(Survival_Rate = mean(survived))









