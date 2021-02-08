import 'package:json_annotation/json_annotation.dart';

part 'carrinho.g.dart';

@JsonSerializable()
class ItemCarrinho {
  int idProduto;
  String descricaoProduto;
  String imagemProduto;
  int quantidade;
  double valor;
  String situacao = "não especificado";
  String observacao = "não especificado";
  List<AdicionalEscolhido> adicionaisEscolhidos;

  ItemCarrinho(
      this.idProduto,
      this.descricaoProduto,
      this.imagemProduto,
      this.quantidade,
      this.valor,
      this.situacao,
      this.observacao,
      this.adicionaisEscolhidos);

  factory ItemCarrinho.fromJson(Map<String, dynamic> json) =>
      _$ItemCarrinhoFromJson(json);

  Map<String, dynamic> toJson() => _$ItemCarrinhoToJson(this);
}

@JsonSerializable()
class AdicionalEscolhido {
  final int id;
  final String descricao;
  String descricaoVariacao;
  final String valor;
  final String valorTotal;

  AdicionalEscolhido(this.id, this.descricao, this.descricaoVariacao,
      this.valor, this.valorTotal);

  factory AdicionalEscolhido.fromJson(Map<String, dynamic> json) =>
      _$AdicionalEscolhidoFromJson(json);

  Map<String, dynamic> toJson() => _$AdicionalEscolhidoToJson(this);
}
