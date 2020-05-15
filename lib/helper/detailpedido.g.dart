// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'detailpedido.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PedidoDetail _$PedidoDetailFromJson(Map<String, dynamic> json) {
  return PedidoDetail(
      json['getParceiroNome'] as String,
      json['valor'] as String,
      json['tipo'] as String,
      json['andamento'] as String,
      json['status'] as String,
      json['entrega'] as bool,
      json['parceiro'] as int,
      json['endereco'] == null
          ? null
          : Endereco.fromJson(json['endereco'] as Map<String, dynamic>),
      json['cliente'] as int,
      json['valorPagoCliente'] as String,
      json['valorEntrega'] as String,
      (json['pagamentosPedido'] as List)
          ?.map((e) => e == null
              ? null
              : FormasPagamentoPedidoDetail.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      (json['itens'] as List)
          ?.map((e) => e == null
              ? null
              : ItemPedidoDetail.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      json['motivoCancelamento'] as String,
      json['getDataPedido'] as String,
      json['codigo'] as String,
      json['situacao'] as String,
      json['getTroco'] as String,
      json['getPreco'] as String,
      json['getParceiroImagem'] as String,
      json['getBotaoConfirmar'] as bool,
      json['avaliado'] as bool,
      json['cancelavel'] as bool,
      json['getPorcentagemCartao'] as String,
      json['getTaxaCartao'] as String,
      json['pedidoCartao'] as bool,
      (json['valor_ticket'] as num)?.toDouble(),
      json['pago_com_saldo'] as bool,
  )
    ..observacao = json['observacao'] as String;
//    ..cor = json['cor'];
}

Map<String, dynamic> _$PedidoDetailToJson(PedidoDetail instance) =>
    <String, dynamic>{
      'getParceiroNome': instance.getParceiroNome,
      'valor': instance.valor,
      'tipo': instance.tipo,
      'codigo': instance.codigo,
      'situacao': instance.situacao,
      'status': instance.status,
      'entrega': instance.entrega,
      'parceiro': instance.parceiro,
      'andamento': instance.andamento,
      'endereco': instance.endereco,
      'cliente': instance.cliente,
      'valorPagoCliente': instance.valorPagoCliente,
      'valorEntrega': instance.valorEntrega,
      'pagamentosPedido': instance.pagamentosPedido,
      'itens': instance.itens,
      'getDataPedido': instance.getDataPedido,
      'getTroco': instance.getTroco,
      'getPreco': instance.getPreco,
      'getParceiroImagem': instance.getParceiroImagem,
      'observacao': instance.observacao,
      'motivoCancelamento': instance.motivoCancelamento,
      'getBotaoConfirmar': instance.getBotaoConfirmar,
      'avaliado': instance.getBotaoConfirmar,
      'cancelavel': instance.cancelamento,
      'cor': instance.cor
    };

Endereco _$EnderecoFromJson(Map<String, dynamic> json) {
  return Endereco(
      json['rua'] as String,
      json['numero'] as int,
      json['bairro'] as String,
      json['cep'] as String,
      json['cidade'] as String,
      json['referencia'] as String,
      json['observacao'] as String);
}

Map<String, dynamic> _$EnderecoToJson(Endereco instance) => <String, dynamic>{
      'rua': instance.rua,
      'numero': instance.numero,
      'bairro': instance.bairro,
      'cep': instance.cep,
      'cidade': instance.cidade,
      'referencia': instance.referencia,
      'observacao': instance.observacao
    };

FormasPagamentoPedidoDetail _$FormasPagamentoPedidoDetailFromJson(
    Map<String, dynamic> json) {
  return FormasPagamentoPedidoDetail(
      json['formaPagamento'] as int,
      json['valor'] as String,
      json['getImagem'] as String,
      json['getNome'] as String)
    ..gettip = json['gettip'] as String;
}

Map<String, dynamic> _$FormasPagamentoPedidoDetailToJson(
        FormasPagamentoPedidoDetail instance) =>
    <String, dynamic>{
      'valor': instance.valor,
      'formaPagamento': instance.formaPagamento,
      'getImagem': instance.getImagem,
      'getNome': instance.getNome,
      'gettip': instance.gettip
    };

ItemPedidoDetail _$ItemPedidoDetailFromJson(Map<String, dynamic> json) {
  return ItemPedidoDetail(
      json['produto'] as int,
      json['getNomeProduto'] as String,
      json['quantidade'] as int,
      json['valorPedido'] as String,
      json['situacao'] as String,
      json['observacao'] as String,
      (json['adicionais'] as List)
          ?.map((e) => e == null
              ? null
              : EscolhaAdicionalDetail.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      json['getImagem'] as String)
    ..getPreco = json['getPreco'] as String;
}

Map<String, dynamic> _$ItemPedidoDetailToJson(ItemPedidoDetail instance) =>
    <String, dynamic>{
      'produto': instance.produto,
      'getNomeProduto': instance.getNomeProduto,
      'quantidade': instance.quantidade,
      'valorPedido': instance.valorPedido,
      'situacao': instance.situacao,
      'observacao': instance.observacao,
      'adicionais': instance.adicionais,
      'getImagem': instance.getImagem,
      'getPreco': instance.getPreco
    };

EscolhaAdicionalDetail _$EscolhaAdicionalDetailFromJson(
    Map<String, dynamic> json) {
  return EscolhaAdicionalDetail(
      json['pkdoadicional'] as int,
      json['descricaoAdicional'] as String,
      json['descricaoVariacao'] as String,
      json['valorAdicional'] as String);
}

Map<String, dynamic> _$EscolhaAdicionalDetailToJson(
        EscolhaAdicionalDetail instance) =>
    <String, dynamic>{
      'pkdoadicional': instance.pkdoadicional,
      'descricaoAdicional': instance.descricaoAdicional,
      'descricaoVariacao': instance.descricaoVariacao,
      'valorAdicional': instance.valorAdicional
    };
