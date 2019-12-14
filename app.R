library(dash)
library(dashCoreComponents)
library(dashHtmlComponents)
library(dashTable)
library(tidyverse)
library(plotly)
library(anytime)
library(lubridate)
library(dplyr)
library(wesanderson)

# get cwd
cwd <- getwd()
path_data <- paste0(cwd,'data/Police_Department_Incidents_-_Previous_Year__2016_.csv')
##### initialize the app #####
app <- Dash$new()

# load in the crime data
df <- read_csv(path_data)
# create factors
# df$Category <- df$Category %>% as.factor()
# create hour column
df <- separate(df, 'Date', 'Date', sep = " ") 
df$Date <- mdy(df$Date)
df$Hour <- hms(df$Time) %>% hour()

# filter the data to the top 4 crimes 
top4_df <- df %>%
      filter(Category %in% c("ASSAULT", "LARCENY/THEFT", "VEHICLE THEFT", "VANDALISM"))

top4_df$Category <- top4_df$Category %>% as.factor()

print("length of top 4 df")
print(length(top4_df))
print(length(unique(top4_df$Category)))
# make plot function neighborhood_freq
make_nf_plot <- function(data = top4_df){
  print('inside_make_nf_plot')
  print(length(data))
  print(length(data$PdDistrict))
  # create a frequency table for the crimes in each neighborhood
  neighborhood_freq <- as.data.frame(table(data$PdDistrict)) %>% 
    mutate(Var1 = fct_reorder(as.factor(Var1), Freq, .desc = TRUE))
  colnames(neighborhood_freq) <- c('neighborhood', 'Freq')
  
  # plot
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
  
  ggplotly(bar_plot)
}

# make time plot
make_tp <- function(data = top4_df){
  print("inside make_tp")
  print(length(data))
  n_unique <- data$Category %>% unique() %>% length()
  time_plot <- ggplot(data, aes(Category)) +
    geom_bar(stat='count', aes(fill=Category)) +
    labs(x = 'Crime Type',
         y = 'Aggregated Crime Count') +
    ggtitle('Crime Occurrences for Top 4 Crimes') +
    theme(plot.title = element_text(size = 14),
          axis.title=element_text(size=12),
          legend.position = 'none') +
    scale_fill_manual(values = wes_palette("Darjeeling1", n = n_unique))
  
  ggplotly(time_plot)
}

# make map plot 
make_mp <- function(data = top4_df){
  # make  map plot 
  # note: static plot is density for all top 4 crimes in each neighborhood
  print("inside mp")
  print(length(unique(data$Category)))
  map_plot <- data %>% 
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
  
  ggplotly(map_plot)
}

hourMarks <- lapply(unique(top4_df$Hour), as.character)
names(hourMarks) <- unique(top4_df$Hour)
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
      list(label = 'ASSAULT', value = 'ASSAULT'),
      list(label = 'LARCENY/THEFT', value = 'LARCENY/THEFT'),
      list(label = 'VEHICLE THEFT', value = 'VEHICLE THEFT'),
      list(label = 'VANDALISM', value = 'VANDALISM')
)

crimeDropdown <- dccDropdown(
  id='crime-dropdown',
  options=crime_options,
  value = levels(top4_df$Category),
  multi = TRUE,
  className = 'dcc_control'
)

# regionDropdown <- dccDropdown(
#   id = 'region-dropdown',
#   options = map(
#     levels(neighborhood_freq$neighborhood), function(x){
#     list(label=x, value=x)
#   }),
#   value = levels(neighborhood_freq$neighborhood), #Selects all by default
#   multi = TRUE
# )

graph1<- dccGraph(
  id = 'map-graph',
  figure=make_mp()
   # gets initial data using argument defaults
)

graph2<- dccGraph(
  id = 'bar-graph',
  figure=make_nf_plot()
   # gets initial data using argument defaults
)

graph3<- dccGraph(
  id = 'hourly-graph',
  figure=make_tp()
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

      # start of top row 
      htmlDiv(list( 

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
      className="eight columns") # end of the top row: control panel + time series

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

app$callback(
  #update figure of gap-graph
  output=list(id = 'hourly-graph', property='figure'),
  #based on values of year, continent, y-axis components
  params=list(input(id = 'hour-slider', property='value'),
              input(id = 'crime-dropdown', property='value')),
  #this translates your list of params into function arguments
  function(hour_values, crime_types) {
    print("Inside first callback")
    print(crime_types)
    df_filter <- top4_df %>% 
      filter(Category %in% crime_types)
    
    print("crime types:")
    print(length(crime_types))
    
    print("hour vals")
    print(length(hour_values))
    df_filter_2 <- df_filter %>% 
      filter(Hour %in% seq(hour_values[[1]], hour_values[[2]]))
    print("after filter 2")
    print(length(unique(df_filter_2$Category)))
    make_tp(df_filter_2)
  })

app$callback(
  #update figure of gap-graph
  output=list(id = 'bar-graph', property='figure'),
  #based on values of year, continent, y-axis components
  params=list(input(id = 'crime-dropdown', property='value')),
  #this translates your list of params into function arguments
  function(hour_values, crime_types) {
    print("Inside second callback")
    df_filter <- top4_df %>% 
      filter(Category %in% crime_types)

    df_filter_2 <- df_filter %>% 
      filter(Hour %in% seq(hour_values[[1]], hour_values[[2]]))
    
    make_nf_plot(df_filter_2)
  })
  
app$callback(
  #update figure of gap-graph
  output=list(id = 'map-graph', property='figure'),
  #based on values of year, continent, y-axis components
  params=list(input(id = 'crime-dropdown', property='value')),
  #this translates your list of params into function arguments
  function(hour_values, crime_types) {
    print("Inside third callback")
    df_filter <- top4_df %>% 
      filter(Category %in% crime_types)
    
    df_filter_2 <- df_filter %>% 
      filter(Hour %in% seq(hour_values[[1]], hour_values[[2]]))
    make_mp(df_filter_2)
  })

app$run_server(host = "0.0.0.0", port = Sys.getenv('PORT', 8050))
