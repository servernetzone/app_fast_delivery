import 'dart:convert';
import 'package:appfastdelivery/dao/singleton.dart';
import 'package:appfastdelivery/helper/cliente.dart';
import 'package:http/http.dart' as http;

class ClienteDao{
  static final ClienteDao _instance = ClienteDao.internal();
  factory ClienteDao() => _instance;
  ClienteDao.internal();


  Future<Map<String, dynamic>> alterarSenha({int id, String senhaAntiga, String novaSenha}) async {
    http.Client client = http.Client();
    print("alterarSenha");
    String request = json.encode({
      "cliente": id,
      "senha_antiga": senhaAntiga,
      "nova_senha": novaSenha
    });
    print("request: $request");
    var data = await client.post(Factory.internal().getUrl() +"cliente/alterar_senha/",
        headers: {"Content-Type": "application/json"},
        body: request);
    print("response: ${data.body}");
    var response = json.decode(utf8.decode(data.bodyBytes));
    print('resposta: $response');
    return response;
  }


  Future<Map<String, dynamic>> recuperarSenha({String login}) async {
    http.Client client = http.Client();
    print("recuperarSenha");
    String request = json.encode({"username": login});
    print("request: $request");
    var data = await client.post(Factory.internal().getUrl() +"cliente/recuperar_senha/",
        headers: {"Content-Type": "application/json"},
        body: request);
    print("response: ${data.body}");
    var response = json.decode(utf8.decode(data.bodyBytes));
    print('resposta: $response');
    return response;
  }


  Future<Map<String, dynamic>> fazerLogin({String login, String senha}) async {
    http.Client client = http.Client();
    String request = json.encode({"username": login, "password": senha});
    print("request: $request");

    var data = await client.post(Factory.internal().getUrl() +"cliente/login/",
        headers: {"Content-Type": "application/json"},
        body: request);
    print("response: ${data.body}");
    var jsondata = json.decode(utf8.decode(data.bodyBytes));
    print('resposta: ${jsondata}');
    return jsondata;
  }


 Future<Map<String, dynamic>> sendCliente({Cliente cliente}) async {
    try{
      http.Client client = http.Client();
      print("sendCliente");
      String request = json.encode(cliente);
      print("request: $request");
      var data = await client.post(Factory.internal().getUrl() +"cliente/novocliente/",
          headers: {"Content-Type": "application/json"},
          body: request);
      print('data: ${data.body}');
      var response = json.decode(utf8.decode(data.bodyBytes));
      print('response: $response');
      return response;
    }catch(e){
      return <String, dynamic> {'status': 'fail', 'resposta': 'Não foi possível cadastrar seus dados. Tente novamente mais tarde'};
    }
  }


 Future<Map<String, dynamic>> editCliente({Cliente cliente}) async {
    http.Client client = http.Client();
    print("editCliente");
    String request = json.encode({"username": cliente.login, "password": cliente.senha, "id": cliente.id, "nome": cliente.nome});
    print("request: $request");
    http.Response data = await client.patch(Factory.internal().getUrl() +"cliente/update_login_cliente/",
        headers: {"Content-Type": "application/json"},
        body: request);

    print('data.body: ${data.body}');
    var jsonData = json.decode(utf8.decode(data.bodyBytes));
    print('response: $jsonData');
    return jsonData;
  }

  Future<Map<String, dynamic>> getVersion() async {
    http.Client client = http.Client();
    var data = await client.get(Factory.internal().getUrl() +"versionamento/1/",
        headers: {"Content-Type": "application/json"});
    print("response: ${data.body}");
    var response = json.decode(utf8.decode(data.bodyBytes));
//    print('resposta: ${response[0]}');
    return response[0] ?? {};
  }


  Future<Map<String, dynamic>> getClientFromPhone({String telefone}) async {
    http.Client client = http.Client();
    http.Response data = await client.get(Factory.internal().getUrl() +"buscacliente2/$telefone/",
        headers: {"Content-Type": "application/json"});

    print('LOG[ClienteDao.getClientFromPhone] data.body: ${data.body}');
    var jsonData = json.decode(utf8.decode(data.bodyBytes));
    print('LOG[ClienteDao.getClientFromPhone] jsonData:: $jsonData');
    return jsonData;
  }

  Future<Map<String, dynamic>> getSaldo(int idCliente) async {
    http.Client client = http.Client();
    http.Response data = await client.get(Factory.internal().getUrl() +"cliente/saldo/$idCliente/",
        headers: {"Content-Type": "application/json"});

    print('LOG[ClienteDao.getSaldo] data.body: ${data.body}');
    var jsonData = json.decode(utf8.decode(data.bodyBytes));
    print('LOG[ClienteDao.getSaldo] jsonData:: $jsonData');
    return jsonData;
  }

  Future<Cliente> updateToken(int idCliente, String token) async {
    Cliente saida;
    http.Client client = http.Client();
    var body = json.encode({"token": token});

    dynamic data = await client.patch(Factory().getUrl() + "cliente/$idCliente/",
        headers: {"Content-Type": "application/json"},
        body: body);
    print('JsonUtils.updateToken: data.statusCode - ${data.statusCode}');
    print('JsonUtils.updateToken:   data.body - ${data.body}');
    var jsondata = json.decode(utf8.decode(data.bodyBytes));
    print('JsonUtils.updateToken:   jsondata - ${jsondata}');
    if (data.statusCode < 200 ||
        data.statusCode >= 400 ||
        data.statusCode == null) {
      saida = null;
    } else {
      print('JsonUtils.updateToken: jsondata - ${jsondata}');
      saida = Cliente.fromJson(jsondata);
    }
    return saida;
  }






}