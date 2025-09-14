import 'item_venda.dart';

class Servico extends ItemVenda {
  Servico({required int codigo, required String nome, required double preco})
    : super(codigo: codigo, nome: nome, preco: preco);
}
