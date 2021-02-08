// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'carrinho.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ItemCarrinho _$ItemCarrinhoFromJson(Map<String, dynamic> json) {
  return ItemCarrinho(
      json['idProduto'] as int,
      json['descricaoProduto'] as String,
      json['imagemProduto'] as String,
      json['quantidade'] as int,
      (json['valor'] as num)?.toDouble(),
      json['situacao'] as String,
      json['observacao'] as String,
      (json['adicionaisEscolhidos'] as List)
          ?.map((e) => e == null
              ? null
              : AdicionalEscolhido.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$ItemCarrinhoToJson(ItemCarrinho instance) =>
    <String, dynamic>{
      'idProduto': instance.idProduto,
      'descricaoProduto': instance.descricaoProduto,
      'imagemProduto': instance.imagemProduto,
      'quantidade': instance.quantidade,
      'valor': instance.valor,
      'situacao': instance.situacao,
      'observacao': instance.observacao,
      'adicionaisEscolhidos': instance.adicionaisEscolhidos
    };

AdicionalEscolhido _$AdicionalEscolhidoFromJson(Map<String, dynamic> json) {
  return AdicionalEscolhido(json['id'] as int, json['descricao'] as String,
      json['descricaoVariacao'] as String, json['valor'] as String, json['valorTotal'] as String);
}

Map<String, dynamic> _$AdicionalEscolhidoToJson(AdicionalEscolhido instance) =>
    <String, dynamic>{
      'id': instance.id,
      'descricao': instance.descricao,
      'descricaoVariacao': instance.descricaoVariacao,
      'valor': instance.valor
    };
