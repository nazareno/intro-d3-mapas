# A escala e as cores

Apesar das vitórias até agora, ainda restam duas coisas importantes relacionados à principal escala em nosso mapa: pensar melhor o uso da cor e colocar uma legenda explicando a cor no mapa.

## Escolhendo mais as cores

Dois riscos e uma dica:

**Estamos vendo as diferenças?** Dependendo dos valores da variável que você está plotando (ou seja, do domínio da escala), você pode ficar sem ver a variação que existe. O sintoma é um mapa todo da mesma cor. A solução é ou ajustar os limites do domínio ou olhar também escalas de log.

**Seu mapa é (sem querer) um mapa de população?** Se você plotar número de mulheres total por km2, número de doentes, número de carros, número de casas, etc., no fundo seu mapa mostrará o mesmo que um mapa de pessoas por km2. A distribuição da população no espaço é muito desigual, e muito correlacionada com todos esses outros exemplos. Nesses casos, você provavelmente quer normalizar por os valores por habitante/km2 também.

**Dica: escalas com limiar** No nosso primeiro exemplo, utilizamos uma escala com infinitos valores entre o mínimo e o máximo de nosso domínio. Uma escala contínua. Embora isso seja muito preciso, depois fica difícil comparar regiões, e ficará difícil reconhecer na legenda qual o valor de uma região. Para contornar isso, uma solução é usar uma escala que tem apenas X valores entre o máximo e o mínimo. D3 tem um mundo de escalas de cores para você explorar nesse sentido. Veja [a documentação](https://github.com/d3/d3-scale-chromatic), inclusive a parte que explica os esquemas de cores discretos.

Tem uma ajuda mostrando com usar diferentes escalas também [nesse notebook javascript interativo](https://beta.observablehq.com/@nazareno/escalas-de-cores-com-limiar-em-d3-v4). Lá clica no * ou nos nomes de cada pedaço do notebook para ver o código dele. 

## Fazendo a legenda

Depois de escolher bem a escala, o próximo passo é criar uma legenda que explique ela para o leitor. Por enquanto faremos isso em um arquivo separado, usando javascript para criar um SVG no navegador mesmo, e colaremos o SVG depois junto do nosso mapa.

Mais precisamente:
  * use um servidor web para ver o arquivo `3-faca-sua-legenda.html` e edite ele para refletir a sua legenda.
  * copie o elemento svg do html no navegador, quando você estiver satisfeito
  * edite o SVG que tem seu mapa e adicione o conteúdo do elemento svg que você copiou (não precisa da tag svg) dentro do SVG que tem seu mapa. Você provavelmente terá que ajustar também o `translate` do grupo.

Pronto, você agora pode colocar tudo dentro de um html. Tem um exemplo de como fazer isso nesse repo em `uma-pb/exemplo-mapa.html`.
