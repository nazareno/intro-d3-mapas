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
./node_modules/.bin/xpto algum-argumento
```

Por exemplo:

```
npm install shapefile
./node_modules/.bin/shp2json < arquivo.shp > saida.json
```

Outra forma de resolver isso é fazer o seguinte no terminal:

```
export PATH=$PATH:./node_modules/.bin
```
