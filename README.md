# Flight Company
Projeto para praticar e aprimorar alguns conceitos na linguagem Ruby.

Primeira fase consiste em criar uma aplicação de busca de voos utilizando um script Ruby e acessando uma API externa de busca de voos. Na segunda fase, criar uma API utilizando Rails, Docker e o banco de dados *Postgres*.


## Índice
- [Pré-requisitos](#pre-requisitos)
- [Tecnologias Utilizadas](#tecnologias-utilizadas)
- [Setup](#setup)
- [Como Usar](#como-usar)
  - [Iniciando](#iniciando)
  - [Testando](#testando)
  - [Code Style](#code-style)
- [Documentação da API](#documentacao-da-api)
  - [Buscar Voos](#buscar-voos)


## Pré-requisitos
- Docker


## Tecnologias Utilizadas
- Docker 24.0.7
- Ruby 3.3.4
- Rails 7.1.3.4


## Setup
A aplicação está configurada para utilizar os comandos do *Makefile*, que simplifica a utilização dos comando do *Docker*. Com isso, para configurar API localmente utilize o comando:

```bash
  make setup
```


## Como Usar
#### Iniciando
Para utilizar sua API REST favorita e fazer requisições para aplicação, basta subir API localmente utilizando o comando:

```bash
# API rodando na porta definida por [port=3000]
  make start port=3000
```

Para acessar o console da aplicação utilize com o comando:

```bash
  make bash
```

Caso haja necessidade, poderá subir uma nova instancia da aplicação utilizando o comando:

```bash
  make exec
```

#### Testando
Para executar os testes utilize com o comando:

```bash
  make test
```


#### Code Style (Rubocop)
A aplicação está usando a gem [RuboCop Rails](https://docs.rubocop.org/rubocop-rails/index.html) como ferramenta linter. Para executar o *rubocop* em toda aplicação utilize o comando:

```bash
  make rubocop
```

A [documentação do RuboCop Rails](https://docs.rubocop.org/rubocop-rails/cops_rails.html) contêm mais informações sobre seu uso.


## Documentação da API
#### - Buscar Voos
O endpoint *`search`* retorna os voos disponíveis mediante os parâmetros definidos na entrada.

```bash
  GET /flight/search
```

| Parâmetros | Tipo | Descrição |
| :--------- | :--- | :-------- |
| `origin_airport` | `string` | **Obrigatório**. Código do aeroporto de origem, formado por 3 letras sem números ou caracteres especiais |
| `destination_airport` | `string` | **Obrigatório**. Código do aeroporto de destino, formado por 3 letras sem números ou caracteres especiais |
| `departure_time` | `string` | **Obrigatório**. Data da partida do voo. O formato da data deve conter: dia e mês com 2 dígitos, e ano com 4 dígitos |
| `arrival_time` | `string` | **Opcional**. Data de chegada no aeroporto de destino |
| `fare_category` | `string` | **Opcional**. Define a categoria da passagem, podendo escolher entre: `economic`, `executive` ou `first_class` |

Exemplo de retorno:
- *Dados de parâmetros*
```json
  {
    "origin_airport": "JPA",
    "destination_airport": "GRU",
    "departure_time": "22/08/2024"
  }
```

- *Dados de retorno*
```json
  [
    {
      "fare_category": "economic",
      "price": "$256",
      "flight_details": [
        {
          "origin": "Joao Pessoa",
          "destiny": "Sao Paulo Guarulhos",
          "origin_airport": "JPA",
          "destination_airport": "GRU",
          "flight_number": 3463,
          "name_airline": "LATAM Airlines",
          "departure_time": "22/08/2024 - 13:25:00",
          "arrival_time": "22/08/2024 - 16:50:00",
          "connections": []
        }
      ]
    },
    {
      "fare_category": "economic",
      "price": "$454",
      "flight_details": [
        {
          "origin": "Joao Pessoa",
          "destiny": "Sao Paulo Guarulhos",
          "origin_airport": "JPA",
          "destination_airport": "GRU",
          "flight_number": null,
          "name_airline": null,
          "departure_time": "22/08/2024 - 18:10:00",
          "arrival_time": "22/08/2024 - 23:05:00",
          "connections": [
            {
              "origin": "Joao Pessoa",
              "destiny": "Recife",
              "origin_airport": "JPA",
              "destination_airport": "REC",
              "departure_time": "22/08/2024 - 18:10:00",
              "arrival_time": "22/08/2024 - 18:45:00",
              "flight_number": 2834,
              "name_airline": "Azul Airlines"
            },
            {
              "origin": "Recife",
              "destiny": "Sao Paulo Guarulhos",
              "origin_airport": "REC",
              "destination_airport": "GRU",
              "departure_time": "22/08/2024 - 19:50:00",
              "arrival_time": "22/08/2024 - 23:05:00",
              "flight_number": 4320,
              "name_airline": "Azul Airlines"
            }
          ]
        }
      ]
    }
  ]
```
