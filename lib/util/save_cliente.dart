import 'dart:io';
import 'dart:convert';
import 'package:appfastdelivery/helper/cliente.dart';
import 'package:path_provider/path_provider.dart';

class SaveCliente {
  final Cliente varCliente = null;

  SaveCliente();

  Future<File> get cliente async {
    Directory dir = await getApplicationDocumentsDirectory();
    File file = File(dir.path + "/cliente.json");

    if (!file.existsSync()) {
      file.writeAsString(json.encode(varCliente));
    }
    return file;
  }

  read() async {
    File file = await cliente;
//    print(file == null);
    String data = file.readAsStringSync();
//    print('clientecelular');
//    print('print ');
    return json.decode(data);
  }

  save(data) async {
    File file = await cliente;
    return file.writeAsString(json.encode(data));
  }
}
