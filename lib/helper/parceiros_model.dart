import 'package:appfastdelivery/dao/parceiro_dao.dart';
import 'package:appfastdelivery/helper/parceiro.dart';
import 'package:appfastdelivery/util/session.dart';
import 'package:flutter/material.dart';

class ParceirosModel extends ChangeNotifier {
  List<Parceiro> parceiros = [];

  Future<List<Parceiro>> getParceiros() async {
    parceiros = [];
    notifyListeners();
    parceiros = await ParceiroDao().list(Session.getEnderecoCiente().idCidade);
    notifyListeners();
    return parceiros;
  }
}
