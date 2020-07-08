import 'dart:convert';
import 'dart:async';
import 'package:appfastdelivery/helper/favorito.dart';
import 'package:http/http.dart' as http;
import 'package:appfastdelivery/dao/singleton.dart';
import 'package:appfastdelivery/helper/parceiro.dart';

class ParceiroDao {
  static final ParceiroDao _instance = ParceiroDao.internal();

  factory ParceiroDao() => _instance;

  ParceiroDao.internal();

  Future<List<Parceiro>> list(int idCidade) async {
    var data = await http.get(
        (Factory.internal().getUrl() + 'cidade/$idCidade/parceiros/'),
        headers: {'Accept': 'application/json'});
    var jsonDataList = json.decode(utf8.decode(data.bodyBytes));
    List<Parceiro> parceiros = [];

    for (var p in jsonDataList) {
      bool situacao;
      if (p['situacao'].toString() == 'True') {
        situacao = true;
      } else if ((p['situacao'].toString() == 'False')) {
        situacao = false;
      }

      Parceiro parceiro = Parceiro(
          p['pk'],
          p['nome'],
          p['razaoSocial'],
          p['imagemLogo'],
          p['imagemBackground'],
          situacao,
          p['getestimativaEntrega'],
          p['getValoresEntrega'],
          p['seguimento'],
          p['descricao'],
          p['proxAbertura'],
          p['proxFechamento'],
          p['aceitaCartao'],
          p['resultado_avaliacao'] + 0.0,
          p['porcentagemCartao'] == null ? 0.0 : p['porcentagemCartao'],
          p['permitir_retirada_estabelecimento'],
          p['url']);
      parceiros.add(parceiro);
    }
    return parceiros;
  }

  Future<List<Parceiro>> listSeguimentos(
      int idCidade, String seguimento) async {
    var data = await http.get(
        (Factory.internal().getUrl() +
            "cidade/$idCidade/parceiros/$seguimento/"),
        headers: {'Accept': 'application/json'});
    var jsonDataList = json.decode(utf8.decode(data.bodyBytes));
    List<Parceiro> parceiros = [];

    for (var p in jsonDataList) {
      bool situacao;
      if (p['situacao'].toString() == 'True') {
        situacao = true;
      } else if ((p['situacao'].toString() == 'False')) {
        situacao = false;
      }

      Parceiro parceiro = Parceiro(
          p['pk'],
          p['nome'],
          p['razaoSocial'],
          p['imagemLogo'],
          p['imagemBackground'],
          situacao,
          p['getestimativaEntrega'],
          p['getValoresEntrega'],
          p['seguimento'],
          p['descricao'],
          p['proxAbertura'],
          p['proxFechamento'],
          p['aceitaCartao'],
          p['resultado_avaliacao'] + 0.0,
          p['porcentagemCartao'] == null ? 0.0 : p['porcentagemCartao'],
          p['permitir_retirada_estabelecimento'],
          p['url']);
      parceiros.add(parceiro);
    }
    return parceiros;
  }

  Future<List<Parceiro>> listFavoritos(int id) async {
    var data = await http.get(
        (Factory.internal().getUrl() + "cliente/$id/favoritos/"),
        headers: {'Accept': 'application/json'});
    var jsonDataList = json.decode(utf8.decode(data.bodyBytes));
    List<Parceiro> parceiros = [];

    for (var p in jsonDataList) {
      bool situacao;
      if (p['situacao'].toString() == 'True') {
        situacao = true;
      } else if ((p['situacao'].toString() == 'False')) {
        situacao = false;
      }

      Parceiro parceiro = Parceiro(
          p['pk'],
          p['nome'],
          p['razaoSocial'],
          p['imagemLogo'],
          p['imagemBackground'],
          situacao,
          p['getestimativaEntrega'],
          p['getValoresEntrega'],
          p['seguimento'],
          p['descricao'],
          p['proxAbertura'],
          p['proxFechamento'],
          p['aceitaCartao'],
          p['resultado_avaliacao'] + 0.0,
          p['porcentagemCartao'] == null ? 0.0 : p['porcentagemCartao'],
          p['permitir_retirada_estabelecimento'],
          p['url']);
      parceiros.add(parceiro);
    }
    return parceiros;
  }

  Future<bool> isFavorito({int idcliente, int idparceiro}) async {
    bool saida;
    var data = await http.get(
        (Factory.internal().getUrl() + "testaFavorito/$idcliente/$idparceiro/"),
        headers: {'Accept': 'application/json'});
    var jsondata = json.decode(utf8.decode(data.bodyBytes));

    if (data.statusCode == 200) {
      try {
        saida = jsondata[0]['isFavorito'];
      } catch (erro) {
        saida = false;
      }
    } else {
      saida = false;
    }
    return saida;
  }

  Future<bool> favoritar({Favorito favorito}) async {
    bool saida;
    http.Client client = http.Client();

    dynamic data = await client.post(
        Factory.internal().getUrl() + "cliente/favorito/",
        headers: {"Content-Type": "application/json"},
        body: json.encode(favorito));

//    var jsondata = json.decode(utf8.decode(data.bodyBytes));
    if (data.statusCode == 201) {
      saida = true;
    } else {
      saida = false;
    }
    return saida;
  }
}
