# Cartografia usando a linha de comando

O processo de fazer um mapa normalmente envolve váários passos de pré-processamento para preparar os dados. Esse exercício serve para que você entenda esses passos e conheça ferramenta para eles, sem programar em javascript ainda. Gerando tudo usando ferramentas na linha de comando. 

Esse tutorial é todo baseado [nesse tutorial de Mike Bostocks](https://medium.com/@mbostock/command-line-cartography-part-1-897aa8f8ca2c) e [nessa adaptação de Carlos Lemos](https://github.com/carloslemos/tutorial-terminal-d3js-ibge).

## O objetivo

Faremos um mapa chroropleth usando uma escala de cores em entidades geográficas para representar uma variável numérica. 

## A matéria prima

Para um mapa desse tipo, precisamos de: 
  * Uma variável (numérica, categórica, etc)
  * Uma entidade geográfica (uma geometria)
  * Uma fonte para os dados (de onde virão as variáveis)
  
Um exemplo de combinação desses três inputs é *número de habitantes* por *bairro de campina grande* segundo o *censo do IBGE de 2010*. Para nosso exercício, você escolherá uma variável numérica para que a mostremos nos setores censitários da PB (ou de outro estado) segundo o censo do IBGE de 2010.

No Brasil, duas fontes comuns de dados socioeconômicos são [o censo e a PNAD](https://analiticaterritorial.wordpress.com/2016/04/19/ibge-entenda-a-diferenca-entre-censo-demografico-e-pnad/), ambos feitos pelo IBGE.

A fonte primária de **geometrias** geralmente [é o IBGE](https://mapas.ibge.gov.br/bases-e-referenciais/bases-cartograficas/malhas-digitais.html).

O formato mais comum para geometrias é Shapefile, (.shp), um arquivo binário otimizado para ser usado em softwares como ArcGIS e QGIS. Mas como queremos manipular esse arquivo, vamos no mundo d3 sempre transformá-lo para algo mais json-like e manipulá-lo nesse novo formato. Nesse exercício você mexerá com GeoJSON, ndjson e topojson.

## Passo 1: Obter a geometria em shapefile

Baixe o shapefile de um estado no IBGE e descompacte ele. (Para conferir, o arquivo final se chama 25SEE250GC_SIR.shp)

(Solução: )

curl \
  'ftp://geoftp.ibge.gov.br/organizacao_do_territorio/malhas_territoriais/malhas_de_setores_censitarios__divisoes_intramunicipais/censo_2010/setores_censitarios_shp/pb/pb_setores_censitarios.zip' \
  -o pb_setores_censitarios.zip
