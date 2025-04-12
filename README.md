# Painel de Boleta para MetaTrader 5

Este projeto implementa um painel de boleta personalizado para o MetaTrader 5 que funciona dentro do testador de estratégias.

## Funcionalidades

- Interface gráfica com botões para controle de operações
- Compatível com o testador de estratégias do MetaTrader 5
- Controle de estado dos botões para operações de compra e venda
- Visualização de posições abertas e histórico de operações

## Requisitos

- MetaTrader 5
- MQL5

## Instalação

1. Copie os arquivos para a pasta `MQL5/Experts` do seu MetaTrader 5
2. Compile o arquivo principal `BoletaBacktest.mq5`
3. Adicione o Expert Advisor ao gráfico desejado

## Uso

1. Abra o testador de estratégias
2. Selecione o Expert Advisor "BoletaBacktest"
3. Configure os parâmetros desejados
4. Inicie o teste

## Estrutura do Projeto

- `BoletaBacktest.mq5` - Arquivo principal do Expert Advisor
- `BoletaBacktest.mqh` - Arquivo de inclusão com funções auxiliares
- `BoletaBacktestGUI.mqh` - Implementação da interface gráfica 