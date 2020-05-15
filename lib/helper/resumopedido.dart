import 'package:appfastdelivery/dao/singleton.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part "resumopedido.g.dart";

// flutter pub run build_runner build


@JsonSerializable()
class ResumoPedido {
  int id;
  String codigo;
  String andamento;
  String getParceiroImagem;
  String getTempo;
  String getParceiroNome;
  String getPreco;
  bool avaliado;
  bool cancelamento;

  var cor;


  ResumoPedido(this.id, this.codigo, this.andamento, this.getParceiroImagem, this.getTempo,this.getParceiroNome,this.getPreco,
      this.avaliado, this.cancelamento) {
    setAndamento(andamento);
    setImagem(getParceiroImagem);
  }

  factory ResumoPedido.fromJson(Map<String, dynamic> json) =>
      _$ResumoPedidoFromJson(json);

  Map<String, dynamic> toJson() => _$ResumoPedidoToJson(this);


  setAndamento(String andamento) {
    switch (andamento) {
      case "NEW":
        {
          this.andamento = "Aguardando Aprovação";
          cor = Colors.blueAccent;
        }
        break;

      case "RECEIVED":
        {
          this.andamento = "Pedido Aprovado";
          cor = Colors.blueAccent;
        }
        break;
      case "IN PREPARATION":
        {
          this.andamento = "Em Preparo";
          cor = Colors.purple;
        }
        break;
      case "READY":
        {
          this.andamento = "Pedido Pronto";
          cor = Colors.green;
        }
        break;
      case "SUBMITTED":
        {
          this.andamento = "Pedido Enviado";
          cor = Colors.orange;
        }
        break;
      case "DELIVERED":
        {
          if(!this.avaliado){
            this.andamento = "Avaliar agora";
            cor = Colors.orange[800];
          }else{
            this.andamento = "Pedido Entregue";
            cor = Colors.green;
          }
        }
        break;
      case "CANCEL":
        {
          this.andamento = "Pedido Cancelado";
          cor = Colors.red;
        }
        break;
      case "REJECTED":
        {
          this.andamento = "Pedido Rejeitado";
          cor = Colors.red;
        }
        break;
    }
  }
  setImagem(String getParceiroImagem){
    this.getParceiroImagem = Factory.internal().getUrlDefault()+ getParceiroImagem;
  }
}
