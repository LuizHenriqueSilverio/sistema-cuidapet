abstract class ItemVenda {
  final int codigo;
  final String nome;
  final double preco;

  ItemVenda({required this.codigo, required this.nome, required this.preco});

  @override
  String toString() {
    return 'Código: $codigo | Nome: $nome - R\$ ${preco.toStringAsFixed(2)}';
  }
}
