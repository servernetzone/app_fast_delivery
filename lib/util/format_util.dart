abstract class FormatUtil {

  static String doubleToPrice(double value) {
    return value.toStringAsFixed(2).replaceAll('.', ',');
  }

  static String doubleToString(double value) {
    return value.toString();
  }

  static String doubleToStringOne(double value) {
    return value.toStringAsFixed(1);
  }

  static String doubleToStringTwo(double value) {
    return value.toStringAsFixed(1);
  }

  static String doubleToStringTwoReplaced(double value) {
    return value.toStringAsFixed(1).replaceAll('.', ',');
  }


  static double fixedValueDouble(double value) {
    return double.parse(value.toStringAsFixed(2));
  }

  static double stringToDouble(String value) {
    return double.parse(value);
  }

  static String adicionaMascaraDinheiro(String valor) {
    return "R\$ " + valor.replaceAll(".", ",");
  }

  static String adicionaMascaraProcentagem(double value, {int decimal}) {
    return "${value.toStringAsFixed(decimal ?? 2).replaceAll('.', ',')}%";
  }

  static String removeAcentos(String texto) {
    String comAcentos = "ÄÅÁÂÀÃäáâàãÉÊËÈéêëèÍÎÏÌíîïìÖÓÔÒÕöóôòõÜÚÛüúûùÇç";
    String semAcentos = "AAAAAAaaaaaEEEEeeeeIIIIiiiiOOOOOoooooUUUuuuuCc";

    for (int i = 0; i < comAcentos.length; i++) {
      texto = texto.replaceAll(comAcentos[i], semAcentos[i]);
    }
    return texto;
  }
}