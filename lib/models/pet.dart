class Pet {
  final String nome;
  final String raca;

  Pet({required this.nome, required this.raca});

  @override
  String toString() {
    return 'Pet: $nome ($raca)';
  }
}
