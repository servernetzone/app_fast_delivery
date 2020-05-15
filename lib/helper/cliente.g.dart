// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cliente.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Cliente _$ClienteFromJson(Map<String, dynamic> json) {
  return Cliente(
      json['id'] as int,
      json['nome'] as String,
      json['cpf'] as String,
      json['telefone'] as String,
      json['token'] as String,
      json['username'] as String,
      json['password'] as String,
      codigoIndicador: (json['codigo_indicador'] as String),
      saldo: json['saldo'] == null ? 0.0 : (json['saldo'] as num)?.toDouble(),
      codigoIndicacao: (json['codigo_indicacao'] as String)
  )
    ..endereco = json['endereco'] == null
        ? null
        : Endereco.fromJson(json['endereco'] as Map<String, dynamic>);
}

Map<String, dynamic> _$ClienteToJson(Cliente instance) => <String, dynamic>{
      'id': instance.id,
      'nome': instance.nome,
      'cpf': instance.cpf,
      'telefone': instance.telefone,
      'token': instance.token,
      'endereco': instance.endereco,
      'username': instance.login,
      'password': instance.senha,
      'codigo_indicador': instance.codigoIndicador,
      'codigo_indicacao': instance.codigoIndicacao,
      'saldo': instance.saldo,
    };
