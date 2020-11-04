library(shiny)

shinyServer(function(input, output) {
    
    predictors <- reactive({length(input$checkboxGroup1)})
    
    model <- reactive({
        set.seed(input$seed)
        if(predictors() < 1){
            return(NULL)
        }
        if(input$model == 1){
            lm(mpg~.,data=mtcars[,c("mpg",input$checkboxGroup1)])
        }
        else if(input$model == 2){
            glm(mpg~.,data=mtcars[,c("mpg",input$checkboxGroup1)],family = "gaussian")
        }
        else if(input$model == 3){
            glm(mpg~.,data=mtcars[,c("mpg",input$checkboxGroup1)],family = "Gamma")
        }
        else if(input$model == 4){
            glm(mpg~.,data=mtcars[,c("mpg",input$checkboxGroup1)],family = "quasipoisson")
        }
        
        
    })
    
    modelTable <- reactive({
        if(predictors()>0){
            c <- coefficients(summary(model()))
            cbind(Coefficient=rownames(c),c)
        }
        else{
            data.frame()
        }
    })
    
    
    output$coefsTable <- renderDataTable(modelTable(),options=list(paging=FALSE,searching=FALSE,info=FALSE))  
    
    output$diagnostic1 <- renderPlot({
        m <- model()
        if(!is.null(m)){
            plot(model(),which=1)
        }
        else{
            NULL
        }
    })
    
    output$diagnostic2 <- renderPlot({
        m <- model()
        if(!is.null(m)){
            plot(model(),which=2)
        }
        else{
            NULL
        }
    })
    
    output$diagnostic3 <- renderPlot({
        m <- model()
        if(!is.null(m)){
            plot(model(),which=3)
        }
        else{
            NULL
        }
    })
    
    output$diagnostic4 <- renderPlot({
        m <- model()
        if(!is.null(m)){
            plot(model(),which=4)
        }
        else{
            NULL
        }
    })
    
    output$diagnostic5 <- renderPlot({
        m <- model()
        if(!is.null(m)){
            plot(model(),which=5)
        }
        else{
            NULL
        }
    })
    
    output$diagnostic6 <- renderPlot({
        m <- model()
        if(!is.null(m)){
            plot(model(),which=6)
        }
        else{
            NULL
        }
    })
    
    output$pvaluesPlot <- renderPlot({
        m <- model()
        if(!is.null(m)){
            coefs <- coefficients(summary(m))
            labels<-dimnames(coefs)[[1]]
            labels[1] <- "Intercept"
            pvalues=coefs[,4]
            plot(pvalues,xaxt="n")
            axis(1,at=1:length(labels),labels=labels)
        }
        else{
            NULL
        }
        
    })
    
    observe({
        if(predictors() > 1){
            showNotification("Model updated, plots refreshed.",type="message",duration = 5,closeButton=FALSE)
        }
        else{
            showNotification("No predictors selected, nothing to show.",type="error",duration=5,closeButton=FALSE)
        }
    }) 

})
