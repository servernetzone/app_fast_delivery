import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:appfastdelivery/dao/singleton.dart';
import 'package:appfastdelivery/util/format_util.dart';

part 'detailpedido.g.dart';


@JsonSerializable()
class PedidoDetail {

  String getParceiroNome;
  String valor;
  String tipo;
  String codigo;
  String situacao;
  String status;
  bool entrega;
  int parceiro;
  String andamento;
  Endereco endereco;
  int cliente;
  String valorPagoCliente;
  String valorEntrega;
  List<FormasPagamentoPedidoDetail> pagamentosPedido;
  List<ItemPedidoDetail> itens;
  String getDataPedido;
  String getTroco;
  String getPreco;
  String getParceiroImagem;
  String observacao;
  String motivoCancelamento;
  bool getBotaoConfirmar;
  bool avaliado;
  bool cancelamento;
  var cor;
  String porcentagemCartao;
  String valorTaxaCartao;
  bool pedidoCartao;// se TRUE indica que o pedido foi feito no cartão de crédio ou debito
  double valorTicket;
  bool pagoComSaldo;

  PedidoDetail(
      this.getParceiroNome,
      this.valor,
      this.tipo,
      this.andamento,
      this.status,
      this.entrega,
      this.parceiro,
      this.endereco,
      this.cliente,
      this.valorPagoCliente,
      this.valorEntrega,
      this.pagamentosPedido,
      this.itens,
      this.motivoCancelamento,
      this.getDataPedido,
      this.codigo,
      this.situacao,
      this.getTroco,
      this.getPreco,
      this.getParceiroImagem,
      this.getBotaoConfirmar,
      this.avaliado,
      this.cancelamento,
      this.porcentagemCartao,
      this.valorTaxaCartao,
      this.pedidoCartao,
      this.valorTicket,
      this.pagoComSaldo
      ){
    setAndamento(andamento);
    setParceiroImagem(getParceiroImagem);
    setValor(valor);
    setValorEntrega(valorEntrega);
    setValorPago(valorPagoCliente);
  }
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
          this.andamento = "Pedido Entregue";
          cor = Colors.green;
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
  setParceiroImagem(String caminhoImagem){
    this.getParceiroImagem = Factory.internal().getUrlDefault()+ caminhoImagem;
  }
  setValor(String valor){
    this.valor = FormatUtil.adicionaMascaraDinheiro(valor);
  }

  setValorEntrega(String valor){
    this.valorEntrega = FormatUtil.adicionaMascaraDinheiro(valor);
  }
  setValorPago(String valor){
    this.valorPagoCliente = FormatUtil.adicionaMascaraDinheiro(valor);
  }
  factory PedidoDetail.fromJson(Map<String, dynamic> json) => _$PedidoDetailFromJson(json);
  Map<String, dynamic> toJson() => _$PedidoDetailToJson(this);

}

@JsonSerializable()
class Endereco {
  String rua;
  int numero;
  String bairro;
  String cep;
  String cidade;
  String referencia;
  String observacao;

  Endereco(this.rua, this.numero, this.bairro, this.cep, this.cidade,
      this.referencia, this.observacao);

  factory Endereco.fromJson(Map<String, dynamic> json) => _$EnderecoFromJson(json);
  Map<String, dynamic> toJson() => _$EnderecoToJson(this);
}

@JsonSerializable()
class FormasPagamentoPedidoDetail {
  String valor;
  int formaPagamento;
  String getImagem;
  String getNome;
  String gettip;
  FormasPagamentoPedidoDetail(this.formaPagamento, this.valor, this.getImagem, this.getNome){
    setImagem(getImagem);
    setValor(valor);
  }

    setImagem(String caminhoImagem){
      this.getImagem = Factory.internal().getUrlDefault() + caminhoImagem;
    }
  setValor(String valor){
    this.valor = FormatUtil.adicionaMascaraDinheiro(valor);
  }


  factory FormasPagamentoPedidoDetail.fromJson(Map<String, dynamic> json) => _$FormasPagamentoPedidoDetailFromJson(json);
  Map<String, dynamic> toJson() => _$FormasPagamentoPedidoDetailToJson(this);
}

@JsonSerializable()
class ItemPedidoDetail {
  int produto;
  String getNomeProduto;
  int quantidade;
  String valorPedido;
  String situacao ="não especificado";
  String observacao="não especificado";
  List<EscolhaAdicionalDetail> adicionais;
  String getImagem;
  String getPreco;

  ItemPedidoDetail(this.produto, this. getNomeProduto, this.quantidade, this.valorPedido, this.situacao, this.observacao, this.adicionais,this.getImagem){
    setImagem(getImagem);
    setValor(valorPedido);
  }
    setImagem(String caminhoImagem){
      this.getImagem = Factory.internal().getUrlDefault() + caminhoImagem;
    }

    setValor(String valor){
    this.valorPedido = FormatUtil.adicionaMascaraDinheiro(valor);
  }

  setgetPreco(String valor){
    this.getPreco = FormatUtil.adicionaMascaraDinheiro(valor);
  }

  factory ItemPedidoDetail.fromJson(Map<String, dynamic> json) => _$ItemPedidoDetailFromJson(json);
  Map<String, dynamic> toJson() => _$ItemPedidoDetailToJson(this);
}

@JsonSerializable()
class EscolhaAdicionalDetail {
  int pkdoadicional;
  String descricaoAdicional;
  String descricaoVariacao;
  String valorAdicional;

  EscolhaAdicionalDetail(this.pkdoadicional,this.descricaoAdicional,this.descricaoVariacao,this.valorAdicional){
    setValor(valorAdicional);
  }

  setValor(String valor){
    this.valorAdicional = FormatUtil.adicionaMascaraDinheiro(valor);
  }
  factory EscolhaAdicionalDetail.fromJson(Map<String, dynamic> json) => _$EscolhaAdicionalDetailFromJson(json);
  Map<String, dynamic> toJson() => _$EscolhaAdicionalDetailToJson(this);
}


