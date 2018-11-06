### Curso Big Data para Análise de Redes Sociais
### 08 de novembro de 2018
### Prof. Neylson Crepalde
### GIARS - UFMG
################################################

# Se os pacotes necessários não estiverem instalados, faça a instalação
if (! "rtweet" %in% installed.packages()) install.packages("rtweet")
if (! "dplyr" %in% installed.packages()) install.packages("dplyr")
if (! "ggplot2" %in% installed.packages()) install.packages("ggplot2")
if (! "igraph" %in% installed.packages()) install.packages("igraph")

# Carrega os pacotes necessários
library(rtweet)  # conexão com o twitter API
library(dplyr)   # manipulação de bancos de dados estilo tidy
library(ggplot2) # Visualização de dados
library(igraph)  # ARS - análises e visualização

## Buscando dados no Twitter ####
# Vamos criar um token usando as chaves de acesso que criamos
# Importa as chaves de outro script
source("access_keys.R")
my_token = create_token(app, consumer_key, consumer_secret, access_token, access_secret)
# Verifica os limites de pesquisa para este token
# my_limits = rate_limits(my_token)
# my_limits

# Vamos fazer uma busca de 10000 tweets contendo as hashtags 
# #elenao, #elesim, #bolsonaro17 e #haddad13
rt = search_tweets(q = "#elenao OR #elesim OR #bolsonaro17 OR #haddad13", 
                   n = 10000,
                   token = my_token)


# Análises preliminares ####
# Como o objeto rt é um tibble, podemos chamá-lo pelo nome para uma visualização sucinta.
# Não é recomendável fazer isso com outros tipos de bancos de dados.
class(rt)
rt

# Quais informações estão disponíveis pra nós nessa coleta?
names(rt)

# Vamos verificar o texto de alguns tweets coletados
head(rt$text)

# Com um comando simples, vamos verificar a distribuição desses tweets no tempo
ts_plot(rt)




