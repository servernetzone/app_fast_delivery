import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

class SaveLocal {
  final List itensList;
  int id;

  SaveLocal({this.itensList});

  Future<File> get carrinho async {
    Directory dir = await getApplicationDocumentsDirectory();
    File file = File(dir.path + "/$id.json");

    if (!file.existsSync()) {
      file.writeAsString(json.encode(List()));
    }
    return file;
  }

  read(id) async {
    try{
      this.id = id;

      File file = await carrinho;
//    print(file == null);
      String data = file.readAsStringSync();
      return json.decode(data);
    }catch(exception){
      return List();
    }

  }
  Future<String> readData(id) async {
    try{
      this.id = id;
      File file = await carrinho;
      return file.readAsString();
    }catch(exception){
      return null;
    }

  }

  save(data,id) async {
    this.id = id;
    File file = await carrinho;
    return file.writeAsString(json.encode(data));
  }
}
