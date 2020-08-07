import 'dart:io';
import 'dart:convert' as convert;
import 'package:appfastdelivery/helper/cliente.dart';
import 'package:appfastdelivery/util/prefs.dart';
import 'package:path_provider/path_provider.dart';

class SaveCliente {
  final Cliente varCliente = null;

  SaveCliente();

  Future<File> get cliente async {
    Directory dir = await getApplicationDocumentsDirectory();
    File file = File(dir.path + "/cliente.json");

    if (!file.existsSync()) {
      file.writeAsString(convert.json.encode(varCliente));
    }
    return file;
  }

  read() async {
    String json = await Prefs.getString('cliente.prefs');
    if (json.isEmpty) {
      return null;
    }
    return convert.json.decode(json);
//    File file = await cliente;
//
//    String data = file.readAsStringSync();
//    return convert.json.decode(data);
  }

  void clear() {
    Prefs.setString('cliente.prefs', '');
  }

  save(data) async {
    String json = convert.json.encode(data);

    Prefs.setString('cliente.prefs', json);
//    File file = await cliente;
//    return file.writeAsString(json.encode(data));
  }
}
