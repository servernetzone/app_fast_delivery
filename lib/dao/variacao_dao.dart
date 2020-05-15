import 'dart:convert';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:appfastdelivery/helper/adicional.dart';
import 'package:appfastdelivery/helper/variacao.dart';

import 'singleton.dart';


class VariacaoDao{

  static final VariacaoDao _instance = VariacaoDao.internal();
  factory VariacaoDao() => _instance;
  VariacaoDao.internal();





//  Future<List<Variacao>> list(int id) async {
////    print(id);
//    var data = await http.get((Factory.internal().getUrl()+'produtos/$id/variacoes/'), headers: {'Accept': 'application/json'});
//    var jsonDataList = json.decode(utf8.decode(data.bodyBytes));
//    List<Variacao> variacoes = List();
//
////    print(jsonDataList);
//    for (var jsonData in jsonDataList) {
//      Variacao variacao = Variacao(jsonData['pk'], jsonData['descricao'], jsonData['min'], jsonData['max'], jsonData['ativo']);
//      variacoes.add(variacao);
//    }
//
//    for (Variacao c in variacoes) {
//      print("variacao: "+c.descricao);
//    }
//    return variacoes;
//  }

  Future<List<Variacao>> list(int id) async {
//    print(id);
    var data = await http.get((Factory.internal().getUrl()+'produtos/$id/variacoes/'), headers: {'Accept': 'application/json'});
    var jsonDataList = json.decode(utf8.decode(data.bodyBytes));
    List<Variacao> variacoes = List();

//    print(jsonDataList);
    for (var jsonData in jsonDataList) {
      List<Adicional> adicionais = [];

      for(var jsonDataAdicionais in jsonData['adicionais']){
//      print(jsonDataAdicionais['descricao']);
       if(jsonDataAdicionais['status'] == 'Ativo'){
         Adicional adicional = Adicional(
             jsonDataAdicionais['pk'],
             jsonDataAdicionais['descricao'],
             jsonDataAdicionais['status'],
             jsonDataAdicionais['valor'],
             jsonDataAdicionais['getpreco']
         );
         adicionais.add(adicional);
       }
      }
//    print("printouuuuu: "+jsonData['adicionais']);

      Variacao variacao = Variacao(jsonData['pk'], jsonData['descricao'], jsonData['min'], jsonData['max'], jsonData['ativo'], adicionais, jsonData['isMultiple']);
      variacoes.add(variacao);
    }
    return variacoes;
  }





}