import 'dart:convert';

import 'package:appfastdelivery/dao/singleton.dart';
import 'package:appfastdelivery/helper/detailpedido.dart';
import 'package:appfastdelivery/helper/resumopedido.dart';
import 'package:http/http.dart' as http;
class PedidoDao {

  static final PedidoDao _instance = PedidoDao.internal();
  factory PedidoDao() => _instance;
  PedidoDao.internal();



  Future<List<ResumoPedido>> list(int id) async {
    List<ResumoPedido> saida = [];
    http.Client client = http.Client();
    dynamic data;
    try {
      data = await client.get(Factory.internal().getUrl() +"cliente/$id/pedidos/",
          headers: {"Content-Type": "application/json"});

//      print('LOG[PedidoDao.enviarMensagem]: data.body: ${data.body}');
      var jsonList = json.decode(utf8.decode(data.bodyBytes));
//      print('LOG[PedidoDao.enviarMensagem] jsondata: ${jsonList}');
      if (data.statusCode < 200 ||
          data.statusCode >= 400 ||
          data.statusCode == null) {
      } else {

        for (data in jsonList) {
          ResumoPedido p = ResumoPedido.fromJson(data);
          saida.add(p);
        }
      }
    } catch (Exception) {
      return saida;
    }
    return saida;
  }



  Future<PedidoDetail> get(int id) async {
    http.Client client = http.Client();
    dynamic data;
    try {
      data = await client.get(
          Factory.internal().getUrl() +"pedidos/$id/",
          headers: {"Content-Type": "application/json"});

      var jsondata = json.decode(utf8.decode(data.bodyBytes));
      if (data.statusCode < 200 ||
          data.statusCode >= 400 ||
          data.statusCode == null) {
      } else {
        PedidoDetail p = PedidoDetail.fromJson(jsondata[0]);
        return p;
      }

    } catch (Exception) {
      print(Exception.toString());
      return null;
    }

  }


  Future<Map<String, dynamic>> cancelarPedido(int id) async {
    http.Client client = http.Client();
    dynamic request;
    try {
      request = await client.get(
          Factory.internal().getUrl() +"cancelar_pedido/$id/",
          headers: {"Content-Type": "application/json"});

      var response = json.decode(utf8.decode(request.bodyBytes));
      print('response $response');
     return response;

    } catch (exception) {
      print(exception);
      return null;
    }

  }

  Future<Map<String, dynamic>> enviarMensagem(String message, int id) async {
    http.Client client = http.Client();
    try {
      String request = json.encode({
        "mensagem_adicional": message
      });
      print('LOG[PedidoDao.enviarMensagem]: request: $request');
      var data = await client.patch(
          Factory.internal().getUrl() +"mensagem_adicional/$id/",
          headers: {"Content-Type": "application/json"},
          body: request
          );
      print('LOG[PedidoDao.enviarMensagem]: data.body: ${data.body}');
      var response = json.decode(utf8.decode(data.bodyBytes));
      print('LOG[PedidoDao.enviarMensagem]: response: $response');
      return response;
    } catch (exception) {
      print(exception);
      return <String, dynamic> {'status': 'fail', 'resposta': 'Erro ao enviar mensagem. Tente novamente mais tarde.'};
    }

  }
}