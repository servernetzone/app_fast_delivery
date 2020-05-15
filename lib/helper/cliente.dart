import 'package:json_annotation/json_annotation.dart';
import 'package:appfastdelivery/helper/pedido.dart';

part 'cliente.g.dart';


@JsonSerializable()
class Cliente {
  int id;
  String nome;
  String cpf;
  String telefone;
  String token;
  String login;
  String senha;
  Endereco endereco = null;
  String codigoIndicador;
  String codigoIndicacao;
  double saldo;

  Cliente(this.id, this.nome, this.cpf, this.telefone, this.token, this.login, this.senha, {this.codigoIndicador, this.saldo, this.codigoIndicacao});
  Cliente.internal();



  factory Cliente.fromJson(Map<String, dynamic> json) => _$ClienteFromJson(json);
  Map<String, dynamic> toJson() => _$ClienteToJson(this);
}
