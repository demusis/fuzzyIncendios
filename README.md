# fuzzyIncendios

> APlicativo interativo para avaliação do risco de incêndios florestais usando **lógica fuzzy** e **simulação de Monte Carlo**, implementada como aplicativo **Shiny** em **R**.

---

## Visão geral

O aplicativo combina duas abordagens complementares:

1. **Sistema Mamdani fuzzy** (biblioteca `FuzzyR`) que estima o *Risco de incêndio* (0 – 100 %) a partir de três variáveis ambientais:
   - **Cobertura vegetal** (0 – 100 %)
   - **Relevo** (0 – 100 %)
   - **Proximidade da população** (0 – 1 000 m)
2. **Método de Monte Carlo** (bibliotecas `mc2d` & `propagate`) que propaga incertezas de eventos detonadores (p.ex. raios, bitucas de cigarro) e devolve a distribuição probabilística do risco.

A interface, construída com `shinydashboard`, permite ao usuário:

* Ajustar graficamente as funções de pertinência trapezoidais por *sliders*.
* Carregar/editar regras fuzzy via arquivo CSV ou gerar uma grade automática.
* Definir probabilidades, efeitos médios, variâncias e correlações entre eventos.
* Visualizar curvas de pertinência, regras legíveis em português, valores defuzzificados e histogramas de risco.
* Exportar o modelo em formato **`.fis`** para uso externo.

---

## Estrutura do repositório

```text
.
├── ui.R          # Interface Shiny (shinydashboard)
├── server.R      # Lógica fuzzy, Monte Carlo e controladores reativos
├── regras.csv    # Exemplo de base de regras (opcional)
├── ajuda.Rmd     # Manual embutido, exibido na aba “Instruções”
└── README.md     # Este arquivo
```

### server.R
* **criaFuzzy()** – Constrói o sistema `fis` com funções de pertinência definidas em `ui.R`.
* **efeitoEvento()** – Simula ocorrência e intensidade de um evento, aplicando efeitos multivariados correlacionados.
* **renderPlot() / renderPrint()** – Desenha curvas de pertinência, processos de fuzificação e histogramas.
* **downloadHandler()** – Gera o arquivo `fuzzy.fis` sob demanda.

### ui.R
* Barra lateral com três abas: *Lógica fuzzy*, *Método de Monte Carlo* e *Instruções*.
* Cada variável (entrada/saída) é controlada por *sliders* em subtabs independentes.
* Componentes colapsáveis (*shinydashboard::box*) otimizam o uso do espaço.

---

## Pré‑requisitos

| Pacote | Versão sugerida |
|--------|-----------------|
| R ≥ 4.2|                 |
| FuzzyR | ≥ 2.3           |
| mc2d   | ≥ 0.1‑18        |
| propagate | ≥ 1.0‑6      |
| qlcMatrix | ≥ 0.9.7      |
| shinydashboard | ≥ 0.7.2 |

Instale tudo de uma vez:

```r
install.packages(c("FuzzyR", "mc2d", "propagate", "qlcMatrix", "shinydashboard"))
```

---

## Instalação e execução

```bash
# clone o repositório
git clone https://github.com/demusis/fuzzyIncendios.git
cd fuzzyIncendios

# inicie o app
R -e "shiny::runApp('.')"
```

Também é possível abrir `ui.R`/`server.R` no RStudio e clicar em **Run App** ou implantar em Shiny Server sem alterações adicionais.

---

## Uso rápido

1. **Aba Lógica fuzzy**
   1. Ajuste os *sliders* das funções de pertinência.
   2. (Opcional) Carregue `regras.csv` para usar sua própria base.
   3. Informe valores pontuais das variáveis em *Fuzificação – Antecedentes*.
   4. Observe o risco defuzzificado e baixe o modelo `.fis` se desejar.
2. **Aba Método de Monte Carlo**
   1. Defina a probabilidade de cada evento (raio, bituca, etc.).
   2. Ajuste os efeitos médios, variâncias e correlações.
   3. Escolha o número de simulações e examine o histograma resultante.
3. **Aba Instruções** – Consulte detalhes teóricos e dicas de interpretação.

---

## CSV de regras
O arquivo deve ter pelo menos cinco colunas: três de antecedentes (inteiros referentes às posições das funções de pertinência), uma para a consequente e uma para *peso*; uma sexta coluna opcional define o operador lógico (1 = AND, 2 = OR).

```csv
Antecedente1,Antecedente2,Antecedente3,Consequente,Peso,Operador
1,1,1,1,1,1
1,2,3,2,1,1
# ...
```

Caso nenhum CSV seja carregado, o aplicativo cria automaticamente uma grade completa de combinações.

---

## Exemplos de extensão
* **Novos eventos** – Adicione *sliders* extras em `ui.R` e chame `efeitoEvento()` no `server.R`.
* **Outras variáveis de risco** – Expanda `criaFuzzy()` para incluir mais entradas/saídas.
* **Mudança de método de defuzzificação** – Alterar argumento `defuzzMethod` para `bisector`, `mom`, etc.
