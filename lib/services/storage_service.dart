import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/calculation_history.dart';

class StorageService {
  static const String _historyKey = 'calculation_history';

  // Lưu danh sách lịch sử (tối đa 50-100 cái) [cite: 126, 148]
  static Future<void> saveHistory(List<CalculationHistory> history) async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData = jsonEncode(history.map((e) => e.toJson()).toList());
    await prefs.setString(_historyKey, encodedData);
  }

  // Tải lịch sử lên khi mở app [cite: 155]
  static Future<List<CalculationHistory>> loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final String? historyString = prefs.getString(_historyKey);
    if (historyString == null) return [];
    final List<dynamic> decodedData = jsonDecode(historyString);
    return decodedData.map((e) => CalculationHistory.fromJson(e)).toList();
  }
}