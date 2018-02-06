# Cartografia usando a linha de comando

O processo de fazer um mapa normalmente envolve váários passos de pré-processamento para preparar os dados. Esse exercício serve para que você entenda esses passos e conheça ferramenta para eles, sem programar em javascript ainda. Gerando tudo usando ferramentas na linha de comando.

Esse tutorial é todo baseado [nesse tutorial de Mike Bostocks](https://medium.com/@mbostock/command-line-cartography-part-1-897aa8f8ca2c) e [nessa adaptação de Carlos Lemos](https://github.com/carloslemos/tutorial-terminal-d3js-ibge).

Uma diferença importante é que não colocamos os comandos já prontos aí embaixo. Então sugerimos que você vá criando um arquivo `resposta.sh` com seus comandos já completos.

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

Crie uma pasta para trabalharmos. Use vá logo usando o terminal para se acostumar. `mkdir mapa-ninja` e `cd mapa-ninja`. Na medida que você for descobrindo os comandos que resolvem as partes abaixo do exercício, vá salvando eles em um arquivo .txt ou .sh.

Baixe o shapefile de um estado no IBGE e descompacte ele. Caso seja o da PB, o arquivo final se chama 25SEE250GC_SIR.shp. Caso esteja difícil achar o link, [procura aqui](ftp://geoftp.ibge.gov.br/organizacao_do_territorio/malhas_territoriais/malhas_de_setores_censitarios__divisoes_intramunicipais/censo_2010/setores_censitarios_shp/). Bônus: use o curl para baixar na linha de comando.

Esse shp contém o desenho dos setores censitários na PB (ou outro estado). Para visualizá-lo, você pode usar uma página chamada [mapshaper](http://mapshaper.org).

## Passo 2: SHP -> GeoJSON

Para criar um arquivo mais fácil de manipular a partir do binário do shp, usaremos um módulo do node chamado shapefile.

```
npm install -g shapefile
```

A conversão é com a ferramenta **shp2json**:

```
shp2json <arquivo-entrada> -o <arquivo-saída, ex: pb.json>
```

Como o json não é binário, não é compactado. Compare os tamanhos dos arquivos de entrada e saída nesse passo. Mas como é json, você pode olhar dentro! (Faça `less pb.json`; para sair, **q**).

Lembrando, esse GeoJSON contém os mesmos dados do shapefile.

## Passo 3: GeoJSON -> GeoJSON projetado

Agora, uma coisa que é importante lembrar: **a Terra não é plana**. Por que isso é importante? Porque os mapas são. Para adaptar a superfício de um globo (na verdade um geóide) em um plano é preciso distorcê-la. Assista [esse vídeo aqui](https://www.vox.com/world/2016/12/2/13817712/map-projection-mercator-globe) para entender (tem legendas em pt-br). Para ver uma lista das projeções disponíveis em d3, vá [na página do módulo](https://github.com/d3/d3-geo-projection).

Importante para nós é que (i) o arquivo que temos até agora não está projetado (ou seja, é de coordenadas em um globo) e (ii) fazer a projeção na hora da visualização é custoso, porque envolve um monte de trigonometria. Fica lento em celulares, principalmente.

Por isso, deixaremos o nosso json já projetado, usando um outro módulo node:

```
npm install -g d3-geo-projection

geoproject \
  'd3.geoOrthographic().rotate([54, 14, -2]).fitSize([1000, 600], d)' \
  < [json-entrada]
  > pb-ortho.json
```

Se você não estiver acostumado com o **<** e **>**, o primeiro diz que o conteúdo do arquivo deve ser passado para o programa à esquerda, e o segundo, que a saída do programa (que iria para o terminal) deve ser direcionada para um arquivo com o nome à direita.

Repare que nesse ponto decidimos que a geometria deverá caber em 1000 por 600 pixels.
Para visualizar a projeção, podemso convertê-la para um SVG:

```
geo2svg \
  -w 1000 \
  -h 600 \
  < pb-ortho.json \
  > pb-ortho.svg
```

E abrí-la num browser.

## Passo 4: GeoJSON -> NDJSON

Agora vamos começar a manipular as entidades geográficas que estão no nosso json. O legal de fazer isso na linha de comando é que tem muitas ferramentas para juntar arquivos linha-a-linha, filtrar linhas e coisas do tipo. Só que para que json funcione dessa forma, precisamos que as entidades dentro dele estejam em linhas diferentes. Num json normal isso não acontece, mas acontece em um NDJSON (newline-delimited json). Por isso, usaremos NDJSON:

```
ndjson-split 'd.features' \
  < [geojson-entrada] \
  > [arquivo-saida.ndjson]
```

Mude os nomes acima, claro.

Se você comparar o arquivo de entrada e saída, verá que o 1o é um objeto com uma lista de objetos chamada `features`. Cada feature é um setor censitário. No segundo, temos uma feature/setor por linha. Cada setor tem um json (um dicionário) de propriedades chamada `properties`.

## Passo 5: NDJSON -> NDJSON + dados

Nosso objetivo aqui é colocar em cada linha/objeto do ndjson a variável que nos interessa. A variável virá dos dados censitários da PB. Eles estão [no site do IBGE]( ftp://ftp.ibge.gov.br/Censos/Censo_Demografico_2010/Resultados_do_Universo/Agregados_por_Setores_Censitarios/).

Quando você baixar e descompactar, terá um diretório cheio de CSVs com os dados do censo. Para que possamos uní-los ao ndjson da geometria, precisamos (i) transformar o CSV com os dados que queremos para ndjson e (ii) que ambos tenham uma chave em comum por objeto/linha.

Para fazer a primeira parte, você precisa primeiro escolher que variável quer mostrar a partir dos dados que baixamos. Tem uma explicação das variáveis na página 33 e da 43 em diante [desse arquivo](./base-informacoes-censo-universo.pdf). usaremos mais uma ferramenta linha de comando do d3:

```
npm install -g d3-dsv
```

E aí:

```
dsv2json \
  -r ';' \
  -n \
  < [csv-dos-dados] \
  > pb-censo.ndjson
```

Dê uma olhada no arquivo de saída. Se o encoding estiver bagunçado, experimente adicionar `--input-encoding latin1` depois de `dsv2json`.

Além disso, se você abrir o arquivo resultado, verá que cada objeto nele tem uma propriedade `Cod_setor`. Por exemplo, `"Cod_setor":"250010605000001"`. Se você olhar o arquivo ndjson com nossa geometria, verá que cada objeto `d` lá tem um código parecido na propriedade `d.properties.CD_GEOCODI`. Para facilitar a junção dos dados do censo com as geometrias, precisamos fazer com que as geometrias tenham também o `Cod_setor` no objeto (e não dentro do dicionário). Para transformar um ndjson usaremos `ndjson-map`:

```
ndjson-map 'd.Cod_setor = d.properties.CD_GEOCODI, d' \
  < [entrada] \
  > [um nome tipo saida-ortho-sector.ndjson]
```

A expressão `d.Cod_setor = d.properties.CD_GEOCODI, d` diz que cada objeto `d` será substituído pelo resultado dessas duas expressões, que alteram e retornam `d` alterado.

Agora podemos juntar as partes:

```
ndjson-join 'd.Cod_setor' \
  [ndjson geometrias] \
  [ndjson censo] \
  > [ndjson resultado do join]
```

Examine o formato da saída. Cada linha agora é um array de 2 objetos: o do primeiro e o do segundo arquivos, unidos pelo `Cod_setor`.

Para organizar o arquivo, vamos deixar apenas um objeto por linha, e com as variáveis que queremos apenas. Por exemplo, se tivermos usado o csv `Basico_PB.csv` e quisermos mostrar o valor do rendimento nominal médio dos responsáveis em cada domicílio (variável V005 nos dados):

```
ndjson-map \
  'd[0].properties = {renda: Number(d[1].V005.replace(",", "."))}, d[0]' \
  < [ndjson-depois-do-join]] \
  > pb-ortho-comdado.ndjson
```

Repare como alteramos `d[0]` e depois ficamos só com esse elemento. Repare também que é preciso transformar a string em número e que *como em pt-br o decimal é vírgula, precisamos cuidar disso*.

## Passo 6: NDJSON -> TopoJSON

O NDJSON que temos está com tudo que precisamos, mas ainda tem uns 9MB. Muito.

Uma representação mais compacta para o mesmo dado é o TopoJSON. Vamos converter nosso arquivo para topojson:

```
npm install -g topojson

geo2topo -n \
  tracts=pb-ortho-comdado.ndjson \
  > pb-tracts-topo.json
```

Já deu uma reduzida no tamanho do arquivo.

Para reduzir ainda mais, vamos simplificar e quantizar a geometria do topojson:

```
toposimplify -p 1 -f \
  < pb-tracts-topo.json \
  | topoquantize 1e5 \
  > pb-quantized-topo.json
```

Agora diminuiu bastante :) Você pode vê-lo lá no http://mapshaper.org/ também.

## Passo 7: TopoJSON -> Mapa!

Agora vamos gerar a visualização de fato no mapa. Instale o módulo d3 e uma escala cromática.

```
npm install -g d3
npm install -g d3-scale-chromatic
```

E essa cadeia de comandos gera o gráfico em svg de fato:

```
topo2geo tracts=- \
  < pb-quantized-topo.json \
  | ndjson-map -r d3 \
  'z = d3.scaleSequential(d3.interpolateViridis).domain([0, 1e3]), d.features.forEach(f => f.properties.fill = z(f.properties.renda)), d' \
  | ndjson-split 'd.features' \
  | geo2svg -n --stroke none -w 1000 -h 600 \
  > pb-tracts-threshold-light.svg
```

Repare no trecho onde definimos uma escala de cores e usamos para definir o valor do fill de cada entidade geográfica. Configure o `domain` da escala de acordo com a variável que você está mostrando.
