import 'package:flutter/material.dart';
import '../utils/expression_parser.dart';
import '../models/calculator_mode.dart';

class CalculatorProvider extends ChangeNotifier {
  String _expression = '';
  String _result = '0';
  CalculatorMode _mode = CalculatorMode.basic;
  double _memory = 0; // Biến lưu trữ bộ nhớ M+

  String get expression => _expression;
  String get result => _result;
  CalculatorMode get mode => _mode;

  void addToExpression(String value) {
    if (['HEX', 'DEC', 'BIN', 'OCT'].contains(value)) return;
    _expression += value;
    notifyListeners();
  }

  void toggleMode(CalculatorMode newMode) {
    _mode = newMode;
    notifyListeners();
  }

  void calculate() {
    if (_expression.isEmpty) return;
    if (_mode == CalculatorMode.programmer) {
      _result = ExpressionParser.evaluateProgrammer(_expression);
    } else {
      _result = ExpressionParser.evaluate(_expression, false);
    }
    notifyListeners();
  }

  void clear() {
    _expression = '';
    _result = '0';
    notifyListeners();
  }

  void clearEntry() {
    if (_expression.isNotEmpty) {
      _expression = _expression.substring(0, _expression.length - 1);
      notifyListeners();
    }
  }

  // --- CÁC HÀM MEMORY ĐANG BỊ THIẾU ĐÂY NÈ ---
  
  void memoryAdd() {
    // Lấy kết quả hiện tại cộng dồn vào bộ nhớ
    double currentResult = double.tryParse(_result) ?? 0;
    _memory += currentResult;
    notifyListeners();
  }

  void memoryClear() {
    // Xóa sạch bộ nhớ về 0
    _memory = 0;
    notifyListeners();
  }

  void memoryRecall() {
    // Gọi giá trị trong bộ nhớ ra màn hình (nếu bạn có nút MR)
    _expression += _memory.toString();
    notifyListeners();
  }
}