import 'dart:convert';

import 'package:appfastdelivery/helper/carrinho.dart';
import 'package:appfastdelivery/helper/cliente.dart';
import 'package:appfastdelivery/helper/forma_pagamento.dart';
import 'package:appfastdelivery/helper/parceiro.dart';
import 'package:appfastdelivery/util/save_cliente.dart';
import 'package:appfastdelivery/util/save_endereco.dart';

import 'save_local.dart';
import 'package:appfastdelivery/helper/pedido.dart';

abstract class Session {
  static int _idParceiro;
  static Cliente _cliente;
  static Parceiro _parceiro;
  static String _token;
  static String _nomeParceiro;
  static String _imageParceiro;
  static List<ItemCarrinho> _listaItens = [];
  static Endereco _enderecoCliente;
  static SaveLocal _persistence = null;
  static Pedido _pedido = null;
  static FormaPagamento _formaPagamento;

  static void setParceiro(Parceiro parceiro) {
    _parceiro = parceiro;
  }

  static Parceiro getParceiro() {
    return _parceiro;
  }

//  static void setImageParceiro(String image){
//    _imageParceiro = image;
//  }
//  static String getImageParceiro(){
//    return _imageParceiro;
//  }
//  static String getNomeParceiro(){
//    return _nomeParceiro;
//  }
//  static void setNomeParceiro(String nome){
//    _nomeParceiro = nome;
//  }

  static int getIdParceiro() {
    return _idParceiro;
  }

  static void setIdParceiro(int id) {
    _idParceiro = id;
    if (_persistence == null) {
//      print('new save local');
      _persistence = new SaveLocal(itensList: _listaItens);
    }
    _persistence.read(id).then((data) {
//      print('CARREGANDO DADOS');
      List<ItemCarrinho> novaLista = [];
      for (dynamic dado in data) {
        novaLista.add(ItemCarrinho.fromJson(dado));
//        print(dado);
      }
      _listaItens = novaLista;
//      print('DADOS CARREGADOS');
    });
  }

  static void setFormaPagamento(FormaPagamento formaPagamento) {
    _formaPagamento = formaPagamento;
  }

  static FormaPagamento getFormaPagamento() {
    return _formaPagamento;
  }

  static void setPedido(Pedido pedido) {
    _pedido = pedido;
    _pedido.tipo = 'tipo';
    _pedido.situacao = 'situacao';
    _pedido.status = 'status';
    _pedido.pagamentosPedido = List<FormasPagamentoPedido>();
    _pedido.itens = List<ItemPedido>();
    _pedido.valorEntrega = 0.00;
  }

  static Pedido getPedido() {
    if (_pedido == null) {
      _pedido = Pedido.instance();
      _pedido.tipo = 'tipo';
      _pedido.situacao = 'situacao';
      _pedido.status = 'status';
      _pedido.pagamentosPedido = List<FormasPagamentoPedido>();
      _pedido.itens = List<ItemPedido>();
      _pedido.valorEntrega = 0.00;
    }
    return _pedido;
  }

  static void setToken(String token) {
    _token = token;
  }

  static String getToken() {
    return _token;
  }

  static SaveLocal getPersistence() {
    if (_persistence == null) {
      _persistence = new SaveLocal(itensList: _listaItens);
    }
    return _persistence;
  }

  static List<ItemCarrinho> getListaItens() {
    return _listaItens;
  }

  static void setListaItens(List<ItemCarrinho> itens) {
    _listaItens = itens;
  }

  static Future<List<ItemCarrinho>> getCarrinho(int idParceiro) async {
    if (_persistence == null) {
      _persistence = new SaveLocal(itensList: _listaItens);
    }
    List<ItemCarrinho> lista = List();
    var dados;
    dynamic values;

    await _persistence.readData(idParceiro).whenComplete(() {
//      print('LOG[ParceiroPage]:  carrinho - iniciou');
    }).then((data) {
      dados = json.decode(data);
//      print('LOG[ParceiroPage]:  carrinho - carregando');
    }).whenComplete(() {
      for (dynamic dado in dados) {
        lista.add(ItemCarrinho.fromJson(dado));
      }
//      print('LOG[EnderecoPage]:  carrinho - finalizou');
    });
    return lista;
  }

  static Cliente getCliente() {
    if (_cliente == null) {
      SaveCliente persistence = SaveCliente();
      persistence.read().then((data) {
        _cliente = Cliente.fromJson(data);
        return _cliente;
      });
    } else {
      return _cliente;
    }
  }

  static Future<Cliente> getCliente2() async {
    if (_cliente == null) {
      SaveCliente persistence = SaveCliente();
      var read = await persistence.read();
      _cliente = Cliente.fromJson(read);
    }
    return _cliente;
  }

  static void setCliente(Cliente client) {
    _cliente = client;
    SaveCliente persistence = SaveCliente();
    persistence.save(_cliente);
  }

  static void clearCliente() {
    _cliente = null;
    SaveCliente persistence = SaveCliente();
    persistence.save(_cliente);
  }

  static void logout() {
    SaveCliente persistence = SaveCliente();
    persistence.clear();
  }

  static Endereco getEnderecoCiente() {
    return _enderecoCliente;
  }

  static Future<Endereco> getEnderecoCienteInFuture() async {
    if (_enderecoCliente == null) {
      Endereco endereco;
      var dados;
      SaveEndereco persistence = SaveEndereco();
      await persistence.readData().then((value) {
        dados = json.decode(value);
      }).whenComplete(() {
//        print(dados);
        if (dados.toString() != '[]') {
          endereco = Endereco.fromJson(dados);
          _enderecoCliente = endereco;
        }
      });
    }
    return _enderecoCliente;
  }

  static void saveEnderecoCiente(Endereco endereco) {
//    _enderecoCliente = endereco;
    SaveEndereco persistence = SaveEndereco();
    persistence.save(_enderecoCliente);
  }

  static void clearEnderecoCliente() {
    _enderecoCliente = null;
    SaveEndereco persistence = SaveEndereco();
    persistence.save('');
  }

  static void setEnderecoCiente(Endereco endereco) {
    _enderecoCliente = endereco;
  }
}
