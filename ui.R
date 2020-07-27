library(FuzzyR)
library(shinydashboard)
library(stringi)

# Define UI for application that draws a histogram
shinyUI(dashboardPage(
    skin = 'red',
    dashboardHeader(title = "Análise de risco de incêndio",
                    titleWidth = 300),
    dashboardSidebar(
        sidebarMenu(
            menuItem(
                "Fuzificação",
                tabName = "fuzificacao",
                icon = icon("dashboard")
            ),
            menuItem(
                "Instruções",
                tabName = "instrucoes",
                icon = icon("question-circle")
            )
        ),
        fileInput(
            'arq_fis',
            'Carregar FIS:',
            multiple = TRUE,
            buttonLabel = 'Carregar',
            placeholder = 'Nenhum arquivo selecionado',
            accept = c("csv", ".csv")
        )
    ), 
    
    #
    dashboardBody(tabItems(
        # Fuzificação
        tabItem(tabName = "fuzificacao",
                fluidRow(
                    tabBox(
                        width = 4,
                        title = "A (antecedente)",
                        tabPanel(
                            title = "Baixo",
                            sliderInput("b_1_1", "Mínimo (a):", 0, 100, 0),
                            sliderInput("b_1_2", "b:", 0, 100, 0),
                            sliderInput("b_1_3", "c:", 0, 100, 25),
                            sliderInput("b_1_4", "Máximo (d):", 0, 100, 50)
                        ),
                        tabPanel(
                            title = "Médio",
                            sliderInput("m_1_1", "Mínimo (a):", 0, 100, 0),
                            sliderInput("m_1_2", "b:", 0, 100, 25),
                            sliderInput("m_1_3", "c:", 0, 100, 75),
                            sliderInput("m_1_4", "Máximo (d):", 0, 100, 100)
                        ),
                        tabPanel(
                            title = "Alto",
                            sliderInput("a_1_1", "Mínimo (a):", 0, 100, 50),
                            sliderInput("a_1_2", "b:", 0, 100, 75),
                            sliderInput("a_1_3", "c:", 0, 100, 100),
                            sliderInput("a_1_4", "Máximo (d):", 0, 100, 100)
                        ),
                        tabPanel("Gráfico",
                                 plotOutput("fuzzy_A", height = 500))
                    ),
                    
                    tabBox(
                        width = 4,
                        title = "B (antecedente)",
                        tabPanel(
                            title = "Baixo",
                            sliderInput("b_2_1", "Mínimo (a):", 0, 100, 0),
                            sliderInput("b_2_2", "b:", 0, 100, 0),
                            sliderInput("b_2_3", "c:", 0, 100, 25),
                            sliderInput("b_2_4", "Máximo (d):", 0, 100, 50)
                        ),
                        tabPanel(
                            title = "Médio",
                            sliderInput("m_2_1", "Mínimo (a):", 0, 100, 0),
                            sliderInput("m_2_2", "b:", 0, 100, 25),
                            sliderInput("m_2_3", "c:", 0, 100, 75),
                            sliderInput("m_2_4", "Máximo (d):", 0, 100, 100)
                        ),
                        tabPanel(
                            title = "Alto",
                            sliderInput("a_2_1", "Mínimo (a):", 0, 100, 50),
                            sliderInput("a_2_2", "b:", 0, 100, 75),
                            sliderInput("a_2_3", "c:", 0, 100, 100),
                            sliderInput("a_2_4", "Máximo (d):", 0, 100, 100)
                        ),
                        tabPanel("Gráfico",
                                 plotOutput("fuzzy_B", height = 500))
                    ),
                    
                    tabBox(
                        width = 4,
                        title = "C (consequente)",
                        tabPanel(
                            title = "Baixo",
                            sliderInput("b_3_1", "Mínimo (a):", 0, 100, 0),
                            sliderInput("b_3_2", "b:", 0, 100, 0),
                            sliderInput("b_3_3", "c:", 0, 100, 25),
                            sliderInput("b_3_4", "Máximo (d):", 0, 100, 50)
                        ),
                        tabPanel(
                            title = "Médio",
                            sliderInput("m_3_1", "Mínimo (a):", 0, 100, 0),
                            sliderInput("m_3_2", "b:", 0, 100, 25),
                            sliderInput("m_3_3", "c:", 0, 100, 75),
                            sliderInput("m_3_4", "Máximo (d):", 0, 100, 100)
                        ),
                        tabPanel(
                            title = "Alto",
                            sliderInput("a_3_1", "Mínimo (a):", 0, 100, 50),
                            sliderInput("a_3_2", "b:", 0, 100, 75),
                            sliderInput("a_3_3", "c:", 0, 100, 100),
                            sliderInput("a_3_4", "Máximo (d):", 0, 100, 100)
                        ),
                        tabPanel("Gráfico",
                                 plotOutput("fuzzy_C", height = 500))
                    ),
                    
                    box(
                        width = 4,
                        status = "primary",
                        solidHeader = TRUE,
                        collapsible = TRUE,
                        title = "Fuzificação - Consequente",
                        plotOutput("fuzificacao_C", height = 500),
                        downloadButton('fisArquivo', label = "Baixar")
                    ),
                    box(
                        width = 4,
                        status = "primary",
                        solidHeader = TRUE,
                        collapsible = TRUE,
                        title = "Fuzificação - Antecedentes",
                        sliderInput("v_1", "A:", 0, 100, 50),
                        sliderInput("v_2", "B:", 0, 100, 50)
                        
                    ),
                    box(
                        width = 4,
                        status = "primary",
                        solidHeader = TRUE,
                        collapsible = TRUE,
                        title = "Regras",
                        fileInput('arq_regras', 'Regras:',
                                  multiple = FALSE,
                                  buttonLabel = 'Carregar',
                                  placeholder = 'Nenhum arquivo selecionado', 
                                  accept = c(
                                             'text/csv',
                                             'text/comma-separated-values',
                                             'csv', 
                                             '.csv')),
                        # tags$hr(),
                        textOutput("regrasTexto")
                    )
                ),),
        
        # Instruções.
        tabItem(
            tabName = "instrucoes",
            h2("Fuzificação."),
            h3(stri_rand_lipsum(1)),
            h2("Defuzificação."),
            h3(stri_rand_lipsum(1)),
            
        )
    ))
))
