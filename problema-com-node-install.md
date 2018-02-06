## npm install -g não deu certo?

Se você não tem permissão para instalar um dos módulos node necessários, faça o seguinte:

Se a instalação era:

```
npm install -g modulo_xpto
```

Faça:

```
npm install modulo_xpto
```

Isso instalará o módulo no diretório node_modules/. Para chamar um programa que seria `xpto`, você deverá substituir a linha:

```
xpto algum-argumento
```

Por

```
./node_modules/modulo_xpto/bin/xpto algum-argumento
```

Por exemplo:

```
npm install shapefile
./node_modules/shapefile/bin/shp2json < arquivo.shp > saida.json
```
