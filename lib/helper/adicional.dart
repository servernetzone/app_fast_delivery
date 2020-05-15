

class Adicional {
  final int id;
  final String descricao;
  final String status;
  final String valor;
  double preco;
  bool selected = false;

  Adicional(this.id, this.descricao, this.status, this.valor, this.preco);
}