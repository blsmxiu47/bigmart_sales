library(shiny)
library(ggplot2)
bigmart_tidy <- read.csv('bigmart_tidy.csv')

# Define UI for application that draws a histogram
ui <- fluidPage(
   
   # Application title
   titlePanel("Bigmart Sales Attribute Visualizations"),
   
   # Sidebar with a slider input for number of bins 
   sidebarLayout(
      sidebarPanel(
        #Dropdown selection box. Select x-axis attribute to be plotted against
              #Item_Output_Sales
              #IW --> 
        # Select variable for x-axis
        selectInput(inputId = 'x', 
                  label = 'Attribute:',
                  choices = c('Item_Weight', 'Item_Fat_Content', 'Item_Visibility_MeanRatio', 'Item_Type', 'Item_Type_Aggregate', 'Item_MRP'), 
                  selected = 'Item_MRP'),
              
        # Select variable for group
        selectInput(inputId = 'group', 
                  label = 'Grouped by:',
                  choices = c('Outlet_Size', 'Outlet_Location_Type', 'Outlet_Type', 'Outlet_Years'), 
                  selected = 'Outlet_Type')
      ),
      
      # Show a plot of the generated distribution
      mainPanel(
         plotOutput('viz_plot')
      )
   )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
   
   output$viz_plot <- renderPlot({
           ggplot(data = bigmart_tidy, aes_string(x = input$x,
                                                  y = Item_Outlet_Sales,
                                                  group = input$group)) +
                   geom_point()
   })
}

# Run the application 
shinyApp(ui = ui, server = server)

