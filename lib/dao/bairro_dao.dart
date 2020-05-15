//WALTERLY
import 'dart:convert';
import 'package:appfastdelivery/dao/singleton.dart';
import 'package:appfastdelivery/helper/endereco.dart';
import 'package:http/http.dart' as http;


class BairroDao{
  static final BairroDao _instance = BairroDao.internal();
  factory BairroDao() => _instance;
  BairroDao.internal();

  Future<List<Bairro>> list() async {
    var data = await http.get((Factory.internal().getUrl()+'bairros/'), headers: {'Accept': 'application/json'});
    var jsonDataList = json.decode(utf8.decode(data.bodyBytes));
    List<Bairro> bairros = [];

    for (var dado in jsonDataList) {
      Bairro bairro = Bairro(pk: dado['id'], descricao: dado['nome']);
      bairros.add(bairro);
//      print(parceiro.situacao);
    }
    return bairros;
  }

  Future<List<Bairro>> listActives(int idParceiro) async {
    var data = await http.get((Factory.internal().getUrl()+'parceiros/$idParceiro/entrega/'), headers: {'Accept': 'application/json'});
    var jsonDataList = json.decode(utf8.decode(data.bodyBytes));
    List<Bairro> bairros = List();
//    print(jsonDataList);
    for (var dado in jsonDataList) {

      Bairro bairro = Bairro(descricao: dado['getNome'], valorEntrega: dado['valor'] );
      bairros.add(bairro);
//      print(dado);
    }
//    for(Bairro b in bairros){
//      print(b.descricao);
//    }
    return bairros;
  }





}



