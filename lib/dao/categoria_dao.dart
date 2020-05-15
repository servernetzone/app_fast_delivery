import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:appfastdelivery/dao/singleton.dart';
import 'package:appfastdelivery/helper/categoria.dart';


class CategoriaDao{

  static final CategoriaDao _instance = CategoriaDao.internal();
  factory CategoriaDao() => _instance;
  CategoriaDao.internal();



  Future<List<Categoria>> list(int id) async {
//    print(id);
      var data = await http.get((Factory.internal().getUrl()+'parceiros/$id/'), headers: {'Accept': 'application/json'});
      var jsonDataList = json.decode(utf8.decode(data.bodyBytes))[0]["categorias"];
      List<Categoria> categorias = List();

//    print(jsonDataList);
      for (var jsonData in jsonDataList) {
        Categoria categoria = Categoria(jsonData['pk'], jsonData['descricao'], jsonData['imagem'], jsonData['status'], jsonData['PossuiCategorias']);
//        print(categoria.descricao);
        categorias.add(categoria);
      }
//
//    for (Categoria c in categorias) {
//      print(c.descricao);
//    }

      return categorias;
  }
//  Future<List<Categoria>> list() async {
//    List<Categoria> categorias = [];
//    categorias.add(Categoria("BEIRUTES", NetworkImage('https://cdn.pixabay.com/photo/2014/04/10/10/06/bird-320779_960_720.jpg').url));
//
//    categorias.add(Categoria("BEBIDAS", NetworkImage('https://cdn.pixabay.com/photo/2014/04/10/10/06/bird-320779_960_720.jpg').url));
//    categorias.add(Categoria("BEBIDAS", NetworkImage('https://cdn.pixabay.com/photo/2014/04/10/10/06/bird-320779_960_720.jpg').url));
//    categorias.add(Categoria("BEBIDAS", NetworkImage('https://cdn.pixabay.com/photo/2014/04/10/10/06/bird-320779_960_720.jpg').url));
//    categorias.add(Categoria("BEBIDAS", NetworkImage('https://cdn.pixabay.com/photo/2014/04/10/10/06/bird-320779_960_720.jpg').url));
//    categorias.add(Categoria("BEBIDAS", NetworkImage('https://cdn.pixabay.com/photo/2014/04/10/10/06/bird-320779_960_720.jpg').url));
//    categorias.add(Categoria("BEIRUTES", NetworkImage('https://cdn.pixabay.com/photo/2014/04/10/10/06/bird-320779_960_720.jpg').url));
//
//    categorias.add(Categoria("BEBIDAS", NetworkImage('https://cdn.pixabay.com/photo/2014/04/10/10/06/bird-320779_960_720.jpg').url));
//    categorias.add(Categoria("BEBIDAS", NetworkImage('https://cdn.pixabay.com/photo/2014/04/10/10/06/bird-320779_960_720.jpg').url));
//    categorias.add(Categoria("BEBIDAS", NetworkImage('https://cdn.pixabay.com/photo/2014/04/10/10/06/bird-320779_960_720.jpg').url));
//    categorias.add(Categoria("BEBIDAS", NetworkImage('https://cdn.pixabay.com/photo/2014/04/10/10/06/bird-320779_960_720.jpg').url));
//    categorias.add(Categoria("BEBIDAS", NetworkImage('https://cdn.pixabay.com/photo/2014/04/10/10/06/bird-320779_960_720.jpg').url));
//    categorias.add(Categoria("BEIRUTES", NetworkImage('https://cdn.pixabay.com/photo/2014/04/10/10/06/bird-320779_960_720.jpg').url));
//
//    categorias.add(Categoria("BEBIDAS", NetworkImage('https://cdn.pixabay.com/photo/2014/04/10/10/06/bird-320779_960_720.jpg').url));
//    categorias.add(Categoria("BEBIDAS", NetworkImage('https://cdn.pixabay.com/photo/2014/04/10/10/06/bird-320779_960_720.jpg').url));
//    categorias.add(Categoria("BEBIDAS", NetworkImage('https://cdn.pixabay.com/photo/2014/04/10/10/06/bird-320779_960_720.jpg').url));
//    categorias.add(Categoria("BEBIDAS", NetworkImage('https://cdn.pixabay.com/photo/2014/04/10/10/06/bird-320779_960_720.jpg').url));
//    categorias.add(Categoria("BEBIDAS", NetworkImage('https://cdn.pixabay.com/photo/2014/04/10/10/06/bird-320779_960_720.jpg').url));categorias.add(Categoria("BEIRUTES", NetworkImage('https://cdn.pixabay.com/photo/2014/04/10/10/06/bird-320779_960_720.jpg').url));
//
//    categorias.add(Categoria("BEBIDAS", NetworkImage('https://cdn.pixabay.com/photo/2014/04/10/10/06/bird-320779_960_720.jpg').url));
//    categorias.add(Categoria("BEBIDAS", NetworkImage('https://cdn.pixabay.com/photo/2014/04/10/10/06/bird-320779_960_720.jpg').url));
//    categorias.add(Categoria("BEBIDAS", NetworkImage('https://cdn.pixabay.com/photo/2014/04/10/10/06/bird-320779_960_720.jpg').url));
//    categorias.add(Categoria("BEBIDAS", NetworkImage('https://cdn.pixabay.com/photo/2014/04/10/10/06/bird-320779_960_720.jpg').url));
//    categorias.add(Categoria("BEBIDAS", NetworkImage('https://cdn.pixabay.com/photo/2014/04/10/10/06/bird-320779_960_720.jpg').url));
//
//    return categorias;
//  }





}



