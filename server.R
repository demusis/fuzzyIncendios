# library(shinydashboard)
library(FuzzyR)

# setwd("D:/OneDrive/arincendio/fuzzyIncedio")

server <- function(input, output) {
    criaFuzzy <- reactive({
        # Cria sistema fuzzy.
        # a <- newfis ('hyper', fisType = " mamdani ", defuzzMethod = "centroid " )
        m1_fis <<- newfis('C')
        
        # Adiciona variáveis.
        m1_fis <<- addvar(m1_fis, 'input', 'A', c(0, 100))
        m1_fis <<- addvar(m1_fis, 'input', 'B', c(0, 100))
        m1_fis <<- addvar(m1_fis, 'output', 'C', c(0, 100))
        
        # Adiciona funções de pertença.
        # A.
        m1_fis <<-
            addmf(
                m1_fis,
                'input',
                1,
                'baixo',
                'trapmf',
                c(input$b_1_1, input$b_1_2, input$b_1_3, input$b_1_4)
            )
        m1_fis <<-
            addmf(
                m1_fis,
                'input',
                1,
                'médio',
                'trapmf',
                c(input$m_1_1, input$m_1_2, input$m_1_3, input$m_1_4)
            )
        m1_fis <<-
            addmf(
                m1_fis,
                'input',
                1,
                'alto',
                'trapmf',
                c(input$a_1_1, input$a_1_2, input$a_1_3, input$a_1_4)
            )
        # B.
        m1_fis <<-
            addmf(
                m1_fis,
                'input',
                2,
                'baixo',
                'trapmf',
                c(input$b_2_1, input$b_2_2, input$b_2_3, input$b_2_4)
            )
        m1_fis <<-
            addmf(
                m1_fis,
                'input',
                2,
                'médio',
                'trapmf',
                c(input$m_2_1, input$m_2_2, input$m_2_3, input$m_2_4)
            )
        m1_fis <<-
            addmf(
                m1_fis,
                'input',
                2,
                'alto',
                'trapmf',
                c(input$a_2_1, input$a_2_2, input$a_2_3, input$a_2_4)
            )
        # C.
        m1_fis <<-
            addmf(
                m1_fis,
                'output',
                1,
                'baixo',
                'trapmf',
                c(input$b_3_1, input$b_3_2, input$b_3_3, input$b_3_4)
            )
        m1_fis <<-
            addmf(
                m1_fis,
                'output',
                1,
                'médio',
                'trapmf',
                c(input$m_3_1, input$m_3_2, input$m_3_3, input$m_3_4)
            )
        m1_fis <<-
            addmf(
                m1_fis,
                'output',
                1,
                'alto',
                'trapmf',
                c(input$a_3_1, input$a_3_2, input$a_3_3, input$a_3_4)
            )
        
        # Regras.
        
        infile <- input$arq_regras
        # infile <- 'regras.csv'
        if (!is.null(infile)) {
            lista_regras <- read.csv(infile$datapath)
            # lista_regras <- read.csv(infile)
            m1_fis <<- addrule (m1_fis, as.matrix(lista_regras[,2:6]))
        } else {
            lista_regras <- rbind(
                # A  B  C   peso operador (1 - AND, 2 OR)
                c(1, 1, 1,  1,   1),
                c(1, 2, 2,  1,   1),
                c(1, 3, 3,  1,   1),
                
                c(2, 1, 2,  1,   1),
                c(2, 2, 2,  1,   1),
                c(2, 3, 3,  1,   1),
                
                c(3, 1, 3,  1,   1),
                c(3, 2, 3,  1,   1),
                c(3, 3, 3,  1,   1)
            )
            m1_fis <<- addrule (m1_fis, lista_regras)
        }
    })
    
    output$fuzzy_A <- renderPlot({
        criaFuzzy()
        plotmf(m1_fis, "input" , 1)
    })
    
    output$fuzzy_B <- renderPlot({
        criaFuzzy()
        plotmf(m1_fis, "input" , 2)
    })
    
    output$fuzzy_C <- renderPlot({
        criaFuzzy()
        plotmf(m1_fis, "output", 1)
    })
    
    output$fuzificacao_C <- renderPlot({
        criaFuzzy()
        res <- evalfis(c(input$v_1, input$v_2), m1_fis, draw = FALSE)
        nome_var = m1_fis$output[[1]]$name
        plot(D_x, D_y, type = "l", col = "blue", lwd = 3,
             xlab=nome_var,
             ylab='Pertinência')
        abline(v = D_out, col="red", lwd=3, lty=2)
        text(D_out, 0,  toString(D_out),
             cex=1, pos=4,col="red") 
    })
    
    output$regrasTexto <- renderPrint({
        criaFuzzy()

        texto <- capture.output(showrule(m1_fis))
        texto <- gsub(" If ", " Se ", texto)
        texto <- gsub(" is ", " é ", texto)
        texto <- gsub(" and ", " e ", texto)
        texto <- gsub(" or ", " ou ", texto)
        texto <- gsub(" then ", " então ", texto)
        texto
    })
    
    output$fisArquivo <- downloadHandler(filename = 'fuzzy.fis', 
                                         content = function(arqu){
                                         writefis(m1_fis, arqu)
                                         })
}

# shinyApp(ui, server)