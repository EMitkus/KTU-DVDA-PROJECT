# Install and load necessary packages
# install.packages("shinybusy")
# install.packages("shiny")
# install.packages("h2o")
# install.packages("tidyverse")
# install.packages("DT")

library(shiny)
library(shinybusy)
library(h2o)
library(tidyverse)
library(DT)

h2o.init()
myModel <- h2o.loadModel("../../project/4-model/my_best_automlmodel")

ui <- fluidPage(
  use_busy_spinner(),
  titlePanel("Loan Prediction Model"),
  
  tags$head(
    tags$style(HTML("
    .prediction-done {
      color: green;
    }
    .prediction-error {
      color: red;
    }
  "))
  ),
  
  sidebarLayout(
    sidebarPanel(
      fileInput("file1", "Choose CSV File",
                accept = c("text/csv", "text/comma-separated-values,text/plain", ".csv")),
      numericInput("idInput", "Enter ID to Search:", value = 1),
      checkboxInput("toggleId", "Filter by Specific ID", value = FALSE),
      actionButton("predictButton", "Predict"),
      uiOutput("predictionDone"),
      numericInput("checkId", "Check Loan Status:", value = NA),
      actionButton("checkButton", "Check"),
      uiOutput("loanStatus")
    ),
    mainPanel(
      tabsetPanel(id="tabs",
        tabPanel("Overview",
                 h3("Overview of the Loan Prediction Model"),
                 dataTableOutput("overviewTable")
        ),
        tabPanel("Chart",
                 h3("Prediction Distribution"),
                 plotOutput("chartOutput")
        ),
        tabPanel("Predictions Table",
                 dataTableOutput("predictionOutput")
        ),
        tabPanel("Help",
                 div(
                   HTML("
      <h2>Kaip naudotis programa:</h2>
      <ul>
        <li>Šoninėje juostoje, esančia kairėje lango pusėje, paspauskite \"Browse...\" mygtuką ir pasirinkite norimą patikrinti .csv failą (failas turi atitikti tam tikrus standartus, pvz. pirmas stulpelis- \"id\", t.t.);</li>
        <li>Pasirinkti .csv failo duomenys automatiškai užsikraus į aplikaciją, bet norint toliau nagrinėti, ar buvo suteiktos paskolos, reikia paspausti mygtuką \"Predict\";</li>
        <li>Kai aplikacija suprocesuos pateikto .csv failo duomenis bei paskolų suteikimus, pamatysite žinutę \"Prediction done!\". Aplikacija gali užtrukti kelias sekundes, kol visi duomenys bus peržiūrėti, tad prašome palaukti.</li>
        <li>Jei norite išfiltruoti tik specifišką ID, tai galite padaryti pasirinkus norimą ID šoninėje juostoje, po tekstu \"Enter ID to Search\" bei varnele pažymėjus langelį \"Filter by Specific ID\";</li>
        <li>Jei norite patikrinti, ar specifiniam ID paskola buvo suteikta, suveskitę norimą ID į teksto lauką po tekstu \"Check Loan Status\" ir paspauskite mygtuką \"Check\". Pamatysite žinutę \"Loan approved!\", jei paskola buvo suteikta, arba žinutę \"Loan denied\", jei paskola nebuvo suteikta nurodytam ID.</li>
        <li>Skirtuke \"Overview\" pateikiama informacija apie Jūsų pateiktus duomenis iš .csv failo.</li>
        <li>Skirtuke \"Chart\" pateikiama skerspjūvio diagrama, nurodantį santykį tarp suteiktų bei atmestų paskolų pagal Jūsų pateiktus duomenis.</li>
        <li>Skirtuke \"Predictions Table\" pateikiama informacija apie tai, ar paskola buvo suteikta (stulpelyje \"predict\" esanti reikšmė 1- paskola suteikta, 0- paskola atmesta), p0- tikimybė, jog paskola bus atmesta bei p1- tikimybė, jog paskola bus priimta).</li>
      </ul>
    ")
                 )
        )
      )
    )
  )
)


server <- function(input, output) {
  
  predictionMessage <- reactiveVal("")

  myModel <- h2o.loadModel("../4-model/my_best_automlmodel")

  values <- reactiveValues(predictedData = NULL)
  
  observeEvent(input$predictButton, {
    req(input$file1)
    
    inFile <- input$file1
    inputData <- read.csv(inFile$datapath, header = TRUE)
    h2oInputData <- tryCatch(
      {
        as.h2o(inputData)
      },
      error = function(e) {
        NULL
      }
    )
    
    if (!is.null(h2oInputData)) {
      prediction <- tryCatch(
        {
          h2o.predict(myModel, h2oInputData)
        },
        error = function(e) {
          NULL
        }
      )
    }
    
    if (!is.null(prediction)) {
      result <- as.data.frame(prediction)
      result$p0 <- round(result$p0, 3)
      result$p1 <- round(result$p1, 3)
      result_with_id <- cbind(inputData[1], result)
      
      values$predictedData <- result_with_id
      
      predictionMessage("Prediction done!")
    } else {
      predictionMessage("Prediction failed. Please check the data format.")
    }
  })
  
  observe({
    input$tabs
    predictionMessage(NULL)
  })
  
  output$predictionDone <- renderUI({
    msg <- predictionMessage()
    if (!is.null(msg) && msg != "") {
      if (msg == "Prediction done!") {
        span(class = "prediction-done", msg)
      } else {
        span(class = "prediction-error", msg)
      }
    }
  })
  
  observeEvent(input$checkButton, {
    req(values$predictedData)
    
    selected <- values$predictedData[values$predictedData[[1]] == input$checkId, ]
    
    if (nrow(selected) > 0) {
      if (selected$predict == 1) {
        statusMessage <- span(style = "color: green;", "Loan approved!")
      } else {
        statusMessage <- span(style = "color: red;", "Loan denied")
      }
    } else {
      statusMessage <- "ID not found"
    }
    
    output$loanStatus <- renderUI({ statusMessage })
  })
  
  output$overviewTable <- renderDataTable({
    req(input$file1)
    
    inFile <- input$file1
    overviewData <- read.csv(inFile$datapath, header = TRUE)
    
    if (input$toggleId && !is.null(input$idInput) && input$idInput != "") {
      overviewData <- overviewData[overviewData[[1]] == input$idInput, ]
    }
    
    datatable(overviewData, options = list(pageLength = 10, rownames = FALSE))
  }, options = list(pageLength = 10))
  
  output$predictionOutput <- renderDataTable({
    req(values$predictedData)

    if (input$toggleId && !is.null(input$idInput) && input$idInput != "") {
      filtered_result <- values$predictedData[values$predictedData[[1]] == input$idInput, ]
    } else {
      filtered_result <- values$predictedData
    }
    
    datatable(filtered_result, options = list(pageLength = 10, rownames = FALSE))
  })
  
  output$chartOutput <- renderPlot({
    req(values$predictedData)
    
    prediction_count <- as.data.frame(values$predictedData) %>%
      group_by(predict) %>%
      summarise(Count = n()) %>%
      arrange(desc(Count))

    ggplot(prediction_count, aes(x = "", y = Count, fill = factor(predict))) +
      geom_bar(stat = "identity", width = 1) +
      coord_polar("y", start = 0) +
      theme_void() +
      theme(legend.title = element_blank()) +
      scale_fill_discrete(name = "Prediction", labels = c("Denied", "Approved"))
  })
}

shinyApp(ui = ui, server = server)
