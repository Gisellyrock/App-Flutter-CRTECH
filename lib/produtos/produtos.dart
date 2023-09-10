class Produtos {
  final int categoria;
  final String nome;
  final String imagem;
  final String descricao;
  final double preco;
  final double quantidade;

  Produtos({
    required this.categoria,
    required this.nome,
    required this.preco,
    required this.descricao,
    required this.imagem,
    required this.quantidade,
  });
}
