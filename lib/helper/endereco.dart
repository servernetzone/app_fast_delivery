//WALTERLY

class Bairro{
  int pk;
  String descricao;
  String valorEntrega;

  Bairro({this.pk, this.descricao, this.valorEntrega});
  Bairro.instance();
}



class EnderecoPedido {
  String rua = '';
  int numero = 0;
  String bairro = '';
  String cep = '00000-000';
  String cidade = '';
  String estado = '';
  String uf = '';
  String referencia = '';
  String observacao = '';



  @override
  String toString() {
    return 'Endereco{rua: $rua, numero: $numero, bairro: $bairro, cep: $cep, cidade: $cidade, estado: $estado, uf: $uf, referencia: $referencia, observacao: $observacao}';
  }
}