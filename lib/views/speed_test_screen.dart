import 'package:flutter/material.dart';
import '../services/network_service.dart';

class SpeedTestScreen extends StatefulWidget {
  const SpeedTestScreen({Key? key}) : super(key: key);

  @override
  State<SpeedTestScreen> createState() => _SpeedTestScreenState();
}

class _SpeedTestScreenState extends State<SpeedTestScreen> {
  final NetworkService _networkService = NetworkService();
  bool _isTesting = false;
  double _downloadSpeed = 0.0;
  int _ping = 0;
  double _progress = 0.0;
  String _statusMessage = "اضغط على بدء الاختبار للقياس";

  Future<void> _startTest() async {
    setState(() {
      _isTesting = true;
      _downloadSpeed = 0.0;
      _ping = 0;
      _progress = 0.0;
      _statusMessage = "جاري قياس زمن الاستجابة (Ping)...";
    });

    int pingResult = await _networkService.measurePing();
    setState(() {
      _ping = pingResult;
      _statusMessage = "جاري قياس سرعة التنزيل الـ التقديرية...";
    });

    double speedResult = await _networkService.measureDownloadSpeed((progress) {
      setState(() {
        _progress = progress;
      });
    });

    setState(() {
      _downloadSpeed = speedResult;
      _isTesting = false;
      _statusMessage = "اكتمل الاختبار بنجاح!";
    });

    await _networkService.saveResult(TestResult(
      timestamp: DateTime.now(),
      downloadSpeedMbps: speedResult,
      latencyMs: pingResult,
      connectionType: "Mobile/Wi-Fi",
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('اختبار سرعة الشبكة'),
          backgroundColor: Colors.blue.shade900,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      const Text('زمن الاستجابة (Ping)', style: TextStyle(fontSize: 16, color: Colors.grey)),
                      Text('$_ping ms', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.teal)),
                      const SizedBox(height: 20),
                      const Text('سرعة التنزيل (Download)', style: TextStyle(fontSize: 16, color: Colors.grey)),
                      Text('$_downloadSpeed Mbps', style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.blue)),
                      if (_isTesting) ...[
                        const SizedBox(height: 16),
                        LinearProgressIndicator(value: _progress > 0 ? _progress : null),
                      ]
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Text(_statusMessage, textAlign: TextAlign.center, style: const TextStyle(fontSize: 14)),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade800,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: _isTesting ? null : _startTest,
                icon: const Icon(Icons.play_arrow, color: Colors.white),
                label: Text(_isTesting ? 'جاري الاختبار...' : 'بدء الاختبار الآن', style: const TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
