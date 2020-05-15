import 'package:json_annotation/json_annotation.dart';
import 'package:appfastdelivery/helper/pedido.dart';


class Cliente2 {
  int id;
  String nome;
  String cpf;
  String telefone;
  String token;
  String login;
  String senha;
  Endereco endereco = null;

  Cliente2(this.id, this.nome, this.cpf, this.telefone, this.token, this.login, this.senha);
  Cliente2.internal();



  factory Cliente2.fromJson(Map<String, dynamic> json) {
    return Cliente2(
      json['id'] as int,
      json['nome'] as String,
      json['cpf'] as String,
      json['telefone'] as String,
      json['token'] as String,
      json['username'] as String,
      json['password'] as String,
    )
      ..endereco = json['endereco'] == null
          ? null
          : Endereco.fromJson(json['endereco'] as Map<String, dynamic>);
  }
  Map<String, dynamic> toJson()=> <String, dynamic>{
    'id': this.id,
    'nome': this.nome,
    'cpf': this.cpf,
    'telefone': this.telefone,
    'token': this.token,
    'username': this.login,
    'password': this.senha,
    'endereco': this.endereco
  };
}