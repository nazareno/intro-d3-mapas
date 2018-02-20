# Mapas nem tão no terminal assim

Nessa parte do material, nossa intenção é começar a programar mais do mapa em javascript e menos no terminal. Isso para que possamos cuidar da parte de interação mais facilmente.

Para fazer esse processo, vamos gerar mais um mapa da PB via linha de comando, e depois gerar o mesmo mapa com uma parte programada em js como fazíamos fora de dados geográficos.

## Entendendo o mapa

O mapa que queremos gerar é um de quão bem está o aprendizado dos alunos de escolas públicas na PB de acordo com a Prova Brasil. Os dados vem do QEDU e estão explicados aqui: http://www.qedu.org.br/brasil/aprendizado. Esses dados, para alunos do 5o ano em Português estão em `aprendizado-segundo-qedu.csv`. Dê uma olhada lá.

Considerando esses dados e os shapefiles em `pb_municipios.zip`, temos dois scripts para gerar o choropleth com a % de alunos com aprendizado adequado:

*`0-obtem-dados.sh`* Baixa dados do IBGE, cruza eles com os dados do QEDU e produz um GeoJSON com as propriedades de cada feature incluindo os dados do QEDU.
*`1-cria-mapa.sh`* Usa ferramentas de linha de comando para gerar um choropleth.

Para termos certeza que você entendeu o processo, faça o seguinte:

1. Altere o gráfico para mostrar o Crescimento entre 2011 e 2013 em pontos percentuais do município no IDEB. É a última coluna do csv.
2. Altere o gráfico para usar uma escala divergente em vez de ordenada: os valroes zero devem ter uma cor neutra, os positivos um tom e os negativos outro tom. Por exemplo, [essa escala](https://github.com/d3/d3-scale-chromatic#schemeBrBG) é divergente.

## Programando a interação com mais js que bash

Para essa parte, faremos um processo em duas partes.

`2-mapa-do-aprendizado-js.html` mostra uma visualização em mapa sendo construída a partir do mesmo json que usamos como entrada no script `1-cria-mapa.sh`. Altere esse html para usar sua nova escala e variável. Repare no uso de `d3.geoPath()`. No caso, não precisamos fazer nenhuma projeção aqui porque ela já foi feita na linha de comando.

Agora que estamos confortáveis de volta no browser, vamos à interação. Em `3-mapa-interativo-1.html` nós mostramos como incluir tooltips e zoom + pan (aka arrastar) para navegar no mapa. Caso você queira entender exatamente o que está acontecendo no zoom pode ajudar ler [aqui](http://www.puzzlr.org/zoom-in-d3v4-minimal-example/) e [aqui](https://bl.ocks.org/puzzler10/91a6b53d4237c97752d0e466443dad0b).

Altere `3-mapa-interativo-1.html` também para que ele mostre sua variável e escala.

### Sua vez

Agora já craque no funcionamento de d3 para mapas, você fará o processo completo de escolher dados, cruzá-los com uma geometria e criar um mmapa interativo legal. Do Brasil todo. Por município.

Para os dados, sugiro que você use dados de educação do [Observatório do Plano Nacional de Educação](http://www.observatoriodopne.org.br/downloads).

Abrindo os arquivos Excel disponíveis lá, você vai perceber que embora os dados estejam lá, o formato é meio ingrato. O que funcionou bem para mim foi abrir o xls, copiar o trecho que tem o nome das variáveis e as linhas referentes aos municípios, colar isso em uma nova planilha e salvar como csv. No Mac, o csv gerado pelo Excel nunca fica com um encoding que eu consiga manipular na linha de comando, então faço essa última parte no google spreadsheets (dá para copiar do excel e colar lá).

*Importante*: cuidado com as vírgulas que estão sendo usadas para casas decimais. Você precisa ou removê-las todas aqui ou em algum ponto no javascript. JS espera pontos, e não vírgulas. 
