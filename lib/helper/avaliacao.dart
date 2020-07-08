
class Avaliacao {
  int id;
  String descricao;
  String tipo;
  List<Comentario> comentarios;

  Avaliacao(
      this.id,
      this.descricao,
      this.tipo,
      this.comentarios
      );
  Avaliacao.instance();

}

class Comentario{
  int id;
  String descricao;
  int ponto;
  bool ativo = false;
  bool marcado = false;


  Comentario(
      this.id,
      this.descricao,
      this.ponto);
  Comentario.instance();

}


