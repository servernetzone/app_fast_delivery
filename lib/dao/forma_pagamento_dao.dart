//WALTERLY
import 'dart:convert';

import 'package:appfastdelivery/dao/singleton.dart';
import 'package:appfastdelivery/helper/forma_pagamento.dart';
import 'package:http/http.dart' as http;

class FormaPagamentoDao{
  static final FormaPagamentoDao _instance = FormaPagamentoDao.internal();
  factory FormaPagamentoDao() => _instance;
  FormaPagamentoDao.internal();

  Future<List<FormaPagamento>> list(int id) async {
    var data = await http.get((Factory.internal().getUrl()+'parceiros/$id/formasdepagamento/'), headers: {'Accept': 'application/json'});
    var jsonDataList = json.decode(utf8.decode(data.bodyBytes));
    List<FormaPagamento> formasPagamento = List();

    for (var data in jsonDataList) {
      FormaPagamento formaPagamento = FormaPagamento(data['pk'], data['formapagamentodisponivel']['descricao'], data['formapagamentodisponivel']['imagem'], data['formapagamentodisponivel']['tipo']);
      formasPagamento.add(formaPagamento);
    }

    return formasPagamento;
  }




}