import 'dart:io';
import 'package:intl/intl.dart';

import '../models/carrinho.dart';
import '../models/cliente.dart';
import '../models/item_venda.dart';
import '../models/pet.dart';
import '../models/produto.dart';
import '../models/servico.dart';
import '../utils/console_utils.dart';

class SistemaAtendimento {
  final List<Produto> _produtos = [
    Produto(codigo: 101, nome: 'Ração Premium 1kg', preco: 45.50),
    Produto(codigo: 102, nome: 'Brinquedo de Corda', preco: 15.00),
    Produto(codigo: 103, nome: 'Shampoo Antipulgas', preco: 32.90),
    Produto(codigo: 104, nome: 'Coleira de Couro', preco: 55.00),
  ];

  final List<Servico> _servicos = [
    Servico(codigo: 201, nome: 'Banho e Tosa', preco: 80.00),
    Servico(codigo: 202, nome: 'Consulta Veterinária', preco: 120.00),
    Servico(codigo: 203, nome: 'Corte de Unhas', preco: 25.00),
  ];

  int _totalClientesAtendidos = 0;
  double _totalFaturado = 0.0;
  static const String _senhaAdmin = 'cuidapetrestrito';

  void iniciar() {
    while (true) {
      _exibirMenuPrincipal();
      final opcao = ConsoleUtils.lerInt(
        mensagem: 'Escolha uma opção: ',
        min: 0,
        max: 2,
      );

      switch (opcao) {
        case 1:
          _executarAtendimentoCliente();
          break;
        case 2:
          _acessarAreaRestrita();
          break;
        case 0:
          _gerarRelatorioFinal();
          return;
      }
    }
  }

  void _exibirMenuPrincipal() {
    print('\n--- Bem-vindo à Loja Cuidapet ---');
    print('1: Iniciar novo atendimento');
    print('2: Área Restrita (Funcionários)');
    print('0: Sair do sistema e gerar relatório');
    print('----------------------------------');
  }

  void _executarAtendimentoCliente() {
    print('\nOlá! Bem-vindo(a) ao autoatendimento Cuidapet!');
    final nomeCliente = ConsoleUtils.lerString(
      'Para começar, por favor, digite seu nome: ',
    );

    final cliente = Cliente(nome: nomeCliente);
    print('Olá, ${cliente.nome}!');

    _cadastrarPet(cliente);

    while (true) {
      _exibirMenuCliente();
      final opcao = ConsoleUtils.lerInt(
        mensagem: 'Escolha uma opção: ',
        min: 0,
        max: 4,
      );

      if (opcao == 0) {
        print('Atendimento cancelado. Até a próxima, ${cliente.nome}!');
        break;
      }

      switch (opcao) {
        case 1:
          _listarItensVenda(_produtos, 'Produtos em Promoção');
          _adicionarItemAoCarrinho(cliente, [..._produtos, ..._servicos]);
          break;
        case 2:
          _listarItensVenda(_servicos, 'Serviços Disponíveis');
          _adicionarItemAoCarrinho(cliente, [..._produtos, ..._servicos]);
          break;
        case 3:
          cliente.carrinho.listarItens();
          break;
        case 4:
          if (_finalizarCompra(cliente)) {
            return;
          }
          break;
      }
    }
  }

  void _cadastrarPet(Cliente cliente) {
    final resposta = ConsoleUtils.lerString(
      'Deseja cadastrar um pet para este atendimento? (s/n): ',
    ).toLowerCase();
    if (resposta == 's') {
      final nomePet = ConsoleUtils.lerString('Qual o nome do seu pet? ');
      final racaPet = ConsoleUtils.lerString('E a raça dele(a)? ');
      cliente.pet = Pet(nome: nomePet, raca: racaPet);
      print('Pet ${cliente.pet!.nome} cadastrado com sucesso!');
    }
  }

  void _exibirMenuCliente() {
    print('\n--- Menu de Opções ---');
    print('1: Ver promoções de produtos');
    print('2: Solicitar serviços');
    print('3: Ver carrinho de compra');
    print('4: Finalizar carrinho');
    print('0: Cancelar e sair');
    print('----------------------');
  }

  void _listarItensVenda(List<ItemVenda> itens, String titulo) {
    print('\n--- $titulo ---');
    itens.forEach(print);
    print('-----------------------');
  }

  void _adicionarItemAoCarrinho(
    Cliente cliente,
    List<ItemVenda> itensDisponiveis,
  ) {
    if (cliente.carrinho.itens.length >= Carrinho.limiteItens) {
      print(
        'Você já atingiu o limite de ${Carrinho.limiteItens} itens no carrinho.',
      );
      return;
    }

    final codigo = ConsoleUtils.lerInt(
      mensagem: 'Digite o código do item que deseja adicionar: ',
    );

    try {
      final item = itensDisponiveis.firstWhere((i) => i.codigo == codigo);
      if (cliente.carrinho.adicionarItem(item) &&
          item is Servico &&
          cliente.pet != null) {
        print('Serviço agendado para o pet ${cliente.pet!.nome}.');
      }
    } catch (e) {
      print('Código de item inválido ou não encontrado.');
    }
  }

  bool _finalizarCompra(Cliente cliente) {
    if (cliente.carrinho.itens.isEmpty) {
      print(
        'Seu carrinho está vazio. Adicione itens antes de finalizar a compra.',
      );
      return false;
    }

    cliente.carrinho.listarItens();
    final subtotal = cliente.carrinho.calcularTotal();
    print('\nSubtotal da compra: R\$ ${subtotal.toStringAsFixed(2)}');

    final formaPagamento = ConsoleUtils.lerString(
      'Qual a forma de pagamento (dinheiro, cartao)? ',
    ).toLowerCase();

    double desconto = 0.0;
    double valorFinal = subtotal;

    if (formaPagamento == 'dinheiro') {
      desconto = subtotal * 0.10;
      valorFinal -= desconto;
    } else if (formaPagamento != 'cartao') {
      print(
        'Forma de pagamento não reconhecida. Compra finalizada sem desconto.',
      );
    }

    _gerarRecibo(
      cliente: cliente,
      subtotal: subtotal,
      desconto: desconto,
      valorFinal: valorFinal,
      formaPagamento: formaPagamento,
    );

    _totalClientesAtendidos++;
    _totalFaturado += valorFinal;

    return true;
  }

  void _gerarRecibo({
    required Cliente cliente,
    required double subtotal,
    required double desconto,
    required double valorFinal,
    required String formaPagamento,
  }) {
    final dataFormatada = DateFormat(
      'dd/MM/yyyy HH:mm:ss',
    ).format(DateTime.now());

    print('\n\n======================================');
    print('          RECIBO - CUIDAPET');
    print('======================================');
    print('Data: $dataFormatada');
    print('Cliente: ${cliente.nome}');
    if (cliente.pet != null) {
      print('Pet: ${cliente.pet!.nome} (${cliente.pet!.raca})');
    }
    print('--------------------------------------');
    print('Itens Comprados:');
    for (var item in cliente.carrinho.itens) {
      final preco = 'R\$ ${item.preco.toStringAsFixed(2)}'.padLeft(10);
      print('- ${item.nome.padRight(25)} $preco');
    }
    print('--------------------------------------');
    print('Subtotal:             R\$ ${subtotal.toStringAsFixed(2)}');
    if (desconto > 0) {
      print('Desconto (Dinheiro): -R\$ ${desconto.toStringAsFixed(2)}');
    }
    print('Forma de Pagamento:   ${formaPagamento.toUpperCase()}');
    print('======================================');
    print('TOTAL A PAGAR:        R\$ ${valorFinal.toStringAsFixed(2)}');
    print('======================================');
    print('\nObrigado, ${cliente.nome}! Volte sempre!');
  }

  void _acessarAreaRestrita() {
    final senha = ConsoleUtils.lerString('Digite a senha de acesso: ');
    if (senha != _senhaAdmin) {
      print('Senha incorreta! Acesso negado.');
      return;
    }

    print('\n--- Área Restrita - Lançamento Manual ---');
    final nomeCliente = ConsoleUtils.lerString('Nome do cliente: ');
    final valorCompra = ConsoleUtils.lerDouble('Valor da compra: R\$ ');
    final formaPagamento = ConsoleUtils.lerString(
      'Forma de pagamento (dinheiro, cartao): ',
    ).toLowerCase();

    double valorFinal = valorCompra;
    if (formaPagamento == 'dinheiro') {
      valorFinal *= 0.90;
    }

    _totalClientesAtendidos++;
    _totalFaturado += valorFinal;

    print(
      'Venda para "$nomeCliente" no valor de R\$ ${valorFinal.toStringAsFixed(2)} registrada com sucesso!',
    );
  }

  void _gerarRelatorioFinal() {
    print('\n\n--- Relatório Final do Dia ---');
    print('Sistema encerrando...');
    print('Total de clientes atendidos: $_totalClientesAtendidos');
    print('Total faturado no dia: R\$ ${_totalFaturado.toStringAsFixed(2)}');
    print('--------------------------------------');
  }
}
