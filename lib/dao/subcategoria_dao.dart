import 'dart:convert';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:appfastdelivery/helper/categoria.dart';
import 'package:appfastdelivery/helper/subcategoria.dart';

import 'singleton.dart';


class SubCategoriaDao{

  static final SubCategoriaDao _instance = SubCategoriaDao.internal();
  factory SubCategoriaDao() => _instance;
  SubCategoriaDao.internal();





  Future<List<SubCategoria>> list(int id) async {
//    print(id);
    var data = await http.get((Factory.internal().getUrl()+'categorias/$id/subcategorias/'), headers: {'Accept': 'application/json'});
    var jsonDataList = json.decode(utf8.decode(data.bodyBytes));
    List<SubCategoria> subCategorias = List();

//    print(jsonDataList);
    for (var jsonData in jsonDataList) {
      SubCategoria subCategoria = SubCategoria(jsonData['pk'], jsonData['descricao'], jsonData['imagem'], jsonData['status']);
      subCategorias.add(subCategoria);
    }

//    for (SubCategoria c in subCategorias) {
//      print("subcategoria: "+c.descricao);
//    }
    return subCategorias;
  }


//  Future<List<SubCategoria>> list(int id) async {
//    List<SubCategoria> categorias = [];
//    categorias.add(SubCategoria(1, "BEIRUTES", NetworkImage('https://cdn.pixabay.com/photo/2014/04/10/10/06/bird-320779_960_720.jpg').url, true));
//    categorias.add(SubCategoria(1, "BEBIDAS", NetworkImage('https://cdn.pixabay.com/photo/2014/04/10/10/06/bird-320779_960_720.jpg').url, true));
//    categorias.add(SubCategoria(1, "TÍPICOS", NetworkImage('https://cdn.pixabay.com/photo/2014/04/10/10/06/bird-320779_960_720.jpg').url, true));
//    categorias.add(SubCategoria(1, "BEIRUTES", NetworkImage('https://cdn.pixabay.com/photo/2014/04/10/10/06/bird-320779_960_720.jpg').url, true));
//    categorias.add(SubCategoria(1, "BEBIDAS", NetworkImage('https://cdn.pixabay.com/photo/2014/04/10/10/06/bird-320779_960_720.jpg').url, true));
//    categorias.add(SubCategoria(1, "TÍPICOS", NetworkImage('https://cdn.pixabay.com/photo/2014/04/10/10/06/bird-320779_960_720.jpg').url, true));
//    categorias.add(SubCategoria(1, "BEIRUTES", NetworkImage('https://cdn.pixabay.com/photo/2014/04/10/10/06/bird-320779_960_720.jpg').url, true));
//    categorias.add(SubCategoria(1, "BEBIDAS", NetworkImage('https://cdn.pixabay.com/photo/2014/04/10/10/06/bird-320779_960_720.jpg').url, true));
//    categorias.add(SubCategoria(1, "TÍPICOS", NetworkImage('https://cdn.pixabay.com/photo/2014/04/10/10/06/bird-320779_960_720.jpg').url, true));
//    categorias.add(SubCategoria(1, "BEIRUTES", NetworkImage('https://cdn.pixabay.com/photo/2014/04/10/10/06/bird-320779_960_720.jpg').url, true));
//    categorias.add(SubCategoria(1, "BEBIDAS", NetworkImage('https://cdn.pixabay.com/photo/2014/04/10/10/06/bird-320779_960_720.jpg').url, true));
//    categorias.add(SubCategoria(1, "TÍPICOS", NetworkImage('https://cdn.pixabay.com/photo/2014/04/10/10/06/bird-320779_960_720.jpg').url, true));
//    categorias.add(SubCategoria(1, "BEIRUTES", NetworkImage('https://cdn.pixabay.com/photo/2014/04/10/10/06/bird-320779_960_720.jpg').url, true));
//    categorias.add(SubCategoria(1, "BEBIDAS", NetworkImage('https://cdn.pixabay.com/photo/2014/04/10/10/06/bird-320779_960_720.jpg').url, true));
//    categorias.add(SubCategoria(1, "TÍPICOS", NetworkImage('https://cdn.pixabay.com/photo/2014/04/10/10/06/bird-320779_960_720.jpg').url, true));
//    categorias.add(SubCategoria(1, "BEIRUTES", NetworkImage('https://cdn.pixabay.com/photo/2014/04/10/10/06/bird-320779_960_720.jpg').url, true));
//    categorias.add(SubCategoria(1, "BEBIDAS", NetworkImage('https://cdn.pixabay.com/photo/2014/04/10/10/06/bird-320779_960_720.jpg').url, true));
//    categorias.add(SubCategoria(1, "TÍPICOS", NetworkImage('https://cdn.pixabay.com/photo/2014/04/10/10/06/bird-320779_960_720.jpg').url, true));
//
//
//    return categorias;
//  }





}



