import 'package:math_expressions/math_expressions.dart';
import 'dart:math' as math;

class ExpressionParser {
  static String evaluate(String expression, bool isRadians) {
    try {
      // 1. Chuẩn hóa ký hiệu
      String finalExp = expression
          .replaceAll('×', '*')
          .replaceAll('÷', '/')
          .replaceAll('π', math.pi.toString())
          .replaceAll('e', math.e.toString())
          .replaceAll('√', 'sqrt');

      // 2. Tự động xử lý số Hex nếu người dùng nhập A-F mà quên 0x
      finalExp = finalExp.replaceAllMapped(RegExp(r'\b[0-9A-Fa-f]+\b'), (match) {
        String val = match.group(0)!;
        // Nếu chứa chữ cái A-F thì ép kiểu về Hex
        if (RegExp(r'[A-Fa-f]').hasMatch(val)) {
          return int.parse(val, radix: 16).toString();
        }
        return val;
      });

      Parser p = Parser();
      Expression exp = p.parse(finalExp);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);

      if (eval.isInfinite || eval.isNaN) return "Error";
      return eval.truncateToDouble() == eval ? eval.toInt().toString() : eval.toStringAsFixed(6);
    } catch (e) {
      return "Error";
    }
  }

  // Logic cho phép AND/OR (Step 8)
  static String evaluateProgrammer(String expression) {
    try {
      if (expression.contains('AND')) {
        var parts = expression.split('AND');
        int a = _parseHexOrDec(parts[0].trim());
        int b = _parseHexOrDec(parts[1].trim());
        return '0x${(a & b).toRadixString(16).toUpperCase()}';
      }
      return evaluate(expression, false);
    } catch (e) { return "Error"; }
  }

  static int _parseHexOrDec(String s) {
    if (s.contains('0x')) return int.parse(s.replaceAll('0x', ''), radix: 16);
    return int.parse(s, radix: 16); // Ép kiểu Hex cho an toàn
  }
}