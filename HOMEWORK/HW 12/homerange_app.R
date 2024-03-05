library(shiny)
library(tidyverse)
library(janitor)

homerange <- read_csv("data/Tamburelloetal_HomeRangeDatabase.csv") %>% clean_names()

ui <- fluidPage(
  
  radioButtons("x", "Select Fill Option", choices = c("trophic_guild", "thermoregulation"), selected = "trophic_guild"),
  
  plotOutput("plot", width="500px", height="400px")
  
  
)

server <- function(input, output, session) {
  
  output$plot <- renderPlot({ 
    
    ggplot(data= homerange, aes_string(x= "locomotion", fill= input$x)) +
      geom_bar(position = "dodge", alpha = 0.7, color = "black") + 
      labs(x=NULL, fill="Fill Variable")
    
    
  })
  
  
  
}
shinyApp(ui, server) 

