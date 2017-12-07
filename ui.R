
#####################################################
#  SHINY UI 
#####################################################

# packages
library(shiny)
library(shinydashboard)
library(dplyr)
library(ggplot2)
library(ROCR)

dashboardPage(skin = "green",
              dashboardHeader(title = "Classifier 1-0-1", titleWidth=300),
              dashboardSidebar(width = 300, 
                               sidebarMenu(
                                    menuItem("Simulator", tabName = "simulator"),
                                    menuItem("Some explanations...", tabName = "learning_ressources"),
                                    hr(),
                                    sliderInput("amount", "Amount of spam?", 0, 900, 30),
                                    h4("What is your biggest concern?"),
                                    sliderInput("beta", label = div(style='width:250px;', 
                                                                    div(style='float:left;', 'False Positives'), 
                                                                    div(style='float:right;', 'False Negatives')), 
                                                min = 0, max = 1, value = 0.5, width = 250),
                                    br(), br(), br(), hr(), br(),
                                    a("Realisation: marc.agenis@gmail.com", href="https://github.com/agenis", target="_blank")
                               )
              ),
              dashboardBody(
                   tabItems(
                        tabItem(tabName = "simulator",
                                fluidRow(
                                     box(
                                          title = "Mouse-select your spam predictions!", background = "blue", solidHeader = TRUE,
                                          plotOutput("main_plot", brush=brushOpts(id="brush")),
                                          br(),
                                          h5("This plot shows 900 emails, that have been divided into regular ones (grey) and actual spams (red). You can draw a rectangle with your mouse to simlulate a prediction from an classification algorithm. All points in your selection get the predicted class <spam>, the others <non-spam>.", style="color:white")
                                     ),
                                     infoBoxOutput("accuracy_output"),
                                     infoBoxOutput("precision_output"),
                                     infoBoxOutput("recall_output"),
                                     infoBoxOutput("f1_output")
                                )
                        ),
                        tabItem(tabName = "learning_ressources",
                                fluidRow(
                                     box(
                                          title = "What is a F1-score?", background = "navy", solidHeader = TRUE,
                                          h4("F1 Score is the weighted average of Precision and Recall. Therefore, this score takes both false positives and false negatives into account. Intuitively it is not as easy to understand as accuracy, but F1 is usually more useful than accuracy, especially if you have an uneven class distribution. Accuracy works best if false positives and false negatives have similar cost. If the cost of false positives and false negatives are very different, it’s better to look at both Precision and Recall. We can add aa weighting to account for the higher consequence of eigher false positives or negatives (second slider)"),
                                          br(),
                                          h4("F1 Score = 2*(Recall * Precision) / (Recall + Precision)"),
                                          img(src='f1-score definition.png', align = "center")
                                     ),
                                     box(
                                          title = "What is precision?", background = "fuchsia", solidHeader = TRUE,
                                          h4("Precision is the ratio of correctly predicted positive observations to the total predicted positive observations. High precision relates to the low false positive rate."),
                                          br(),
                                          h4("Precision = TP/TP+FP")
                                     )
                                     
                                ),
                                fluidRow(
                                     box(
                                          title = "What is recall?", background = "yellow", solidHeader = TRUE,
                                          h4("Recall is the ratio of correctly predicted positive observations to the all observations in actual class."),
                                          br(),
                                          h4("Recall = TP/TP+FN")
                                     ),
                                     box(
                                          title = "What is accurracy?", background = "blue", solidHeader = TRUE,
                                          h4("Accuracy is the most intuitive performance measure and it is simply a ratio of correctly predicted observation to the total observations. One may think that, if we have high accuracy then our model is best. Yes, accuracy is a great measure but only when you have symmetric datasets where values of false positive and false negatives are almost same. Therefore, you have to look at other parameters to evaluate the performance of your model."),
                                          br(), 
                                          h4("Accuracy = TP+TN/TP+FP+FN+TN")
                                     )
                                     
                                )
                        )
                   )
              )
)

