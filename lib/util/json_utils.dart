import 'package:appfastdelivery/dao/singleton.dart';
import 'package:appfastdelivery/helper/cliente.dart';
import 'package:appfastdelivery/helper/detailpedido.dart';
import 'package:appfastdelivery/helper/favorito.dart';
import 'package:appfastdelivery/helper/parceiro.dart';
import 'package:appfastdelivery/helper/resumopedido.dart';

import '../helper/pedido.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'notificacao_utils.dart';


class JsonUtils {
  static String MontaJSON(dynamic objeto) {
    return json.encode(objeto);
  }

  static Future<List<String>> novoPedido({Pedido pedido}) async {
    bool saida ;
    http.Client client = http.Client();
    var json2 =  json.encode(pedido);

    print('JsonUtils.novoPedido - request: ${json2}');

    var data = await client.post(
        Factory.internal().getUrl() +"pedidos/novopedido/",
        headers: {"Content-Type": "application/json"},
        body: json2);

    print('------------------- status code ${data.statusCode}');
    print('------------------- body: ${data.body}');

    var jsondata = json.decode(utf8.decode(data.bodyBytes));
    String resposta = jsondata['resposta'];
    List<String> mensagens = List<String>();
    mensagens.add(resposta);
    if (data.statusCode < 200 || data.statusCode >= 400 || data.statusCode == null){
      mensagens.add(jsondata['motivo']);
      print(jsondata['motivo']);
      return mensagens;
    }else{
      mensagens.add('SALVO');
      return mensagens;
    }

//    String motivo = jsondata['motivo'];
//

  }



  static Future<Cliente> cadastrarCliente({Cliente objcliente}) async {
    Cliente saida ;
    http.Client client = http.Client();
    dynamic data = await client.post(Factory.internal().getUrl() +"cliente/novocliente/",
        headers: {"Content-Type": "application/json"},
        body: json.encode(objcliente));

    var jsondata = json.decode(utf8.decode(data.bodyBytes));
    print('Json data cliente: ${jsondata}');

    if (data.statusCode < 200 || data.statusCode >= 400 || data.statusCode == null){
      saida = null;
    }else{
      saida = Cliente.fromJson(jsondata);
    }
    return saida;
  }





  static Future<Cliente> atualizarCliente({Cliente cliente}) async {
    Cliente saida;
    http.Client client = http.Client();
    var body = jsonEncode(cliente);

    dynamic data = await client.patch(Factory().getUrl() + "cliente/${cliente.id}/",
        headers: {"Content-Type": "application/json"},
        body: body);

    var jsondata = json.decode(utf8.decode(data.bodyBytes));
    if (data.statusCode < 200 ||
        data.statusCode >= 400 ||
        data.statusCode == null) {
      saida = null;
    } else {
      print('JsonUtils.atualizarCliente: jsondata - ${jsondata}');
      saida = Cliente.fromJson(jsondata);
    }
    return saida;
  }

//  static Future<Cliente> buscarCliente({String telefone}) async {
//    Cliente saida;
//    http.Client client = http.Client();
//
//    dynamic data = await client.get(Factory.internal().getUrl() +"buscacliente/$telefone/",
//        headers: {"Content-Type": "application/json"});
//
//
//    var jsondata = json.decode(utf8.decode(data.bodyBytes));
//    print("JsonUtils.buscarCliente:  jsondata: ${jsondata}");
//    if(jsondata != null && jsondata.isEmpty){
//      if(jsondata.toString().contains("id")){
//        print("JsonUtils.buscarCliente:  jsondata[0]: ${jsondata[0]}");
//        saida = Cliente.fromJson(jsondata[0]);
////      saida = Cliente(jsondata['pk'], jsondata['nome'], jsondata['cpf'], jsondata['telefone'], "token");
//      }
//    }
//
//    if (data.statusCode < 200 || data.statusCode >= 400 || data.statusCode == null){
//      //ERRO
////      saida = true;
////      NotificacaoUtils.NovaNotificacao(
////          context,
////          "Pedido Criado com Sucesso",
////          Icon(Icons.beenhere, size: 80, color: Colors.lightGreen));
//    }else{
//
////      saida = false;
////      NotificacaoUtils.NovaNotificacao(
////          context,
////          "Erro ao Criar pedido",
////          Icon(Icons.error_outline, size: 80, color: Colors.redAccent));
//    }
////    print('cliente servidor');
////    print('saida');
//    return saida;
//  }

//  static Future<List> getPedidos(int id) async {
//    List<ResumoPedido> saida = List();
//    http.Client client = http.Client();
//    dynamic data;
//    try {
//      data = await client.get(
//          Factory.internal().getUrl() +"cliente/$id/pedidos/",
//          headers: {"Content-Type": "application/json"});
//
//      var jsondata = json.decode(utf8.decode(data.bodyBytes));
//      print(jsondata);
//
//      if (data.statusCode < 200 ||
//          data.statusCode >= 400 ||
//          data.statusCode == null) {
//      } else {
//
//        for (data in jsondata) {
////          print('entrou akkki');
//          ResumoPedido p = ResumoPedido.fromJson(data);
//
//         // p.getParceiroImagem = p.getParceiroImagem.replaceAll("/webapps/delivery/delivery", "http://www.appfastdelivery.com/");
//          saida.add(p);
//        }
//      }
//    } catch (Exception) {
//      return saida;
//    }
//    return saida;
//  }


  static Future<PedidoDetail> getPedidoDetail(int id) async {
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

  static Future<bool> confirmarRecebimento(int id) async {
    http.Client client = http.Client();
    dynamic data;
    try {
      data = await client.patch(
          Factory.internal().getUrl() +"pedidos/$id/",
          headers: {"Content-Type": "application/json"},
        body: "{\"confirmacaoCliente\": true}"
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

//  static Future<bool> Favoritar({Favorito favorito,BuildContext context}) async {
//    bool saida ;
//    http.Client client = http.Client();
//
//    dynamic data = await client.post(
//        Factory.internal().getUrl() +"cliente/favorito/",
//        headers: {"Content-Type": "application/json"},
//        body: json.encode(favorito));
//
//
//    var jsondata = json.decode(utf8.decode(data.bodyBytes));
//    if (data.statusCode == 201){
//      saida = true;
////      NotificacaoUtils.NovaNotificacao(
////          context,
////          "Pedido Criado com Sucesso",
////          Icon(Icons.beenhere, size: 80, color: Colors.lightGreen));
//    }else{
//      saida = false;
////      NotificacaoUtils.NovaNotificacao(
////          context,
////          "Erro ao Criar favorito",
////          Icon(Icons.error_outline, size: 80, color: Colors.redAccent));
//    }
//    return saida;
//  }

//  static Future<List<Parceiro>> getFavoritos(int id) async {
//    var data = await http.get((Factory.internal().getUrl()+"cliente/$id/favoritos/"), headers: {'Accept': 'application/json'});
//    var jsonDataList = json.decode(utf8.decode(data.bodyBytes));
//    List<Parceiro> parceiros = [];
//
//    for (var p in jsonDataList) {
//      bool situacao;
//      if(p['situacao'].toString() == 'True'){
//        situacao =  true;
//      }else if((p['situacao'].toString() == 'False')){
//        situacao =  false;
//      }
//
//      Parceiro parceiro = Parceiro(p['pk'], p['nome'], p['razaoSocial'], p['imagemLogo'], p['imagemBackground'],
//          situacao, p['getestimativaEntrega'], p['getValoresEntrega'],p['seguimento'], p['descricao'],  p['proxAbertura']
//          , p['proxFechamento'],  p['aceitaCartao'], p['resultado_avaliacao'] + 0.0);
//      parceiros.add(parceiro);
////      print(parceiro.situacao);
//    }
//    return parceiros;
//  }

//  static Future<List<Parceiro>> listSeguimentos(String seguimento) async {
//    var data = await http.get((Factory.internal().getUrl()+"parceiros/$seguimento/"), headers: {'Accept': 'application/json'});
//    var jsonDataList = json.decode(utf8.decode(data.bodyBytes));
//    List<Parceiro> parceiros = [];
//
//    for (var p in jsonDataList) {
//      bool situacao;
//      if(p['situacao'].toString() == 'True'){
//        situacao =  true;
//      }else if((p['situacao'].toString() == 'False')){
//        situacao =  false;
//      }
//
//      Parceiro parceiro = Parceiro(p['pk'], p['nome'], p['razaoSocial'], p['imagemLogo'], p['imagemBackground'],
//          situacao, p['getestimativaEntrega'], p['getValoresEntrega'],p['seguimento'], p['descricao'],  p['proxAbertura']
//          , p['proxFechamento'],  p['aceitaCartao'], p['resultado_avaliacao'] + 0.0);
//      parceiros.add(parceiro);
//    }
//    return parceiros;
//  }

//  static Future<bool> isFavorito({int idcliente,int idparceiro}) async {
//    bool saida ;
//    var data = await http.get((Factory.internal().getUrl()+"testaFavorito/$idcliente/$idparceiro/"), headers: {'Accept': 'application/json'});
//    var jsondata = json.decode(utf8.decode(data.bodyBytes));
//
//
//    if (data.statusCode == 200){
//      saida = jsondata[0]['isFavorito'];
//    }else{
//      saida = false;
//    }
//    return saida;
//  }
}
