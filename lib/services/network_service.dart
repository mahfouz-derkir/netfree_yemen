import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TestResult {
  final DateTime timestamp;
  final double downloadSpeedMbps;
  final int latencyMs;
  final String connectionType;

  TestResult({
    required this.timestamp,
    required this.downloadSpeedMbps,
    required this.latencyMs,
    required this.connectionType,
  });

  Map<String, dynamic> toJson() => {
    'timestamp': timestamp.toIso8601String(),
    'speed': downloadSpeedMbps,
    'latency': latencyMs,
    'type': connectionType,
  };

  factory TestResult.fromJson(Map<String, dynamic> json) => TestResult(
    timestamp: DateTime.parse(json['timestamp']),
    downloadSpeedMbps: json['speed'].toDouble(),
    latencyMs: json['latency'],
    connectionType: json['type'],
  );
}

class NetworkService {
  Future<int> measurePing() async {
    final stopwatch = Stopwatch()..start();
    try {
      final response = await http.get(Uri.parse('https://www.google.com/generate_204'))
          .timeout(const Duration(seconds: 5));
      stopwatch.stop();
      if (response.statusCode == 204 || response.statusCode == 200) {
        return stopwatch.elapsedMilliseconds;
      }
      return -1;
    } catch (_) {
      return -1;
    }
  }

  Future<double> measureDownloadSpeed(Function(double progress) onProgress) async {
    const String testUrl = 'https://proof.ovh.net/files/1Mb.dat';
    final stopwatch = Stopwatch();
    int bytesReceived = 0;

    try {
      final request = http.Request('GET', Uri.parse(testUrl));
      final response = await http.Client().send(request).timeout(const Duration(seconds: 15));
      
      final contentLength = response.contentLength ?? 1048576;
      stopwatch.start();

      await for (var chunk in response.stream) {
        bytesReceived += chunk.length;
        onProgress(bytesReceived / contentLength);
      }
      stopwatch.stop();

      double seconds = stopwatch.elapsedMilliseconds / 1000.0;
      if (seconds == 0) return 0.0;

      double speedMbps = (bytesReceived * 8) / (seconds * 1000000);
      return double.parse(speedMbps.toStringAsFixed(2));
    } catch (e) {
      return 0.0;
    }
  }

  Future<void> saveResult(TestResult result) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> history = prefs.getStringList('speed_history') ?? [];
    history.add(jsonEncode(result.toJson()));
    await prefs.setStringList('speed_history', history);
  }

  Future<List<TestResult>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> history = prefs.getStringList('speed_history') ?? [];
    return history
        .map((e) => TestResult.fromJson(jsonDecode(e)))
        .toList()
        .reversed
        .toList();
  }
}
