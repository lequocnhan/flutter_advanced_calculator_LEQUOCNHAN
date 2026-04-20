import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/calculator_provider.dart';
import '../widgets/calculator_button.dart';
import '../models/calculator_mode.dart';

class CalculatorScreen extends StatelessWidget {
  const CalculatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final calc = Provider.of<CalculatorProvider>(context);

    // Danh sách nút theo đúng Step 8
    final List<String> basicButtons = [
      'C', 'CE', '%', '÷', '7', '8', '9', '×', '4', '5', '6', '-', '1', '2', '3', '+', '±', '0', '.', '='
    ];

    final List<String> sciButtons = [
      '(', ')', 'sin', 'cos', 'tan', '÷',
      'π', '√', 'log', 'ln', '^', '×',
      '7', '8', '9', 'C', 'CE', '-',
      '4', '5', '6', '1', '2', '3', '+',
      'M+', 'MC', '0', '.', 'e', '='
    ];

    final List<String> progButtons = [
      'HEX', 'DEC', 'AND', 'OR', 'XOR', 'NOT',
      'A', 'B', 'C', 'D', 'E', 'F',
      '7', '8', '9', '(', ')', '÷',
      '4', '5', '6', 'C', 'CE', '×',
      '1', '2', '3', '0', '.', '-',
      '0x', '<<', '>>', 'BIN', '+', '=' // Đã thêm dấu = để bạn dễ test Step 8
    ];

    int crossCount = calc.mode == CalculatorMode.basic ? 4 : 6;
    List<String> buttons = calc.mode == CalculatorMode.basic 
        ? basicButtons : (calc.mode == CalculatorMode.scientific ? sciButtons : progButtons);

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: DropdownButton<CalculatorMode>(
          value: calc.mode,
          onChanged: (m) => calc.toggleMode(m!),
          items: CalculatorMode.values.map((e) => DropdownMenuItem(value: e, child: Text(e.name.toUpperCase()))).toList(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: GestureDetector(
              onHorizontalDragEnd: (d) => { if (d.primaryVelocity! > 0) calc.clearEntry() },
              child: Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(color: const Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(24)),
                alignment: Alignment.bottomRight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(calc.expression, style: const TextStyle(fontSize: 22, color: Colors.white70)),
                    Text(calc.result, style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white)),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossCount,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                itemCount: buttons.length,
                itemBuilder: (context, i) {
                  return CalculatorButton(
                    text: buttons[i],
                    color: buttons[i] == '=' ? const Color(0xFF4ECDC4) : null,
                    onPressed: () {
                      String btn = buttons[i];
                      if (btn == 'C') calc.clear();
                      else if (btn == 'CE') calc.clearEntry();
                      else if (btn == '=') calc.calculate();
                      else if (btn == 'M+') calc.memoryAdd();
                      else if (btn == 'MC') calc.memoryClear();
                      else calc.addToExpression(btn);
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}