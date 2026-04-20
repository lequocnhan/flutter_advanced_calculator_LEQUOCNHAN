import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/calculator_provider.dart';
import 'screens/calculator_screen.dart';

void main() {
  runApp(MultiProvider(
    providers: [ChangeNotifierProvider(create: (_) => CalculatorProvider())],
    child: const MaterialApp(home: CalculatorScreen(), debugShowCheckedModeBanner: false),
  ));
}