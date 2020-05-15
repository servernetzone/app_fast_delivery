// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorito.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Favorito _$FavoritoFromJson(Map<String, dynamic> json) {
  return Favorito(json['cliente'] as int, json['parceiro'] as int,
      json['isFavorito'] as bool);
}

Map<String, dynamic> _$FavoritoToJson(Favorito instance) => <String, dynamic>{
      'cliente': instance.cliente,
      'parceiro': instance.parceiro,
      'isFavorito': instance.isFavorito
    };
