#Page with general info for the internal SI Shiny server

#Required packages ----
library(shiny)
library(dplyr)
library(DT)


#UI ----
ui <- fluidPage(
  
  # App title ----
  titlePanel("si-shiny.si.edu - Internal Shiny Server"),
  hr(),
 
  #Instructions for users ----
  fluidRow(column(width=8, 
          p("This", a(href = "https://shiny.rstudio.com/", "Shiny"), "server is set up with the", a(href = "http://docs.rstudio.com/shiny-server/#host-per-user-application-directories", "'Host Per-User Application Directories'"), " option."),
          p("For instructions on how to get an account, deploy apps, or get help, please check the ", a(href = "https://confluence.si.edu/display/RSHINY", "R/Shiny"), " Confluence site."),
          p("This page is a Shiny app."),
          p("Source is available at Github: ", a(href = "https://github.com/Smithsonian/Shiny-server-info", img(src="GitHub-Mark-32px.png"))),
          p("v 1.0"),
          
          #Table with system-wide packages installed
          h3("installed.packages(.Library)"),
          DT::dataTableOutput("packages")
  ),
  column(width=4, 
         img(src="SI-f5xccl1.png", style="display: block; margin-left: 0px;"),
         
         #rversion
         h3("R.Version()"),
         tableOutput("rversion"))
  )
)

#Server ----
server <- function(input, output) {

  #format R.Version() ----
  output$rversion <- renderTable({
    rinfo <- unlist(R.Version())
    as.data.frame(unlist(R.Version()))
  }, rownames = TRUE, colnames = FALSE)
  
  #Render table of packages ----
  output$packages <- DT::renderDataTable({
    allpkg <- as.data.frame(installed.packages(.Library, noCache = TRUE), stringsAsFactors = FALSE)
    allpkg <- dplyr::select(allpkg, Package, Version, Depends, Imports, Suggests, License, Built)

    DT::datatable(allpkg, escape = FALSE, options = list(searching = TRUE), rownames = FALSE, selection = 'none')
    })
}

# Create Shiny app ----
shinyApp(ui = ui, server = server)
