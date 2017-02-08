library(data.table)
library(dplyr)
library(bit64)
library(ggplot2)
library(ggmap)

landslide = fread("landslides_data.csv")

# removing unnecessary features/columns
landslide = landslide[, c(4,22,23) := NULL]

# checking missing values
colSums(is.na(landslide))

landslide$injuries = 0
landslide$fatalities = 0

# Now there is one single case for which latitude and longitude are not given in the data
# ...so let's delete this case and move ahead
landslide = landslide[!is.na(latitude)]

# Converting to date format
landslide$date = as.Date(landslide$date, "%m/%d/%y")
# Extracting year and month from the date feature
landslide$year = year(landslide$date)
landslide$month = month(landslide$date)

###########################################################################

mapWorld = borders("world", colour="black", fill="black") # create a layer of borders
mp = ggplot() + mapWorld

# final plot of lanslides between the years 2007 and 2016, denoted by different colours
ls_plot = mp + geom_point(data =landslide, aes(x = longitude, y = latitude, colour = factor(year)), size = 1)
print(ls_plot)

ggsave(ls_plot, file="landslides_plot.png")