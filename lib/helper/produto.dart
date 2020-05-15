import 'package:appfastdelivery/helper/variacao.dart';

class Produto {

  int id;
  String descricao;
  String imagem;
  String valorProduto;
  String situacao;
  String observacao;
  String preco;
  double porcentagemDesconto;
  bool promocao;
  double precoComDesconto;
  List<Variacao> variacoes;



  Produto({
    this.id,
    this.descricao,
    this.imagem,
    this.valorProduto,
    this.situacao,
    this.observacao,
    this.preco,
    this.porcentagemDesconto,
    this.promocao,
    this.precoComDesconto
  });
  Produto.internal();


  factory Produto.fromJson(Map<String, dynamic> json){
    return Produto(
      id: (json['pk'] as int),
      descricao: (json['descricao'] as String),
      imagem: (json['imagem'] as String),
      valorProduto: (json['valorProduto'] as String),
      situacao: (json['situacao'] as String),
      observacao: json['observacao'] == null ? '' : (json['observacao'] as String),
      preco: (json['getpreco'] as String),
      porcentagemDesconto: (json['porcentagemDesconto'] as num)?.toDouble(),
      promocao: (json['promocao'] as bool),
      precoComDesconto: (json['getPrecoComDesconto'] as num)?.toDouble()
    );
  }


}