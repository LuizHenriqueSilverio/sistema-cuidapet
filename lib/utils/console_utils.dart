import 'dart:io';

class ConsoleUtils {

  static String lerString(String mensagem) {
    String? input;
    do {
      stdout.write(mensagem);
      input = stdin.readLineSync();
      if (input == null || input.trim().isEmpty) {
        print(' Entrada inválida. Por favor, digite um valor.');
      }
    } while (input == null || input.trim().isEmpty);
    return input.trim();
  }

  static int lerInt({required String mensagem, int? min, int? max}) {
    int? valor;
    do {
      String input = lerString(mensagem);
      try {
        valor = int.parse(input);
        if (min != null && valor < min) {
          print(' Valor inválido. O número deve ser no mínimo $min.');
          valor = null;
        }
        if (max != null && valor > max) {
          print(' Valor inválido. O número deve ser no máximo $max.');
          valor = null;
        }
      } catch (e) {
        print(' Entrada inválida. Por favor, digite um número inteiro.');
      }
    } while (valor == null);
    return valor;
  }

  static double lerDouble(String mensagem) {
    double? valor;
    do {
      String input = lerString(mensagem);
      try {
        valor = double.parse(input.replaceAll(',', '.'));
        if (valor < 0) {
          print(' O valor não pode ser negativo.');
          valor = null;
        }
      } catch (e) {
        print(' Entrada inválida. Por favor, digite um valor numérico.');
      }
    } while (valor == null);
    return valor;
  }
}