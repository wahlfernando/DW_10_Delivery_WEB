import 'package:flutter/services.dart';


extension FormatterExtensions on double{
  String get currencyPTBR{
    return UtilBrasilFields.obterReal(this);
  }
}


class UtilBrasilFields {
  static String removeCaracteres(String valor) {
    assert(valor.isNotEmpty);
    return valor.replaceAll(RegExp('[^0-9a-zA-Z]+'), '');
  }

  static String removerSimboloMoeda(String valor) {
    assert(valor.isNotEmpty);
    return valor.replaceAll('R\$ ', '');
  }

  static double converterMoedaParaDouble(String valor) {
    assert(valor.isNotEmpty);
    final value = double.tryParse(
      valor.replaceAll('R\$ ', '').replaceAll('.', '').replaceAll(',', '.'),
    );

    return value ?? 0;
  }

  static String obterCep(String cep, {bool ponto = true}) {
    assert(
      cep.length == 8,
      'CEP com tamanho inválido. Deve conter 8 caracteres',
    );

    return ponto
        ? '${cep.substring(0, 2)}.${cep.substring(2, 5)}-${cep.substring(5, 8)}'
        : '${cep.substring(0, 2)}${cep.substring(2, 5)}-${cep.substring(5, 8)}';
  }

  static String obterTelefone(
    String telefone, {
    bool ddd = true,
    bool mascara = true,
  }) {
    assert(
      (telefone.length <= 15),
      'Telefone com tamanho inválido. Deve conter 10 ou 11 caracteres',
    );
    if (!mascara) return UtilBrasilFields.removeCaracteres(telefone);

    if (ddd) {
      assert(
        (telefone.length == 10 || telefone.length == 11),
        'Telefone com tamanho inválido. Deve conter 10 ou 11 caracteres',
      );

      return telefone.length == 10
          ? '(${telefone.substring(0, 2)}) ${telefone.substring(2, 6)}-${telefone.substring(6, 10)}'
          : '(${telefone.substring(0, 2)}) ${telefone.substring(2, 7)}-${telefone.substring(7, 11)}';
    } else {
      assert((telefone.length == 8 || telefone.length == 9),
          'Telefone com tamanho inválido. Deve conter 8 ou 9 caracteres');

      return (telefone.length == 8)
          ? '${telefone.substring(0, 4)}-${telefone.substring(4, 8)}'
          : '${telefone.substring(0, 5)}-${telefone.substring(5, 9)}';
    }
  }

  static String obterDDD(String telefone) {
    assert((telefone.length == 14 || telefone.length == 15),
        'Telefone com tamanho inválido. Deve conter 14 ou 15 caracteres');

    return telefone.substring(1, 3);
  }

  static String obterReal(double value, {bool moeda = true, int decimal = 2}) {
    bool isNegative = false;

    if (value.isNegative) {
      isNegative = true;
      value = value * (-1);
    }

    String fixed = value.toStringAsFixed(decimal);
    List<String> separatedValues = fixed.split(".");

    separatedValues[0] = adicionarSeparador(separatedValues[0]);
    String formatted = separatedValues.join(",");

    if (isNegative) {
      formatted = "-$formatted";
    }

    if (moeda) {
      return r"R$ " + formatted;
    } else {
      return formatted;
    }
  }

  static String obterKM(int km) {
    assert(
        km <= 999999, 'KM informado inválido. Valor máximo permitido é 999999');
    final kmString = km.toString();
    switch (kmString.length) {
      case 4:
        return "${kmString[0]}.${kmString[1]}${kmString[2]}${kmString[3]}";
      case 5:
        return "${kmString[0]}${kmString[1]}.${kmString[2]}${kmString[3]}${kmString[4]}";
      case 6:
        return "${kmString[0]}${kmString[1]}${kmString[2]}.${kmString[3]}${kmString[4]}${kmString[5]}";
      default:
        return km.toString();
    }
  }
}

String adicionarSeparador(String texto) {
  var valorFinal = "";
  var pointCount = 0;
  for (var i = texto.length - 1; i > -1; i--) {
    if (pointCount == 3) {
      valorFinal = ".$valorFinal";
      pointCount = 0;
    }
    pointCount = pointCount + 1;
    valorFinal = texto[i] + valorFinal;
  }

  return valorFinal;
}

class CentavosInputFormatter extends TextInputFormatter {
  CentavosInputFormatter({this.moeda = false, this.casasDecimais = 2})
      : assert(casasDecimais == 2 || casasDecimais == 3,
            'Quantidade de casas decimais deve ser 2 ou 3. Informado: $casasDecimais');

  final bool moeda;
  final int casasDecimais;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final newValueLength = newValue.text.length;

    if (newValueLength > 12) {
      return oldValue;
    }

    if (newValueLength == 0) {
      return newValue;
    }

    const simbolo = 'R\$ ';
    final newText = StringBuffer();
    var centsValue = "";
    var valorFinal = newValue.text;
    var numero = int.parse(newValue.text);

    var textValue = newValue.text.padLeft(
        newValue.text.length == 1 ? casasDecimais + 1 : casasDecimais, "");
    if (textValue.length >= casasDecimais) {
      centsValue = textValue.substring(
          textValue.length - casasDecimais, textValue.length);
      valorFinal = textValue.substring(0, textValue.length - casasDecimais);
    }

    if (numero == 0 && int.tryParse(centsValue) == 0) {
      return const TextEditingValue(
        text: "",
        selection: TextSelection.collapsed(offset: 0),
      );
    }

    if (textValue.length == casasDecimais) {
      valorFinal = "0,$centsValue";
      if (moeda) {
        valorFinal = simbolo + valorFinal;
      }
      newText.write(valorFinal);

      return TextEditingValue(
        text: newText.toString(),
        selection: TextSelection.collapsed(offset: newText.length),
      );
    }

    if (numero > 0 && numero <= 9) {
      if (casasDecimais == 3) {
        centsValue = "00$numero";
      } else {
        centsValue = "0$numero";
      }

      numero = 0;
    } else if (numero >= 10 && numero < 100) {
      if (casasDecimais == 3) {
        centsValue = "0$numero";
      } else {
        centsValue = numero.toString();
      }

      numero = 0;
    } else if (valorFinal.isNotEmpty) {
      numero = int.parse(valorFinal);
    }


    if (numero > 999) {
      valorFinal = "${adicionarSeparador(numero.toString())},$centsValue";
    } else {
      valorFinal = "$numero,$centsValue";
    }

    if (moeda) {
      valorFinal = simbolo + valorFinal;
    }
    newText.write(valorFinal);

    return TextEditingValue(
      text: newText.toString(),
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}