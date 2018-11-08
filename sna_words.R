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
if (! "wordcloud" %in% installed.packages()) install.packages("wordcloud")

# Carrega os pacotes necessários
library(rtweet)   # conexão com o twitter API
library(dplyr)    # manipulação de bancos de dados estilo tidy
library(tidyr)    # manipulação de dados
library(ggplot2)  # Visualização de dados
library(igraph)   # ARS - análises e visualização
library(stringr)  # Manipulação de texto
library(tm)       # Mineração de texto
library(wordcloud) # nuvens de palavras
source("remove_accent.R", encoding = "UTF-8")

# Se já tivermos os tweets salvos num arquivo csv, podemos importá-los para o R com o comando
rt = read_twitter_csv("tweets_coleta_2018_11_06_14_11_09.csv")

# Agora, vamos trabalhar com o texto dos tweets
# Para ter uma visão geral do conteúdo, vamos montar uma nuvem de palavras. Antes,
# é necessário um breve pre-processamento do texto
# Transforma num corpus
texto = VCorpus(VectorSource(enc2native(rt$text)))
# Transforma em letras minúsculas
texto = tm_map(texto, content_transformer(tolower))
# Aplica função que retira as URLs
texto = tm_map(texto, content_transformer(removeURL))
# Remove a pontuação
texto = tm_map(texto, removePunctuation)
# Remove as "stopwords"
texto = tm_map(texto, removeWords, stopwords("pt"))
# Remove os acentos
texto = tm_map(texto, content_transformer(remove_accent))
# define função que transforma os emojis e aplica 
f = content_transformer(function(x) iconv(x, from = "latin1", to = "ascii", sub = "byte"))
texto = tm_map(texto, f)
# Retira os códigos dos emojis
texto = tm_map(texto, content_transformer(function(x) gsub("<[a-z0-9][a-z0-9]>", "", x)))
# Plota a nuvem de palavras
wordcloud(texto, min.freq = 3, max.words = 100, random.order = F)

# tentativa de stem
stemmed = tm_map(texto, stemDocument, language = "pt")
# Plota a nuvem com as raízes das palavras
wordcloud(stemmed, min.freq = 3, max.words = 100, random.order = F)


# montando a matriz termos documentos como uma matriz 2-mode
tdm = TermDocumentMatrix(texto)
tdm = removeSparseTerms(tdm, .95) # retira termos esparsos
dim(tdm) # confere as dimensões

# Cria a rede
g <- graph_from_incidence_matrix(as.matrix(tdm))
# Extrai uma rede de 1-modo de palavras
p = bipartite_projection(g, which = "FALSE")
# Define o vértice como sem formato (apenas texto)
V(p)$shape = "none"

# Calcula o grau para plotar
deg = degree(p)
sort(deg, dec = T)

# Plota a rede de palavras
plot(p, vertex.label.cex=deg/20, edge.width=(E(p)$weight)/120, 
     edge.color=adjustcolor("grey60", .5),
     vertex.label.color=adjustcolor("red", .7))
