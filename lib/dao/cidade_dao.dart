//WALTERLY
import 'dart:convert';
import 'package:appfastdelivery/dao/singleton.dart';
import 'package:appfastdelivery/helper/cidade.dart';
import 'package:appfastdelivery/helper/endereco.dart';
import 'package:http/http.dart' as http;


class CidadeDao{
  static final CidadeDao _instance = CidadeDao.internal();
  factory CidadeDao() => _instance;
  CidadeDao.internal();

  Future<Cidade> get(String city) async {
    List<Bairro> bairros = List();
    Cidade cidade = null;

    var data = await http.get((Factory.internal().getUrl()+'${city.toUpperCase()}/bairros/'), headers: {'Accept': 'application/json'});
    var jsonData = json.decode(utf8.decode(data.bodyBytes));

//    print('LOG[dao]: olha aki: ${jsonData.toString()}');

    if(data.statusCode < 200 || data.statusCode >= 400 || data.statusCode == null){
//      print('é zero');
    }
    if(jsonData.toString() != '[]'){
      for(var dado in jsonData[0]['bairros']){
        Bairro bairro = Bairro(pk: dado['id'], descricao: dado['nome']);
        bairros.add(bairro);
      }

       cidade = Cidade(jsonData[0]['pk'], jsonData[0]['nome'], bairros);

    }
    return cidade;




//    for (var dado in jsonDataList) {
//        print(parceiro.situacao);
//    }
//    print('LOG[dao]: cidade ${cidade.descricao}');
//    for (Bairro b in cidade.bairros) {
//      print('LOG[dao]: bairro -  ${b.descricao}');
//    }


  }






}



