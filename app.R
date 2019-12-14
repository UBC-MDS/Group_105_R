
library(dash)
library(dashCoreComponents)
library(dashHtmlComponents)

#library(dashTable)
library(tidyverse)
library(plotly)


bs_data <- read_csv("https://raw.githubusercontent.com/UBC-MDS/Group_105_R/master/data/birdstrikes_clean.csv")

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

#GRAPHS
#-----------------------------------.

line <- dccGraph( 
    # sandbox = 'allow-scripts',
    id = 'line_plot',
    # height = '550',
    # width = '750',
    # style = {'border-width': '0'}
)

bar <- dccGraph(
    # sandbox = 'allow-scripts',
    id = 'bar_plot',
    # height = '550',
    # width = '650',
    # style = {'border-width': '0'}
)

heatmap <- dccGraph(
    # sandbox = 'allow-scripts',
    id = 'heatmap_plot',
    # height = '1100',
    # width = '1000',
    # style = {'border-width': '0'}
) 

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
        dccMarkdown(
        "__Example Questions__  
        Using the interactive tools above, try answering the following:    

        - What state experienced the most birdstrikes and in what year?  
        - What airport experienced the most birdstrikes and in what year and state did this occur?  
        - What states experienced the most birdstrikes causing minor damage and in what year did this occur?"
        ),
        htmlHr()       
        ), className = "row"
    )
), style = list('padding-left'= '130px',
                'padding-right'= '130px')
)
    

tabs <- htmlDiv(list(
            dccTabs(id="tabs", value='tab-1', 
                    style = list('padding-left'= '130px',
                             'padding-right'= '130px'), 
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
                    )
                    )
                    )
                }
                else if(tab == 'tab-2'){
                    return(htmlDiv(list(
                        tab2_selectors
                        
                    ))
                    )
                }
            })


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
    #   htmlH1('test'),
    #   htmlH2('test2'),
    #   #selection components
    #   htmlLabel('test3'),
    #   dropdown_selector_tab1,
    #   dropdown_selector_tab2,
    # #   htmlIframe(height=15, width=10, style=list(borderWidth = 0)), #space
    #   htmlLabel('test4'),
    #   rangeslider_selector,
    #   dropdown_barchart,
    #   dropdown_heatmap,
    #   htmlBr(),
    #   htmlLabel('test5'), 
      tabs
    #   dropdown_barchart,
    #   dropdown_heatmap,
    #   line,
    #   bar,
    #   heatmap,
      #graphs and table
    #   graph,
    #   htmlIframe(height=20, width=10, style=list(borderWidth = 0)), #space
    #   country_graph, # NEW
    #   htmlIframe(height=20, width=10, style=list(borderWidth = 0)), #space
    #   htmlLabel('Try sorting by table columns!'),
    #   table,
    #   htmlIframe(height=20, width=10, style=list(borderWidth = 0)), #space
    #   dccMarkdown("test6")
    )
    
  )
)


# CALLBACKS & PLOT CREATION
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
        #line plot function
        # RETURN A ggplotly object here
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
        # RETURN A ggplotly object here
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
        # RETURN A ggplotly object here
    }
)








app$run_server()