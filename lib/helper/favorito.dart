import 'package:json_annotation/json_annotation.dart';
import 'package:appfastdelivery/helper/pedido.dart';

part 'favorito.g.dart';
//flutter pub run build_runner build

@JsonSerializable()
class Favorito {
  int cliente;
  int parceiro;
  bool isFavorito;

  Favorito(this.cliente,this.parceiro,this.isFavorito);
  Favorito.internal();



  factory Favorito.fromJson(Map<String, dynamic> json) => _$FavoritoFromJson(json);
  Map<String, dynamic> toJson() => _$FavoritoToJson(this);
}
