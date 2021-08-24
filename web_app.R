library(shiny)
library(readr)
library(dplyr)
library(tidyverse)

regions=c("med","lat")
metadata<-as.data.frame(read_csv("~/metadata_labdefined_net.csv"))
met<-metadata[c("Sex","Site of Motor Onset","Age at Death","Sample Source","Final Subject Group - Bowser lab defined")]

server <- function(input,output,session)
  {
  
  #Selecting datasets (region of interest)
  data <- reactive({
    db = data.frame()#declaring a dataframe
    dataset <- input$selected_dataset #assigning the user input to DATASET
    if (dataset == "med")
      db = as.data.frame(read_csv("~/txi_medial_result_net.csv"))
    else
      db = as.data.frame(read_csv("~/txi_lateral_result_net.csv"))
  })
  
  output$choose_gene = renderUI({
    
    db <- data()
    selectInput(inputId = "selected_gene",
                label= "Choose any gene",
                choices =  db$gene[1:10])
  })
  
  output$dist_plot = renderPlot({
    db <- data()
    var = input$selected_gene
    data_gene <- as.data.frame(db[db$gene == var,-1])
    t_data_gene<- as.data.frame(t(data_gene))
    colnames(t_data_gene)<-var
    ggplot(t_data_gene, aes_string(x=var)) + 
      geom_histogram(aes(y=..density..),binwidth=100, colour="black", fill="salmon1")+
      geom_density(alpha=.2)
  })
  
  output$choose_group = renderUI({
    db <- data()
    selectInput(inputId = "selected_group",
                label= "Choose two groups you want to compare",
                choices = unique(met$`Final Subject Group - Bowser lab defined`),
                selected="ALS",
                multiple=TRUE)
  })
  
  output$bar_plot=renderPlot(
    {
    db<- data()
    var1= input$selected_gene
    var2= input$selected_group
    #grp='Final Subject Group - Bowser lab defined'
    data_gene <- as.data.frame(db[db$gene == var1,-1])
    t_data_gene<-as.data.frame(t(data_gene))
    t_data_gene$ExternalSampleId <- rownames(t_data_gene)
    colnames(t_data_gene)<-c(var1,'ExternalSampleId')
    dat<-merge(t_data_gene,met,by='ExternalSampleId')
    dat_ALS_HC<-dat[(dat$`Final Subject Group - Bowser lab defined`) %in% var2,]
    ggplot(dat_ALS_HC, aes(x=`Final Subject Group - Bowser lab defined`), aes_string(y=var1)) +
    geom_bar(stat="identity", aes_string(y=var1))+
    geom_errorbar(aes(ymin=var1-sd, ymax=var1+sd), width=.2,
                    position=position_dodge(.9))
   })
}

ui <- fluidPage(
  titlePanel("Gene expression"),
  sidebarLayout(
    sidebarPanel(
      selectInput(inputId = "selected_dataset",label = "Choose a region of interest", regions),
      uiOutput("choose_gene"),
      uiOutput("choose_group")
    ),
    
    mainPanel(
      tabsetPanel(
        tabPanel("Distplot",plotOutput("dist_plot")),
        tabPanel("Barplot",plotOutput("bar_plot"))
      )
    )
  )
)

shinyApp(ui,server)
