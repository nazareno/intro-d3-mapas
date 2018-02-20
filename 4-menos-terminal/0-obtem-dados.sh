#!/bin/bash

# Cria um geojson simplificado e quantizado dos municípios da PB + dados do QEDU

# OBTER E TRANSFORMAR OS DADOS ======================
# Baixa e descompacta
# curl 'ftp://geoftp.ibge.gov.br/organizacao_do_territorio/malhas_territoriais/malhas_municipais/municipio_2016/UFs/PB/pb_municipios.zip' -o pb_municipios.zip
unzip pb_municipios.zip

# Cria geometria projetada
shp2json 25MUE250GC_SIR.shp --encoding 'utf8' \
  | geoproject \
    'd3.geoOrthographic().rotate([54, 14, -2]).fitSize([1000, 600], d)' \
    > geo1-pb_municipios_projetado.json

# Dados de aprendizagem do QEDU
dsv2json \
  -r ',' \
  -n \
  < aprendizado-segundo-qedu.csv \
  > dado1-aprendizado-na-pb.ndjson

# JOIN Geometria, Dado ======================
# organiza geometria
ndjson-split 'd.features' \
  < geo1-pb_municipios_projetado.json \
  | ndjson-map 'd.cidade = d.properties.NM_MUNICIP, d' \
  > geo2-pb_municipios.ndjson

# organiza variável
ndjson-map 'd.cidade = d.Cidade.toUpperCase(), d' \
  < dado1-aprendizado-na-pb.ndjson \
  > dado2-aprendizado-na-pb-comchave.ndjson

# o join
# 1. left join (como em SQL)
# 2. o resultado do join é um array com 2 objetos por linha
# 3. o ndjson-map volta a um objeto por linha
EXP_PROPRIEDADE='d[0].properties = Object.assign({}, d[0].properties, d[1]), d[0]'
ndjson-join --left 'd.cidade' \
  geo2-pb_municipios.ndjson \
  dado2-aprendizado-na-pb-comchave.ndjson \
  | ndjson-map \
    "$EXP_PROPRIEDADE" \
  > geo3-municipios-e-aprendizado.ndjson

# SIMPLIFICA E QUANTIZA ======================
geo2topo -n \
  tracts=- \
< geo3-municipios-e-aprendizado.ndjson \
| toposimplify -p 1 -f \
| topoquantize 1e5 \
| topo2geo tracts=- \
> geo4-municipios-e-aprendizado-simplificado.json
