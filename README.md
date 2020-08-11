# README

O objetivo desse projeto é atender ao [desafio](CHALLENGE.md) proposto pela Nexaas.

## Instalação

### Docker

Com o docker e o docker-compose instalados.

```bash
docker-compose build
docker-compose up
docker-compose run web bundle exec rails db:create
docker-compose run web bundle exec rails db:migrate
```

### Local

Com o ruby:2.7.1, a gem bundler e o postgresql instalados.

```bash
bundle install
bundle exec rails db:create
bundle exec rails db:migrate
```

### Heroku

A aplicação estarodando no heroku no endereço <https://nexxas.herokuapp.com/api-docs/index.html>.

Ps: Desculpa pelo Nexxas so vi depois esse typo =(

## Uso

### Swagger

Eu usei a gem Rswag para documentar e fazer testes de integração na aplicação.

Acessando {host}/api-docs entra na pagina da documentação que alem das descrições e possibilidades da api, tem a opção de enviar as chamadas definindo parametros clicando em "Try out".

### Testes

Foi usado o Rspec para os testes

```bash
bundle exec rspec
```

Caso esteja usando o Docker

```bash
docker-compose run web bundle exec rspec
```

## Considerações

### Sobre o pontos avaliados

1. Solução adotada, principalmente a questão de adicionar e retirar itens do estoque (imagine um cenário de concorrência)

- Imaginando um cenario de concorrencia ao ponto de alguma regra ser invalidada no dominio (por exemplo duas chamadas removerem um item e ele ficar negativo) criei alem das regras no dominio constraints no banco de dados, para garantir o estado dos dados.

2. Cobertura de testes e a qualidade dos testes (utilize o RSpec)

- Decidi por fazer testes de integração, model e serializers usando factory bot.

3. Qualidade de código

- Tentei usar as convenções do Rails na maior parte do codigo para ser de facil acesso para outros desenvolvedores que ja tenham usado rails.

4. Conceitos avançados de orientação a objetos (nada de fat model ou controllers com regras de negócio, por favor)

- A logica da aplicação era bem simples e se enquadrava muito bem na proposta do framework, por tanto, fiz uso na maior parte das convenções ja propostas. Criei a estrutura de serializers como PORO para poder demonstrar como seria possivel abordar outras formas de arquitetura dentro do framework.

5. Estrutura do banco de dados (índices, chave estrangeiras, chaves únicas… use um banco relacional e todo seu poder)

- Criei constraints e indices na tabela stock_items alem dos que ja são criados pelo framework

6. Verbos e status code dos endpoints (utilize os padrões HTTP)

- Busquei usar os verbos e status code que mais se adequavam

7. Como os erros são tratados

- Usei bastante dos erros ja presentes no framework e criei alguns handlers para erros especificos.

### Melhorias

- Melhorar as descrições e repostas na documentação
- Usar o especificação JsonApi
