library(dash)
library(dashCoreComponents)
library(dashHtmlComponents)
library(dashTable)
library(tidyverse)
library(plotly)
library(anytime)
library(lubridate)
library(dplyr)

app <- Dash$new(external_stylesheets = "https://codepen.io/chriddyp/pen/bWLwgP.css")

# load in the crime data
df <- read_csv('documents/mds_532/vs-sf_crime-statistic-dashboard/data/Police_Department_Incidents_-_Previous_Year__2016_.csv')


# filter the data to the top 4 crimes 
top4_df <- df %>% 
      drop_na() %>% 
      filter(Category == c('ASSAULT') |
             Category == 'LARCENY/THEFT' |
             Category == 'VANDALISM' |
             Category == 'VEHICLE THEFT')

# create a frequency table for the crimes in each neighborhood
neighborhood_freq <- as.data.frame(table(top4_df$PdDistrict))
colnames(neighborhood_freq) <- c('neighborhood', 'Freq')

hourMarks <- map(list(0, 23), as.character)
hourSlider <- dccRangeSlider(
  # TODO: Add id to component
  marks = hourMarks,
  min = 0,
  max = 23,
  step=1,
  value = list(0, 23)
)

crimeDropdown <- dccDropdown(
            
      options=list(
    list(label = "Assault", value = "ASSAULT"),
    list(label = "Larceny/theft", value = "LARCENY/THEFT"),
    list(label = "Vandalism", value = "VANDALISM"),
    list(label = "Vehicle theft", value = "VEHICLE THEFT")
  ),
  value = " ASSAULT",
  multi = TRUE
)

regionDropdown <- dccDropdown(
  # TODO: Add id to component
  # purrr:map can be used as a shortcut instead of writing the whole list
  # especially useful if you wanted to filter by country!
  options = map(
    levels(neighborhood_freq$neighborhood), function(x){
    list(label=x, value=x)
  }),
  value = levels(neighborhood_freq$neighborhood), #Selects all by default
  multi = TRUE
)

# make the frequency chart for crime over neighborhood
# note: static plot is counts of all 4 crimes together for each neighborhood
bar_chart <- neighborhood_freq %>% 
      ggplot(aes(x = reorder(neighborhood, -neighborhood_freq$Freq), y = Freq, fill = neighborhood)) + 
      geom_col() +
      labs(title = "Distribution of Crime Reports Across Neighborhood",
           x = "Neighborhood",
           y = 'Count of Report') + 
      theme(legend.position = 'none',
            title = element_text(size = 14),
            axis.title = element_text(size = 14),
            axis.text = element_text(size = 6)) + 
      scale_fill_brewer(palette = 'Spectral')



# make  map plot 
# note: static plot is density for all top 4 crimes in each neighborhood

map_plot <- top4_df %>% 
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
            
               
df <- separate(df, 'Date', 'Date', sep = " ") 
df$Date <- mdy(df$Date)
df$Hour <- hm(df$Time) %>% hour()

df_4 <- filter(df, Category %in% c('ASSAULT', 'VANDALISM', 'VEHICLE THEFT', 'LARCENY/THEFT'))

time_plot <- ggplot(df_4, aes(Category, color = Category)) +
              geom_bar(stat='count') +
              labs(x = 'Category of crime',
                   y = 'Aggregated count of crimes') +
              ggtitle('Crime occurrences for top 4 crimes') +
              theme(plot.title = element_text(size = 16),
                    axis.title=element_text(size=12))


graph1<- dccGraph(
  id = 'gap-graph',
  figure=ggplotly(map_plot)
   # gets initial data using argument defaults
)

graph2<- dccGraph(
  id = 'bar-graph',
  figure=ggplotly(bar_chart)
   # gets initial data using argument defaults
)

graph3<- dccGraph(
  id = 'time-graph',
  figure=ggplotly(time_plot)
   # gets initial data using argument defaults
)

app$layout(
  htmlDiv(
    list( 
          hourSlider,
          graph1,
          graph2,
          graph3,
          crimeDropdown,
          regionDropdown
    )
  )
) 
  

app$run_server()
