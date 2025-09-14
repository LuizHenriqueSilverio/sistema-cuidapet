import 'item_venda.dart';

class Produto extends ItemVenda {
  Produto({required int codigo, required String nome, required double preco})
    : super(codigo: codigo, nome: nome, preco: preco);
}
