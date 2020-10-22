#Page with general info for the internal SI Shiny server

#Required packages ----
library(shiny)
library(dplyr)
library(DT)

#Get servername
source("settings.R")

#UI ----
ui <- fluidPage(
  
  # App title ----
  titlePanel(paste0(hostname, " - Internal Shiny Server")),
  hr(),
 
  #Instructions for users ----
  fluidRow(column(width=9, 
          img(src="shiny120.png", style="float: right;"),
          p("This", a(href = "https://shiny.rstudio.com/", "Shiny"), "server is set up with the", a(href = "http://docs.rstudio.com/shiny-server/#host-per-user-application-directories", "'Host Per-User Application Directories'"), " option."),
          p("For instructions on how to get an account, deploy apps, or get help, please check the ", a(href = "https://confluence.si.edu/display/RSHINY", "R/Shiny"), " Confluence site."),
          p("This page is a Shiny app. Source is available at Github: ", a(href = "https://github.com/Smithsonian/Shiny-server-info", img(src="GitHub-Mark-32px.png"))),
          p("v 1.1"),
          
          #Table with system-wide packages installed
          hr(),
          h3("installed.packages(.Library)"),
          p("Packages installed on the server:"),
          DT::dataTableOutput("packages")
  ),
  column(width=3, 

         #Shiny server version
         uiOutput("shinyver"),
         hr(),
         
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
  
  
  output$shinyver <- renderUI({
    shiny_ver <- try(system('shiny-server --version', intern = TRUE))
    
    req(class(shiny_ver) != "try-error")
    
    tagList(
      h3("Shiny Server version"),
      HTML("<ul>"),
      HTML(paste(unlist(paste0("<li>", shiny_ver, "</li>")), collapse = "")),
      HTML("</ul>")
    )
  })
    
  
  
  #Render table of packages ----
  output$packages <- DT::renderDataTable({
    allpkg <- as.data.frame(installed.packages(.Library, noCache = TRUE), stringsAsFactors = FALSE)
    allpkg <- dplyr::select(allpkg, Package, Version, Depends, Imports, Suggests, License, Built)

    DT::datatable(allpkg, escape = FALSE, options = list(searching = TRUE), rownames = FALSE, selection = 'none')
    })
}

# Create Shiny app ----
shinyApp(ui = ui, server = server)
