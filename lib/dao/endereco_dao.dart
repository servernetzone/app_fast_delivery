//WALTERLY
import 'dart:convert';
import 'package:appfastdelivery/dao/singleton.dart';
import 'package:appfastdelivery/helper/endereco.dart';
import 'package:appfastdelivery/helper/pedido.dart';
import 'package:http/http.dart' as http;


class EnderecoDao{
  static final EnderecoDao _instance = EnderecoDao.internal();
  factory EnderecoDao() => _instance;
  EnderecoDao.internal();

  Future<Endereco> get(int idParceiro) async {
    var data = await http.get((Factory.internal().getUrl()+'parceiros/$idParceiro/endereco/'), headers: {'Accept': 'application/json'});
    var jsonData = json.decode(utf8.decode(data.bodyBytes));
//  List<Endereco> enderecos = [];

//    for (var p in jsonDataList) {
      Endereco endereco = Endereco.fromJson(jsonData[0]);
//      enderecos.add(endereco);
//      print(parceiro.situacao);

    return endereco;
  }

//RETORNA A LISTA DE ENDEREÇOS DO CLIENTE A PARTIR DA PK DO MESMO.



  Future<List<Endereco>> list(int idCliente) async {
    var data = await http.get((Factory.internal().getUrl()+'cliente/$idCliente/enderecos/'), headers: {'Accept': 'application/json'});
    var jsonDataList = json.decode(utf8.decode(data.bodyBytes));

//    print(jsonDataList);
    List<Endereco> enderecos = List();

    for (var jsonData in jsonDataList) {
      Endereco endereco = Endereco.fromJson(jsonData);
//      endereco.id = data['id'];
//      endereco.rua =  data['rua'];
//      endereco.numero = data['numero'];
//      endereco.bairro =  data['bairro'];
//      endereco.cep = data['cep'];
//      endereco.cidade = data['nomecidade'];
//      endereco.referencia = data['referencia'];
//      endereco.observacao = data['observacao'];
//      endereco.idCidade = data['cidade'];

      enderecos.add(endereco);
    }

//    for(Endereco e in enderecos){
//      print(e.rua);
//    }

    return enderecos;
  }


  Future<List<EnderecoCliente>> listEnderecosCliente(int idCliente) async {
    var data = await http.get((Factory.internal().getUrl()+'cliente/$idCliente/enderecos/'), headers: {'Accept': 'application/json'});
    var jsonDataList = json.decode(utf8.decode(data.bodyBytes));
    List<EnderecoCliente> enderecos = List();
    for (var jsonData in jsonDataList) {
      EnderecoCliente enderecoCliente = EnderecoCliente.fromJson(jsonData);
//      print(enderecoCliente.rua);
//      print(enderecoCliente.id);
//      print(enderecoCliente.idCliente);
//      print(enderecoCliente.idCidade);
//      print(enderecoCliente.nomeCidade);
      enderecos.add(enderecoCliente);
    }

    return enderecos;
  }

  Future<List<String>> novoEndereco({EnderecoCliente endereco}) async {
    bool saida ;
    http.Client client = http.Client();
    var json2 =  json.encode(endereco);

    print(json2);

    dynamic data = await client.post(Factory.internal().getUrl() +"cliente/novoEndereco/",
        headers: {"Content-Type": "application/json"},
        body: json2);


    var jsondata = json.decode(utf8.decode(data.bodyBytes));
    String resposta = jsondata['resposta'];
    print('resposta: ${resposta}');
    List<String> mensagens = List<String>();
    mensagens.add(resposta);
    if (data.statusCode < 200 || data.statusCode >= 400 || data.statusCode == null){
      mensagens.add(jsondata['motivo']);
      print(jsondata['motivo']);
      return mensagens;
    }else{
//      mensagens.add('');
      mensagens.add('Salvo com sucesso!!');
      return mensagens;
    }
  }






}



