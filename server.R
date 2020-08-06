
# library(shinydashboard)
# install.packages('qlcMatrix')

library(FuzzyR)
library(mc2d)
library(propagate)
library(qlcMatrix)
library(utils)


# setwd("D:/OneDrive/Fuzzy/fuzzyIncendio")

efeitoEvento <- function(valores, p, correlacoes, medias_efeitos, variancias_efeitos) {
    nrep <- 1
    aux_ber <- rbern(n=nrep, prob=p)
    
    covariancias <- cor2cov(correlacoes, variancias_efeitos)
    covariancias <- as.vector(covariancias)
    
    aux_efeitos <- aux_ber*rmultinormal(nrep, medias_efeitos, covariancias)
    aux_efeitos[aux_efeitos==0] <- 1
    var_cons_efeito <- sweep(aux_efeitos, MARGIN = 2, valores, '*')
    
    return(var_cons_efeito)
}

# 
# Servidor.
#

server <- function(input, output) {
    criaFuzzy <- reactive({
        # Cria sistema fuzzy.
        # a <- newfis ('hyper', fisType = " mamdani ", defuzzMethod = "centroid " )
        m1_fis <<- newfis('C')
        
        # Adiciona variáveis.
        m1_fis <<- FuzzyR::addvar(m1_fis, 'input', 'Cobertura vegetal', c(0, 100))
        m1_fis <<- FuzzyR::addvar(m1_fis, 'input', 'Relevo', c(0, 100))
        m1_fis <<- FuzzyR::addvar(m1_fis, 'input', 'Proximidade da população', c(0, 1000))
        m1_fis <<- FuzzyR::addvar(m1_fis, 'output', 'Risco de incêndio', c(0, 100))
        
        # Adiciona funções de pertença.
        # Cobertura vegetal.
        m1_fis <<-
            addmf(
                m1_fis,
                'input',
                1,
                'baixa',
                'trapmf',
                c(input$b_1_1, input$b_1_2, input$b_1_3, input$b_1_4)
            )
        m1_fis <<-
            addmf(
                m1_fis,
                'input',
                1,
                'média',
                'trapmf',
                c(input$m_1_1, input$m_1_2, input$m_1_3, input$m_1_4)
            )
        m1_fis <<-
            addmf(
                m1_fis,
                'input',
                1,
                'alta',
                'trapmf',
                c(input$a_1_1, input$a_1_2, input$a_1_3, input$a_1_4)
            )
        
        # Relevo.
        m1_fis <<-
            addmf(
                m1_fis,
                'input',
                2,
                'Plano',
                'trapmf',
                c(input$b_2_1, input$b_2_2, input$b_2_3, input$b_2_4)
            )
        m1_fis <<-
            addmf(
                m1_fis,
                'input',
                2,
                'Rampa ou colina',
                'trapmf',
                c(input$mb_2_1, input$mb_2_2, input$mb_2_3, input$mb_2_4)
            )
        m1_fis <<-
            addmf(
                m1_fis,
                'input',
                2,
                'Morrote',
                'trapmf',
                c(input$ma_2_1, input$ma_2_2, input$ma_2_3, input$ma_2_4)
            )
        m1_fis <<-
            addmf(
                m1_fis,
                'input',
                2,
                'Morro com encosta suave',
                'trapmf',
                c(input$a_2_1, input$a_2_2, input$a_2_3, input$a_2_4)
            )
        m1_fis <<-
            addmf(
                m1_fis,
                'input',
                2,
                'Morro com encosta forte',
                'trapmf',
                c(input$ma_2_1, input$ma_2_2, input$ma_2_3, input$ma_2_4)
            )
        
        # Proximidade.
        m1_fis <<-
            addmf(
                m1_fis,
                'input',
                3,
                'Na área',
                'trapmf',
                c(input$b_2_1, input$b_2_2, input$b_2_3, input$b_2_4)
            )
        m1_fis <<-
            addmf(
                m1_fis,
                'input',
                3,
                'Próxima',
                'trapmf',
                c(input$mb_2_1, input$mb_2_2, input$mb_2_3, input$mb_2_4)
            )
        m1_fis <<-
            addmf(
                m1_fis,
                'input',
                3,
                'Média',
                'trapmf',
                c(input$ma_2_1, input$ma_2_2, input$ma_2_3, input$ma_2_4)
            )
        m1_fis <<-
            addmf(
                m1_fis,
                'input',
                3,
                'Distante',
                'trapmf',
                c(input$a_2_1, input$a_2_2, input$a_2_3, input$a_2_4)
            )
        
        
        # Risco de incêndio.
        m1_fis <<-
            addmf(
                m1_fis,
                'output',
                1,
                'Muito baixo',
                'trapmf',
                c(input$mb_3_1, input$mb_3_2, input$mb_3_3, input$mb_3_4)
            )
        m1_fis <<-
            addmf(
                m1_fis,
                'output',
                1,
                'Baixo',
                'trapmf',
                c(input$b_3_1, input$b_3_2, input$b_3_3, input$b_3_4)
            )
        m1_fis <<-
            addmf(
                m1_fis,
                'output',
                1,
                'Médio',
                'trapmf',
                c(input$m_3_1, input$m_3_2, input$m_3_3, input$m_3_4)
            )
        m1_fis <<-
            addmf(
                m1_fis,
                'output',
                1,
                'Alto',
                'trapmf',
                c(input$a_3_1, input$a_3_2, input$a_3_3, input$a_3_4)
            )
        m1_fis <<-
            addmf(
                m1_fis,
                'output',
                1,
                'Muito alto',
                'trapmf',
                c(input$ma_3_1, input$ma_3_2, input$ma_3_3, input$ma_3_4)
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
                # A  B  C  D peso operador (1 - AND, 2 OR)
                c(1, 1, 1, 1,   1,       1),
                c(1, 2, 2, 1,   1,       1),
                c(1, 3, 3, 1,   1,       1),
                
                c(2, 1, 2, 1,   1,       1),
                c(2, 2, 2, 1,   1,       1),
                c(2, 3, 3, 1,   1,       1),
                
                c(3, 1, 3, 1,   1,       1),
                c(3, 2, 3, 1,   1,       1),
                c(3, 3, 3, 1,   1,       1)
            )
            
            lista_regras <- expand.grid(1:3, 1:5, 1:4)
            
            lista_regras$c <- rowMax(as.matrix(lista_regras))@x
            lista_regras$peso <- 1
            lista_regras$operador <- 1
            m1_fis <<- addrule(m1_fis, as.matrix(lista_regras))
        }
    })
    
    output$cobertura_vegetal_fuzzy <- renderPlot({
        criaFuzzy()
        plotmf(m1_fis, "input" , 1)
    })
    
    output$relevo_fuzzy <- renderPlot({
        criaFuzzy()
        plotmf(m1_fis, "input" , 2)
    })
    
    output$proximidade_fuzzy <- renderPlot({
        criaFuzzy()
        plotmf(m1_fis, "input" , 3)
    })
    
    output$risco_incendio_fuzzy <- renderPlot({
        criaFuzzy()
        plotmf(m1_fis, "output", 1)
    })
    
    output$risco_incendio_fuzificacao <- renderPlot({
        criaFuzzy()
        res <- evalfis(c(input$v_1, input$v_2, input$v_3), m1_fis, draw = FALSE)
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
        HTML(texto)
    })
    
    output$histograma_mmc <- renderPlot({
        res_mmc <- data.frame(va=double(),
                              vb=double(),
                              stringsAsFactors=FALSE)
        for (n in 1:input$n_mmc) {
            # Avalia o efeito do evento 1 (por hora).
            aux_res <- efeitoEvento(
                valores = c(input$v_1, input$v_2, input$v_3),
                p = input$p_1,
                correlacoes = matrix(c(             1, input$corr_1_2, input$corr_1_3,
                                       input$corr_1_2,              1, input$corr_2_3,
                                       input$corr_1_3, input$corr_2_3,              1), ncol = 3),
                medias_efeitos = c(input$e_1_1, input$e_1_2, input$e_1_3),
                variancias_efeitos = c(input$v_1_1, input$v_1_2, input$v_1_3)
            )
            
            res_mmc <- rbind(res_mmc, aux_res)
        }
        res <- evalfis(as.matrix(res_mmc), m1_fis, draw = FALSE)
        hist(res)
    })
    
    output$fisArquivo <- downloadHandler(filename = 'fuzzy.fis', 
                                         content = function(arqu){
                                         writefis(m1_fis, arqu)
                                         })
    
}

# shinyApp(ui, server)