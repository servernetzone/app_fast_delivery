import 'package:appfastdelivery/dao/parceiro_dao.dart';
import 'package:appfastdelivery/helper/parceiro.dart';
import 'package:appfastdelivery/util/session.dart';
import 'package:flutter/material.dart';

class FavoritosModel extends ChangeNotifier{
  List<Parceiro> parceirosFavoritos = [];

  Future<List<Parceiro>> getParceirosFavoritos()async{
    parceirosFavoritos = await ParceiroDao.internal().listFavoritos(Session.getCliente().id);
    notifyListeners();
    return parceirosFavoritos;
  }
}