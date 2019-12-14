library(dash)
library(dashCoreComponents)
library(dashHtmlComponents)
#library(tidyverse)
library(ggplot2)
library(dplyr)
library(tidyr)
library(readr)
library(purrr)
library(tibble)
library(forcats)
library(RColorBrewer)

library(plotly)

df <- read_csv("https://raw.githubusercontent.com/UBC-MDS/Group_105_R/master/data/birdstrikes_clean.csv")

app <- Dash$new(external_stylesheets = "https://codepen.io/chriddyp/pen/bWLwgP.css")


#DCC COMPONENTS
#===================================

#SELECTORS
#-----------------------------------
dropdown_selector_tab1 <- dccDropdown(
    id = "damage_types_dropdown_tab1",
    options = list(
        list(label = "None Damage", value = "None"),
        list(label = "Minor Damage", value = "Minor"),
        list(label = "Medium Damage", value = "Medium"),
        list(label = "Substantial Damage", value = "Substantial")
    ),
    multi = TRUE,
    value = list("Minor", "Medium", "Substantial"),
    style = list(width = '60%')
)

dropdown_selector_tab2 <- dccDropdown(
    id = "damage_types_dropdown_tab2",
    options = list(
        list(label = "None Damage", value = "None"),
        list(label = "Minor Damage", value = "Minor"),
        list(label = "Medium Damage", value = "Medium"),
        list(label = "Substantial Damage", value = "Substantial")
    ),
    multi = TRUE,
    value = list("None", "Minor", "Medium", "Substantial"),
    style = list(width = '60%')
)

rangeslider_selector <- dccRangeSlider(
    id = "date_slider",
    marks = list(
        "1990" = "1990", 
        "1991" = "1991",
        "1992" = "1992",
        "1993" = "1993",
        "1994" = "1994",
        "1995" = "1995",
        "1996" = "1996",
        "1997" = "1997",
        "1998" = "1998",
        "1999" = "1999",
        "2000" = "2000",
        "2001" = "2001"
    ),
    count = 12,
    min = 1990,
    max = 2002,
    step = 1,
    value = list(1990, 2002),
    # style = list(width = '50%')
)

dropdown_barchart <- dccDropdown(
    id = "bar_dropdown",
    options = list(
        list(label = "Flight Phase", value = "flight_phase"),
        list(label = "Time of Day", value = "time_of_day"),
        list(label = "Bird Size", value = "bird_size")
    ),
    value = "flight_phase",
    style = list(width = '48%')
)

dropdown_heatmap <- dccDropdown(
    id = "heatmap_dropdown",
    options = list(
        list(label = "State", value = "state"),
        list(label = "Airport", value = "airport")
    ),
    value = "state",
    style = list(width = '30%')
)

#TITLE BLOCK
#-----------------------------------
paragraph <- htmlDiv(list(
  htmlDiv(list(
      htmlDiv(list(
          htmlH2("Aircraft Bird Strikes"),
          dccMarkdown(
              "The purpose of the app is to investigate the effect of birdstrikes on aircraft between 1990 and 2002 in the United States for 29 states.  
              Different factors (flight phase, time of day, bird size) and regions (states, airports) are explored, visualizing four classes of damage to aircraft."),
        htmlBr(),
        dccMarkdown(
            "The aim of __Tab 1__ is to visualize the trend of, number of, and damage caused by birdstrikes between 1990 and 2002.   
            The visualizations in this tab explore what factors affect the number and of and damage caused by bird strikes.  
            The aim of __Tab 2__ is to explore which states and airports observed the largest number of bird strikes between 1990 and 2002."
          ),             
        htmlBr()
      ), className = "six columns", 
         style = list('padding-left'= '130px', 'padding-right'= '130px')
      ),      
      htmlDiv(list(htmlImg(src='https://cdn.pixabay.com/photo/2012/04/16/13/55/swans-36088_960_720.png', width = '35%')),
        className = "six columns")
    ), className = "row"
  )
), style= list("background-color"= "#d1e8f7")
)
    
#GRAPHS
#-----------------------------------

line <- dccGraph(id = 'line_plot')
bar <- dccGraph(id = 'bar_plot')
heatmap <- dccGraph(id = 'heatmap_plot') 

# TAB OBJECTS
#==========================

tab1_selectors <- htmlDiv(list(
    htmlDiv(list(
        htmlH5("Damage Type"),
        htmlH6("Plot: Both"),
        dropdown_selector_tab1,
        htmlBr()
        ), className = "row"
    ),
    htmlDiv(list(
        htmlDiv(list(
            htmlH5("Date Range Between 1990 - 2002"), 
            htmlH6("Plot: Bird Strike Damage Over Time"),
            rangeslider_selector,
            htmlBr(),
            htmlBr()
            ), className = "six columns"),
        htmlDiv(list(
            htmlH5("Factor"), 
            htmlH6("Plot: Effect of (factor) on Birdstrikes"),
            dropdown_barchart,
            htmlBr()
            ), className = "six columns")
        ), className = "row"
    ),
    htmlDiv(list(
        htmlHr()
        ), className = "row"
    ),
    htmlDiv(list(
        htmlDiv(list(
            line
        ), className = "six columns"),
        htmlDiv(list(
            bar
        ), className = "six columns")
        ), className = "row"
    ),
    htmlDiv(list(
        htmlHr()
        ), className = "row"
    ),
    htmlDiv(list(
        dccMarkdown(
            "__Example Questions__  
            Using the interactive tools above, try answering the following:    

            - How has the number of bird strikes causing substantial damage changed between 1994 and 1999?    
            - What is the difference between birdstrikes causing minor damage and medium damage in 1996?   
            - What time of day results in the most birdstrikes causing substantial damage?  
            - What is the difference between the number of large bird and small bird birdstrikes that caused no damage?"
            )
        ), className = "row"
    ),
    htmlDiv(list(
        htmlHr()
        ), className = "row"
    )
), style = list('padding-left'= '130px',
                'padding-right'= '130px')
)

tab2_selectors <- htmlDiv(list(
    htmlDiv(list(
        htmlH5("Damage Type"),
        htmlH6("Plot: Both"),
        dropdown_selector_tab2,
        htmlBr(),
        htmlH5("Location Type"),
        htmlH6('Plot: Birdstrikes by Location'),
        dropdown_heatmap,
        htmlHr(),
        heatmap,
        htmlHr(),
        dccMarkdown(
        "__Example Questions__  
        Using the interactive tools above, try answering the following:    

        - What state experienced the most birdstrikes and in what year?  
        - What airport experienced the most birdstrikes and in what year and state did this occur?  
        - What states experienced the most birdstrikes causing minor damage and in what year did this occur?"
        )
        ), className = "row"
    )
), style = list('padding-left'= '130px',
                'padding-right'= '130px')
)
    

tabs <- htmlDiv(list(
            dccTabs(id="tabs", value='tab-1', 
                    # style = list('padding-left'= '130px',
                    #          'padding-right'= '130px'), 
                    colors= list("border"= "white",
                             "primary"= "dodgerblue",
                             "background"= "AliceBlue"),
                    children = list(
                        dccTab(label='Tab 1 - Bird Strikes Trends & Factors', value='tab-1'),
                        dccTab(label='Tab 2- Bird Strikes by Location', value='tab-2')
                    )),
                    htmlDiv(id='tabs-content')#, style = {'backgroundColor':'tan'})
            ))

app$callback(output(id ='tabs-content', property = 'children'),
            params = list(input(id = 'tabs', property = 'value')),
            function(tab){
                if(tab == 'tab-1'){
                    return(htmlDiv(list(
                        tab1_selectors
                    )))
                }
                else if(tab == 'tab-2'){
                    return(htmlDiv(list(
                        tab2_selectors
                    ))) 
                }
            })


# APP LAYOUT
#==========================
app$layout(
  htmlDiv(
    list(
    paragraph,
    tabs,
    dccMarkdown(
          "[Photo Attribution](https://pixabay.com/vectors/swans-silhouette-black-flying-36088/)"
          )
    )))

# PLOT CREATION 
#==========================

#HEATMAP
#--------------------------
y_varKey <- tibble(label = c("State", "Ariport"),
                   value = c("state", "airport"))
dmg_unique <- unique(df$damage_level)

make_heatmap_plot <- function( dmg_lvl = dmg_unique, y_var = state){ #years = c(1990,2002)
    
  dmg_vect <- vector() # these 3 lines can be removed - depending on what form the call back takes
  for(i in dmg_lvl){
    dmg_vect <- c(dmg_vect, i) 
  }
    
  y_label <- y_varKey$label[y_varKey$value==y_var] # extracting name for the y label from table defined outside of function
    
  if(length(dmg_vect) != 0 ){ # next two rows are wrangling the dataframe
        w_df <- df %>% filter(damage_level %in% dmg_vect) %>% group_by(year, !!sym(y_var)) %>%   summarize(count = n())
        
        # creat ggplot object
    h_plot <- ggplot(data = w_df, aes(x = factor(year), y = factor(!!sym(y_var)))) +
        geom_tile(aes(fill = count)) +
        scale_fill_continuous(type = "viridis") +
        labs(x = "Year", y = y_label, title = paste("Bird Strikes by ", y_label)) +
        theme_minimal()
        
        # create plotly object - should be last peice of function 
    
    if(y_var == "State"){
        h = 600
        w = 900
    }
    else{
        h = 900
        w = 1100
    }
    plotly_graph <- ggplotly(h_plot, height = h, width = w) %>%
                        config(modeBarButtonsToRemove = c("zoom2d", "zoomIn2d", "zoomOut2d", "pan2d", "select2d", "lasso2d", "toggleSpikelines", "hoverCompareCartesian"),displaylogo = FALSE)
    return(plotly_graph)
      }
      return(None)
    
  }

#Line/Area Plot
#--------------------------
# dmg_unique <- unique(df$damage_level)
make_linegraph <- function(years = c(1990,2002), dmg_lvl = dmg_unique){ #years=c(1990, 2002)
    dmg_vect <- vector()
    for(i in dmg_lvl){
        dmg_vect <- c(dmg_vect, i) 
    }
    if(length(dmg_vect) != 0 ){  
        w_df <- df %>% filter(damage_level %in% dmg_vect) %>% 
                   filter(year >= years[1] & year <= years[2]) %>% 
                   group_by(year, damage_level) %>% 
                   summarise(count = n())

        w_df$damage_level <- factor(w_df$damage_level,levels = c('Substantial', 'Medium', 'Minor', 'None')) # Fixing Legend order
        area_plot <- ggplot(w_df, aes(x= year, y= count, fill= damage_level)) + 
            geom_area(position = "identity", alpha=0.3 , size=0.3) + 
            scale_x_continuous(breaks = unique(w_df$year)) +
            scale_fill_manual(values=c("Substantial" = "red", "Medium" = "#0066FF","Minor" = "grey", "None" = "#339933")) + 
            labs(y = "Total Bird Strikes",
                 x = "Year",
                 fill = "Damage_level",
                 title = "Bird Strike Damage over Time") +
            theme_bw()
        area_plot <- area_plot + theme(legend.text= element_text(color = "black", size = 10),legend.position = "top",
                                       legend.title= element_text(color = "black", size = 12)) 
        # Removes extra plotly buttoms and create plotly object 
        area_plot <- ggplotly(area_plot)%>% config(modeBarButtonsToRemove = c("zoom2d", "zoomIn2d", "zoomOut2d", "pan2d",
                                                            "hoverClosestCartesian", "resetScale2d"),
                                                   displaylogo = FALSE)    
        area_plot <- ggplotly(area_plot, height = 4, width = 9) # Set dimensions for the plot
    return(area_plot)                     
    }
    return(None)
}

#Bar Plot
#--------------------------
# Defining Default values for plot
# dmg_unique <- unique(df$damage_level)

# gets the label matching the column value
xaxisKey <- tibble(label = c("Flight Phase", "Bird Size", "Time of Day"),
                   value = c("flight_phase", "bird_size", "time_of_day"))

make_bargraph <- function(xaxis, dmg_lvl = dmg_unique){

    dmg_vect <- vector()
    
    for(i in dmg_lvl){
        dmg_vect <- c(dmg_vect, i) 
    }
    
    if(length(dmg_vect) != 0 ){
    
        w_df <- df %>% filter(damage_level %in% dmg_vect) %>% 
                   #filter(year >= years[1] & year <= years[2]) %>% # This was not included in the python version but does not hurt
                   group_by(damage_level, !!sym(xaxis)) %>% 
                   summarise(count = n())
        
        w_df$damage_level <- factor(w_df$damage_level,levels = c('Substantial', 'Medium', 'Minor', 'None')) # Fixing Legend order
        
    x_label <- xaxisKey$label[xaxisKey$value==xaxis] # labels for X-axis
                            
    bar_plot <- ggplot(w_df, aes(x = !!sym(xaxis), y = count)) +
                  geom_col(aes(fill = damage_level), width = 0.7 , alpha=0.3 , size=0.3, colour="black") + 
                  scale_fill_manual(values=c("Substantial" = "red", "Medium" = "#0066FF","Minor" = "grey", "None" = "#339933")) +
                  labs(y = "Total Bird Strikes",
                       x = x_label,
                       fill = "Damage_level") +
                  ggtitle(paste0("Effect of ",  x_label, " on Bird Strike")) +
                  theme(legend.position = "top") + 
                  theme_bw()
                          
    bar_plot <- bar_plot + theme(legend.text= element_text(color = "black", size = 10), legend.position = "top", # Optional changes
                               legend.title= element_text(color = "black", size = 12)) 

    # Removes extra plotly buttoms and create plotly object                     
    bar_plot <- ggplotly(bar_plot)%>% config(modeBarButtonsToRemove = c("zoom2d", "zoomIn2d", "zoomOut2d", "pan2d",  
                                    "hoverClosestCartesian", "resetScale2d", "select2d", "lasso2d", "toggleSpikelines"),
                                    displaylogo = FALSE)
                          
    bar_plot <- ggplotly(bar_plot, height = 4, width = 9) # Set dimensions for the plot
    
    return(bar_plot)                     
    }
    return(None)
}


# CALLBACKS 
#==========================
# NOTES: 
# the range slider and dropdowns return LISTS (int for range slider, char for dropdowns) 
# they can be iterated over
# to extract value use: [[]]


#Line PLOT
#--------------------------
app$callback(
    output = list(id = 'line_plot', property = 'figure'),
    params = list(input(id = 'date_slider', property = 'value'),
                  input(id = 'damage_types_dropdown_tab1', property = 'value')),
    function(date, damage){       
        # RETURN A ggplotly object here
        make_linegraph(date, damage)
    }
)

#BAR PLOT
#--------------------------
app$callback(
    output = list(id = 'bar_plot', property = 'figure'),
    params = list(input(id = 'bar_dropdown', property = 'value'),
                  input(id = 'damage_types_dropdown_tab1', property = 'value')),
    function(category, damage){
        # RETURN A ggplotly object here
        make_bargraph(category, damage)
    }
)

#HEATMAP
#--------------------------
app$callback(
    output = list(id = 'heatmap_plot', property = 'figure'),
    params = list(input(id = 'heatmap_dropdown', property = 'value'),
                  input(id = 'damage_types_dropdown_tab2', property = 'value')),
    function(y_category, damage){
        # RETURN A ggplotly object here
        make_heatmap_plot(damage, y_category)   
    }
)

#app$run_server()

#for deployment
app$run_server(host = "0.0.0.0", port = Sys.getenv('PORT', 8050))