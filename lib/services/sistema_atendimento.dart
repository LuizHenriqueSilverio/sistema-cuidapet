import '../models/carrinho.dart';
import '../models/item_venda.dart';
import '../models/produto.dart';
import '../models/servico.dart';
import '../utils/console_utils.dart';
import 'dart:io';

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
    print('Olá, $nomeCliente! O que deseja fazer hoje?');

    final carrinho = Carrinho();

    while (true) {
      _exibirMenuCliente();
      final opcao = ConsoleUtils.lerInt(
        mensagem: 'Escolha uma opção: ',
        min: 0,
        max: 4,
      );

      if (opcao == 0) {
        print('Atendimento cancelado. Até a próxima, $nomeCliente!');
        break;
      }

      switch (opcao) {
        case 1:
          _listarItensVenda(_produtos, 'Produtos em Promoção');
          _adicionarItemAoCarrinho(carrinho, [..._produtos, ..._servicos]);
          break;
        case 2:
          _listarItensVenda(_servicos, 'Serviços Disponíveis');
          _adicionarItemAoCarrinho(carrinho, [..._produtos, ..._servicos]);
          break;
        case 3:
          carrinho.listarItens();
          break;
        case 4:
          if (_finalizarCompra(carrinho, nomeCliente)) {
            return;
          }
          break;
      }
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
    Carrinho carrinho,
    List<ItemVenda> itensDisponiveis,
  ) {
    if (carrinho.itens.length >= Carrinho.limiteItens) {
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
      carrinho.adicionarItem(item);
    } catch (e) {
      print('Código de item inválido ou não encontrado.');
    }
  }

  bool _finalizarCompra(Carrinho carrinho, String nomeCliente) {
    if (carrinho.itens.isEmpty) {
      print(
        'Seu carrinho está vazio. Adicione itens antes de finalizar a compra.',
      );
      return false;
    }

    carrinho.listarItens();
    final total = carrinho.calcularTotal();
    print('\nTotal da compra: R\$ ${total.toStringAsFixed(2)}');

    final formaPagamento = ConsoleUtils.lerString(
      'Qual a forma de pagamento (dinheiro, cartao)? ',
    ).toLowerCase();

    double valorFinal = total;
    if (formaPagamento == 'dinheiro') {
      final desconto = total * 0.10;
      valorFinal -= desconto;
      print('Desconto de 10% aplicado para pagamento em dinheiro!');
      print('Valor com desconto: R\$ ${valorFinal.toStringAsFixed(2)}');
    } else if (formaPagamento != 'cartao') {
      print(
        'Forma de pagamento não reconhecida. Compra finalizada sem desconto.',
      );
    }

    print('\nCompra finalizada com sucesso! Obrigado, $nomeCliente!');

    _totalClientesAtendidos++;
    _totalFaturado += valorFinal;

    return true;
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
