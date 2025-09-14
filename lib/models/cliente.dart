import 'carrinho.dart';
import 'pet.dart';

class Cliente {
  final String nome;
  Pet? pet;
  final Carrinho carrinho = Carrinho();

  Cliente({required this.nome, this.pet});
}
