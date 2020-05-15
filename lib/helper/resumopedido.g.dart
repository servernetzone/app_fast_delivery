// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resumopedido.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResumoPedido _$ResumoPedidoFromJson(Map<String, dynamic> json) {
  return ResumoPedido(
      json['id'] as int,
      json['codigo'] as String,
      json['andamento'] as String,
      json['getParceiroImagem'] as String,
      json['getTempo'] as String,
      json['getParceiroNome'] as String,
      json['getPreco'] as String,
      json['avaliado'] as bool,
      json['cancelavel'] as bool
  );
//    ..cor = json['cor'];
}

Map<String, dynamic> _$ResumoPedidoToJson(ResumoPedido instance) =>
    <String, dynamic>{
      'id': instance.id,
      'codigo': instance.codigo,
      'andamento': instance.andamento,
      'getParceiroImagem': instance.getParceiroImagem,
      'getTempo': instance.getTempo,
      'getParceiroNome': instance.getParceiroNome,
      'getPreco': instance.getPreco,
      'avaliado': instance.avaliado,
'cancelavel': instance.cancelamento,
      'cor': instance.cor,

    };
