import 'item_venda.dart';

class Carrinho {
  final List<ItemVenda> _itens = [];
  static const int limiteItens = 3;

  List<ItemVenda> get itens => List.unmodifiable(_itens);

  bool adicionarItem(ItemVenda item) {
    if (_itens.length < limiteItens) {
      _itens.add(item);
      print('"${item.nome}" adicionado ao carrinho.');
      return true;
    } else {
      print('Erro: O carrinho já atingiu o limite de $limiteItens itens.');
      return false;
    }
  }

  double calcularTotal() {
    return _itens.fold(0.0, (total, item) => total + item.preco);
  }

  void listarItens() {
    if (_itens.isEmpty) {
      print('O seu carrinho está vazio.');
    } else {
      print('--- Itens no seu Carrinho ---');
      _itens.forEach(print);
      print('---------------------------------');
      print('Total parcial: R\$ ${calcularTotal().toStringAsFixed(2)}');
    }
  }
}
