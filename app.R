
library(dash)
library(dashCoreComponents)
library(dashHtmlComponents)

#library(dashTable)
library(tidyverse)
library(plotly)


bs_data <- read_csv("https://raw.githubusercontent.com/UBC-MDS/Group_105_R/master/data/birdstrikes_clean.csv")

app <- Dash$new(external_stylesheets = "https://codepen.io/chriddyp/pen/bWLwgP.css")


#HTML COMPONENTS
#===================================
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

# APP LAYOUT
#==========================

# app.layout = html.Div([title_header,
#                        tabs,
#                        dcc.Markdown(
#                            '''
#                            [Photo Attribution](https://pixabay.com/vectors/swans-silhouette-black-flying-36088/)
#                            '''
#                        )])

app$layout(
  htmlDiv(
    list(
      htmlH1('test'),
      htmlH2('test2'),
      #selection components
      htmlLabel('test3'),
      dropdown_selector_tab1,
      dropdown_selector_tab2,
    #   htmlIframe(height=15, width=10, style=list(borderWidth = 0)), #space
      htmlLabel('test4'),
      rangeslider_selector,
      htmlBr(),
      htmlLabel('test5'),
      dropdown_barchart,
      dropdown_heatmap,
      #graphs and table
    #   graph,
    #   htmlIframe(height=20, width=10, style=list(borderWidth = 0)), #space
    #   country_graph, # NEW
    #   htmlIframe(height=20, width=10, style=list(borderWidth = 0)), #space
    #   htmlLabel('Try sorting by table columns!'),
    #   table,
    #   htmlIframe(height=20, width=10, style=list(borderWidth = 0)), #space
      dccMarkdown("test6")
    )
    
  )
)

# CALLBACKS & PLOT CREATION
#==========================
#Line PLOT
#--------------------------
app$callback(
    output = list(id = 'line_plot', property = 'figure'),
    params = list(input(id = 'date_slider', property = 'value'),
                  input(id = 'damage_types_dropdown_tab1', property = 'value')),
    function(date_list, damage){
        #line graph function
    }
)



#BAR PLOT
#--------------------------
app$callback(
    output = list(id = 'bar_plot', property = 'figure'),
    params = list(input(id = 'bar_dropdown', property = 'value'),
                  input(id = 'damage_types_dropdown_tab1', property = 'value')),
    function(category, damage){
        #bar graph function
    }
)


#HEATMAP
#--------------------------
app$callback(
    output = list(id = 'heatmap_plot', property = 'figure'),
    params = list(input(id = 'heatmap_dropdown', property = 'value'),
                  input(id = 'damage_types_dropdown_tab2', property = 'value')),
    function(y_category, damage){
        #heatmap function
    }
)








app$run_server()