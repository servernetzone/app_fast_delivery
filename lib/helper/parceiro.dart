
class Parceiro {

 final int id;
 final String nome;
 final String razaoSocial;
 final String imagemLogo;
 final String imagemBackground;
 final bool situacao;
 final String estimativaEntrega;
 final String valoresEntrega;
 final String seguimento;
 final String descricao;
 final String abertura;
 final String fechamento;
 final bool isCartao;
 final double classificacao;
 final double porcentagemCartao;
 bool permitirRetirarEstabelecimento;
 String url;
 
 Parceiro(this.id, this.nome, this.razaoSocial, this.imagemLogo, this.imagemBackground,
     this.situacao, this.estimativaEntrega, this.valoresEntrega, this.seguimento, this.descricao
     ,this.abertura, this.fechamento, this.isCartao, this.classificacao, this.porcentagemCartao, this.permitirRetirarEstabelecimento, this.url);
// );
}
