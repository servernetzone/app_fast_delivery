// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pedido.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Pedido _$PedidoFromJson(Map<String, dynamic> json) {
  return Pedido(
      (json['valor'] as num)?.toDouble(),
      json['tipo'] as String,
      json['situacao'] as String,
      json['status'] as String,
      json['entrega'] as bool,
      json['parceiro'] as int,
      json['endereco'] == null
          ? null
          : Endereco.fromJson(json['endereco'] as Map<String, dynamic>),
      json['cliente'] as int,
      (json['valorPagoCliente'] as num)?.toDouble(),
      (json['valorEntrega'] as num)?.toDouble(),
      (json['pagamentosPedido'] as List)?.map((e) => e == null
              ? null
              : FormasPagamentoPedido.fromJson(e as Map<String, dynamic>)
      )?.toList(),
      (json['itens'] as List)?.map(
              (e) => e == null
                  ? null
                  : ItemPedido.fromJson(e as Map<String, dynamic>)
      )?.toList(),
      json['observacao'] as String,
      porcentagemCartao: (json['taxaCartao'] as num)?.toDouble()
  )
    ..codigo = json['codigo'] as String
    ..andamento = json['andamento'] as String
    ..dataPedido = json['dataPedido'] as String;
}

Map<String, dynamic> _$PedidoToJson(Pedido instance) => <String, dynamic>{
      'valor': instance.valor,
      'tipo': instance.tipo,
//      'codigo': instance.codigo,
      'situacao': instance.situacao,
      'status': instance.status,
      'entrega': instance.entrega,
      'parceiro': instance.parceiro,
//      'andamento': instance.andamento,
      'endereco': instance.endereco,
//      'dataPedido': instance.dataPedido,
      'cliente': instance.cliente,
      'valorPagoCliente': instance.valorPagoCliente,
      'valorEntrega': instance.valorEntrega,
      'observacao': instance.observacao,
      'pagamentosPedido': instance.pagamentosPedido,
      'itens': instance.itens,
      'porcentagemCartao': instance.porcentagemCartao,
      'ticket': instance.ticket,
      'pago_com_saldo': instance.pagoComSaldo,
    };

Endereco _$EnderecoFromJson(Map<String, dynamic> json) {
  return Endereco(
      json['rua'] as String,
      json['numero'] as int,
      json['bairro'] as String,
      json['cep'] as String,
      json['cidade'] as String,
      json['referencia'] as String,
      json['observacao'] as String,
      json['idCidade'] as int,
      json['idCliente'] as int)
    ..id = json['id'] as int;
}

Map<String, dynamic> _$EnderecoToJson(Endereco instance) => <String, dynamic>{
      'id': instance.id,
      'rua': instance.rua,
      'numero': instance.numero,
      'bairro': instance.bairro,
      'cep': instance.cep,
      'cidade': instance.cidade,
      'referencia': instance.referencia,
      'observacao': instance.observacao,
      'idCidade': instance.idCidade,
      'idCliente': instance.idCliente
    };

EnderecoCliente _$EnderecoClienteFromJson(Map<String, dynamic> json) {
  return EnderecoCliente(
      json['rua'] as String,
      json['numero'] as int,
      json['bairro'] as String,
      json['cep'] as String,
      json['nomecidade'] as String,
      json['referencia'] as String,
      json['observacao'] as String,
      json['cidade'] as int,
      json['cliente'] as int)
    ..id = json['id'] as int;
}

Map<String, dynamic> _$EnderecoClienteToJson(EnderecoCliente instance) =>
    <String, dynamic>{
      'id': instance.id,
      'rua': instance.rua,
      'numero': instance.numero,
      'bairro': instance.bairro,
      'cep': instance.cep,
      'nomecidade': instance.nomeCidade,
      'referencia': instance.referencia,
      'observacao': instance.observacao,
      'cidade': instance.idCidade,
      'cliente': instance.idCliente
    };

FormasPagamentoPedido _$FormasPagamentoPedidoFromJson(
    Map<String, dynamic> json) {
  return FormasPagamentoPedido(
      json['formaPagamento'] as int, (json['valor'] as num)?.toDouble());
}

Map<String, dynamic> _$FormasPagamentoPedidoToJson(
        FormasPagamentoPedido instance) =>
    <String, dynamic>{
      'valor': instance.valor,
      'formaPagamento': instance.formaPagamento
    };

ItemPedido _$ItemPedidoFromJson(Map<String, dynamic> json) {
  return ItemPedido(
      json['produto'] as int,
      json['quantidade'] as int,
      (json['valorPedido'] as num)?.toDouble(),
      json['situacao'] as String,
      json['observacao'] as String,
      (json['adicionais'] as List)
          ?.map((e) => e == null
              ? null
              : EscolhaAdicional.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$ItemPedidoToJson(ItemPedido instance) =>
    <String, dynamic>{
      'produto': instance.produto,
      'quantidade': instance.quantidade,
      'valorPedido': instance.valorPedido,
      'situacao': instance.situacao,
      'observacao': instance.observacao,
      'adicionais': instance.adicionais
    };

EscolhaAdicional _$EscolhaAdicionalFromJson(Map<String, dynamic> json) {
  return EscolhaAdicional(json['pkdoadicional'] as int);
}

Map<String, dynamic> _$EscolhaAdicionalToJson(EscolhaAdicional instance) =>
    <String, dynamic>{'pkdoadicional': instance.pkdoadicional};
