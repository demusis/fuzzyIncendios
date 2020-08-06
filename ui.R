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
                "Lógica fuzzy",
                tabName = "fuzzy",
                icon = icon("dashboard")
            ),
            menuItem(
                "Método de Monte Carlo",
                tabName = "mmc",
                icon = icon("spinner")
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
        tabItem(tabName = "fuzzy",
                fluidRow(
                    tabBox(
                        width = 3,
                        title = "Cobertura vegetal",
                        tabPanel(
                            title = "Baixa",
                            sliderInput("b_1_1", "a:", 0, 100, 0),
                            sliderInput("b_1_2", "b:", 0, 100, 0),
                            sliderInput("b_1_3", "c:", 0, 100, 25),
                            sliderInput("b_1_4", "d:", 0, 100, 50)
                        ),
                        tabPanel(
                            title = "Média",
                            sliderInput("m_1_1", "a:", 0, 100, 0),
                            sliderInput("m_1_2", "b:", 0, 100, 25),
                            sliderInput("m_1_3", "c:", 0, 100, 75),
                            sliderInput("m_1_4", "d:", 0, 100, 100)
                        ),
                        tabPanel(
                            title = "Alta",
                            sliderInput("a_1_1", "a:", 0, 100, 50),
                            sliderInput("a_1_2", "b:", 0, 100, 75),
                            sliderInput("a_1_3", "c:", 0, 100, 100),
                            sliderInput("a_1_4", "d:", 0, 100, 100)
                        ),
                        tabPanel("Gráfico",
                                 plotOutput("cobertura_vegetal_fuzzy", height = 500))
                    ),
                    
                    tabBox(
                        width = 3,
                        title = "Relevo (%)",
                        tabPanel(
                            title = "Plano",
                            sliderInput("b_2_1", "a:", 0, 10, 0),
                            sliderInput("b_2_2", "b:", 0, 10, 0),
                            sliderInput("b_2_3", "c:", 0, 10, 5),
                            sliderInput("b_2_4", "d", 0, 10, 5)
                        ),
                        tabPanel(
                            title = "Rampa ou colina",
                            sliderInput("mb_2_1", "a:", 0, 100, 0),
                            sliderInput("mb_2_2", "b:", 0, 100, 15),
                            sliderInput("mb_2_3", "c:", 0, 100, 25),
                            sliderInput("mb_2_4", "d", 0, 100, 50)
                        ),
                        tabPanel(
                            title = "Morrote",
                            sliderInput("ma_2_1", "a:", 0, 100, 15),
                            sliderInput("ma_2_2", "b:", 0, 100, 25),
                            sliderInput("ma_2_3", "c:", 0, 100, 50),
                            sliderInput("ma_2_4", "d", 0, 100, 750)
                        ),
                        tabPanel(
                            title = "Morro com encosta suave",
                            sliderInput("a_2_1", "a", 0, 100, 50),
                            sliderInput("a_2_2", "b:", 0, 100, 75),
                            sliderInput("a_2_3", "c:", 0, 100, 100),
                            sliderInput("a_2_4", "d", 0, 100, 100)
                        ),
                        tabPanel(
                            title = "Morro com encosta forte",
                            sliderInput("ma_2_1", "a", 0, 100, 50),
                            sliderInput("ma_2_2", "b:", 0, 100, 75),
                            sliderInput("ma_2_3", "c:", 0, 100, 100),
                            sliderInput("ma_2_4", "d", 0, 100, 100)
                        ),
                        tabPanel("Gráfico",
                                 plotOutput("relevo_fuzzy", height = 500))
                    ),
                    
                    tabBox(
                        width = 3,
                        title = "Proximidade de populacação (m)",
                        tabPanel(
                            title = "Na área",
                            sliderInput("b_2_1", "a:", 0, 50, 0),
                            sliderInput("b_2_2", "b:", 0, 50, 0),
                            sliderInput("b_2_3", "c:", 0, 50, 25),
                            sliderInput("b_2_4", "d", 0, 50, 25)
                        ),
                        tabPanel(
                            title = "Próxima",
                            sliderInput("mb_2_1", "a:", 0, 100, 0),
                            sliderInput("mb_2_2", "b:", 0, 100, 15),
                            sliderInput("mb_2_3", "c:", 0, 100, 25),
                            sliderInput("mb_2_4", "d", 0, 100, 100)
                        ),
                        tabPanel(
                            title = "Média",
                            sliderInput("ma_2_1", "a:", 0, 500, 50),
                            sliderInput("ma_2_2", "b:", 0, 500, 125),
                            sliderInput("ma_2_3", "c:", 0, 500, 250),
                            sliderInput("ma_2_4", "d", 0, 500, 500)
                        ),
                        tabPanel(
                            title = "Distante",
                            sliderInput("ma_2_1", "a", 250, 1000, 50),
                            sliderInput("ma_2_2", "b:", 250, 1000, 750),
                            sliderInput("ma_2_3", "c:", 250, 1000, 1000),
                            sliderInput("ma_2_4", "d", 250, 1000, 1000)
                        ),
                        tabPanel("Gráfico",
                                 plotOutput("proximidade_fuzzy", height = 500))
                    ),
                    
                    tabBox(
                        width = 3,
                        title = "Risco de incêndio",
                        tabPanel(
                            title = "Muito baixo",
                            sliderInput("mb_3_1", "a:", 0, 100, 0),
                            sliderInput("mb_3_2", "b:", 0, 100, 0),
                            sliderInput("mb_3_3", "c:", 0, 100, 15),
                            sliderInput("mb_3_4", "d:", 0, 100, 25)
                        ),                        
                        tabPanel(
                            title = "Baixo",
                            sliderInput("b_3_1", "a:", 0, 100, 0),
                            sliderInput("b_3_2", "b:", 0, 100, 15),
                            sliderInput("b_3_3", "c:", 0, 100, 25),
                            sliderInput("b_3_4", "d:", 0, 100, 50)
                        ),
                        tabPanel(
                            title = "Médio",
                            sliderInput("m_3_1", "a:", 0, 100, 0),
                            sliderInput("m_3_2", "b:", 0, 100, 25),
                            sliderInput("m_3_3", "c:", 0, 100, 75),
                            sliderInput("m_3_4", "d:", 0, 100, 100)
                        ),
                        tabPanel(
                            title = "Alto",
                            sliderInput("a_3_1", "a:", 0, 100, 25),
                            sliderInput("a_3_2", "b:", 0, 100, 50),
                            sliderInput("a_3_3", "c:", 0, 100, 75),
                            sliderInput("a_3_4", "d:", 0, 100, 100)
                        ),
                        tabPanel(
                            title = "Muito alto",
                            sliderInput("ma_3_1", "a:", 0, 100, 50),
                            sliderInput("ma_3_2", "b:", 0, 100, 75),
                            sliderInput("ma_3_3", "c:", 0, 100, 100),
                            sliderInput("ma_3_4", "d:", 0, 100, 100)
                        ),
                        tabPanel("Gráfico",
                                 plotOutput("risco_incendio_fuzzy", height = 500))
                    ),
                    
                    box(
                        width = 9,
                        status = "primary",
                        solidHeader = TRUE,
                        collapsible = TRUE,
                        title = "Fuzificação - Risco de incêndio",
                        plotOutput("risco_incendio_fuzificacao", height = 500),
                        downloadButton('fisArquivo', label = "Baixar")
                    ),
                    box(
                        width = 3,
                        status = "primary",
                        solidHeader = TRUE,
                        collapsible = TRUE,
                        title = "Fuzificação - Antecedentes",
                        sliderInput("v_1", "Cobertura vegetal:", 0, 100, 50),
                        sliderInput("v_2", "Relevo:", 0, 100, 50),
                        sliderInput("v_3", "Proximidade da população:", 0, 1000, 150)
                    ),
                    box(
                        width = 12,
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

        # Método de Monte Carlo.
        tabItem(
            tabName = 'mmc',
            box(
                width = 4,
                status = "primary",
                solidHeader = TRUE,
                collapsible = TRUE,
                title = "Evento - Raio",
                sliderInput("p_1", "Probabilidade:", 0, 1, 0.5, 0.1),
                tags$hr(),
                sliderInput("e_1_1", "Efeito esperado na Cobertura vegetal:", -1, 1, 0.3, 0.1),
                sliderInput("v_1_1", "Variabilidade do efeito na Cobertura vegetal:", 0, 1, 0.2, 0.1),
                tags$hr(),
                sliderInput("e_1_2", "Efeito esperado no Relevo:", -1, 1, -0.1, 0.1),
                sliderInput("v_1_2", "Variabilidade do efeito no Relevo:", 0, 1, 0.2, 0.1),
                tags$hr(),
                sliderInput("e_1_3", "Efeito esperado na Vizinhança:", -1, 1, 0.3, 0.1),
                sliderInput("v_1_3", "Variabilidade do efeito na Vizinhança:", 0, 1, 0.4, 0.1)                
            ),
            box(
                width = 4,
                status = "primary",
                solidHeader = TRUE,
                collapsible = TRUE,
                title = "Evento - Bituca de cigarro",
                sliderInput("p_2", "Probabilidade:", 0, 1, 0.5, 0.1),
                tags$hr(),
                sliderInput("e_2_1", "Efeito esperado na Cobertura vegetal:", -1, 1, 0, 0.1),
                sliderInput("v_2_1", "Variabilidade do efeito na Cobertura vegetal:", 0, 1, 0, 0.1),
                tags$hr(),
                sliderInput("e_2_2", "Efeito esperado no Relevo:", -1, 1, 0, 0.1),
                sliderInput("e_2_2", "Variabilidade do efeito no Relevo:", 0, 1, 0, 0.1)
            ),
            box(
                width = 4,
                status = "primary",
                solidHeader = TRUE,
                collapsible = TRUE,
                title = "Evento 3",
                sliderInput("p_3", "Probabilidade:", 0, 1, 0.5, 0.1),
                tags$hr(),
                sliderInput("e_3_1", "Efeito esperado na Cobertura vegetal:", -1, 1, 0, 0.1),
                sliderInput("v_3_1", "Variabilidade do efeito na Cobertura vegetal:", 0, 1, 0, 0.1),
                tags$hr(),
                sliderInput("e_3_2", "Efeito esperado no Relevo:", -1, 1, 0, 0.1),
                sliderInput("e_3_2", "Variabilidade do efeito no Relevo:", 0, 1, 0, 0.1)
            ),
            box(
                width = 4,
                status = "primary",
                solidHeader = TRUE,
                collapsible = TRUE,
                title = "Correlações",
                sliderInput("corr_1_2", "Cobertura vegetal e Relevo:", -1, 1, -0.5, 0.1),
                sliderInput("corr_1_3", "Cobertura vegetal e Proximidade:", -1, 1, 0.4, 0.1),
                sliderInput("corr_2_3", "Proximidade e Relevo:", -1, 1, 0.3, 0.1)
            ),
            box(
                width = 4,
                status = "primary",
                solidHeader = TRUE,
                collapsible = TRUE,
                title = "Simulações",
                sliderInput("n_mmc", "N:", 10, 100, 15),
                plotOutput("histograma_mmc", height = 500)
                
            ) 
        ),
                
        # Instruções.
        tabItem(
            tabName = "instrucoes",
            includeMarkdown("ajuda.Rmd")
            
        )
    ))
))
