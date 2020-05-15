


import 'dart:convert';

import 'package:appfastdelivery/dao/singleton.dart';
import 'package:appfastdelivery/helper/avaliacao.dart';
import 'package:http/http.dart' as http;

class AvaliacaoDao{

  static final AvaliacaoDao _instance = AvaliacaoDao.internal();
  factory AvaliacaoDao() => _instance;
  AvaliacaoDao.internal();

  Future<List<Avaliacao>> listAll() async{

    var data = await http.get(Factory.internal().getUrl()+'avaliacoes_comentarios/', headers: {'Accept': 'application/json'});
    var jsonDataList = json.decode(utf8.decode(data.bodyBytes));
    List<Avaliacao> avaliacoes = [];
    for(var jsonData in jsonDataList){
      List<Comentario> comentarios = [];
      var comments = jsonData['comentarios'];
      for(var comment in comments){
        comentarios.add(Comentario(comment['id'], comment['descricao'], comment['ponto']));
      }
      Avaliacao avaliacao = Avaliacao(jsonData['id'], jsonData['descricao'], jsonData['tipo'], comentarios);
      avaliacoes.add(avaliacao);
    }

    return avaliacoes;
  }


  Future<bool> sendResult(int idPedido, int idAvaliacao, int idComentario) async{
    http.Client client = http.Client();
    dynamic data;

    String body = "{\"pedido\": ${idPedido}, \"avaliacao\": ${idAvaliacao}, \"comentario\": ${idComentario}}";


    try {
      data = await client.post(
          Factory.internal().getUrl() +"avaliacao_pedido/",
          headers: {"Content-Type": "application/json"},
          body: body
      );

      if (data.statusCode < 200 ||
          data.statusCode >= 400 ||
          data.statusCode == null) {
        return false;
      } else {
        return true;
      }

    } catch (Exception) {
      print(Exception.toString());
      return false;
    }
  }



}