### Análise de redes com tweets coletados
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
if (! "stringr" %in% installed.packages()) install.packages("stringr")

# Carrega os pacotes necessários
library(rtweet)  # conexão com o twitter API
library(dplyr)   # manipulação de bancos de dados estilo tidy
library(tidyr)   # manipulação de dados
library(ggplot2) # Visualização de dados
library(igraph)  # ARS - análises e visualização
library(stringr) # Manipulação de texto

# Se já tivermos os tweets salvos num arquivo csv, podemos importá-los para o R com o comando
rt = read_twitter_csv("tweets_coleta_2018_11_06_14_11_09.csv")

# O processo de construção de uma rede
# Objeto de classe "igraph".
# Umas das formas mais eficientes é montar uma matriz de duas colunas sendo a primeira o
# sender e a segunda o receiver.

# Rede de citações em tweets
grep("@\\w+", rt$text, v=T) %>% length
receivers = str_extract_all(rt$text, "@\\w+")
receivers[10:20]

# construindo a matriz
topcit = max(sapply(receivers, length)) # Verifica a maior quantidade de citações num tweet
# Cria uma matriz vazia para guardar os citados
citados = matrix(nrow = nrow(rt), ncol = topcit) 

# Preenche com os citados
for (i in 1:nrow(rt)) {
  for (j in 1:length(receivers[[i]])) {
    citados[i,j] = receivers[[i]][j]
  }
}

citados

# Cola os senders na primeira coluna
rede_citacoes = cbind(rt$screen_name, citados)
head(rede_citacoes)

# transforma para que fique com apenas duas colunas
rede_citacoes = rede_citacoes %>% 
  as_tibble %>% 
  gather("col", "name", -V1) %>% 
  mutate(sender = V1,
         receiver = str_remove_all(name, "@")) %>% 
  select(sender, receiver) %>% 
  na.omit %>% 
  as.matrix

# Cria o objeto igraph
g_citacoes = graph_from_edgelist(rede_citacoes, directed = T)
g_citacoes

# Plota
layoutgg = layout_with_kk(g_citacoes)
plot(g_citacoes, vertex.size = 2, vertex.label = NA,
     edge.arrow.size = .3, edge.color = adjustcolor("grey",.8),
     layout = layoutgg)


# Plotando com o tamanho nos nós
plot(g_citacoes, vertex.size = degree(g_citacoes, normalized = T)*300,
     vertex.label = NA, vertex.color = adjustcolor("orange", .7),
     edge.arrow.size = .3, edge.color = adjustcolor("grey",.8),
     layout = layoutgg)

# Quem são os usuários mais citados?
grau = degree(g_citacoes)
sort(grau, decreasing = T)
