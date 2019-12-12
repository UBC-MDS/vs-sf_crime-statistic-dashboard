library(dash)
library(dashCoreComponents)
library(dashHtmlComponents)
library(dashTable)
library(tidyverse)
library(plotly)
library(anytime)
library(lubridate)
library(dplyr)


##### initialize the app #####
app <- Dash$new()

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

hourMarks <- map(list(0, 23), as.character)
hourSlider <- dccRangeSlider(
  id='hour-slider',
  marks = hourMarks,
  min = 0,
  max = 23,
  step=1,
  value = list(0, 23),
  className="dcc_control"
)

# store the crime categories for drop down
crime_options <- list(
      list(label = 'ASSAULT', value = 'default'),
      list(label = 'LARCENY/THEFT', value = 'LARCENY/THEFT'),
      list(label = 'VEHICLE THEFT', value = 'VEHICLE THEFT'),
      list(label = 'VANDALISM', value = 'VANDALISM')
)

crimeDropdown <- dccDropdown(
  id='crime-dropdown',
  options=crime_options,
  value = " ASSAULT",
  multi = TRUE,
  className = 'dcc_control'
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
bar_plot <- neighborhood_freq %>% 
      ggplot(aes(x = neighborhood, y = Freq, fill = neighborhood)) + 
      geom_col() +
      labs(title = "Distribution of Crime Reports Across Neighborhood",
           x = "Neighborhood",
           y = 'Count of Report') + 
      theme(legend.position = 'none',
            title = element_text(size = 12),
            axis.title = element_text(size = 14),
            axis.text = element_text(size = 6)) + 
      scale_fill_brewer(palette = 'Spectral')



# make  map plot 
# note: static plot is density for all top 4 crimes in each neighborhood

map_plot <- top4_df %>% 
      ggplot(aes(x = X, y = Y, color = PdDistrict)) +
      geom_point(size = 0.02) +
      labs(title = 'Crime Density Across Neighborhoods',
           x = "Longitude",
           y = "Latitude") + 
      guides(color =guide_legend(title = "Neighborhood",
                                 size = 12,
                                 override.aes = list(size=5))) + 
      theme(title = element_text(size = 14),
            axis.title = element_text(size = 14),
            axis.text = element_text(size = 10),
            legend.text = element_text(size = 10)) + 
   scale_colour_brewer(palette = 'Spectral')
            
               
df <- separate(df, 'Date', 'Date', sep = " ") 
df$Date <- mdy(df$Date)
df$Hour <- hm(df$Time) %>% hour()

df_4 <- filter(df, Category %in% c('ASSAULT', 'VANDALISM', 'VEHICLE THEFT', 'LARCENY/THEFT'))

time_plot <- ggplot(df_4, aes(Category, color = Category)) +
              geom_bar(stat='count') +
              labs(x = 'Crime Type',
                   y = 'Aggregated Crime Count') +
              ggtitle('Crime Occurrences for Top 4 Crimes') +
              theme(plot.title = element_text(size = 14),
                    axis.title=element_text(size=12),
                    legend.position = 'none') + 
              scale_colour_brewer(palette = 'Spectral')


graph1<- dccGraph(
  id = 'map-graph',
  figure=ggplotly(map_plot)
   # gets initial data using argument defaults
)

graph2<- dccGraph(
  id = 'bar-graph',
  figure=ggplotly(bar_plot)
   # gets initial data using argument defaults
)

graph3<- dccGraph(
  id = 'hourly-graph',
  figure=ggplotly(time_plot)
   # gets initial data using argument defaults
)

app$layout(
  htmlDiv(
    list(

# page header components
      htmlDiv(list(

            htmlDiv(
                  list(
                        htmlImg(
                              src="/assets/mds_img.png",
                              id="mds-image",
                              style=list(
                                    "height"= "60px",
                                    "width"= "auto",
                                    "margin-bottom"= "25px"
                                     )

                        )),
                   className="one-third column"
            ),


         htmlDiv(
          list(
            htmlDiv(
              list(
                htmlH3(
                  "San Francisco Crime Rates",
                  style=list("margin-bottom"= "0px")
                ),
                htmlH5(
                  "Incidents for 2016", style=list("margin-top"= "0px")
                )
              )
            )
          ),
          className="one-half column",
          id="title"
        ),

        htmlDiv(
          list(
            htmlA(
              htmlButton("Data Source", id="data-source-button"),
              href="https://www.kaggle.com/roshansharma/sanfranciso-crime-dataset"
            )
          ),
          className="one-third column",
          id="button"
        )

      ), # end of header components list

      id="header",
      className="row flex-display",
      style=list("margin-bottom"= "25px")

      ),
      # end of page header div container


      htmlDiv(list( # start of top row 

            # start of the control panel 
            htmlDiv(
            list(
                  htmlP(
                  "Filter by Hour of the Day:",
                  className="control_label"
                  ),
                  hourSlider,
                  htmlP("Filter by Crime Category:", className="control_label"),
                  crimeDropdown


            ),
            className="pretty_container four columns",
            id="cross-filter-options"
      ), # end of the control panel 

      htmlDiv(list(

            htmlDiv(
              list(graph3),
              id="countGraphContainer",
              className="pretty_container"
            )

      
      ),
      id="right-column",
      className="eight columns")

),

className="row flex-display"

 ),


# start of 2nd row of graphs 
 htmlDiv(
      list(
        htmlDiv(
          list(graph2),
          className="pretty_container six columns"
        ),
        htmlDiv(
          list(graph1),
          className="pretty_container six columns"
        )
      ),
      className="row flex-display"
    )
  


),
id="mainContainer",
style=list("display"= "flex", "flex-direction"= "column") 
)

)
  

app$run_server()
