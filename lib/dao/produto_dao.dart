import 'dart:convert';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:appfastdelivery/helper/categoria.dart';
import 'package:appfastdelivery/helper/produto.dart';

import 'singleton.dart';


class ProdutoDao{

  static final ProdutoDao _instance = ProdutoDao.internal();
  factory ProdutoDao() => _instance;
  ProdutoDao.internal();




  Future<List<Produto>> list(int id) async {
//    print(id);
    var data = await http.get((Factory.internal().getUrl()+'subcategoria/$id/produtos/'), headers: {'Accept': 'application/json'});
    var jsonDataList = json.decode(utf8.decode(data.bodyBytes));
    List<Produto> produtos = List();
    for (var jsonData in jsonDataList) {
      Produto produto = Produto.fromJson(jsonData);
//      String observacao = jsonData['observacao'];
//      if(observacao == null){
//        observacao = "";
//      }
//      Produto produto = Produto(jsonData['pk'], jsonData['descricao'], jsonData['imagem'], jsonData['valorProduto'],
//          jsonData['situacao'], observacao, jsonData['getpreco']);
      produtos.add(produto);
    }
    return produtos;
  }



  Future<List<Produto>> listProduto(int id) async {
    print(id);
    var data = await http.get((Factory.internal().getUrl()+'categoria/$id/produtos/'), headers: {'Accept': 'application/json'});
    var jsonDataList = json.decode(utf8.decode(data.bodyBytes));
    List<Produto> produtos = List();

    for (var jsonData in jsonDataList) {
      Produto produto = Produto.fromJson(jsonData);
//      String observacao = jsonData['observacao'];
//      if(observacao == null){
//        observacao = "";
//      }
//      Produto produto = Produto(jsonData['pk'], jsonData['descricao'], jsonData['imagem'], jsonData['valorProduto'],
//          jsonData['situacao'], observacao, jsonData['getpreco']);
      produtos.add(produto);
    }

    return produtos;
  }

  Future<Produto> getProduto(int id) async {
//    print(id);
    var data = await http.get((Factory.internal().getUrl()+'produto/$id/'), headers: {'Accept': 'application/json'});
    var jsonData = json.decode(utf8.decode(data.bodyBytes))[0];
    Produto produto = Produto.fromJson(jsonData);
//    print(jsonData[0].['pk']);
//    for (var jsonData in jsonDataList) {
//      String observacao = jsonData['observacao'];
//      if(observacao == null){
//        observacao = "";
//      }
//      Produto produto = Produto(jsonData['pk'], jsonData['descricao'], jsonData['imagem'], jsonData['valorProduto'],
//          jsonData['situacao'], observacao, jsonData['getpreco']);
//      produtos.add(produto);
//    }

    return produto;
  }

  Future<List<Produto>> listProdutosComPromocao(int idParceiro) async {
    List<Produto> produtos = List();
    var data = await http.get((Factory.internal().getUrl()+'$idParceiro/produtos_promocao/'), headers: {'Accept': 'application/json'});
    var jsonDataList = json.decode(utf8.decode(data.bodyBytes));
    print(jsonDataList);
    for (var jsonData in jsonDataList) {
      Produto produto = Produto.fromJson(jsonData);
      produtos.add(produto);
    }
    return produtos;
  }




}



