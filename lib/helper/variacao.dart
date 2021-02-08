import 'adicional.dart';

class Variacao {
  final int id;
  final String descricao;
  final int maximo;
  final int minimo;
  final bool ativo;
  final bool isMultiple;
  List<Adicional> adicionais;
  String valorTotal;

  Variacao(this.id, this.descricao, this.minimo, this.maximo, this.ativo,
      this.adicionais, this.isMultiple, this.valorTotal);
}
