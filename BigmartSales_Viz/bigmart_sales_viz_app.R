# Aggregated visualization of different variables from Bigmart Sales dataset
# against sales (output variable) using the tidied version of the original
# data

library(shiny)
library(ggplot2)
bigmart_tidy <- read.csv('bigmart_tidy.csv')
bold_theme <- theme(
                axis.title.x = element_text(face = 'bold', size = 12),
                axis.title.y = element_text(face = 'bold', size = 12),
                axis.text.x = element_text(face = 'bold', size = 11),
                axis.text.y = element_text(face = 'bold', size = 11),
                legend.title = element_text(face = 'bold', size = 12),
                legend.text = element_text(face = 'bold', size = 11)
                )

# Define UI for application
ui <- fluidPage(
   
   # Application title
   titlePanel("Bigmart Sales Attribute Visualizations"),
   
   # Sidebar with selection options for x-axis variables and grouping 
   sidebarLayout(position = 'left',
      sidebarPanel('Select Plot',
        #Dropdown selection box. Select x-axis attributes to be plotted against Sales
         
        # Select numerical variables for top plot
        selectInput(inputId = 'x1', 
                    label = 'Numeric Plot Attribute:',
                    choices = c('Item_Weight', 'Item_Visibility_MeanRatio'), 
                    selected = 'Item_Visibility_MeanRatio'),
        
        # Select categorical variables for bottom plot
        selectInput(inputId = 'x2', 
                  label = 'Categorical Plot Attribute:',
                  choices = c('Item_Type', 'Item_Type_Aggregate', 'Item_Fat_Content'), 
                  selected = 'Item_Type_Aggregate'),
              
        # Select variable for group
        selectInput(inputId = 'group', 
                  label = 'Grouped by:',
                  choices = c('Outlet_Size', 'Outlet_Location_Type', 'Outlet_Type'), 
                  selected = 'Outlet_Type')
      ),
      
      # Show plots
      mainPanel(
         plotOutput('line'),
         plotOutput('hist')
      )
   )
)

# Define server logic required to draw our plots
server <- function(input, output) {
   
   output$line <- renderPlot({
           ggplot(data = bigmart_tidy, 
                  aes_string(x = input$x1, 
                             y = bigmart_tidy$Item_Outlet_Sales,
                             color = input$group
                             )) +
                   geom_point() +
                   geom_smooth(color = 'red', size = 1.5) +
                   geom_jitter() +
                   ylab('Sales') +
                   ggtitle('Numeric Attributes') +
                   bold_theme
   })
   
   output$hist <- renderPlot({
           ggplot(data = bigmart_tidy, aes_string(x = input$x2,
                                                  y = bigmart_tidy$Item_Outlet_Sales,
                                                  group = input$group,
                                                  fill = input$group)) +
                   geom_histogram(stat = 'identity', position = 'dodge',
                                  binwidth = 0.5) +
                   ylab('Sales') +
                   ggtitle('Categorical Attributes') +
                   theme(axis.text.x = element_text(angle = 45, vjust = 0.7)) +
                   bold_theme
   })
   
}

# Run the application 
shinyApp(ui = ui, server = server)

