library(tidyverse)
library(lubridate)
library(gridExtra)

# load in the crime data
df <- read_csv('data/Police_Department_Incidents_-_Previous_Year__2016_.csv')


# filter the data to the top 4 crimes 
top4_df <- df %>% 
      drop_na() %>% 
      filter(Category == c('ASSAULT') |
             Category == 'LARCENY/THEFT' |
             Category == 'VANDALISM' |
             Category == 'VEHICLE THEFT')

# create a frequency table for the crimes in each neighborhood
neighborhood_freq <- as.data.frame(table(top4_df$PdDistrict)) %>% 
   mutate(Var1 = fct_reorder(as.factor(Var1), Freq, .desc = TRUE))
colnames(neighborhood_freq) <- c('neighborhood', 'Freq')


# make the frequency chart for crime over neighborhood
# note: static plot is counts of all 4 crimes together for each neighborhood
bar_chart <- neighborhood_freq %>% 
      ggplot(aes(x = neighborhood, y = Freq, fill = neighborhood)) + 
      geom_col() +
      labs(title = "Distribution of Crime Reports Across Neighborhood",
           x = "Neighborhood",
           y = 'Count of Report') + 
      theme(legend.position = 'none',
            title = element_text(size = 14),
            axis.title = element_text(size = 14),
            axis.text = element_text(size = 6)) + 
      scale_fill_brewer(palette = 'Spectral')

bar_chart


# make  map plot 
# note: static plot is density for all top 4 crimes in each neighborhood

map_plot <- top4_df %>% q
      ggplot(aes(x = X, y = Y, color = PdDistrict)) +
      geom_point(size = 0.07) +
      labs(title = 'Crime Density Across Neighborhoods',
           x = "Longitude",
           y = "Latitude") + 
      guides(color =guide_legend(title = "Neighborhood",
                                 size = 12,
                                 override.aes = list(size=5))) + 
      theme(title = element_text(size = 16),
            axis.title = element_text(size = 14),
            axis.text = element_text(size = 14),
            legend.text = element_text(size = 12)) + 
   scale_colour_brewer(palette = 'Spectral')
            
               
map_plot

grid.arrange(my_plot, map_plot, bar_chart, ncol = 2, nrow = 2)      
      
      
      


