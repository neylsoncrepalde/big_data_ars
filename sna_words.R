### Análise de redes entre palavras (redes semânticas)
### Curso Big Data para Análise de Redes Sociais
### 08 de novembro de 2018
### Prof. Neylson Crepalde
### GIARS - UFMG
################################################

# Se os pacotes necessários não estiverem instalados, faça a instalação
if (! "rtweet" %in% installed.packages()) install.packages("rtweet")
if (! "dplyr" %in% installed.packages()) install.packages("dplyr")
if (! "tidyr" %in% installed.packages()) install.packages("tidyr")
if (! "ggplot2" %in% installed.packages()) install.packages("ggplot2")
if (! "igraph" %in% installed.packages()) install.packages("igraph")
if (! "stringr" %in% installed.packages()) install.packages("stringr")
if (! "sna" %in% installed.packages()) install.packages("sna")
if (! "blockmodels" %in% installed.packages()) install.packages("blockmodels")
if (! "tm" %in% installed.packages()) install.packages("tm")

# Carrega os pacotes necessários
library(rtweet)  # conexão com o twitter API
library(dplyr)   # manipulação de bancos de dados estilo tidy
library(tidyr)   # manipulação de dados
library(ggplot2) # Visualização de dados
library(igraph)  # ARS - análises e visualização
library(stringr) # Manipulação de texto
library(tm)      # Mineração de texto

# Se já tivermos os tweets salvos num arquivo csv, podemos importá-los para o R com o comando
rt = read_twitter_csv("tweets_coleta_2018_11_06_14_11_09.csv")

# Agora, vamos trabalhar com o texto dos tweets
