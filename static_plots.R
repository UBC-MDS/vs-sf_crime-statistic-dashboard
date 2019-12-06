library(tidyverse)
library(lubridate)

# load in the crime data
df <- read_csv('data/Police_Department_Incidents_-_Previous_Year__2016_.csv')


# filter the data to the top 4 crimes 
top4_df <- df %>% 
      filter(Category == c('ASSAULT') |
             Category == 'LARCENY/THEFT' |
             Category == 'VANDALISM' |
             Category == 'VEHICLE THEFT')

# create a frequency table for the crimes in each neighborhood
neighborhood_freq <- as.data.frame(table(top4_df$PdDistrict))
colnames(neighborhood_freq) <- c('neighborhood', 'Freq')


# make the frequency chart for crime over neighborhood
# note: static plot is counts of all 4 crimes together for each neighborhood
neighborhood_freq %>% 
      ggplot(aes(x = reorder(neighborhood, -neighborhood_freq$Freq), y = Freq, fill = neighborhood)) + 
      geom_col() +
      labs(title = "Distribution of Crime Reports Across Neighborhood",
           x = "Neighborhood",
           y = 'Count of Report') + 
      theme(legend.position = 'none') + 
      scale_fill_brewer(palette = )


