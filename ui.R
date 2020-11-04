library(shiny)
library(shinyBS)

modelOptions <- c("1","2","3","4")
names(modelOptions) <- c ("Linear model", "Generalized linear model - Gaussian", "Generalized linear model - Gamma", "Generalized linear model - Quasipoisson")

shinyUI(fluidPage(title = "Mtcars model fit diagnostics",

    # Application title
    titlePanel(div(h1("Mtcars model fit diagnostics"),h4("Fit different models and see the results! Hover on elements for tooltip help."),windowTitle="Mtcars model fit diagnostics")),
      sidebarLayout(
        sidebarPanel(
            selectInput(inputId = "model",label="Select model to fit",multiple=FALSE,choices=modelOptions,selected=1),
            checkboxGroupInput(
                "checkboxGroup1",
                "Select variables to include in the linear model",
                selected = c("cyl","disp","hp","drat","wt","qsec","vs","am","gear","carb"),
                inline = FALSE,
                choiceNames = c("Number of cylinders","Displacement (cu.in.)","Gross horsepower","Rear axle ratio","Weight (1000 lbs)","1/4 mile time","Engine","Transmission","Number of forward gears","Number of carburetors"),
                choiceValues = c("cyl","disp","hp","drat","wt","qsec","vs","am","gear","carb")
            ),
            bsTooltip(id = "model", title = "Select the model to be fitted, for GLMs it aslo sets the familiy to be used", 
                      placement = "bottom", trigger = "hover"),
            bsTooltip(id = "checkboxGroup1", title = "Check the boxes to include the variables you prefer as predictors in the model", 
                      placement = "bottom", trigger = "hover"),
            submitButton()
        ),
        mainPanel(
            h2("Model results"),
            conditionalPanel(
                condition = "input.checkboxGroup1.length > 0",
                tabsetPanel(id = "tabpanel",
                    tabPanel("Coefficients",  dataTableOutput("coefsTable")),
                    tabPanel("Residuals vs Fitted",plotOutput("diagnostic1")),
                    tabPanel("Normal Q-Q",plotOutput("diagnostic2")),
                    tabPanel("Scale-Location",plotOutput("diagnostic3")),
                    tabPanel("Cook's distance",plotOutput("diagnostic4")),
                    tabPanel("Residuals vs Leverage",plotOutput("diagnostic5")),
                    tabPanel("Cook's dist vs Leverage",plotOutput("diagnostic6")),
                    tabPanel("P-values",plotOutput("pvaluesPlot"))
                ),
                bsTooltip(id = "tabpanel", title = "Select the diagnostic plot you would like to see", 
                          placement = "top", trigger = "hover")
            ),
            conditionalPanel(
                condition = "input.checkboxGroup1.length < 1",
                h3("No predictors selected, can't train model.")
            )
            
        )
    )
))
