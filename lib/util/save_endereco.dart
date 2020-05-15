import 'dart:io';
import 'dart:convert';
import 'package:appfastdelivery/helper/pedido.dart';
import 'package:path_provider/path_provider.dart';

class SaveEndereco {
  final Endereco enderecoCliente;

  SaveEndereco({this.enderecoCliente});

  Future<File> get endereco async {
    Directory dir = await getApplicationDocumentsDirectory();
    File file = File(dir.path + "/endereco.json");

    if (!file.existsSync()) {
      file.writeAsString('');
    }
    return file;
  }
//  Future<File> _getFile() async {
//    final directory = await getApplicationDocumentsDirectory();
//    return File("${directory.path}/data.json");
//  }


  Future<String> readData() async {
    try{
      File file = await endereco;
      return file.readAsString();
    }catch(exception){
      return null;
    }
  }
   read() async {
    try{
      File file = await endereco;
      return json.decode(file.readAsStringSync());
    }catch(exception){
      return null;
    }
  }


  save(data) async {
    File file = await endereco;
    return file.writeAsString(json.encode(data));
  }
}
