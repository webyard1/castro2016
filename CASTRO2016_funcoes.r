############################################################
#
#	TODOS OS SCRIPTS
#
############################################################

###########
# SUMARIO #
###########

## LEITURA DE ARQUIVOS TXT EM PASTA

# le_txt_pasta

## LIMPEZA DO TEXTO

# limpeza

## REMOVER MARCADORES (ENTRE < E >)

# removeMarcador

## TORNAR UM TERMO COMPOSTO EM UM TEXTO

# prepara_palavra_composta

## GERAR INDICES COM BASE EM UMA LISTA DE VERBOS

# gera_indices

## GERAR TEXTO_NUVEM a partir de uma LISTA DE FREQUENCIA

#lista_freq_para_texto_nuvem

## LISTA DE FREQUENCIA

# lista_frequencia

## NUVEM DE PALAVRAS

# nuvem_palavras

## LINHAS DE CONCORDANCIA

# concordancia

## LISTA DE COLOCADOS

# colocados

## DENDOGRAMA

# dendograma

###########################################################

# LEITURA DE ARQUIVOS TXT EM PASTA

# FUNCAO PARA LER TXT EM PASTAS COM CODIFICACAO (TXT OU UTF-8, POR EXEMPLO)


le_txt_pasta = function (CODIFICACAO = c("ANSI","UTF-8")) {

# escolhendo a pasta com os textos de analise 
# e obtendo o endereco do diretorio
direct = choose.dir(getwd(), caption=toupper("Escolha o diretorio onde estao os textos"))

# definindo extensao do arquivo
EXTENSAO = ".txt"

# acerca a expressao regular com o * (que significa qualquer sequencia de caracteres) para a EXTENSAO do arquivo_saida 
EXTENSAO = paste("*",EXTENSAO,sep= "")

# lista os arquivos (no formato ".txt") do diretorio
lista_arquivos_dir = list.files(direct, pattern=EXTENSAO, full.names=TRUE)

# cria funcao para ler arquivos .txt em, default, na codificacao ANSI
# CODIFICACAO pega o primeiro valor da lista de valores
func_leitura = function (files) readLines(files,warn=F,skipNul=F,encoding= CODIFICACAO[1])

# define arquivo de saida
NOME_ARQUIVO = "arquivo_saida"

# lendo os arquivos com a funcao criada
# criando um objeto com o nome dado anteriormente,
# com o conteudo dos arquivos em uma lista

assign (NOME_ARQUIVO,

		lapply(lista_arquivos_dir, func_leitura)
)

###
# gerando resultado

# vetor em branco para preencher
Resultado = list()

# gera dados de saida
Resultado = arquivo_saida

# gera indice dos resultados (nomes dos arquivos do diretorio na ordem)
indices_result = gsub(".txt","",dir(direct))

names(Resultado) = indices_result

###

# retorna resultado
return(Resultado)

}

#######	FIM DA FUNCAO

###########################################################

# LIMPEZA DO TEXTO

### FUNCAO LIMPEZA DE TEXTOS

limpeza = function(TEXTO) {

if (!is.character(TEXTO)) {
	stop("TEXTO deve ser um vetor de caracteres")
}

# elimina pontuações, barras e parênteses
TEXTO = gsub("[\\,_/.;:()..?!\\\\]","",TEXTO,ignore.case=T,perl=T)
# elimina reticencias
TEXTO = gsub("\\.\\.\\.$","",TEXTO,ignore.case=T,perl=T) 
# elimina todas as aspas duplas dos textos
TEXTO = gsub("\"","",TEXTO,ignore.case=T,perl=T) 
# elimina todas as aspas simples dos textos
TEXTO = gsub("\'","",TEXTO,ignore.case=T,perl=T) 
# troca % por por_cento
TEXTO = gsub("[%]","por_cento",TEXTO,ignore.case=T,perl=T) 
# elimina espaços EXTRAS (troca 2 a 5 espacos por apenas um)
TEXTO = gsub(" {2,5}"," ",TEXTO,perl=T) 
# elimina espaços em branco no inicio das orações/dos itens
TEXTO = gsub("^ ","",TEXTO,perl=T) 
# elimina espaços em branco no fim das orações/dos itens
TEXTO = gsub(" $","",TEXTO,perl=T)
# substitui hifens por underlines  
TEXTO = gsub("-","_",TEXTO,ignore.case=T) 
# elimina os dígitos
TEXTO = gsub("[[:digit:]]","",TEXTO,ignore.case=T) 
# passa pra minúsculo. 
TEXTO = tolower(TEXTO) 

# retira reticencias iniciais
TEXTO = gsub("^…","",TEXTO) 
# retira reticencias finais
TEXTO = gsub("…$","",TEXTO) 
# retira espaco extra final
TEXTO = gsub(" $","",TEXTO) 

# elimina itens apenas com espacos
TEXTO = TEXTO[TEXTO!=" "] 
# retira itens nulos remanescentes das substituicoes
TEXTO = TEXTO[TEXTO!=""] 


##### USAR LIMPEZA DO TM POR SEGURANCA

# importando e carregando pacote tm
if (!require("tm")) {
	install.packages("tm")
	require("tm")
} else {
		require("tm")
}

# remove pontuacao via tm
TEXTO = removePunctuation(TEXTO,preserve_intra_word_dashes = TRUE)
# remove numeros via tm
TEXTO = removeNumbers(TEXTO)

#CARACTERES ESPECIAIS DO TECLADO

return(TEXTO)
}

#######	FIM DA FUNCAO

##########################################################################

# REMOVER MARCADORES (ENTRE < E >)

######	FUNÇAO PARA REMOVER ITENS ENTRE <>

#Removendo tudo que esta entre < >
removeMarcador = function(TEXTO){
  
TEXTO = gsub(pattern="<[^<>]*>",replacement="",x=TEXTO)

# Remove linhas em branco
TEXTO = TEXTO[which(TEXTO!="")]

# Remove tabulações
TEXTO = TEXTO[which(TEXTO!="\t")]

# Elimina espaços em branco no início das orações

# importa pacote stringr
if (!require("stringr")) {
	install.packages("stringr")
	require(stringr)
} else { 
	require("stringr")
}

# remove espaco inicial
TEXTO = str_replace_all(TEXTO,"^ $","") 
# remove espaco final
TEXTO = gsub(" $","",TEXTO,perl=T) 

# Retornando o resultado
return(TEXTO) 
}

#######	FIM DA FUNCAO

##########################################################################

### Funcao para tornar um termo composto em um texto 

prepara_palavra_composta = function (TEXTO,TERMO) {

# expressao regular que busca palavra seguida de espaco, 
# esta seguida de e/ou outras palavras
regexSource = "[A-Za-z]+ [A-Za-z]+( [A-Za-z]+)?"

# se a condicao for verdadeira, executa
if( grepl(regexSource ,TERMO) ) {
	temp = TERMO # armazena TERMO com espacos para posterior substituicao
	TERMO = gsub(" ","-",TERMO) # troca espaco por hifen no TERMO
	TEXTO = gsub(temp,TERMO,TEXTO) # troca espaco por hifen do TERMO no TEXTO
	rm(temp) # deleta objeto que nao e mais necessario
}

return (TEXTO)

}

##########################################################################

# Funcao para gerar indices com base em uma lista de verbos

gera_indices = function(lista_verbos,planilha) {

	# gerando lista vazia
	ind_fundidos = c()

	# loop para gerar indices de cada palavra em uma busca

	for (verbo in lista_verbos) {

		#define nome de variavel a usar em cada ciclo do loop
		nome_var = paste("ind",verbo,sep="_")

		#define palavra de busca a usar em cada ciclo do loop
		pal_busca = paste(verbo,"$",sep="")

		# fundindo indices da linha num so objeto para eliminar
		ind_fundidos = append(ind_fundidos,
					#gerando variaveis com o nome pre-definido
					assign(nome_var,
					grep(pal_busca,planilha)
					))

	}

return (ind_fundidos)

} # fim da funcao gera_indices

##########################################################################

# FUNCAO QUE GERA TEXTO_NUVEM a partir de uma LISTA DE FREQUENCIA

lista_freq_para_texto_nuvem = function (LISTA_FREQ) {

texto_nuvem = character()

for (linha in 1:nrow(LISTA_FREQ)) {
	texto_nuvem = (
		append (texto_nuvem,rep(as.character(LISTA_FREQ[linha,1]),LISTA_FREQ[linha,2]))
			)
}

return(texto_nuvem)

}


##########################################################################

####################################################################
#
# SCRIPT PARA FAZER LISTA DE FREQUENCIA
#
####################################################################



lista_frequencia = function (texto, ALFAB = FALSE) {
	# Se ALFAB = TRUE, a lista estara em ordem alfabetica, 
	# senao estara em ordem decrescente de frequencia

############### Validacao

if (!is.character(texto)) {
	stop("texto deve ser vetor de caracteres")
}

if (!is.logical(ALFAB)) {
	stop("ALFAB deve ser vetor logico")
}


###############

# passa tudo pra minusculo
texto = tolower(texto) 

######### Limpeza geral

# importa pacote stringr
if (!require("stringr")) {
	install.packages("stringr")
	require("stringr")
} else {
		require("stringr")
}

# remove pontuacao
texto = str_replace_all(texto,"[,.;:()\"?!\\/]","")

# remove reticencias
texto = str_replace_all(texto,"[\\.\\.\\.]","")

# remove espaco no inicio
texto = str_replace_all(texto,"^ ","") 

# remove numeros
texto = str_replace_all(texto,"[[:digit:]]","")


##### USAR LIMPEZA DO TM POR SEGURANCA

# importando e carregando pacote tm
if (!require("tm")) {
	install.packages("tm")
	require("tm")
} else {
		require("tm")
}

# remove pontuacao via tm
texto = removePunctuation(texto,preserve_intra_word_dashes = TRUE)

# remove numeros via tm
texto = removeNumbers(texto)


######### LISTA DE PALAVRAS (wordlist)

# divide itens (palavras) por espaco
wordlist = strsplit(texto," ")

# une itens (palavras) num vetor de caracteres
words_vector = unlist(wordlist)

# cria uma lista de frequencia 
freq_list = table(words_vector) 

# Vetor logico com 3 condicoes a serem cumpridas para eliminar

# condicoes:
#1: os itens (os nomes das linhas) que sao itens vazios ("")
#2: os itens (os nomes das linhas) que sao espacos (" ")
#3: os itens (os nomes das linhas) que sao hifens ("-")

condition = (row.names(freq_list) != "") & (row.names(freq_list) != " ") &
				(row.names(freq_list) != "-")

# filtragem para satisfazer a condicao acima
freq_list = freq_list[condition == TRUE]

# ordena a lista em ordem decrescente
sorted_freq_list = sort(freq_list,decreasing=T) 

# limpa caracteres nao alfanumericos dos itens da lista
# que nao foram eliminados na limpeza anterior
# utilizando uma expressao regular "[^[:alnum:]_]"

sorted_freq_list[1]$Termo = gsub("[^[:alnum:]_]","",sorted_freq_list[1]$Termo)
################################################

# Transformando lista_freq de array (arranjo) gerado pela funcao "table" para dataframe
# e organizando dados 

# Alteracao feita devido a uma mudanca na funcao data.frame ao lidar com arrays (arranjos)
# da versao 3.2.5 para a versao 3.3.0

# obtendo versao atual do R

# versao atual
curr_R_vers = package_version(R.version)

#####

# versao chave (key), a partir da qual houve uma modificacao importante
key_R_vers = "3.3.0"

# Nao e necessario rodar essa linha porque a comparacao transforma o numero da versao em string
#key_R_vers = as.numeric_version(key_R_vers)

#####

# Conferindo versao e executando comandos para a versao atual (seja igual ou anterior a 3.3.0)
                                                                       
# se o 1o caractere da versao do R (de valor "3", se a versao for 3.2.5) for menor o 1o caractere da versao "chave" do R
if (substr(curr_R_vers,1,1) < substr(key_R_vers,1,1) |  # OU
	# se o 1o caractere da versao do R (de valor "3", se a versao for 3.2.5) for igual ao 1o caractere da versao "chave"
	# (de valor "2", se a versao for 3.2.5) E o 3o (de valor "2", se a versao for 3.2.5) for menor que o 3o da versao "chave" # (no caso, "3")
	(substr(curr_R_vers,1,1) == substr(key_R_vers,1,1) & (substr(curr_R_vers,3,3) < (substr(key_R_vers,3,3))))
	) {

	# transforma em dataframe
	sorted_freq_list = data.frame(sorted_freq_list)

	# organiza dados no dataframe
	sorted_freq_list = data.frame(Termo = row.names(sorted_freq_list),
						Frequencia = sorted_freq_list,row.names=NULL, stringsAsFactors=FALSE)

} else { # se a versao atual do R for maior ou igual a 3.3.0

	# transforma em dataframe sem os nomes das linhas (que seriam iguais aos dados da 1a coluna)
	sorted_freq_list = data.frame(sorted_freq_list,row.names = NULL)
}

################################################

# define nomes das colunas pro resultado
colnames(sorted_freq_list) = c("Termo","Frequencia")

# Se o argumento ALFAB for TRUE, a lista sai em ordem alfabetica, caso contrario, sai em ordem decrescente.
if (ALFAB == TRUE) {
	sorted_freq_list = sorted_freq_list[order(sorted_freq_list$Termo),]
}	

# retorna resultado
return(sorted_freq_list)

} # FIM DA FUNCAO


############################################################################


####################################################################
#
# SCRIPT PARA FAZER NUVEM DE PALAVRAS
#
####################################################################

####################################################################

nuvem_palavras = function(TEXTO, ALFAB = FALSE,
				  STOPWORDS_default = c(NA,TRUE,FALSE), # Stopwords default (TRUE); Stopwords personalizadas
														# Stopwords personalizadas	(FALSE);
														# Ausencia de stopwords (NA)
				  # lingua das stopwords
				  LANGUAGE = c("portuguese","danish", "dutch", "english", "finnish", "french", "german", "hungarian", "italian", "norwegian","russian", "spanish", "swedish"), 
				  TITULO = " ", # Titulo da nuvem de palavras
				  MIN = 2, # Frequencia minima para aparecer na nuvem
				  MAX_WORDS = 300, # Frequencia maxima para aparecer na nuvem
				  COLORS = c("black","grey") # cores das palavras de menor e maior frequencia
			) {

#########################################
# carregando pacote "tm"
#########################################

# importa pacote tm
if (!require("tm")) {
	install.packages("tm")
	require("tm")
} else { 
	require("tm")
}

#########################################

# TESTES DE OBJETOS


if (!is.character(LANGUAGE)) {
	stop("LANGUAGE deve ser um vetor de caracteres de comprimento 1\n")
}

if (!is.character(TEXTO)) {
	stop("TEXTO deve ser um vetor de caracteres\n")
}
  
if (!is.logical(STOPWORDS_default)) {
	stop("STOPWORDS_default deve ser um vetor logico (TRUE ou FALSE ou NA)\n")
}

if (!is.character(COLORS)) {
	stop("COLORS deve ser um vetor de caracteres\n")
}

if (!is.character(TITULO) || length(TITULO) != 1) {
	stop("TITULO deve ser um vetor de caracteres de comprimento 1\n")
}

if (!is.numeric(MIN) || length(MIN) != 1) {
	stop("MIN deve ser um vetor numerico de comprimento 1\n")
}

if (!is.numeric(MAX_WORDS) || length(MAX_WORDS) != 1) {
	stop("MAX_WORDS deve ser um vetor numerico de comprimento 1\n")
}

######

# Criando lista de frequencia

LISTA_FREQ = lista_frequencia(TEXTO)

# definindo nome das colunas da lista de frequencia
colnames(LISTA_FREQ)[1:2] = c("Termo","Frequencia")

###### LIMPEZA DAS STOPWORDS PRA FAZER A NUVEM DE PALAVRAS

##	DEFININDO STOPWORDS

if (is.na(STOPWORDS_default)) { # SE NAO quiser usar uma lista de stopwords
						   # ou seja, se STOPWORDS_default for NA
	stopwords = character() # valor nulo (vetor sem elementos)

} else if (STOPWORDS_default == TRUE) { # se quiser usar stopwords default

	# Gerando lista de linguas disponiveis para stopwords default
	linguas_stopwords = c("danish", "dutch", "english", "finnish", "french", "german", "hungarian",
					"italian", "norwegian", "portuguese","russian", "spanish", "swedish")

	STOPWORDS_default = STOPWORDS_default[1] # pega so o primeiro elemento da lista
		
		
	if (length (intersect (LANGUAGE[1], linguas_stopwords)) > 0) { # SE escolher uma das linguas disponiveis
	
		stopwords = stopwords(LANGUAGE[1])
	
		# Gerando nome do arquivo
		StopList = paste ("stopwords_default_",LANGUAGE[1],".txt",sep="")   
	
		# Salvando arquivo no diretorio
		
		#cat("Salvando lista de stopwords no diretorio de trabalho com o nome 'stopwords_default_LINGUA.txt'\n")
		
		#writeLines(stopwords,StopList)
		}

} else if (STOPWORDS_default == FALSE) { # SE NAO escolher uma das linguas disponiveis, mas sim quiser uma personalizada
    
	# MENSAGEM DE AVISO

	# O usuario deve digitar qualquer tecla para o programa avancar,
	# com isso ele sabe que arquivo deve selecionar.

	# criando variavel msg com valor arbitrario (diferente de vazio)
	 msg = 1
	 
	 # se o usuario nao apertar enter o programa nao continua
	while (msg != "") {
		cat("\n")
		msg = readline("Aperte ENTER para selecionar o arquivo de texto (.txt) contendo as stopwords.\n")
	}
	
	# Stopwords personalizadas

	# SELECIONAR LISTA DE STOPWORDS
	stopwords = readLines(choose.files(),warn=F)

	# salvando stopwords personalizadas

	# MENSAGEM DE AVISO	
	#cat("Salvando lista de stopwords no diretorio de trabalho com o nome 'stopwords_default_LINGUA.txt'\n")

	#writeLines(stopwords,"stopwords.txt")
	
}


#########

#  REMOVENDO STOPWORDS (se houver)

# vetor auxiliar
palavras = LISTA_FREQ$Termo

#Linha com o comando de remover as stopwords
lista = unlist(palavras)[!(unlist(palavras) %in% stopwords)]

# Gera lista de frequencia sem termos da stoplist

seleciona <- LISTA_FREQ$Termo %in% lista   #Vetor que é TRUE somente onde o Termo de 
                                             #LISTA-FREQ está na lista sem stopwords
lista_FREQUENCIA <- LISTA_FREQ[seleciona,] 
  
# remove nomes de linhas
row.names(lista_FREQUENCIA)= NULL

# Salvando lista de frequencia completa

# MENSAGEM DE AVISO
#cat("Salvando lista de frequencia completa sem stopwords no diretorio de trabalho com o nome 'lista_FREQUENCIA.csv'\n")

#write.csv(lista_FREQUENCIA,"lista_FREQUENCIA.csv",row.names=FALSE,quote=FALSE)

###############################

#### GERANDO NUVEM DE PALAVRAS

# importando pacote wordcloud

if (!require("wordcloud")) {
	install.packages("wordcloud")
	require("wordcloud")
} else { 
	require("wordcloud")
}

# GERACAO DA LISTA DE PALAVRAS

wordcloud(lista_FREQUENCIA$Termo,
          lista_FREQUENCIA$Frequencia, 
          scale = c(3.5,1),
          min.freq = MIN,
          max.words = MAX_WORDS, 
          random.order = FALSE, 
          rot.per = .10, 
	    colors = COLORS
	    )

# Para adicionar titulo na nuvem de palavras, rodar a linha abaixo
title(TITULO)

# retorna lista de frequencia como resultado
return(lista_FREQUENCIA) # retorna a lista de frequencia

} # FIM DA FUNCAO

################################################


################################################


## LINHAS DE CONCORDANCIA




####################################################################
#
# SCRIPT PARA FAZER LINHAS DE CONCORDANCIA
#
####################################################################

concordancia = function (TEXTO,TERMO) {
# Alem disso, o argumento TERMO deve ser um vetor de caracteres

## validacao

# Para validacao das classes dos argumentos dessa funcao 
# o texto ja deve estar "unlisted" (fora do formato de list)

if (!is.character(TEXTO)) {
	TEXTO = unlist(TEXTO)
}

if (!is.character(TERMO) || length(TERMO) != 1) {
	stop ("TERMO deve ser um vetor de caracteres de comprimento 1.")
}

###############################################################

## Preparando os dados

# Passando as letras para minusculo

TERMO = tolower(TERMO)

TEXTO = tolower(TEXTO)


######################

# Expressao regular que retorna TRUE  ou FALSE se a string for do tipo STRING ESPAÇO STRING (ESPAÇO STRING) 
# o que esta entre parenteses e opcional

# Feita para permitir a busca de termos como "TERMO DE BUSCA", sem precisar entrar termo de busca 
# como "TERMO_DE_BUSCA"

# CRIEI ESSA PARTE DA FUNCAO QUANDO TIVE QUE SUBSTITUIR "a gente" 
# por "a_gente" via gsub para permitir a busca


	## ESSA SUBSTITUICAO USANDO EXPRESSAO REGULAR SO E SUFICIENTE
	## SE FOR FEITA UMA SUBSTITUICAO NO TEXTO TAMBEM, COMO HAVIA SIDO FEITO
	## COM "A_GENTE" NUM EXEMPLO INICIAL.

regexSource = "[A-Za-z]+ [A-Za-z]+( [A-Za-z]+)?"

if( grepl(regexSource ,TERMO) ) {
	temp = TERMO # armazena TERMO com espacos para posterior substituicao
	TERMO = gsub(" ","-",TERMO) # troca espaco por hifen no TERMO
	TEXTO = gsub(temp,TERMO,TEXTO) # troca espaco por hifen do TERMO no TEXTO
	rm(temp) # deleta objeto que nao e mais necessario
}

######################

### NECESSARIO RODAR ANTES A FUNCAO lista_frequencia

# criando Lista de frequencia usando a funcao propria

lista_frequencia = lista_frequencia(TEXTO)

##################

# Funcao para unir itens do vetor de caracteres em apenas um

unificar_vetor = function(VETOR) {

Result = c()

	for (i in length(VETOR):1) {
	
		if (i == length(VETOR)) {
			Result = paste(VETOR[[i]],Result,sep ="")
		} else {
			Result = paste(VETOR[[i]],Result,sep = " ")
		}

	}

return (Result)

} # FIM da funcao

##################


TEXTO_UNIF = unificar_vetor(TEXTO)

# Elimina espacos EXTRAS (troca 2 a 5 espacos por apenas um)
TEXTO_UNIF = gsub(" {2,5}"," ",TEXTO_UNIF,perl=T) 

## Divide os textos por espacos

TEXTO_UNIF_split = strsplit(tolower(TEXTO_UNIF),split=" ")


## Buscando ocorrencias do termo de busca

indices = grep(TERMO,TEXTO_UNIF_split[[1]])
#   numero do indice das ocorrencias da busca

# indices minimo e maximo para resultados
min = indices - 5
max = indices + 5

# dataframe com posicoes dos itens encontrados
posicoes_TERMO = data.frame(min,max)


# MENSAGEM DE ERRO CASO O TERMO DE BUSCA NAO TENHA SIDO ENCONTRADO

if (nrow(posicoes_TERMO) == 0) { # se o numero de ocorrencias encontradas for zero
	
	# criar mensagem de erro
	msg = ("O termo buscado nao foi encontrado.") 
	
	# criar resultado rapido
	resultado_rapido = list(msg,lista_frequencia)	
	
	# retorna resultado
	return(resultado_rapido) # e sair da funcao

} 


#######

###################	Criando e acessando resultado

# criando lista de resultados encontrados

# criando matriz (com NAs) para ser preenchida
concord = matrix(rep("NA",11),nrow=1)


# preenchendo matriz com as linhas de concordancia
for (ind in seq_along(1:nrow(posicoes_TERMO))) {

	# sequencia de posicoes de (termo_busca -5) a (termo_busca + 5)
	seq_posicoes = seq(posicoes_TERMO$min[[ind]],posicoes_TERMO$max[[ind]])
	
	# colando linhas de concordancia uma a uma no dataframe 'concord'
	if (ind < 6) { # cria valor inicial de concord com primeiras 5 ocorrencias
				   # para evitar indices negativos

		# condicional auxiliar para indice "ind"
		condic_ind = seq_posicoes>0

		# vetor com numeros negativos e zero
		negativos_zeros = seq_posicoes[seq_posicoes <= 0]

		if (length(negativos_zeros) > 0) { # se o termo buscado estiver no inicio
								  # completar com NAs
			
		# separando dados nulos (se existentes) e outros (nao_nulos)	
		nulos = as.numeric(rep(NA,length(negativos_zeros)))
		nao_nulos = TEXTO_UNIF_split[[1]][seq_posicoes[condic_ind == TRUE]]

			# gerando novamente o concord para gerar linhas de concordancia
			concord = c(nulos,nao_nulos)
		} else {
		concord = rbind(concord,TEXTO_UNIF_split[[1]][seq_posicoes])
		}
	} else { # se o indice estiver entre 1 e o limite (o ultimo item)
	
		# preenchendo matriz com ocorrencias
		concord = rbind(concord,TEXTO_UNIF_split[[1]][seq_posicoes])
	
	}
	
	
	
	if (ind == nrow(posicoes_TERMO)) { 	# quando ind for igual ao ultimo item 
		
		if (is.vector(concord)) { #se tiver apenas uma linha de resultado
				 # transformar vetor em dataframe

			concord = as.data.frame(matrix(concord,nrow=1))
			
		} else if (nrow(concord) > 1) { # e tiver sido encontrada mais de uma linha
			concord = concord[-1,] # elimina a primeira linha de NAs
		}
		
	}

} # Fim do for

# acerta nomes de linhas do concord

row.names(concord) = NULL

# acerta nomes de colunas do concord

if (is.vector(concord)) { #se tiver apenas uma linha de resultado
				 # transformar vetor em dataframe

	concord = as.data.frame(matrix(concord,nrow=1))


	# acertando nomes de linhas do concord
	colnames(concord) = c("A1","A2","A3","A4","A5","Termo_busca","D1","D2","D3","D4","D5")


} else if (nrow(concord) > 1) {#se tiver mais de uma linha de resultado

	# acertando nomes de linhas do concord
	colnames(concord) = c("A1","A2","A3","A4","A5","Termo_busca","D1","D2","D3","D4","D5")
}

###########

####
## Para ELIMINAR falsos positivos usando uma expressao regular
####

# Foi criada mais acima uma expressao regular a seguir parecida
# para substituir o espaco por hifen
# permitir a busca de termos de busca compostos.
# Esta, porem, localiza itens do tipo "TERMO-TERMO"

regexSource2 = "[A-Za-z]+-[A-Za-z]+(-[A-Za-z]+)?"


# condicional para definir a expressao regular para 
if( !grepl(regexSource2 ,TERMO) ) { # se o termo de busca nao for composto
					     # exemplo "eu" (em vez de "a-gente")

	# busca o TERMO isolado como palavra, 
	# com um a 3 itens depois (como uma pontuacao)
	regex = paste("\\b",TERMO,"\\b(.{1,3})?",sep="")

	# substitui a lista de concordancia anterior pela correta
	concord = concord[grep(regex,concord[,6]),]
}

###########



# organiza resultado

resultado = list(Lista_de_Frequencia = lista_frequencia,Linhas_de_Concordancia = concord)

# retorna resultado
return(resultado)

}

############	FIM DA FUNCAO

#########################################################################

## LISTA DE COLOCADOS

# colocados

####################################################################
#
# SCRIPT PARA FAZER LINHAS DE COLOCADOS
#
####################################################################

colocados = function (TEXTO,TERMO) {
# Alem disso, o argumento TERMO deve ser um vetor de caracteres

## validacao

# Para validacao das classes dos argumentos dessa funcao 
# o texto ja deve estar "unlisted" (fora do formato de list)

if (!is.character(TEXTO)) {
	TEXTO = unlist(TEXTO)
}

if (!is.character(TERMO) || length(TERMO) != 1) {
	stop ("TERMO deve ser um vetor de caracteres de comprimento 1.")
}

###############################################################

## Preparando os dados

# Passando as letras para minusculo

TERMO = tolower(TERMO)

TEXTO = tolower(TEXTO)


######################

# Expressao regular que retorna TRUE  ou FALSE se a string for do tipo STRING ESPAÇO STRING (ESPAÇO STRING) 
# o que esta entre parenteses e opcional

# Feita para permitir a busca de termos como "TERMO DE BUSCA", sem precisar entrar termo de busca 
# como "TERMO_DE_BUSCA"

# CRIEI ESSA FUNCAO TIVE QUE SUBSTITUIR "a gente" 
# por "a_gente" via gsub para permitir a busca

	## ESSA SUBSTITUICAO USANDO EXPRESSAO REGULAR SO E SUFICIENTE
	## SE FOR FEITA UMA SUBSTITUICAO NO TEXTO TAMBEM, COMO HAVIA SIDO FEITO
	## COM "A_GENTE" NUM EXEMPLO INICIAL.


regexSource = "[A-Za-z]+ [A-Za-z]+( [A-Za-z]+)?"

# condicional para definir a expressao regular para 
if( !grepl(regexSource ,TERMO) ) { # se o termo de busca nao for composto
	temp = TERMO # armazena TERMO com espacos para posterior substituicao
	TERMO = gsub(" ","-",TERMO) # troca espaco por hifen no TERMO
	TEXTO = gsub(temp,TERMO,TEXTO) # troca espaco por hifen do TERMO no TEXTO
	rm(temp) # deleta objeto que nao e mais necessario
}

######################

### NECESSARIO RODAR ANTES A FUNCAO lista_frequencia,
### logo a funcao dara um erro se ela nao tiver sido carregada

# criando Lista de frequencia usando a funcao propria

lista_frequencia = lista_frequencia(TEXTO)

######################

# Dividindo o texto por espacos

y = strsplit(TEXTO," ")


##################

# Funcao para unir itens do vetor de caracteres em apenas um

unificar_vetor = function(VETOR) {

Result = c()

	for (i in length(VETOR):1) {
	
		if (i == length(VETOR)) {
			Result = paste(VETOR[[i]],Result,sep ="")
		} else {
			Result = paste(VETOR[[i]],Result,sep = " ")
		}

	}

return (Result)

} # FIM da funcao

##################


TEXTO_UNIF = unificar_vetor(TEXTO)

# Elimina espacos EXTRAS (troca 2 a 5 espacos por apenas um)
TEXTO_UNIF = gsub(" {2,5}"," ",TEXTO_UNIF,perl=T) 

## Divide os textos por espacos

TEXTO_UNIF_split = strsplit(tolower(TEXTO_UNIF),split=" ")


## Buscando ocorrencias do termo de busca

indices = grep(TERMO,TEXTO_UNIF_split[[1]])
#   numeros do indice das ocorrencias da busca

# indices minimo e maximo para resultados
min = indices - 5
max = indices + 5

# dataframe com posicoes dos itens encontrados
posicoes_TERMO = data.frame(min,max)



# MENSAGEM DE ERRO CASO O TERMO DE BUSCA NAO TENHA SIDO ENCONTRADO

if (nrow(posicoes_TERMO) == 0) { # se o numero de ocorrencias encontradas for zero
	
	# criar mensagem de erro
	msg = ("O termo buscado nao foi encontrado.") 
	
	# criar resultado rapido
	resultado_rapido = list(msg,lista_frequencia)	
	
	# retorna resultado
	return(resultado_rapido) # e sair da funcao

} 


#######

###################	Criando e acessando resultado

# criando lista de resultados encontrados

# criando matriz (com NAs) para ser preenchida
concord = matrix(rep("NA",11),nrow=1)


# preenchendo matriz com as linhas de concordancia
for (ind in seq_along(1:nrow(posicoes_TERMO))) {

	# sequencia de posicoes de (termo_busca -5) a (termo_busca + 5)
	seq_posicoes = seq(posicoes_TERMO$min[[ind]],posicoes_TERMO$max[[ind]])
	
	# colando linhas de concordancia uma a uma no dataframe 'concord'
	if (ind < 6) { # cria valor inicial de concord com primeiras 5 ocorrencias
				   # para evitar indices negativos

		# condicional auxiliar para indice "ind"
		condic_ind = seq_posicoes>0

		# vetor com numeros negativos e zero
		negativos_zeros = seq_posicoes[seq_posicoes <= 0]

		if (length(negativos_zeros) > 0) { # se o termo buscado estiver no inicio
								  # completar com NAs
			
		# separando dados nulos (se existentes) e outros (nao_nulos)	
		nulos = as.numeric(rep(NA,length(negativos_zeros)))
		nao_nulos = TEXTO_UNIF_split[[1]][seq_posicoes[condic_ind == TRUE]]

			# gerando novamente o concord para gerar linhas de concordancia
			concord = c(nulos,nao_nulos)
		} else {
		concord = rbind(concord,TEXTO_UNIF_split[[1]][seq_posicoes])
		}
	} else { # se o indice estiver entre 1 e o limite (o ultimo item)
	
		# preenchendo matriz com ocorrencias
		concord = rbind(concord,TEXTO_UNIF_split[[1]][seq_posicoes])
	
	}
	
	
	
	if (ind == nrow(posicoes_TERMO)) { 	# quando ind for igual ao ultimo item 
		
		if (is.vector(concord)) { #se tiver apenas uma linha de resultado
				 # transformar vetor em dataframe

			concord = as.data.frame(matrix(concord,nrow=1))
			
		} else if (nrow(concord) > 1) { # e tiver sido encontrada mais de uma linha
			concord = concord[-1,] # elimina a primeira linha de NAs
		}
		
	}

} # Fim do for

# acerta nomes de linhas do concord

row.names(concord) = NULL

# acerta nomes de colunas do concord

colnames(concord) = c("A1","A2","A3","A4","A5","Termo_busca","D1","D2","D3","D4","D5")


###########

####
## Para ELIMINAR falsos positivos usando uma expressao regular
####

# Esta expressao regular a seguir ja foi criada anteriormente
# para substituir o espaco por hifen
# permitir a busca de termos de busca compostos,
# logo, esta apenas comentada aqui

regexSource2 = "[A-Za-z]+-[A-Za-z]+(-[A-Za-z]+)?"

# condicional para definir a expressao regular para 
if( !grepl(regexSource2 ,TERMO) ) { # se o termo de busca nao for composto
					     # exemplo "eu" (em vez de "a-gente")

	# busca o TERMO isolado como palavra, 
	# com um a 3 itens depois (como uma pontuacao)
	regex = paste("\\b",TERMO,"\\b(.{1,3})?",sep="")

	# substitui a lista de concordancia anterior pela correta
	concord = concord[grep(regex,concord[,6]),]
}

###########

###########


# organiza resultado da concordancia (NAO O DOS COLOCADOS)

resultado_concord = list(Lista_de_Frequencia = lista_frequencia,Linhas_de_Concordancia = concord)


# separa a lista de frequencia a partir do resultado anterior
lista_frequencia = resultado_concord[[1]]


# pega a lista de concordancia a partir do resultado anterior
concord = resultado_concord[[2]]

## Colocados

# separando colunas a esquerda
coloc_esq = concord[,1:5]

# separando colunas a direita
coloc_dir = concord[,7:11]

######################################

##### USAR LIMPEZA DO TM nos colocados

# importando e carregando pacote tm
if (!require("tm")) {
	install.packages("tm")
	require("tm")
} else {
		require("tm")
}

## limpeza a direita

# remove pontuacao via tm
coloc_dir = removePunctuation(coloc_dir,preserve_intra_word_dashes = TRUE)

# remove numeros via tm
coloc_dir = removeNumbers(coloc_dir)

## limpeza a esquerda


# remove pontuacao via tm
coloc_esq = removePunctuation(coloc_esq,preserve_intra_word_dashes = TRUE)

# remove numeros via tm
coloc_esq = removeNumbers(coloc_esq)

######################################

# contagens a esquerda
freq_coloc_esq = data.frame(table(coloc_esq))
#freq_coloc_esq

# acertando nomes das colunas
colnames(freq_coloc_esq) = c("Termo","Frequencia")

# ordenando em ordem decrescente de frequencia
freq_coloc_esq = freq_coloc_esq[order(freq_coloc_esq$Frequencia,decreasing=TRUE),]


#######

# contagens a direita
freq_coloc_dir  = data.frame(table(coloc_dir))
#freq_coloc_dir

# acertando nomes das colunas
colnames(freq_coloc_dir) = c("Termo","Frequencia")

# ordenando em ordem decrescente de frequencia
freq_coloc_dir = freq_coloc_dir[order(freq_coloc_dir$Frequencia,decreasing=TRUE),]

	 
##################    RESULTADO

# Resultado completo
Resultado = list( lista_frequencia = lista_frequencia, # retorna lista de frequencia, alem dos colocados a direita e a esquerda
			Colocados_direita_freq = freq_coloc_dir,   # alem dos colocados a direita
			Colocados_esquerda_freq = freq_coloc_esq)  # e a esquerda             
 
return(Resultado)

} # FIM DA FUNCAO

####################################################################

####################################################################
#
# SCRIPT PARA FAZER DENDROGRAMA DE TEXTOS
#
####################################################################

# FUNCAO PARA FAZER DENDROGRAMA DE TEXTOS

dendograma = function  (MATRIZ,
			      N_GRUPOS = 2, # Numero de grupos
		       	DISTANCIA = c("euclidean","maximum","manhattan","canberra","binary","minkowski"),
				METODO = "ward.D",       # Metodo Ward
				TITULO = "Dendograma",   
				LEGENDA = "Nivel") {

# TESTES PARA ARGUMENTOS

if (!is.matrix(MATRIZ)) {
   stop("MATRIZ deve ser uma matriz")
}

if (!is.character(DISTANCIA[1])) {
   stop("DISTANCIA deve ser um vetor de caracteres")
}

###########

condicao = ((DISTANCIA[1] != "euclidean") || (DISTANCIA[1] != "maximum") || 
            (DISTANCIA[1] != "manhattan") || (DISTANCIA[1] != "canberra") || 
            (DISTANCIA[1] != "binary") || (DISTANCIA[1] != "minkowski"))

if (condicao != TRUE) {
   stop('DISTANCIA deve ser uma das seguintes opcoes: "euclidean", "maximum", "manhattan", "canberra", "binary" ou "minkowski"')
}

###########

if (!is.character(METODO) || length(METODO) != 1) {
   stop("METODO deve ser um vetor de caracteres de comprimento 1")
}

if (!is.character(LEGENDA) || length(LEGENDA) != 1) {
   stop("LEGENDA deve ser um vetor de caracteres de comprimento 1")
}

# se o numero de grupos for decimal, pegar apenas a parte inteira
N_GRUPOS = floor(N_GRUPOS) 

if (!is.numeric(N_GRUPOS) || N_GRUPOS < 2 || length(N_GRUPOS) != 1) {
	stop("N_GRUPOS deve ser um numero maior ou igual a 2 em um vetor numerico de comprimento 1)")
}

# FUNCAO PARA FORMATAR CORES DO DENDOGRAMA

# funcao adaptada a partir da disponivel on-line no site:
#https://github.com/SachaEpskamp/qgraph/blob/master/R/addTrans.R

addTrans <- function(color,trans)	{
  # Esta funcao adiciona transparencia de uma cor.
  # A transparencia e definida por um inteiro de 0 a 255.
  # 0 se refere a transparencia total e 255 a totalmente opaco	
  # Funciona com qualquer cor e com um vetor de igual comprimento,
  # ou de comprimento 1.

  if (length(color)!=length(trans)&!any(c(length(color),length(trans))==1)) stop("Vector lengths not correct")
  if (length(color)==1 & length(trans)>1) color <- rep(color,length(trans))
  if (length(trans)==1 & length(color)>1) trans <- rep(trans,length(color))

  num2hex = function(x)
  {
    hex = unlist(strsplit("0123456789ABCDEF",split=""))
    return(paste(hex[(x-x%%16)/16+1],hex[x%%16+1],sep=""))
  }
  rgb = rbind(col2rgb(color),trans)
  res = paste("#",apply(apply(rgb,2,num2hex),2,paste,collapse=""),sep="")
  return(res)
}

############################################################


## Biblioteca:

# Importando pacote stats

if (!require("stats")) {
	install.packages("stats") 
	require("stats")
} else {
	require("stats")
}

##Padronizando os dados para a analise multivariada

standdados = scale (MATRIZ, center=TRUE,scale=TRUE)

## Eliminando variaveis sem informacao(desvio-padrão=0)
standdados = data.matrix(t(na.exclude(t(standdados))))

## Obter matriz de distancia (default = Euclidiana)
distancia = dist(standdados, method = DISTANCIA[1],  
				diag = TRUE, upper = TRUE)

# Mudando a configuracao do console para apresentar 1 grafico,
par(mfrow = c(1, 1))

################### 

	#Distancia (default = Euclidiana)
	ajuste = hclust(distancia, method=METODO) # METODO

	#Avaliacao Nivel de Fusao
	#if (NIVEL_FUSAO == "TRUE")
		#plot(ajuste$height,xlab="Passo",ylab="Distancia" ,pch=4)

	# Plotar o dendograma com o titulo especificado
	plot(ajuste, main = TITULO)

	# Acrescentar a legenda # LEGENDA
	legend("topright", legend=c(LEGENDA,round(ajuste$height,4)),bty="n",text.col=addTrans("red",100))

	#### SEPARANDO GRUPOS POR NUMERO DE CLUSTERS
	# Fonte: http://www.instantr.com/2013/02/12/performing-a-cluster-analysis-in-r/


	# Criando linhas vermelhas separando os grupos
	rect.hclust(ajuste, N_GRUPOS)     
		
	# Obtendo informacao dos grupos
	grupos = cutree(ajuste, N_GRUPOS)

	# APRESENTANDO TABELA COM GRUPOS DE CADA TEXTO

	cat ("Tabela com a localizacao de cada elemento nos grupos\n",grupos,"\n")


} # FIM DA FUNCAO

#########################################################################
