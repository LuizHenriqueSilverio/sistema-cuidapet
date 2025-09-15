# Cuidapet - Sistema de Autoatendimento

## 📝 Descrição

Este projeto é um sistema de autoatendimento para um pet shop fictício, o "Cuidapet". Desenvolvido em Dart, o sistema opera via console e simula a jornada de um cliente, desde a visualização de produtos e serviços até a finalização da compra, incluindo também uma área restrita para funcionários.

Este software foi criado como parte de um projeto acadêmico, com foco na aplicação dos conceitos de Programação Orientada a Objetos.

## 🚀 Requisitos para Execução

-   [Dart SDK](https://dart.dev/get-dart) (versão 3.0 ou superior)

## ⚙️ Como Rodar Localmente

1.  **Clone o repositório:**
    ```bash
    git clone <url-do-seu-repositorio>
    cd <nome-do-repositorio>
    ```

2.  **Instale as dependências:**
    O projeto utiliza o pacote `intl` para formatação de datas. Execute o comando abaixo para baixá-lo:
    ```bash
    dart pub get
    ```

3.  **Execute a aplicação:**
    ```bash
    dart run lib/main.dart
    ```

O sistema será iniciado no seu terminal.

## 📖 Instruções de Uso

Ao iniciar o sistema, você terá três opções principais:

1.  **Iniciar novo atendimento:**
    -   Siga as instruções para se identificar e, opcionalmente, cadastrar seu pet.
    -   Navegue pelo menu para ver produtos, serviços, adicionar itens ao carrinho e finalizar a compra.
    -   O carrinho tem um limite de 3 itens.
    -   Pagamentos em dinheiro recebem 10% de desconto.

2.  **Área Restrita (Funcionários):**
    -   Utilize esta opção para lançar vendas manualmente.
    -   A senha de acesso é: `cuidapetrestrito`

3.  **Sair do sistema e gerar relatório:**
    -   Encerra a aplicação e exibe um relatório final com o total de clientes atendidos e o valor total faturado no dia.

## 📚 Documentação Completa

Para uma visão detalhada da arquitetura, diagramas UML e decisões de projeto, por favor, consulte a **[Wiki do Projeto](https://github.com/LuizHenriqueSilverio/sistema-cuidapet/wiki)**.

## 👥 Créditos

-   **[Gabriel Caproni Pegoraro]** - Desenvolvedor
-   **[Guilherme Henrique de Souza Silva]** - Desenvolvedor
-   **[Luiz Henrique silverio de Souza]** - Desenvolvedor
-   **[Pedro Ferreira Franco]** - Desenvolvedor