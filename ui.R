library(shiny)

shinyUI(fluidPage(
    title = "Word Prediction App",
    h2("Application for Next Word Prediction"),
    h5("created by Mykola Steshenko"),
    h3("Description"),
    p("This is the demonstrational Web application for next word prediction. It predicts the most probable next words using backing-off n-gram model. Prediction consists of 5 words or less to choose the right one by user itself. User can select one of the four different models for prediction (twitter, news, blog and other). This will adjust results for different kinds of texts depending on the context. When user types just a part of a word the application is trying to predict the rest of it. While the application does not predict profane words, they still can be used by user, and this will not affect the quality of prediction. This App also includes punctuation marks into prediction results when the last character in the user's text is not a 'space' character. The predictions are not affected by the proximity of the document start. App will try to predict the next word even if the document is empty. It can also predict words that follow after e-mails or digits, and different abbreviations like U.S., p.m. and others."),
    br(),
    p("To start working with this App please select the most appropriate context using radio-buttons below, and start typing your text to the input field."),
    br(),
    h3("Prediction:"),
    verbatimTextOutput("txt"),
    hr(),
    h3("The most probable next words/characters:"),
    verbatimTextOutput("preds"),
    hr(),
    fluidRow(
        column(3,
               radioButtons("src", label = h4("This text is for..."),
                                              choices = list("Twitter" = 1, 
                                                             "Blog" = 2, 
                                                             "News" = 3,
                                                             "Other" = 4), 
                                              selected = 1)
        ),
        column(3,
               h4("Input your text here:"),
               tags$textarea(id="txt", rows=5, cols=40, "")
        )
    )
))
