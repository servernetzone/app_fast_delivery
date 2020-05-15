import 'package:json_annotation/json_annotation.dart';

part 'pedido.g.dart';


@JsonSerializable()
class Pedido {

  double valor;
  String tipo;
  String codigo;
  String situacao;
  String status;
  bool entrega;
  int parceiro;
  String andamento;
  Endereco endereco;
  String dataPedido;
  int cliente;
  double porcentagemCartao;
  double valorPagoCliente;
  double valorEntrega;
  String observacao;
  List<FormasPagamentoPedido> pagamentosPedido;
  List<ItemPedido> itens;
  String ticket;
  bool pagoComSaldo = false;


  Pedido(
      this.valor,
      this.tipo,
      this.situacao,
      this.status,
      this.entrega,
      this.parceiro,
      this.endereco,
      this.cliente,
      this.valorPagoCliente,
      this.valorEntrega,
      this.pagamentosPedido,
      this.itens,
      this.observacao,
      {
        this.porcentagemCartao,
        this.ticket,
        this.pagoComSaldo
      }
      );
  Pedido.instance();
  factory Pedido.fromJson(Map<String, dynamic> json) => _$PedidoFromJson(json);
  Map<String, dynamic> toJson() => _$PedidoToJson(this);
}

@JsonSerializable()
class Endereco {  // Pedido
  int id;
  String rua;
  int numero;
  String bairro;
  String cep;
  String cidade;
  String referencia;
  String observacao;
  int idCidade;
  int idCliente;

  Endereco(this.rua, this.numero, this.bairro, this.cep, this.cidade,
      this.referencia, this.observacao, this.idCidade, this.idCliente);
  Endereco.instance();

  factory Endereco.fromJson(Map<String, dynamic> json) => _$EnderecoFromJson(json);
  Map<String, dynamic> toJson() => _$EnderecoToJson(this);
}

@JsonSerializable()
class EnderecoCliente {
  int id;
  String rua;
  int numero;
  String bairro;
  String cep;
  String nomeCidade;
  String referencia;
  String observacao;
  int idCidade;
  int idCliente;

  EnderecoCliente(this.rua, this.numero, this.bairro, this.cep, this.nomeCidade,
      this.referencia, this.observacao, this.idCidade, this.idCliente);

  factory EnderecoCliente.fromJson(Map<String, dynamic> json) => _$EnderecoClienteFromJson(json);
  Map<String, dynamic> toJson() => _$EnderecoClienteToJson(this);
}

@JsonSerializable()
class FormasPagamentoPedido {
  double valor;
  int formaPagamento;

  FormasPagamentoPedido(this.formaPagamento, this.valor);

  factory FormasPagamentoPedido.fromJson(Map<String, dynamic> json) => _$FormasPagamentoPedidoFromJson(json);
  Map<String, dynamic> toJson() => _$FormasPagamentoPedidoToJson(this);
}

@JsonSerializable()
class ItemPedido {
  int produto;
  int quantidade;
  double valorPedido;
  String situacao ="não especificado";
  String observacao="não especificado";
  List<EscolhaAdicional> adicionais;

  ItemPedido(this.produto, this.quantidade, this.valorPedido, this.situacao, this.observacao, this.adicionais);

  factory ItemPedido.fromJson(Map<String, dynamic> json) => _$ItemPedidoFromJson(json);
  Map<String, dynamic> toJson() => _$ItemPedidoToJson(this);
}

@JsonSerializable()
class EscolhaAdicional {
  int pkdoadicional;

  EscolhaAdicional(this.pkdoadicional);

  factory EscolhaAdicional.fromJson(Map<String, dynamic> json) => _$EscolhaAdicionalFromJson(json);
  Map<String, dynamic> toJson() => _$EscolhaAdicionalToJson(this);
}


