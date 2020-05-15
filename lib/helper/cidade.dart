import 'endereco.dart';

class Cidade {
   int id;
   String descricao;
   List<Bairro> bairros = List();

   Cidade(this.id, this.descricao, this.bairros);
   Cidade.internal();
}